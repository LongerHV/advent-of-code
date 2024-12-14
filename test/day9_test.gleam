import day9
import gleeunit/should

pub fn part_1_example_test() {
  day9.part1("data/day9_example.txt")
  |> should.equal(Ok(1928))
}

pub fn part_1_exercise_test() {
  day9.part1("data/day9_exercise.txt")
  |> should.equal(Ok(6_349_606_724_455))
}
// pub fn part_2_example_test() {
//   day9.part2("data/day9_example.txt")
//   |> should.equal(Ok(0))
// }

// pub fn part_2_exercise_test() {
//   day9.part2("data/day9_exercise.txt")
//   |> should.equal(Ok(0))
// }
