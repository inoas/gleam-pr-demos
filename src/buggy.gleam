import buggy/io2

pub fn main() {
  io2.debug("hello world")
  io2.debug_raw("hello world")

  io2.debug(["hello", "world"])
  io2.debug_raw(["hello", "world"])

  io2.debug(#("hello", "world"))
  io2.debug_raw(#("hello", "world"))
}
