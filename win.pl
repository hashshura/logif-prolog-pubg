gameover :-
	write('GAME OVER!'), nl, 
	write('Enemies left: '), enemiesleft(X), write(X), nl,
	halt.

checkvictory :-
	(\+ enemyposition(_,_,_), enemiesleft(X), X < 4, !, victory; 1 == 1).	

victory :-
	nl,
	write('A loud bell is ringing.'), nl,
	write('"Congratulations, Warrior!", a worrisome shouting is heard.'), nl, nl,
	write('You have killed all of your enemies.'), nl,
	write('Or to be exact, "classmates". "Comrades".'), nl,
	write('Is this really what you wanted from the start?'), nl, nl,
	gameover.

truevictory :-
	write('You launch the airballoon.'), nl, nl,
	write('Soaring high to the sky.'), nl,
	write('Leaving the arena, leaving the deadzone.'), nl,
	write('"Goodbye, hell," everyone whispers.'), nl,
	nl,
	write('CONGRATULATIONS'), nl,
	write('You have beaten the game!'), nl,
	write('Secret savegame: \'imba\'.'), nl,
	write('Go load him, the Imba Warrior!'), nl,
	halt.
