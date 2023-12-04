import functools
import io
from collections import defaultdict
from itertools import chain

from .part1 import Record, parse_game

BAG = defaultdict(
    int,
    {
        "red": 12,
        "green": 13,
        "blue": 14,
    },
)


def process_color(color: str, flat_game: list[Record]) -> int:
    color_occurences = list(filter(lambda record: record.color == color, flat_game))
    if len(color_occurences) > 1:
        largest = max(*color_occurences, key=lambda record: record.count)
    else:
        largest = color_occurences[0]
    return largest.count


def process_game(line: str) -> int:
    _, game = parse_game(line)
    flat_game = list(chain.from_iterable(game))
    colors = set(map(lambda record: record.color, flat_game))
    return functools.reduce(
        lambda x, y: x * process_color(y, flat_game),
        colors,
        1,
    )


def main(data: io.TextIOWrapper) -> int:
    return sum(map(process_game, data))
