import gleam/io
import day2

pub fn main() {
  // let filepath = "data/day2_example.txt"
  let filepath = "data/day2_exercise.txt"
  day2.part2(filepath)
  |> io.debug()
}
