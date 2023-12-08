import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2
from .part1 import PartNumber as pn

three_lines = tuple[str | None, str, str | None]


@pytest.mark.parametrize(
    ["line", "expected"],
    [
        ["467..114..", [pn(467, 0), pn(114, 5)]],
        ["..35..633.", [pn(35, 2), pn(633, 6)]],
        [".....+.58.", [pn(58, 7)]],
        ["617*......", [pn(617, 0)]],
        [".......111", [pn(111, 7)]],
    ],
)
def test_find_part_numbers(line: str, expected: list[pn]):
    result = part1.find_parts_in_line(line)
    assert result == expected


@pytest.mark.parametrize(
    ["part_number", "lines", "expected"],
    [
        [
            pn(111, 3),
            (
                "##.....###",
                "##.111.###",
                "##.....###",
            ),
            False,
        ],
        [
            pn(111, 3),
            (
                "..........",
                "..#111....",
                "..........",
            ),
            True,
        ],
        [
            pn(111, 3),
            (
                "..........",
                "...111#...",
                "..........",
            ),
            True,
        ],
        [
            pn(111, 3),
            (
                "..........",
                "..#111#...",
                "..........",
            ),
            True,
        ],
        [
            pn(111, 3),
            (
                "....#.....",
                "...111....",
                "..........",
            ),
            True,
        ],
        [
            pn(111, 3),
            (
                "..........",
                "...111....",
                "....#.....",
            ),
            True,
        ],
        [
            pn(111, 3),
            (
                "..#.......",
                "...111....",
                "..........",
            ),
            True,
        ],
        [
            pn(111, 3),
            (
                "..#.......",
                "...111....",
                "..........",
            ),
            True,
        ],
        [
            pn(111, 3),
            (
                "..........",
                "...111....",
                "..#.......",
            ),
            True,
        ],
        [
            pn(111, 3),
            (
                "..........",
                "...111....",
                "......#...",
            ),
            True,
        ],
        [
            pn(111, 0),
            (
                "..........",
                "111.......",
                "..........",
            ),
            False,
        ],
        [
            pn(111, 7),
            (
                "..........",
                ".......111",
                "..........",
            ),
            False,
        ],
        [
            pn(111, 3),
            (
                None,
                "...111....",
                "..........",
            ),
            False,
        ],
        [
            pn(111, 3),
            (
                "..........",
                "...111....",
                None,
            ),
            False,
        ],
    ],
)
def test_is_part_number(part_number: pn, lines: tuple[str | None, str, str | None], expected: bool):
    # given
    prev_line, current_line, next_line = lines

    # when
    result = part1.is_part_number(part_number, prev_line, current_line, next_line)

    # then
    assert result == expected


@pytest.mark.parametrize(
    ["line", "expected"],
    [
        ["*.........", [0]],
        [".........*", [9]],
        ["*........*", [0, 9]],
        ["*.*.*.*.*.", [0, 2, 4, 6, 8]],
    ],
)
def test_find_gears(line: str, expected: list[int]):
    # when
    result = part2.find_gears_in_line(line)

    # then
    assert list(result) == expected


@pytest.mark.parametrize(
    ["gear", "lines", "expected"],
    [
        [
            5,
            (
                "..........",
                "111..*.111",
                "..........",
            ),
            [],
        ],
        [
            5,
            (
                "..........",
                "..111*111.",
                "..........",
            ),
            [pn(111, 2), pn(111, 6)],
        ],
        [
            5,
            (
                "..111.....",
                ".....*....",
                "......111.",
            ),
            [pn(111, 2), pn(111, 6)],
        ],
        [
            5,
            (
                # >= 3
                # <= 7
                "....111...",
                ".....*....",
                "..........",
            ),
            [pn(111, 4)],
        ],
        [
            5,
            (
                ".111...111",
                ".....*....",
                "..........",
            ),
            [],
        ],
    ],
)
def test_find_adjacent_parts(gear: int, lines: tuple[str, str, str], expected: list[pn]):
    # when
    result = part2.find_adjacent_parts(gear, *lines)

    # then
    assert result == expected


@pytest.mark.parametrize(
    ["func", "file", "expected"],
    [
        [part1.main, "example.txt", 4361],
        [part1.main, "input.txt", 546312],
        [part2.main, "example.txt", 467835],
        [part2.main, "input.txt", 87449461],
    ],
)
def test_gear_ratios(func: Callable[[io.TextIOWrapper], int], file: str, expected: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == expected
