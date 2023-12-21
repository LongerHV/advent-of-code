import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1  # , part2


@pytest.mark.parametrize(
    ["func", "file", "steps", "result"],
    [
        [part1.main, "example.txt", 6, 16],
        [part1.main, "input.txt", 64, 3666],
        # [part2.main, "example.txt", 6, 16],
        # [part2.main, "example.txt", 10, 50],
        # [part2.main, "example.txt", 50, 1594],
        # [part2.main, "example.txt", 100, 6536],
        # [part2.main, "example.txt", 500, 167004],
        # [part2.main, "example.txt", 1000, 668697],
        # [part2.main, "example.txt", 5000, 16733044],
        # [part2.main, "input.txt", 0],
    ],
)
def test_step_counter(
    func: Callable[[io.TextIOWrapper, int], int],
    file: str,
    steps: int,
    result: int,
):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f, steps) == result
