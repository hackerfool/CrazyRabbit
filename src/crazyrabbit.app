{application, crazyrabbit,
	[
		{description, "I'm crazy rabbit."},
		{vsn, "0.0.1"},
		{modules, []},
		{registered, [crazyrabbit_sup, crazyrabbit_server, crazyrabbit_redis]},
		{applications, [
			kernel,
			stdlib,
			eredis
		]},
		{mod, {crazyrabbit_app, []}},
		{env, []}
	]
}.