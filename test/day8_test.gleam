import day8
import gleeunit/should

pub fn part_1_example_test() {
  day8.part1("data/day8_example.txt")
  |> should.equal(Ok(14))
}

pub fn part_1_exercise_test() {
  day8.part1("data/day8_exercise.txt")
  |> should.equal(Ok(361))
}

// pub fn part_2_example_test() {
//   day8.part2("data/day8_example.txt")
//   |> should.equal(Ok(0))
// }

// pub fn part_2_exercise_test() {
//   day8.part2("data/day8_exercise.txt")
//   |> should.equal(Ok(0))
// }
