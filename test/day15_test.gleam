import day15
import gleeunit/should

pub fn part_1_example1_test() {
  day15.part1("data/day15_example1.txt")
  |> should.equal(Ok(2028))
}

pub fn part_1_example2_test() {
  day15.part1("data/day15_example2.txt")
  |> should.equal(Ok(10_092))
}

pub fn part_1_exercise_test() {
  day15.part1("data/day15_exercise.txt")
  |> should.equal(Ok(1_492_518))
}

pub fn part_2_example2_test() {
  day15.part2("data/day15_example2.txt")
  |> should.equal(Ok(9021))
}
