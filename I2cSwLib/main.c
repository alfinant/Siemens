#include "..\inc\swilib.h"
#include "I2cSwLib.h"

#define ARDUINO_ADDR 0x40 

extern void kill_data(void *p, void (*func_p)(void *));
#pragma segment="ELFBEGIN"
void ElfKiller(void)
{
  kill_data(__segment_begin("ELFBEGIN"),(void (*)(void *))mfree_adr());
}

GBSTMR tmr;
int count=0;

void tmr_proc()
{
  char text[32];
  
  sprintf(text, "i2c write test 0x%X", count++);
  I2cSwWrite(0x40, -1, text, strlen(text));
  GBS_StartTimerProc(&tmr, 108, tmr_proc);
}

int main(char *exename, char *fname)
{
  char data[32];
  
  zeromem(data, 32);
  
  if(I2cSwInit())
    ShowMSG(1,(int)"I2c driver not loaded!");
  else
  {
    if(I2cSwRead(ARDUINO_ADDR, -1, data, 19))
      ShowMSG(1,(int)"I2c send message error");
    else
      ShowMSG(1,(int)data);
  }
     
  SUBPROC((void*)ElfKiller);
  return 0;
}
