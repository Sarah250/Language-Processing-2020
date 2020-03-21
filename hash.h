#define HASHSIZE 10

typedef struct comment *Hash[HASHSIZE];

void init(Hash hp);
void displayHash(Hash hp);
void insert(Hash hp, char * id, char * user, char * date, int timestamp, char * comments, int likes, int hasReplies, int numberOfReplies);
void freeHash(Hash hp);