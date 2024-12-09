import gleam/dynamic

@external(erlang, "io", "get_line")
fn read_line(prompt: String) -> dynamic.Dynamic

pub fn pause() {
  read_line("Press Enter to continue")
}
