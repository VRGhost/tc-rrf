import typing

from .gcode import GenericCommand, Prop


class M116(GenericCommand):
    """Wait (for temp)"""

    P = Prop(int)
    H = Prop(int)
    C = Prop(int)
    S = Prop(int)


COMMAND = typing.Union[int, M116]
