import dataclasses
import re

import tc_gcode.typ


@dataclasses.dataclass(frozen=True, kw_only=True)
class Toolchange:
    new_tool: int
    lineno: int


def parse_tc(line: str) -> int | None:
    match = re.match(r"T(-?\d+)", line.split(";")[0].strip(), re.I)
    if match:
        return int(match.group(1))


def get_toolchanges(
    input: tc_gcode.typ.LineReader,
) -> list[Toolchange]:
    toolchanges = []
    for lineno, line in input():
        if (tc := parse_tc(line.strip())) is not None:
            toolchanges.append(Toolchange(new_tool=tc, lineno=lineno))

    return toolchanges
