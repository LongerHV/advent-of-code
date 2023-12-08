import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example.txt", 8],
        [part1.main, "input.txt", 2317],
        [part2.main, "example.txt", 2286],
        [part2.main, "input.txt", 74804],
    ],
)
def test_code_conundrum(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
