/* Load and save game */
gsave(Filetxt):-
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

save_weaponlist(Stream) :- weaponlist(A, B), write(Stream, weaponlist(A, B)), write(Stream, '.'), nl(Stream), fail.
save_ammoweapon(Stream) :- ammoweapon(A, B), write(Stream, ammoweapon(A, B)), write(Stream, '.'), nl(Stream), fail.

gload(Filename):-
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