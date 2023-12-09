import io
from itertools import pairwise

from .part1 import parse_input


def extrapolate(data: list[int]) -> int:
    if all(map(lambda s: s == 0, data)):
        return 0
    return data[0] - extrapolate(list(b - a for a, b in pairwise(data)))


def main(data: io.TextIOWrapper) -> int:
    return sum(map(extrapolate, parse_input(data)))
