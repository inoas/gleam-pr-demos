-module(buggy_ffi).

-export([inspect/1, debug/1]).

inspect(true) ->
    "True";
inspect(false) ->
    "False";
inspect(Any) when is_atom(Any) ->
    lists:map(
        fun(Part) ->
            [Head | Tail] = string:next_grapheme(unicode:characters_to_binary(Part)),
            [string:uppercase([Head]), Tail]
        end,
        re:split(erlang:atom_to_list(Any), "_+", [{return, iodata}])
    );
inspect(Any) when is_integer(Any) ->
    erlang:integer_to_list(Any);
inspect(Any) when is_float(Any) ->
    io_lib_format:fwrite_g(Any);
inspect(Any) when is_binary(Any) ->
    Pattern = [$"],
    Replacement = [$\\, $\\, $"],
    Escaped = re:replace(Any, Pattern, Replacement, [{return, binary}, global]),
    ["\"", Escaped, "\""];
inspect(Any) when is_list(Any) ->
    ["[",
        lists:join(<<", ">>,
            lists:map(fun inspect/1, Any)
        ),
    "]"];
inspect(Any) when is_tuple(Any) % Record constructors
  andalso is_atom(element(1, Any))
  andalso element(1, Any) =/= false
  andalso element(1, Any) =/= true
  andalso element(1, Any) =/= nil
->
    [Atom | ArgsList] = erlang:tuple_to_list(Any),
    Args =
        lists:join(<<", ">>,
            lists:map(fun inspect/1, ArgsList)
    ),
    [inspect(Atom), "(", Args, ")"];
inspect(Any) when is_tuple(Any) ->
    ["#(",
        lists:join(<<", ">>,
            lists:map(fun inspect/1, erlang:tuple_to_list(Any))
        ),
    ")"];
inspect(Any) when is_function(Any) ->
    {arity, Arity} = erlang:fun_info(Any, arity),
    ArgsAsciiCodes = lists:seq($a, $a + Arity - 1),
    Args = lists:join(<<", ">>,
        lists:map(fun(Arg) -> <<Arg>> end, ArgsAsciiCodes)
    ),
    ["//fn(", Args, ") { ... }"];
inspect(Any) ->
    ["//erl(", io_lib:format("~p", [Any]), ")"].

debug(Any) ->
	println(inspect(Any)),
    nil.

println(String) ->
    io:put_chars([String, $\n]),
    nil.
