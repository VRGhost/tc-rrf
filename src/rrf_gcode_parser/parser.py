import dataclasses
import enum
import typing

import rrf_gcode_parser
import rrf_gcode_parser.gcode as gcode


class ParseMode(enum.Enum):
    start = enum.auto()
    gcode_command_seen = enum.auto()


@dataclasses.dataclass(kw_only=True, frozen=False)
class ParseState:
    mode: ParseMode = dataclasses.field(default=ParseMode.start)
    tokens: list[str] = dataclasses.field(default_factory=list)
    command: str = dataclasses.field(default="")  # uppercased gcode command


def mk_command(state: ParseState) -> gcode.COMMAND:
    # print(f"{state=!r}")
    if state.mode == ParseMode.start:
        out = gcode.EmptyLine(state.tokens)
    else:
        out = gcode.GenericCommand(state.tokens)
    return out


def parse(
    input: typing.IO[str],
) -> typing.Generator["gcode.COMMAND", None, None]:
    state = ParseState()
    for token in rrf_gcode_parser.tokeniser.tokenise(input):
        state.tokens.append(token)
        # print(accumulated)
        if token == "\n":
            yield mk_command(state)
            state = ParseState()  # new parse state
        elif token.isspace():
            # Just append to the accumulated
            continue
        elif gcode.GCODE_COMMAND.match(token):
            if state.mode == ParseMode.start:
                state.mode = ParseMode.gcode_command_seen
                state.command = token.strip().upper()
            else:
                2 / 0
        elif state.mode in (ParseMode.gcode_command_seen,):
            # Not a space, but we have seen a gcode command - must be an argument
            pass
        else:
            raise NotImplementedError(f"{token=!r} {state}")
