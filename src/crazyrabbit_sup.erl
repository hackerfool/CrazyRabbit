%%% author:wang.kun
%%% date:2014-05-21
%%% mail:wangkun0226@gmail.com

-module(crazyrabbit_sup).

-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({global, ?MODULE}, ?MODULE, []).

init(_Arg) ->
	Server = {crazyrabbit_server, {crazyrabbit_server, start_link, []},
				permanent, 2000, worker, [crazyrabbit_server]},
	Children = [Server],
	RestartStrategy = {one_for_one, 0, 1},
	{ok, {RestartStrategy, Children}}.