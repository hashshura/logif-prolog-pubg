printlocation(X, Y) :-
	write('You are currently in '),
	(
		(X =< 8, Y =< 8, write('Ahrisa'), !);
		(X =< 8, Y > 8, write('Mhayakidz'), !);
		(X > 8, Y =< 8, write('Fmmichflu'), !);
		(X > 8, Y > 8, write('Ispatur'), !)
		/* Yes, those are our names. :) */
	),
	write('.'), nl.

printwalk :-
	step(Step), Mod is Step mod 5,
	(Mod == 0, nl, write('A gust of wind sweeps by, the battle area has been reduced!'), nl, nl, !; Mod \= 0),
	playerposition(X, Y),
	(
		deadzone(X, Y),
		write('You are stepping into the deadzone.'), nl,
		write('"A Warrior attempts trespassing," a voice reverberates.'), nl, nl,
		write('ZZAP! The electromagnetic force inside the deadzone ravages your intestines.'), nl,
		write('Blood gushing through your veins, you are now sleeping so soundly...'), nl, nl,
		gameover, !;
		1 == 1
	),
	(
		enemyposition(_,X, Y),
		write('An enemy on your vicinity spots you, commencing a duel!'), nl,
		doattack(X, Y), !;
		1 == 1
	),
	printlocation(X, Y),
	(
		(Xn is X-1, (
			(deadzone(Xn, Y), write('To the north is the deadzone. '), !);
			(write('To the north is an open field. ')))
		),
		(Yn is Y+1, (
			(deadzone(X, Yn), write('To the east is the deadzone. '), !);
			(write('To the east is an open field. ')))
		),
		nl, (Xnp is X+1, (
			(deadzone(Xnp, Y), write('To the south is the deadzone. '), !);
			(write('To the south is an open field. ')))
		),
		(Ynp is Y-1, (
			(deadzone(X, Ynp), write('To the west is the deadzone. '), !);
			(write('To the west is an open field. ')))
		)
	).
	
surrounding :-
	playerposition(X, Y),
	printlocation(X, Y),
	Startpx is X-1,
	Startpy is Y-1,
	printsurrounding(Startpx, Startpy),
	nl.

printsurrounding(X, Y) :-
	playerposition(Px, Py),
	Endpy is Py + 2,
	Endpx is Px + 2,
	Startpy is Py - 1,
	(
		(Y == Endpy, !, Next_X is X + 1, printsurrounding(Next_X, Startpy));
		(X == Px, Y == Py, !, 
			(
				((enemyposition(Id,X,Y), write('You spot an enemy, #'), write(Id), write(', right in front of you.'), nl, !); 1 == 1),
				((secretposition(_,X,Y), write('You are right beside an airballoon. "What could it do?" you wonder.'), nl, !); 1 == 1),
				((medicineposition(Med,X,Y), write('There is a medicine, '), write(Med), write(', right below you. '), nl, !); 1 == 1),
				((weaponposition(Wea,X,Y), write('A weapon, '), write(Wea), write(', lies right below you. '), nl, !); 1 == 1),
				((armorposition(Arm,X,Y), write('You see an armor, '), write(Arm), write(', right below you. '), nl, !); 1 == 1),
				((ammoposition(Amm,X,Y), write('Magazines, '), write(Amm), write(', are right below you. '), nl, !); 1 == 1)
			), Next_Y is Y + 1, !, printsurrounding(X, Next_Y)
		);
		(X < Endpx, !,
			(
				((enemyposition(Id,X,Y), write('An enemy, #'), write(Id), write(', is on your vicinity.'), nl, !); 1 == 1),
				((secretposition(_,X,Y), write('You see an airballoon nearby, with its balloon soaring high, ready to take off.'), nl, !); 1 == 1),
				((medicineposition(Med,X,Y), write('There is a medicine, '), write(Med), write(', on the ground. '), nl, !); 1 == 1),
				((weaponposition(Wea,X,Y), write('A weapon, '), write(Wea), write(', lies near you. '), nl, !); 1 == 1),
				((armorposition(Arm,X,Y), write('You see an armor, '), write(Arm), write('. '), nl, !); 1 == 1),
				((ammoposition(Amm,X,Y), write('Magazines, '), write(Amm), write(', are seen. '), nl, !); 1 == 1)
			), Next_Y is Y + 1, !, printsurrounding(X, Next_Y)
		);
		X == Endpx
	).
	
look :-
	playerposition(X, Y),
	surrounding,
	Startpx is X-1,
	Startpy is Y-1,
	printlook(Startpx, Startpy).
	
printlook(X, Y) :-
	playerposition(Px, Py),
	Endpy is Py + 2,
	Endpx is Px + 2,
	Startpy is Py - 1,
	(
		(Y == Endpy, !, nl, Next_X is X + 1, printlook(Next_X, Startpy));
		(X < Endpx, !, write(' '),
		(
			(deadzone(X, Y), write('X'), !);
			(secretposition(_,X,Y), write('@'), !);
			(enemyposition(_,X,Y), write('E'), !);
			(medicineposition(_,X,Y), write('M'), !);
			(weaponposition(_,X,Y), write('W'), !);
			(armorposition(_,X,Y), write('A'),!);
			(ammoposition(_,X,Y), write('O'),!);
			(playerposition(X, Y), write('P'), !); 
			
			write('_')
		),
		write(' '), Next_Y is Y + 1, printlook(X, Next_Y));
		X == Endpx
	).
