import error.{type AocError, NilError, ParseError}
import gleam/bool
import gleam/dict
import gleam/list
import gleam/option.{None, Some}
import gleam/pair
import gleam/result
import gleam/set.{type Set}
import gleam/string
import point.{type Point}
import simplifile

const directions = [#(0, 1), #(1, 0), #(0, -1), #(-1, 0)]

fn parse_input(
  in: String,
) -> Result(#(#(Int, Int), #(Int, Int), Set(#(Int, Int))), AocError) {
  let groups =
    in
    |> string.trim
    |> string.split("\n")
    |> list.index_map(fn(row, j) {
      row
      |> string.to_graphemes
      |> list.index_map(fn(char, i) { #(#(i, j), char) })
    })
    |> list.flatten
    |> list.group(by: pair.second)

  use start <- result.try(
    groups
    |> dict.get("S")
    |> result.then(list.first)
    |> result.map(pair.first)
    |> result.replace_error(ParseError("Didn't find the starting position")),
  )

  use end <- result.try(
    groups
    |> dict.get("E")
    |> result.then(list.first)
    |> result.map(pair.first)
    |> result.replace_error(ParseError("Didn't find the end position")),
  )

  let path =
    groups
    |> dict.get(".")
    |> result.unwrap([])
    |> list.map(pair.first)
    |> set.from_list

  Ok(#(start, end, path))
}

fn find_neighbours(point: Point, others: Set(Point)) -> List(#(Int, Int)) {
  directions
  |> list.map(fn(direction) {
    let neighbour =
      point
      |> point.add(direction)
    case set.contains(others, neighbour) {
      True -> Some(neighbour)
      False -> None
    }
  })
  |> option.values
}

fn compute_distances(
  length: Int,
  prev: Point,
  current: Point,
  end: Point,
  path: Set(Point),
) -> List(#(Point, Int)) {
  use <- bool.lazy_guard(when: current == end, return: fn() {
    [#(current, length)]
  })
  let recurse = fn(next) {
    compute_distances(length + 1, current, next, end, path)
  }
  let assert Ok(next) =
    current
    |> find_neighbours(path)
    |> list.find(fn(p) { p != prev })
  [#(current, length), ..recurse(next)]
}

pub fn main(filepath: String) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(error.ReadError),
  )
  use #(start, end, path) <- result.try(parse_input(content))
  use first_step <- result.try(
    find_neighbours(start, path) |> list.first |> result.map_error(NilError),
  )
  [
    #(start, 0),
    ..compute_distances(1, start, first_step, end, set.insert(path, end))
  ]
  |> dict.from_list
  |> Ok
}

pub fn find_shortcuts1(distances: dict.Dict(#(Int, Int), Int)) -> List(Int) {
  let step_size = 2
  let directions = list.map(directions, fn(d) { point.mul(d, step_size) })
  distances
  |> dict.keys
  |> list.fold([], fn(acc, pos) {
    let assert Ok(current_distance) = dict.get(distances, pos)
    let shortcuts =
      directions
      |> list.map(fn(jump) {
        let p = point.add(pos, jump)
        case dict.get(distances, p) {
          Ok(distance) -> Some(distance - current_distance)
          _ -> None
        }
      })
    list.append(acc, shortcuts)
  })
  |> option.values
  |> list.map(fn(d) { d - step_size })
  |> list.filter(fn(d) { d > 0 })
}

pub fn part1(filepath: String) -> Result(Int, AocError) {
  use distances <- result.try(main(filepath))
  distances
  |> find_shortcuts1
  |> list.filter(fn(d) { d >= 100 })
  |> list.length
  |> Ok
}
