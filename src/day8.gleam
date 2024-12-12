import error
import gleam/dict
import gleam/list
import gleam/option
import gleam/result
import gleam/string
import simplifile

fn pair_add(a: #(Int, Int), b: #(Int, Int)) -> #(Int, Int) {
  let #(x1, y1) = a
  let #(x2, y2) = b
  #(x1 + x2, y1 + y2)
}

fn pair_sub(a: #(Int, Int), b: #(Int, Int)) -> #(Int, Int) {
  let #(x1, y1) = a
  let #(x2, y2) = b
  #(x1 - x2, y1 - y2)
}

fn pair_invert(a: #(Int, Int)) -> #(Int, Int) {
  let #(x, y) = a
  #(-x, -y)
}

fn read_input(filepath: String) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(error.ReadError),
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

fn solve(groups, rows, cols, collect) {
  groups
  |> dict.map_values(with: fn(_, v) {
    v
    |> list.combination_pairs
    |> list.map(collect)
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

pub fn part1(filepath: String) -> Result(Int, error.AocError) {
  use #(groups, #(rows, cols)) <- result.try(read_input(filepath))

  solve(groups, rows, cols, fn(points) {
    let #(p1, p2) = points
    let d = pair_sub(p2, p1)
    [pair_add(p2, d), pair_sub(p1, d)]
  })
}

fn find_nodes(
  start: #(Int, Int),
  delta: #(Int, Int),
  rows: Int,
  cols: Int,
) -> List(#(Int, Int)) {
  let recurse = fn(s) { find_nodes(s, delta, rows, cols) }
  case pair_add(start, delta) {
    #(x, y) as next if x >= 0 && x < rows && y >= 0 && y < cols -> [
      start,
      ..recurse(next)
    ]
    _ -> [start]
  }
}

pub fn part2(filepath: String) -> Result(Int, error.AocError) {
  use #(groups, #(rows, cols)) <- result.try(read_input(filepath))

  solve(groups, rows, cols, fn(points) {
    let #(p1, p2) = points
    let d = pair_sub(p2, p1)
    list.append(
      find_nodes(p1, d, rows, cols),
      find_nodes(p2, pair_invert(d), rows, cols),
    )
  })
}
