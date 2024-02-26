import typing

from .gcode import GenericCommand, Prop


class TC(GenericCommand):
    """Toolchange"""

    @property
    def tool(self) -> int:
        """new tool id"""
        return int(self.command[1:])


class G10Temperature(GenericCommand):
    """G10: Tool Temperature Setting"""

    P = Prop(int)
    R = Prop(int)
    S = Prop(int)


class G10Retract(GenericCommand):
    """G10 retract"""


class M73(GenericCommand):
    """Set remaining print time"""

    P = Prop(int)  # Percentage of the print that has been completed (not used by RRF)
    R = Prop(int)  # Remaining print time in minutes


class M116(GenericCommand):
    """Wait (for temp)"""

    P = Prop(int)
    H = Prop(int)
    C = Prop(int)
    S = Prop(int)


COMMAND = typing.Union[TC, G10Temperature, G10Retract, M73, M116]
