import io
from functools import cache
from itertools import takewhile
from typing import NamedTuple

from more_itertools import iterate, last

Vector = tuple[int, int]

UP: Vector = (-1, 0)
DOWN: Vector = (1, 0)
LEFT: Vector = (0, -1)
RIGHT: Vector = (0, 1)

DIRECTIONS = (UP, DOWN, LEFT, RIGHT)

SLOPES: dict[str, Vector] = {
    "^": UP,
    "v": DOWN,
    "<": LEFT,
    ">": RIGHT,
}


@cache
def scalar_mul(v: Vector, s: int) -> Vector:
    return v[0] * s, v[1] * s


@cache
def vector_add(a: Vector, b: Vector) -> Vector:
    return a[0] + b[0], a[1] + b[1]


@cache
def new_directions(last_direction: Vector) -> tuple[Vector, Vector, Vector]:
    return tuple(filter(lambda d: d != scalar_mul(last_direction, -1), DIRECTIONS))  # type: ignore


class Path(NamedTuple):
    position: Vector
    last_direction: Vector
    visited: frozenset[Vector]


class Args(NamedTuple):
    paths: list[Path]
    complete: list[Path]


def main(data: io.TextIOWrapper) -> int:
    map_ = list(map(str.strip, data))
    rows = len(map_)
    cols = len(map_[0])
    start = Args([Path((1, 1), DOWN, frozenset({(0, 1)}))], [])

    @cache
    def is_invalid_position(position: Vector) -> bool:
        return position[0] < 0 or position[0] >= rows or position[1] < 0 or position[1] >= cols

    def get_next_path(path: Path, direction: Vector) -> Path | None:
        new_position = vector_add(path.position, direction)
        if new_position in path.visited or is_invalid_position(new_position):
            return None
        tile = map_[new_position[0]][new_position[1]]
        if tile == "." or SLOPES.get(tile) == direction:
            return Path(
                new_position,
                direction,
                path.visited | {path.position},
            )
        return None

    def advance(args: Args):
        path = args.paths.pop()
        if path.position[0] == rows - 1:
            return Args(args.paths, args.complete + [path])
        new_paths = filter(
            None,
            map(
                lambda direction: get_next_path(path, direction),
                new_directions(path.last_direction),
            ),
        )
        return Args(args.paths + list(new_paths), args.complete)

    return max(
        map(
            lambda a: len(a.visited),
            last(
                takewhile(
                    lambda a: a.paths,
                    iterate(advance, start),
                ),
            ).complete,
        )
    )
