import dataclasses
import enum
import typing

import rrf_gcode_parser

COMMAND = typing.Union[
    "rrf_gcode_parser.gcode.COMMAND", "rrf_gcode_parser.gcode_commands.COMMAND"
]


class ParseMode(enum.Enum):
    start = enum.auto()
    gcode_command_seen = enum.auto()


@dataclasses.dataclass(kw_only=True, frozen=False)
class ParseState:
    lineno: int = 0
    mode: ParseMode = dataclasses.field(default=ParseMode.start)
    tokens: list[str] = dataclasses.field(default_factory=list)
    command: str = dataclasses.field(default="")  # uppercased gcode command


def mk_command(
    state: ParseState,
) -> COMMAND:
    # print(f"{state=!r}")
    if state.mode == ParseMode.start:
        out = rrf_gcode_parser.gcode.EmptyLine(state.tokens)
    else:
        cls = {
            "M116": rrf_gcode_parser.gcode_commands.M116,
        }.get(state.command, rrf_gcode_parser.gcode.GenericCommand)
        out = cls(state.tokens)
    return out


def parse(
    input: typing.IO[str],
) -> typing.Generator[COMMAND, None, None]:
    state = ParseState()
    for token in rrf_gcode_parser.tokeniser.tokenise(input):
        state.lineno = token.lineno
        token_val = token.val
        state.tokens.append(token_val)
        # print(accumulated)
        if token_val == "\n":
            yield mk_command(state)
            state = ParseState()  # new parse state
        elif token_val.isspace():
            # Just append to the accumulated
            continue
        elif rrf_gcode_parser.gcode.GCODE_COMMAND.match(token_val):
            if state.mode == ParseMode.start:
                state.mode = ParseMode.gcode_command_seen
                state.command = token_val.strip().upper()
            else:
                2 / 0
        elif state.mode in (ParseMode.gcode_command_seen,):
            # Not a space, but we have seen a gcode command - must be an argument
            pass
        else:
            raise NotImplementedError(f"{token=!r} {state}")
    if state.tokens:
        yield mk_command(state)
