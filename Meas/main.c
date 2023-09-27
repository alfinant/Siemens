#include "../inc/swilib.h"
#include "meas.h"

//#define CX75v25
//#define CX72v22

extern int adata;
int VREF=1960;//Измеренное опорное напряжение 
int VMAX=15220; 
int AOffset=-2; //коррекция на нуль
int voltage=0;


extern void kill_data(void *p, void (*func_p)(void *));
void ElfKiller(void)
{ 
  extern void *ELF_BEGIN;
  kill_data(&ELF_BEGIN,(void (*)(void *))mfree_adr());
}

void ShowRes()
{
  char s[128];
  
  sprintf(s, "Analog Data: 0x%X\n"
             "Voltage: %dmV"
               ,adata, voltage);
  ShowMSG(1, (int)s );   
}

void meas_callback()
{
  int v0 = divide(2047, VREF * (adata-2048));//напряжение на входе M2
  int mux = divide(VREF, VMAX * 1000);//множитель для резисторного делителя
  voltage = divide(1000, v0 * mux);
  
  if (voltage < 0)
    voltage=0;
  
  SUBPROC((void*)ShowRes);
  //выходим
  MEAS_Delete();
  SUBPROC((void *)ElfKiller);
}

int main(void)
{ 
  if (MEAS_Init(meas_callback))
  {
    MEAS_Start();
  }
  else
  {
    ShowMSG(1,(int)"HISR not created:(" );
    SUBPROC((void *)ElfKiller);
  }
  return 0;
}

