import dataclasses


@dataclasses.dataclass(frozen=True, slots=True)
class Point:
    x: float
    y: float

    def sq_dist_to(self, other: "Point"):
        return (self.x - other.x) ** 2 + (self.y - other.y) ** 2


@dataclasses.dataclass(frozen=True, slots=True)
class Circle(Point):
    r: int
