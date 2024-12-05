import gleam/dict
import gleam/function
import gleam/int
import gleam/list
import gleam/order
import gleam/pair
import gleam/result
import gleam/set
import gleam/string
import simplifile

pub type DayError {
  ReadError(simplifile.FileError)
  NilError(Nil)
}

fn list_at(l: List(any), index: Int) {
  case l {
    [element, ..] if index == 0 -> element
    [_, ..rest] -> list_at(rest, index - 1)
    _ -> panic
  }
}

fn list_mid(l: List(typevar)) -> typevar {
  list_at(l, list.length(l) / 2)
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

fn make_indexes_dict(list: List(any)) -> dict.Dict(any, Int) {
  list
  |> list.index_map(fn(element, index) { #(element, index) })
  |> dict.from_list
}

fn check_rule(rule: #(Int, Int), indexes) -> Result(Bool, Nil) {
  let #(a, b) = rule
  use a_index <- result.try(dict.get(indexes, a))
  use b_index <- result.try(dict.get(indexes, b))
  Ok(a_index < b_index)
}

fn find_applicable_rules(
  page: Int,
  pages: set.Set(Int),
  rules_left: dict.Dict(Int, List(#(Int, Int))),
  rules_right: dict.Dict(Int, List(#(Int, Int))),
) -> List(#(Int, Int)) {
  let filter_rules = fn(rules, pair_element) {
    rules
    |> dict.get(page)
    |> result.unwrap([])
    |> list.filter(fn(r) { set.contains(pages, pair_element(r)) })
  }
  list.append(
    filter_rules(rules_left, pair.second),
    filter_rules(rules_right, pair.first),
  )
}

pub fn part1(filepath: String) -> Result(Int, DayError) {
  use #(rules, edits) <- result.try(read_file(filepath))
  let rules_by_first = list.group(rules, by: pair.first)
  let rules_by_second = list.group(rules, by: pair.second)

  edits
  |> list.map(fn(edit) {
    let page_set = set.from_list(edit)
    let page_indexes = make_indexes_dict(edit)
    let is_good =
      edit
      |> list.map(fn(page) {
        page
        |> find_applicable_rules(page_set, rules_by_first, rules_by_second)
        |> list.map(check_rule(_, page_indexes))
        |> result.all
        |> result.map(list.all(_, function.identity))
      })
      |> result.all
      |> result.map(list.all(_, function.identity))

    case is_good {
      Ok(True) -> edit
      _ -> []
    }
  })
  |> list.filter(fn(l) { !list.is_empty(l) })
  |> list.map(list_mid)
  |> int.sum
  |> Ok
}

pub fn part2(filepath: String) -> Result(Int, DayError) {
  use #(rules, edits) <- result.try(read_file(filepath))
  let rules_by_first = list.group(rules, by: pair.first)
  let rules_by_second = list.group(rules, by: pair.second)
  let rules_set = set.from_list(rules)

  let fixup = fn(edit: List(Int)) -> List(Int) {
    edit
    |> list.sort(fn(a, b) {
      case set.contains(rules_set, #(a, b)), set.contains(rules_set, #(b, a)) {
        True, False -> order.Lt
        False, True -> order.Gt
        _, _ -> panic
      }
    })
  }

  edits
  |> list.map(fn(edit) {
    let page_set = set.from_list(edit)
    let page_indexes = make_indexes_dict(edit)
    let is_good =
      edit
      |> list.map(fn(page) {
        page
        |> find_applicable_rules(page_set, rules_by_first, rules_by_second)
        |> list.map(check_rule(_, page_indexes))
        |> result.all
        |> result.map(list.all(_, function.identity))
      })
      |> result.all
      |> result.map(list.all(_, function.identity))

    case is_good {
      Ok(False) -> fixup(edit)
      _ -> []
    }
  })
  |> list.filter(fn(l) { !list.is_empty(l) })
  |> list.map(list_mid)
  |> int.sum
  |> Ok
}
