import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example.txt", 19114],
        [part1.main, "input.txt", 362930],
        [part2.main, "example.txt", 167409079868000],
        [part2.main, "input.txt", 116365820987729],
    ],
)
def test_aplenty(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
