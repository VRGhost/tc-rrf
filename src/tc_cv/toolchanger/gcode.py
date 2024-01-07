"""GCode snippets"""

import contextlib

from .. import typ


class GCode:
    def __init__(self, duet_api):
        self.duet_api = duet_api

    def send(self, code: str):
        return self.duet_api.send_code(code)

    def abs_move(self, p: typ.Point, feed: float = 45.0):
        assert p.x >= 0 and p.x <= 300
        assert p.y >= 0 and p.y <= 200
        self.send(
            f"""
                G0 X{p.x} Y{p.y} F{feed}
                M400
                G0 F99999
            """
        )

    def max_speed(self):
        self.send("G0 F99999999")

    @contextlib.contextmanager
    def tmp_settings(self):
        self.send("M120")  # save settings
        try:
            yield
        finally:
            self.send("M121")

    @contextlib.contextmanager
    def restore_pos(self, feed: float | int | None = None) -> typ.Point:
        assert isinstance(feed, float | int | None), type(feed)
        coords = self.duet_api.get_coords()
        if feed:
            str_feed = f"F{feed}"
        else:
            str_feed = ""
        try:
            yield typ.Point(x=coords["X"], y=coords["Y"])
        finally:
            self.send(
                f"G0 X{coords['X']} Y{coords['Y']} Z{coords['Z']} {str_feed}".strip()
            )
            if str_feed:
                self.max_speed()

    def rel_move(
        self,
        dx: float = 0.0,
        dy: float = 0.0,
        dz: float = 0.0,
        feed: float = 55.0,
    ):
        self.send(
            f"""
                G91
                G1 X{dx} Y{dy} Z{dz} F{feed}
                G90
                M400
            """
        )
        self.max_speed()
