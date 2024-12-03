import day3
import gleeunit/should

pub fn part_1_example_test() {
  day3.part1("data/day3_example.txt")
  |> should.equal(Ok(161))
}

pub fn part_1_exercise_test() {
  day3.part1("data/day3_exercise.txt")
  |> should.equal(Ok(162_813_399))
}

pub fn part_2_example_test() {
  day3.part2("data/day3_example2.txt")
  |> should.equal(Ok(48))
}

pub fn part_2_exercise_test() {
  day3.part2("data/day3_exercise.txt")
  |> should.equal(Ok(53_783_319))
}
