import error
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

fn parse_vector(in: String) -> Result(#(Int, Int), error.AocError) {
  case string.split(in, "=") {
    [_, s] -> {
      case string.split(s, ",") {
        [x, y] -> {
          use x <- result.try(
            x |> int.parse |> result.map_error(error.NilError),
          )
          use y <- result.try(
            y |> int.parse |> result.map_error(error.NilError),
          )
          Ok(#(x, y))
        }
        _ -> Error(error.ParseError("Invalid input"))
      }
    }
    _ -> Error(error.ParseError("Invalid input"))
  }
}

fn parse_robot(
  in: String,
) -> Result(#(#(Int, Int), #(Int, Int)), error.AocError) {
  case string.split(in, " ") {
    [p, v] -> {
      use p <- result.try(parse_vector(p))
      use v <- result.try(parse_vector(v))
      Ok(#(p, v))
    }
    _ -> Error(error.ParseError("Invalid input"))
  }
}

fn parse_input(content: String) {
  case
    content
    |> string.trim
    |> string.split("\n\n")
  {
    [first, others] -> {
      use #(rows, cols) <- result.try(case string.split(first, " ") {
        [rows, cols] -> {
          use rows <- result.try(
            rows |> int.parse |> result.map_error(error.NilError),
          )
          use cols <- result.try(
            cols |> int.parse |> result.map_error(error.NilError),
          )
          Ok(#(rows, cols))
        }
        _ -> Error(error.ParseError("Invalid input"))
      })

      use robots <- result.try(
        others
        |> string.split("\n")
        |> list.map(parse_robot)
        |> result.all,
      )

      Ok(#(#(rows, cols), robots))
    }
    _ -> Error(error.ParseError("Invalid input"))
  }
}

fn mod(a, b) {
  case a % b {
    r if r >= 0 -> r
    r -> b + r
  }
}

fn move_robot(
  robot: #(#(Int, Int), #(Int, Int)),
  cols: Int,
  rows: Int,
  iterations: Int,
) -> #(Int, Int) {
  let #(#(px, py), #(vx, vy)) = robot
  #(mod(px + { vx * iterations }, rows), mod(py + { vy * iterations }, cols))
}

fn quadrants(cols: Int, rows: Int) -> List(#(#(Int, Int), #(Int, Int))) {
  [
    #(#(0, 0), #(cols / 2 - 1, rows / 2 - 1)),
    #(#(cols / 2 + 1, 0), #(cols - 1, rows / 2 - 1)),
    #(#(0, rows / 2 + 1), #(cols / 2 - 1, rows - 1)),
    #(#(cols / 2 + 1, rows / 2 + 1), #(cols - 1, rows - 1)),
  ]
}

pub fn part1(filepath: String) -> Result(Int, error.AocError) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(error.ReadError),
  )

  use #(#(cols, rows), robots) <- result.try(parse_input(content))
  let robots = list.map(robots, move_robot(_, rows, cols, 100))

  quadrants(cols, rows)
  |> list.map(fn(quadrant) {
    let #(#(x1, y1), #(x2, y2)) = quadrant
    robots
    |> list.filter(fn(robot) {
      let #(x, y) = robot
      x >= x1 && x <= x2 && y >= y1 && y <= y2
    })
    |> list.length
  })
  |> int.product
  |> Ok
}