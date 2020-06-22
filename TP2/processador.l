%{
#include "y.tab.h"
%}
%option noyywrap   
%option yylineno

acentos    \xc3[\x80-\xbf]       
letra      [a-zA-Z]|{acentos}
simbolos   [\-()/'.,\t ]
numeros    [0-9]
texto      {letra}|{simbolos}|{numeros}

%x CONCEITO TITULO NOTA TRIPLE DESCRIPTION SOMETHING DES
%%
[=]{3}[ ]*                    {    BEGIN CONCEITO;
                                   return initCaracters;
                              }

<CONCEITO>[:]{letra}+[\n]     {    BEGIN INITIAL;
                                   yylval.str = strndup(yytext,strlen(yytext)-1);
                                   return conceito;
                              }
                                
("@tit:")[ ]+                 {    BEGIN TITULO;}
<TITULO>{texto}*[\n]          {    BEGIN INITIAL;
                                   yylval.str = strndup(yytext,strlen(yytext)-1); 
                                   return titulo;
                              }
[#][ ]*                       {    BEGIN NOTA;}
<NOTA>{texto}+[\n]            {    BEGIN INITIAL; 
                                   yylval.str = strndup(yytext,strlen(yytext)-1); 
                                   return nota; 
                              }
^{letra}{texto}+              {    yylval.str = strdup(yytext);
                                   return comentario;
                              }
^[.]+{texto}+                 {    yylval.str = strdup(yytext);
                                   return comentario;
                              }
^"@triplos:"                  {    BEGIN TRIPLE; 
                                   return initTriplos;
                              }
<TRIPLE>^[:]{letra}+          {    BEGIN INITIAL;
                                   yylval.str = strdup(yytext); 
                                   return sujeito;
                              }
[\t ]*[a]                     { return a;}
[\t ]+[:]{letra}+[\t ]+       {return t0;}

%%
