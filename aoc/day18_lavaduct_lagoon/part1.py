import io
from functools import reduce

Vector = tuple[int, int]


def add_vectors(a: Vector, b: Vector) -> Vector:
    return a[0] + b[0], a[1] + b[1]


def mul_vector(a: Vector, scalar: int) -> Vector:
    return a[0] * scalar, a[1] * scalar


DIRECTIONS: dict[str, Vector] = {
    "U": (-1, 0),
    "D": (1, 0),
    "L": (0, -1),
    "R": (0, 1),
}


def find_start(duct: list[list[str]]) -> Vector:
    return (1, duct[1].index("#") + 1)


def main(data: io.TextIOWrapper) -> int:
    instructions = map(lambda x: (DIRECTIONS[x[0]], int(x[1])), (x.strip().split() for x in data))
    current: Vector = (0, 0)
    dug: set[Vector] = {current}
    for direction, length in instructions:
        dug |= {add_vectors(current, mul_vector(direction, i)) for i in range(1, length + 1)}
        current = add_vectors(current, mul_vector(direction, length))
    x_offset = min(dug, key=lambda x: x[0])[0]
    y_offset = min(dug, key=lambda x: x[1])[1]
    dug = {add_vectors(x, (-x_offset, -y_offset)) for x in dug}
    rows = max(dug, key=lambda x: x[0])[0] + 1
    cols = max(dug, key=lambda x: x[1])[1] + 1
    lava_duct = [[("#" if (i, j) in dug else ".") for j in range(cols)] for i in range(rows)]
    to_fill: set[Vector] = {find_start(lava_duct)}
    while to_fill:
        tile = to_fill.pop()
        x, y = tile
        lava_duct[x][y] = "#"
        for direction in DIRECTIONS.values():
            next_x, next_y = add_vectors(tile, direction)
            if next_x < 0 or next_y < 0 or next_x >= rows or next_y >= cols:
                continue
            if lava_duct[next_x][next_y] == ".":
                to_fill.add((next_x, next_y))

    return reduce(
        lambda acc, x: acc + "".join(x).count("#"),
        lava_duct,
        0,
    )
