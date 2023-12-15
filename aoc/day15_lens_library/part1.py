import io
from functools import reduce


def compute_hash(data: str) -> int:
    return reduce(
        lambda acc, char: ((acc + ord(char)) * 17) % 256,
        data,
        0,
    )


def main(data: io.TextIOWrapper) -> int:
    steps = data.read().strip().split(",")
    return sum(map(compute_hash, steps))
