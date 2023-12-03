import io
import itertools
from dataclasses import dataclass


@dataclass
class PartNumber:
    value: int
    position: int

    @property
    def length(self):
        return len(str(self.value))


def is_symbol(s: str) -> bool:
    return s != "."


def find_part_numbers_in_line(line: str) -> list[PartNumber]:
    number = ""
    result = []
    for i, s in enumerate(line):
        if s.isdigit():
            number += s
        elif number:
            result.append(PartNumber(int(number), i - len(number)))
            number = ""
    if number:
        result.append(PartNumber(int(number), len(line) - len(number)))
    return result


def is_part_number(
    part_number: PartNumber,
    prev_line: str | None,
    current_line: str,
    next_line: str | None,
) -> bool:
    position = part_number.position
    length = part_number.length
    start = position - 1 if position > 0 else 0
    end = position + length + 1 if position + length < len(current_line) else position + length
    return any(
        itertools.chain(
            (is_symbol(s) for s in prev_line[start:end]) if prev_line else [],
            (
                position > 0 and is_symbol(current_line[position - 1]),
                (position + length) < len(current_line)
                and is_symbol(current_line[position + length]),
            ),
            (is_symbol(s) for s in next_line[start:end]) if next_line else [],
        )
    )


def gear_ratios(data: io.TextIOWrapper) -> int:
    sum_ = 0
    lines = data.readlines()
    for i, line in enumerate(lines):
        prev_line = lines[i - 1].strip() if i > 0 else None
        current_line = line.strip()
        next_line = lines[i + 1].strip() if i < len(lines) - 1 else None
        part_numbers = find_part_numbers_in_line(current_line)
        for part_number in part_numbers:
            if is_part_number(part_number, prev_line, current_line, next_line):
                sum_ += part_number.value
    return sum_


if __name__ == "__main__":
    with open(
        "/home/longer/repos/advent-of-code/2023/python/day03_gear_ratios/input/input1.txt", "r"
    ) as f:
        gear_ratios(f)
