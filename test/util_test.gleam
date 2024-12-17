import gleam/io
import gleam/option.{None, Some}
import gleeunit/should
import util

pub fn nth_first_test() {
  util.list_nth(0, [1, 2, 3])
  |> should.equal(Some(1))
}

pub fn nth_last_test() {
  util.list_nth(2, [1, 2, 3])
  |> should.equal(Some(3))
}

pub fn nth_out_of_bound_test() {
  util.list_nth(2, [])
  |> io.debug
  |> should.equal(None)
}
