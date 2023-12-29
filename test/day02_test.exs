defmodule Day02Test do
  use ExUnit.Case

  test "Day 2 part 1 - example data" do
    data = File.read!("input_data/day02_example")
    assert Aoc.Day02part1.main(data) == 8
  end

  test "Day 2 part 1 - puzzle input" do
    data = File.read!("input_data/day02_input")
    assert Aoc.Day02part1.main(data) == 2317
  end

  test "Day 2 part 2 - example data" do
    data = File.read!("input_data/day02_example")
    assert Aoc.Day02part2.main(data) == 2286
  end

  test "Day 2 part 2 - puzzle input" do
    data = File.read!("input_data/day02_input")
    assert Aoc.Day02part2.main(data) == 74804
  end
end
