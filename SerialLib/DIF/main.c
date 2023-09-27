#include <swilib.h>
#include "ssc.h"

extern void kill_data(void *p, void (*func_p)(void *));
#pragma segment="ELFBEGIN"

void ElfKiller(void)
{
  kill_data(__segment_begin("ELFBEGIN"),(void (*)(void *))mfree_adr());
}


extern int BFC_L2_SwitchOffDisplay(void * unk1,void *dnum,int _2);
extern int BFC_L2_RestoreDisplay(void * unk1,void *dnum,int _2);
extern int BFC_L2_ForceDisplayUpdate(void * unk1,void *dnum,int _3);

extern int get_access();
extern void LCD_SwitchOff(void);
extern void init(void); 
extern void set_access(int);

int main(char *exename, char *fname)
{
 //char data;
 //int  data1,data2=0;
// char *value="               ";
   //GetPlayStatus();
  // data1=get_access();
   
   GetPlayStatus();

  
  char unk1[]={1,0,0x10,0};
  char dnum[]={1,0,0x10,0};
  
  BFC_L2_SwitchOffDisplay(&unk1,&dnum,2);
  //BFC_L2_RestoreDisplay(&unk1,&dnum,2);
  
  //init();
 // LCD_SwitchOff();
    
   //data2=get_access();
 
   //GetPlayStatus();
   //i2c_read(0x31,0x07,&data);
     
  // sprintf(value,"%X",data);
   // ShowMSG(1,(int)value); 


   SUBPROC((void *)ElfKiller);
   return 0;
}

/*
BFC_L2_GetDisplayType
BFC_L2_RedirectDisplay - дисплей перестает обновляться
BFC_L2_RestoreDisplay - восстановливает обновление
BFC_L2_ForceDisplayUpdate
BFC_L2_SwitchOffDisplay

BFC_L2_GetDisplayCount
BFC_L2_GetDisplayInformation
BFC_L2_GetDisplayBufferInfo
BFC_L2_GenerateDisplayPattern


BFC_L2_GetDisplayData
BFC_L2_DisplayUpdateNotification
BFC_L2_SetDisplayContrast

BFC_L2_SetPartialDisplayMode
*/
