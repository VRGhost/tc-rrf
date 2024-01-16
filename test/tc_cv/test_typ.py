import tc_cv.typ as typ


def test_vector():
    p1 = typ.Point(x=1, y=2, z=3)
    p2 = typ.Point(x=3, y=6, z=9)
    assert p1 - p2 == typ.Vector(dx=-2, dy=-4, dz=-6)


def test_math():
    p1 = typ.Point(0, 0, 0)
    p2 = typ.Point(-10, -10, 1)
    delta = p1 - p2
    assert (p1 + delta) == typ.Point(10, 10, -1)


def test_mul():
    v1 = typ.Vector(dx=2, dy=1, dz=3)
    assert v1 * 0.01 == typ.Vector(dx=0.02, dy=0.01, dz=0.03)
