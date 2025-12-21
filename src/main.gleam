import gleam/erlang
import gleam/io
import gleam/string

@external(erlang, "erlang", "halt")
fn halt(exit_code: Int) -> Nil

pub fn main() {
  io.print("$ ")
  let assert Ok(command) = erlang.get_line("")
  print_command(command)
  main()
}

pub fn get_line() {
  let assert Ok(command) = erlang.get_line("")
  command
}

pub fn print_command(command: String) {
  let trim = string.trim(command)
  case trim {
    "exit" -> halt(0)
    "echo " <> text -> io.println(text)
    _ -> io.println(trim <> ": command not found")
  }
  trim
}
