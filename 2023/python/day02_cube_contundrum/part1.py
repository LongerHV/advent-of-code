import io
import itertools
from collections import defaultdict
from typing import NamedTuple

BAG = defaultdict(
    int,
    {
        "red": 12,
        "green": 13,
        "blue": 14,
    },
)


class Record(NamedTuple):
    count: int
    color: str


def parse_record(s: str) -> Record:
    count, color = s.split(" ")
    return Record(int(count), color)


def parse_set(s: str):
    return list(map(parse_record, s.split(", ")))


def parse_sets(s: str):
    return list(map(parse_set, s.split("; ")))


def parse_game(s: str):
    idx = s.find(":")
    game_id = s[5:idx]
    records = s[idx + 2 :].strip()
    return int(game_id), parse_sets(records)


def process_game(line: str) -> int:
    game_id, game = parse_game(line)
    is_game_playable = all(
        count <= BAG[color] for count, color in itertools.chain.from_iterable(game)
    )
    if is_game_playable:
        return game_id
    return 0


def cube_conundrum(data: io.TextIOWrapper) -> int:
    return sum(map(process_game, data))
