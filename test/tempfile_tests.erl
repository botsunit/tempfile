-module(tempfile_tests).

-include_lib("eunit/include/eunit.hrl").

tempfile_test_() ->
  {setup,
   fun setup/0, fun teardown/1,
   [
    ?_test(t_name()),
    ?_test(t_name_is_good_random()),
    ?_test(t_randstr_has_good_length()),
    ?_test(t_randstr_is_good_random())
   ]}.

setup() ->
  ok.

teardown(_) ->
  ok.

t_name() ->
  DirPath  = tempfile:name("tutu", [{ext, ".toto"},{path, "tata"}]),
  ?assertMatch("tata", filename:dirname(DirPath)),
  ?assertMatch({match, _}, re:run(filename:basename(DirPath), "^tutu.{20}\\.toto$")).


build_sample(0) ->
  [];
build_sample(N) ->
  [tempfile:name("whatever_equal_")|build_sample(N-1)].

all_are_different([]) ->
  true;
all_are_different([H|T]) ->
  not lists:member(H,T) andalso all_are_different(T).

t_name_is_good_random() ->
  ?assert(all_are_different(build_sample(100))).

build_randstrs(0) ->
  [];
build_randstrs(N) ->
  [tempfile:randstr(10)|build_randstrs(N-1)].

t_randstr_has_good_length() ->
  ?assertEqual(234,string:len(tempfile:randstr(234))).

t_randstr_is_good_random() ->
  ?assert(all_are_different(build_randstrs(100))).
