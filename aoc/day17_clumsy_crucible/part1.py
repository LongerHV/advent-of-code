import io
import math

Vector = tuple[int, int]


UP: Vector = (-1, 0)
DOWN: Vector = (1, 0)
LEFT: Vector = (0, -1)
RIGHT: Vector = (0, 1)


def add_positions(a: Vector, b: Vector) -> Vector:
    return a[0] + b[0], a[1] + b[1]


def main(data: io.TextIOWrapper) -> int:
    heatmap = tuple(map(str.strip, data))
    rows = len(heatmap)
    cols = len(heatmap[0])
    finish_position: Vector = rows - 1, cols - 1
    visited: dict[tuple[Vector, Vector, int], int | float] = {}
    unvisited: dict[tuple[Vector, Vector, int], int | float] = {}
    unvisited2: dict[tuple[Vector, Vector, int], int | float] = {}
    for i in range(rows):
        for j in range(cols):
            for direction in (UP, DOWN, LEFT, RIGHT):
                if (i, j) == (0, 0) and (direction in [UP, LEFT]):
                    continue
                elif (i, j) == (0, 0):
                    unvisited[((i, j), direction, 1)] = 0
                    continue
                for steps in range(1, 4):
                    unvisited2[((i, j), direction, steps)] = math.inf

    position, direction, steps = (0, 0), RIGHT, 1
    cost = math.inf
    while position != finish_position:
        cost = unvisited.pop((position, direction, steps))
        for d in (UP, DOWN, LEFT, RIGHT):
            if d[0] == -direction[0] and d[1] == -direction[1]:
                continue
            p = add_positions(position, d)
            s = steps + 1 if direction == d else 1
            key = p, d, s
            if key in visited:
                continue
            c = unvisited.get(key) or unvisited2.get(key)
            if c is None:
                continue
            unvisited[key] = min(c, cost + int(heatmap[p[0]][p[1]]))
        visited[(position, direction, steps)] = cost
        position, direction, steps = min(unvisited, key=lambda x: unvisited[x])  # why so slow -.-
    return int(cost)
