import io
from enum import Enum
from functools import reduce
from itertools import pairwise, tee
from typing import Iterable

Vector = tuple[int, int]

DIRECTIONS: dict[str, Vector] = {
    "U": (-1, 0),
    "D": (1, 0),
    "L": (0, -1),
    "R": (0, 1),
}


class Rotation(Enum):
    CW = 1
    CCW = 0


ROTATION: dict[tuple[Vector, Vector], Rotation] = {
    ((-1, 0), (0, 1)): Rotation.CW,
    ((0, 1), (1, 0)): Rotation.CW,
    ((1, 0), (0, -1)): Rotation.CW,
    ((0, -1), (-1, 0)): Rotation.CW,
    ((-1, 0), (0, -1)): Rotation.CCW,
    ((0, -1), (1, 0)): Rotation.CCW,
    ((1, 0), (0, 1)): Rotation.CCW,
    ((0, 1), (-1, 0)): Rotation.CCW,
}


def advance(start: Vector, direction: Vector, distance: int) -> Vector:
    return start[0] + (distance * direction[0]), start[1] + (distance * direction[1])


def get_next_point(
    acc: tuple[list[Vector], Vector, Rotation],
    x: tuple[tuple[int, Vector], tuple[int, Vector]],
) -> tuple[list[Vector], Vector, Rotation]:
    vertices, prev, last_rotation = acc
    (distance, direction), (_, next_direction) = x
    next_rotation = ROTATION[(direction, next_direction)]
    match (last_rotation, next_rotation):
        case (Rotation.CW, Rotation.CW):
            offset = 1
        case (Rotation.CCW, Rotation.CCW):
            offset = -1
        case _:
            offset = 0
    next_point = advance(prev, direction, distance + offset)
    return vertices + [next_point], next_point, next_rotation


def get_points(steps: Iterable[tuple[int, Vector]]) -> list[Vector]:
    origin: Vector = (0, 0)
    steps_a, steps_b = tee(steps)
    next(steps_b)
    return reduce(get_next_point, zip(steps_a, steps_b), ([origin], origin, Rotation.CW))[0]


def parse_input(data: io.TextIOWrapper) -> list[Vector]:
    steps = map(lambda x: (int(x[1]), DIRECTIONS[x[0]]), (x.strip().split() for x in data))
    return get_points(steps)


def determinant(a: Vector, b: Vector) -> int:
    return -(a[0] * b[1]) + (a[1] * b[0])


def shoelace(vertices: list[Vector]) -> int:
    return (
        reduce(
            lambda acc, v: acc + determinant(v[0], v[1]),
            pairwise(vertices),
            0,
        )
        // 2
    )


def main(data: io.TextIOWrapper) -> int:
    return shoelace(parse_input(data))
