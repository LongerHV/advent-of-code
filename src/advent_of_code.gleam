import argv
import day1
import day11
import day13
import day14
import day15
import day17
import day19
import day2
import day20
import day3
import day4
import day5
import day7
import day8
import day9
import error
import gleam/int
import gleam/io
import gleam/result

pub fn main() {
  let #(day, part, filepath) = case argv.load().arguments {
    [a, b, c] -> #(a, b, c)
    _ -> panic as "Expected three arguments: <day> <part> <filepath>"
  }

  let r = case day, part {
    "1", "1" -> day1.part1(filepath) |> result.map(int.to_string)
    "1", "2" -> day1.part2(filepath) |> result.map(int.to_string)
    "2", "1" -> day2.part1(filepath) |> result.map(int.to_string)
    "2", "2" -> day2.part2(filepath) |> result.map(int.to_string)
    "3", "1" -> day3.part1(filepath) |> result.map(int.to_string)
    "3", "2" -> day3.part2(filepath) |> result.map(int.to_string)
    "4", "1" -> day4.part1(filepath) |> result.map(int.to_string)
    "4", "2" -> day4.part2(filepath) |> result.map(int.to_string)
    "5", "1" -> day5.part1(filepath) |> result.map(int.to_string)
    "5", "2" -> day5.part2(filepath) |> result.map(int.to_string)
    "7", "1" -> day7.part1(filepath) |> result.map(int.to_string)
    "7", "2" -> day7.part2(filepath) |> result.map(int.to_string)
    "8", "1" -> day8.part1(filepath) |> result.map(int.to_string)
    "8", "2" -> day8.part2(filepath) |> result.map(int.to_string)
    "9", "1" -> day9.part1(filepath) |> result.map(int.to_string)
    "11", "1" -> day11.part1(filepath) |> result.map(int.to_string)
    "11", "2" -> day11.part2(filepath) |> result.map(int.to_string)
    "13", "1" -> day13.part1(filepath) |> result.map(int.to_string)
    "13", "2" -> day13.part2(filepath) |> result.map(int.to_string)
    "14", "1" -> day14.part1(filepath) |> result.map(int.to_string)
    "14", "2" -> day14.part2(filepath) |> result.map(int.to_string)
    "15", "1" -> day15.part1(filepath) |> result.map(int.to_string)
    "17", "1" -> day17.part1(filepath)
    "19", "1" -> day19.part1(filepath) |> result.map(int.to_string)
    "19", "2" -> day19.part2(filepath) |> result.map(int.to_string)
    "20", "1" -> day20.part1(filepath) |> result.map(int.to_string)
    _, _ -> panic as "Not yet implemented"
  }

  case r {
    Ok(a) -> io.println(a)
    Error(error.ParseError(s)) -> panic as s
    Error(error.NilError(Nil)) -> panic as "Nil Error"
    Error(_) -> panic as "Error"
  }
}
