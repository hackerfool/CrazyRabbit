%%% author:wang.kun
%%% date:2014-06-05
%%% mail:wangkun0226@gmail.com

-module(crazyrabbit_redis).

-behaviour(gen_server).

-record(redis_server_statue,{
		eredisHandle = undefined
	}).

%% API
-export([start_link/1]).

%% redis API
-export([q/1]).
-export([q/2]).

%% gen_server 
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).

%% redis API
start_link(Args) ->
	error_logger:info_msg("redis gen_server is starting.....~n"),
	gen_server:start_link({global, ?MODULE}, ?MODULE, [Args], []).

q(Command) ->
	gen_server:call({global, ?MODULE}, {eredis_q, Command}).

q(Command, Timeout) ->
	gen_server:call({global, ?MODULE}, {eredis_q, Command, Timeout}).


%%
init([Args]) ->
	Host           = proplists:get_value("host", Args, "127.0.0.1"),
    Port           = proplists:get_value("port", Args, 6379),
    % Database       = proplists:get_value("database", Args, 0),
    % Password       = proplists:get_value("password", Args, ""),
    % ReconnectSleep = proplists:get_value("reconnect_sleep", Args, 100),
	% EredisHandle   = eredis:start_link(Host, Port, Database, Password, ReconnectSleep),
	{ok,EredisHandle}   = eredis:start_link(Host, Port),
	error_logger:info_msg("Connection redis is running, Args:~p ::::::~n",[Args]),
	{ok, #redis_server_statue{ eredisHandle = EredisHandle }}.

handle_call({eredis_q, Command}, _From, Status) ->
	Result = eredis:q(Status#redis_server_statue.eredisHandle, Command),
	{reply, Result, Status};

handle_call({eredis_q, Command, Timeout}, _From, Status) ->
	Result = ereids:q(Status#redis_server_statue.eredisHandle, Command, Timeout),
	{reply, Result, Status};

handle_call(_Request, _From , State) ->
	{reply, bad_request, State}.

handle_cast(_Request, State) ->
	{noreply, State}.

handle_info(_Request, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_Oldsvn, State, _Extra) ->
	{ok, State}.