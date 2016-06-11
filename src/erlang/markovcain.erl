-module(markovcain).
-export([markovcain/0, parse/2]).

markovcain() ->
  markovcain(dict:new()).
markovcain(Dict) ->
    case io:get_chars('', 65536) of
	eof ->
	    print_dict(Dict),
	    init:stop();
	Text ->    
	    %% io:put_chars(Text),
	    NewDict = parse(Text, Dict),
	    markovcain(NewDict)
    end.



%%  a dict of the form {word -> [{nextword, count}...],
%%                      otherword -> [{nextword, count}...],
%%                     } 

parse(Text, Dict)->
    Words = string:tokens(Text, " .!,"),
    count(Words, Dict).
%%    print_dict(Result).


count([H|T], Dict)->
    case T of
	[] -> Dict;
	[Node|_] -> NewDict = increment(H, Node, Dict), count(T, NewDict)
    end;
count([], Dict) ->
    Dict.

increment(Root, Node, Dict)->
   % io:fwrite("root: ~p node: ~p~n", [Root, Node]),
   %     io:fwrite("dict: ~p~n~n", [Dict]),
    case Node of
	[] -> Dict;
	_ ->

	    case dict:is_key(Root, Dict) of  
		true ->
		    Counts = dict:fetch(Root, Dict),
		    case lists:keyfind(Node, 1, Counts) of 
			false ->
			    UpdatedCount = lists:flatten([Counts, [{Node, 1}]]);
			{Node, Count} ->
			    UpdatedCount =  lists:keyreplace(Node, 1, Counts, {Node, Count + 1})
		    end,
		    dict:store(Root, UpdatedCount, Dict);
		false ->
		    dict:store(Root, [{Node, 1}], Dict)
	    end
    end.

		    
		     		    
print_dict(Dict)->

    F = fun(Key, Value, AccIn) ->
		io:fwrite("~p~n", [Key]),
		[io:fwrite("   ~p ~p~n", [Word, Count]) || {Word, Count} <- Value],
		AccIn
	end,
    dict:fold(F, [], Dict).
	    


	     
	    
    

