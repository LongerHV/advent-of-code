import io
from functools import reduce
from itertools import chain, combinations
from typing import Iterable, TypeVar

T = TypeVar("T")


def transposed(data: Iterable[Iterable[T]]) -> Iterable[Iterable[T]]:
    return zip(*data)


def find_empty_rows(skymap: Iterable[Iterable[str]]) -> set[int]:
    return set(
        map(
            lambda x: x[0],
            filter(
                lambda x: all(char == "." for char in x[1]),
                enumerate(skymap),
            ),
        ),
    )


def expand_universe(skymap: list[str]) -> list[str]:
    empty_rows = find_empty_rows(skymap)
    empty_cols = find_empty_rows(transposed(skymap))
    return reduce(
        lambda acc, x: acc + [x[1], x[1]]
        if x[0] in empty_rows
        else acc
        + [
            reduce(
                lambda acc, y: acc + ".." if y[0] in empty_cols else acc + y[1],
                enumerate(x[1]),
                "",
            )
        ],
        enumerate(skymap),
        [],
    )


def find_galaxies_in_row(row: int, line: str) -> Iterable[tuple[int, int]]:
    return map(
        lambda x: (row, x[0]),
        filter(
            lambda x: x[1] == "#",
            enumerate(line),
        ),
    )


def find_galaxies(skymap: list[str]) -> Iterable[tuple[int, int]]:
    return chain.from_iterable(
        map(
            lambda x: find_galaxies_in_row(*x),
            enumerate(skymap),
        )
    )


def distance(a: tuple[int, int], b: tuple[int, int]) -> int:
    return abs(a[0] - b[0]) + abs(a[1] - b[1])


def main(data: io.TextIOWrapper) -> int:
    skymap = expand_universe(list(map(str.strip, data.readlines())))
    return sum(
        map(
            lambda x: distance(*x),
            combinations(find_galaxies(skymap), 2),
        )
    )
