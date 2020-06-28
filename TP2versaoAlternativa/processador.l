%{
#include "y.tab.h"
#include "ctype.h"

char* aux; 

/* Funçao que tira os espaços em branco do inicio da string str */
char* trimSpace(char *str){
  while(isspace((unsigned char) *str) || ((unsigned char) *str) == ':') str++;
  return str;
}

%}

%option noyywrap   
%option yylineno

acentos    \xc3[\x80-\xbf]       
letra      [a-zA-Z]|{acentos}
simbolos   [\-()/'.,\t ]
simbolos2  [_]
simbolos3  [_\-()/'.\t ]
numeros    [0-9]
texto      {letra}|{simbolos}|{numeros}
texto2     {letra}|{simbolos2}
texto3     {letra}|{simbolos3}|{numeros}

%x INICIO DOCTITULO DOCNOTA TRIPLOS TRIPLO RELACAO IMAGE
%%
[=]{3}[ ]*                    	    {	BEGIN INICIO; }

<INICIO>[:]{letra}+$     	      {  BEGIN INITIAL;
                                   	   aux = strdup(yytext); aux = trimSpace(aux); yylval.str = strdup(aux);
                                   	   return CONCEITO;
                              	    }
("@tit:")[ ]*                 	    {	 BEGIN DOCTITULO; }

<DOCTITULO>{texto}*[\n]     	      {	 BEGIN INITIAL;
                                   	   yylval.str = strndup(yytext,strlen(yytext)-1); 
                                   	   return TITULO;
                              	    }
[#][ ]*                       	    {  BEGIN DOCNOTA; }

<DOCNOTA>{texto}+[\n]               {  BEGIN INITIAL; 
                                   	   yylval.str = strndup(yytext,strlen(yytext)-1); 
                                   	   return TITULONOTA; 
                              	    }
^{letra}{texto}+                    {  yylval.str = strdup(yytext);
                                       return STR;
                                    }
^[.]+{texto}+                       {  yylval.str = strdup(yytext);
                                       return STR;
                                    }

^@triplos:                          {  BEGIN TRIPLOS; }

<TRIPLOS>^[:]{letra}+               {  BEGIN TRIPLO;
                                       aux = strdup(yytext); aux = trimSpace(aux); yylval.str = strdup(aux); return TRIPLONOME; }

<TRIPLO>^[\t| ]+a               {  BEGIN RELACAO; aux = strdup(yytext); aux = trimSpace(aux); yylval.str = strdup(aux); return NOMERELACAO; }
<TRIPLO>[ ]+[:](?:img)          {  BEGIN IMAGE; aux = strdup(yytext); aux = trimSpace(aux); yylval.str = strdup(aux); return NOMERELACAO; }
<TRIPLO>^[\t| ]+[:]{texto2}+    {  BEGIN RELACAO; aux = strdup(yytext); aux = trimSpace(aux); yylval.str = strdup(aux); return NOMERELACAO; }

<IMAGE>["]{texto}+["]           {  aux = strdup(yytext); aux = trimSpace(aux); yylval.str = strdup(aux); return IMAGEM;}
<IMAGE>[;]                      {  BEGIN TRIPLO; }
<IMAGE>[.]                      {  BEGIN TRIPLOS; }

<RELACAO>[ ]+["]{texto3}+["]        {  aux = strdup(yytext); aux = trimSpace(aux); yylval.str = strdup(aux); return NOMECOMPLEMENTO; }
<RELACAO>[ ]+[:]{texto2}+           {  aux = strdup(yytext); aux = trimSpace(aux); yylval.str = strdup(aux); return NOMECOMPLEMENTO; }
<RELACAO>[;]                        {  BEGIN TRIPLO; }
<RELACAO>[.]$                       {  BEGIN TRIPLOS; }

<TRIPLOS>[=]{3}[ ]*                 {  BEGIN INICIO; }

.|\n 								{;}

%%
