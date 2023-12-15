import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example.txt", 1320],
        [part1.main, "input.txt", 510388],
        [part2.main, "example.txt", 145],
        [part2.main, "input.txt", 291774],
    ],
)
def test_lens_library(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
