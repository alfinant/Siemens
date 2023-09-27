#include "../inc/siemens/swilib.h"


typedef struct{ 
  int word[26]; 
}GBSPROC;
 
#pragma swi_number=0x385
__swi __arm GBSPROC *GBS_GetProcAddress(short cepid);



extern void kill_data(void *p, void (*func_p)(void *));
#pragma segment="ELFBEGIN"
void ElfKiller(void)
{
  kill_data(__segment_begin("ELFBEGIN"),(void (*)(void *))mfree_adr());
}


int main(char *exename, char *fname)
{
  
 char s[32];
  
  void *adr =GBS_GetProcAddress(0x40c8);
  sprintf(s, "=0x%X", adr);
  ShowMSG(0x11, (int)s);

  return 0;
}




