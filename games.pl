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
:- dynamic(ammo/1).
:- dynamic(armorlist/2).
:- dynamic(ammoweapon/2).
:- dynamic(weaponlist/2).
:- dynamic(enemiesleft/1).

reset :-
	retractall(health(_)), retractall(stamina(_)), retractall(armor(_)), retractall(playerposition(_,_)),
	retractall(weapon(_)), retractall(enemyposition(_,_,_)), retractall(enemycount(_)),
	retractall(inventory(_)), retractall(step(_)), retractall(enemyweapon(_,_)), retractall(armorposition(_,_,_)),
	retractall(weaponposition(_,_,_)), retractall(medicineposition(_,_,_)), retractall(ammoposition(_,_,_)), retractall(ammo(_)),
	retractall(armorlist(_,_)), retractall(ammoweapon(_,_)), retractall(weaponlist(_,_)), retractall(enemiesleft(_)).

inc :-
	retract(step(X)),
	Next_X is X+1,
	asserta(step(Next_X)),
	enemydeadzone(1).
	
enemydeadzone(Id) :-
	(enemyposition(Id, X, Y), deadzone(X, Y), retract(enemyposition(Id, X, Y)), !; 1 == 1),
	Next_Id is Id + 1, enemycount(Enemy_count),
	(Next_Id =< Enemy_count, enemydeadzone(Next_Id), !; 1 == 1).
	
/*Enemies stuffs*/
spawnenemies :-
	asserta(enemyposition(1,2,3)),
	asserta(enemyweapon(1,ak47)),
	asserta(enemyposition(2,5,8)),
	asserta(enemyweapon(2,ak47)),
	asserta(enemyposition(3,9,4)),
	asserta(enemyweapon(3,ak47)),
	asserta(enemyposition(4,4,5)),
	asserta(enemyweapon(4,ak47)),
	asserta(enemycount(4)),
	asserta(enemiesleft(4)).

/*start games */
start :-
	reset,
	asserta(step(0)),
	asserta(health(100)),
	asserta(playerposition(2,2)),
	asserta(stamina(100)),
	asserta(armor(0)),
    asserta(weapon(none)),
	asserta(inventory([])),
	asserta(ammo(0)),
	spawnenemies, spawnammo, spawnarmor, spawnweapon, spawnmedicine, armorinit, weaponinit, ammoinit, !,
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
	write('    attack. -- attack enemy on your vicinity       '), nl,
	write('    status. -- show your status                    '), nl,
	write('    save(Filename). -- save your game              '), nl,
	write('    loads(Filename). -- load previously saved game '), nl,
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
	nl.

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
		(deadzone(X, Y), write('X'), !);
		write('_')
	), write(' '), Next_Y is Y + 1, printmap(X, Next_Y));
	X == 21.

/*rest for players*/
rest :-
	inc, enemywalk(1), retract(stamina(Prev)), Now is Prev+20, asserta(stamina(Now)), restmax,
	write('You rest for a while, increasing your stamina by 10.'), nl,
	playerposition(X, Y),
	(
		deadzone(X, Y),
		write('Alas, sometimes "a while" does mean forever. Your resting place has become a deadzone.'), nl,
		write('"A Warrior attempts trespassing," a voice reverberates.'), nl, nl,
		write('ZZAP! The electromagnetic force inside the deadzone ravages your intestines.'), nl,
		write('Blood gushing through your veins, you are now sleeping so soundly...'), nl, nl,
		gameover, !;
		1 == 1
	),
	(
		enemyposition(_,X, Y),
		write('Unknowingly, an enemy ambushes you from behind, commencing a duel!'), nl,
		doattack(X, Y), !;
		1 == 1
	).
restmax :-
	(stamina(Now), Now > 100, !, retract(stamina(Now)), asserta(stamina(100)));
	stamina(_).	
enemywalk(Id) :-
	enemycount(N), Id > N, !;
	\+ enemyposition(Id,_,_), NextId is Id + 1, enemywalk(NextId), !;
	enemycount(N), Id =< N, !, retract(enemyposition(Id,X,Y)), playerposition(Xp,Yp),
		(
			X > Xp, !, X1 is X - 1, asserta(enemyposition(Id,X1,Y));
			X < Xp, !, X1 is X + 1, asserta(enemyposition(Id,X1,Y));
			Y > Yp, !, Y1 is Y - 1, asserta(enemyposition(Id,X,Y1));
			Y < Yp, !, Y1 is Y + 1, asserta(enemyposition(Id,X,Y1));
			asserta(enemyposition(Id,X,Y))
		), NextId is Id + 1, enemywalk(NextId).

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
				((medicineposition(Med,X,Y), write('There is a medicine, '), write(Med), write(', right below you. '), nl, !); 1 == 1),
				((weaponposition(Wea,X,Y), write('A weapon, '), write(Wea), write(', lies right below you. '), nl, !); 1 == 1),
				((armorposition(Arm,X,Y), write('You see an armor, '), write(Arm), write(', right below you. '), nl, !); 1 == 1),
				((ammoposition(Amm,X,Y), write('Magazines, '), write(Amm), write(', are right below you. '), nl, !); 1 == 1)
			), Next_Y is Y + 1, !, printsurrounding(X, Next_Y)
		);
		(X < Endpx, !,
			(
				((enemyposition(Id,X,Y), write('An enemy, #'), write(Id), write(', is on your vicinity.'), nl, !); 1 == 1),
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

/* armor, weapon, ammo, and medicine places */
spawnarmor :-
	asserta(armorposition(hat, 5,5)),
	asserta(armorposition(hat, 19,4)),
	asserta(armorposition(vest, 3,14)),
	asserta(armorposition(vest, 17,18)),
	asserta(armorposition(helmet,2,20)),
	asserta(armorposition(kopyah, 4,12)),
	asserta(armorposition(helmet, 5, 13)).
	
armorinit :-
	asserta(armorlist(hat,20)),
	asserta(armorlist(vest,20)),
	asserta(armorlist(helmet,20)),
	asserta(armorlist(kopyah,20)).

spawnweapon :-
	asserta(weaponposition(ak47,15,15)),
	asserta(weaponposition(pistol,2,3)),
	asserta(weaponposition(watergun,3,2)),
	asserta(weaponposition(sword,12,12)),
	asserta(weaponposition(ak47,10,10)),
	asserta(weaponposition(pistol, 6,6)).

weaponinit :- 
	asserta(weaponlist(ak47,70)),
	asserta(weaponlist(pistol,30)),
	asserta(weaponlist(watergun,20)),
	asserta(weaponlist(sword,35)),
	asserta(weaponlist(grenade, 25)),
	asserta(weaponlist(none, 0)).
	 
	
spawnammo :-
	asserta(ammoposition(peluruwatergun, 3,3)),
	asserta(ammoposition(peluruwatergun, 2,2)),
	asserta(ammoposition(peluruak47, 2,2)),
	asserta(ammoposition(pelurupistol, 2,4)),
	asserta(ammoposition(peluruak47, 4,6)),
	asserta(ammoposition(peluruwatergun, 5,6)).
	
ammoinit :-
	asserta(ammoweapon(pelurupistol, 0)),
	asserta(ammoweapon(peluruak47, 0)),
	asserta(ammoweapon(peluruwatergun, 0)).

spawnmedicine :- 
    asserta(medicineposition(bandage, 3, 7)),
    asserta(medicineposition(bandage, 6, 15)),
    asserta(medicineposition(bandage, 20, 10)),
    asserta(medicineposition(betadine, 8, 9)),
    asserta(medicineposition(betadine, 2, 2)),
    asserta(medicineposition(betadine, 4, 16)).	

/*temporary rules */
w :- cekstamina, inc, retract(playerposition(X, Y)), Next_y is Y-1, asserta(playerposition(X, Next_y)), printwalk,
	 retract(stamina(S)), N is S-10, asserta(stamina(N)), !;
	 write('You don\'t have enough stamina to walk, please take a rest first!').
s :- cekstamina, inc, retract(playerposition(X, Y)), Next_x is X+1, asserta(playerposition(Next_x, Y)), printwalk,
	 retract(stamina(S)), N is S-10, asserta(stamina(N)), !;
	 write('You don\'t have enough stamina to walk, please take a rest first!').
e :- cekstamina, inc, retract(playerposition(X, Y)), Next_y is Y+1, asserta(playerposition(X, Next_y)), printwalk,
	 retract(stamina(S)), N is S-10, asserta(stamina(N)), !;
	 write('You don\'t have enough stamina to walk, please take a rest first!').
n :- cekstamina, inc, retract(playerposition(X, Y)), Next_x is X-1, asserta(playerposition(Next_x, Y)), printwalk,
	 retract(stamina(S)), N is S-10, asserta(stamina(N)), !;
	 write('You don\'t have enough stamina to walk, please take a rest first!').

cekstamina :- stamina(N), N>=10.

/*inventory rules */
isiinventory([], 0).
isiinventory([H|T], X) :- isiinventory(T, Y), X is (Y + 1). 

printinventory([]).
printinventory([H|T]) :- write('--->'), write(H), nl, printinventory(T).

isada(Object, []) :- false.
isada(Object, [H|T]) :- (Object == H), !.
isada(Object, [H|T]) :- isada(Object, T), !.
isexist(Object) :- retract(inventory(I)), asserta(inventory(I)), isada(Object, I).

del(X,[X|Tail], Tail).
del(X,[Y|Tail], [Y|Tail1]) :- del(X, Tail, Tail1).

removeobject(Object) :- retract(inventory(Inventory)), del(Object, Inventory, Newinventory), asserta(inventory(Newinventory)).

jumlahammo(X) :- ammoweapon(peluruak47, P), ((P > 0, A is 1),!;(P == 0, A is 0)), 
            	 ammoweapon(pelurupistol, Q), ((Q > 0, B is 1),!;(Q == 0, B is 0)),
            	 ammoweapon(peluruwatergun, R), ((R > 0, C is 1),!;(R == 0, C is 0)), 
            	 X is A + B + C, !.

addinventory(Object, X, Y) :- inventory(Inventory), isiinventory(Inventory, Frek), jumlahammo(Jumlahammo),
                              ((Frek + Jumlahammo) < 3), append([Object], Inventory, TY), retract(inventory(Inv)), asserta(inventory(TY)), 
							  write('You took the '), write(Object), write('!'), nl, !.

addinventory(Object, X, Y) :- isweapon(Object), asserta(weaponposition(Object, X, Y)), write('Inventory is full!'), nl, !.
addinventory(Object, X, Y) :- isarmor(Object), asserta(armorposition(Object, X, Y)), write('Inventory is full!'), nl, !.
addinventory(Object, X, Y) :- ismedicine(Object), asserta(medicineposition(Object, X, Y)), write('Inventory is full!'), nl, !.

addammo(Ammo, X, Y) :- (Ammo == pelurupistol), !, retract(ammoweapon(pelurupistol, P)), YY is P + 3, asserta(ammoweapon(Ammo, YY)), 
					   write('You took the '), write(Ammo), write('!'), !.
addammo(Ammo, X, Y) :- (Ammo == peluruak47), !, retract(ammoweapon(peluruak47, P)), YY is P + 1, asserta(ammoweapon(Ammo, YY)), 
						write('You took the '), write(Ammo), write('!'), !.
addammo(Ammo, X, Y) :- (Ammo == peluruwatergun), !, retract(ammoweapon(peluruwatergun, P)), YY is P+5, asserta(ammoweapon(Ammo, YY)), 
						write('You took the '), write(Ammo), write('!'), !. 

printstatusinventory(I) :- isiinventory(I,X), (X == 0), jumlahammo(Y), (Y == 0), write(' Your inventory is empty!'), nl, !.
printstatusinventory(I) :- isiinventory(I,XX), (XX > 0), jumlahammo(YY), (YY == 0), printinventory(I), !.
printstatusinventory(I) :- isiinventory(I,XXX), (XXX > 0), jumlahammo(YYY), (YYY > 0), printinventory(I), printinventoryammo1, printinventoryammo2, printinventoryammo3, !.
printstatusinventory(I) :- isiinventory(I,XXXX), (XXXX == 0), jumlahammo(YYYY), (YYYY > 0), printinventoryammo1, printinventoryammo2, printinventoryammo3.

printinventoryammo1 :- ammoweapon(peluruak47, X), (X > 0), write('--->'), write(peluruak47), nl,!;
					   1==1.
printinventoryammo2 :- ammoweapon(pelurupistol, X), (X > 0), write('--->'), write(pelurupistol), nl,!;
					   1==1.
printinventoryammo3 :- ammoweapon(peluruwatergun, X), (X > 0),write('--->'),  write(peluruwatergun), nl,!;
					   1==1.

/*player status*/
status :-
		write('[Lone Warrior]'), nl,
		write(' Health:  '), health(H), write(H), nl,
		write(' Stamina: '), stamina(S), write(S), nl, 
		write(' Armor:   '), armor(Ar), write(Ar), nl, 
		write(' Weapon:  '), weapon(W), write(W), nl, 
		write(' Ammo:    '), ammo(Ammo), write(Ammo), nl, 
		write(' Inventory: '), nl, inventory(Inventory), printstatusinventory(Inventory), !.


/*classify an object */
isweapon(X) :- (X == pistol);(X == watergun);(X == sword);(X == ak47).
ismedicine(X) :- (X == bandage); (X == betadine).
isarmor(X) :- (X == hat);(X == vest);(X == helmet);(X == kopyah).
isammo(X) :- (X == peluruak47); (X == pelurupistol); (X == peluruwatergun).

/*take an object and placed it to inventory */
take(X) :- isweapon(X), retract(playerposition(PX, PY)), asserta(playerposition(PX, PY)), 
            weaponposition(X, PX, PY), takeweapon(PX, PY), !.
take(X) :- isarmor(X), retract(playerposition(PX, PY)), asserta(playerposition(PX, PY)), 
            armorposition(X, PX, PY), takearmor(PX, PY), !.
take(X) :- ismedicine(X), retract(playerposition(PX, PY)), asserta(playerposition(PX, PY)), 
            medicineposition(X, PX, PY), takemedicine(PX, PY), !.
take(X) :- isammo(X), retract(playerposition(PX, PY)), asserta(playerposition(PX, PY)), 
            ammoposition(X, PX, PY), takeammo(X, PX, PY), !.
take(X) :- write(X), write(' is not available in this area.'), nl,!.

takeweapon(X, Y) :- retract(weaponposition(Weapon, X, Y)), addinventory(Weapon, X, Y),!.
takearmor(X, Y) :- retract(armorposition(Armor, X, Y)), addinventory(Armor, X, Y),!.
takemedicine(X, Y) :- retract(medicineposition(Medicine, X, Y)), addinventory(Medicine,X,Y),!.
takeammo(Ammo, X, Y) :- retract(ammoposition(Ammo, X, Y)), addammo(Ammo, X, Y). 

/*use an object in inventory, and removed it from inventory */
use(X) :- isexist(X), isweapon(X), retract(weapon(W)), write(X), write(' is equipped. '), asserta(weapon(X)), removeobject(X), changeweapon(W), !. 
use(X) :- isexist(X), (X == 'bandage'), retract(health(H)), NewH is H + 10, asserta(health(NewH)), cekhealth(X), !.
use(X) :- isexist(X), (X == 'betadine'), retract(health(H)), NewH is H + 10, asserta(health(NewH)), cekhealth(X), !.
use(X) :- isexist(X), (X == 'hat'), retract(armor(Armor)),Newarmor is Armor + 5, asserta(armor(Newarmor)), removeobject(X), write('Your Armor is increasing 5 units!'), nl, !.
use(X) :- isexist(X), (X == 'vest'), retract(armor(Armor)),Newarmor is Armor+10, asserta(armor(Newarmor)), removeobject(X), write('Your Armor is increasing 10 units!'), nl, !.
use(X) :- isexist(X), (X == 'helmet'), retract(armor(Armor)),Newarmor is Armor+15, asserta(armor(Newarmor)), removeobject(X), write('Your Armor is increasing 15 units!'), nl, !.
use(X) :- isexist(X), (X == 'kopyah'), retract(armor(Armor)),Newarmor is Armor+20, asserta(armor(Newarmor)), removeobject(X), write('Your Armor is increasing 20 units!'), nl, !.
use(X) :- (X == peluruak47), weapon(W), W == ak47, ammoweapon(peluruak47, P), P > 0, retract(ammo(Now)), Q is 3 - Now, mini(P, Q, Mini), 
			Np is P - Mini, retract(ammoweapon(peluruak47, Pelor)), asserta(ammoweapon(peluruak47,Np)), Nnow is Now + Mini, asserta(ammo(Nnow)), 
			write('ak47 '), write(' is reloaded with '), write(Mini), write(' ammo. Ready for chicken dinner!'), nl, !.
use(X) :- (X == pelurupistol), weapon(W), W == pistol, ammoweapon(pelurupistol, P),P > 0, retract(ammo(Now)), Q is 7 - Now, mini(P, Q, Mini), 
			Np is P - Mini, retract(ammoweapon(peluruakpistol, Pelor)), asserta(ammoweapon(peluruapistol,Np)), Nnow is Now + Mini, asserta(ammo(Nnow)), 
			write('pistol '), write(' is reloaded with '), write(Mini), write(' ammo. Ready for chicken dinner!'), nl, !.
use(X) :- (X == peluruwatergun), weapon(W), W == watergun, ammoweapon(peluruwatergun, P), P > 0, retract(ammo(Now)), Q is 10 - Now, mini(P, Q, Mini), 
			Np is P - Mini, retract(ammoweapon(peluruwatergun, Pelor)), asserta(ammoweapon(peluruwatergun,Np)), Nnow is Now + Mini, asserta(ammo(Nnow)), 
			write('watergun '), write(' is reloaded with '), write(Mini), write(' ammo. Ready for chicken dinner!'), nl, !.
use(X) :- write('You cant use '), write(X), write(' item'). 
cekhealth(X) :- health(H), H>100, retract(health(H)), asserta(health(100)),write('Your health is maximum!'),nl,!;
			    (X == bandage), write('Your Health is increasing 10 units!'), nl, removeobject(X), !;
			    (X == betadine), write('Your Health is increasing 15 units!'), removeobject(X), nl.

changeweapon(X) :- (X \== none), retract(inventory(Inventory)), isiinventory(Inventory, Frek), (Frek < 10), 
					append([X], Inventory, TY), asserta(inventory(TY)), retract(ammo(Pelor)), asserta(ammo(0)), 
					((X \== sword, write('But the guns empty, cuy.'), nl, 
					retract(ammoweapon(X, Ada)), Newada is Ada + Pelor, asserta(ammoweapon(X, Newada))
					),!;(X == sword, nl)), !.

changeweapon(X) :- retract(inventory(Inventory)), asserta(inventory(Inventory)), retract(ammo(_)), asserta(ammo(0)),
					((X \== sword, write('But the guns empty, cuy.'), nl),!;(X == sword, nl)), !.


mini(X, Y, Z) :- (X < Y, Z is X), !.
mini(X, Y, Z) :- (Y =< X, Z is Y), !.

/* drop an object from inventory */
drop(X) :- isexist(X), isarmor(X), removeobject(X), retract(playerposition(PX, PY)), asserta(playerposition(PX, PY)), 
			asserta(armorposition(X, PX, PY)), !.
drop(X) :- isexist(X), ismedicine(X), removeobject(X), retract(playerposition(PX, PY)), asserta(playerposition(PX, PY)),
			asserta(medicineposition(X, PX, PY)), !.
drop(X) :- isexist(X), isweapon(X), removeobject(X), retract(playerposition(PX, PY)), asserta(playerposition(PX, PY)),
			asserta(weaponposition(X, PX, PY)), !.
drop(X) :- isammo(X), ammoweapon(X, Y), (Y > 0, retract(ammoweapon(X, Y)), asserta(ammoweapon(X, 0)), playerposition(PX, PY), 
			asserta(ammoposition(X, PX, PY))), !.
drop(X) :- write('You don\'t have the '), write(X), write(' item.'), nl, !.

gameover :-
	write('GAME OVER!'), nl, 
	write('Enemies left: '), enemiesleft(X), write(X), nl,
	halt.

/* Attack */
attack :-
	playerposition(X, Y),
	Startpx is X-1,
	Startpy is Y-1,
	loopattack(Startpx, Startpy).
attack :- write('There is no enemy at sight. Keep going!').

loopattack(X, Y) :-
	playerposition(Px, Py),
	Endpy is Py + 2,
	Endpx is Px + 2,
	Startpy is Py - 1,
	(
		Y == Endpy, !, Next_X is X + 1, loopattack(Next_X, Startpy);
		X < Endpx, !, (doattack(X, Y); Next_Y is Y + 1, loopattack(X, Next_Y));
		X == Endpx, !, fail
	).

doattack(Xp, Yp) :-
	enemyposition(Id,Xp,Yp),
	!, weapon(Wp), enemyweapon(Id, We),
	retract(health(Hp)), armor(Ap), Htotal is Hp + Ap, asserta(health(Htotal)),
	playerattack(Wp,We,100).

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
			asserta(health(Htotal))
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

/* Load and save game */
save(Filetxt):-
	atom_concat('savedata/', Filetxt, Filename),
	open(Filename, write, Stream),
	save_facts(Stream),
	close(Stream),
	write('Game saved successfully to '),
	write(Filename),
	write('!'), nl.

save_facts(Stream) :- save_status(Stream).
save_facts(Stream) :- save_enemies(Stream).
save_facts(Stream) :- save_armor(Stream).
save_facts(Stream) :- save_weapon(Stream).
save_facts(Stream) :- save_medicine(Stream).
save_facts(Stream) :- save_ammo(Stream).
save_facts(Stream) :- save_armorlist(Stream).
save_facts(Stream) :- save_weaponlist(Stream).
save_facts(Stream) :- save_ammoweapon(Stream).
save_facts(_) :- !.

save_status(Stream) :-
	health(Health), write(Stream, health(Health)), write(Stream, '.'), nl(Stream),
	stamina(Stamina), write(Stream, stamina(Stamina)), write(Stream, '.'), nl(Stream),
	armor(Armor), write(Stream, armor(Armor)), write(Stream, '.'), nl(Stream),
	playerposition(X, Y), write(Stream, playerposition(X, Y)), write(Stream, '.'), nl(Stream),
	weapon(Weapon), write(Stream, weapon(Weapon)), write(Stream, '.'), nl(Stream),
	ammo(Ammo), write(Stream, ammo(Ammo)), write(Stream, '.'), nl(Stream),
	inventory(Inventory), write(Stream, inventory(Inventory)), write(Stream, '.'), nl(Stream),
	step(Step), write(Stream, step(Step)), write(Stream, '.'), nl(Stream),
	fail.
	
save_enemies(Stream) :-
	enemycount(Enemies), write(Stream, enemycount(Enemies)), write(Stream, '.'), nl(Stream),
	enemiesleft(Enemies_left), write(Stream, enemiesleft(Enemies_left)), write(Stream, '.'), nl(Stream),
	!, enemyposition(Id, X, Y), write(Stream, enemyposition(Id, X, Y)), write(Stream, '.'), nl(Stream),
	enemyweapon(Id, Weapon), write(Stream, enemyweapon(Id, Weapon)), write(Stream, '.'), nl(Stream),
	fail.
	
save_armor(Stream) :- armorposition(H, X, Y), write(Stream, armorposition(H, X, Y)), write(Stream, '.'), nl(Stream), fail.
save_weapon(Stream) :- weaponposition(H, X, Y), write(Stream, weaponposition(H, X, Y)), write(Stream, '.'), nl(Stream), fail.
save_medicine(Stream) :- medicineposition(H, X, Y), write(Stream, medicineposition(H, X, Y)), write(Stream, '.'), nl(Stream), fail.
save_ammo(Stream) :- ammoposition(H, X, Y), write(Stream, ammoposition(H, X, Y)), write(Stream, '.'), nl(Stream), fail.

save_armorlist(Stream) :- armorlist(A, B), write(Stream, armorlist(A, B)), write(Stream, '.'), nl(Stream), fail.
save_weaponlist(Stream) :- weaponlist(A, B), write(Stream, weaponlist(A, B)), write(Stream, '.'), nl(Stream), fail.
save_ammoweapon(Stream) :- ammoweapon(A, B), write(Stream, ammoweapon(A, B)), write(Stream, '.'), nl(Stream), fail.

load(Filename):-
	loads(Filename).

loads(Filetxt):-
	reset,
	atom_concat('savedata/', Filetxt, Filename),
	open(Filename, read, Stream),
	repeat,
		read(Stream, In),
		asserta(In),
	at_end_of_stream(Stream),
	close(Stream),
	nl, write('Savegame has been loaded successfully!'), nl, !.

loads(Filename):-
	nl, write('File '), write(Filename), write(' isn\'t found!'), nl, fail.