import dataclasses
import typing

import numpy as np

from . import typ

CoordTansformFn = typing.Callable[[typ.Point], typ.Point]


@dataclasses.dataclass(frozen=True, kw_only=True)
class ScreenCoordCapture:
    printerCoords: typ.Point
    screenCoords: typ.Point


class InferCoordTransform:
    move_bases: list[typ.Vector]
    ignored_printer_coord: str

    all_printer_coords = ("x", "y", "z")
    active_printer_coords = property(
        lambda s: tuple(
            el for el in s.all_printer_coords if el != s.ignored_printer_coord
        )
    )

    def __init__(self, move_bases: list[typ.Vector], ignore_coord: str):
        self.move_bases = move_bases
        self.ignored_printer_coord = ignore_coord

    @classmethod
    def xy(cls):
        return cls(
            move_bases=[typ.Vector(1, 0, 0), typ.Vector(0, 1, 0)], ignore_coord="z"
        )

    @classmethod
    def xz(cls):
        return cls(
            move_bases=[typ.Vector(1, 0, 0), typ.Vector(0, 0, 1)], ignore_coord="y"
        )

    def _to_numpy_arr_row(self, printerPoint: typ.Point) -> list[float]:
        return [getattr(printerPoint, axis) for axis in self.active_printer_coords]

    async def infer(
        self,
        capture_coords: typing.Callable[
            [typ.Vector], typing.Awaitable[ScreenCoordCapture]
        ],
        mul: float = 1.0,
    ) -> CoordTansformFn:
        measured_points: list[ScreenCoordCapture] = [
            await capture_coords(typ.Vector(0, 0, 0))
        ]
        for world_move in self.move_bases:
            measured_points.append(await capture_coords(world_move * mul))

        np_screen_coords = np.array(
            [[p.screenCoords.x, p.screenCoords.y] for p in measured_points]
        )

        np_printer_coords = np.array(
            [self._to_numpy_arr_row(p.printerCoords) for p in measured_points]
        )

        ignored_coord_values = [
            getattr(p.printerCoords, self.ignored_printer_coord)
            for p in measured_points
        ]

        A = np.vstack([np_screen_coords.T, np.ones(np_screen_coords.shape[0])]).T
        (solution, res, rank, s) = np.linalg.lstsq(A, np_printer_coords, rcond=None)

        def _get_printer_coords(screen_p: typ.Point):
            assert screen_p.z == 0, "No Z axis on the screen"
            rv = np.dot(np.array([[screen_p.x, screen_p.y, 1.0]]), solution)
            assert rv.shape == (1, 2)
            data = {self.ignored_printer_coord: float(np.average(ignored_coord_values))}
            for axis, value in zip(self.active_printer_coords, rv[0]):
                data[axis] = value
            return typ.Point(**data)

        return _get_printer_coords
