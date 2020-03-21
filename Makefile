tp1: tp1.fl
		flex tp1.fl
		gcc -o tp1 hash.c lex.yy.c
clean: 
		rm -f lex.yy.c tp1