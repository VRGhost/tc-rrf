"""Gcode commands"""

import re
import typing

GCODE_COMMAND = re.compile(r"^[GTM]\d+$", re.I)


class _G:
    """Base class for all gcode commands"""

    empty_prefix: list[str]  # any empty lines preceeding the actual content
    raw_tokens: list[str]
    normalised_tokens: list[str]  # uppercase, spaces removed
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
        self.normalised_tokens = [
            el.strip().upper() for el in self.raw_tokens if el.strip()
        ]

    def __repr__(self) -> str:
        return (
            f"<{self.__class__.__name__} {self.normalised_tokens=!r} {self.comment=!r}>"
        )


class EmptyLine(_G):
    """"""


class GenericCommand(_G):
    """An unknown gcode command"""

    command: str  # gcode
    args: list[str]

    def __init__(self, tokens: list[str]):
        super().__init__(tokens)
        assert GCODE_COMMAND.match(self.normalised_tokens[0])
        self.command = self.normalised_tokens[0]
        self.args = self.normalised_tokens[1:]

    def __repr__(self) -> str:
        return (
            f"<{self.__class__.__name__} {self.command=!r} {self.args=} {self.comment}>"
        )


COMMAND = typing.Union[EmptyLine, GenericCommand]
