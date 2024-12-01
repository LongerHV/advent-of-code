import gleam/io
import day1

pub fn main() {
  let filepath = "data/day1_exercise.txt"
  // let filepath = "data/day1_example.txt"
  day1.part2(filepath)
  |> io.debug()
}
