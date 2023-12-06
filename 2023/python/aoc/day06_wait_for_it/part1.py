import functools
import io


def is_winning(time: int, distance: int, hold: int) -> bool:
    return hold * (time - hold) > distance


def get_minimum_hold_time(time: int, distance: int) -> int:
    return next(filter(functools.partial(is_winning, time, distance), range(0, time)))


def get_maximum_hold_time(time: int, distance: int) -> int:
    return next(filter(functools.partial(is_winning, time, distance), reversed(range(0, time))))


def get_ways_to_win(time: int, distance: int) -> int:
    return get_maximum_hold_time(time, distance) - get_minimum_hold_time(time, distance) + 1


def main(data: io.TextIOWrapper) -> int:
    times_line, distances_line = data.read().strip().split("\n")
    times = map(int, times_line.split()[1:])
    distances = map(int, distances_line.split()[1:])
    return functools.reduce(lambda acc, td: acc * get_ways_to_win(*td), zip(times, distances), 1)
