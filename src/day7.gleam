import gleam/int
import gleam/list
import gleam/otp/task
import gleam/result
import gleam/string
import simplifile

pub type DayError {
  ReadError(simplifile.FileError)
  NilError(Nil)
  AwaitError(task.AwaitError)
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
  operators: List(fn(Int, Int) -> Int),
  result: Int,
  current: Int,
  numbers: List(Int),
) -> Bool {
  let recurse = fn(c, n) { check_equation(operators, result, c, n) }
  {
    case current, numbers {
      _, [] -> current == result
      _, [n, ..rest] ->
        list.fold(operators, False, fn(acc, combine) {
          acc || recurse(combine(current, n), rest)
        })
    }
  }
}

fn solve(data, operators) {
  data
  |> list.map(fn(x) {
    task.async(fn() {
      let #(result, numbers) = x
      case check_equation(operators, result, 0, numbers) {
        True -> result
        False -> 0
      }
    })
  })
  |> task.try_await_all(1000)
  |> result.all
  |> result.map(int.sum)
  |> result.map_error(AwaitError)
}

fn count_digits(number: Int) -> Int {
  // This is faster than converting to string
  case number {
    n if n < 10 -> 1
    n if n < 100 -> 2
    n if n < 1000 -> 3
    n -> n |> int.to_string |> string.length
  }
}

fn power_of_ten(exp: Int) -> Int {
  // This is faster than int.power or int.repeat |> int.product
  case exp {
    1 -> 10
    2 -> 100
    3 -> 1000
    e -> e |> list.repeat(10, _) |> int.product
  }
}

fn int_concat(a: Int, b: Int) -> Int {
  let l = b |> count_digits |> power_of_ten
  a * l + b
}

pub fn part1(filepath: String) -> Result(Int, DayError) {
  use data <- result.try(read_input(filepath))

  data
  |> solve([int.add, int.multiply])
}

pub fn part2(filepath: String) -> Result(Int, DayError) {
  use data <- result.try(read_input(filepath))

  data
  |> solve([int.add, int.multiply, int_concat])
}
