from . import typ


def sign_vector(vector: typ.Vector) -> typ.Vector:
    def _cmp(num):
        if num > 0:
            return 1
        elif num < 0:
            return -1
        else:
            assert num == 0
            return 0

    return typ.Vector(dx=_cmp(vector.dx), dy=_cmp(vector.dy))


def round_vector(vector: typ.Vector, digits: int) -> typ.Vector:
    divider = 10**digits
    mul_dx = vector.dx * divider
    mul_dy = vector.dy * divider
    rounded_dx = round(mul_dx)
    rounded_dy = round(mul_dy)
    return typ.Vector(
        dx=rounded_dx / divider,
        dy=rounded_dy / divider,
    )
