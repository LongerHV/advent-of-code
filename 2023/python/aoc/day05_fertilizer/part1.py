import io
from typing import NamedTuple


class RangeMapping(NamedTuple):
    destination: int
    source: int
    range_: int


class CategoryMap:
    def __init__(
        self,
        name: str,
        mappings: list[RangeMapping],
    ):
        self.name = name
        self.mappings = mappings

    def get(self, i: int):
        for dest, src, range_ in self.mappings:
            if i >= src and i < src + range_:
                return i - src + dest
        return i


def parse_seeds(line: str) -> list[int]:
    match line.strip().split(" "):
        case ["seeds:", *seeds]:
            return list(map(int, seeds))
        case _:
            raise ValueError("Invalid seeds")


def parse_category_map_entry(data: str) -> RangeMapping:
    match data.split(" "):
        case (destination, source, range_):
            return RangeMapping(int(destination), int(source), int(range_))
        case _:
            raise ValueError(f"Invalid category map entry: {data}")


def parse_category_map(data: str) -> CategoryMap:
    first_line, *other_lines = data.strip().split("\n")
    match first_line.strip().split(" "):
        case [name, "map:"]:
            mappings = list(map(parse_category_map_entry, other_lines))
            return CategoryMap(name, mappings)
        case _:
            raise ValueError(f"Invalid category map: {first_line}")


def main(data: io.TextIOWrapper) -> int:
    maps = data.read().split("\n\n")
    seeds = parse_seeds(maps[0])
    for category in maps[1:]:
        print("category:", category)
        map_ = parse_category_map(category)
        seeds = map(map_.get, seeds)
    return min(seeds)
