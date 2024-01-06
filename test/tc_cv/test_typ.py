import tc_cv.typ as typ


def test_vector():
    p1 = typ.Point(x=1, y=2)
    p2 = typ.Point(x=3, y=6)
    assert p1 - p2 == typ.Vector(dx=-2, dy=-4)


def test_math():
    p1 = typ.Point(0, 0)
    p2 = typ.Point(-10, -10)
    delta = p1 - p2
    assert (p1 + delta) == typ.Point(10, 10)
