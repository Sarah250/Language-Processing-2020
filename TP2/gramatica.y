%{
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
// evitar warnnings
extern int yylex();
extern char *yytext;
int yyerror();
extern int yylineno;
%}
%union{char * str;}
%token <str> initCaracters
%token <str> conceito
%token <str> titulo
%token <str> nota
%token <str> comentario
%token <str> initTriplos
%token <str> sujeito
%token <str> a
%token <str> t0
%%
Caderno : initCaracters Documento                           {printf("%s", "1.HELLO");}
        | Caderno initCaracters Documento                   {printf("%s", "2.HELLO");}
        ;  
Documento : conceito titulo Notas  Triplos                  {printf("conceito = %s\ntitulo = %s\n", $1, $2);}
          | Documento conceito titulo Notas Triplos         {printf("conceito = %s\ntitulo = %s\n", $2, $3);}
          ;
Notas : nota Comentarios                                    {printf("nota = %s\n", $1);}
      | nota                                                {printf("nota = %s\n", $1);}
      | Notas nota Comentarios                              {printf("nota = %s\n", $2);}
      | Notas nota                                          {printf("nota = %s\n", $2);}
      ;
Comentarios : comentario                                    {printf("comentario = %s\n", $1);}
            | Comentarios comentario                        {printf("comentario = %s\n", $2);}
            ;
Triplos : initTriplos Sujeito                               {printf("---- Triplos ----- \n");}
        ; 
Sujeito : sujeito a t0                                       {printf("SUJEITO = %s, t0 = %s\n",$1, $3);}                                         
        ;
%%    
#include "lex.yy.c"

int yyerror(char *s){
  fprintf(stderr, "ERRO: %s \n", s);
  fprintf(stderr,"--\nErro sintático na linha %d\n--\n\n",yylineno); 

  return 0;
}

int main(){
  yyparse();
  return(0);
}
