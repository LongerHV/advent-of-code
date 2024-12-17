import argv
import day1
import day11
import day13
import day14
import day15
import day2
import day3
import day4
import day5
import day7
import day8
import day9
import error
import gleam/int
import gleam/io

pub fn main() {
  let #(day, part, filepath) = case argv.load().arguments {
    [a, b, c] -> #(a, b, c)
    _ -> panic as "Expected three arguments: <day> <part> <filepath>"
  }

  let r = case day, part {
    "1", "1" -> day1.part1(filepath)
    "1", "2" -> day1.part2(filepath)
    "2", "1" -> day2.part1(filepath)
    "2", "2" -> day2.part2(filepath)
    "3", "1" -> day3.part1(filepath)
    "3", "2" -> day3.part2(filepath)
    "4", "1" -> day4.part1(filepath)
    "4", "2" -> day4.part2(filepath)
    "5", "1" -> day5.part1(filepath)
    "5", "2" -> day5.part2(filepath)
    "7", "1" -> day7.part1(filepath)
    "7", "2" -> day7.part2(filepath)
    "8", "1" -> day8.part1(filepath)
    "8", "2" -> day8.part2(filepath)
    "9", "1" -> day9.part1(filepath)
    "11", "1" -> day11.part1(filepath)
    "11", "2" -> day11.part2(filepath)
    "13", "1" -> day13.part1(filepath)
    "13", "2" -> day13.part2(filepath)
    "14", "1" -> day14.part1(filepath)
    "14", "2" -> day14.part2(filepath)
    "15", "1" -> day15.part1(filepath)
    "15", "2" -> day15.part2(filepath)
    _, _ -> panic as "Not yet implemented"
  }

  case r {
    Ok(a) -> io.println(int.to_string(a))
    Error(error.ParseError(s)) -> panic as s
    Error(error.NilError(Nil)) -> panic as "Nil Error"
    Error(_) -> panic as "Error"
  }
}
