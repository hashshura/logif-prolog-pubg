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

step(0).
health(100).
playerposition(2,2).
stamina(100).
armor(0).

inc :-
	retract(step(X)),
	Next_X is X+1,
	asserta(step(Next_X)).

start :-
	write("======================================================="), nl,
	write("=                         _             _             ="), nl,
	write("=                        | |           ( )            ="), nl,
	write("=         _ __  _ __ ___ | | ___   __ _|/ ___         ="), nl,
	write("=        | '_ \\| '__/ _ \\| |/ _ \\ / _` | / __|        ="), nl,
	write("=        | |_) | | | (_) | | (_) | (_| | \\__ \\        ="), nl,
	write("=        | .__/|_|  \\___/|_|\\___/ \\__, | |___/        ="), nl,
	write("=        | |                       __/ |              ="), nl,
	write("=        |_|    unknown           |___/               ="), nl,
	write("=                  battlegrounds                      ="), nl,
	write("======================================================="), nl,
	nl,
	nl,
	write(" Welcome, Warrior."), nl,
	nl,
	write(" You are chosen as one of class K-3's representatives"), nl,
	write(" for the battle by a(n) (un)lucky lottery. Carve the"), nl,
	write(" way out through your opponents' corpses."), nl,
	nl,
	write(" Available commands:                               "), nl,
	write("    start. -- start the game!                      "), nl,
	write("    help. -- show available commands               "), nl,
	write("    quit. -- quit the game                         "), nl,
	write("    look. -- look around you                       "), nl,
	write("    n. s. e. w. -- move                            "), nl,
	write("    map. -- look at the map and detect enemies     "), nl,
	write("    take(Object). -- pick up an object             "), nl,
	write("    drop(Object). -- drop an object                "), nl,
	write("    use(Object). -- use an object                  "), nl,
	write("    attack. -- attack enemy that crosses your path "), nl,
	write("    status. -- show your status                    "), nl,
	write("    save(Filename). -- save your game              "), nl,
	write("    load(Filename). -- load previously saved game  "), nl,
	nl,
	write(" Legends:           "), nl,
	write("    W = weapon      "), nl,
	write("    A = armor       "), nl,
	write("    M = medicine    "), nl,
	write("    O = ammo        "), nl,
	write("    P = player      "), nl,
	write("    E = enemy       "), nl,
	write("    - = accessible  "), nl,
	write("    X = inaccessible"), nl,
	nl.

deadzone(X, Y) :-
	step(Steps),
	Div is Steps / 5 + 1,
	(
	X == Div, !;
	Y == Div, !;
	Divl is 21 - Div, X == Divl, !;
	Divl is 21 - Div, Y == Divl, !
	).
	
map :-
	printmap(1, 1).
	
printmap(X, Y) :-
	(Y == 21, !, nl, Next_X is X + 1, printmap(Next_X, 1));
	(X < 21, !, write(" "), (
		(playerposition(X, Y), write("P"), !); 
		(deadzone(X, Y), write("X"), !);
		write("_")
	), write(" "), Next_Y is Y + 1, printmap(X, Next_Y));
	X == 21.

/*temporary rules */
w :- inc, retract(playerposition(X, Y)), Next_y is Y-1, asserta(playerposition(X, Next_Y)).
s :- inc, retract(playerposition(X, Y)), Next_x is X+1, asserta(playerposition(Next_x, Y)).
e :- inc, retract(playerposition(X, Y)), Next_y is Y+1, asserta(playerposition(X, Next_y)).
n :- inc, retract(playerposition(X, Y)), Next_x is X-1, asserta(playerposition(Next_x, Y)).

