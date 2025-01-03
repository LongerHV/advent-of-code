import error.{type AocError, NilError, ParseError}
import gleam/bool
import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/pair
import gleam/result
import gleam/set.{type Set}
import gleam/string
import parallel
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

fn find_shortcuts(
  path: dict.Dict(Point, Int),
  threshold: Int,
  cheat: fn(Int, Point) -> List(option.Option(Int)),
) -> List(Int) {
  path
  |> dict.keys
  |> parallel.map(group_by: fn(p) { p.0 % 16 }, with: fn(pos) {
    let assert Ok(current_distance) = dict.get(path, pos)
    cheat(current_distance, pos)
  })
  |> list.flatten
  |> option.values
  |> list.filter(fn(d) { d >= threshold })
}

pub fn find_shortcuts1(path: dict.Dict(Point, Int), threshold: Int) -> List(Int) {
  let step_size = 2
  let directions = list.map(directions, fn(d) { point.mul(d, step_size) })
  find_shortcuts(path, threshold, fn(current_distance, pos) {
    directions
    |> list.map(fn(jump) {
      let p = point.add(pos, jump)
      case dict.get(path, p) {
        Ok(distance) -> Some(distance - current_distance - step_size)
        _ -> None
      }
    })
  })
}

pub fn part1(filepath: String) -> Result(Int, AocError) {
  use distances <- result.try(main(filepath))
  distances
  |> find_shortcuts1(100)
  |> list.length
  |> Ok
}

pub fn find_shortcuts2(path: dict.Dict(Point, Int), threshold: Int) -> List(Int) {
  let max_cheat = 20
  find_shortcuts(path, threshold, fn(current_distance, pos) {
    path
    |> dict.keys
    |> list.map(fn(other) {
      let d = point.sub(other, pos)
      #(other, int.absolute_value(d.0) + int.absolute_value(d.1))
    })
    |> list.filter(fn(other) { other.1 <= max_cheat })
    |> list.map(fn(x) {
      let #(other, saved) = x
      case dict.get(path, other) {
        Ok(distance) -> Some(distance - current_distance - saved)
        _ -> None
      }
    })
  })
}

pub fn part2(filepath: String) -> Result(Int, AocError) {
  use distances <- result.try(main(filepath))
  distances
  |> find_shortcuts2(100)
  |> list.length
  |> Ok
}
