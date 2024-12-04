import day4
import gleeunit/should

pub fn part_1_small_example_test() {
  day4.part1("data/day4_example1.txt")
  |> should.equal(Ok(4))
}

pub fn part_1_example_test() {
  day4.part1("data/day4_example2.txt")
  |> should.equal(Ok(18))
}

pub fn part_1_exercise_test() {
  day4.part1("data/day4_exercise.txt")
  |> should.equal(Ok(2567))
}

// pub fn part_2_example_test() {
//   day4.part2("data/day4_example2.txt")
//   |> should.equal(Ok(0))
// }

// pub fn part_2_exercise_test() {
//   day4.part2("data/day4_exercise.txt")
//   |> should.equal(Ok(0))
// }
