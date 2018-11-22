/* temporary facts */ 
:- dynamic(health/1).
:- dynamic(stamina/1).
:- dynamic(armor/1).
:- dynamic(playerposition/2).
:- dynamic(weapon/1).
:- dynamic(equip/1).
:- dynamic(enemyposition/3).
:- dynamic(enemycount/1).
:- dynamic(inventory/1).
:- dynamic(step/1).
:- dynamic(enemyweapon/3).
:- dynamic(armorposition/3).
:- dynamic(weaponposition/3).
:- dynamic(existweapon/3).
:- dynamic(existmedicine/3).
:- dynamic(existammo/3).
:- dynamic(ammo/1).

inc :-
	retract(step(X)),
	Next_X is X+1,
	asserta(step(Next_X)).

createenemies :-
	asserta(enemyposition(1,2,3)),
	asserta(enemyweapon(1,ak47)),
	asserta(enemyposition(2,5,8)),
	asserta(enemyweapon(2,ak47)),
	asserta(enemyposition(3,9,1)),
	asserta(enemyweapon(3,ak47)),
	asserta(enemyposition(4,4,5)),
	asserta(enemyweapon(4,ak47)),
	asserta(enemycount(4)).

start :-
	asserta(step(0)),
	asserta(health(100)),
	asserta(playerposition(2,2)),
	asserta(stamina(100)),
	asserta(armor(0)),
		asserta(existweapon(ak47, 3, 3)),
	asserta(inventory([])),
	asserta(ammo(0)),
	createenemies,
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
	(X < 21, !, write(' '), (
		(playerposition(X, Y), write('P'), !); 
		(deadzone(X, Y), write('X'), !);
		write('_')
	), write(' '), Next_Y is Y + 1, printmap(X, Next_Y));
	X == 21.

rest :-
	inc, enemywalk(1), retract(stamina(Prev)), Now is Prev + 10, Now > 100, !, asserta(stamina(100));
	asserta(stamina(Now)).
	
enemywalk(Id) :-
	enemycount(N), Id =< N, retract(enemyposition(Id,X,Y)), playerposition(Xp,Yp),
		(X > Xp, !, X1 is X - 1, asserta(enemyposition(Id,X1,Y)), NextId is Id + 1, enemywalk(NextId);
		X < Xp, !, X1 is X + 1, asserta(enemyposition(Id,X1,Y)), NextId is Id + 1, enemywalk(NextId);
		Y > Yp, !, Y1 is Y - 1, asserta(enemyposition(Id,X,Y1)), NextId is Id + 1, enemywalk(NextId);
		Y < Yp, !, Y1 is Y + 1, asserta(enemyposition(Id,X,Y1)), NextId is Id + 1, enemywalk(NextId)).


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
			(enemyposition(Id,X,Y), write('E'), !);
			(playerposition(X, Y), write('P'), !); 
			(deadzone(X, Y), write('X'), !);
			(existarmor, armorposition(_,X,Y), write('A'),!);
			(existweapon, weaponposition(_,X,Y), write('W'),!);
			
			write('_')
		),
		write(' '), Next_Y is Y + 1, printlook(X, Next_Y));
		X == Endpx
	).

existarmor :-
	asserta(armorposition(hat, 5,5));
	asserta(armorposition(hat, 19,4));
	asserta(armorposition(vest, 3,14));
	asserta(armorposition(vest, 17,18));
	asserta(armorposition(helmet,2,20));
	asserta(armorposition(kopyah, 4,12));
	asserta(armorposition(helmet, 5, 13)).
	
existweapon :-
	asserta(weaponposition(ak47,15,15));
	asserta(weaponposition(pistol,2,3));
	asserta(weaponposition(watergun,3,2));
	asserta(weaponposition(sword,12,12));
	asserta(weaponposition(ak47,10,10));
	asserta(weaponposition(grenade,15,15));
	asserta(weaponposition(grenade,3,7));
	asserta(weaponposition(pistol, 6,6)).
	
existammo :-
	asserta(ammoposition(pistol, 2,4));
	asserta(ammoposition(pistol, 4,6));
	asserta(ammoposition(pistol, 5,6)).
	

/*temporary rules */
w :- inc, retract(playerposition(X, Y)), Next_y is Y-1, asserta(playerposition(X, Next_y)).
s :- inc, retract(playerposition(X, Y)), Next_x is X+1, asserta(playerposition(Next_x, Y)).
e :- inc, retract(playerposition(X, Y)), Next_y is Y+1, asserta(playerposition(X, Next_y)).
n :- inc, retract(playerposition(X, Y)), Next_x is X-1, asserta(playerposition(Next_x, Y)).


/*inventory rules */
printinventory([]) :- write('').
printinventory([H|T]) :- write(H), write(' '), printinventory(T). 
addinventory(Object) :- retract(inventory(Inventory)), !, append([Object], Inventory, Y), asserta(inventory(Y)).

/*player status*/
status :- retract(health(Health)), write('Health: '), write(Health), nl,
		retract(armor(Armor)), write('Armor: '), write(Armor), nl,
		retract(weapon(Weapon)), write('Weapon: '), write(Weapon), nl,
		retract(ammo(Ammo)),write('Ammo: '), write(Ammo), nl,
		retract(inventory(Inventory)), write('Inventory: '), printinventory(Inventory), nl.


/*take an object and placed it to inventory */
take :- retract(playerposition(POSX, POXY)), !, takeweapon(POSX, POSY).
takeweapon(X, Y) :- retract(existweapon(Weapon, X, Y)), !, addinventory(Weapon).
