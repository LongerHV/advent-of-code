#!/usr/bin/env bash

day="$1"
name="$2"

dir=aoc/day"$day"_"$name"
mkdir -p "$dir"/input
touch "$dir"/{part1,part2,__init__}.py
touch "$dir"/test_"$name".py
touch "$dir"/input/{example,input}.txt
