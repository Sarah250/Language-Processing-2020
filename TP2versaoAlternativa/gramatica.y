%{
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char mem[100];
char buffer[1200];

// evitar warnnings
extern int yylex();
extern char *yytext;
int yyerror();
extern int yylineno;

FILE *fp;
char* paragraph_concat(char *str1, char *str2);
%}

%union{char * str;}

%type <str> CONCEITO TITULO TITULONOTA STR TRIPLONOME NOMERELACAO NOMECOMPLEMENTO IMAGEM
%type <str> Pagina Documento Notas String Text Nota Triplos Triplo Relacoes Complementos Relacao Caderno
%token CONCEITO TITULO TITULONOTA STR TRIPLONOME NOMERELACAO NOMECOMPLEMENTO IMAGEM
%%

Caderno : Caderno Pagina             {  printf("<html>\n<BODY>\n%s\n</BODY>\n</html>\n", $2);}
        | Pagina                     {  fprintf(fp, "<html>\n<BODY>\n%s\n</BODY>\n</html>\n", $1);}
        ;

Pagina : CONCEITO Documento Triplos             { asprintf(&$$, "<H1>%s</H1>\n%s<P><B>---------TRIPLOS---------</B></P>%s", $1, $2, $3);}
       ;

Documento : TITULO Notas                        { asprintf(&$$, "<H2>%s</H2>\n%s\n", $1, $2);}
          ;

Notas : Notas Nota                              { asprintf(&$$, "%s%s", $1, $2);}
      | Nota                                    { $$ = $1;}
      ;

Nota : TITULONOTA Text                          { asprintf(&$$, "<P><B>%s</P></B>\n%s\n", $1, $2);}
     | Text                                     { $$ = $1; }
     ;

Text : String Text                              { $$ = paragraph_concat($1, $2); }
     | String                                   { $$ = $1; }
     ;

String: STR                                     { $$ = malloc(sizeof(char)*(strlen($1)+8)); snprintf($$, strlen($1) + 8, "%s",$1); }
      ;

Triplos: Triplos Triplo                      {  asprintf(&$$, "%s%s", $1, $2);}
       | Triplo                              {  $$ = $1; }
       ;

Triplo : TRIPLONOME Relacoes                { asprintf(&$$, "<P><B>Triplo: %s</P></B>\n<table style=\"width: 100%%\" border=\"1px solid black\">\n\t<tr>\n\t\t<th>Relacao</th>\n\t\t<th>Complemento</th>\n\t</tr>\n%s\n</table>", $1, $2); }
       ;

Relacoes : Relacao Relacoes                 { asprintf(&$$, "%s%s", $1, $2); }
         | Relacao                          { $$ = $1; }
         ;

Relacao : NOMERELACAO Complementos          { asprintf(&$$, "\t<tr>\n\t\t<td>%s</td>\n%s\n\t</tr>\n", $1, $2); }
        ;

Complementos : Complementos NOMECOMPLEMENTO        { asprintf(&$$, "%s\t\t<td>%s</td>\n", $1, $2); }
             | NOMECOMPLEMENTO                      { asprintf(&$$, "\t\t<td>%s</td>\n", $1); }
             | IMAGEM                               { asprintf(&$$, "\t\t<td><img src=%s alt=%s width=\"50\" height=\"50\"></td>", $1, $1); } 
             ;


%%    
#include "lex.yy.c"

int yyerror(char *s){
  fprintf(stderr, "Erro: %s, %s, %d \n", s, yytext, yylineno);

  return 0;
}

int main(){

  fp=fopen("output.html","w");
  yyparse();
  fclose(fp);

  return 0;
}


char* paragraph_concat(char *str1, char *str2){
    int len1 = strlen(str1);
    int len2 = strlen(str2);
    char *str3 = malloc(sizeof(char)*(len1+len2+2));

    snprintf(str3, len1+len2+10, "%s %s", str1, str2);

    return str3;
}
