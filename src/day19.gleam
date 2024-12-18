import error.{type AocError, ParseError}
import gleam/bool
import gleam/function
import gleam/int
import gleam/list
import gleam/otp/task
import gleam/result
import gleam/string
import gleam/yielder
import memo
import simplifile

fn parse_input(in: String) -> Result(#(List(String), List(String)), AocError) {
  use #(a, b) <- result.try(case in |> string.trim |> string.split("\n\n") {
    [a, b] -> Ok(#(a, b))
    _ -> Error(ParseError("Invalid input"))
  })
  let patterns = a |> string.split(", ")
  let designs = b |> string.split("\n")
  Ok(#(patterns, designs))
}

fn is_valid(design: String, patterns: List(String), cache) -> Bool {
  use <- memo.memoize(cache, design)
  use <- bool.lazy_guard(when: design == "", return: fn() { True })
  patterns
  |> yielder.from_list
  |> yielder.map(fn(pattern) {
    let pattern_length = pattern |> string.length
    let design_length = design |> string.length
    case string.starts_with(design, pattern) {
      True ->
        is_valid(
          string.slice(
            from: design,
            at_index: pattern_length,
            length: design_length - pattern_length,
          ),
          patterns,
          cache,
        )
      _ -> False
    }
  })
  |> yielder.any(function.identity)
}

pub fn count_valid(design: String, patterns: List(String), cache) -> Int {
  use <- memo.memoize(cache, design)
  use <- bool.lazy_guard(when: design == "", return: fn() { 1 })
  patterns
  |> yielder.from_list
  |> yielder.map(fn(pattern) {
    let pattern_length = pattern |> string.length
    let design_length = design |> string.length
    case string.starts_with(design, pattern) {
      True ->
        count_valid(
          string.slice(
            from: design,
            at_index: pattern_length,
            length: design_length - pattern_length,
          ),
          patterns,
          cache,
        )
      _ -> 0
    }
  })
  |> yielder.to_list
  |> int.sum
}

pub fn part1(filepath: String) -> Result(Int, AocError) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(error.ReadError),
  )
  use #(patterns, designs) <- result.try(parse_input(content))
  use cache <- memo.create()

  designs
  |> list.map(fn(design) {
    task.async(fn() { is_valid(design, patterns, cache) })
  })
  |> task.try_await_all(5000)
  |> result.all
  |> result.map_error(error.AwaitError)
  |> result.map(list.filter(_, function.identity))
  |> result.map(list.length(_))
}

pub fn part2(filepath: String) -> Result(Int, AocError) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(error.ReadError),
  )
  use #(patterns, designs) <- result.try(parse_input(content))
  use cache <- memo.create()

  designs
  |> list.map(fn(design) {
    task.async(fn() { count_valid(design, patterns, cache) })
  })
  |> task.try_await_all(5000)
  |> result.all
  |> result.map_error(error.AwaitError)
  |> result.map(int.sum)
}
