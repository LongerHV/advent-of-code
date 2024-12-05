import day5
import gleeunit/should

pub fn part_1_example_test() {
  day5.part1("data/day5_example.txt")
  |> should.equal(Ok(143))
}

pub fn part_1_exercise_test() {
  day5.part1("data/day5_exercise.txt")
  |> should.equal(Ok(4637))
}

pub fn part_2_example_test() {
  day5.part2("data/day5_example.txt")
  |> should.equal(Ok(123))
}

pub fn part_2_exercise_test() {
  day5.part2("data/day5_exercise.txt")
  |> should.equal(Ok(6370))
}
