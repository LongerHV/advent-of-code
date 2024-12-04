import gleam/bool
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub type DayError {
  ReadError(simplifile.FileError)
  NilError(Nil)
}

fn count_xmas_in_row(in: List(String)) -> Int {
  in
  |> list.window(4)
  |> list.map(fn(window) {
    case window {
      ["X", "M", "A", "S"] | ["S", "A", "M", "X"] -> 1
      _ -> 0
    }
  })
  |> int.sum
}

fn count_diagonal_xmas(array: List(List(String))) -> Int {
  array
  |> list.window(4)
  |> list.map(fn(v_window) {
    v_window
    |> list.map(list.window(_, 4))
    |> list.transpose
    |> list.map(fn(h_window) {
      {
        case h_window {
          [["X", _, _, _], [_, "M", _, _], [_, _, "A", _], [_, _, _, "S"]] -> 1
          [["S", _, _, _], [_, "A", _, _], [_, _, "M", _], [_, _, _, "X"]] -> 1
          _ -> 0
        }
      }
      + {
        case h_window {
          [[_, _, _, "X"], [_, _, "M", _], [_, "A", _, _], ["S", _, _, _]] -> 1
          [[_, _, _, "S"], [_, _, "A", _], [_, "M", _, _], ["X", _, _, _]] -> 1
          _ -> 0
        }
      }
    })
    |> int.sum
  })
  |> int.sum
}

fn read_array(filepath: String) -> Result(List(List(String)), DayError) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(ReadError),
  )
  content
  |> string.trim_end
  |> string.split("\n")
  |> list.map(string.to_graphemes)
  |> Ok
}

pub fn part1(filepath: String) -> Result(Int, DayError) {
  use array <- result.try(read_array(filepath))

  { array |> list.map(count_xmas_in_row) |> int.sum }
  + { array |> list.transpose |> list.map(count_xmas_in_row) |> int.sum }
  + { array |> count_diagonal_xmas }
  |> Ok
}

pub fn part2(filepath: String) -> Result(Int, DayError) {
  use array <- result.try(read_array(filepath))

  array
  |> list.window(3)
  |> list.map(fn(v_window) {
    v_window
    |> list.map(list.window(_, 3))
    |> list.transpose
    |> list.map(fn(h_window) {
      bool.and(
        {
          case h_window {
            [["M", _, _], [_, "A", _], [_, _, "S"]] -> True
            [["S", _, _], [_, "A", _], [_, _, "M"]] -> True
            _ -> False
          }
        },
        {
          case h_window {
            [[_, _, "M"], [_, "A", _], ["S", _, _]] -> True
            [[_, _, "S"], [_, "A", _], ["M", _, _]] -> True
            _ -> False
          }
        },
      )
    })
    |> list.map(bool.to_int)
    |> int.sum
  })
  |> int.sum
  |> Ok
}
