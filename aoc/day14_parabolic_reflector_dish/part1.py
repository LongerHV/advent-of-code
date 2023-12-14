import io
from functools import reduce
from typing import Iterable


def transpose(iterable: Iterable[str]) -> list[str]:
    return list(map("".join, zip(*iterable)))


def move_rocks_in_column(column: str) -> str:
    return "#".join(
        map(
            "".join,
            map(
                lambda x: sorted(x, reverse=True),
                column.split("#"),
            ),
        ),
    )


def tilt_dish(dish: list[str]) -> Iterable[str]:
    return transpose(
        map(
            move_rocks_in_column,
            transpose(dish),
        ),
    )


def main(data: io.TextIOWrapper) -> int:
    dish = list(map(str.strip, data.readlines()))
    tilted_dish = list(tilt_dish(dish))
    rows = len(tilted_dish)
    return reduce(
        lambda acc, x: acc + (x[1].count("O") * (rows - x[0])),
        enumerate(tilted_dish),
        0,
    )
