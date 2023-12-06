import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2


@pytest.mark.parametrize(
    ["time", "distance", "hold", "result"],
    [
        [7, 9, 0, False],
        [7, 9, 1, False],
        [7, 9, 2, True],
        [7, 9, 3, True],
        [7, 9, 4, True],
        [7, 9, 5, True],
        [7, 9, 6, False],
        [7, 9, 7, False],
    ],
)
def test_is_winning(time: int, distance: int, hold: int, result: bool):
    assert part1.is_winning(time, distance, hold) == result


@pytest.mark.parametrize(
    ["time", "distance", "result"],
    [
        [7, 9, 2],
        [15, 40, 4],
        [30, 200, 11],
    ],
)
def test_min_hold_time(time: int, distance: int, result: int):
    assert part1.get_minimum_hold_time(time, distance) == result


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example.txt", 288],
        [part1.main, "input.txt", 303600],
        # [part2.main, "example.txt", 0],
        # [part2.main, "input.txt", 0],
    ],
)
def test_wait_for_it(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
