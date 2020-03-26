AlphaNum   (Á|À|Â|Ã|á|à|â|ã|É|Ê|é|ê|Í|í|Ó|Ô|ó|õ|ô|Ú|ú|ç|[a-z]|[A-Z]|[0-9]|.|\ )
%{
#include "hash.h"
#include <string.h>
char *idPost;
char *username;
char *dateInfo;
char * commentText;
int timestamp;
int likes;
char * likesC;
int hasReplies;     //0: false, 1: true
int n = 0;
Hash * hash;
%}

%x POST POSTID USER USERNAME NOTH BDATE DATEINFO DATE TIMESTAMP BCOMMENT COMMENT COMMENTTEXT BLIKES LIKES

%%
"\<li class=\"post\""                         {BEGIN POST;}

<POST>{                                          
    "id="    {n++; BEGIN POSTID;}
}

<POSTID>{
    "\"post-"[0-9]*\"           {idPost = strndup(yytext+1,strlen(yytext+1)-1);
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
    [a-zA-z]+[0-9]*\"                   {username = strndup(yytext,strlen(yytext)-1);
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
                                      BEGIN TIMESTAMP;
    }
}

<TIMESTAMP>{
    "\>"[0-9]+                      { timestamp = atoi(yytext+1);
                                    printf("%d\n",timestamp);
                                        BEGIN BCOMMENT;
                                    }
      .|\                           {;}                              
}

<BCOMMENT>{
    ("\<div class=\"post-body-inner\"\>")   {BEGIN COMMENT;}
    .|\n                                    {;}
}

<COMMENT>{
    "\<p\>"                     {BEGIN COMMENTTEXT;}   
    "\<b\>"                     {BEGIN COMMENTTEXT;} 
    .|\n                        {;}
}

<COMMENTTEXT>{
    {AlphaNum}+"\<"[/]*[a-z]+"\>"         { commentText = strndup(yytext,strlen(yytext)-4);
                                printf("%s\n", commentText);
                                BEGIN BLIKES;
                                }
}

<BLIKES>{
    ("\<span class=\"updatable count\" data-role=\"likes\">")    {BEGIN LIKES;}
    .|\n    {;}
}

<LIKES>{
    [0-9]+"\<"                      { likesC = strndup(yytext,strlen(yytext)-1);
                                    likes = atoi(likesC);
                                    printf("%d\n",likes);
                                    BEGIN INITIAL;
                                    insert(*hash,idPost,username,dateInfo,timestamp, commentText,likes,1,0);
    }
}

<NOTH>{
    .|\n    {;}
}

.|\n    {;}


%%
int yywrap(){ return(1); }

int main(){ 
       hash = (Hash *)malloc(sizeof(Hash));

       init(*hash);
       // displayHash(*hash);
        
        yylex(); 
        printf("Number of posts = %d\n",n);
        //displayHash(*hash);
        freeHash(*hash);
        return 0; 
}