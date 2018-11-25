/* map and stuffs */
inc :-
	retract(step(X)),
	Next_X is X+1,
	asserta(step(Next_X)),
	enemydeadzone(1),
	checkvictory.
	
/*maps stuffs */
deadzone(X, Y) :-
	step(Steps),
	Div is Steps // 5 + 1,
	(
	X =< Div, !;
	Y =< Div, !;
	Divl is 21 - Div, X >= Divl, !;
	Divl is 21 - Div, Y >= Divl, !
	).
	
map :-
	printmap(1, 1).
	
printmap(X, Y) :-
	(Y == 21, !, nl, Next_X is X + 1, printmap(Next_X, 1));
	(X < 21, !, write(' '), (
		(playerposition(X, Y), write('P'), !); 
		(enemyposition(_, X, Y), write('E'), !); 
		(deadzone(X, Y), write('X'), !);
		write('_')
	), write(' '), Next_Y is Y + 1, printmap(X, Next_Y));
	X == 21.
