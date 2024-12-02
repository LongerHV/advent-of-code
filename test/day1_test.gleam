import day1
import gleeunit/should

pub fn part_1_example_test() {
  day1.part1("data/day1_example.txt")
  |> should.equal(Ok(11))
}

pub fn part_1_exercise_test() {
  day1.part1("data/day1_exercise.txt")
  |> should.equal(Ok(2742123))
}

pub fn part_2_example_test() {
  day1.part2("data/day1_example.txt")
  |> should.equal(Ok(31))
}

pub fn part_2_exercise_test() {
  day1.part2("data/day1_exercise.txt")
  |> should.equal(Ok(21328497))
}
