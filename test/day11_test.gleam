import day11
import gleeunit/should

pub fn part_1_example_test() {
  day11.part1("data/day11_example.txt")
  |> should.equal(Ok(55_312))
}

pub fn part_1_exercise_test() {
  day11.part1("data/day11_exercise.txt")
  |> should.equal(Ok(183_435))
}

pub fn part_2_example_test() {
  day11.part2("data/day11_example.txt")
  |> should.equal(Ok(65_601_038_650_482))
}

pub fn part_2_exercise_test() {
  day11.part2("data/day11_exercise.txt")
  |> should.equal(Ok(218_279_375_708_592))
}
