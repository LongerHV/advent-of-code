import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example.txt", 13],
        [part1.main, "input.txt", 26443],
        [part2.main, "example.txt", 30],
        [part2.main, "input.txt", 6284877],
    ],
)
def test_scratchcards(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
