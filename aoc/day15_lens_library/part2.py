import io
from functools import reduce

Box = list[tuple[str, int]]


def compute_hash(data: str) -> int:
    return reduce(
        lambda acc, char: ((acc + ord(char)) * 17) % 256,
        data,
        0,
    )


def find_lens_in_box(label: str, box: list[tuple[str, int]]) -> int | None:
    for i, lens in enumerate(box):
        if lens[0] == label:
            return i
    return None


def parse_step(step: str) -> tuple[str, int, int | None]:
    focal: int | None
    match list(step):
        case [*chars, "=", focal_]:
            focal = int(focal_)
        case [*chars, "-"]:
            focal = None
        case _:
            raise RuntimeError(f"Invalid lens: {step}")
    label = "".join(chars)
    return (label, compute_hash(label), focal)


def process_step(boxes: list[Box], step: str) -> list[Box]:
    label, h, focal = parse_step(step)
    box = boxes[h]
    lens_in_box = find_lens_in_box(label, box)
    if focal is not None and lens_in_box is not None:
        box[lens_in_box] = (label, focal)
    elif focal is not None:
        box.append((label, int(focal)))
    elif lens_in_box is not None:
        box.pop(lens_in_box)
    return boxes


def organize_lenses(steps: list[str]) -> list[Box]:
    return reduce(
        process_step,
        steps,
        [list() for _ in range(256)],
    )


def box_power(box: Box) -> int:
    return reduce(
        lambda acc, x: acc + ((x[0] + 1) * x[1][1]),
        enumerate(box),
        0,
    )


def main(data: io.TextIOWrapper) -> int:
    steps = data.read().strip().split(",")
    boxes = organize_lenses(steps)
    return reduce(
        lambda acc, x: acc + ((x[0] + 1) * box_power(x[1])),
        enumerate(boxes),
        0,
    )
