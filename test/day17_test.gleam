import day17
import gleeunit/should

pub fn part_1_example_test() {
  day17.part1("data/day17_example.txt")
  |> should.equal(Ok("4,6,3,5,6,3,5,2,1,0"))
}

pub fn part_1_exercise_test() {
  day17.part1("data/day17_exercise.txt")
  |> should.equal(Ok("5,1,3,4,3,7,2,1,7"))
}
