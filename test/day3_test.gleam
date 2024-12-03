import day3
import gleeunit/should

pub fn part_1_example_test() {
  day3.part1("data/day3_example.txt")
  |> should.equal(Ok(161))
}

pub fn part_1_exercise_test() {
  day3.part1("data/day3_exercise.txt")
  |> should.equal(Ok(162813399))
}

// pub fn part_2_example_test() {
//   day3.part2("data/day3_example.txt")
//   |> should.equal(Ok(0))
// }
//
// pub fn part_2_exercise_test() {
//   day3.part2("data/day3_exercise.txt")
//   |> should.equal(Ok(0))
// }
