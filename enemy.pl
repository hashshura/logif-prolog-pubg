enemydeadzone(Id) :-
	(
		enemyposition(Id, X, Y), deadzone(X, Y), retract(enemyposition(Id, X, Y)),
		retract(enemiesleft(ELeft)), ENext is ELeft-1, asserta(enemiesleft(ENext)),
		write('An enemy has been hurled to death by the agonizingly fast deadzone hurricane!'), nl, !;
		1 == 1
	),
	Next_Id is Id + 1, enemycount(Enemy_count),
	(
		Next_Id =< Enemy_count, enemydeadzone(Next_Id), !;
		1 == 1
	).
	
/*Enemies stuffs*/
spawnenemies :-
	asserta(enemyposition(4,2,18)),
	asserta(enemyweapon(4,ak47)),
	asserta(enemyposition(3,17,17)),
	asserta(enemyweapon(3,watergun)),
	asserta(enemyposition(2,19,4)),
	asserta(enemyweapon(2,watergun)),
	asserta(enemyposition(1,2,5)),
	asserta(enemyweapon(1,pistol)),
	asserta(enemycount(4)),
	asserta(enemiesleft(4)).

enemywalk(Id) :-
	enemycount(N), Id > N, !;
	\+ enemyposition(Id,_,_), NextId is Id + 1, enemywalk(NextId), !;
	enemycount(N), Id =< N, !, retract(enemyposition(Id,X,Y)), playerposition(Xp,Yp),
	(
		X > Xp, X1 is X - 1, \+ enemyposition(_,X1,Y), !, asserta(enemyposition(Id,X1,Y));
		X < Xp, X1 is X + 1, \+ enemyposition(_,X1,Y), !, asserta(enemyposition(Id,X1,Y));
		Y > Yp, Y1 is Y - 1, \+ enemyposition(_,X,Y1), !, asserta(enemyposition(Id,X,Y1));
		Y < Yp, Y1 is Y + 1, \+ enemyposition(_,X,Y1), !, asserta(enemyposition(Id,X,Y1));
		asserta(enemyposition(Id,X,Y))
	),
	NextId is Id + 1, 
	(
		enemyposition(Id,Xp,Yp),
		nl,
		write('Unknowingly, an enemy ambushes you from behind, commencing a duel!'), nl,
		doattack(Xp, Yp), !;
		1 == 1
	), enemywalk(NextId).
