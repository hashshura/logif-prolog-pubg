/*classify an object */
isweapon(X) :- (X == pistol);(X == watergun);(X == sword);(X == ak47).
ismedicine(X) :- (X == bandage); (X == betadine).
isarmor(X) :- (X == hat);(X == vest);(X == helmet);(X == kopyah).
isammo(X) :- (X == peluruak47); (X == pelurupistol); (X == peluruwatergun).

/*take an object and placed it to inventory */
take(X) :- X == airballoon, playerposition(PX, PY), 
            secretposition(X, PX, PY), takesecret(PX, PY), enemywalk(1), !,
			(isexist(airballoon),
				write('You now own an airballoon!'), nl,
				write('A new available command has been unlocked: '), nl,
				write('    persuade. -- persuade nearby "enemies" to join your voyage through the high air'), nl, !
			; 1 == 1).
take(X) :- isweapon(X), retract(playerposition(PX, PY)), asserta(playerposition(PX, PY)), 
            weaponposition(X, PX, PY), takeweapon(PX, PY), enemywalk(1), !.
take(X) :- isarmor(X), retract(playerposition(PX, PY)), asserta(playerposition(PX, PY)), 
            armorposition(X, PX, PY), takearmor(PX, PY), enemywalk(1), !.
take(X) :- ismedicine(X), retract(playerposition(PX, PY)), asserta(playerposition(PX, PY)), 
            medicineposition(X, PX, PY), takemedicine(PX, PY), enemywalk(1), !.
take(X) :- isammo(X), retract(playerposition(PX, PY)), asserta(playerposition(PX, PY)), 
            ammoposition(X, PX, PY), takeammo(X, PX, PY), enemywalk(1), !.
take(X) :- write(X), write(' is not available in this area.'), nl, enemywalk(1), !.

takesecret(X, Y) :- retract(secretposition(Secret, X, Y)), addinventory(Secret, X, Y),!.
takeweapon(X, Y) :- retract(weaponposition(Weapon, X, Y)), addinventory(Weapon, X, Y),!.
takearmor(X, Y) :- retract(armorposition(Armor, X, Y)), addinventory(Armor, X, Y),!.
takemedicine(X, Y) :- retract(medicineposition(Medicine, X, Y)), addinventory(Medicine,X,Y),!.
takeammo(Ammo, X, Y) :- retract(ammoposition(Ammo, X, Y)), addammo(Ammo, X, Y). 

/*use an object in inventory, and removed it from inventory */
use(X) :- isexist(X), X == airballoon,
	(
		\+ enemyposition(_,_,_), enemiesleft(4), !, truevictory;
		write('You feel like it\'s not okay to launch the airballoon'), nl, write('without all five of the "Warriors".'), nl, !
	), !.
use(X) :- isexist(X), isweapon(X), retract(weapon(W)), write(X), write(' is equipped. '), asserta(weapon(X)), removeobject(X), changeweapon(W), enemywalk(1), !. 
use(X) :- isexist(X), (X == bandage), retract(health(H)), NewH is H + 10, asserta(health(NewH)), cekhealth(X), enemywalk(1), removeobject(X), !.
use(X) :- isexist(X), (X == betadine), retract(health(H)), NewH is H + 15, asserta(health(NewH)), cekhealth(X), enemywalk(1), removeobject(X), !.
use(X) :- isexist(X), (X == hat), retract(armor(Armor)),Newarmor is Armor + 5, asserta(armor(Newarmor)), removeobject(X), cekarmor(X), enemywalk(1), !.
use(X) :- isexist(X), (X == vest), retract(armor(Armor)),Newarmor is Armor + 10, asserta(armor(Newarmor)), removeobject(X), cekarmor(X), enemywalk(1), !.
use(X) :- isexist(X), (X == helmet), retract(armor(Armor)),Newarmor is Armor + 15, asserta(armor(Newarmor)), removeobject(X), cekarmor(X), enemywalk(1), !.
use(X) :- isexist(X), (X == kopyah), retract(armor(Armor)),Newarmor is Armor + 20, asserta(armor(Newarmor)), removeobject(X), cekarmor(X), enemywalk(1), !.
use(X) :- (X == peluruak47), weapon(W), W == ak47, ammoweapon(peluruak47, P), P > 0, retract(ammo(Now)), Q is 5 - Now, mini(P, Q, Mini), 
			Np is P - Mini, retract(ammoweapon(peluruak47, _)), asserta(ammoweapon(peluruak47,Np)), Nnow is Now + Mini, asserta(ammo(Nnow)), 
			write('ak47 '), write(' is reloaded with '), write(Mini), write(' ammo. Ready for chicken dinner!'), nl, enemywalk(1), !.
use(X) :- (X == pelurupistol), weapon(W), W == pistol, ammoweapon(pelurupistol, P),P > 0, retract(ammo(Now)), Q is 7 - Now, mini(P, Q, Mini), 
			Np is P - Mini, retract(ammoweapon(peluruakpistol, _)), asserta(ammoweapon(pelurupistol,Np)), Nnow is Now + Mini, asserta(ammo(Nnow)), 
			write('pistol '), write(' is reloaded with '), write(Mini), write(' ammo. Ready for chicken dinner!'), nl, enemywalk(1), !.
use(X) :- (X == peluruwatergun), weapon(W), W == watergun, ammoweapon(X, P), P > 0, retract(ammo(Now)), Q is 10 - Now, mini(P, Q, Mini), 
			Np is P - Mini, retract(ammoweapon(peluruwatergun, _)), asserta(ammoweapon(peluruwatergun,Np)), Nnow is Now + Mini, asserta(ammo(Nnow)), 
			write('watergun '), write(' is reloaded with '), write(Mini), write(' ammo. Ready for chicken dinner!'), nl, enemywalk(1), !.
use(X) :- write('You can\'t use '), write(X), write(' item.'), nl, enemywalk(1). 

cekhealth(X) :- health(H), H>100, retract(health(H)), asserta(health(100)),write('Your health is maximum!'),nl,!;
			    (X == bandage), write('Your Health is increasing 10 units!'), nl, !;
			    (X == betadine), write('Your Health is increasing 15 units!'), nl.

cekarmor(X) :- armor(A), A>100, retract(armor(A)), asserta(armor(100)),write('Your Armor is maximum!'),nl,!;
			    (X == hat), write('Your Armor is increasing 5 units!'), nl, !;
			    (X == vest), write('Your Armor is increasing 10 units!'), nl, !;
			    (X == helmet), write('Your Armor is increasing 15 units!'), nl, !;
			    (X == kopyah), write('Your Armor is increasing 20 units!'), nl.


changeweapon(X) :- (X \== none), retract(inventory(Inventory)), isiinventory(Inventory, Frek), (Frek < 10), 
					append([X], Inventory, TY), asserta(inventory(TY)), retract(ammo(Pelor)), asserta(ammo(0)), 
					((X \== sword, write('But the guns empty, cuy.'), nl,
					((X==pistol,retract(ammoweapon(pelurupistol, Ada)), Newada is Ada + Pelor, asserta(ammoweapon(pelurupistol, Newada)),!);
					 (X==ak47, retract(ammoweapon(peluruak47, Ada)), Newada is Ada + Pelor, asserta(ammoweapon(peluruak47, Newada)),!);
					 (X==watergun, retract(ammoweapon(peluruwatergun, Ada)), Newada is Ada + Pelor, asserta(ammoweapon(peluruwatergun, Newada)))) 
					),!;(X == sword, nl)), !.

changeweapon(X) :- (X == none), retract(inventory(Inventory)), asserta(inventory(Inventory)), retract(ammo(_)), asserta(ammo(0)),
					((X \== sword, write('But the guns empty, cuy.'), nl),!;(X == sword, nl)), !.


mini(X, Y, Z) :- (X < Y, Z is X), !.
mini(X, Y, Z) :- (Y =< X, Z is Y), !.

/* drop an object from inventory */
drop(X) :- X == airballoon, !, write('You feel not like dropping the airballoon.'), nl.
drop(X) :- isexist(X), isarmor(X), removeobject(X), retract(playerposition(PX, PY)), asserta(playerposition(PX, PY)), 
			asserta(armorposition(X, PX, PY)), write('You drop '), write(X), write(' item'), enemywalk(1), !.
drop(X) :- isexist(X), ismedicine(X), removeobject(X), retract(playerposition(PX, PY)), asserta(playerposition(PX, PY)),
			asserta(medicineposition(X, PX, PY)), write('You drop '), write(X), write(' item'), enemywalk(1), !.
drop(X) :- isexist(X), isweapon(X), removeobject(X), retract(playerposition(PX, PY)), asserta(playerposition(PX, PY)),
			asserta(weaponposition(X, PX, PY)), write('You drop '), write(X), write(' item'), enemywalk(1), !.
drop(X) :- isammo(X), ammoweapon(X, Y), (Y > 0, retract(ammoweapon(X, Y)), asserta(ammoweapon(X, 0)), playerposition(PX, PY), 
			asserta(ammoposition(X, PX, PY))), write('You drop '), write(X), write(' item'), enemywalk(1), !.
drop(X) :- write('You don\'t have the '), write(X), write(' item.'), nl, enemywalk(1), !.

