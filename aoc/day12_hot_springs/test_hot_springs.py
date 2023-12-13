import io
from pathlib import Path
from typing import Callable

import pytest

from . import part1  # , part2


@pytest.mark.parametrize(
    ["line", "groups", "result"],
    [
        ["###", [3], True],
        ["###.", [3], True],
        [".###", [3], True],
        [".####", [3], False],
        [".##.#", [3], False],
        [".##.#", [2, 1], True],
    ],
)
def test_validate(line: str, groups: list[int], result: bool):
    assert part1.validate(line, groups) == result


@pytest.mark.parametrize(
    ["line", "groups", "result"],
    [
        ["???.###", [1, 1, 3], 1],
        [".??..??...?##.", [1, 1, 3], 4],
        ["?#?#?#?#?#?#?#?", [1, 3, 1, 6], 1],
    ],
)
def test_count_arrangements(line: str, groups: list[int], result: int):
    assert part1.count_arrangements(line, groups) == result


@pytest.mark.parametrize(
    ["func", "file", "result"],
    [
        [part1.main, "example.txt", 21],
        [part1.main, "input.txt", 7350],
        # [part2.main, "example.txt", 525152],
        # [part2.main, "input.txt", 0],
    ],
)
def test_hot_springs(func: Callable[[io.TextIOWrapper], int], file: str, result: int):
    with (Path(__file__).parent / "input" / file).open("r") as f:
        assert func(f) == result
