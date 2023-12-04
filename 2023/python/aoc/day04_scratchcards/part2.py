import io
from collections import defaultdict


def main(data: io.TextIOWrapper) -> int:
    copies = defaultdict(lambda: 1)
    for i, line in enumerate(data):
        winning, guesses = line.split(":")[1].strip().split("|")
        winning = set(map(int, winning.strip().split()))
        guesses = set(map(int, guesses.strip().split()))
        common = guesses & winning
        current_copies = copies[i]
        for j in range(len(common)):
            copies[i + j + 1] += current_copies
    return sum(copies.values())
