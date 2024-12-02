import gleam/function
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import simplifile

type Array =
  List(List(Int))

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

fn is_ascending(row: List(#(Int, Int))) -> Bool {
  row
  |> list.map(fn(p) {
    let diff = pair.first(p) - pair.second(p)
    diff > 0 && diff < 4
  })
  |> list.all(function.identity)
}

fn is_descending(row: List(#(Int, Int))) -> Bool {
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
  |> list.map(list.window_by_2)
  |> list.filter(fn(x) { is_ascending(x) || is_descending(x) })
  |> list.length
  |> Ok
}
