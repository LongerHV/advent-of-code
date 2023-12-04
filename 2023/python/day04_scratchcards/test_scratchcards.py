import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.scratchcards, "example1.txt", 13],
        [part1.scratchcards, "input.txt", 26443],
        [part2.scratchcards, "example2.txt", 30],
        [part2.scratchcards, "input.txt", 6284877],
    ],
)
def test_scratchcards(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
