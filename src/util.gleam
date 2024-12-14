import gleam/bit_array
import gleam/dynamic

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
