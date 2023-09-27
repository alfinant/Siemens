#include <siemens\swilib.h>

enum {CAPTCHA};

void LoadSmiles();
void LoadImages();
void FreeDynSmiles();
void PNGLIST_Free();
void FreeDynImages();
void EnableDynImages();
void DisableDynImages();
IMGHDR* PNGLIST_GetImgByIndex(int index);
HObj CreateIMGHDRFromMemoryAsync(int uid, char *buf, int len, int msg);
HObj CreateIMGHDRFromFileAsync(char *fname, int msg, short w, short h);

void CreateDynImage(short w, short h, int uid, int index, char* buf, int len);



