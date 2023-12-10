import io
from collections import defaultdict
from typing import DefaultDict


def main(data: io.TextIOWrapper) -> int:
    copies: DefaultDict[int, int] = defaultdict(lambda: 1)
    for i, line in enumerate(data):
        winning, guesses = line.split(":")[1].strip().split("|")
        common = set(map(int, winning.strip().split())) & set(map(int, guesses.strip().split()))
        current_copies = copies[i]
        for j in range(len(common)):
            copies[i + j + 1] += current_copies
    return sum(copies.values())
