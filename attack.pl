/* Attack */
attack :-
	playerposition(X, Y),
	Startpx is X-1,
	Startpy is Y-1,
	loopattack(Startpx, Startpy),
	enemywalk(1), !.
attack :- write('There is no enemy at sight. Keep going!'), nl.

loopattack(X, Y) :-
	playerposition(Px, Py),
	Endpy is Py + 2,
	Endpx is Px + 2,
	Startpy is Py - 1,
	(
		Y == Endpy, !, Next_X is X + 1, loopattack(Next_X, Startpy);
		X < Endpx, !, (doattack(X, Y), !; Next_Y is Y + 1, loopattack(X, Next_Y));
		X == Endpx, !, fail
	).

doattack(Xp, Yp) :-
	enemyposition(Id,Xp,Yp),
	!, weapon(Wp), enemyweapon(Id, We),
	retract(health(Hp)), armor(Ap), Htotal is Hp + Ap, asserta(health(Htotal)),
	playerattack(Wp,We,100),
	retract(enemyposition(Id,Xp,Yp)),
	checkvictory.

playerattack(Wp,We,He) :- ammo(A), A == 0, !, enemyattack(Wp,We,He).
playerattack(Wp,We,He) :-
	retract(ammo(A)), Aleft is A - 1, asserta(ammo(Aleft)),
	weaponlist(Wp,Dp), Heleft is He - Dp,
	write('You attack the enemy with your '), write(Wp), write('.'), nl,
	write('His health point has been reduced to '), write(Heleft), write('.'), nl,
	(
		Heleft > 0, !, write('The battle continues!'), nl, enemyattack(Wp,We,Heleft);
		write('The enemy is dead, blood gushing through his veins.'), nl,
		retract(enemiesleft(Left)), Next_Left is Left - 1, asserta(enemiesleft(Next_Left)),
		retract(health(Htotal)),
		(
			Htotal > 100, !, asserta(health(100)), Atotal is Htotal - 100, retract(armor(_)), asserta(armor(Atotal));
			asserta(health(Htotal)), retract(armor(_)), asserta(armor(0))
		)
	).

enemyattack(Wp,We,He) :-
	retract(health(Hp)), weaponlist(We,De), Hpleft is Hp - De, asserta(health(Hpleft)),
	write('The enemy sneaks from behind and hits you using '), write(We), write('.'), nl,
	write('The attack reduces your health point to '), write(Hpleft), write('.'), nl,
	(
		Hpleft > 0, !, write('The battle continues!'), nl, playerattack(Wp,We,He);
		nl, write('You are dead, the world fades black...'), nl, nl, gameover
	).
