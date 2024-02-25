"""Gcode commands"""

import dataclasses
import re
import typing

GCODE_COMMAND = re.compile(r"^[GTM]\d+$", re.I)


class _G:
    """Base class for all gcode commands"""

    empty_prefix: list[str]  # any empty lines preceeding the actual content
    raw_tokens: list[str]
    comment: tuple[str]
    eol: str = ""  # will be set to /n if the command includes that

    def __init__(self, tokens: list[str]):
        tokens = list(tokens)
        if tokens and ("\n" in tokens[-1]):
            self.eol = tokens.pop(-1)
        # detect comments
        try:
            comma_pos = tokens.index(";")
        except ValueError:
            # no commas
            self.comment = []
        else:
            self.comment = tokens[comma_pos:]
            tokens = tokens[:comma_pos]
        self.empty_prefix = []
        while tokens and tokens[0].isspace():
            self.empty_prefix.append(tokens.pop(0))
        self.raw_tokens = tokens

    def to_gcode(self) -> str:
        return "".join(self.empty_prefix + self.raw_tokens + self.comment) + self.eol

    def __repr__(self) -> str:
        return f"<{self.__class__.__name__} {self.raw_tokens=!r} {self.comment=!r}>"


class EmptyLine(_G):
    """"""


@dataclasses.dataclass(slots=True)
class Arg:
    idx: int
    name: str
    orig_val: str
    new_val: str


class GenericCommand(_G):
    """An unknown gcode command"""

    command: str  # gcode
    args: dict[str, Arg]

    def __init__(self, tokens: list[str]):
        super().__init__(tokens)
        normalised_tokens = [
            (idx, el.strip().upper())
            for idx, el in enumerate(self.raw_tokens)
            if el.strip()
        ]
        assert GCODE_COMMAND.match(normalised_tokens[0][1])
        self.command = normalised_tokens[0][1]
        self.args = {}
        for idx, el in normalised_tokens[1:]:
            arg = Arg(idx=idx, name=el[0], orig_val=el[1:], new_val=el[1:])
            self.args[arg.name] = arg

    def to_gcode(self) -> str:
        parts = [*self.empty_prefix, self.command, " "]
        for arg in self.args.values():
            if arg.new_val is not None:
                parts.append(f"{arg.name}{arg.new_val}")
                parts.append(" ")
        if self.comment:
            parts.extend(self.comment)
        else:
            parts.pop(-1)  # remove last space

        return "".join(parts) + self.eol

    def __repr__(self) -> str:
        return (
            f"<{self.__class__.__name__} {self.command=!r} {self.args=} {self.comment}>"
        )


COMMAND = typing.Union[EmptyLine, GenericCommand]
