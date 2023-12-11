import io
from functools import cache, partial
from itertools import combinations

from .part1 import find_empty_rows, find_galaxies, transposed


@cache
def range_set(start: int, stop: int) -> frozenset[int]:
    return frozenset(range(start, stop))


def distance(
    a: tuple[int, int],
    b: tuple[int, int],
    empty_rows: set[int],
    empty_cols: set[int],
    spacing: int,
) -> int:
    x0, x1 = sorted((a[0], b[0]))
    y0, y1 = sorted((a[1], b[1]))
    return (
        (x1 - x0)
        + (y1 - y0)
        + ((spacing - 1) * len(empty_rows & range_set(x0, x1)))
        + ((spacing - 1) * len(empty_cols & range_set(y0, y1)))
    )


def main(data: io.TextIOWrapper, spacing: int = 1000000) -> int:
    skymap = list(map(str.strip, data.readlines()))
    distance_ = partial(
        distance,
        empty_rows=find_empty_rows(skymap),
        empty_cols=find_empty_rows(transposed(skymap)),
        spacing=spacing,
    )
    return sum(
        map(
            lambda x: distance_(*x),
            combinations(find_galaxies(skymap), 2),
        )
    )
