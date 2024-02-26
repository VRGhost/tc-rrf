import dataclasses

import rrf_gcode_parser

import tc_gcode.typ


@dataclasses.dataclass(frozen=True, kw_only=True)
class Toolchange:
    new_tool: int
    lineno: int


def get_toolchanges(
    input: tc_gcode.typ.LineReader,
) -> list[Toolchange]:
    toolchanges = []
    for cmd in input():
        if isinstance(cmd, rrf_gcode_parser.gcode_commands.TC):
            toolchanges.append(Toolchange(new_tool=cmd.tool, lineno=cmd.lineno))

    return toolchanges
