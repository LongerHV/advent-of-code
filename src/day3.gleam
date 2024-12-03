import gleam/int
import gleam/list
import gleam/option
import gleam/pair
import gleam/regexp
import gleam/result
import simplifile

pub type DayError {
  ReadError(simplifile.FileError)
  NilError(Nil)
}

pub fn part1(filepath: String) -> Result(Int, DayError) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(ReadError),
  )

  let assert Ok(re) = regexp.from_string("mul\\((\\d\\d?\\d?),(\\d\\d?\\d?)\\)")

  re
  |> regexp.scan(content)
  |> list.map(fn(match) {
    case match.submatches {
      [option.Some(a), option.Some(b)] -> #(a, b)
      _ -> panic
    }
  })
  |> list.map(fn(p) {
    let assert Ok(a) = p |> pair.first |> int.parse
    let assert Ok(b) = p |> pair.second |> int.parse
    #(a, b)
  })
  |> list.map(fn(p) { pair.first(p) * pair.second(p) })
  |> int.sum
  |> Ok
}
