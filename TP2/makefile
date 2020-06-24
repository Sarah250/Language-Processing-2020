prog: processador.l gramatica.y
		yacc -d gramatica.y
		flex processador.l
		gcc -o prog hash.c y.tab.c
clean: 
		rm -f lex.yy.c prog y.tab.* *.txt

run : 
		./prog < ex.caderno