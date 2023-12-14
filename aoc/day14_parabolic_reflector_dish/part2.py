import io
from functools import cache, reduce
from typing import Iterable

Dish = tuple[str, ...]


def transpose(iterable: Iterable[str]) -> Dish:
    return tuple(map("".join, zip(*iterable)))


@cache  # 4x speedup by using memorization
def move_rocks_in_column(column: str, reverse=True) -> str:
    return "#".join(
        map(
            "".join,
            map(
                lambda x: sorted(x, reverse=reverse),
                column.split("#"),
            ),
        ),
    )


def spin_the_dish(dish: Dish) -> Dish:
    # Tilt north
    dish = tuple(
        transpose(
            map(
                move_rocks_in_column,
                transpose(dish),
            ),
        )
    )
    # Tilt west
    dish = tuple(map(move_rocks_in_column, dish))
    # Tilt south
    dish = tuple(
        transpose(
            map(
                lambda x: move_rocks_in_column(x, reverse=False),
                transpose(dish),
            ),
        )
    )
    # Tilt east
    return tuple(map(lambda x: move_rocks_in_column(x, reverse=False), dish))


def main(data: io.TextIOWrapper) -> int:
    n = 1_000_000_000
    dish = tuple(map(str.strip, data.readlines()))
    rows = len(dish)
    history: list[Dish] = []
    for i in range(n):
        dish = spin_the_dish(dish)
        # Found repeating cycle
        if dish in history:
            last_occurance = history.index(dish)
            loop = history[last_occurance:]
            cycle = i - last_occurance
            dish = loop[(n - i) % cycle - 1]
            break
        history.append(dish)

    return reduce(
        lambda acc, x: acc + (x[1].count("O") * (rows - x[0])),
        enumerate(dish),
        0,
    )
