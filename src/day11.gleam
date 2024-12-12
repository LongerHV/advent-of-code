import error
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import gleam/yielder
import simplifile

const iterations = 25

fn apply_stone_transformation(stone: Int) -> List(Int) {
  let s = int.to_string(stone)
  let len = string.length(s)
  case stone {
    0 -> [1]
    _ if len % 2 == 0 -> {
      let a = s |> string.drop_end(len / 2) |> int.parse |> result.unwrap(0)
      let b = s |> string.drop_start(len / 2) |> int.parse |> result.unwrap(0)
      [a, b]
    }
    n -> [n * 2024]
  }
}

pub fn part1(filepath: String) -> Result(Int, error.AocError) {
  use content <- result.try(
    simplifile.read(filepath) |> result.map_error(error.ReadError),
  )

  use stones <- result.try(
    content
    |> string.trim
    |> string.split(" ")
    |> list.map(int.parse)
    |> result.all
    |> result.map_error(error.NilError),
  )

  stones
  |> yielder.iterate(fn(stones) {
    stones |> list.map(apply_stone_transformation) |> list.flatten
  })
  |> yielder.take(iterations + 1)
  |> yielder.last
  |> result.map(list.length)
  |> result.map_error(error.NilError)
}
