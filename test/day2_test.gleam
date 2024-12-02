import day2
import gleeunit/should

pub fn part_1_example_test() {
  day2.part1("data/day2_example.txt")
  |> should.equal(Ok(2))
}

pub fn part_1_exercise_test() {
  day2.part1("data/day2_exercise.txt")
  |> should.equal(Ok(432))
}

// pub fn part_2_example_test() {
//   day2.part2("data/day2_example.txt")
//   |> should.equal(Ok(0))
// }

// pub fn part_2_exercise_test() {
//   day2.part2("data/day2_exercise.txt")
//   |> should.equal(Ok(0))
// }
