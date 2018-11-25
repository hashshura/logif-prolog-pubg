/* Games facts */ 
:- dynamic(health/1).
:- dynamic(stamina/1).
:- dynamic(armor/1).
:- dynamic(playerposition/2).
:- dynamic(weapon/1).
:- dynamic(enemyposition/3).
:- dynamic(enemycount/1).
:- dynamic(inventory/1).
:- dynamic(step/1).
:- dynamic(enemyweapon/2).
:- dynamic(armorposition/3).
:- dynamic(weaponposition/3).
:- dynamic(medicineposition/3).
:- dynamic(ammoposition/3).
:- dynamic(secretposition/3).
:- dynamic(ammo/1).
:- dynamic(ammoweapon/2).
:- dynamic(weaponlist/2).
:- dynamic(enemiesleft/1).

reset :-
	retractall(health(_)), retractall(stamina(_)), retractall(armor(_)), retractall(playerposition(_,_)),
	retractall(weapon(_)), retractall(enemyposition(_,_,_)), retractall(enemycount(_)), retractall(secretposition(_,_,_)),
	retractall(inventory(_)), retractall(step(_)), retractall(enemyweapon(_,_)), retractall(armorposition(_,_,_)),
	retractall(weaponposition(_,_,_)), retractall(medicineposition(_,_,_)), retractall(ammoposition(_,_,_)), retractall(ammo(_)),
	retractall(ammoweapon(_,_)), retractall(weaponlist(_,_)), retractall(enemiesleft(_)).

/*start games */
start :-
	reset,
	asserta(step(0)),
	asserta(health(100)),
	asserta(playerposition(10,2)),
	asserta(stamina(100)),
	asserta(armor(0)),
    asserta(weapon(none)),
	asserta(inventory([])),
	asserta(ammo(0)),
	spawnenemies, spawnammo, spawnarmor, spawnweapon, spawnmedicine, weaponinit, ammoinit, asserta(secretposition(airballoon,14,11)), !,
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
	help.

help :-
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
	write('    attack. -- attack enemy on your vicinity       '), nl,
	write('    status. -- show your status                    '), nl,
	(isexist(airballoon),write('    persuade. -- persuade nearby "enemies"'), nl, !; 1 == 1),
	write('    gsave(Filename). -- save your game             '), nl,
	write('    gload(Filename). -- load previously saved game '), nl,
	nl,
	write(' Legends:           '), nl,
	write('    W = weapon      '), nl,
	write('    A = armor       '), nl,
	write('    M = medicine    '), nl,
	write('    O = ammo        '), nl,
	write('    P = player      '), nl,
	write('    E = enemy       '), nl,
	write('    _ = open field  '), nl,
	write('    X = deadzone    '), nl,
	write('    @ = secret      '), nl,
	nl.

quit :- halt.	
