import io

translations = {
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "seven": 7,
    "eight": 8,
    "nine": 9,
}


def get_textual_digit_from_line_start(line: str) -> int | None:
    for text, digit in translations.items():
        if line.startswith(text):
            return digit
    return None


def get_digits_from_line(line: str) -> list[int]:
    if not line:
        return []
    if line[0].isdigit():
        digits = [int(line[0])]
    elif digit := get_textual_digit_from_line_start(line):
        digits = [digit]
    else:
        digits = []
    return digits + get_digits_from_line(line[1:])


def get_calibration_value_from_line(line: str) -> int:
    digits = get_digits_from_line(line)
    return int(f"{digits[0]}{digits[-1]}")


def trebuchet(data: io.TextIOWrapper) -> int:
    return sum(map(get_calibration_value_from_line, data))
