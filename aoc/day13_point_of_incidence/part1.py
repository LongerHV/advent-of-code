import io
from typing import Iterable

from more_itertools import split_at, transpose


def transposed(data: Iterable[str]) -> Iterable[str]:
    return map("".join, transpose(data))


def parse_input(data: io.TextIOWrapper) -> Iterable[list[str]]:
    return split_at(map(str.strip, data), lambda x: not x)


def count_rows_above_reflection(mirror: list[str], middlepoint: int | None = None) -> int:
    if middlepoint == 0:
        return 0
    middlepoint = middlepoint or len(mirror) - 1
    upper, lower = mirror[:middlepoint], mirror[middlepoint:]
    min_length = min(len(upper), len(lower))
    if list(reversed(upper))[:min_length] == lower[:min_length]:
        return middlepoint
    return count_rows_above_reflection(mirror, middlepoint - 1)


def process_mirror(mirror: list[str]) -> int:
    if line_count := count_rows_above_reflection(mirror):
        return 100 * line_count
    if line_count := count_rows_above_reflection(list(transposed(mirror))):
        return line_count
    return 0


def main(data: io.TextIOWrapper) -> int:
    return sum(map(process_mirror, parse_input(data)))
