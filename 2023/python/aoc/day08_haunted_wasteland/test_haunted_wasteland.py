import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example1.txt", 2],
        [part1.main, "example2.txt", 6],
        [part1.main, "input.txt", 17263],
        [part2.main, "example3.txt", 6],
        [part2.main, "input.txt", 14631604759649],
    ],
)
def test_haunted_wasteland(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
