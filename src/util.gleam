import gleam/bit_array
import gleam/dynamic
import gleam/list
import gleam/option.{type Option, None, Some}

@external(erlang, "io", "get_line")
fn read_line(prompt: String) -> dynamic.Dynamic

pub fn pause() {
  read_line("Press Enter to continue")
}

@external(erlang, "zlib", "compress")
fn erl_zlib_compress(data: BitArray) -> BitArray

pub fn compress_string(data: String) -> BitArray {
  data
  |> bit_array.from_string
  |> erl_zlib_compress
}

@external(erlang, "lists", "nth")
fn erl_list_nth(n: Int, list: List(typevar)) -> typevar

pub fn list_nth(n: Int, list: List(typevar)) -> Option(typevar) {
  case list.length(list) {
    len if n >= len || n < 0 -> None
    _ -> erl_list_nth(n + 1, list) |> Some
  }
}
