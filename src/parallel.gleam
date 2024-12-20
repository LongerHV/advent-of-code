import gleam/dict
import gleam/list
import gleam/otp/task

fn partition(list: List(a), by key: fn(a) -> b) -> List(List(a)) {
  list
  |> list.group(by: key)
  |> dict.values
}

pub fn map(
  list: List(a),
  group_by key: fn(a) -> c,
  with fun: fn(a) -> b,
) -> List(b) {
  list
  |> partition(by: key)
  |> list.map(fn(chunk) {
    task.async(fn() {
      chunk
      |> list.map(fun)
    })
  })
  |> list.map(task.await(_, 5000))
  |> list.flatten
}
