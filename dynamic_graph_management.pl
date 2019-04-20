% This buffer is for notes you don't want to save.
% If you want to create a file, visit that file with C-x C-f,
% then enter the text in that file's own buffer.


:- dynamic(node/1).
node(a).
node(b).
node(c).
node(d).


:- dynamic(edge/3).
edge(a,b,4).
edge(a,c,9).
edge(b,c,7).
edge(b,d,8).
edge(d,c,10).


menu :-
	nl,
	write('Gimme the commands:\n'),
	write('inn - insert node\n'),
	write('ine - insert edge\n'),
	write('deln - delete node\n'),
	write('dele - delete edge\n'),
	write('prt - print graph\n'),
	write('shrtp - shortest path\n'),
	write('cls - close\n'),

	read(Input),
	(
	    Input = 'e';
	    parse_input(Input),
	    menu;
	    write('Not a valid imput, try again\n'),
	    menu
	).


parse_input(Input) :-
	Input = 'inn', insert_node;
	Input = 'ine', insert_edge;
	Input = 'deln', delete_node;
	Input = 'dele', delete_edge;
	Input = 'prt', print_graph;
	Input = 'shrtp', shortest_path.


insert_node :-
	write('Enter node: '), read(N),
	retractall(node(N)),
	assert(node(N)).


insert_edge :-
	write('Enter node A: '), read(A),
	write('Enter node B: '), read(B),
	write('Enter distance: '), read(D),
	retractall(edge(A,B,D)),
	assert(edge(A,B,D)).


delete_node :-
	write('Enter node: '), read(N),
	retract(node(N)),
	retractall(edge(N, _, _)),
	retractall(edge(_, N, _)).


delete_edge :-
	write('Enter node A: '), read(A),
	write('Enter node B: '), read(B),
	write('Enter distance: '), read(D),
	retract(edge(A,B,D)).


print_graph :-
	findall(N, node(N), ListN),
	findall([X,Y,D], edge(X, Y, D), ListE),
        write('Nodes: '),
	write(ListN),
	nl,
	write('Edges: '),
	write(ListE),
	nl.


path(X, Y, [X,Y],D) :-
	edge(X,Y,D).


path(X,Y,P,D) :-
	edge(X, Z, D1),
	path(Z, Y, P2, D2),
	append([X,Z], P2, P),
	D is D1 + D2.


shortest_path :-
	write('Enter node A: '),
	read(A),
	write('Enter node B: '),
	read(B),

	findall([D,P], path(A,B,P,D),L),
	(
	    write(L),
	    nl,
	    sort(L, L_Sorted),
	    L_Sorted = [SP|_],
	    write('Shortest path: '),
	    write(SP);
	    L = [],
	    write('No existing path')
	).
