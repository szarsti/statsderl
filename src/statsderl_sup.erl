-module(statsderl_sup).
-include("statsderl.hrl").

%% public
-export([
    start_link/0
]).

-behaviour(supervisor).
-export([
    init/1
]).


%% public
-spec start_link() -> {ok, pid()}.

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% supervisor callbacks
-spec init([]) -> {ok, {{one_for_one, 5, 10}, [supervisor:child_spec()]}}.

init(_Args) ->
    {ok, {{one_for_one, 5, 10}, child_specs(?POOL_SIZE)}}.

%% private
child_specs(0) ->
    [];
child_specs(N) ->
    Name = statsderl_utils:server_name(N),
    [?CHILD(Name, ?SERVER) | child_specs(N - 1)].
