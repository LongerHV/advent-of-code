import day7
import gleeunit/should

pub fn part_1_example_test() {
  day7.part1("data/day7_example.txt")
  |> should.equal(Ok(3749))
}

pub fn part_1_exercise_test() {
  day7.part1("data/day7_exercise.txt")
  |> should.equal(Ok(2314935962622))
}

// pub fn part_2_example_test() {
//   day7.part2("data/day7_example.txt")
//   |> should.equal(Ok(0))
// }

// pub fn part_2_exercise_test() {
//   day7.part2("data/day7_exercise.txt")
//   |> should.equal(Ok(0))
// }
