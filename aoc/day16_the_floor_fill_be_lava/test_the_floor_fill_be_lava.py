import io
import sys
from pathlib import Path
from typing import Callable

import pytest

from . import part1  # , part2

sys.setrecursionlimit(10000)


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example.txt", 46],
        [part1.main, "input.txt", 7996],
        # [part2.main, "example.txt", 0],
        # [part2.main, "input.txt", 0],
    ],
)
def test_the_floor_will_be_lava(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
