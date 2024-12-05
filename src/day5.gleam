import gleam/int
import gleam/list
import gleam/order
import gleam/result
import gleam/set
import gleam/string
import simplifile

pub type DayError {
  ReadError(simplifile.FileError)
  NilError(Nil)
}

fn read_file(filepath: String) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(ReadError),
  )

  let assert [rules_content, edits_content] = string.split(content, on: "\n\n")

  use rules <- result.try(
    rules_content
    |> string.trim
    |> string.split(on: "\n")
    |> list.map(fn(s) {
      case string.split(s, on: "|") {
        [a, b] -> {
          use a <- result.try(int.parse(a))
          use b <- result.try(int.parse(b))
          Ok(#(a, b))
        }
        _ -> Error(Nil)
      }
    })
    |> result.all
    |> result.map_error(NilError),
  )

  use edits <- result.try(
    edits_content
    |> string.trim
    |> string.split(on: "\n")
    |> list.map(fn(s) {
      s
      |> string.split(on: ",")
      |> list.map(int.parse)
      |> result.all
    })
    |> result.all
    |> result.map_error(NilError),
  )

  Ok(#(rules, edits))
}

fn list_at(list: List(any), index: Int) {
  case list {
    [element, ..] if index == 0 -> element
    [_, ..rest] -> list_at(rest, index - 1)
    _ -> panic
  }
}

fn list_mid(list: List(typevar)) -> typevar {
  list_at(list, list.length(list) / 2)
}

fn fixup(edit: List(Int), rules: set.Set(#(Int, Int))) -> List(Int) {
  edit
  |> list.sort(fn(a, b) {
    case set.contains(rules, #(a, b)), set.contains(rules, #(b, a)) {
      True, _ -> order.Lt
      _, True -> order.Gt
      _, _ -> panic as "missing rule"
    }
  })
}

fn solve(
  rules: List(#(Int, Int)),
  edits: List(List(Int)),
  compare: fn(List(Int), List(Int)) -> List(Int),
) -> Result(Int, DayError) {
  edits
  |> list.map(fn(edit) {
    let fixed_edit = fixup(edit, set.from_list(rules))
    compare(edit, fixed_edit)
  })
  |> list.filter(fn(l) { !list.is_empty(l) })
  |> list.map(list_mid)
  |> int.sum
  |> Ok
}

pub fn part1(filepath: String) -> Result(Int, DayError) {
  use #(rules, edits) <- result.try(read_file(filepath))
  solve(rules, edits, fn(edit, fixed_edit) {
    case edit == fixed_edit {
      True -> edit
      False -> []
    }
  })
}

pub fn part2(filepath: String) -> Result(Int, DayError) {
  use #(rules, edits) <- result.try(read_file(filepath))
  solve(rules, edits, fn(edit, fixed_edit) {
    case edit == fixed_edit {
      True -> []
      False -> fixed_edit
    }
  })
}
