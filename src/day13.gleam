import error
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

type Direction {
  Leading
  Trailing
}

@external(erlang, "string", "trim")
fn erl_trim3(a: String, b: Direction, c: List(UtfCodepoint)) -> String

fn trim_end_chars(a: String, c: String) -> String {
  erl_trim3(a, Trailing, string.to_utf_codepoints(c))
}

fn trim_start_chars(a: String, c: String) -> String {
  erl_trim3(a, Leading, string.to_utf_codepoints(c))
}

fn parse_coordinate(in: String) -> Result(Float, error.AocError) {
  in
  |> trim_start_chars("YX+=")
  |> trim_end_chars(",")
  |> int.parse
  |> result.map(int.to_float)
  |> result.map_error(error.NilError)
}

fn parse_machine(
  in: String,
) -> Result(
  #(#(Float, Float), #(Float, Float), #(Float, Float)),
  error.AocError,
) {
  let _ = case string.split(in, "\n") {
    [a, b, prize] -> {
      use a_movement <- result.try(case string.split(a, " ") {
        ["Button", "A:", x, y] -> {
          use x <- result.try(parse_coordinate(x))
          use y <- result.try(parse_coordinate(y))
          Ok(#(x, y))
        }
        _ -> Error(error.ParseError("Invalid input: " <> a))
      })
      use b_movement <- result.try(case string.split(b, " ") {
        ["Button", "B:", x, y] -> {
          use x <- result.try(parse_coordinate(x))
          use y <- result.try(parse_coordinate(y))
          Ok(#(x, y))
        }
        _ -> Error(error.ParseError("Invalid input: " <> a))
      })
      use prize_position <- result.try(case string.split(prize, " ") {
        ["Prize:", x, y] -> {
          use x <- result.try(parse_coordinate(x))
          use y <- result.try(parse_coordinate(y))
          Ok(#(x, y))
        }
        _ -> Error(error.ParseError("Invalid input: " <> a))
      })
      Ok(#(a_movement, b_movement, prize_position))
    }
    _ -> Error(error.ParseError("Invalid input: " <> in))
  }
}

fn parse_file(
  filepath: String,
) -> Result(
  List(#(#(Float, Float), #(Float, Float), #(Float, Float))),
  error.AocError,
) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(error.ReadError),
  )

  content
  |> string.trim
  |> string.split("\n\n")
  |> list.map(parse_machine)
  |> result.all
}

fn solve_machine(machine) {
  let #(#(ax, ay), #(bx, by), #(prize_x, prize_y)) = machine

  // This is where the magic happens ( ͡° ͜ʖ ͡°)
  let b =
    { { ay *. prize_x } -. { ax *. prize_y } }
    /. { { ay *. bx } -. { ax *. by } }
  let a = { prize_x -. { bx *. b } } /. ax

  case a == float.floor(a) && b == float.floor(b) {
    True -> { 3.0 *. a } +. b
    False -> 0.0
  }
  |> float.round
}

pub fn part1(filepath: String) -> Result(Int, error.AocError) {
  use machines <- result.try(parse_file(filepath))

  machines
  |> list.map(solve_machine)
  |> int.sum
  |> Ok
}
