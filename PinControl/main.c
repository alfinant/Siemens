#include <siemens/swilib.h>
#include <siemens/connector.h>


#pragma swi_number=0x385
__swi __arm void *GetGBSProcAddress(short cepid);


extern void kill_data(void *p, void (*func_p)(void *));
#pragma segment="ELFBEGIN"
void ElfKiller(void)
{
  kill_data(__segment_begin("ELFBEGIN"),(void (*)(void *))mfree_adr());
}

unsigned data[0x6];
unsigned *map =(unsigned*)0xF430004C;

void SaveRegMap()
{ unsigned  err=0;

  for(int i=0; i<6;i++) data[i] = *(map++); 

  int f=fopen("0:\\gpio.bin",A_ReadWrite+A_Create+A_Truncate+A_BIN,P_WRITE+P_READ,&err);
  fwrite(f,data,0x18,&err);
  fclose(f,&err);
}


int main(char *exename, char *fname) {
  
  ShowMSG(1, (int)"ELF started!");
  
  InitPin(TX); //Вызывать всегда в начале,ибо пины по умолчанию привязаны к CAPCOM интерфейсу(определение подключения гарнитуры,кабеля и тд.)
  InitPin(DCD);

 
  pinMode(DCD, OUTPUT);
  pinMode(TX, OUTPUT);
  
  digitalWrite(TX, HIGH);


  

  
  //SaveRegMap();
  
  SUBPROC((void *)ElfKiller);
  return 0;
}
