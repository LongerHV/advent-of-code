import error
import gleam/dict
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/pair
import gleam/result
import gleam/string
import point
import simplifile

type Position =
  point.Point

type Direction =
  point.Point

type Map =
  dict.Dict(Position, Object)

type Object {
  Robot
  Wall
  Box
}

fn parse_map(in: String) -> Map {
  in
  |> string.split("\n")
  |> list.index_map(fn(row, y) {
    row
    |> string.to_graphemes
    |> list.index_map(fn(char, x) {
      case char {
        "@" -> Some(#(#(x, y), Robot))
        "#" -> Some(#(#(x, y), Wall))
        "O" -> Some(#(#(x, y), Box))
        _ -> None
      }
    })
  })
  |> list.flatten
  |> list.filter(option.is_some)
  |> option.all
  |> option.unwrap([])
  |> dict.from_list
}

fn parse_steps(in: String) -> List(Direction) {
  in
  |> string.split("\n")
  |> list.map(string.to_graphemes)
  |> list.flatten
  |> list.map(fn(char) {
    case char {
      "^" -> Some(#(0, -1))
      "v" -> Some(#(0, 1))
      "<" -> Some(#(-1, 0))
      ">" -> Some(#(1, 0))
      _ -> None
    }
  })
  |> option.all
  |> option.unwrap([])
}

fn parse_input(in: String) -> Result(#(Map, List(Direction)), error.AocError) {
  use #(map_data, steps_data) <- result.try({
    let data =
      in
      |> string.trim
      |> string.split("\n\n")
    case data {
      [a, b] -> Ok(#(a, b))
      _ -> Error(error.ParseError("Invalid input"))
    }
  })

  let map = parse_map(map_data)
  let steps = parse_steps(steps_data)
  Ok(#(map, steps))
}

fn find_robot(map: Map) -> Result(Position, error.AocError) {
  use robot <- result.try(
    map
    |> dict.to_list
    |> list.find(fn(x) {
      let #(_, obj) = x
      case obj {
        Robot -> True
        _ -> False
      }
    })
    |> result.map_error(error.NilError),
  )

  case robot {
    #(pos, Robot) -> Ok(pos)
    _ -> Error(error.ParseError("No robot found"))
  }
}

fn update_map(map: Map, pos: Position, new_pos: Position) -> Map {
  map
  |> dict.delete(pos)
  |> dict.upsert(new_pos, fn(_) { Box })
}

fn move_box(pos: Position, step: Direction, map: Map) -> #(Bool, Map) {
  let next = point.add(pos, step)
  case dict.get(map, next) {
    Ok(Wall) -> #(False, map)
    Ok(Box) -> {
      case move_box(next, step, map) {
        #(True, new_map) -> #(True, update_map(new_map, pos, next))
        _ -> #(False, map)
      }
    }
    _ -> #(True, update_map(map, pos, next))
  }
}

fn make_step(acc: #(Position, Map), step: Direction) -> #(Position, Map) {
  let #(robot, map) = acc
  let next = point.add(robot, step)

  case dict.get(map, next) {
    Ok(Box) -> {
      case move_box(next, step, map) {
        #(True, new_map) -> #(next, new_map)
        _ -> #(robot, map)
      }
    }
    Ok(Wall) -> #(robot, map)
    _ -> #(next, map)
  }
}

pub fn part1(filepath: String) -> Result(Int, error.AocError) {
  use content <- result.try(
    filepath
    |> simplifile.read
    |> result.map_error(error.ReadError),
  )

  use #(map, steps) <- result.try(parse_input(content))
  use robot <- result.try(find_robot(map))

  steps
  |> list.fold(#(robot, map), make_step)
  |> pair.second
  |> dict.to_list
  |> list.map(fn(obj) {
    case obj {
      #(#(x, y), Box) -> x + { 100 * y }
      _ -> 0
    }
  })
  |> int.sum
  |> Ok
}
