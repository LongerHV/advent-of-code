import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example.txt", 114],
        [part1.main, "input.txt", 1782868781],
        [part2.main, "example.txt", 2],
        [part2.main, "input.txt", 1057],
    ],
)
def test_mirage_maintenance(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
