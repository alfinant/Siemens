#include "defs.h"

void __OpenSSLDie(const char *function,int line)
{
  char s[256];
  
  snprintf(s, 255, "Function:%s,Line:%d\n", function, line);
  StoreErrString(s);

#ifdef NEWSGOLD
  asm("SWI 4"); //Переключаемся в системный режим
#else
  asm("SWI 0");
#endif
    StoreErrInfoAndAbort(0xFFFF,"\1\1OpenSSL internal error",2,2);
}
