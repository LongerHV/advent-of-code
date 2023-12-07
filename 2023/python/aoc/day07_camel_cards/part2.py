import functools
import io
from collections import Counter

from .part1 import Types

CARDS = {
    "A": 13,
    "K": 12,
    "Q": 11,
    "T": 10,
    "J": 1,
}


def strcmp(a: str, b: str) -> bool:
    a_val = CARDS.get(a[0], None) or int(a[0])
    b_val = CARDS.get(b[0], None) or int(b[0])
    return a_val < b_val if a_val != b_val else strcmp(a[1:], b[1:])


# xDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD
def get_hand_type(hand: str) -> Types:
    counter = Counter(hand)
    jokers = counter["J"]
    if 5 in counter.values():
        return Types.FiveOfAKind
    elif 4 in counter.values():
        if jokers:
            return Types.FiveOfAKind
        else:
            return Types.FourOfAKind
    elif 3 in counter.values() and 2 in counter.values():
        if jokers:
            return Types.FiveOfAKind
        else:
            return Types.FullHouse
    elif 3 in counter.values():
        if jokers == 2:
            return Types.FiveOfAKind
        elif jokers:
            return Types.FourOfAKind
        else:
            return Types.ThreeOfAKind
    elif Counter(counter.values())[2] == 2:
        if jokers == 1:
            return Types.FullHouse
        elif jokers:
            return Types.FourOfAKind
        else:
            return Types.TwoPair
    elif 2 in counter.values():
        if jokers:
            return Types.ThreeOfAKind
        else:
            return Types.OnePair
    else:
        if jokers:
            return Types.OnePair
        else:
            return Types.HighCard


class Hand:
    def __init__(self, hand: str, bet: str):
        self.hand = hand
        self.bet = int(bet)
        self.type = get_hand_type(hand)

    def __repr__(self):
        return f"{self.type}: {self.hand} -> {self.bet}"

    def __lt__(self, other):
        if self.type.value < other.type.value:
            return True
        elif self.type == other.type:
            return strcmp(self.hand, other.hand)
        return False


def main(data: io.TextIOWrapper) -> int:
    hands = map(lambda line: Hand(*line.split()), data)
    return functools.reduce(
        lambda acc, x: acc + (x[0] * x[1].bet),
        enumerate(sorted(hands), 1),
        0,
    )
