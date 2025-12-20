import gleam/erlang
import gleam/io
import gleam/string

pub fn main() {
  // TODO: Uncomment the code below to pass the first stage
  io.print("$ ")
  let assert Ok(command) = erlang.get_line("")
  print_command(command)
}

pub fn get_line() {
  let assert Ok(command) = erlang.get_line("")
  command
}

pub fn print_command(command: String) {
  let trim = string.trim(command)
  io.println(trim <> ": command not found")
}
