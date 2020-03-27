AlphaNum   (Á|À|Â|Ã|á|à|â|ã|É|Ê|é|ê|Í|í|Ó|Ô|ó|õ|ô|Ú|ú|ç|[a-z]|[A-Z]|[0-9]|.|\ )
%{
#include "hash.h"
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
char * parentName; // resposta a parentName;
char *idPost;
char *username;
char *name;
char *dateInfo;
char *commentText;
int timestamp;
int likes;
char * likesC;
int hasReplies;     //0: false, 1: true
int n = 0;
Hash * hash;
%}  
%x POST POSTID USER BNAME NAME NAMEINFO USERNAME NOTH BDATE DATEINFO DATE TIMESTAMP BCOMMENT COMMENT COMMENTTEXT BLIKES REPLYBLIKES LIKES PARENT PARENTINFO
%%
"\<li class=\"post\""                         {BEGIN POST;}

<POST>{                                          
    "id="    {n++; BEGIN POSTID;}
}

<POSTID>{
    "\"post-"[0-9]*\"           {idPost = strndup(yytext+1,strlen(yytext+1)-1);
                                printf("%s\n",idPost);
    }

    ("class=\"user\"")       { BEGIN USER; }
    .|\n    {;}
}

<USER>{
    "class=\"author\"\>Guest"       { username = strdup(EMPTYC);
                                      name = strdup(EMPTYC);
                                      BEGIN BDATE;  
    }
    "data-username=\""              {  BEGIN USERNAME;}  
    .|\n    {;}  
}

<USERNAME>{
    [a-zA-z]+[0-9]*\"                   {username = strndup(yytext,strlen(yytext)-1);
                                    printf("%s\n",username);
                                    BEGIN BNAME;
    }
}

<BNAME>{
    ("data-username=")             {BEGIN NAME;}
     .|\n    {;} 
}

<NAME>{
    "target=\"_blank\"\>"            {BEGIN NAMEINFO;}
    .|\n    {;}
}

<NAMEINFO>{
    {AlphaNum}+"\</a\>"              { name = strndup(yytext,strlen(yytext)-4);
                                        printf("Name = %s\n",name);
                                        BEGIN BDATE;
                                        }
    .|\n    {;}   
}

<BDATE>{
    "title=\"in reply to\"\>\</i\>"[ ]+         {BEGIN PARENTINFO;}
    ("\<a class=\"time-ago\"")                  {BEGIN DATE;}
    .|\n                                        {;}
}

<PARENTINFO>{
    {AlphaNum}+"\</a\>"                     { parentName = strndup(yytext,strlen(yytext)-4);
                                            printf("ParentName = %s\n",parentName);
                                            BEGIN BDATE;
    }
    .|\n                                    {;}
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

       //init(*hash);
       // displayHash(*hash);
        
        yylex(); 
        printf("Number of posts = %d\n",n);
        //displayHash(*hash);
        //freeHash(*hash);
        return 0; 
}