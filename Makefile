parser: y.tab.c
	gcc -o parser y.tab.c
y.tab.c: souffle.y lex.yy.c
	yacc souffle.y
lex.yy.c: souffle.l
	lex souffle.l

