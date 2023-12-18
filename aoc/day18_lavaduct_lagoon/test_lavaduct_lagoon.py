import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1  # , part2


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example.txt", 62],
        [part1.main, "input.txt", 40761],
        # [part2.main, "example.txt", 0],
        # [part2.main, "input.txt", 0],
    ],
)
def test_lavaduct_lagoon(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
