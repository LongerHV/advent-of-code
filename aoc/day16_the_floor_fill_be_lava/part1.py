import io

Vector = tuple[int, int]

UP: Vector = (-1, 0)
DOWN: Vector = (1, 0)
LEFT: Vector = (0, -1)
RIGHT: Vector = (0, 1)


def add_vectors(a: Vector, b: Vector) -> Vector:
    return a[0] + b[0], a[1] + b[1]


def solve(layout: tuple[str, ...]) -> int:
    def advance(
        position: Vector,
        direction: Vector,
    ) -> list[tuple[Vector, Vector]]:
        if (
            position[0] < 0
            or position[0] >= len(layout)
            or position[1] < 0
            or position[1] >= len(layout[position[0]])
        ):
            return []

        tile = layout[position[0]][position[1]]

        match (tile, direction[0], direction[1]):
            case [".", _, _] | ["|", _, 0] | ["-", 0, _]:
                return [(add_vectors(position, direction), direction)]
            case ["/", _, _]:
                new_direction = (-direction[1], -direction[0])
                return [(add_vectors(position, new_direction), new_direction)]
            case ["\\", _, _]:
                new_direction = (direction[1], direction[0])
                return [(add_vectors(position, new_direction), new_direction)]
            case ["|", 0, _]:
                return [
                    (add_vectors(position, UP), UP),
                    (add_vectors(position, DOWN), DOWN),
                ]
            case ["-", _, 0]:
                return [
                    (add_vectors(position, LEFT), LEFT),
                    (add_vectors(position, RIGHT), RIGHT),
                ]
            case _:
                raise RuntimeError

    moves: list[tuple[Vector, Vector]] = [((0, 0), RIGHT)]
    visited: set[tuple[Vector, Vector]] = set()
    while moves:
        move = moves.pop()
        position, direction = move
        new_moves = advance(position, direction)
        if new_moves:
            visited.add(move)
        for move in new_moves:
            if move not in visited:
                moves.append(move)

    return len(set(map(lambda x: x[0], visited)))


def main(data: io.TextIOWrapper) -> int:
    layout = tuple(map(str.strip, data.readlines()))
    return solve(layout)
