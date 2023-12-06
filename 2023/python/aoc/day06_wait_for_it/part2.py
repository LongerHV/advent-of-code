import io

from .part1 import get_ways_to_win


# This is very slow
def main(data: io.TextIOWrapper) -> int:
    times_line, distances_line = data.read().strip().split("\n")
    time = int("".join(times_line.split()[1:]))
    distance = int("".join(distances_line.split()[1:]))
    return get_ways_to_win(time, distance)
