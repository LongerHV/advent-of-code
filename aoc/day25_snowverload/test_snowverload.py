import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example.txt", 54],
        [part1.main, "input.txt", 543256],
    ],
)
def test_snowverload(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
