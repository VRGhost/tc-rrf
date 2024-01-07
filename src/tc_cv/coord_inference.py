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
    async def infer(
        self,
        capture_coords: typing.Callable[
            [typ.Vector], typing.Awaitable[ScreenCoordCapture]
        ],
        mul: float = 1.0,
    ) -> CoordTansformFn:
        measured_points: list[ScreenCoordCapture] = [
            await capture_coords(typ.Vector(0, 0))
        ]
        for world_move in (typ.Vector(1, 0), typ.Vector(0, 1)):
            measured_points.append(await capture_coords(world_move * mul))

        np_screen_coords = np.array(
            [[p.screenCoords.x, p.screenCoords.y] for p in measured_points]
        )
        np_printer_coords = np.array(
            [[p.printerCoords.x, p.printerCoords.y] for p in measured_points]
        )

        A = np.vstack([np_screen_coords.T, np.ones(np_screen_coords.shape[0])]).T
        (solution, res, rank, s) = np.linalg.lstsq(A, np_printer_coords, rcond=None)

        def _get_printer_coords(screen_p: typ.Point):
            rv = np.dot(np.array([[screen_p.x, screen_p.y, 1.0]]), solution)
            assert rv.shape == (1, 2)
            return typ.Point(x=rv[0][0], y=rv[0][1])

        return _get_printer_coords
