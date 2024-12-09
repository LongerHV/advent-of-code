import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import simplifile

pub type DayError {
  ReadError(simplifile.FileError)
  NilError(Nil)
}

fn read_file(filepath: String) -> Result(List(Int), DayError) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(ReadError),
  )

  content
  |> string.trim
  |> string.to_graphemes
  |> list.map(int.parse)
  |> result.all
  |> result.map_error(NilError)
}

fn checksum(blocks: List(Option(Int))) -> Int {
  blocks
  |> option.all
  |> option.unwrap([])
  |> list.index_map(int.multiply)
  |> int.sum
}

fn partition(in: List(Option(Int))) -> List(List(Option(Int))) {
  case in {
    [Some(_), ..] -> {
      let #(a, b) = list.split_while(in, option.is_some)
      list.append([a], partition(b))
    }
    [None, ..] -> {
      let #(a, b) = list.split_while(in, option.is_none)
      let fill = list.repeat([], list.length(a) - 1)
      list.append(fill, partition(b))
    }
    [] -> []
  }
}

pub fn part1(filepath: String) -> Result(Int, DayError) {
  use content <- result.try(read_file(filepath))

  let layout_flat =
    content
    |> list.index_map(fn(count, id) {
      case id % 2 {
        0 -> list.repeat(Some(id / 2), count)
        _ -> list.repeat(None, count)
      }
    })
    |> list.flatten

  let data_size = layout_flat |> list.filter(option.is_some) |> list.length
  let #(left, right) =
    layout_flat
    |> list.split(at: data_size)

  let to_move =
    right
    |> list.reverse
    |> list.filter(option.is_some)
    |> list.map(fn(x) { [x] })

  let left =
    left
    |> partition

  list.interleave([left, to_move])
  |> list.filter(fn(x) { !list.is_empty(x) })
  |> list.flatten
  |> checksum
  |> Ok
}
