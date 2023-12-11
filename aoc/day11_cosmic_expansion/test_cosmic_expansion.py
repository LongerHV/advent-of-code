import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1, part2


@pytest.mark.parametrize(
    ["func", "file", "result", "args"],
    [
        [part1.main, "example.txt", 374, []],
        [part1.main, "input.txt", 9947476, []],
        [part2.main, "example.txt", 8410, [100]],
        [part2.main, "input.txt", 519939907614, []],
    ],
)
def test_cosmic_expansion(
    func: Callable[[io.TextIOWrapper], int], file: str, result: int, args: list
):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f, *args) == result
