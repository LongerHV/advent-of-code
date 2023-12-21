import io
from functools import cache, partial
from itertools import chain

from more_itertools import iterate, nth

Vector = tuple[int, int]


@cache
def add_vectors(a: Vector, b: Vector) -> Vector:
    return a[0] + b[0], a[1] + b[1]


def parse_input(data: io.TextIOWrapper) -> tuple[Vector, list[str]]:
    garden = list(map(str.strip, data))
    x = next(filter(lambda x: x[1], enumerate(map(lambda s: "S" in s, garden))))[0]
    y = garden[x].find("S")
    garden[x] = garden[x].replace("S", ".")
    return (x, y), garden


def main(data: io.TextIOWrapper, steps: int = 64) -> int:
    start, garden = parse_input(data)
    rows = len(garden)
    cols = len(garden[0])

    @cache
    def is_valid_position(p: Vector) -> bool:
        return p[0] >= 0 and p[0] < rows and p[1] >= 0 and p[1] < cols and garden[p[0]][p[1]] != "#"

    @cache
    def solve_new_positions(position: Vector) -> list[Vector]:
        offsets = ((-1, 0), (1, 0), (0, 1), (0, -1))
        with_offset = partial(add_vectors, position)
        new_positions = filter(is_valid_position, map(with_offset, offsets))
        return list(new_positions)

    def solve_step(positions: set[Vector]) -> set[Vector]:
        return set(chain.from_iterable(map(solve_new_positions, positions)))

    final_positions = nth(iterate(solve_step, {start}), steps, set[Vector]())
    return len(final_positions)


if __name__ == "__main__":
    with open("input/input.txt", "r") as f:
        main(f)
