import gleam/int
import gleam/io
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

pub fn tokenize(in: String, tokens: List(Token)) -> List(Token) {
  let recurse = fn(in: String, s: String, tokens: List(Token), token: Token) {
    in
    |> string.drop_start(up_to: string.length(s))
    |> tokenize(list.append(tokens, [token]))
  }

  case in {
    "" -> tokens
    "don't" as s <> _ -> recurse(in, s, tokens, Dont)
    "do" as s <> _ -> recurse(in, s, tokens, Do)
    "mul" as s <> _ -> recurse(in, s, tokens, Mul)
    "(" as s <> _ -> recurse(in, s, tokens, LParen)
    ")" as s <> _ -> recurse(in, s, tokens, RParen)
    "," as s <> _ -> recurse(in, s, tokens, Comma)
    "0" <> _
    | "1" <> _
    | "2" <> _
    | "3" <> _
    | "4" <> _
    | "5" <> _
    | "6" <> _
    | "7" <> _
    | "8" <> _
    | "9" <> _ -> {
      let assert Ok(n) =
        result.or(
          int.parse(string.slice(in, at_index: 0, length: 3)),
          result.or(
            int.parse(string.slice(in, at_index: 0, length: 2)),
            int.parse(string.slice(in, at_index: 0, length: 1)),
          ),
        )
      recurse(in, int.to_string(n), tokens, Number(n))
    }
    _ -> {
      let s = string.slice(in, at_index: 0, length: 1)
      recurse(in, s, tokens, Garbage(s))
    }
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
  |> tokenize([])
  |> compute(True)
  |> Ok
}
