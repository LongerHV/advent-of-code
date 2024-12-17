import error.{type AocError, NilError, ParseError}
import gleam/float
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import gleam/yielder
import simplifile
import util

type Registers =
  #(Int, Int, Int)

type Instructions =
  List(Int)

type Output =
  List(Int)

fn parse_register(in: String) -> Result(Int, AocError) {
  case in |> string.split(" ") {
    ["Register", _, val] -> val |> int.parse |> result.map_error(NilError)
    _ -> Error(ParseError("Invalid register"))
  }
}

fn parse_registers(in: String) -> Result(Registers, AocError) {
  use #(a, b, c) <- result.try(case in |> string.split("\n") {
    [a, b, c] -> Ok(#(a, b, c))
    _ -> Error(ParseError("Invalid registers"))
  })
  use a <- result.try(parse_register(a))
  use b <- result.try(parse_register(b))
  use c <- result.try(parse_register(c))
  Ok(#(a, b, c))
}

fn parse_program(in: String) -> Result(List(Int), AocError) {
  case in |> string.split(" ") {
    ["Program:", values] -> {
      values
      |> string.split(",")
      |> list.map(int.parse)
      |> result.all
      |> result.map_error(NilError)
    }
    _ -> Error(ParseError("Invalid program"))
  }
}

fn parse_input(in: String) -> Result(#(Registers, Instructions), AocError) {
  let parts = in |> string.trim |> string.split("\n\n")
  use #(registers, program) <- result.try(case parts {
    [registers, program] -> Ok(#(registers, program))
    _ -> Error(ParseError("Invalid input"))
  })

  use registers <- result.try(parse_registers(registers))
  use program <- result.try(parse_program(program))
  Ok(#(registers, program))
}

fn combo_operand(operand: Int, registers: Registers) -> Int {
  let #(a, b, c) = registers
  case operand {
    o if o <= 3 -> o
    4 -> a
    5 -> b
    6 -> c
    7 -> panic as "Reserved operand"
    _ -> panic as "Invalid operand"
  }
}

fn divide(operand: Int, registers: Registers) -> Int {
  let #(a, _, _) = registers
  let denominator =
    operand
    |> combo_operand(registers)
    |> int.to_float
    |> int.power(2, of: _)
    |> result.map(float.round)

  case denominator {
    Ok(d) -> a / d
    _ -> panic as "Power failed"
  }
}

fn adv(operand: Int, registers: Registers) -> Registers {
  let #(_, b, c) = registers
  #(divide(operand, registers), b, c)
}

fn bxl(operand: Int, registers: Registers) -> Registers {
  let #(a, b, c) = registers
  #(a, int.bitwise_exclusive_or(operand, b), c)
}

fn bst(operand: Int, registers: Registers) -> Registers {
  let #(a, _, c) = registers
  #(a, combo_operand(operand, registers) % 8, c)
}

fn jnz(ip: Int, operand: Int, registers: Registers) -> Int {
  let #(a, _, _) = registers
  case a {
    0 -> ip + 2
    _ -> operand
  }
}

fn bxc(_operand: Int, registers: Registers) -> Registers {
  let #(a, b, c) = registers
  #(a, int.bitwise_exclusive_or(b, c), c)
}

fn out(operand: Int, registers: Registers) -> Int {
  combo_operand(operand, registers) % 8
}

fn bdv(operand: Int, registers: Registers) -> Registers {
  let #(a, _, c) = registers
  #(a, divide(operand, registers), c)
}

fn cdv(operand: Int, registers: Registers) -> Registers {
  let #(a, b, _) = registers
  #(a, b, divide(operand, registers))
}

fn execute_opcode(
  ip: Int,
  registers: Registers,
  output: Output,
  instructions: Instructions,
) -> Option(#(Int, Registers, Output)) {
  use opcode <- option.then(util.list_nth(ip, instructions))
  use operand <- option.then(util.list_nth(ip + 1, instructions))
  let #(new_ip, new_registers, new_output) = case opcode {
    0 -> #(ip + 2, adv(operand, registers), output)
    1 -> #(ip + 2, bxl(operand, registers), output)
    2 -> #(ip + 2, bst(operand, registers), output)
    3 -> #(jnz(ip, operand, registers), registers, output)
    4 -> #(ip + 2, bxc(operand, registers), output)
    5 -> #(ip + 2, registers, [out(operand, registers), ..output])
    6 -> #(ip + 2, bdv(operand, registers), output)
    7 -> #(ip + 2, cdv(operand, registers), output)
    _ -> panic as "Invalid opcode"
  }
  Some(#(new_ip, new_registers, new_output))
}

pub fn part1(filepath: String) -> Result(String, AocError) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(error.ReadError),
  )

  use #(registers, instructions) <- result.try(parse_input(content))
  use #(_, _, output) <- result.try(
    #(0, registers, [])
    |> Some
    |> yielder.iterate(fn(x) {
      use #(ip, registers, output) <- option.then(x)
      execute_opcode(ip, registers, output, instructions)
    })
    |> yielder.take_while(option.is_some)
    |> yielder.last
    |> result.unwrap(None)
    |> option.to_result(NilError(Nil)),
  )

  output
  |> list.reverse
  |> list.map(int.to_string)
  |> string.join(",")
  |> Ok
}
