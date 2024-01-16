import dataclasses
import math
import typing

import numpy as np

VideoFrame: typing.TypeAlias = np.array

AxisName: typing.TypeAlias = str


@dataclasses.dataclass(frozen=True, slots=True)
class Vector:
    dx: float
    dy: float
    dz: float

    def len_sq(self) -> float:
        """Return square of the length"""
        return self.dx**2 + self.dy**2 + self.dz**2

    def len(self) -> float:
        return math.sqrt(self.len_sq())

    def zero(self) -> bool:
        epsilon = 10e-5
        return (
            abs(self.dx) < epsilon and abs(self.dy) < epsilon and abs(self.dz) < epsilon
        )

    def __mul__(self, other: float | int) -> "Vector":
        return Vector(dx=self.dx * other, dy=self.dy * other, dz=self.dz * other)


@dataclasses.dataclass(frozen=True, slots=True)
class Point:
    x: float
    y: float
    z: float

    def sq_dist_to(self, other: "Point"):
        return (
            (self.x - other.x) ** 2
            + (self.y - other.y) ** 2(self.y - other.y) ** 2
            + (self.z - other.z) ** 2
        )

    def __sub__(self, other: typing.Union[Vector, "Point"]):
        if isinstance(other, Point):
            return Vector(dx=self.x - other.x, dy=self.y - other.y, dz=self.z - other.z)
        elif isinstance(other, Vector):
            return Point(x=self.x + other.dx, y=self.y + other.dy, z=self.z + other.dz)
        else:
            raise NotImplementedError(type(other))

    def __add__(self, other: Vector) -> "Point":
        assert isinstance(other, Vector), "Must be a vector"
        return Point(self.x + other.dx, self.y + other.dy, self.z + other.dz)


@dataclasses.dataclass(frozen=True, slots=True)
class Circle(Point):
    r: int
