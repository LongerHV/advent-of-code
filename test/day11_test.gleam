import day11
import gleeunit/should

pub fn part_1_example_test() {
  day11.part1("data/day11_example.txt")
  |> should.equal(Ok(55312))
}

pub fn part_1_exercise_test() {
  day11.part1("data/day11_exercise.txt")
  |> should.equal(Ok(183435))
}

pub fn part_2_example_test() {
  day11.part2("data/day11_example.txt")
  |> should.equal(Ok(65601038650482))
}

pub fn part_2_exercise_test() {
  day11.part2("data/day11_exercise.txt")
  |> should.equal(Ok(218279375708592))
}
