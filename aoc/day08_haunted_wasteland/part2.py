import io
from functools import partial, reduce
from itertools import cycle, takewhile

from .part1 import make_step, parse_map, pass_map


def prime_factor(num: int, factor: int = 2) -> list[int]:
    if num == 1:
        return []
    if not num % factor:
        return [factor] + prime_factor(num // factor, factor)
    return prime_factor(num, factor + 1)


def main(data: io.TextIOWrapper) -> int:
    steps = data.readline().strip()
    data.readline()
    map_ = parse_map(data)
    make_step_ = partial(make_step, map_)
    ghost_cycles = map(
        lambda initial_position: reduce(
            lambda acc, _: acc + 1,
            takewhile(
                lambda x: not x.endswith("Z"),
                pass_map(
                    lambda position, step: make_step_(position, step),
                    cycle(steps),
                    initial_position,
                ),
            ),
            1,
        ),
        filter(lambda s: s.endswith("A"), map_.keys()),
    )
    prime_factors = reduce(
        lambda acc, p: acc | p,
        map(set, map(prime_factor, ghost_cycles)),
        set[int](),
    )
    return reduce(lambda acc, p: acc * p, prime_factors, 1)
