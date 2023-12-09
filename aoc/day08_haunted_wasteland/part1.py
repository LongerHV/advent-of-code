import io
from functools import partial
from itertools import cycle, takewhile
from typing import Callable, Iterable, Mapping, NamedTuple, TypeVar

from more_itertools import ilen


class Directions(NamedTuple):
    left: str
    right: str


def parse_line(line: str) -> tuple[str, Directions]:
    match line.strip().split():
        # AAA = (BBB, CCC)
        case [location, "=", left, right]:
            return location, Directions(
                left.removeprefix("(").removesuffix(","),
                right.removesuffix(")"),
            )
        case _:
            raise ValueError(f"Invalid line: {line}")


def parse_map(data: Iterable[str]) -> Mapping[str, Directions]:
    return dict(map(parse_line, data))


def make_step(map_: Mapping[str, Directions], position: str, step: str) -> str:
    current = map_[position]
    return current.left if step == "L" else current.right


T = TypeVar("T")
V = TypeVar("V")


def pass_map(
    predicate: Callable[[T, V], T],
    iterable: Iterable[V],
    initial: T,
) -> Iterable[T]:
    """Map function on elements of iterable,
    additionally passing result of last iteration as a first argument
    """
    acc = initial
    for element in iterable:
        acc = predicate(acc, element)
        yield acc


def main(data: io.TextIOWrapper) -> int:
    steps = data.readline().strip()
    data.readline()
    make_step_ = partial(make_step, parse_map(data))
    return 1 + ilen(
        takewhile(
            lambda x: x != "ZZZ",
            pass_map(
                lambda position, step: make_step_(position, step),
                cycle(steps),
                "AAA",
            ),
        ),
    )
