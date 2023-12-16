import io
from functools import cache
from itertools import chain

from .part1 import DOWN, LEFT, RIGHT, UP, Vector, add_vectors


def solve(layout: tuple[str, ...]) -> int:
    @cache
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

    starting_positions = chain(
        (((0, i), DOWN) for i in range(len(layout[0]))),
        (((len(layout) - 1, i), UP) for i in range(len(layout[0]))),
        (((i, 0), RIGHT) for i in range(len(layout))),
        (((i, len(layout[0]) - 1), LEFT) for i in range(len(layout))),
    )

    def solve_(starting_position: tuple[Vector, Vector]):
        moves: list[tuple[Vector, Vector]] = [starting_position]
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

    return max(map(solve_, starting_positions))


def main(data: io.TextIOWrapper) -> int:
    layout = tuple(map(str.strip, data.readlines()))
    return solve(layout)
