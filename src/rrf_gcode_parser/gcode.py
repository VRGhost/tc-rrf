"""Gcode commands"""

import dataclasses
import re
import typing

T = typing.TypeVar("T")
GCODE_ARG_TYPE = typing.Union[str, int, float]
GCODE_COMMAND = re.compile(r"^(?:[GTM]\d+)|T-1$", re.I)


class _G:
    """Base class for all gcode commands"""

    lineno: int
    empty_prefix: list[str]  # any empty lines preceeding the actual content
    raw_tokens: list[str]
    comment: tuple[str]
    eol: str = ""  # will be set to /n if the command includes that

    def __init__(self, tokens: list[str], lineno: int | None):
        self.lineno = lineno
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
        return f"<{self.__class__.__name__} {self.raw_tokens=!r} {self.comment=!r} {self.lineno=}>"


class EmptyLine(_G):
    """"""

    command = None  # To conform to `GenericCommand` api below


@dataclasses.dataclass(slots=True)
class Arg:
    idx: int
    name: str
    orig_val: str
    new_val: str


class Prop(typing.Generic[T]):
    """Bound generic command property"""

    _out_t: typing.Type[T]
    name: str = None

    def __init__(self, out_t: typing.Type[T]):
        self._out_t = out_t

    def _parent_init(self, name: str):
        self.name = name

    def __get__(self, obj: "GenericCommand", objtype=None) -> T | None:
        if obj is None:
            # getattr() called on the class
            return self
        return obj.get(self.name, self._out_t)

    def __set__(self, obj: "GenericCommand", value: T):
        obj.set(self.name, self._out_t, value)

    def __delete__(self, obj: "GenericCommand"):
        obj.set(self.name, self._out_t, None)


class GenericCommand(_G):
    """An unknown gcode command"""

    command: str  # gcode
    args: dict[str, Arg]

    def __init_subclass__(cls) -> None:
        super().__init_subclass__()
        for name in dir(cls):
            val = getattr(cls, name)
            if isinstance(val, Prop):
                val._parent_init(name)

    def __init__(self, tokens: list[str], lineno: int | None):
        super().__init__(tokens, lineno)
        normalised_tokens = [
            (idx, el.strip()) for idx, el in enumerate(self.raw_tokens) if el.strip()
        ]
        self.command = normalised_tokens[0][1].upper()
        assert GCODE_COMMAND.match(self.command)
        self.args = {}
        for idx, el in normalised_tokens[1:]:
            name = el[0].upper()
            val = el[1:]
            arg = Arg(idx=idx, name=name, orig_val=val, new_val=val)
            self.args[arg.name] = arg

    def _get_arg(self, name: str) -> Arg:
        if name not in self.args:
            if self.args:
                last_id = max(el.idx for el in self.args.values())
            else:
                last_id = -1
            self.args[name] = Arg(
                idx=last_id + 1, name=name, orig_val=None, new_val=None
            )
        return self.args[name]

    def get(self, name: str, typ: typing.Type[T] | GCODE_ARG_TYPE) -> T | str | None:
        assert name and name.isupper(), "Gcode args are uppercase letters"
        out = self._get_arg(name).new_val
        if out is None:
            pass
        elif typ == int:
            try:
                out = int(out)
            except ValueError:
                # It is possible to have a non-int arg resolving to an int in
                #  duet (e.g. use of gcode macro variables)
                pass
        elif typ == float:
            try:
                out = float(out)
            except ValueError:
                # Same as with int - can be a stirng/placeholder
                pass
        elif typ == str:
            if out.startswith('"') and out.endswith('"'):
                # A quoted string
                out = out[1:-1].replace('""', '"')
            else:
                # perform no string procesing
                pass
        else:
            raise NotImplementedError(typ)
        return out

    def set(self, name: str, typ: typing.Type[T | GCODE_ARG_TYPE], value):
        assert name and name.isupper()
        assert isinstance(value, typ | None)
        if value is None:
            new_val = None
        elif typ == int:
            new_val = str(value)
        elif typ == float:
            new_val = f"{value:0.10}"
        elif typ == str:
            new_val = '"{}"'.format(str(value).replace('"', '""'))
        else:
            raise NotImplementedError(typ)
        self._get_arg(name).new_val = new_val

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
