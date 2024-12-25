import day24
import gleeunit/should

pub fn part_1_example_test() {
  day24.part1("data/day24_example.txt")
  |> should.equal(Ok(2024))
}

pub fn part_1_exercise_test() {
  day24.part1("data/day24_exercise.txt")
  |> should.equal(Ok(57_632_654_722_854))
}
// pub fn part_2_example_test() {
//   day24.part2("data/day24_example.txt")
//   |> should.equal(Ok(0))
// }

// pub fn part_2_exercise_test() {
//   day24.part2("data/day24_exercise.txt")
//   |> should.equal(Ok(0))
// }
