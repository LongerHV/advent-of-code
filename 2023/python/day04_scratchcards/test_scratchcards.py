import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.scratchcards, "example1.txt", 13],
        [part1.scratchcards, "input.txt", 0],
        # [part2.scratchcards, "example2.txt", 0],
        # [part2.scratchcards, "input.txt", 0],
    ],
)
def test_scratchcards(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
