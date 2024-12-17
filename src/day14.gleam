import error
import gleam/bit_array
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/set
import gleam/string
import gleam/string_tree
import gleam/yielder
import simplifile
import util

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

fn move_robot(
  robot: #(#(Int, Int), #(Int, Int)),
  cols: Int,
  rows: Int,
  iterations: Int,
) -> #(Int, Int) {
  let #(#(px, py), #(vx, vy)) = robot
  #(
    util.int_modulo(px + { vx * iterations }, rows),
    util.int_modulo(py + { vy * iterations }, cols),
  )
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

fn render_map(robots: List(#(Int, Int)), cols: Int, rows: Int) -> String {
  let robots =
    robots
    |> set.from_list
  list.range(0, rows)
  |> list.map(fn(y) {
    list.range(0, cols)
    |> list.map(fn(x) {
      case set.contains(robots, #(x, y)) {
        True -> "#"
        False -> "."
      }
    })
    |> string_tree.from_strings
  })
  |> string_tree.join("")
  |> string_tree.to_string
}

pub fn part2(filepath: String) -> Result(Int, error.AocError) {
  let entropy_threshold = 500
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(error.ReadError),
  )

  use #(#(cols, rows), robots) <- result.try(parse_input(content))

  robots
  |> yielder.iterate(fn(robots) {
    list.map(robots, fn(r) {
      let #(_, velocity) = r
      #(move_robot(r, rows, cols, 1), velocity)
    })
  })
  |> yielder.take_while(fn(robots) {
    let size =
      robots
      |> list.map(pair.first)
      |> render_map(cols, rows)
      |> util.compress_string
      |> bit_array.byte_size

    size > entropy_threshold
  })
  |> yielder.length
  |> Ok
}
