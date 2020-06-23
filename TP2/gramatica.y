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
%token <str> tr
%token <str> virgula
%token <str> pontoVirgula
%token <str> name
%token <str> descriptionName
%token <str> birthPlace
%token <str> birthplaceDescription
%token <str> viveuem
%token <str> viveuemDescription
%token <str> imgDescription
%token <str> img
%token <str> ponto
%token <str> paiDescription
%token <str> pai
%token <str> filhodeDescription
%token <str> filhode
%token <str> casoucom
%token <str> casoucomDescription
%%
Caderno : initCaracters Documento                           {printf("1. %s", "HELLO");}
        | Caderno initCaracters Documento                   {printf("2. %s", "HELLO");}
        ;  
Documento : conceito titulo Notas  Triplos                  {printf("1. conceito = %s\ntitulo = %s\n", $1, $2);}
          | Documento conceito titulo Notas Triplos         {printf("2. conceito = %s\ntitulo = %s\n", $2, $3);}
          ;
Notas : nota Comentarios                                    {printf("nota = %s\n", $1);}
      | nota                                                {printf("nota = %s\n", $1);}
      | Notas nota Comentarios                              {printf("nota = %s\n", $2);}
      | Notas nota                                          {printf("nota = %s\n", $2);}
      | Comentarios                                         {printf("Comentarios\n");}
      ;
Comentarios : comentario                                    {printf("comentario = %s\n", $1);}
            | Comentarios comentario                        {printf("comentario = %s\n", $2);}
            ;
Triplos : initTriplos Sujeito                               {printf("---- Triplos ----- \n");}
        | Triplos initTriplos Sujeito                       {printf("---- Triplos ----- \n");}
        ; 
Sujeito : sujeito a Coisas                                  {printf("1. SUJEITO = %s\n",$1);}                                         
        | Sujeito sujeito a Coisas                          {printf("2. SUJEITO = %s\n",$2);}
        | Sujeito sujeito Coisas                            {printf("3. SUJEITO = %s\n",$2);}
        ;
Coisas  : tr virgula                                                                    {printf("t0 = %s\n",$1);}
        | Coisas tr pontoVirgula                                                        {printf("tr =  %s\n", $2);}
        | Coisas name descriptionName pontoVirgula                                      {printf("2. ---- %s - %s\n", $2, $3);}
        | Coisas birthPlace birthplaceDescription pontoVirgula             {printf("3. ---- %s - %s \n", $2, $3);}
        | Coisas viveuem viveuemDescription virgula viveuemDescription pontoVirgula                   {printf("4. ---- %s - %s e %s \n", $2, $3,$5);}
        | Coisas img imgDescription ponto                                                                  {printf("5. ---- %s - %s\n", $2, $3);}                             
        | pai paiDescription ponto                                              {printf("6. ---- %s - %s\n", $1, $2);}
        | filhode filhodeDescription pontoVirgula                                      {printf("7. ---- %s - %s\n", $1, $2);}
        | Coisas name descriptionName                                                   {printf("8. ---- %s - %s\n", $2, $3);}
        | Coisas casoucom casoucomDescription ponto                                     {printf("9. ---- %s - %s\n", $2, $3);}
        | Coisas pai paiDescription ponto                                               {printf("10. ---- %s - %s\n", $2, $3);}                                        
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
