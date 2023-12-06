import functools
import io
import math


@functools.cache
def delta(a: int, b: int, c: int) -> float:
    return b**2 - (4 * a * c)


def get_minimum_hold_time(time: int, distance: int) -> int:
    d = delta(1, time, distance)
    return math.floor((time - math.sqrt(d)) / 2) + 1


def get_maximum_hold_time(time: int, distance: int) -> int:
    d = delta(1, time, distance)
    return math.ceil((time + math.sqrt(d)) / 2) - 1


def get_ways_to_win(time: int, distance: int) -> int:
    return get_maximum_hold_time(time, distance) - get_minimum_hold_time(time, distance) + 1


# This solution uses a squere equation:
# hold_time ^ 2 - time * hold_time + d < 0
def main(data: io.TextIOWrapper) -> int:
    times_line, distances_line = data.read().strip().split("\n")
    times = map(int, times_line.split()[1:])
    distances = map(int, distances_line.split()[1:])
    return functools.reduce(lambda acc, td: acc * get_ways_to_win(*td), zip(times, distances), 1)
