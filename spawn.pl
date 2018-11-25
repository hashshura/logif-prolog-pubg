/* armor, weapon, ammo, and medicine places */
spawnarmor :-
	asserta(armorposition(helmet,5,13)),
	asserta(armorposition(kopyah,4,12)),
	asserta(armorposition(helmet,2,20)),
	asserta(armorposition(helmet,11,2)),
	asserta(armorposition(vest,17,18)),
	asserta(armorposition(kopyah,10,2)),
	asserta(armorposition(kopyah,9,3)),
	asserta(armorposition(vest,3,14)),
	asserta(armorposition(hat,19,4)),
	asserta(armorposition(hat,5,5)).

spawnweapon :-
	asserta(weaponposition(pistol,6,6)),
	asserta(weaponposition(ak47,10,10)),
	asserta(weaponposition(ak47,12,2)),
	asserta(weaponposition(sword,12,12)),
	asserta(weaponposition(watergun,3,2)),
	asserta(weaponposition(watergun,14,3)),
	asserta(weaponposition(pistol,2,3)),
	asserta(weaponposition(ak47,15,15)).

weaponinit :-
	asserta(weaponlist(ak47,70)),
	asserta(weaponlist(pistol,30)),
	asserta(weaponlist(watergun,20)),
	asserta(weaponlist(sword,35)),
	asserta(weaponlist(grenade, 25)),
	asserta(weaponlist(none, 0)).
	
spawnammo :-
	asserta(ammoposition(peluruwatergun,5,6)),
	asserta(ammoposition(peluruak47,4,6)),
	asserta(ammoposition(pelurupistol,2,4)),
	asserta(ammoposition(peluruak47,2,2)),
	asserta(ammoposition(peluruak47,9,4)),
	asserta(ammoposition(peluruak47,10,3)),
	asserta(ammoposition(peluruwatergun,3,3)),
	asserta(ammoposition(peluruwatergun,11,4)).
	
ammoinit :-
	asserta(ammoweapon(pelurupistol, 0)),
	asserta(ammoweapon(peluruak47, 0)),
	asserta(ammoweapon(peluruwatergun, 0)).

spawnmedicine :- 
	asserta(medicineposition(betadine,4,16)),
	asserta(medicineposition(betadine,10,6)),
	asserta(medicineposition(betadine,2,2)),
	asserta(medicineposition(betadine,8,9)),
	asserta(medicineposition(betadine,7,4)),
	asserta(medicineposition(betadine,6,4)),
	asserta(medicineposition(betadine,10,3)),
	asserta(medicineposition(betadine,8,4)),
	asserta(medicineposition(betadine,10,4)),
	asserta(medicineposition(bandage,20,10)),
	asserta(medicineposition(bandage,6,15)),
	asserta(medicineposition(bandage,3,7)),
	asserta(medicineposition(bandage,12,4)).
