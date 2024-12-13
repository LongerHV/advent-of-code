import day13
import gleeunit/should

pub fn part_1_example_test() {
  day13.part1("data/day13_example.txt")
  |> should.equal(Ok(480))
}

pub fn part_1_exercise_test() {
  day13.part1("data/day13_exercise.txt")
  |> should.equal(Ok(37_680))
}

pub fn part_2_example_test() {
  day13.part2("data/day13_example.txt")
  |> should.equal(Ok(875_318_608_908))
}

pub fn part_2_exercise_test() {
  day13.part2("data/day13_exercise.txt")
  |> should.equal(Ok(87_550_094_242_995))
}
