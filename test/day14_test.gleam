import day14
import gleeunit/should

pub fn part_1_example_test() {
  day14.part1("data/day14_example.txt")
  |> should.equal(Ok(12))
}

pub fn part_1_exercise_test() {
  day14.part1("data/day14_exercise.txt")
  |> should.equal(Ok(231_782_040))
}
// This is slow AF
// pub fn part_2_exercise_test() {
//   day14.part2("data/day14_exercise.txt")
//   |> should.equal(Ok(6475))
// }
