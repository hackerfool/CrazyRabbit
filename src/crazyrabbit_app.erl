%%% author:wang.kun
%%% date:2014-05-21
%%% mail:wangkun0226@gmail.com

-module(crazyrabbit_app).

-behaviour(application).

-export([start/2]).
-export([stop/1]).

start(_StartType, _StartArgs) ->
	case crazyrabbit_sup:start_link() of
		{ ok, Pid} ->
			{ ok, Pid};
		Other ->
			{error, Other}
	end.

stop(_State) ->
	ok.