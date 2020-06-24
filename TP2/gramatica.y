%{
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include "hash.h"

extern int yylex();
extern char *yytext;
int yyerror();
extern int yylineno;
int i = 0;
Subject s;
Hash *h;
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
Caderno : initCaracters Documento                           { i++;}
        | Caderno initCaracters Documento                   { i++;}
        ;  
Documento : conceito titulo Notas  Triplos                  {setConceito(*h,i,$1); setTitulo(*h,i,$2);}
          | Documento conceito titulo Notas Triplos         {setConceito(*h,i,$2); setTitulo(*h,i,$3);}
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
Triplos : initTriplos Sujeito                               {;}
        | Triplos initTriplos Sujeito                       {;}
        ; 
Sujeito : sujeito a Coisas                                  {setSubject(s,$1); setSubject_2(*h,s,i);}                                         
        | Sujeito sujeito a Coisas                          {setSubject(s,$2); setSubject_2(*h,s,i);}
        | Sujeito sujeito Coisas                            {setSubject(s,$2); setSubject_2(*h,s,i);}
        ;
Coisas  : tr virgula                                                                            { s = initSubject(); setDescription(s,$1); }
        | Coisas tr pontoVirgula                                                                {setDescription(s,$2);}
        | Coisas name descriptionName pontoVirgula                                              {setName(s,$3);}
        | Coisas birthPlace birthplaceDescription pontoVirgula                                  {setBirthPlace(s,$3);}
        | Coisas viveuem viveuemDescription virgula viveuemDescription pontoVirgula             {printf("4. ---- %s - %s e %s \n", $2, $3,$5);}
        | Coisas img imgDescription ponto                                                       {setIMG(s,$3);}                             
        | pai paiDescription ponto                                                              {s = initSubject(); setPaiDe(s,$2);}
        | filhode filhodeDescription pontoVirgula                                               {s = initSubject(); setFilhoDe(s,$2);}
        | Coisas name descriptionName                                                           {setName(s,$3);}
        | Coisas casoucom casoucomDescription ponto                                             {setCasouCom(s,$3);}
        | Coisas pai paiDescription ponto                                                       {setPaiDe(s,$3);}                                        
        ;
        
%%    
#include "lex.yy.c"

int yyerror(char *s){
  fprintf(stderr, "ERRO: %s \n", s);
  fprintf(stderr,"--\nErro sintático na linha %d\n--\n\n",yylineno); 

  return 0;
}

int main(){
  h = (Hash*)malloc(sizeof(Hash));
  init(*h);
  yyparse();
  displayHash(*h);
  return(0);
}
