import functools
import io
from collections import Counter
from enum import Enum


class Types(Enum):
    HighCard = 1
    OnePair = 2
    TwoPair = 3
    ThreeOfAKind = 4
    FullHouse = 5
    FourOfAKind = 6
    FiveOfAKind = 7


CARDS = {
    "A": 14,
    "K": 13,
    "Q": 12,
    "J": 11,
    "T": 10,
}


def strcmp(a: str, b: str) -> bool:
    a_val = CARDS.get(a[0], None) or int(a[0])
    b_val = CARDS.get(b[0], None) or int(b[0])
    return a_val < b_val if a_val != b_val else strcmp(a[1:], b[1:])


class Hand:
    def __init__(self, hand: str, bet: str):
        self.hand = hand
        self.bet = int(bet)

        counter = Counter(hand)
        if 5 in counter.values():
            self.type = Types.FiveOfAKind
        elif 4 in counter.values():
            self.type = Types.FourOfAKind
        elif 3 in counter.values() and 2 in counter.values():
            self.type = Types.FullHouse
        elif 3 in counter.values():
            self.type = Types.ThreeOfAKind
        elif Counter(counter.values())[2] == 2:
            self.type = Types.TwoPair
        elif 2 in counter.values():
            self.type = Types.OnePair
        else:
            self.type = Types.HighCard

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
