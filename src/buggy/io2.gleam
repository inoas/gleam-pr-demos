/// Prints a value to standard output using Erlang syntax.
///
/// The value is returned after being printed so it can be used in pipelines.
///
/// ## Example
///
/// ```gleam
/// > io.debug("Hi mum")
/// // -> <<"Hi mum">>
/// "Hi mum"
///
/// > io.debug(Ok(1))
/// // -> {ok, 1}
/// Ok(1)
///
/// > import list
/// > [1, 2]
/// > |> list.map(fn(x) { x + 1 })
/// > |> io.debug
/// > |> list.map(fn(x) { x * 2 })
/// // -> [2, 3]
/// [4, 6]
/// ```
///
pub fn debug(term: anything) -> anything {
  do_debug(term)
  term
}

if javascript {
  fn do_debug(_term: anything) {
    Nil
  }
}

if erlang {
  external fn do_debug(term: anything) -> Nil =
    "buggy_ffi" "debug"
}

/// Prints a value to standard output (stdout) yielding Erlang or JavaScript syntax.
///
pub fn debug_raw(term: anything) -> anything {
  do_debug_raw(term)
  term
}

if erlang {
  fn do_debug_raw(_term: anything) {
    Nil
  }
}

if javascript {
  external fn do_debug_raw(term: anything) -> Nil =
    "../buggy_ffi.mjs" "debug_raw"
}
