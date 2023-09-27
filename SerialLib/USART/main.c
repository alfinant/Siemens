#include "..\..\inc\swilib.h"
#include "..\..\inc\usart.h"

extern void kill_data(void *p, void (*func_p)(void *));

#pragma segment="ELFBEGIN"
void ElfKiller(void)
{
  kill_data(__segment_begin("ELFBEGIN"),(void (*)(void *))mfree_adr());
}

void tx_str(char *str)
{
  int len = strlen(str);
  for (int i=0; i<len; i++)
    S0Tx_byte(str[i]);
}


void main(char *exename, char *fname)
{ 
  S0_setbaudrate(USART_57600_DATA);
  tx_str("HELLO SIEMENS E71!\n");
  SUBPROC((void *)ElfKiller);
}

