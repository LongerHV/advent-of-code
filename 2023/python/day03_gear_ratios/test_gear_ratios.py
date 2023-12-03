import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2
from .part1 import PartNumber as pn


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
    result = part1.find_part_numbers_in_line(line)
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
    ["func", "file", "expected"],
    [
        [part1.gear_ratios, "example1.txt", 4361],
        [part1.gear_ratios, "input1.txt", 546312],
        # [part2.gear_ratios, "example2.txt", 281],
        # [part2.gear_ratios, "input2.txt", 55429],
    ],
)
def test_gear_ratios(func: Callable[[io.TextIOWrapper], int], file: str, expected: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == expected
