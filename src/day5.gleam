import gleam/dict
import gleam/function
import gleam/int
import gleam/list
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

pub fn part1(filepath: String) -> Result(Int, DayError) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(ReadError),
  )

  let assert [rules_content, edits_content] =
    content
    |> string.split(on: "\n\n")

  use rules <- result.try(
    rules_content
    |> string.trim
    |> string.split(on: "\n")
    |> list.map(fn(s) {
      use a <- result.try(int.parse(string.slice(s, 0, 2)))
      use b <- result.try(int.parse(string.slice(s, 3, 2)))
      Ok(#(a, b))
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

  let rules_by_first = list.group(rules, by: pair.first)
  let rules_by_second = list.group(rules, by: pair.second)

  edits
  |> list.map(fn(edit) {
    let page_set = set.from_list(edit)
    let page_indexes =
      edit
      |> list.index_map(fn(page, index) { #(page, index) })
      |> dict.from_list
    let is_good =
      edit
      |> list.map(fn(page) {
        let a = result.unwrap(dict.get(rules_by_first, page), [])
        let b = result.unwrap(dict.get(rules_by_second, page), [])
        let aa =
          a
          |> list.filter(fn(x) { set.contains(page_set, pair.second(x)) })
        let bb =
          b
          |> list.filter(fn(x) { set.contains(page_set, pair.first(x)) })
        let applicable_rules = list.append(aa, bb)
        applicable_rules
        |> list.map(fn(rule) {
          let #(a, b) = rule
          use a_index <- result.try(dict.get(page_indexes, a))
          use b_index <- result.try(dict.get(page_indexes, b))
          Ok(a_index < b_index)
        })
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
  |> list.map(fn(l) { list_at(l, list.length(l) / 2) })
  |> int.sum
  |> Ok
}
