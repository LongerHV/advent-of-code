import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type DayError {
  ReadError(simplifile.FileError)
  NilError(Nil)
}

fn read_input(filepath: String) -> Result(List(#(Int, List(Int))), DayError) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(ReadError),
  )

  content
  |> string.trim
  |> string.split(on: "\n")
  |> list.map(string.split(_, on: " "))
  |> list.map(fn(l) {
    case l {
      [result, ..numbers] -> {
        use numbers <- result.try(
          numbers
          |> list.map(int.parse)
          |> result.all,
        )
        use result <- result.try(
          result
          |> string.slice(at_index: 0, length: string.length(result) - 1)
          |> int.parse,
        )

        Ok(#(result, numbers))
      }
      _ -> Error(Nil)
    }
  })
  |> result.all
  |> result.map_error(NilError)
}

pub fn check_equation(
  combine_functions: List(fn(Int, Int) -> Int),
  result: Int,
  current: Int,
  numbers: List(Int),
) -> Bool {
  let recurse = fn(c, n) { check_equation(combine_functions, result, c, n) }
  {
    case current, numbers {
      _, [] -> current == result
      _, [n, ..rest] ->
        list.fold(combine_functions, False, fn(acc, combine) {
          acc || recurse(combine(current, n), rest)
        })
    }
  }
}

fn solve(data, combine_functions) {
  data
  |> list.map(fn(x) {
    let #(result, numbers) = x
    case check_equation(combine_functions, result, 0, numbers) {
      True -> result
      False -> 0
    }
  })
  |> int.sum
}

fn int_concat(a: Int, b: Int) -> Int {
  { int.to_string(a) <> int.to_string(b) }
  |> int.parse
  |> result.unwrap(0)
}

pub fn part1(filepath: String) -> Result(Int, DayError) {
  use data <- result.try(read_input(filepath))

  data
  |> solve([int.add, int.multiply])
  |> Ok
}

pub fn part2(filepath: String) -> Result(Int, DayError) {
  use data <- result.try(read_input(filepath))

  data
  |> solve([int.add, int.multiply, int_concat])
  |> Ok
}
