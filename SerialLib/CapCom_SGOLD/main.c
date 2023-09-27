#include <swilib.h>

extern void kill_data( void * p, void( * func_p ) ( void * ) );
#pragma segment="ELFBEGIN"
void ElfKiller(void)
{
  kill_data(__segment_begin("ELFBEGIN"),(void (*)(void *))mfree_adr());
}

//SetIllumination(unsigned char dev,unsigned long param1,unsigned short bright,unsigned long delay);
//0 - дисплей, 1 - клавиатура, 2 - динамический свет (x65)

#define pwm_EnablePort        ((int(*)(int channel))0xA11697E8)
#define pwm_DisablePort       ((int(*)(int channel))0xA1169B3C)
#define pwm_SetFreq           ((int(*)(int channel,int frequency))0xA116A478)
#define pwm_SetDutycycle      ((int(*)(int channel,int dutycycle))0xA116A920)
#define pwm_unk9              ((int(*)(int channel))0xA116A2B4)

#define PIN_Set               ((int(*)(int p1,int pin, int p3))0xA1169360)
#define Disable_INT           ((int(*)(void))0xA0837F80)
#define Enable_INT            ((void(*)(unsigned cpsr))0xA0837FA0)

int main(char *exename, char *fname) {
  //pwm_unk9, 12(off),14(off)
  //N93: F43000B0 - dynlight pin
  //N9F: F4300098 - ringin pin
  
  pwm_EnablePort(8);
  pwm_unk9(8);
  pwm_SetFreq(8,1);
  pwm_EnablePort(9);
  pwm_SetDutycycle(9,50);
  //SetIllumination( 2, 1, 0x64, 0x6E8);
  ShowMSG(1,(int)"Дин.свет включен!");
  
  SUBPROC((void *)ElfKiller);
  return 0;
}



