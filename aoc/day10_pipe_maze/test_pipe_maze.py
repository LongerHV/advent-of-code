import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example1.txt", 4],
        [part1.main, "example2.txt", 4],
        [part1.main, "example3.txt", 8],
        [part1.main, "example4.txt", 8],
        [part1.main, "input.txt", 6846],
        # [part2.main, "example.txt", 0],
        # [part2.main, "input.txt", 0],
    ],
)
def test_pipe_maze(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
