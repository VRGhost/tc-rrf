from .. import typ
from . import gcode


class Toolchanger:
    gcode: gcode.GCode

    def __init__(self, duet_api):
        self.duet_api = duet_api
        self.gcode = gcode.GCode(duet_api)

    def get_printer_coords(self) -> typ.Point:
        api_coords = self.duet_api.get_coords()
        return typ.Point(x=api_coords["X"], y=api_coords["Y"])
