import dataclasses
import re

import tc_gcode.typ


@dataclasses.dataclass(frozen=True, kw_only=True)
class ProjectTC:
    new_tool: int
    time: float
    lineno: int


class ProjectToolchanges:
    toolchanges: list[ProjectTC]

    def __init__(self) -> None:
        self.toolchanges = []

    def add(self, tc: ProjectTC):
        self.toolchanges.append(tc)
        self.toolchanges.sort(key=lambda el: el.lineno)

    def get_cur_tc(self, lineno: int) -> ProjectTC|None:
        pred_toolchanges = [el for el in self.toolchanges if el.lineno <= lineno]
        if not pred_toolchanges:
            return None
        last_tc = max(pred_toolchanges, key=lambda el: el.lineno)
        return last_tc

    def get_current_tool(self, lineno: int) -> int|None:
        tc = self.get_cur_tc(lineno)
        if tc is not None:
            return tc.new_tool
        
    def get_tools_no_longer_used(self, lineno: int) -> set[int]:
        cur_tools = {el.new_tool for el in self.toolchanges if el.lineno <= lineno}
        future_tools = {el.new_tool for el in self.toolchanges if el.lineno > lineno}
        return cur_tools - future_tools

    def get_tool_used_at(self, time: float) -> int|None:
        past_tcs = [el for el in self.toolchanges if el.time <= time]
        if past_tcs:
            return max(past_tcs, key=lambda el: el.time).new_tool

def parse_tc(line: str) -> int | None:
    match = re.match(r"T(-?\d+)", line.split(";")[0].strip(), re.I)
    if match:
        return int(match.group(1))


def get_toolchanges(
    input: tc_gcode.typ.LineReader, time_fn: tc_gcode.typ.LineToTimeFn
) -> ProjectToolchanges:
    toolchanges = ProjectToolchanges()
    for lineno, line in input():
        if (tc := parse_tc(line.strip())) is not None:
            toolchanges.add(ProjectTC(new_tool=tc, time=time_fn(lineno), lineno=lineno))

    return toolchanges
