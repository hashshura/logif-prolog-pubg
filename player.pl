/*inventory rules */
isiinventory([], 0).
isiinventory([_|T], X) :- isiinventory(T, Y), X is (Y + 1). 

printinventory([]).
printinventory([H|T]) :- write(' - '), write(H), nl, printinventory(T).

isada(_, []) :- false.
isada(Object, [H|_]) :- (Object == H), !.
isada(Object, [_|T]) :- isada(Object, T), !.
isexist(Object) :- retract(inventory(I)), asserta(inventory(I)), isada(Object, I).

del(X,[X|Tail], Tail).
del(X,[Y|Tail], [Y|Tail1]) :- del(X, Tail, Tail1).

removeobject(Object) :- retract(inventory(Inventory)), del(Object, Inventory, Newinventory), asserta(inventory(Newinventory)).

jumlahammo(X) :- ammoweapon(peluruak47, P), ((P > 0, A is 1),!;(P == 0, A is 0)), 
            	 ammoweapon(pelurupistol, Q), ((Q > 0, B is 1),!;(Q == 0, B is 0)),
            	 ammoweapon(peluruwatergun, R), ((R > 0, C is 1),!;(R == 0, C is 0)), 
            	 X is A + B + C, !.

addinventory(Object, _, _) :- inventory(Inventory), isiinventory(Inventory, Frek), jumlahammo(Jumlahammo),
                              ((Frek + Jumlahammo) < 10), append([Object], Inventory, TY), retract(inventory(_)), asserta(inventory(TY)), 
							  write('You took the '), write(Object), write('!'), nl, !.

addinventory(Object, X, Y) :- isweapon(Object), asserta(weaponposition(Object, X, Y)), write('Inventory is full!'), nl, !.
addinventory(Object, X, Y) :- isarmor(Object), asserta(armorposition(Object, X, Y)), write('Inventory is full!'), nl, !.
addinventory(Object, X, Y) :- ismedicine(Object), asserta(medicineposition(Object, X, Y)), write('Inventory is full!'), nl, !.
addinventory(Object, X, Y) :- Object == airballoon, asserta(secretposition(Object, X, Y)), write('Sadly, your inventory is too full for this airballoon to fit!'), nl, !.

addammo(Ammo, _, _) :- (Ammo == pelurupistol), !, retract(ammoweapon(pelurupistol, P)), YY is P+4, asserta(ammoweapon(Ammo, YY)), 
					   write('You took the '), write(Ammo), write('!'), !.
addammo(Ammo, _, _) :- (Ammo == peluruak47), !, retract(ammoweapon(peluruak47, P)), YY is P+6, asserta(ammoweapon(Ammo, YY)), 
						write('You took the '), write(Ammo), write('!'), !.
addammo(Ammo, _, _) :- (Ammo == peluruwatergun), !, retract(ammoweapon(peluruwatergun, P)), YY is P+9, asserta(ammoweapon(Ammo, YY)), 
						write('You took the '), write(Ammo), write('!'), !. 

printstatusinventory(I) :- isiinventory(I,X), (X == 0), jumlahammo(Y), (Y == 0), write(' Your inventory is empty!'), nl, !.
printstatusinventory(I) :- isiinventory(I,XX), (XX > 0), jumlahammo(YY), (YY == 0), printinventory(I), !.
printstatusinventory(I) :- isiinventory(I,XXX), (XXX > 0), jumlahammo(YYY), (YYY > 0), printinventory(I), printinventoryammo1, printinventoryammo2, printinventoryammo3, !.
printstatusinventory(I) :- isiinventory(I,XXXX), (XXXX == 0), jumlahammo(YYYY), (YYYY > 0), printinventoryammo1, printinventoryammo2, printinventoryammo3.

printinventoryammo1 :- ammoweapon(peluruak47, X), (X > 0), write(' - '), write(peluruak47), nl,!;
					   1==1.
printinventoryammo2 :- ammoweapon(pelurupistol, X), (X > 0), write(' - '), write(pelurupistol), nl,!;
					   1==1.
printinventoryammo3 :- ammoweapon(peluruwatergun, X), (X > 0), write(' - '), write(peluruwatergun), nl,!;
					   1==1.

/*player status*/
status :-
		write('[Lone Warrior]'), nl,
		write(' Health    : '), health(H), write(H), nl,
		write(' Stamina   : '), stamina(S), write(S), nl, 
		write(' Armor     : '), armor(Ar), write(Ar), nl, 
		write(' Weapon    : '), weapon(W), write(W), nl, 
		write(' Ammo      : '), ammo(Ammo), write(Ammo), nl, 
		write(' Inventory : '), nl, inventory(Inventory), printstatusinventory(Inventory), !.

/* movement rules */
w :- cekstamina, inc, retract(playerposition(X, Y)), Next_y is Y-1, asserta(playerposition(X, Next_y)), printwalk,
	 retract(stamina(S)), N is S-10, asserta(stamina(N)), enemywalk(1), !;
	 write('You don\'t have enough stamina to walk, please take a rest first!').
s :- cekstamina, inc, retract(playerposition(X, Y)), Next_x is X+1, asserta(playerposition(Next_x, Y)), printwalk,
	 retract(stamina(S)), N is S-10, asserta(stamina(N)), enemywalk(1), !;
	 write('You don\'t have enough stamina to walk, please take a rest first!').
e :- cekstamina, inc, retract(playerposition(X, Y)), Next_y is Y+1, asserta(playerposition(X, Next_y)), printwalk,
	 retract(stamina(S)), N is S-10, asserta(stamina(N)), enemywalk(1), !;
	 write('You don\'t have enough stamina to walk, please take a rest first!').
n :- cekstamina, inc, retract(playerposition(X, Y)), Next_x is X-1, asserta(playerposition(Next_x, Y)), printwalk,
	 retract(stamina(S)), N is S-10, asserta(stamina(N)), enemywalk(1), !;
	 write('You don\'t have enough stamina to walk, please take a rest first!').

cekstamina :- stamina(N), N>=10.

/*rest for players*/
rest :-
	inc, enemywalk(1), retract(stamina(Prev)), Now is Prev+20, asserta(stamina(Now)), restmax,
	write('You rest for a while, increasing your stamina by 20.'), nl,
	playerposition(X, Y),
	(
		deadzone(X, Y),
		write('Alas, sometimes "a while" does mean forever. Your resting place has become a deadzone.'), nl,
		write('"A Warrior attempts trespassing," a voice reverberates.'), nl, nl,
		write('ZZAP! The electromagnetic force inside the deadzone ravages your intestines.'), nl,
		write('Blood gushing through your veins, you are now sleeping so soundly...'), nl, nl,
		gameover, !;
		1 == 1
	).

restmax :-
	(stamina(Now), Now > 100, !, retract(stamina(Now)), asserta(stamina(100)));
	stamina(_).	

