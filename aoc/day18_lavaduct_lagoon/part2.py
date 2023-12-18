import io

from .part1 import Vector, get_points, shoelace

DIRECTIONS: dict[str, Vector] = {
    "0": (0, 1),
    "1": (1, 0),
    "2": (0, -1),
    "3": (-1, 0),
}


def parse_input(data: io.TextIOWrapper) -> list[Vector]:
    steps = map(
        lambda s: (int(s[:-1], 16), DIRECTIONS[s[-1]]),
        (s.strip().split()[-1].removeprefix("(#").removesuffix(")") for s in data),
    )

    return get_points(steps)


def main(data: io.TextIOWrapper) -> int:
    return shoelace(parse_input(data))
