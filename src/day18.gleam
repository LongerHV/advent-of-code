import error.{type AocError, NilError, ParseError}
import gleam/dict
import gleam/float
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/set
import gleam/string
import simplifile

fn parse_row(in: String) -> Result(#(Int, Int), AocError) {
  case in |> string.split(",") {
    [x, y] -> {
      use x <- result.try(x |> int.parse |> result.map_error(NilError))
      use y <- result.try(y |> int.parse |> result.map_error(NilError))
      Ok(#(x, y))
    }
    _ -> Error(ParseError("Invalid input"))
  }
}

fn parse_file(in: String) {
  use #(a, b) <- result.try(case in |> string.trim |> string.split("\n\n") {
    [a, b] -> Ok(#(a, b))
    _ -> Error(ParseError("Invalid input"))
  })
  use #(x, y, take) <- result.try(case a |> string.split(",") {
    [x, y, z] -> {
      use x <- result.try(x |> int.parse |> result.map_error(NilError))
      use y <- result.try(y |> int.parse |> result.map_error(NilError))
      use z <- result.try(z |> int.parse |> result.map_error(NilError))
      Ok(#(x, y, z))
    }
    _ -> Error(ParseError("Invalid input"))
  })
  use walls <- result.try(
    b
    |> string.split("\n")
    |> list.map(parse_row)
    |> result.all,
  )
  Ok(#(#(x, y), walls |> list.take(take) |> set.from_list))
}

fn calculate_distance(from: #(Int, Int), to: #(Int, Int)) -> Float {
  let #(x1, y1) = from
  let #(x2, y2) = to
  let dx = x2 - x1 |> int.to_float
  let dy = y2 - y1 |> int.to_float
  case float.square_root({ dx *. dx } +. { dy *. dy }) {
    Ok(distance) -> distance
    _ -> panic as "Invalid distance"
  }
}

fn calculate_distances(
  nodes: List(#(Int, Int)),
  target: #(Int, Int),
) -> dict.Dict(#(Int, Int), Float) {
  nodes
  |> list.map(fn(node) {
    let distance = calculate_distance(node, target)
    #(node, distance)
  })
  |> dict.from_list
}

fn a_star(
  queue: List(#(Int, Int)),
  visited: dict.Dict(#(Int, Int), Int),
  distances: dict.Dict(#(Int, Int), Float),
) {
  todo
}

fn find_nodes(
  rows: Int,
  cols: Int,
  walls: set.Set(#(Int, Int)),
) -> List(#(Int, Int)) {
  list.range(0, rows)
  |> list.map(fn(y) {
    list.range(0, cols)
    |> list.map(fn(x) { #(x, y) })
  })
  |> list.flatten
  |> list.filter(fn(node) { !set.contains(walls, node) })
}

pub fn part1(filepath: String) -> Result(Int, AocError) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(error.ReadError),
  )
  use #(final, walls) <- result.try(parse_file(content))
  let cols = final.0 + 1
  let rows = final.1 + 1
  let nodes = find_nodes(rows, cols, walls)
  let distances = calculate_distances(nodes, final)

  todo
}
