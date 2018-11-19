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

health(100).
playerposition(0,0).
stamina(100).
armor(0).

/*temporary rules */
w :- inc, retract(playerposition(X, Y)), Next_y is Y-1, asserta(playerposition(X, Next_Y)).
s :- inc, retract(playerposition(X, Y)), Next_x is X+1, asserta(playerposition(Next_x, Y)).
e :- inc, retract(playerposition(X, Y)), Next_y is Y+1, asserta(playerposition(X, Next_y)).
n :- inc, retract(playerposition(X, Y)), Next_x is X-1, asserta(playerposition(Next_x, Y)).

