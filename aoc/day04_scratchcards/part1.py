import io


def scratch_card(card: str) -> int:
    winning, guesses = card.split(":")[1].strip().split("|")
    common = set(map(int, winning.strip().split())) & set(map(int, guesses.strip().split()))
    return 2 ** (len(common) - 1) if common else 0


def main(data: io.TextIOWrapper) -> int:
    return sum(map(scratch_card, data))
