#include "..\inc\swilib.h"

#define D1601AA 0x31 //dialog
#define TEA5761UK 0x10// radio
#define CAMERA 0xB0

enum {NO_ACTION,LOAD_REG_MAP,SAVE_REG_MAP,INIT_REGISTER,SET_REGISTER };
unsigned char DATA[0x60];


I2C_MSG dialog=
{
  D1601AA,
  4,//unk1
  0,//unk2
  0,//unk3
  0x0,//register
  0,//callback data
  0,
  &DATA,
  1
};
/******************************************************************************/
void SaveRegMap()
{
  unsigned err=0;
  int f=fopen("0:\\LM4946_REG_MAP.bin",A_ReadWrite+A_Create+A_Truncate+A_BIN,P_WRITE+P_READ,&err);
  fwrite(f,&DATA,0x60,&err);
  fclose(f,&err);
}


int callback(void *msg)
{ I2C_MSG *dialog=(I2C_MSG*)msg;

  switch(dialog->cb_data)
  {
   case INIT_REGISTER: 
   case SET_REGISTER:   
   case LOAD_REG_MAP: REDRAW(); break;
   case SAVE_REG_MAP: SUBPROC((void*)SaveRegMap); break;
   
  }
  
  return 1;
}

/******************************************************************************/

void InitRegister()
{ 
  dialog.cb_data=INIT_REGISTER;
  dialog.callback=callback;
  i2c_receive(&dialog);
  dialog.size=1;
}
 
void SetRegister(unsigned char value)
{ 
  DATA[0]=value;
  dialog.cb_data=SET_REGISTER;
  dialog.callback=callback;
  i2c_transfer(&dialog); 
  dialog.size=1;
}

void LoadRegisters()
{  
  dialog.nRegister=0;
  dialog.cb_data=LOAD_REG_MAP;
  dialog.callback=callback;
  dialog.data=&DATA;
  dialog.size=0x60;
  i2c_receive(&dialog);
}
