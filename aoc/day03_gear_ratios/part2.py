import io
from functools import partial
from itertools import chain, tee
from typing import Iterable, TypeVar

from .part1 import PartNumber, find_parts_in_line


def find_gears_in_line(line: str) -> Iterable[int]:
    return map(
        lambda x: x[0],
        filter(
            lambda x: x[1] == "*",
            enumerate(line),
        ),
    )


def find_adjacent_parts_in_current_line(gear: int, line: str) -> list[PartNumber]:
    def is_adjacent(part: PartNumber):
        return part.position == gear + 1 or part.position + part.length == gear

    parts = find_parts_in_line(line)
    return list(filter(is_adjacent, parts))


def find_adjacent_parts_in_neighbour_line(gear, line: str | None) -> list[PartNumber]:
    def is_adjacent(part: PartNumber):
        return gear >= part.position - 1 and gear <= part.position + part.length

    if not line:
        return []
    parts = find_parts_in_line(line)
    return list(filter(is_adjacent, parts))


def find_adjacent_parts(
    gear: int,
    prev_line: str | None,
    current_line: str,
    next_line: str | None,
) -> list[PartNumber]:
    return [
        *find_adjacent_parts_in_neighbour_line(gear, prev_line),
        *find_adjacent_parts_in_current_line(gear, current_line),
        *find_adjacent_parts_in_neighbour_line(gear, next_line),
    ]


T = TypeVar("T")


def triwise(iterable: Iterable[T]) -> Iterable[tuple[T | None, T, T | None]]:
    a, b, c = tee(iterable, 3)
    next(c)
    return zip(chain([None], a), b, c)


def get_gear_ratio(gear: int, lines: tuple[str | None, str, str | None]) -> int:
    match find_adjacent_parts(gear, *lines):
        case [a, b]:
            return a.value * b.value
        case _:
            return 0


def sum_gear_ratios_in_line(lines: tuple[str | None, str, str | None]) -> int:
    return sum(
        map(
            partial(get_gear_ratio, lines=lines),
            find_gears_in_line(lines[1]),
        )
    )


def main(data: io.TextIOWrapper) -> int:
    return sum(map(sum_gear_ratios_in_line, triwise(data)))
