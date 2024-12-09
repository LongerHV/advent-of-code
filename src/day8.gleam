import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import simplifile

pub type DayError {
  ReadError(simplifile.FileError)
  NilError(Nil)
}

fn read_input(filepath: String) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(ReadError),
  )

  let lines =
    content
    |> string.trim
    |> string.split(on: "\n")

  let rows = lines |> list.length
  let cols = lines |> list.first |> result.unwrap("") |> string.length

  let antennas =
    lines
    |> list.index_map(fn(line, i) {
      line
      |> string.to_graphemes
      |> list.index_map(fn(char, j) {
        case char {
          "." -> option.None
          c -> option.Some(#(#(i, j), c))
        }
      })
      |> option.values
    })
    |> list.flatten
    |> dict.from_list

  let groups =
    antennas
    |> dict.keys
    |> list.group(by: fn(point) {
      antennas |> dict.get(point) |> result.unwrap("")
    })

  Ok(#(groups, #(rows, cols)))
}

pub fn part1(filepath: String) -> Result(Int, DayError) {
  use #(groups, #(rows, cols)) <- result.try(read_input(filepath))

  groups
  |> dict.map_values(with: fn(_, v) {
    v
    |> list.combination_pairs
    |> list.map(fn(points) {
      let #(#(x1, y1), #(x2, y2)) = points
      let dx = x2 - x1
      let dy = y2 - y1
      [#(x2 + dx, y2 + dy), #(x1 - dx, y1 - dy)]
    })
    |> list.flatten
  })
  |> dict.values
  |> list.flatten
  |> list.unique
  |> list.filter(fn(point) {
    let #(x, y) = point
    x >= 0 && x < rows && y >= 0 && y < cols
  })
  |> list.length
  |> Ok
}
