import gleam/otp/task
import simplifile

pub type AocError {
  ReadError(simplifile.FileError)
  AwaitError(task.AwaitError)
  ParseError(String)
  NilError(Nil)
}
