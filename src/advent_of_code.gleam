import argv
import day1
import day2
import day3
import gleam/int
import gleam/io
import gleam/result

pub fn main() {
  let #(day, part, filepath) = case argv.load().arguments {
    [a, b, c] -> #(a, b, c)
    _ -> panic as "Expected three arguments: <day> <part> <filepath>"
  }

  let r = case day, part {
    "1", "1" -> day1.part1(filepath) |> result.replace_error(Nil)
    "1", "2" -> day1.part2(filepath) |> result.replace_error(Nil)
    "2", "1" -> day2.part1(filepath) |> result.replace_error(Nil)
    "2", "2" -> day2.part2(filepath) |> result.replace_error(Nil)
    "3", "2" -> day3.part2(filepath) |> result.replace_error(Nil)
    _, _ -> panic as "Not yet implemented"
  }

  case r {
    Ok(a) -> io.println(int.to_string(a))
    Error(_) -> panic as "Error"
  }
}
