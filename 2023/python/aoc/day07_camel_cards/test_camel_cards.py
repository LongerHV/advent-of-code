import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example.txt", 6440],
        [part1.main, "input.txt", 250946742],
        [part2.main, "example.txt", 5905],
        [part2.main, "input.txt", 251824095],
    ],
)
def test_camel_cards(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
