import io
from functools import reduce
from itertools import combinations
from typing import Iterable, NamedTuple, Self

Num = int | float


class Vector(NamedTuple):
    x: Num
    y: Num


class Hailstone(NamedTuple):
    position: Vector
    velocity: Vector

    @classmethod
    def from_string(cls, s: str) -> Self:
        position, velocity = s.split("@")
        px, py, _ = tuple(map(lambda x: int(x.strip()), position.split(", ")))
        vx, vy, _ = tuple(map(lambda x: int(x.strip()), velocity.split(", ")))
        return cls(
            Vector(px, py),
            Vector(vx, vy),
        )

    @property
    def slope(self) -> Num:
        return self.velocity.y / self.velocity.x

    @property
    def intercept(self) -> Num:
        return self.position.y - (self.slope * self.position.x)

    def find_intersection(self, other: Self) -> Vector | None:
        if self.slope == other.slope:
            return None
        x = (other.intercept - self.intercept) / (self.slope - other.slope)
        y = (self.slope * x) + self.intercept
        return Vector(x, y)

    def is_heading_towards(self, other: Vector) -> bool:
        return (other.x > self.position.x and self.velocity.x > 0) or (
            other.x < self.position.x and self.velocity.x < 0
        )


def ilen(iterable: Iterable) -> int:
    return reduce(lambda acc, _: acc + 1, iterable)


def parse_input(data: io.TextIOWrapper):
    return list(map(Hailstone.from_string, data))


def main(
    data: io.TextIOWrapper,
    start: int = 200000000000000,
    stop: int = 400000000000000,
) -> int:
    def intersects_in_area(
        acc: int,
        hailstones: tuple[Hailstone, Hailstone],
    ) -> int:
        a, b = hailstones
        intersection = a.find_intersection(b)
        if intersection is None:
            return acc
        x, y = intersection
        if not a.is_heading_towards(intersection) or not b.is_heading_towards(intersection):
            return acc
        if x >= start and x <= stop and y >= start and y <= stop:
            return acc + 1
        return acc

    hailstones = parse_input(data)
    result = reduce(
        intersects_in_area,
        combinations(hailstones, 2),
        0,
    )
    return result
