import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example1.txt", 142],
        [part1.main, "input.txt", 54605],
        [part2.main, "example2.txt", 281],
        [part2.main, "input.txt", 55429],
    ],
)
def test_trebuchet(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
