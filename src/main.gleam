import gleam/dynamic
import gleam/erlang
import gleam/erlang/charlist
import gleam/io
import gleam/string

@external(erlang, "erlang", "halt")
fn halt(exit_code: Int) -> Nil

@external(erlang, "main_ffi", "find_executable")
fn find_executable(name: String) -> Result(String, Nil)

@external(erlang, "os", "cmd")
fn cmd(command_line: charlist.Charlist) -> String

@external(erlang, "file", "get_cwd")
fn get_cwd() -> Result(charlist.Charlist, Nil)

@external(erlang, "file", "set_cwd")
fn set_cwd(path: String) -> dynamic.Dynamic

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
    "type " <> text -> io.println(get_type_of_command(text))
    "pwd" -> {
      case get_cwd() {
        Ok(cwd) -> io.println(charlist.to_string(cwd))
        Error(_) -> io.println("Error getting current directory")
      }
    }
    "cd " <> path -> {
      let result = set_cwd(path)
      case dynamic.classify(result) {
        "Atom" -> Nil
        _ -> io.println("cd: " <> path <> ": No such file or directory")
      }
    }
    text -> {
      let #(command, args) = separate_command(text)
      execute(command, args)
    }
  }
  trim
}

pub fn separate_command(command_line: String) -> #(String, List(String)) {
  let parts = string.split(command_line, " ")
  case parts {
    [command, ..args] -> #(command, args)
    [] -> #("", [])
  }
}

pub fn execute(command, args) -> Nil {
  case find_executable(command) {
    Ok(_) -> {
      let command_line = string.join([command, ..args], " ")
      cmd(charlist.from_string(command_line))
      |> io.print
      Nil
    }
    Error(_) -> {
      io.println(command <> ": command not found")
      Nil
    }
  }
}

pub fn get_type_of_command(command: String) -> String {
  case command {
    "echo" -> "echo is a shell builtin"
    "type" -> "type is a shell builtin"
    "exit" -> "exit is a shell builtin"
    "pwd" -> "pwd is a shell builtin"
    "cd" -> "cd is a shell builtin"
    _ -> {
      case find_executable(command) {
        Ok(path) -> command <> " is " <> path
        Error(_) -> command <> ": not found"
      }
    }
  }
}
