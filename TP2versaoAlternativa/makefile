prog: processador.l gramatica.y
		yacc -d gramatica.y
		flex processador.l
		gcc -o prog y.tab.c
clean: 
		rm -f lex.yy.c prog y.tab.* output.html

run: prog

run2 : 
		./prog < ex.caderno