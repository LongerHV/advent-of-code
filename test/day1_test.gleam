import day1
import gleeunit/should

pub fn part_1_example_test() {
  day1.part1("data/day1_example.txt")
  |> should.equal(11)
}

pub fn part_1_exercise_test() {
  day1.part1("data/day1_exercise.txt")
  |> should.equal(2742123)
}

pub fn part_2_example_test() {
  day1.part2("data/day1_example.txt")
  |> should.equal(31)
}

pub fn part_2_exercise_test() {
  day1.part2("data/day1_exercise.txt")
  |> should.equal(21328497)
}
