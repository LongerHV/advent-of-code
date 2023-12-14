import io

from .part1 import parse_input, transposed


def is_exactly_one_off(upper: list[str], lower: list[str]) -> bool:
    min_length = min(len(upper), len(lower))
    different = 0
    for line_a, line_b in zip(list(reversed(upper))[:min_length], lower[:min_length]):
        for char_a, char_b in zip(line_a, line_b):
            if different > 1:
                return False
            if char_a == char_b:
                continue
            different += 1
    return different == 1


def count_rows_above_reflection(mirror: list[str], middlepoint: int | None = None) -> int:
    if middlepoint == 0:
        return 0
    middlepoint = middlepoint or len(mirror) - 1
    upper, lower = mirror[:middlepoint], mirror[middlepoint:]
    if is_exactly_one_off(upper, lower):
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
