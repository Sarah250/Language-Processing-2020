#include<string.h>
#include<stdio.h>
#include<stdlib.h>
#include "hash.h"


typedef struct comment {
    char * id;
    char * user;
	char * nameUser;
    char * date;
    int timestamp;
    char * comments;
    int likes;
    int hasReplies;
    int numberOfReplies;
	char ** idReplies;
} Comment;

int idHash;


void init(Hash hp){
	
    int i;
	idHash = 0;
	
    for (i=0;i<HASHSIZE;i++){
		Comment * comm = (Comment *) malloc(sizeof(Comment));
		comm->id = EMPTYC;
		comm->user = EMPTYC;
		comm->nameUser = EMPTYC;
		comm->date = EMPTYC;
        comm->timestamp = EMPTY;
        comm->comments = EMPTYC;
        comm->likes = EMPTY;
        comm->hasReplies = 0;
        comm->numberOfReplies = 0;
		comm->idReplies = (char**)malloc(sizeof(char*)*10);
		hp[i] = comm;
	}
}

void displayHash(Hash hp){
	unsigned i;

	for (i=0;i<HASHSIZE;i++){
		if (hp[i]!=NULL){;
			printf("hp[%d] - Id comment = %s , User = %s , Name = %s ,Date = %s, timestamp = %d ,comments = %s,likes = %d, hasReplies = %d, numberOfReplies = %d\n",i,hp[i]->id,hp[i]->user, hp[i]->nameUser,hp[i]->date, hp[i]->timestamp,hp[i]->comments,hp[i]->likes,hp[i]->hasReplies,hp[i]->numberOfReplies);
				int j = 0;
				while(hp[i]->idReplies[j]!=NULL) printf("--IdReply = %s\n",hp[i]->idReplies[j++]);
		}
		else fprintf(stderr, "Pointer é null\n");
	}
} 

int hashCode(char * k){
    unsigned i, sum=0;
    
    for(i=0; i < strlen(k) && k[i]; i++){  sum += k[i]; }
    
    return (sum%HASHSIZE);
}

void insert(Hash hp, char * id, char * user, char* nameUser, char * date, int timestamp, char * comments, int likes){

	int key = idHash++;

	if (strcmp(hp[key]->id,EMPTYC) == 0){
		hp[key]->id = id;
		hp[key]->user = user;
		hp[key]->nameUser = nameUser;
		hp[key]->date = date;
		hp[key]->timestamp = timestamp;
		hp[key]->comments = comments;
		hp[key]->likes = likes;
	}
}

void insertReply(Hash hp, char* nameUser, char * idPost){
	int i = idHash-2;
	int flag = 0;

	while(i>=0 && !flag){
		if (strstr(nameUser,hp[i]->nameUser)!= NULL){
			int j = 0;
			while(hp[i]->idReplies[j]!=NULL) j++;
			hp[i]->idReplies[j] = idPost;
			hp[i]->hasReplies = 1;
			hp[i]->numberOfReplies++;
			flag = 1;
		}
		else i--;
	}
}

/* 
void freeHash(Hash hp){
	
	unsigned int i;
	Comment * atual;
	Comment * prev;
	for (i=0;i<HASHSIZE;i++){
		atual = hp[i]->next;
		prev = hp[i];
		while (atual != NULL){
			free(prev);
			prev = atual; 
			atual = atual->next;
		}
		free(prev);
	}
}
*/
