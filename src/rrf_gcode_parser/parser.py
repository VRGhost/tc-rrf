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
    full_line_comment = enum.auto()


@dataclasses.dataclass(kw_only=True, frozen=False)
class ParseState:
    lineno: int = 0
    mode: ParseMode = dataclasses.field(default=ParseMode.start)
    tokens: list[str] = dataclasses.field(default_factory=list)
    command: str = dataclasses.field(default="")  # uppercased gcode command


def get_arg_names(state: ParseState) -> frozenset[str]:
    """Quick fetch arg names"""
    args = set()
    command = state.command.upper()
    for el in state.tokens:
        el = el.upper().strip()
        if not el:
            continue  # Skip empty elements
        if el == command:
            continue  # Skip the gcode command
        if el == ";":
            # start of comment
            break
        args.add(el[0])  # Only get arg names - first letter
    return args


def mk_command(
    state: ParseState,
) -> COMMAND:
    # print(f"{state=!r}")
    if state.mode in (ParseMode.start, ParseMode.full_line_comment):
        out = rrf_gcode_parser.gcode.EmptyLine(state.tokens, lineno=state.lineno)
    else:
        assert state.mode == ParseMode.gcode_command_seen
        if state.command.startswith("T"):
            # a toolchange
            cls = rrf_gcode_parser.gcode_commands.TC
        elif state.command == "G10":
            args = get_arg_names(state)
            if not args:
                cls = rrf_gcode_parser.gcode_commands.G10Retract
            elif "P" in args and {"S", "R"}.intersection(args):
                # P and S/R are present
                cls = rrf_gcode_parser.gcode_commands.G10Temperature
            else:
                raise NotImplementedError(state)

        else:
            cls = {
                "M73": rrf_gcode_parser.gcode_commands.M73,
                "M116": rrf_gcode_parser.gcode_commands.M116,
            }.get(state.command, rrf_gcode_parser.gcode.GenericCommand)
        out = cls(state.tokens, lineno=state.lineno)
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
        elif state.mode == ParseMode.full_line_comment or token_val.isspace():
            # Just append to the accumulated
            continue
        elif state.mode == ParseMode.start and token_val == ";":
            state.mode = ParseMode.full_line_comment
        elif (
            state.mode == ParseMode.start
            and rrf_gcode_parser.gcode.GCODE_COMMAND.match(token_val)
        ):
            state.mode = ParseMode.gcode_command_seen
            state.command = token_val.strip().upper()
        elif state.mode in (ParseMode.gcode_command_seen,):
            # Not a space, but we have seen a gcode command - must be an argument
            pass
        else:
            raise NotImplementedError(f"{token=!r} {state}")
    if state.tokens:
        yield mk_command(state)
