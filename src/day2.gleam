import gleam/function
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import simplifile

type Array =
  List(Row)

type Row =
  List(Int)

type Pairs =
  List(#(Int, Int))

pub type Error {
  ReadError(simplifile.FileError)
  NilError(Nil)
}

fn read_file(filepath: String) -> Result(Array, Error) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(ReadError),
  )

  content
  |> string.trim
  |> string.split("\n")
  |> list.map(string.split(_, " "))
  |> list.map(map_parse_int)
  |> result.all
}

fn map_parse_int(in: List(String)) -> Result(List(Int), Error) {
  in
  |> list.map(int.parse)
  |> result.all
  |> result.map_error(NilError)
}

fn is_ascending(row: Pairs) -> Bool {
  row
  |> list.map(fn(p) {
    let diff = pair.first(p) - pair.second(p)
    diff > 0 && diff < 4
  })
  |> list.all(function.identity)
}

fn is_descending(row: Pairs) -> Bool {
  row
  |> list.map(fn(p) {
    let diff = pair.second(p) - pair.first(p)
    diff > 0 && diff < 4
  })
  |> list.all(function.identity)
}

pub fn part1(filepath: String) -> Result(Int, Error) {
  use data <- result.try(read_file(filepath))

  data
  |> list.filter(fn(row) {
    let windowed_row = list.window_by_2(row)
    is_ascending(windowed_row) || is_descending(windowed_row)
  })
  |> list.length
  |> Ok
}

fn generate_slices(in: Row) -> List(Row) {
  list.range(from: 1, to: list.length(in))
  |> list.map(fn(i) { list.append(list.take(in, i - 1), list.drop(in, i)) })
}

fn is_safe_with_toleration(in: Row, check: fn(Pairs) -> Bool) -> Bool {
  in
  |> generate_slices
  |> list.map(fn(slice) {
    slice
    |> list.window_by_2
    |> check
  })
  |> list.any(function.identity)
}

pub fn part2(filepath: String) -> Result(Int, Error) {
  use data <- result.try(read_file(filepath))

  data
  |> list.filter(fn(row) {
    let windowed_row = list.window_by_2(row)
    is_ascending(windowed_row)
    || is_descending(windowed_row)
    || is_safe_with_toleration(row, is_ascending)
    || is_safe_with_toleration(row, is_descending)
  })
  |> list.length
  |> Ok
}
