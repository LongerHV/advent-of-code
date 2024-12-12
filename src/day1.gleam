import error
import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import simplifile

fn read_file(filepath: String) -> Result(List(List(Int)), error.AocError) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(error.ReadError),
  )

  content
  |> string.trim()
  |> string.split("\n")
  |> list.map(fn(in) { string.split(in, "   ") })
  |> list.map(map_parse_int)
  |> result.all
}

fn map_parse_int(in: List(String)) -> Result(List(Int), error.AocError) {
  in
  |> list.map(int.parse)
  |> result.all
  |> result.map_error(error.NilError)
}

fn convert_to_tuple(in: List(typevar)) -> Result(#(typevar, typevar), error.AocError) {
  case in {
    [a, b] -> Ok(pair.new(a, b))
    _ -> Nil |> Error |> result.map_error(error.NilError)
  }
}

fn map_convert_to_tuple(
  in: List(List(typevar)),
) -> Result(List(#(typevar, typevar)), error.AocError) {
  in
  |> list.map(convert_to_tuple)
  |> result.all
}

fn distance(in: #(Int, Int)) -> Int {
  int.absolute_value(pair.first(in) - pair.second(in))
}

pub fn part1(filepath: String) -> Result(Int, error.AocError) {
  use data <- result.try(read_file(filepath))

  data
  |> list.transpose
  |> list.map(list.sort(_, by: int.compare))
  |> list.transpose
  |> Ok
  |> result.then(map_convert_to_tuple)
  |> result.map(list.map(_, distance))
  |> result.map(int.sum)
}

pub fn part2(filepath: String) -> Result(Int, error.AocError) {
  let data =
    filepath
    |> read_file()
    |> result.map(list.transpose)
    |> result.then(convert_to_tuple)

  use #(a, b) <- result.try(data)

  a
  |> list.map(fn(val) { val * list.count(b, fn(v) { val == v }) })
  |> int.sum()
  |> Ok
}
