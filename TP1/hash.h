#define HASHSIZE 43
#define EMPTY (-1)
#define EMPTYC "-"

typedef struct comment *Hash[HASHSIZE];

void init(Hash hp);
void displayHash(Hash hp);
void insert(Hash hp, char * id, char * user, char* nameUser, char * date, int timestamp, char * comments, int likes);
void freeHash(Hash hp);
void insertReply(Hash hp, char* nameUser, int idPost);
void creatingJsonFile(Hash hp);
void freeHash(Hash hp);