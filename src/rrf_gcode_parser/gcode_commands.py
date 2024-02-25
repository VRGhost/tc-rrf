import typing

from . import gcode

T = typing.TypeVar("T")


class _TypedCommand(gcode.GenericCommand):
    def __init_subclass__(cls) -> None:
        super().__init_subclass__()
        for name in dir(cls):
            val = getattr(cls, name)
            if isinstance(val, Prop):
                val._parent_init(name)

    def _get_arg(self, name: str) -> gcode.Arg:
        if name not in self.args:
            if self.args:
                last_id = max(el.idx for el in self.args.values())
            else:
                last_id = -1
            self.args[name] = gcode.Arg(
                idx=last_id + 1, name=name, orig_val=None, new_val=None
            )
        return self.args[name]

    def get(self, name: str, typ: typing.Type[T]) -> T | str | None:
        out = self._get_arg(name).new_val
        if out is None:
            pass
        elif typ == int:
            out = int(out)
        elif typ == float:
            out = float(out)
        else:
            raise NotImplementedError(typ)
        return out

    def set(self, name: str, typ: typing.Type[T], value):
        assert isinstance(value, typ | None)
        if value is None:
            new_val = None
        elif typ == int:
            new_val = str(value)
        elif typ == float:
            new_val = f"{value:0.4}"
        else:
            raise NotImplementedError(typ)
        self._get_arg(name).new_val = new_val


class Prop(typing.Generic[T]):
    _out_t: typing.Type[T]
    name: str = None

    def __init__(self, out_t: typing.Type[T]):
        self._out_t = out_t

    def _parent_init(self, name: str):
        self.name = name

    def __get__(self, obj: _TypedCommand, objtype=None) -> T | None:
        if obj is None:
            # getattr() called on the class
            return self
        return obj.get(self.name, self._out_t)

    def __set__(self, obj: _TypedCommand, value: T):
        obj.set(self.name, self._out_t, value)

    def __delete__(self, obj: _TypedCommand):
        obj.set(self.name, self._out_t, None)


class M116(_TypedCommand):
    """Wait (for temp)"""

    P = Prop(int)
    H = Prop(int)
    C = Prop(int)
    S = Prop(int)


COMMAND = typing.Union[int, M116]
