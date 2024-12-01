import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

fn read_file(filepath: String) -> List(List(String)){
  let contents = case simplifile.read(filepath) {
    Ok(text) -> text
    Error(_) -> panic
  }
  contents
  |> string.trim()
  |> string.split("\n")
  |> list.map(fn(in) { string.split(in, "   ") })
}

fn parse_int_tuple(in: List(String)) -> Result(List(Int), Nil) {
  in
  |> list.map(int.parse)
  |> result.all
}

pub fn part1(filepath: String) -> Int {
  read_file(filepath)
  |> list.transpose()
  |> list.map(parse_int_tuple)
  |> result.all
  |> result.unwrap([])
  |> list.map(fn(in) { list.sort(in, by: int.compare) })
  |> list.transpose()
  |> list.map(fn(in) {
    case in {
      [a, b] -> #(a, b)
      _ -> panic
    }
  })
  |> list.map(fn(in) { int.absolute_value(in.0 - in.1) })
  |> int.sum()
}

pub fn part2(filepath: String) -> Int {
  read_file(filepath)

  0
}
