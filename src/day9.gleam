import gleam/io
import gleam/int
import gleam/list
import gleam/option
import gleam/pair
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

fn find_middle(
  l: List(option.Option(Int)),
  nones_on_left: Int,
  somes_on_right: Int,
) -> Int {
  let mid = list.length(l) / 2
  let #(a, b) = l |> list.split(mid)
  case
    nones_on_left + list.count(a, option.is_none),
    somes_on_right + list.count(b, option.is_some)
  {
    nones, somes if nones == somes -> mid
    nones, somes if nones > somes -> find_middle(a, nones_on_left, somes)

    nones, _ -> mid + find_middle(b, nones, somes_on_right)
  }
}

fn checksum(blocks: List(option.Option(Int))) -> Int {
  blocks
  |> option.all
  |> option.unwrap([])
  |> list.index_map(int.multiply)
  |> int.sum
}

pub fn part1(filepath: String) -> Result(Int, DayError) {
  use content <- result.try(read_file(filepath))

  let layout =
    content
    |> list.index_map(fn(count, id) {
      case id {
        _ if id % 2 == 0 -> list.repeat(option.Some(id / 2), count)
        _ -> list.repeat(option.None, count)
      }
    })
    |> list.flatten

  let mid = find_middle(layout, 0, 0)
  let #(part1, part2) =
    layout
    |> list.split(mid)

  let segments_to_move =
    part2
    |> list.reverse
    |> list.filter(option.is_some)

  list.fold(part1, #(segments_to_move, []), fn(acc, current) {
    let #(to_move, result) = acc
    case to_move, current {
      [next_to_move, ..rest], option.None -> #(
        rest,
        list.append(result, [next_to_move]),
      )
      _, option.Some(_) as b -> #(to_move, list.append(result, [b]))
      _, _ -> #(to_move, result)
    }
  })
  |> pair.second
  |> checksum
  |> Ok
}
