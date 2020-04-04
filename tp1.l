AlphaNum   (Á|À|Â|Ã|á|à|â|ã|É|Ê|é|ê|Í|í|Ó|Ô|ó|õ|ô|Ú|ú|ç|[a-z]|[A-Z]|[0-9]|.|\ )
%{
#include "hash.h"

char * parentName; // resposta a parentName;
char *idPost;
char *username;
char *name;
char *dateInfo;
char *commentText;
char * commentTemp;
int timestamp;
int likes;
char * likesC;
int hasReplies;     //0: false, 1: true
int n = 0;
Hash * hash;
char * b = "<b>";
char * btemp;




%}  
%x POST POSTID USER BNAME NAME NAMEINFO USERNAME NOTH BDATE DATEINFO DATE TIMESTAMP BCOMMENT COMMENT COMMENTTEXT BLIKES REPLYBLIKES LIKES PARENT PARENTINFO
%%
"\<li class=\"post\""                         {BEGIN POST;}

<POST>{                                          
    "id="    {n++; 
                commentTemp = (char*)malloc(sizeof(char)*1500);
                BEGIN POSTID;}
}

<POSTID>{
    "\"post-"[0-9]*\"           {idPost = strndup(yytext+1,strlen(yytext+1)-1);
                                //printf("IdPost = %s\n",idPost);
    }

    ("class=\"user\"")       { BEGIN USER; }
    .|\n    {;}
}

<USER>{
    "class=\"author\"\>Guest"       { username = strdup("Guest");
                                      name = strdup("Guest");
                                      //printf("Username = %s\n",username);
                                      //printf("Name = %s\n",name);
                                      BEGIN BDATE;  
    }
    "data-username=\""              {  BEGIN USERNAME;}  
    .|\n    {;}  
}

<USERNAME>{
    ([a-zA-z]|[0-9])+\"                   {username = strndup(yytext,strlen(yytext)-1);
                                        //printf("Username = %s\n",username);
                                        BEGIN BNAME;
    }
     .|\n    {;}  
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
                                        //printf("Name = %s\n",name);
                                        BEGIN BDATE;
                                        }
    .|\n    {;}   
}

<BDATE>{
    "title=\"in reply to\"\>\</i\>"[ ]*         {BEGIN PARENTINFO;}
    ("\<a class=\"time-ago\"")                  {BEGIN DATE;}
    .|\n                                        {;}
}

<PARENTINFO>{
    {AlphaNum}+"\</a\>"                     { parentName = strndup(yytext+1,strlen(yytext)-5);
                                            //printf("ParentName =_%s_\n",parentName);
                                            insertReply(*hash,parentName,n-1);
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
                                      //printf("Date = %s\n",dateInfo);
                                      BEGIN TIMESTAMP;
    }
}

<TIMESTAMP>{
    "\>"[0-9]+                      { timestamp = atoi(yytext+1);
                                    //printf("Timestamp = %d\n",timestamp);
                                        BEGIN BCOMMENT;
                                    }
      .|\                           {;}                              
}

<BCOMMENT>{
    ("\<div class=\"post-body-inner\"\>")   {BEGIN COMMENT;}
    .|\n                                    {;}
}

<COMMENT>{
    "\<p\>"*                     {BEGIN COMMENTTEXT;}   
    "\<b\>"*                     {BEGIN COMMENTTEXT;} 
    .|\n                        {;}
}

<COMMENTTEXT>{

    "�&nbsp;"                               {strcat(commentTemp,"à");}

    "\""                                    {strcat(commentTemp,"");}

    "\<b\>"                                 {strcat(commentTemp,"");}

    "\<br\>"                                  {strcat(commentTemp,"");}

    {AlphaNum}                              {strcat(commentTemp,yytext);}
                                        
    "\<"[/]*[a-z]+"\>"                  {   
                                            commentText = strdup(commentTemp);
                                            printf("commentText = %s\n---", commentText);    
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
                                    //printf("Likes = %d\n",likes);
                                    insert(*hash,idPost,username,name,dateInfo,timestamp,commentText,likes);
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

        init(*hash);
        yylex(); 
       
        //printf("\n +++++++++ Hash ++++++++++++\n");
        //displayHash(*hash);
       
        creatingJsonFile(*hash);
       
        //freeHash(*hash);
        return 0; 
}