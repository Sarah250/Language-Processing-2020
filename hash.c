#include<string.h>
#include<stdio.h>
#include<stdlib.h>
#include <sys/stat.h>
#include <fcntl.h>
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
	int *replies;
	int isPrincipal;
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
		comm->isPrincipal = 1;
		comm->replies = (int *)malloc(sizeof(int)*10);
		int j ;
		for(j= 0; j<10;j++) comm->replies[j]=EMPTY;
		hp[i] = comm;
	}
}

void displayHash(Hash hp){
	unsigned i;

	for (i=0;i<HASHSIZE;i++){
		if (hp[i]!=NULL){;
			printf("hp[%d] - Id comment = %s , User = %s , Name =%s,Date = %s, timestamp = %d ,comments = %s,likes = %d, hasReplies = %d, numberOfReplies = %d\n",i,hp[i]->id,hp[i]->user, hp[i]->nameUser,hp[i]->date, hp[i]->timestamp,hp[i]->comments,hp[i]->likes,hp[i]->hasReplies,hp[i]->numberOfReplies);
				int j = 0;
				//while(hp[i]->idReplies[j]!=NULL) printf("--IdReply = %s\n",hp[i]->idReplies[j++]);
				while(hp[i]->replies[j]!=EMPTY) printf("--IdReply = %d\n",hp[i]->replies[j++]);
		}
		else fprintf(stderr, "Pointer é null\n");
	}
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

void insertReply(Hash hp, char* nameUser, int idPost){
	int i = idHash-1;
	int flag = 0;
	
	hp[idPost]->isPrincipal = 0;
	
	while(i>=0 && !flag){
		if (strcmp(nameUser,hp[i]->nameUser)== 0){
			int j = 0;
			while(hp[i]->replies[j]!=EMPTY) j++;
			hp[i]->replies[j] = idPost;
			hp[i]->hasReplies = 1;
			hp[i]->numberOfReplies++;
			flag = 1;
		}
		else i--;
	}
}

void creatingReplies(Hash hp, int i, FILE *f, char * tab){
	
	fprintf(f,"%s{\"id\" : \"%s\",\n",tab, hp[i]->id);
	fprintf(f,"%s\"user\": \"%s\",\n",tab, hp[i]->user);
	fprintf(f,"%s\"date\": \"%s\",\n",tab, hp[i]->date);
	fprintf(f,"%s\"timestamp\": %d,\n",tab, hp[i]->timestamp);
	fprintf(f,"%s\"commentText\": \"%s\",\n",tab, hp[i]->comments);
	fprintf(f,"%s\"likes\": %d,\n",tab, hp[i]->likes);
	fprintf(f,"%s\"numberOfReplies\": %d,\n",tab,hp[i]->numberOfReplies);
	if (hp[i]->hasReplies){
		fprintf(f,"%s\"hasReplies\": true,\n",tab);
		char * tab2 = (char*)malloc(sizeof(char)*(strlen(tab)*2));
		strcat(tab2,tab);
		strcat(tab2,"\t");
		fprintf(f,"%s\"replies\":[\n",tab);
		int j = 0;
		while(hp[i]->replies[j]!= EMPTY) {
			creatingReplies(hp, hp[i]->replies[j++],f,tab2);
			if (hp[i]->replies[j] != EMPTY) fprintf(f,",\n");
		}
		fprintf(f,"\n%s]\n",tab);
	}
	else{
		fprintf(f,"%s\"hasReplies\": false,\n",tab);
		fprintf(f,"%s\"replies\": null\n",tab);
	}
	fprintf(f,"%s}",tab);
}

void creatingJsonFile(Hash hp){
	FILE * f = fopen("tp1_ex5_g19.json","w");
	int i;

	fprintf(f,"{\"commentThread\": [\n");

	for(i=0; i < HASHSIZE; i++){
		
		if (hp[i]->isPrincipal){
			fprintf(f,"{\n");
			fprintf(f,"\"id\" : \"%s\",\n", hp[i]->id);
			fprintf(f,"\"user\": \"%s\",\n", hp[i]->user);
			fprintf(f,"\"date\": \"%s\",\n", hp[i]->date);
			fprintf(f,"\"timestamp\": %d,\n", hp[i]->timestamp);
			fprintf(f,"\"commentText\": \"%s\",\n", hp[i]->comments);
			fprintf(f,"\"likes\": %d,\n", hp[i]->likes);
		
			if (hp[i]->hasReplies != 0){
				int j = 0;
				fprintf(f, "\"hasReplies\": true,\n");
				fprintf(f,"\"numberOfReplies\": %d,\n",hp[i]->numberOfReplies);
				fprintf(f,"\"replies\":[\n");
				while(hp[i]->replies[j]!= EMPTY) {
					creatingReplies(hp, hp[i]->replies[j++],f,"\t");
					if (hp[i]->replies[j] != EMPTY) fprintf(f,",\n");
				}
				fprintf(f,"\n]\n");
			} 
			else {
				fprintf(f, "\"hasReplies\": false,\n");
				fprintf(f,"\"numberOfReplies\": %d,\n",hp[i]->numberOfReplies);
				fprintf(f,"\"replies\": null\n");
			}
			fprintf(f,"}");
			if ( i != 37 ) fprintf(f,",\n");
		}
		
	}
	fprintf(f,"\n]}");
}

void freeHash(Hash hp){
	
	unsigned int i;

	Comment * prev;
	for (i=0;i<HASHSIZE;i++){
		prev = hp[i];
		free(prev);
	}
}

