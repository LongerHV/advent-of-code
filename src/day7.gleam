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

pub fn check_equation(result: Int, current: Int, numbers: List(Int)) -> Bool {
  {
    case current, numbers {
      _, [] -> current == result
      _, [n, ..rest] ->
        check_equation(result, n + current, rest)
        || check_equation(result, n * current, rest)
    }
  }
}

pub fn part1(filepath: String) -> Result(Int, DayError) {
  use data <- result.try(read_input(filepath))

  data
  |> list.map(fn(x) {
    let #(result, numbers) = x
    case check_equation(result, 0, numbers) {
      True -> result
      False -> 0
    }
  })
  |> int.sum
  |> Ok
}
