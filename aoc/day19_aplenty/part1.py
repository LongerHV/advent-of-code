import io
import operator
from functools import partial
from itertools import dropwhile, takewhile
from typing import Callable

from more_itertools import iterate

Rating = dict[str, int]
RuleFunc = Callable[[Rating], bool | str | None]
Workflow = list[RuleFunc]


def parse_rule(r: str) -> RuleFunc:
    def rule(rating: Rating) -> bool | str | None:
        """
        Returns:
            True - accepted
            False - rejected
            None - keep going
            str - next workflow
        """
        match r.split(":"):
            case [action] if action in ("A", "R"):
                return action == "A"
            case [action]:
                return action
            case [condition, action]:
                op = operator.gt if condition[1] == ">" else operator.lt
                if op(rating[condition[0]], int(condition[2:])):
                    return {"A": True, "R": False}.get(action, action)
                return None
        raise RuntimeError(f"Invalid rule: {r}")

    return rule


def parse_workflow(line: str) -> tuple[str, list[RuleFunc]]:
    name, rules = line.removesuffix("}").split("{")
    return name, list(map(parse_rule, rules.split(",")))


def parse_rating(line: str) -> Rating:
    m = map(lambda r: r.split("="), line.removeprefix("{").removesuffix("}").split(","))
    return {x[0]: int(x[1]) for x in m}


def parse_input(data: io.TextIOWrapper) -> tuple[dict[str, Workflow], list[Rating]]:
    workflows = map(parse_workflow, map(str.strip, takewhile(lambda line: line != "\n", data)))
    ratings = map(parse_rating, map(str.strip, data))
    return {k: v for k, v in workflows}, list(ratings)


def run_workflow(workflows: dict[str, Workflow], rating: Rating, value: str | bool) -> str | bool:
    if isinstance(value, bool):
        return value
    result = next(
        dropwhile(
            lambda x: x is None,
            map(
                lambda rule: rule(rating),
                workflows[value],
            ),
        ),
    )
    if result is not None:
        return result
    raise RuntimeError("None of the workflows gave a meaningful result")


def process_rating(workflows: dict[str, Workflow], rating: Rating) -> int:
    start: bool | str = "in"  # type annotation to make mypy happy
    it = iterate(partial(run_workflow, workflows, rating), start)
    if next(dropwhile(lambda x: not isinstance(x, bool), it)):
        return sum(rating.values())
    return 0


def main(data: io.TextIOWrapper) -> int:
    workflows, ratings = parse_input(data)
    return sum(map(partial(process_rating, workflows), ratings))
