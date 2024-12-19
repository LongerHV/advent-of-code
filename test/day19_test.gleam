import day19
import gleeunit/should

pub fn part_1_example_test() {
  day19.part1("data/day19_example.txt")
  |> should.equal(Ok(6))
}

pub fn part_1_exercise_test() {
  day19.part1("data/day19_exercise.txt")
  |> should.equal(Ok(272))
}

pub fn part_2_example_test() {
  day19.part2("data/day19_example.txt")
  |> should.equal(Ok(16))
}

pub fn part_2_exercise_test() {
  day19.part2("data/day19_exercise.txt")
  |> should.equal(Ok(1_041_529_704_688_380))
}
