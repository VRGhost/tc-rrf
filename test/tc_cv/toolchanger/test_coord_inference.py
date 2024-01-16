import pytest

import tc_cv


def assert_almoast_eq(p1: tc_cv.typ.Point, p2: tc_cv.typ.Point, epsilon: float = 10e-5):
    dist = (p1 - p2).len()
    assert dist < epsilon, "Distance should be sufficiently small"


class TestXY:
    @pytest.fixture
    def inferer(self):
        return tc_cv.coord_inference.InferCoordTransform.xy()

    def test_simple(self, inferer):
        assert inferer.ignored_printer_coord == "z"
        assert inferer.active_printer_coords == ("x", "y")

    @pytest.mark.asyncio
    async def test_infer(self, inferer):
        async def _get_coords(move_vec: tc_cv.typ.Vector):
            return {
                tc_cv.typ.Vector(0, 0, 0): tc_cv.coord_inference.ScreenCoordCapture(
                    printerCoords=tc_cv.typ.Point(0, 0, 0),
                    screenCoords=tc_cv.typ.Point(0, 0, 0),
                ),
                # Moving by dx=1 moves screen dy=1 & printer by dy=10
                tc_cv.typ.Vector(1, 0, 0): tc_cv.coord_inference.ScreenCoordCapture(
                    printerCoords=tc_cv.typ.Point(0, 10, 0),
                    screenCoords=tc_cv.typ.Point(0, 1, 0),
                ),
                # Moving by dx=1 moves screen dx=-1 & printer by dx=-10
                tc_cv.typ.Vector(0, 1, 0): tc_cv.coord_inference.ScreenCoordCapture(
                    printerCoords=tc_cv.typ.Point(-1, 0, 0),
                    screenCoords=tc_cv.typ.Point(10, 0, 0),
                ),
            }[move_vec]

        transform_fn = await inferer.infer(_get_coords)
        assert_almoast_eq(
            transform_fn(tc_cv.typ.Point(0, 0, 0)), tc_cv.typ.Point(0, 0, 0)
        )
        assert_almoast_eq(
            transform_fn(tc_cv.typ.Point(100, 0, 0)), tc_cv.typ.Point(-10, 0, 0)
        )
        assert_almoast_eq(
            transform_fn(tc_cv.typ.Point(0, 100, 0)), tc_cv.typ.Point(0, 1000, 0)
        )


class TestXZ:
    @pytest.fixture
    def inferer(self):
        return tc_cv.coord_inference.InferCoordTransform.xz()

    def test_simple(self, inferer):
        assert inferer.ignored_printer_coord == "y"
        assert inferer.active_printer_coords == ("x", "z")

    @pytest.mark.asyncio
    async def test_infer(self, inferer):
        async def _get_coords(move_vec: tc_cv.typ.Vector):
            return {
                tc_cv.typ.Vector(0, 0, 0): tc_cv.coord_inference.ScreenCoordCapture(
                    printerCoords=tc_cv.typ.Point(0, 0, 0),
                    screenCoords=tc_cv.typ.Point(0, 0, 0),
                ),
                # Moving by dx=1 moves screen dx=1 & printer by dz=10
                tc_cv.typ.Vector(1, 0, 0): tc_cv.coord_inference.ScreenCoordCapture(
                    printerCoords=tc_cv.typ.Point(0, 0, 10),
                    screenCoords=tc_cv.typ.Point(1, 0, 0),
                ),
                # Moving by dz=1 moves screen dx=-1 & printer by dx=-10
                tc_cv.typ.Vector(0, 0, 1): tc_cv.coord_inference.ScreenCoordCapture(
                    printerCoords=tc_cv.typ.Point(-10, 0, 0),
                    screenCoords=tc_cv.typ.Point(0, 10, 0),
                ),
            }[move_vec]

        transform_fn = await inferer.infer(_get_coords)
        assert_almoast_eq(
            transform_fn(tc_cv.typ.Point(0, 0, 0)), tc_cv.typ.Point(0, 0, 0)
        )
        assert_almoast_eq(
            transform_fn(tc_cv.typ.Point(100, 0, 0)), tc_cv.typ.Point(0, 0, 1000)
        )
        assert_almoast_eq(
            transform_fn(tc_cv.typ.Point(0, 100, 0)), tc_cv.typ.Point(-100, 0, 0)
        )
