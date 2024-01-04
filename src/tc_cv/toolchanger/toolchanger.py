import datetime

import pydantic

from .. import typ
from . import gcode


class Tool(pydantic.BaseModel):
    name: str
    state: str

    @property
    def active(self) -> bool:
        return self.state == "active"


class State(pydantic.BaseModel):
    currentTool: int
    msUpTime: int
    status: str
    time: datetime.datetime
    upTime: int


class Toolchanger:
    gcode: gcode.GCode

    def __init__(self, duet_api):
        self.duet_api = duet_api
        self.gcode = gcode.GCode(duet_api)

    def get_coords(self) -> typ.Point:
        api_coords = self.duet_api.get_coords()
        return typ.Point(x=api_coords["X"], y=api_coords["Y"])

    def get_tools(self) -> list[Tool]:
        return [Tool(**el) for el in self.duet_api.get_model(key="tools")]

    def get_state(self) -> State:
        return State(**self.duet_api.get_model(key="state"))
