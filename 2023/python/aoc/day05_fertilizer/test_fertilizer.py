import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example.txt", 35],
        [part1.main, "input.txt", 836040384],
        [part2.main, "example.txt", 46],
        [part2.main, "input.txt", 10834440],
    ],
)
def test_fertilizer(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
