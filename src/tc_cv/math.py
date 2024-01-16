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

    return typ.Vector(dx=_cmp(vector.dx), dy=_cmp(vector.dy), dz=_cmp(vector.dz))


def round_vector(vector: typ.Vector, digits: int) -> typ.Vector:
    divider = 10**digits
    mul_dx = vector.dx * divider
    mul_dy = vector.dy * divider
    mul_dz = vector.dz * divider
    rounded_dx = round(mul_dx)
    rounded_dy = round(mul_dy)
    rounded_dz = round(mul_dz)
    print(mul_dz, rounded_dz)
    return typ.Vector(
        dx=rounded_dx / divider, dy=rounded_dy / divider, dz=rounded_dz / divider
    )
