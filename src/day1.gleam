import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import simplifile

fn read_file(filepath: String) -> Result(List(List(Int)), Nil) {
  let contents = case simplifile.read(filepath) {
    Ok(text) -> text
    Error(_) -> panic
  }
  contents
  |> string.trim()
  |> string.split("\n")
  |> list.map(fn(in) { string.split(in, "   ") })
  |> list.map(parse_int_tuple)
  |> result.all
}

fn parse_int_tuple(in: List(String)) -> Result(List(Int), Nil) {
  in
  |> list.map(int.parse)
  |> result.all
}

fn convert_to_tuple(in: List(typevar)) -> Result(#(typevar, typevar), Nil) {
  case in {
    [a, b] -> Ok(pair.new(a, b))
    _ -> Error(Nil)
  }
}

fn map_convert_to_tuple(
  in: List(List(typevar)),
) -> Result(List(#(typevar, typevar)), Nil) {
  in
  |> list.map(convert_to_tuple)
  |> result.all
}

fn distance(in: #(Int, Int)) -> Int {
  int.absolute_value(pair.first(in) - pair.second(in))
}

pub fn part1(filepath: String) -> Result(Int, Nil) {
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

pub fn part2(filepath: String) -> Result(Int, Nil) {
  let data =
    read_file(filepath)
    |> result.map(list.transpose)
    |> result.then(convert_to_tuple)

  use #(a, b) <- result.try(data)

  a
  |> list.map(fn(val) { val * list.count(b, fn(v) { val == v }) })
  |> int.sum()
  |> Ok
}
