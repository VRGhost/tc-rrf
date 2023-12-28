import dataclasses
import typing

import numpy as np

VideoFrame: typing.TypeAlias = np.array


@dataclasses.dataclass(frozen=True, slots=True)
class Vector:
    dx: float
    dy: float

    def len_sq(self):
        """Return square of the length"""
        return self.dx**2 + self.dy**2


@dataclasses.dataclass(frozen=True, slots=True)
class Point:
    x: float
    y: float

    def sq_dist_to(self, other: "Point"):
        return (self.x - other.x) ** 2 + (self.y - other.y) ** 2

    def __sub__(self, other: typing.Union[Vector, "Point"]):
        if isinstance(other, Point):
            return Vector(dx=self.x - other.x, dy=self.y - other.y)
        elif isinstance(other, Vector):
            return Point(x=self.x + other.dx, y=self.y + other.dy)
        else:
            raise NotImplementedError


@dataclasses.dataclass(frozen=True, slots=True)
class Circle(Point):
    r: int
