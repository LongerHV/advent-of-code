import io

from .part1 import PartNumber, find_parts_in_line


def find_gears_in_line(line: str) -> list[int]:
    result = []
    for i, s in enumerate(line):
        if s == "*":
            result.append(i)
    return result


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


def gear_ratios(data: io.TextIOWrapper) -> int:
    sum_ = 0
    lines = data.readlines()
    for i, line in enumerate(lines):
        prev_line = lines[i - 1].strip() if i > 0 else None
        current_line = line.strip()
        next_line = lines[i + 1].strip() if i < len(lines) - 1 else None
        gears = find_gears_in_line(current_line)
        for gear in gears:
            parts = find_adjacent_parts(gear, prev_line, current_line, next_line)
            match parts:
                case [a, b]:
                    sum_ += a.value * b.value

    return sum_
