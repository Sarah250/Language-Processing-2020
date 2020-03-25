option noyywrap
%{
#include "hash.h"
#include <string.h>
char *idPost;
%}

%x POST POSTID

%%
("\<li class=\"post\"")                         {BEGIN POST;}
<POST>{                                          
    "id="    {BEGIN POSTID;}
    .|\n    {;}
}
<POSTID>{
    "\"post-"[0-9]*\"    {idPost = strndup(yytext+1,strlen(yytext+1)-2);
                            printf("%s\n",idPost);
    }
    .|\n    {;}
}

.|\n    {;}


%%
int yywrap(){ return(1); }

int main(){ 
       // Hash * hash = (Hash *)malloc(sizeof(Hash));

       // init(*hash);
       // displayHash(*hash);
        
        yylex(); 
        return 0; 
}