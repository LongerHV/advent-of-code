import io
from functools import reduce
from itertools import product
from typing import Iterable


def parse_input(data: io.TextIOWrapper) -> Iterable[tuple[str, list[int]]]:
    return map(
        lambda x: (x[0], list(map(int, x[1].split(",")))),
        (map(str.split, data)),
    )


def validate(line: str, groups: list[int]) -> bool:
    return list(map(len, filter(None, line.split(".")))) == groups


def ilen(iterable):
    return reduce(lambda acc, _: acc + 1, iterable, 0)


def count_arrangements(line: str, groups: list[int]) -> int:
    template = line.replace("?", "{}")
    possibilities = product(".#", repeat=line.count("?"))
    return ilen(
        filter(
            None,
            map(
                lambda x: validate(template.format(*x), groups),
                possibilities,
            ),
        ),
    )


def main(data: io.TextIOWrapper) -> int:
    return sum(map(lambda x: count_arrangements(*x), parse_input(data)))
