import dataclasses
import itertools
import re
import typing

import tc_gcode

SKIP_GCODE = re.compile(
    R"""
        (G10 \s+ S\d+ \s+ P\d+)
    """,
    re.VERBOSE | re.IGNORECASE,
)


@dataclasses.dataclass(kw_only=True, frozen=True)
class TcState:
    lineno: int
    cur_tool: int | None
    prev_tool: int | None
    all_future_tools: frozenset[int]
    preheat_tools: frozenset[int]


def normalise_toolchanges(
    toolchanges: list["tc_gcode.toolchanges.Toolchange"],
) -> tuple["tc_gcode.toolchanges.Toolchange"]:
    """Normalise toolchange sequence:

    - Order by line number
    - deduplicate any TCs for the matching tool
    """
    out = []
    last_tool = -999
    for tc in sorted(toolchanges, key=lambda el: el.lineno):
        if tc.new_tool != last_tool:
            out.append(tc)
            last_tool = tc.new_tool
    return tuple(out)


def iter_tool_states(
    toolchanges: list["tc_gcode.toolchanges.Toolchange"],
    duration_model: "tc_gcode.duration.PrintDurationModel",
    preheat_time: float,
) -> typing.Generator[TcState, None, None]:
    tool_changes = {tc.lineno: tc.new_tool for tc in normalise_toolchanges(toolchanges)}
    for key, value in tool_changes.items():
        # -1 (disengaged tool) is no tool for purposes of this simulation
        if value < 0:
            tool_changes[key] = None

    NO_NEW_TOOL = object()
    cur_tool = prev_tool = None
    for lineno in itertools.count():
        new_tool = tool_changes.pop(lineno, NO_NEW_TOOL)
        if new_tool is not NO_NEW_TOOL:
            prev_tool = cur_tool
            cur_tool = new_tool
        next_tc_times = {}  # tool id -> tc TIME
        for future_line, future_tool in tool_changes.items():
            if (future_tool is not None) and future_tool not in next_tc_times:
                next_tc_times[future_tool] = duration_model.get_time(future_line)

        cur_time = duration_model.get_time(lineno)
        should_be_preheating = frozenset(
            tool_id
            for (tool_id, tool_time) in next_tc_times.items()
            if ((tool_time - cur_time) <= preheat_time) and (tool_id != cur_tool)
        )

        future_tools = frozenset(
            val for val in tool_changes.values() if val is not None
        )
        if (cur_tool is not None) and (cur_tool < 0):
            cur_tool = None
        yield TcState(
            lineno=lineno,
            cur_tool=cur_tool,
            prev_tool=prev_tool,
            all_future_tools=future_tools,
            preheat_tools=should_be_preheating,
        )


def emit_off_commands(
    tools: typing.Iterable[int],
) -> typing.Generator[str, None, None]:
    for tool_id in sorted(tools):
        yield f"M568 P{tool_id} A0 ; tc_gcode:: Switch tool {tool_id} to OFF"


def emit_preheat_commands(
    tools: typing.Iterable[int],
) -> typing.Generator[str, None, None]:
    for tool_id in sorted(tools):
        yield f"M568 P{tool_id} A2 ; tc_gcode:: Switch tool {tool_id} to active temp"


def convert(
    input: "tc_gcode.typ.LineReader",
    tc: list["tc_gcode.toolchanges.Toolchange"],
    duration_model: "tc_gcode.duration.PrintDurationModel",
    preheat_time: float,
) -> typing.Iterable[str]:
    """Convert the original gcode to a pre-processed one"""
    print_active = False  # Skips preamble gibberish
    all_tools = frozenset(el.new_tool for el in tc if el.new_tool >= 0)
    fully_disengaged_tools = set()
    preheating_tools = set()
    for (lineno, line), tool_state in zip(
        input(), iter_tool_states(tc, duration_model, preheat_time)
    ):
        assert tool_state.lineno == lineno
        is_m116 = line.startswith("M116 ") or (line == "M116")
        if tool_state.cur_tool is not None or is_m116:
            print_active = True

        if print_active:
            new_preheat_tools = (
                tool_state.preheat_tools - preheating_tools - {tool_state.cur_tool}
            )
        else:
            new_preheat_tools = set()

        new_disengaged_tools = (
            (all_tools - tool_state.all_future_tools)
            - fully_disengaged_tools
            - {tool_state.cur_tool}
        )

        if new_preheat_tools:
            yield from emit_preheat_commands(new_preheat_tools)

        if SKIP_GCODE.match(line):
            yield f";; {line.strip()} ; gc-gcode - line removed"
        elif is_m116:
            if tool_state.cur_tool is None:
                yield f";; {line.strip()} ; gc-gcode :: m116 removed"
            else:
                yield f"M116 P{tool_state.cur_tool} C0 ; gc-gcode :: m116 override"
        else:
            yield line.strip()

        if new_disengaged_tools:
            yield from emit_off_commands(new_disengaged_tools)

        preheating_tools = (preheating_tools | new_preheat_tools) - {
            tool_state.cur_tool
        }
        fully_disengaged_tools = fully_disengaged_tools | new_disengaged_tools
