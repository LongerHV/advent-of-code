import day20
import gleam/int
import gleam/list
import gleam/result
import gleeunit/should

pub fn part_1_example_test() {
  day20.main("data/day20_example.txt")
  |> result.map(day20.find_shortcuts1)
  |> result.map(list.sort(_, by: int.compare))
  |> should.equal(
    Ok([
      2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
      4, 4, 4, 6, 6, 8, 8, 8, 8, 10, 10, 12, 12, 12, 20, 36, 38, 40, 64,
    ]),
  )
}

pub fn part_1_exercise_test() {
  day20.part1("data/day20_exercise.txt")
  |> should.equal(Ok(1360))
}

pub fn part_2_example_test() {
  day20.main("data/day20_example.txt")
  |> result.map(day20.find_shortcuts2)
  |> result.map(list.filter(_, fn(d) { d >= 50 }))
  |> result.map(list.length)
  |> should.equal(Ok(285))
}

pub fn part_2_exercise_test() {
  day20.part2("data/day20_exercise.txt")
  |> should.equal(Ok(1_005_476))
}
