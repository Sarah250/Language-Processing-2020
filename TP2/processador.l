%{
#include "y.tab.h"
%}
%option noyywrap   
%option yylineno

acentos    \xc3[\x80-\xbf]       
letra      [a-zA-Z]|{acentos}
simbolos   [\-()/'.,\t ]
simbolos2  [_]
numeros    [0-9]
texto      {letra}|{simbolos}|{numeros}
texto2     {letra}|{simbolos2}

%x CONCEITO TITULO NOTA  IMG FILHODE CASOUCOM TRIPLE DESCRIPTION SOMETHING DES NAME BIRTHPLACE VIVEUEM PAI
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
^"@triplos:"                  {    
                                   BEGIN TRIPLE;
                                   return initTriplos;
                              }
<TRIPLE>^[:]{letra}+          {    
                                   BEGIN DESCRIPTION;
                                   yylval.str = strndup(yytext, strlen(yytext)); 
                                   return sujeito;
                              }
<TRIPLE>[=]{3}[ ]*            {    
                                   BEGIN CONCEITO;
                                   return initCaracters;
                              }
<DESCRIPTION>[\t ]*[a]        {    return a;}
<DESCRIPTION>[:](?i:pai_de)   {    
                                   BEGIN PAI;
                                   yylval.str = strdup(yytext);
                                   return pai; 
                              }
<PAI>[:]{letra}+                   {    
                                        BEGIN DESCRIPTION;
                                        yylval.str = strdup(yytext);
                                        return paiDescription;  
                                   }
<DESCRIPTION>[:](?i:casou_com)     {
                                        BEGIN CASOUCOM;
                                        yylval.str = strdup(yytext);
                                        return casoucom; 
                                   }
<CASOUCOM>[:]{letra}+              {
                                        BEGIN DESCRIPTION;
                                        yylval.str = strdup(yytext);
                                        return casoucomDescription;
                                   }
<DESCRIPTION>[:](?i:name)          {    BEGIN NAME;
                                        yylval.str = strdup(yytext);
                                        return name;     
                                   }
<DESCRIPTION>[:](?i:filho_de)      {    BEGIN FILHODE;
                                        yylval.str = strdup(yytext);
                                        return filhode;
                                   }
<FILHODE>[:]{letra}+                {    BEGIN DESCRIPTION;
                                        yylval.str = strdup(yytext);
                                        return filhodeDescription;
                                   }
<DESCRIPTION>[:](?i:birth_place)   {    BEGIN BIRTHPLACE;
                                        yylval.str = strdup(yytext);    
                                        return birthPlace;
                                   }
<DESCRIPTION>[:](?i:viveu_em)      {    BEGIN VIVEUEM;
                                        yylval.str = strdup(yytext);
                                        return viveuem;
                                   }
<DESCRIPTION>[:](?i:img)           {    BEGIN IMG;
                                        yylval.str = strdup(yytext);
                                        return img;
                                   }
<IMG>["]{texto}+["]                {    BEGIN DESCRIPTION;
                                        yylval.str = strndup(yytext+1,strlen(yytext)-1);
                                        return imgDescription;     
                                   }
<DESCRIPTION>^[\n]                 {    BEGIN TRIPLE;  }
<DESCRIPTION>[.]                   {    return ponto;  }
<VIVEUEM>[:]{letra}+               {    
                                        yylval.str = strdup(yytext);
                                        return viveuemDescription;
                                   }
<VIVEUEM>[,]                       {    return virgula;     }
<VIVEUEM>[;]                       {    BEGIN DESCRIPTION;
                                        return pontoVirgula;     
                                   }
<BIRTHPLACE>[:]{letra}+            {    BEGIN DESCRIPTION;
                                        yylval.str = strdup(yytext);
                                        return birthplaceDescription;
                                   }     
<DESCRIPTION>[:]{texto2}+          {    yylval.str = strdup(yytext); 
                                        return tr;
                                   }

<DESCRIPTION>[,]                   {    return virgula;} 
<DESCRIPTION>[;]                   {    return pontoVirgula;}

<NAME>["]{texto}+["]               {    
                                        BEGIN DESCRIPTION;
                                        yylval.str = strndup(yytext+1,strlen(yytext)-1);
                                        return descriptionName;
                                   }        

%%
