import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2


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
    ["time", "distance", "result"],
    [
        [7, 9, 5],
        [15, 40, 11],
        [30, 200, 19],
    ],
)
def test_max_hold_time(time: int, distance: int, result: int):
    assert part1.get_maximum_hold_time(time, distance) == result


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example.txt", 288],
        [part1.main, "input.txt", 303600],
        [part2.main, "example.txt", 71503],
        [part2.main, "input.txt", 23654842],
    ],
)
def test_wait_for_it(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
