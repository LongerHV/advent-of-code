import gleam/io
import day2

pub fn main() {
  // let filepath = "data/day2_example.txt"
  let filepath = "data/day2_exercise.txt"
  day2.part1(filepath)
  |> io.debug()
}
