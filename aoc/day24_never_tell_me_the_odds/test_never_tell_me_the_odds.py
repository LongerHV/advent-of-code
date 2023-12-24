import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1  # , part2


@pytest.mark.parametrize(
    ["func", "file", "args", "result"],
    [
        [part1.main, "example.txt", (7, 27), 2],
        [part1.main, "input.txt", (200000000000000, 400000000000000), 19976],
        # [part2.main, "example.txt", 0],
        # [part2.main, "input.txt", 0],
    ],
)
def test_never_tell_me_the_odds(
    func: Callable[[io.TextIOWrapper], int],
    file: str,
    args,
    result: int,
):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f, *args) == result
