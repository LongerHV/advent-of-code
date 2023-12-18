import io

from .part1 import Vector, count_cubes, get_points

DIRECTIONS: dict[str, Vector] = {
    "0": (0, 1),
    "1": (1, 0),
    "2": (0, -1),
    "3": (-1, 0),
}


def parse_input(data: io.TextIOWrapper) -> tuple[list[tuple[int, Vector]], list[Vector]]:
    steps = list(
        map(
            lambda s: (int(s[:-1], 16), DIRECTIONS[s[-1]]),
            (s.strip().split()[-1].removeprefix("(#").removesuffix(")") for s in data),
        )
    )

    return steps, get_points(steps)


def main(data: io.TextIOWrapper) -> int:
    steps, points = parse_input(data)
    return count_cubes(steps, points)
