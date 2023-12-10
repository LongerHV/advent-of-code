import io
from functools import reduce
from itertools import takewhile
from math import ceil
from typing import NamedTuple, Self

from more_itertools import iterate


class Coordinates(NamedTuple):
    x: int
    y: int

    def with_offset(self, x: int = 0, y: int = 0) -> Self:
        return type(self)(self.x + x, self.y + y)


class Maze:
    def __init__(self, maze: list[str]):
        self._maze = maze
        self.rows = len(maze)
        self.columns = len(maze[0])

    def __getitem__(self, __key: int | Coordinates) -> str:
        match __key:
            case int():
                return self._maze[__key]
            case Coordinates():
                return self._maze[__key.x][__key.y]
        raise ValueError(f"Unsupported key argument: {__key}")

    def slice(self, k: int):
        return type(self)(self._maze[k:])


def find_start(maze: Maze) -> Coordinates:
    column = maze[0].find("S")
    if column > -1:
        return Coordinates(0, column)
    return find_start(maze.slice(1)).with_offset(1, 0)


def make_step(
    maze: Maze,
    position: Coordinates,
    last_position: Coordinates | None = None,
) -> tuple[Coordinates, Coordinates]:
    last_position = last_position or position

    # Go up
    new_position = position.with_offset(x=-1)
    if (
        position.x > 0
        and new_position != last_position
        and maze[position] in "|LJS"
        and maze[new_position] in "|7FS"
    ):
        return new_position, position

    # Go down
    new_position = position.with_offset(x=1)
    if (
        position.x < maze.rows
        and new_position != last_position
        and maze[position] in "|F7S"
        and maze[new_position] in "|LJS"
    ):
        return new_position, position

    # Go left
    new_position = position.with_offset(y=-1)
    if (
        position.y > 0
        and new_position != last_position
        and maze[position] in "-J7S"
        and maze[new_position] in "-LFS"
    ):
        return new_position, position

    # Go right
    new_position = position.with_offset(y=1)
    if (
        position.y < maze.columns
        and new_position != last_position
        and maze[position] in "-LFS"
        and maze[new_position] in "-7JS"
    ):
        return new_position, position

    raise Exception


def main(data: io.TextIOWrapper) -> int:
    maze = Maze(list(map(str.strip, data.readlines())))
    start = find_start(maze)

    def make_step_(x: tuple[Coordinates, Coordinates | None]) -> tuple[Coordinates, Coordinates]:
        return make_step(maze, *x)

    return ceil(
        reduce(
            lambda acc, _: acc + 1,
            takewhile(
                lambda x: x[0] != start,
                iterate(
                    make_step_,
                    make_step_((start, None)),
                ),
            ),
            1,
        )
        / 2,
    )
