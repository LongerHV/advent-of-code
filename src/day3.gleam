import gleam/int
import gleam/list
import gleam/option
import gleam/pair
import gleam/regexp
import gleam/result
import gleam/string
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

fn parse_mul(in: String) -> #(option.Option(#(Int, Int)), String) {
  let assert Ok(re) =
    regexp.from_string("^mul\\((\\d\\d?\\d?),(\\d\\d?\\d?)\\)")
  let matches =
    re
    |> regexp.scan(in)

  case matches {
    [regexp.Match(content, [option.Some(a), option.Some(b)])] -> {
      let len = string.length(content)
      let assert #(Ok(x), Ok(y)) = #(int.parse(a), int.parse(b))
      #(option.Some(#(x, y)), string.slice(in, len, string.length(in) - len))
    }
    _ -> #(option.None, string.slice(in, 1, string.length(in) - 1))
  }
}

fn parse(in: String, do: Bool, pairs: List(#(Int, Int))) -> List(#(Int, Int)) {
  case in {
    "mul(" <> _ -> {
      case do {
        True -> {
          let #(p, rest) = {
            parse_mul(in)
          }
          case p {
            option.Some(pp) -> parse(rest, do, list.append(pairs, [pp]))
            option.None -> parse(rest, do, list.append(pairs, []))
          }
        }
        False -> parse(string.slice(in, 1, string.length(in) - 1), do, pairs)
      }
    }
    "do()" <> rest -> parse(rest, True, pairs)
    "don't()" <> rest -> parse(rest, False, pairs)
    "" -> pairs
    s -> parse(string.slice(s, 1, string.length(s) - 1), do, pairs)
  }
}

pub fn part2(filepath: String) -> Result(Int, DayError) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(ReadError),
  )

  content
  |> parse(True, [])
  |> list.map(fn(p) { pair.first(p) * pair.second(p) })
  |> int.sum
  |> Ok
}
