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

pub type Token {
  Number(Int)
  Garbage(String)
  Comma
  LParen
  RParen
  Mul
  Do
  Dont
}

pub fn tokenize(in: List(String), tokens: List(Token)) -> List(Token) {
  let recurse = fn(
    in: List(String),
    offset: Int,
    tokens: List(Token),
    token: Token,
  ) {
    in
    |> list.drop(up_to: offset)
    |> tokenize(list.append(tokens, [token]))
  }

  case in {
    [] -> tokens
    ["d", "o", "n", "'", "t", ..] -> recurse(in, 5, tokens, Dont)
    ["d", "o", ..] -> recurse(in, 2, tokens, Do)
    ["m", "u", "l", ..] -> recurse(in, 3, tokens, Mul)
    ["(", ..] -> recurse(in, 1, tokens, LParen)
    [")", ..] -> recurse(in, 1, tokens, RParen)
    [",", ..] -> recurse(in, 1, tokens, Comma)
    [s, ..] -> {
      case is_digit(s) {
        True -> {
          let digits =
            in
            |> list.take(up_to: 3)
            |> list.take_while(is_digit)
            |> string.join("")
          let assert Ok(n) = int.parse(digits)
          recurse(in, string.length(digits), tokens, Number(n))
        }
        False -> recurse(in, 1, tokens, Garbage(s))
      }
    }
  }
}

fn is_digit(s: String) -> Bool {
  case s {
    "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> True
    _ -> False
  }
}

fn compute(tokens: List(Token), do: Bool) -> Int {
  case tokens {
    [] -> 0
    [Mul, LParen, Number(a), Comma, Number(b), RParen, ..rest] if do -> {
      a * b + compute(rest, do)
    }
    [Do, LParen, RParen, ..other] -> compute(other, True)
    [Dont, LParen, RParen, ..other] -> compute(other, False)
    [_, ..other] -> compute(other, do)
  }
}

pub fn part2(filepath: String) -> Result(Int, DayError) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(ReadError),
  )

  content
  |> string.to_graphemes
  |> tokenize([])
  |> compute(True)
  |> Ok
}
