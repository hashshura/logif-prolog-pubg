# logif-pubg (a.k.a. Prolog's Unknown Battlegrounds)

**Please note that the default branch is *modularize*.**

PUBG is a text-based adventure role-playing game where the user takes the role of a student who is sent to an unknown island to battle his classmates and leave the island safely. Made with Prolog, done to fulfill IF2121	Logic of Informatics's Big Mission (or whatever Tugas Besar is called).

*Welcome, Warrior. You are chosen as one of class K-3's representatives for the battle by a(n) (un)lucky lottery. Carve the way out through your opponents' corpses! ... or, should you?*

## Installation and Running
Make sure that GNU Prolog* is already installed on your PC.

* If you are using **Windows**:
1. Open GNU Prolog,
2. Change working directory to directory `/source`,
3. Run these consults:
``` bash
| ?- [attack],[enemy],[look],[main],[map],[object],[persuade],[player],[save],[spawn],[win].
```
4. Type "start." to start the game.

* If you are using **Linux**:
1. Open terminal,
2. Change working directory to directory `/source`,
3. Run:
``` bash
/source> chmod +x make.sh
/source> ./make.sh
/source> ./pubg
```
4. Type "start." to start the game.

## Cheatsheet
There are two kinds of _victory_ endings:
* Bad Ending:
``` bash
| ?- start.
| ?- take(kopyah).
| ?- s.
| ?- s.
| ?- take(ak47).
| ?- e.
| ?- n.
| ?- n.
| ?- take(peluruak47).
| ?- use(ak47).
| ?- use(peluruak47).
| ?- use(kopyah).
| ?- take(betadine).
| ?- use(betadine).
| ?- n.
| ?- e.
| ?- take(peluruak47).
| ?- use(peluruak47).
| ?- n.
| ?- take(betadine).
| ?- use(betadine).
| ?- e.
| ?- rest.
| ?- attack.
```
* Good (True) Ending:
``` bash
| ?- start.
| ?- e.
| ?- e.
| ?- e.
| ?- e.
| ?- e.
| ?- e.
| ?- e.
| ?- e.
| ?- e.
| ?- s.
| ?- rest.
| ?- s.
| ?- s.
| ?- rest.
| ?- s.
| ?- take(airballoon).
| ?- persuade.
| ?- persuade.
| ?- persuade.
| ?- persuade.
| ?- use(airballoon).
```
