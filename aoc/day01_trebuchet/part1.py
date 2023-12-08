import io


def get_calibration_value_from_line(line: str) -> int:
    digits = list(filter(str.isdigit, line))
    return int(f"{digits[0]}{digits[-1]}")


def main(data: io.TextIOWrapper) -> int:
    return sum(map(get_calibration_value_from_line, data))
