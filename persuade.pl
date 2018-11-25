persuade :-
	isexist(airballoon),
	playerposition(X, Y),
	Startpx is X-1,
	Startpy is Y-1,
	looppersuade(Startpx, Startpy),
	enemywalk(1), !.
persuade :- \+ isexist(airballoon), !, write('Command not found.'), nl.
persuade :- write('There is no "enemy" at sight to persuade. Keep going!'), nl.
	
looppersuade(X, Y) :-
	playerposition(Px, Py),
	Endpy is Py + 2,
	Endpx is Px + 2,
	Startpy is Py - 1,
	(
		Y == Endpy, !, Next_X is X + 1, looppersuade(Next_X, Startpy);
		X < Endpx, !, (enemyposition(Id, X, Y), dopersuade(Id), checkpersuade, !; Next_Y is Y + 1, looppersuade(X, Next_Y));
		X == Endpx, !, fail
	).
	
dopersuade(Id) :- Id == 1, write('Ally #1, Asif, joins your party for the next airballoon voyage!'), nl, retract(enemyposition(Id,_,_)),!.
dopersuade(Id) :- Id == 2, write('Ally #2, Hanif, joins your party for the next airballoon voyage!'), nl, retract(enemyposition(Id,_,_)),!.
dopersuade(Id) :- Id == 3, write('Ally #3, Faiz, joins your party for the next airballoon voyage!'), nl, retract(enemyposition(Id,_,_)),!.
dopersuade(Id) :- Id == 4, write('Ally #4, Irfan, joins your party for the next airballoon voyage!'), nl, retract(enemyposition(Id,_,_)),!.

checkpersuade :-
	\+ enemyposition(_,_,_), enemiesleft(4), nl,
	write('Everyone is now on your airballoon.'), nl,
	write('You can now use the airballoon.'), nl, !.
checkpersuade :- !.
