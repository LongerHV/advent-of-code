import io
from functools import reduce
from itertools import pairwise
from typing import Iterable

Vector = tuple[int, int]

DIRECTIONS: dict[str, Vector] = {
    "U": (-1, 0),
    "D": (1, 0),
    "L": (0, -1),
    "R": (0, 1),
}


def advance(start: Vector, direction: Vector, distance: int) -> Vector:
    return start[0] + (distance * direction[0]), start[1] + (distance * direction[1])


def get_next_point(
    acc: tuple[list[Vector], Vector],
    x: tuple[int, Vector],
) -> tuple[list[Vector], Vector]:
    vertices, prev = acc
    distance, direction = x
    next_point = advance(prev, direction, distance)
    return vertices + [next_point], next_point


def get_points(steps: Iterable[tuple[int, Vector]]) -> list[Vector]:
    origin: Vector = (0, 0)
    return reduce(get_next_point, steps, ([origin], origin))[0]


def parse_input(data: io.TextIOWrapper) -> tuple[list[tuple[int, Vector]], list[Vector]]:
    steps = list(map(lambda x: (int(x[1]), DIRECTIONS[x[0]]), (x.strip().split() for x in data)))
    return steps, get_points(steps)


def determinant(a: Vector, b: Vector) -> int:
    return (a[0] * b[1]) - (a[1] * b[0])


def shoelace(vertices: list[Vector]) -> int:
    return (
        reduce(
            lambda acc, v: acc + determinant(v[0], v[1]),
            pairwise(reversed(vertices)),
            0,
        )
        // 2
    )


def count_cubes(steps: list[tuple[int, Vector]], points: list[Vector]) -> int:
    area = shoelace(points)
    edge = reduce(lambda acc, x: acc + x[0], steps, 0)
    return int(area + (edge / 2) + 1)


def main(data: io.TextIOWrapper) -> int:
    steps, points = parse_input(data)
    return count_cubes(steps, points)
