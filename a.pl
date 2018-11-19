/* temporary facts */ 
:- dynamic(health/1).
:- dynamic(stamina/1).
:- dynamic(armor/1).
:- dynamic(playerposition/2).
:- dynamic(weapon/1).
:- dynamic(equip/1).
:- dynamic(enemyposition/3).
:- dynamic(enemycount/1).
:- dynamic(existarmor/2).
:- dynamic(existweapon/2).
:- dynamic(inventory/1).
:- dynamic(step/1).
:- dynamic(ammo/1).

inc :-
	retract(step(X)),
	Next_X is X+1,
	asserta(step(Next_X)).

start :-
	asserta(step(0)),
	asserta(health(100)),
	asserta(playerposition(2,2)),
	asserta(stamina(100)),
	asserta(armor(0)),
	asserta(exist)
	write('======================================================='), nl,
	write('=                         _             _             ='), nl,
	write('=                        | |           ( )            ='), nl,
	write('=         _ __  _ __ ___ | | ___   __ _|/ ___         ='), nl,
	write('=        | \'_ \\| \'__/ _ \\| |/ _ \\ / _` | / __|        ='), nl,
	write('=        | |_) | | | (_) | | (_) | (_| | \\__ \\        ='), nl,
	write('=        | .__/|_|  \\___/|_|\\___/ \\__, | |___/        ='), nl,
	write('=        | |                       __/ |              ='), nl,
	write('=        |_|    unknown           |___/               ='), nl,
	write('=                  battlegrounds                      ='), nl,
	write('======================================================='), nl,
	nl,
	nl,
	write(' Welcome, Warrior.'), nl,
	nl,
	write(' You are chosen as one of class K-3\'s representatives'), nl,
	write(' for the battle by a(n) (un)lucky lottery. Carve the'), nl,
	write(' way out through your opponents\' corpses.'), nl,
	nl,
	write(' Available commands:                               '), nl,
	write('    start. -- start the game!                      '), nl,
	write('    help. -- show available commands               '), nl,
	write('    quit. -- quit the game                         '), nl,
	write('    look. -- look around you                       '), nl,
	write('    n. s. e. w. -- move                            '), nl,
	write('    map. -- look at the map and detect enemies     '), nl,
	write('    take(Object). -- pick up an object             '), nl,
	write('    drop(Object). -- drop an object                '), nl,
	write('    use(Object). -- use an object                  '), nl,
	write('    attack. -- attack enemy that crosses your path '), nl,
	write('    status. -- show your status                    '), nl,
	write('    save(Filename). -- save your game              '), nl,
	write('    load(Filename). -- load previously saved game  '), nl,
	nl,
	write(' Legends:           '), nl,
	write('    W = weapon      '), nl,
	write('    A = armor       '), nl,
	write('    M = medicine    '), nl,
	write('    O = ammo        '), nl,
	write('    P = player      '), nl,
	write('    E = enemy       '), nl,
	write('    - = accessible  '), nl,
	write('    X = inaccessible'), nl,
	nl.

/*temporary rules */

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
		(deadzone(X, Y), write('X'), !);
		write('_')
	), write(' '), Next_Y is Y + 1, printmap(X, Next_Y));
	X == 21.

/*for movement*/
w :- inc, retract(playerposition(X, Y)), Next_y is Y-1, asserta(playerposition(X, Next_y)).
s :- inc, retract(playerposition(X, Y)), Next_x is X+1, asserta(playerposition(Next_x, Y)).
e :- inc, retract(playerposition(X, Y)), Next_y is Y+1, asserta(playerposition(X, Next_y)).
n :- inc, retract(playerposition(X, Y)), Next_x is X-1, asserta(playerposition(Next_x, Y)).

/*inventory rules */
printinventory([]) :- write('').
printinventory([H|T]) :- write(H), write(' '), printinventory(T).  
addinventory([]) :- !.
addinventory([H|T]) :- retract(inventory(X)), !, append([H], X, Y), asserta(inventory(Y)).

/*player status*/
status :- retract(health(Health)), !, write('Health: '), write(Health), nl,
		retract(armor(Armor)), !, write('Armor: '), write(Armor), nl,
		retract(weapon(Weapon)), write('Weapon: '), write(Weapon), nl,
		retract(ammo(Ammo)), write('Ammo: '), write(Ammo), nl,
		retract(inventory(Inventory)), write('Inventory: '), printinventory(Inventory), nl.


/*take an object and placed it to inventory */
take :- retract(playerposition(POSX, POXY)), 
/* temporary facts */ 
:- dynamic(health/1).
:- dynamic(stamina/1).
:- dynamic(armor/1).
:- dynamic(playerposition/2).
:- dynamic(weapon/1).
:- dynamic(equip/1).
:- dynamic(enemyposition/3).
:- dynamic(enemycount/1).
:- dynamic(exist/3).
:- dynamic(inventory/1).
:- dynamic(step/1).


inc :-
	retract(step(X)),
	Next_X is X+1,
	asserta(step(Next_X)).

start :-
	asserta(step(0)),
	asserta(health(100)),
	asserta(playerposition(2,2)),
	asserta(stamina(100)),
	asserta(armor(0)),
	write('======================================================='), nl,
	write('=                         _             _             ='), nl,
	write('=                        | |           ( )            ='), nl,
	write('=         _ __  _ __ ___ | | ___   __ _|/ ___         ='), nl,
	write('=        | \'_ \\| \'__/ _ \\| |/ _ \\ / _` | / __|        ='), nl,
	write('=        | |_) | | | (_) | | (_) | (_| | \\__ \\        ='), nl,
	write('=        | .__/|_|  \\___/|_|\\___/ \\__, | |___/        ='), nl,
	write('=        | |                       __/ |              ='), nl,
	write('=        |_|    unknown           |___/               ='), nl,
	write('=                  battlegrounds                      ='), nl,
	write('======================================================='), nl,
	nl,
	nl,
	write(' Welcome, Warrior.'), nl,
	nl,
	write(' You are chosen as one of class K-3\'s representatives'), nl,
	write(' for the battle by a(n) (un)lucky lottery. Carve the'), nl,
	write(' way out through your opponents\' corpses.'), nl,
	nl,
	write(' Available commands:                               '), nl,
	write('    start. -- start the game!                      '), nl,
	write('    help. -- show available commands               '), nl,
	write('    quit. -- quit the game                         '), nl,
	write('    look. -- look around you                       '), nl,
	write('    n. s. e. w. -- move                            '), nl,
	write('    map. -- look at the map and detect enemies     '), nl,
	write('    take(Object). -- pick up an object             '), nl,
	write('    drop(Object). -- drop an object                '), nl,
	write('    use(Object). -- use an object                  '), nl,
	write('    attack. -- attack enemy that crosses your path '), nl,
	write('    status. -- show your status                    '), nl,
	write('    save(Filename). -- save your game              '), nl,
	write('    load(Filename). -- load previously saved game  '), nl,
	nl,
	write(' Legends:           '), nl,
	write('    W = weapon      '), nl,
	write('    A = armor       '), nl,
	write('    M = medicine    '), nl,
	write('    O = ammo        '), nl,
	write('    P = player      '), nl,
	write('    E = enemy       '), nl,
	write('    - = accessible  '), nl,
	write('    X = inaccessible'), nl,
	nl.

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
	(X < 21, !, write(' '),
		(
			(playerposition(X, Y), write('P'), !); 
			(deadzone(X, Y), write('X'), !);
			write('_')
		),
		write(' '), Next_Y is Y + 1, printmap(X, Next_Y));
	X == 21.
	

look :-
	playerposition(X, Y),
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
			(playerposition(X, Y), write('P'), !); 
			(deadzone(X, Y), write('X'), !);
			/* tambahin rule kayak "existweapon" dll di sini */
			write('_')
		),
		write(' '), Next_Y is Y + 1, printlook(X, Next_Y));
		X == Endpx
	).

/*temporary rules */
w :- inc, retract(playerposition(X, Y)), Next_y is Y-1, asserta(playerposition(X, Next_y)).
s :- inc, retract(playerposition(X, Y)), Next_x is X+1, asserta(playerposition(Next_x, Y)).
e :- inc, retract(playerposition(X, Y)), Next_y is Y+1, asserta(playerposition(X, Next_y)).
n :- inc, retract(playerposition(X, Y)), Next_x is X-1, asserta(playerposition(Next_x, Y)).

