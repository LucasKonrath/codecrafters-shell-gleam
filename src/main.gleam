import gleam/erlang
import gleam/io
import gleam/string

pub fn main() {
  io.print("$ ")
  let assert Ok(command) = erlang.get_line("")
  let trim = print_command(command)
  main()
}

pub fn get_line() {
  let assert Ok(command) = erlang.get_line("")
  command
}

pub fn print_command(command: String) {
  let trim = string.trim(command)
  case trim {
    "exit" -> Nil
    _ -> io.println(trim <> ": command not found")
  }
  trim
}
