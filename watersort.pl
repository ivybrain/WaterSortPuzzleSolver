
% verify_level(+Level)
% Ensures that each colour listed in the level occurs 4 times
verify_level(Level) :-
  flatten(Level, Flat),
  sort(Flat, Colours),
  findall(N, (member(C, Colours), count_elem(C, Flat, N)), Counts),
  all_same(Counts, 4).

% Counts the occerances of Elem in List
% count_elem(+Elem, +List, -N)
count_elem(_, [], 0).
count_elem(Elem, [L|List], N) :-
  L == Elem ->
    count_elem(Elem, List, N1),
    N is N1 + 1
  ;
  count_elem(Elem, List, N).


% Finds a series of moves that takes a Level to a winning state
% solve_level(+Level, ?Moves)

solve_level(Level, Moves) :-
  level(Level, L),
  verify_level(L) ->
    call(level, Level, Tubes),
    findall((N, Tube), (member(Tube, Tubes), nth1(N, Tubes, Tube)), S),
    sort(1, @<, S, State),
    make_move(State, Moves)
  ;
    throw("Invalid Level Data").


check_soln(Level, Moves) :-
  level(Level, L),
  verify_level(L) ->
    call(level, Level, Tubes),
    findall((N, Tube), (member(Tube, Tubes), nth1(N, Tubes, Tube)), S),
    sort(1, @<, S, State),
    make_moves(State, Moves, [])
  ;
    throw("Invalid Level Data").

% Finds a series of valid moves that lead to a winning state, then return these moves
% make_move(+State, +Acc, - Moves)
make_move(State, Moves) :-
  ground(Moves) ->
    reverse(Moves, Acc),
    make_move(State, Acc, Moves, [])
  ;
  make_move(State, [], Moves, []).

make_move(State, Acc, Moves, PastStates) :-
  win_state(State) ->
    reverse(Acc, Moves)
  ;
  member((Fn, From), State),
  member((Tn, To), State),
  Tn \= Fn,
  valid_move((Fn, From), (Tn,To), (Fn, FromNew), (Tn, ToNew)),
  sort(1, @<, [(Fn, FromNew), (Tn, ToNew)], Changes),
  sort(1, @<, State, StateS),
  update_state(StateS, Changes, [], State_next),
  not_in_past(State_next, PastStates),
  make_move(State_next, [(Fn, Tn)|Acc], Moves, [StateS|PastStates]).
  %make_move(State_next, [(Fn, Tn)|Acc], Moves).

check_moves(State, [], _) :-
  win_state(State).

check_moves(State, [(Fn, Tn)|Moves], PastStates) :-
  member((Fn, From), State),
  member((Tn, To), State),
  Fn \= Tn,
  valid_move((Fn, From), (Tn,To), (Fn, FromNew), (Tn, ToNew)),
  sort(1, @<, [(Fn, FromNew), (Tn, ToNew)], Changes),
  sort(1, @<, State, StateS),
  update_state(StateS, Changes, [], State_next),
  not_in_past(State_next, PastStates),
  check_moves(State_next, Moves, [StateS|PastStates]).


% Takes a state (list of (TubeNumber, Tube)) and creates a new one with the elements in Changes (a similar list)
% replacing the corresponding elements from the old state
% update_state(+OldState, +Changes, +Acc, -NewState)
update_state([],_ , Acc, Acc).
update_state(State, [], Acc, New) :-
  append(Acc, State, New).
update_state([(N,Elem)|Old], [(Nc, Change)|Rest], Acc, New) :-
  N == Nc ->
    update_state(Old, Rest, [(Nc, Change)|Acc], New)
  ;
  update_state(Old, [(Nc, Change)|Rest], [(N,Elem)|Acc], New).




%Checks if a pour from From to To is valid, and finds the result afterwards
% valid_move(?from, ?to, ?FromNew, ?ToNew)
valid_move((Fn,From), (Tn,[T|To]), (Fn, FromNew), (Tn, ToNew)) :-
  append(F, FromNew, From),
  F \= [],
  all_same(F, C),

  C == T,
  append(F, [T|To], ToNew),
  length(ToNew, Len),
  Len =< 4,

  % One of these pouring conditions must be satisfied
  (
  % Pour until we hit the next colour
  ([R|_] = FromNew, R \= C);

  % Pour until the tube is empty
  [] = FromNew

  % Pour until the to tube is full
  %Len = 4
  ).

valid_move((Fn, From), (Tn, []), (Fn, FromNew), (Tn, ToNew)) :-
  % Pouring a single colour into empty is pointless, and results in infinite sequences
  \+ all_same(From, _),
  append(F, FromNew, From),
  F \= [],
  all_same(F, C),

  append(F, [], ToNew),
  length(ToNew, Len),
  Len =< 4,

  ([R|_] = FromNew, R \= C;
  [] = FromNew
  ).

% We win if all the tubes have 1 colour, and they are all either empty or full
% win_state(State)
win_state([]).
win_state([(_,Tube)|Rest]) :-
  all_same(Tube, _),
  length(Tube, N),
  (N == 0 ; N == 4),
  win_state(Rest).


% Matches if every element in List is Value
% all_same(?List, ?Value)
all_same([], _).
all_same([X|Xs], X) :-
  all_same(Xs, X).


% Unused, was used to keep track of past states
not_in_past(State, PastStates) :-
  sort(1, @<, State, StateS),
  %\+ has_permutation(StateS, PastStates).
  \+ member(StateS, PastStates).

has_permutation(State, PastStates) :-
  member(PastState, PastStates),
  is_permutation(State, PastState).

is_permutation([], _).
is_permutation([(_, Tube)|Ss], S2) :-
  member((_, Tube), S2),
  is_permutation(Ss, S2).
