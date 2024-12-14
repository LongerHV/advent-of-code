import day7
import gleeunit/should

pub fn part_1_example_test() {
  day7.part1("data/day7_example.txt")
  |> should.equal(Ok(3749))
}

pub fn part_1_exercise_test() {
  day7.part1("data/day7_exercise.txt")
  |> should.equal(Ok(2_314_935_962_622))
}

pub fn part_2_example_test() {
  day7.part2("data/day7_example.txt")
  |> should.equal(Ok(11_387))
}

pub fn part_2_exercise_test() {
  day7.part2("data/day7_exercise.txt")
  |> should.equal(Ok(401_477_450_831_495))
}
