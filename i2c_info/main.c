#include "..\inc\swilib.h"
#include "..\inc\i2c.h"

#ifdef NEWSGOLD
#include "..\inc\reg8876.h"
#else
#include "..\inc\reg8875.h"
#endif

extern void kill_data(void *p, void (*func_p)(void *));
#pragma segment="ELFBEGIN"
void ElfKiller(void)
{
  kill_data(__segment_begin("ELFBEGIN"),(void (*)(void *))mfree_adr());
}

unsigned data[0x6];

void SaveRegMap()
{ unsigned  err=0;

  int f=fopen("0:\\SCCU.bin",A_ReadWrite+A_Create+A_Truncate+A_BIN,P_WRITE+P_READ,&err);
  fwrite(f,data,0x18,&err);
  fclose(f,&err);
}


char dat=0;
char r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19;


void showMess()
{
  char s[127];
  sprintf(s, "r1=%X\n"
             "r2=%X\n"
             "r10=%X\n"
             "pmCrhg=%X\n", r1, r2, r10, GPIO.TOUT1);
  
  ShowMSG(0x1, (int)s);
  SUBPROC((void *)ElfKiller);
}

void callback(void *i2c_msg, int err)
{
  I2C_MSG *msg=(I2C_MSG*) i2c_msg;
  
  if(msg->cdata==0)i2cr_pmu(2, &r2, callback, 1);
  if(msg->cdata==1)i2cr_pmu(0x10, &r10, callback, 0xf);  
  
  if(msg->cdata==0xf) SUBPROC((void*)showMess);
}


int main(char *exename, char *fname)
{

  i2cr_pmu(1, &r1, callback, 0);
  
  return 0;
}




