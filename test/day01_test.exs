defmodule Day01Test do
  use ExUnit.Case

  test "Day 01 part 1 - example data" do
    data = File.read!("input_data/day01_example1")
    assert Day01part1.main(data) == 142
  end

  test "Day 01 part 1 - real input" do
    data = File.read!("input_data/day01_input")
    assert Day01part1.main(data) == 54605
  end
end
