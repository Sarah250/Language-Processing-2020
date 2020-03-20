#include<string.h>
#include<stdio.h>
#include<stdlib.h>
#include "hash.h"
#define HASHSIZE 10
#define EMPTY (-1000)
#define EMPTYC "-"

typedef struct comment {
    char * id;
    char * user;
    char * date;
    int timestamp;
    char * comments;
    int likes;
    int hasReplies;
    int numberOfReplies;
    // Replies replies; mesmos dados? 
	struct comment *next;
}Comment, *Hash[HASHSIZE];


void init(Hash hp){
	int i;
	for (i=0;i<HASHSIZE;i++){
		Comment * comment = (Comment *) malloc(sizeof(Comment));
		comment->id = EMPTYC;
		comment->user = EMPTYC;
		comment->date = EMPTYC;
        comment->timestamp = EMPTY;
        comment->comments = EMPTYC;
        comment->likes = EMPTY;
        comment->hasReplies = EMPTY;
        comment->numberOfReplies = EMPTY;
		comment->next = NULL;
		hp[i] = comment;
	}
}


void displayHash(Hash hp){
	int i;

	for (i=0;i<HASHSIZE;i++){
		if (hp[i]!=NULL){;
			printf("hp[%d] - Id comment = %s , User = %s ,Date = %s, timestamp = %d ,comments = %s,likes = %d, hasReplies = %d, numberOfReplies = %d\n",i,hp[i]->id,hp[i]->user,hp[i]->date, hp[i]->timestamp,hp[i]->comments,hp[i]->likes,hp[i]->hasReplies,hp[i]->numberOfReplies);
				Comment * ptr = hp[i]->next;
				while(ptr != NULL) {
					printf("-->hp[%d] - Id comment = %s , User = %s ,Date = %s, timestamp = %d ,comments = %s,likes = %d, hasReplies = %d, numberOfReplies = %d\n",i,ptr->id,ptr->user,ptr->date, ptr->timestamp,ptr->comments,ptr->likes,ptr->hasReplies,ptr->numberOfReplies);
					ptr = ptr->next;
				}	
		}
		else fprintf(stderr, "Pointer é null\n");
	}
} 


int hashCode(char * k){
    int i, sum=0;
    
    for(i=0; i < strlen(k) && k[i]; i++){  sum += k[i]; }
    
    return (sum%HASHSIZE);
}

void insert(Hash hp, char * id, char * user, char * date, int timestamp, char * comments, int likes, int hasReplies, int numberOfReplies){

	int key = hashCode(id);

	if (strcmp(hp[key]->id,EMPTYC) == 0){
		hp[key]->id = id;
		hp[key]->user = user;
		hp[key]->date = date;
		hp[key]->timestamp = timestamp;
		hp[key]->comments = comments;
		hp[key]->likes = likes;
		hp[key]->hasReplies = hasReplies;
		hp[key]->numberOfReplies = numberOfReplies;
	}

	else {
		Comment * aux = (Comment*)malloc(sizeof(Comment));
		aux->id = id;
		aux->user = user;
		aux->date = date;
		aux->timestamp = timestamp;
		aux->comments = comments;
		aux->likes = likes;
		aux->hasReplies = hasReplies;
		aux->numberOfReplies = numberOfReplies;
		aux->next = hp[key]->next;
		hp[key]->next = aux;
	}
}

/* Função que dá o free da tabela Hash */
void freeHash(Hash hp){
	
	int i;
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

/*
// Exemplo de utilização
int main(){

    Hash * hash = (Hash *)malloc(sizeof(Hash));

    init(*hash);
    insert(*hash,"post","tifany","25011994",12355,"no comments",25,1,0);

    displayHash(*hash);
    freeHash(*hash);

    return 0;
}
*/