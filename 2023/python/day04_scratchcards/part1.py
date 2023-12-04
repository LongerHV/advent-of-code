import io


def scratchcards(data: io.TextIOWrapper) -> int:
    result = 0
    for line in data:
        winning, guesses = line.split(":")[1].strip().split("|")
        winning = set(map(int, winning.strip().split()))
        guesses = set(map(int, guesses.strip().split()))
        common = guesses & winning
        if common:
            result += 2 ** (len(common) - 1)
    return result
