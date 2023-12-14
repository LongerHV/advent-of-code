defmodule Day01Test do
  use ExUnit.Case

  test "Day 1 part 1 - example data" do
    data = File.read!("input_data/day01_example1")
    assert Aoc.Day01part1.main(data) == 142
  end

  test "Day 1 part 1 - puzzle input" do
    data = File.read!("input_data/day01_input")
    assert Aoc.Day01part1.main(data) == 54605
  end

  test "Day 1 part 2 - example data" do
    data = File.read!("input_data/day01_example2")
    assert Aoc.Day01part2.main(data) == 281
  end

  test "Day 1 part 2 - puzzle input" do
    data = File.read!("input_data/day01_input")
    assert Aoc.Day01part2.main(data) == 55429
  end
end
