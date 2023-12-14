import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example.txt", 136],
        [part1.main, "input.txt", 105784],
        [part2.main, "example.txt", 64],
        [part2.main, "input.txt", 91286],
    ],
)
def test_parabolic_reflector_dish(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
