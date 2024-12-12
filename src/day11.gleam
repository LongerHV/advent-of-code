import error
import gleam/bool
import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import rememo/memo
import simplifile

@external(erlang, "math", "log10")
fn log10(x: Float) -> Float

fn count_digits(x: Int) -> Int {
  case x {
    0 -> 1
    _ -> { x |> int.to_float |> log10 |> float.truncate } + 1
  }
}

fn read_file(filepath: String) -> Result(List(Int), error.AocError) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(error.ReadError),
  )
  content
  |> string.trim
  |> string.split(" ")
  |> list.map(int.parse)
  |> result.all
  |> result.map_error(error.NilError)
}

fn count_stones(stone: Int, depth: Int, cache) -> Int {
  use <- memo.memoize(cache, #(stone, depth))
  use <- bool.lazy_guard(depth <= 0, fn() { 1 })

  let len = count_digits(stone)
  let next = case stone {
    0 -> [1]
    _ if len % 2 == 0 -> {
      let s = int.to_string(stone)
      let a = s |> string.drop_end(len / 2) |> int.parse |> result.unwrap(0)
      let b = s |> string.drop_start(len / 2) |> int.parse |> result.unwrap(0)
      [a, b]
    }
    n -> [n * 2024]
  }

  next
  |> list.map(count_stones(_, depth - 1, cache))
  |> int.sum
}

fn solve(stones: List(Int), iterations: Int) {
  use cache <- memo.create()

  stones
  |> list.map(count_stones(_, iterations, cache))
  |> int.sum
}

pub fn part1(filepath: String) -> Result(Int, error.AocError) {
  use stones <- result.try(read_file(filepath))
  stones
  |> solve(25)
  |> Ok
}

pub fn part2(filepath: String) -> Result(Int, error.AocError) {
  use stones <- result.try(read_file(filepath))
  stones
  |> solve(75)
  |> Ok
}
