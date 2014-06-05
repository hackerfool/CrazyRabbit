%%% author:wang.kun
%%% date:2014-06-03
%%% mail:wangkun0226@gmail.com

-module(crazyrabbit_spider).

-export([add_seed_url/1]).

-export([parse_url/1]).

add_seed_url(Url) ->
	error_logger:info_msg("add_seed_url Url:~p~n",[Url]),
	case crazyrabbit_redis:q(["get",Url]) of
			{ok, undefined} ->	parse_url(Url);
			_ -> {error, "seed url already exists"}
	end.

parse_url(Url) ->
	error_logger:info_msg("parse_url Url:~p~n",[Url]),
	{ok,{_,_,Body}} = httpc:request(Url),
	% error_logger:info_msg("parse_url body:~p~n",[Body]),
	parse_url(Body,[]).

parse_url([], Urls) ->
	% error_logger:info_msg("parse_url2 Urls:~p~n ::::::",[Urls]),
	Urls;
parse_url(Body,Urls) ->
	% error_logger:info_msg("parse_url2 Urls:~w~n ::::::",[Urls]),
	case Body of
		"<a href=" ++ Other ->
			{Url, Body2} = parse_get_body_url(Other, []),
			parse_url(Body2, [Url | Urls]);
		[_ | Other] ->
			parse_url(Other, Urls)
	end.

parse_get_body_url(Body, Url) ->
	case Body of
		">" ++ Other ->
			{lists:reverse(Url), Other};
		[Word | Body2] ->
			parse_get_body_url(Body2, [Word | Url])
	end.