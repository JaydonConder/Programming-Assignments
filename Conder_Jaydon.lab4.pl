%Jaydon Conder
% CSCI 305 Lab 4
:- consult('royal.pl').

%returns the female parent.
mother(M,C):- parent(M,C), female(M).
%returns the male parent.
father(F,C):- parent(F,C), male(F).
% the spouse can be written on either side of the 'married' data, so it
% checks both sides to see who the person how was inputted was married
% to.
spouse(X,Y) :- married(X,Y); married(Y,X).
%returns the child of the person inputted.
child(X,Y) :- parent(Y,X).
%returns the male child.
son(X,Y) :- child(X,Y), male(X).
%returns the female child.
daughter(X,Y) :- child(X,Y), female(X).
% returns all people that have the same mother and father. I didn't use
% parent instead of using both father and mother because it would return
% doubles of everything.
sibling(X,Y) :- father(F,X), father(F,Y), mother(M,X), mother(M,Y), X\=Y.
%returns the male siblings.
brother(X,Y) :- sibling(X,Y), male(X).
%returns the female siblings.
sister(X,Y) :- sibling(X,Y), female(X).
% returns the parents' brothers and the inputted person's spouse's
% uncles.
uncle(X,Y) :- parent(Z,Y), brother(X,Z); spouse(S,Y), parent(Z,S), brother(X,Z).
%returns the parents' sisters and the inputted person's spouse's aunts.
aunt(X,Y) :- parent(Z,Y), sister(X,Z); spouse(S,Y), parent(Z,S), sister(X,Z).
%returns the parents of the parents (the grandparents).
grandparent(X,Y) :- parent(X,Z), parent(Z,Y).
%returns the male grandparents.
grandfather(X,Y) :- grandparent(X,Y), male(X).
%returns the female grandparents.
grandmother(X,Y) :- grandparent(X,Y), female(X).
%returns all grandchildren.
grandchild(X,Y) :- grandparent(Y,X).
% returns all of the people above the inputted person on the family
% tree. It does this recursively by calling all of the parents of all of
% the parents, as far back as it can go.
ancestor(X,Y) :- parent(X,Y); parent(X,Z), ancestor(Z,Y).
% returns all of the children and their direct descendants on the family
% tree. It does this by recursively calling all of the children of the
% children of the children, etc.
descendant(X,Y) :- child(X,Y); child(X,Z), descendant(Z,Y).
% Checks to see if person 'X' was born before person 'Y', and if so,
% returns true.
older(X,Y) :- born(X,A), born(Y,B), (A < B).
% Checks to see if person 'X' was born after person 'Y', and if so,
% returns true.
younger(X,Y):- born(X,A), born(Y,B), (A > B).

% only seems to work sometimes, although it works with the question you
% asked.
regentWhenBorn(X,Y) :- born(Y, A), regentHelper(A, 1819, X).
% helper method for regentWhenBorn that finds who reigned at the
% current time inputted, finds the years that person reigned, checks if
% the year the inputted person was born is in that range. If it is, it
% returns the person who reigned at the current dates and if not, it
% recursively calls itself with the person who reigned before the
% current person.
regentHelper(A,B,X) :- reigned(C, B, D), (between(B,D,A) -> C = X;
 regentHelper(A,D,X)).
