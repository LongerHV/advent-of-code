import io
from itertools import chain
from typing import Generator, Iterable, TypeVar

from .part1 import parse_category_map

T = TypeVar("T")


def batched(iterable: Iterable[T]) -> Generator[tuple[T, T], None, None]:
    it = iter(iterable)
    for i in it:
        yield i, next(it)


def parse_seeds(line: str) -> list[tuple[int, int]]:
    match line.strip().split(" "):
        case ["seeds:", *seeds]:
            return list(map(lambda pair: (int(pair[0]), int(pair[1])), batched(seeds)))
        case _:
            raise ValueError("Invalid seeds")


def main(data: io.TextIOWrapper) -> int:
    maps = data.read().split("\n\n")
    seed_ranges = parse_seeds(maps[0])
    result = list(chain.from_iterable(range(a, a + b) for (a, b) in seed_ranges))
    for category in maps[1:]:
        map_ = parse_category_map(category)
        result = list(map(map_.get, result))
    return min(result)
