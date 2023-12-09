import io
from itertools import pairwise
from typing import Iterable


def parse_input(data: io.TextIOWrapper) -> Iterable[list[int]]:
    return map(lambda line: list(map(int, line.split())), data)


def extrapolate(data: list[int]) -> int:
    if all(map(lambda s: s == 0, data)):
        return 0
    return data[-1] + extrapolate(list(b - a for a, b in pairwise(data)))


def main(data: io.TextIOWrapper) -> int:
    return sum(map(extrapolate, parse_input(data)))
