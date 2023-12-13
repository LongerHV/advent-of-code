import io
from typing import Iterable


def parse_input(data: io.TextIOWrapper) -> Iterable[tuple[str, list[int]]]:
    return map(
        lambda x: (("?".join([x[0]] * 5)), 5 * list(map(int, x[1].split(",")))),
        (map(str.split, data)),
    )


def main(data: io.TextIOWrapper) -> int:
    _ = parse_input(data)
    raise NotImplementedError
