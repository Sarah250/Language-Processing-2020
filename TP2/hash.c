#include<string.h>
#include<stdio.h>
#include<stdlib.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "hash.h"



typedef struct subject{
    char * sujeito;
    char * name;
    char ** description;
    char * birthplace;
    char * viveuem;
    char * img;
    char * paiDe;
    char * filhoDe;
    char * casouCom;
    struct subject * next;
};

typedef struct concept {
    char * conceito;
    char * titulo;
    char * notasIniciais;
    Subject * subject;
} Concept;

Subject initSubject(){

    Subject s = (Subject ) malloc(sizeof(struct subject));
    s->sujeito = EMPTYC;
    s->name = EMPTYC;
    s->birthplace = EMPTYC;
    s->viveuem = EMPTYC;
    s->img = EMPTYC;
    s->paiDe = EMPTYC;
    s->filhoDe = EMPTYC;
    s->casouCom = EMPTYC;
    s->description = (char **)malloc(sizeof(char*)*10);
    for(int i = 0; i<10;i++){
        s->description[i] = EMPTYC;
    }
    s->next = NULL;
    return s;
}



void printSubject(Subject s){
    
    while(s !=NULL){
        printf("Sujeito = %s, Nome = %s, \n", s->sujeito, s->name);
        printf("Birthplace = %s, ViveuEm  = %s, IMG = %s\n", s->birthplace, s->viveuem, s->img);
        printf("PaiDe = %s, FilhoDe = %s, CasouCom = %s\n", s->paiDe, s->filhoDe, s->casouCom);
        int i= 0;
        while(s->description[i]!= EMPTYC){
            printf("Description = %s ", s->description[i]);
            i++;
        }
        
        printf("\n");
        if (s->next == NULL) printf("É NULL\n");
        s = s->next;
    }

}


void insertSubject(Subject  * s, Subject * s1){
    
    while(*s!=NULL) s = &(*s)->next;
    (*s) = (*s1);
    
}

void setTitulo(Hash hp, int indice, char * titulo){
    hp[indice]->titulo = titulo;
}

void setConceito(Hash hp, int indice, char * conceito){
    hp[indice]->conceito = conceito;
}

void displayHash(Hash hp){
	int i;

	for (i=0;i<HASHSIZE;i++){
		if (hp[i]!=NULL){;
            printf("hp[%d] : Conceito = %s, Titulo = %s\n",i, hp[i]->conceito, hp[i]->titulo );
    	
            printSubject(*hp[i]->subject);

        }else fprintf(stderr, "Pointer é null\n");
	}
} 

void setName(Subject s, char * name){ s->name = name; }

void setSubject(Subject s, char * subject){ s->sujeito = subject; }

void setDescription(Subject s, char * desc){
    int i = 0;
    while(s->description[i]!=EMPTYC){
        i++;
    }
    s->description[i] = desc;
}

void setBirthPlace(Subject  s, char * birthplace){
    s->birthplace = birthplace;
}

void setViveuEm(Subject  s, char * viveuEm){
    s->viveuem = viveuEm;
}

void setIMG(Subject s, char * img){
    s->img = img;
}

void setPaiDe(Subject  s, char * paiDe){
    s->paiDe = strdup(paiDe);
}

void setFilhoDe(Subject s, char * filhoDe){
    s->filhoDe = filhoDe;
}

void setCasouCom(Subject  s, char * casouCom){
    s->casouCom = casouCom;
}

void init(Hash hp){
	
    int i;

	
    for (i=0;i<HASHSIZE;i++){
		Concept * comm = (Concept *) malloc(sizeof(Concept));
		comm->conceito = EMPTYC;
		comm->titulo = EMPTYC;
        comm->notasIniciais = EMPTYC;
        comm->subject = (Subject*)malloc(sizeof(Subject));
		hp[i] = comm;
	}
}

void setSubject_2(Hash hp, Subject s , int indice){
    int i = 0;

    insertSubject(hp[indice]->subject,&s);

}


void freeHash(Hash hp){
	
	unsigned int i;

	Concept * prev;
	for (i=0;i<HASHSIZE;i++){
		prev = hp[i];
		free(prev);
	}
}

