#define HASHSIZE 7
#define EMPTY (-1)
#define EMPTYC "-"

typedef struct concept *Hash[HASHSIZE];
typedef struct subject *Subject;

void init(Hash hp);
void displayHash(Hash hp);
Subject initSubject();
void printSubject(Subject s);
void setTitulo(Hash hp, int indice, char * titulo);
void setConceito(Hash hp, int indice, char * conceito);
void displayHash(Hash hp);
void setName(Subject s, char * name);
void setSubject(Subject s, char * subject);
void setDescription(Subject s, char * desc);
void setBirthPlace(Subject  s, char * birthplace);
void setViveuEm(Subject  s, char * viveuEm);
void setIMG(Subject s, char * img);
void setPaiDe(Subject  s, char * paiDe);
void setFilhoDe(Subject s, char * filhoDe);
void setCasouCom(Subject  s, char * casouCom);
void init(Hash hp);
void setSubject_2(Hash hp, Subject s , int indice);

