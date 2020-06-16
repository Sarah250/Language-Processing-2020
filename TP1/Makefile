tp1: tp1.l
		flex tp1.l
		gcc -o tp1 hash.c lex.yy.c
clean: 
		rm -f lex.yy.c tp1 tp1_ex5_g19.html tp1_ex5_g19.json
run: tp1
		./tp1  < Sol4.html
		nodejs index.js