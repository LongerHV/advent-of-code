import error.{type AocError, NilError, ParseError}
import gleam/bool
import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import simplifile

type Gate {
  AND(String, String)
  OR(String, String)
  XOR(String, String)
}

fn parse_inputs(in: String) -> Result(Dict(String, Bool), AocError) {
  in
  |> string.split("\n")
  |> list.map(fn(x) {
    case string.split(x, ": ") {
      [key, value] -> {
        use value <- result.try(case int.parse(value) {
          Ok(0) -> Ok(False)
          Ok(1) -> Ok(True)
          _ -> Error(ParseError("Expected 0 or 1"))
        })
        Ok(#(key, value))
      }
      _ -> Error(ParseError("Expected key value pair"))
    }
  })
  |> result.all
  |> result.map(dict.from_list)
}

fn parse_gates(in: String) -> Result(Dict(String, Gate), AocError) {
  in
  |> string.split("\n")
  |> list.map(fn(x) {
    case string.split(x, " ") {
      [a, op, b, "->", c] -> {
        use operator <- result.try(case op {
          "AND" -> Ok(AND(a, b))
          "OR" -> Ok(OR(a, b))
          "XOR" -> Ok(XOR(a, b))
          _ -> Error(ParseError("Expected operator"))
        })
        Ok(#(c, operator))
      }
      _ -> Error(ParseError("Expected gate"))
    }
  })
  |> result.all
  |> result.map(dict.from_list)
}

fn read_input(filepath: String) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(error.ReadError),
  )

  content
  |> string.trim
  |> string.split("\n\n")
  |> fn(x) {
    case x {
      [a, b] -> {
        use inputs <- result.try(parse_inputs(a))
        use gates <- result.try(parse_gates(b))
        Ok(#(inputs, gates))
      }
      _ ->
        Error(ParseError("Expected two sections separated with an empty line"))
    }
  }
}

fn get_value(
  key: String,
  inputs: Dict(String, Bool),
  gates: Dict(String, Gate),
) -> Bool {
  case dict.get(inputs, key) {
    Ok(value) -> value
    Error(_) -> {
      let assert Ok(gate) = dict.get(gates, key)
      case gate {
        AND(a, b) -> get_value(a, inputs, gates) && get_value(b, inputs, gates)
        OR(a, b) -> get_value(a, inputs, gates) || get_value(b, inputs, gates)
        XOR(a, b) ->
          bool.exclusive_or(
            get_value(a, inputs, gates),
            get_value(b, inputs, gates),
          )
      }
    }
  }
}

pub fn part1(filepath: String) -> Result(Int, AocError) {
  use #(inputs, gates) <- result.try(read_input(filepath))

  gates
  |> dict.keys
  |> list.filter(string.starts_with(_, "z"))
  |> list.sort(string.compare)
  |> list.reverse
  |> list.map(get_value(_, inputs, gates))
  |> list.map(fn(b) {
    case b {
      True -> "1"
      False -> "0"
    }
  })
  |> string.join("")
  |> int.base_parse(2)
  |> result.map_error(NilError)
}
