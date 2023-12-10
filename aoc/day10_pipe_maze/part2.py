import io
from functools import reduce
from itertools import chain, product, takewhile
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

    @property
    def rows(self):
        return len(self._maze)

    @property
    def columns(self):
        return len(self._maze[0])

    def discover_start(self) -> tuple[Coordinates, Self]:
        start = find_start(self)
        m = self._maze.copy()
        x, y = start
        up = m[x - 1][y] if x > 0 else None
        down = m[x + 1][y] if x < len(m) else None
        left = m[x][y - 1] if y > 0 else None
        right = m[x][y + 1] if y < len(m[x]) else None
        match (up, down, left, right):
            case (_, _, "-" | "F" | "L", "-" | "7" | "J"):
                start_tile = "-"
            case ("|" | "F" | "7", "|" | "L" | "J", _, _):
                start_tile = "|"
            case (_, "|" | "J" | "L", _, "-" | "7" | "J"):
                start_tile = "F"
            case (_, "|" | "J" | "L", "-" | "F" | "L", _):
                start_tile = "7"
            case ("|" | "F" | "7", _, _, "-" | "7" | "J"):
                start_tile = "L"
            case ("|" | "F" | "7", _, "-" | "F" | "L", _):
                start_tile = "J"
            case _:
                raise ValueError("Invalid starting position")
        m[start.x] = m[start.x].replace("S", start_tile)
        return start, type(self)(m)

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


def count_intersections(s: str, row: int, offset: int, loop_tiles: set[Coordinates]) -> int:
    last_turn = ""
    intersections = 0
    for i, s in enumerate(s, offset):
        if (row, i) not in loop_tiles:
            continue
        if s == "|":
            intersections += 1
            last_turn = ""
        if s in "LF":
            last_turn = s
        elif s in "J7":
            match (last_turn, s):
                case ("L", "7") | ("F", "J"):
                    intersections += 1
                    last_turn = ""
        elif s == "-":
            pass
        else:
            last_turn = ""
    return intersections


def is_enclosed(maze: Maze, loop_tiles: set[Coordinates], tile: tuple[int, int]) -> bool:
    """The tile is enclosed in a loop,
    if there are odd number of pipe loops on both left and right sides."""
    if tile in loop_tiles:
        return False

    x, y = tile
    row = maze[x]
    left, right = row[:y], row[y + 1 :]
    left_intersections = count_intersections(left, x, 0, loop_tiles)
    right_intersections = count_intersections(right, x, len(left) + 1, loop_tiles)
    return bool(left_intersections % 2 and right_intersections % 2)


def main(data: io.TextIOWrapper) -> int:
    maze = Maze(list(map(str.strip, data.readlines())))
    start, maze = maze.discover_start()

    def make_step_(x: tuple[Coordinates, Coordinates | None]) -> tuple[Coordinates, Coordinates]:
        return make_step(maze, *x)

    visited_tiles = set(
        chain(
            [start],
            map(
                lambda x: x[0],
                takewhile(
                    lambda x: x[0] != start,
                    iterate(
                        make_step_,
                        make_step_((start, None)),
                    ),
                ),
            ),
        ),
    )
    return reduce(
        lambda acc, _: acc + 1,
        filter(
            lambda pos: is_enclosed(maze, visited_tiles, pos),
            product(range(maze.rows), range(maze.columns)),
        ),
        0,
    )


if __name__ == "__main__":
    with open("aoc/day10_pipe_maze/input/input.txt") as f:
        main(f)
