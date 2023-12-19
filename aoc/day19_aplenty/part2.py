import io
from functools import reduce
from itertools import takewhile
from typing import NamedTuple, Self


def parse_workflow(line: str) -> tuple[str, list[str]]:
    name, rules = line.removesuffix("}").split("{")
    return name, rules.split(",")


def parse_input(data: io.TextIOWrapper):
    workflows = map(parse_workflow, map(str.strip, takewhile(lambda line: line != "\n", data)))
    return {k: v for k, v in workflows}


class Part(NamedTuple):
    x: tuple[int, int]
    m: tuple[int, int]
    a: tuple[int, int]
    s: tuple[int, int]

    @property
    def size(self):
        return reduce(lambda acc, x: acc * (x[1] - x[0]), self, 1)

    def split_at(self, category: str, val: int) -> tuple[Self, Self]:
        c = getattr(self, category)
        c_a = (c[0], val)
        c_b = (val, c[1])
        return self.with_category(category, c_a), self.with_category(category, c_b)

    def with_category(self, category: str, value: tuple[int, int]) -> Self:
        return type(self)(**(self._asdict() | {category: value}))


def solve(workflows: dict[str, list[str]]) -> int:
    part = Part((1, 4001), (1, 4001), (1, 4001), (1, 4001))

    def solve_(part: Part, name: str) -> int:
        if name == "R" or part.size == 0:
            return 0
        if name == "A":
            return part.size
        result = 0
        for rule in workflows[name]:
            if ":" in rule:
                condition, target = rule.split(":")
                if ">" in condition:
                    n, v = condition.split(">")
                    part, other_part = part.split_at(n, int(v) + 1)
                    result += solve_(other_part, target)
                elif "<" in rule:
                    n, v = condition.split("<")
                    other_part, part = part.split_at(n, int(v))
                    result += solve_(other_part, target)
            else:
                result += solve_(part, rule)
        return result

    return solve_(part, "in")


def main(data: io.TextIOWrapper) -> int:
    return solve(parse_input(data))
