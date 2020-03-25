AlphaNum   (Á|À|Â|Ã|á|à|â|ã|É|Ê|é|ê|Í|í|Ó|Ô|ó|õ|ô|Ú|ú|ç|[a-z]|[A-Z]|[0-9]|.|\ )
%{
#include "hash.h"
#include <string.h>
char *idPost;
char *username;
char *dateInfo;
%}

%x POST POSTID USER USERNAME NOTH BDATE DATEINFO DATE

%%
("\<li class=\"post\"")                         {BEGIN POST;}
<POST>{                                          
    "id="    {BEGIN POSTID;}
    .|\n    {;}
}
<POSTID>{
    "\"post-"[0-9]*\"           {idPost = strndup(yytext+1,strlen(yytext+1)-2);
                                printf("%s\n",idPost);
    }
    ("\<a class=\"user\"")       { BEGIN USER; }
    .|\n    {;}
}
<USER>{
    "data-username=\""          {BEGIN USERNAME;}  
    .|\n    {;}  
}
<USERNAME>{
    [A-Za-z]+\"                   {username = strndup(yytext,strlen(yytext)-1);
                                    printf("%s\n",username);
                                    BEGIN BDATE;
    }
    
}
<BDATE>{
    ("\<a class=\"time-ago\"")    {BEGIN DATE;}
    .|\n                          {;}
}
<DATE>{
    "title=\""                     {BEGIN DATEINFO;}
    .|\n                            {;}
}
<DATEINFO>{
    {AlphaNum}+\"                   { dateInfo = strndup(yytext,strlen(yytext)-1);
                                      printf("%s\n",dateInfo);
                                      BEGIN NOTH;
    }
}


<NOTH>{
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