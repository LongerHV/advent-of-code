import argparse
import pkgutil
import sys
from functools import partial
from importlib import import_module
from types import SimpleNamespace

import aoc


def solve_puzzle(module, args: SimpleNamespace):
    try:
        main = import_module(f"{aoc.__name__}.{module.name}.part{args.part}").main
    except (AttributeError, ModuleNotFoundError):
        print(f"{module.name.capitalize()} part{args.part} is not implemented")
        exit(1)
    print(main(args.input))


def main():
    parser = argparse.ArgumentParser(formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.set_defaults(func=lambda _: parser.print_help())
    subparsers = parser.add_subparsers()
    for module in pkgutil.iter_modules(aoc.__path__):
        if module.name == "main":
            continue
        day, name = module.name.split("_", 1)
        p = subparsers.add_parser(
            name,
            help=f"Solve {day} puzzle",
            formatter_class=argparse.ArgumentDefaultsHelpFormatter,
        )
        p.add_argument(
            "--input",
            "-i",
            type=argparse.FileType("r"),
            default=sys.stdin,
            help="Path to the file containing input data",
        )
        p.add_argument(
            "--part",
            "-p",
            type=int,
            choices=[1, 2],
            default=1,
            help="Select puzzle part to run",
        )
        p.set_defaults(func=partial(solve_puzzle, module))
    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
