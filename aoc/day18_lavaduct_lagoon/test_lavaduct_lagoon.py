import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example.txt", 62],
        [part1.main, "input.txt", 40761],
        [part2.main, "example.txt", 952408144115],
        [part2.main, "input.txt", 106920098354636],
    ],
)
def test_lavaduct_lagoon(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
