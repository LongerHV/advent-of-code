import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example.txt", 405],
        [part1.main, "input.txt", 36041],
        [part2.main, "example.txt", 400],
        [part2.main, "input.txt", 35915],
    ],
)
def test_point_of_incidence(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
