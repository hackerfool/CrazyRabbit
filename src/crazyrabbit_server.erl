%%% author:wang.kun
%%% date:2014-05-29
%%% mail:wangkun0226@gmail.com

-module(crazyrabbit_server).

-behaviour(gen_server).


%% API.
-export([start_link/0]).
-export([stop/0]).
-export([add_adapter/1]).
-export([add_seed_url/1]).

%% gen_server callback
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).
-export([code_change/3]).

-record(server_statue,{
		adapter_queue = []
	}).

%% API.
start_link() ->
	gen_server:start_link({global, ?MODULE}, ?MODULE, [] ,[]).

stop() ->
	gen_server:call({stop, normal}, ?MODULE).

add_adapter(Module) ->
	gen_server:call({global, ?MODULE}, {add_adapter, Module}).

add_seed_url(Url) ->
	gen_server:call({global, ?MODULE}, {add_seed_url, Url}, 15000).


%% gen_server
init(_Args) ->
	%% start link the redis db and read the adapter
	{ok, [ {redis, RedisConfig}, {server, ServerConfig} ]} = file:consult("..\\config\\server.config"),
	Adap = proplists:get_value("adapter", ServerConfig),
	inets:start(),
	crazyrabbit_redis:start_link(RedisConfig),
	{ok, #server_statue{ adapter_queue = Adap }}.

handle_call({add_adapter, Module}, _From, Status) ->
	Adapter = [ Module | Status#server_statue.adapter_queue],
	{reply, Adapter, Status#server_statue{ adapter_queue = Adapter }};

handle_call({add_seed_url, Url}, _From, Status) ->
	Result = crazyrabbit_spider:add_seed_url(Url),
	{reply, Result, Status};

handle_call(_Request, _From, State) ->
	{reply, ok, State}.

handle_cast(_Request, State) ->
	{noreply, State}.

handle_info(_Request, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldSvn, State, _Extra) ->
	{ok, State}.