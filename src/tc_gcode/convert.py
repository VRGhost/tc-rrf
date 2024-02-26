import dataclasses
import typing

import rrf_gcode_parser

import tc_gcode


@dataclasses.dataclass(kw_only=True, frozen=True)
class TcState:
    lineno: int
    cur_tool: int | None
    prev_tool: int | None
    all_future_tools: frozenset[int]
    preheat_tools: frozenset[int]


class ToolStates:
    toolchanges: dict[int, int]  # line -> tool id
    duration_model: "tc_gcode.duration.PrintDurationModel"
    preheat_time: float
    last_tc_state: TcState
    NO_NEW_TOOL = object()

    def __init__(
        self,
        toolchanges: list["tc_gcode.toolchanges.Toolchange"],
        duration_model: "tc_gcode.duration.PrintDurationModel",
        preheat_time: float,
    ):
        self.toolchanges = {
            tc.lineno: tc.new_tool for tc in self.normalise_toolchanges(toolchanges)
        }
        for key, tool_id in self.toolchanges.items():
            # -1 (disengaged tool) is no tool for purposes of this simulation
            if tool_id < 0:
                self.toolchanges[key] = None
        self.duration_model = duration_model
        self.preheat_time = preheat_time
        self.last_tc_state = TcState(
            lineno=-1,
            cur_tool=None,
            prev_tool=None,
            all_future_tools={el.new_tool for el in toolchanges if el.new_tool >= 0},
            preheat_tools=set(),
        )

    def normalise_toolchanges(
        self,
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

    def get(self, lineno: int) -> TcState:
        assert lineno - self.last_tc_state.lineno in (
            0,
            1,
        ), f"either same or prev line: {self.last_tc_state}, {lineno=}"
        if lineno == self.last_tc_state.lineno:
            return self.last_tc_state

        assert lineno == self.last_tc_state.lineno + 1

        prev_tool = self.last_tc_state.prev_tool
        cur_tool = self.last_tc_state.cur_tool
        new_tool = self.toolchanges.get(lineno, self.NO_NEW_TOOL)
        if new_tool is not self.NO_NEW_TOOL:
            prev_tool = cur_tool
            cur_tool = new_tool
        future_tc = {
            tc_lineno: tool_id
            for (tc_lineno, tool_id) in self.toolchanges.items()
            if tc_lineno > lineno
        }
        next_tc_times = {}  # tool id -> tc TIME
        for future_line, future_tool in future_tc.items():
            if (future_tool is not None) and future_tool not in next_tc_times:
                next_tc_times[future_tool] = self.duration_model.get_time(future_line)

        cur_time = self.duration_model.get_time(lineno)
        should_be_preheating = frozenset(
            tool_id
            for (tool_id, tool_time) in next_tc_times.items()
            if ((tool_time - cur_time) <= self.preheat_time) and (tool_id != cur_tool)
        )

        future_tools = frozenset(val for val in future_tc.values() if val is not None)
        if (cur_tool is not None) and (cur_tool < 0):
            cur_tool = None
        self.last_tc_state = TcState(
            lineno=lineno,
            cur_tool=cur_tool,
            prev_tool=prev_tool,
            all_future_tools=future_tools,
            preheat_tools=should_be_preheating,
        )
        return self.last_tc_state


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
    tool_states = ToolStates(tc, duration_model, preheat_time)
    for cmd in input():
        tool_state = tool_states.get(cmd.lineno)
        is_m116 = isinstance(cmd, rrf_gcode_parser.gcode_commands.M116)
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

        if isinstance(cmd, rrf_gcode_parser.gcode_commands.G10Temperature):
            yield f";; {cmd.to_gcode().strip()} ; gc-gcode - line removed"
        elif is_m116:
            if tool_state.cur_tool is None:
                yield f";; {cmd.to_gcode().strip()} ; gc-gcode :: m116 removed"
            else:
                yield f"M116 P{tool_state.cur_tool} C0 ; gc-gcode :: m116 override"
        else:
            yield cmd.to_gcode().strip()

        if new_disengaged_tools:
            yield from emit_off_commands(new_disengaged_tools)

        preheating_tools = (preheating_tools | new_preheat_tools) - {
            tool_state.cur_tool
        }
        fully_disengaged_tools = fully_disengaged_tools | new_disengaged_tools
