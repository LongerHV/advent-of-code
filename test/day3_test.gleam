import day3.{Comma, Do, Dont, Garbage, LParen, Mul, Number, RParen, tokenize, part1}
import gleeunit/should

// pub fn part_1_example_test() {
//   day3.part1("data/day3_example.txt")
//   |> should.equal(Ok(161))
// }
//
// pub fn part_1_exercise_test() {
//   day3.part1("data/day3_exercise.txt")
//   |> should.equal(Ok(162_813_399))
// }

pub fn part_2_example_test() {
  day3.part2("data/day3_example2.txt")
  |> should.equal(Ok(48))
}

pub fn part_2_exercise_test() {
  day3.part2("data/day3_exercise.txt")
  |> should.equal(Ok(53_783_319))
}

pub fn lexer_test() {
  day3.tokenize(
    "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))",
    [],
  )
  |> should.equal([
    Garbage("x"),
    Mul,
    LParen,
    Number(2),
    Comma,
    Number(4),
    RParen,
    Garbage("&"),
    Mul,
    Garbage("["),
    Number(3),
    Comma,
    Number(7),
    Garbage("]"),
    Garbage("!"),
    Garbage("^"),
    Dont,
    LParen,
    RParen,
    Garbage("_"),
    Mul,
    LParen,
    Number(5),
    Comma,
    Number(5),
    RParen,
    Garbage("+"),
    Mul,
    LParen,
    Number(32),
    Comma,
    Number(64),
    Garbage("]"),
    LParen,
    Mul,
    LParen,
    Number(11),
    Comma,
    Number(8),
    RParen,
    Garbage("u"),
    Garbage("n"),
    Do,
    LParen,
    RParen,
    Garbage("?"),
    Mul,
    LParen,
    Number(8),
    Comma,
    Number(5),
    RParen,
    RParen,
  ])
}
