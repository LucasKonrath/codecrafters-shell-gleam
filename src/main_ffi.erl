-module(main_ffi).
-export([get_line/1, find_executable/1]).

-spec get_line(io:prompt()) -> {ok, unicode:unicode_binary()} | {error, nil}.
get_line(PromptBin) ->
    Prompt = binary:bin_to_list(PromptBin),
    case io:get_line(Prompt) of
    eof -> {error, nil};
         {error, _} -> {error, nil};
         Data when is_binary(Data) -> {ok, Data};
         Data when is_list(Data) -> {ok, unicode:characters_to_binary(Data)}
    end.

find_executable(NameBin) ->
    Name = binary:bin_to_list(NameBin),
    case os:find_executable(Name) of
        false -> {error, nil};
        Filename -> {ok, unicode:characters_to_binary(Filename)}
    end.