#include "..\inc\swilib.h"

extern void kill_data(void *p, void (*func_p)(void *));
#pragma segment="ELFBEGIN"
void ElfKiller(void)
{
  kill_data(__segment_begin("ELFBEGIN"),(void (*)(void *))mfree_adr());
}

extern unsigned int initalize();

int main(char *exename, char *fname)
{
  int status = initalize();
  
  if(status==1)
    SUBPROC((void*)ElfKiller);
  
  return 0;  
}

