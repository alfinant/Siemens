#include "..\inc\swilib.h"
//#include "..\inc\connector.h"
//#include "..\inc\i2c.h"

#ifdef NEWSGOLD
#include "..\inc\reg8876.h"
#else
#include "..\inc\reg8875.h"
#endif


//PhyWAS_ExtPower

typedef struct
{
  int zero0;
  int zero1;
  int one;
  short pid;
  short pid_from;
  short msg;
  short submess;
}SA_MSG;

//#define C81

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


void USB_Charging_NSG()
{ //STA: MAIN-заряжается, DONE, STBY-зарядка не требуется, WAIT-требуется зарядка
  //CTY: NONE, USB, STD
 
  GBS_SendMessage(0x40B8,0x6,0,0,0);      //from PhyWAS_ExtPower_Process to 40B8_AKKU_ANZEIGE
  GBS_SendMessage(0x40B8,0x1,0,0,0);      //from PhyWAS_ExtPower_Process to 40B8_AKKU_ANZEIGE
  GBS_SendMessage(0x407E,0x1400,0,0,0);   //from PhyWAS_ExtPower_Process  to 407E_AKKU_MESS
  GBS_SendMessage(0x3F00,0xA,0,0,0);      //from WAS_HISR_Detection to PhyWAS_ExtPower_Process 
  GBS_SendMessage(0x3F00,0xB,0,0,0);      //from WAS_HISR_Detection to PhyWAS_ExtPower_Process
  GBS_SendMessage(0x3F00,0xC,0,0,0);      //from WAS_HISR_Detection to PhyWAS_ExtPower_Process 
  //GBS_SendMessage(0x6B03,0x1A71,0,0,0); //from WAS_Manager_Process to WAS_ChargerController

  ShowMSG(0x11, (int)"PwrState: MAIN");
}

void USB_Charging()
{ //STA: MAIN-заряжается, DONE, STBY-зарядка не требуется, WAIT-требуется зарядка
  //CTY: NONE, USB, STD
  
  GBS_SendMessage(0x3F00,0x8,0,0,0);  //источник usb
  GBS_SendMessage(0x3F00,0xB,0,0,0);  //from WAS_HISR_Detection to PhyWAS_ExtPower_Process
  GBS_SendMessage(0x3F00,0xA,0,0,0);  //from WAS_HISR_Detection to PhyWAS_ExtPower_Process
  GBS_SendMessage(0x6B03,0x15,0,0,0); //from WAS_Manager to WAS_ChargerController
  GBS_SendMessage(0x6B03,0x10,0,0,0); //from WAS_Manager to WAS_ChargerController
  ShowMSG(0x11, (int)"PwrState: MAIN");
/*  
  Для NSG:сетевая зарядка:
  1. При втыкании штекера выполняется прерывание (интерфейс SCU) Pasic_LISR
  2. Из прерывания вызывается Pasic_HISR
  3. Pasic_HISR читает по i2c значения 1го и 2го регистра PMU
  4. В callback`е i2c функции отправляется сообщение msg=7 3F00_PhyWAS_ExtPower_Process`у
  5. 3F00_PhyWAS_ExtPower_Process передает msg=0x1A77 6B03_WAS_ChargerController
  6. 6B03_WAS_ChargerController передает msg=0x1A19 4500_WAS_Manager_Process
  7. 4500_WAS_Manager_Process передает msg=6 40B8_AKKU_ANZEIGE, msg=1 40B8_AKKU_ANZEIGE, msg=0x1400 407E_AKKU_MESS
  
  3. В 3F00_PhyWAS_ExtPower_Process активируется WAS_HISR_Detection,тот передает сообщение msg=0x1A42 WAS_DetectionController
   . 6B00_WAS_DetectionController передает сообщение(0x1A1A) 4500_WAS_Manager_Process

  1. В callback`е i2c функции отправляется сообщение msg=8 3F00_PhyWAS_ExtPower_Process`у +
  2. 3F00_PhyWAS_ExtPower_Process передает msg=0x1A77 6B03_WAS_ChargerController
  3. 6B03_WAS_ChargerController передает msg=0x1A19 4500_WAS_Manager_Process

  0xF44000CC-регистр прерывания при включении и выключении зарядки
  в регистр 0x10 пишется знач==0x90
  в регистр 3 пишется знач==8
  читается значение в регистре 0х10
  в регистр 0x10 пишется знач==0x90
  
*/
}

int main(char *exename, char *fname)
{
  /*char s[32];
  void *adr =GBS_GetProcAddress(0x408b);
  sprintf(s, "=0x%X", adr);
  ShowMSG(0x11, (int)s);
 */ 
  USB_Charging_NSG();
 
    
  //GBS_SendMessage(0x3F00,0x6,0,0,0); // CTY=NONE
 
/*GBS_SendMessage(0x3F00,0x6,0,0,0);
  GBS_SendMessage(0x6B03,0xF,0,0,0);  // CTY=NONE
  GBS_SendMessage(0x3F00,0xB,0,0,0);  
  GBS_SendMessage(0x3F00,0xA,0,0,0);
  GBS_SendMessage(0x6B03,0x15,0,0,0);    
  //0xA,4
*/

}




