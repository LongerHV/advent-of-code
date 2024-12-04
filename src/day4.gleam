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

fn count_diagonal_xmas(in: List(List(String))) -> Int {
  in
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

pub fn part1(filepath: String) -> Result(Int, DayError) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(ReadError),
  )

  let array =
    content
    |> string.trim_end
    |> string.split("\n")
    |> list.map(string.to_graphemes)

  { array |> list.map(count_xmas_in_row) |> int.sum }
  + { array |> list.transpose |> list.map(count_xmas_in_row) |> int.sum }
  + { array |> count_diagonal_xmas }
  |> Ok
}
