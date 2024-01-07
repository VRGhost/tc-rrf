import pytest

import tc_cv


@pytest.mark.parametrize(
    "inp, exp_out",
    [
        (tc_cv.typ.Vector(0.1, 0.1), tc_cv.typ.Vector(1, 1)),
        (tc_cv.typ.Vector(0.1, -0.0001), tc_cv.typ.Vector(1, -1)),
        (tc_cv.typ.Vector(1000, 0), tc_cv.typ.Vector(1, 0)),
        (tc_cv.typ.Vector(-0.1, -1), tc_cv.typ.Vector(-1, -1)),
    ],
)
def test_sign(inp, exp_out):
    assert tc_cv.math.sign_vector(inp) == exp_out


@pytest.mark.parametrize(
    "inp, prec, exp_out",
    [
        (tc_cv.typ.Vector(0.1, 0.1), 1, tc_cv.typ.Vector(0.1, 0.1)),
        (tc_cv.typ.Vector(0.16, -0.26), 1, tc_cv.typ.Vector(0.2, -0.3)),
        (tc_cv.typ.Vector(1.5, 1.3), 0, tc_cv.typ.Vector(2, 1)),
    ],
)
def test_round_vector(inp: tc_cv.typ.Vector, prec: int, exp_out: tc_cv.typ.Vector):
    assert tc_cv.math.round_vector(inp, prec) == exp_out
