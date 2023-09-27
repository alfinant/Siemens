#include <siemens/swilib.h>
#include <siemens/nu_swilib.h>
#include <siemens/reg8876.h>
#include "i2clib.h"
#include <siemens/i2c.h>

#define    ClkSetLevel            ((int(*)(unsigned client,int level)) 0xA04D0728)
//#define    i2cr_pmu               ((int(*)(int addr, short reg, char *data)) 0xA04F4220)

extern void kill_data(void *p, void (*func_p)(void *));
#pragma segment="ELFBEGIN"

void ElfKiller(void)
{
  kill_data(__segment_begin("ELFBEGIN"),(void (*)(void *))mfree_adr());
}

void WriteFile(void *addr,int  max)
{ 
 int f;
 
 if((f=fopen("0:\\cam.bin", A_ReadWrite + A_TXT + A_Create, P_READ + P_WRITE, 0))!=-1);
   {
     fwrite(f, addr , max, 0);
     fclose(f,0);
   }
}



int main(char *exename, char *fname)
{ 
  char s[32];
  
   int err=i2cw_string(0x80, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
   NU_Sleep(6);
   i2cw_string(0x80, "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
   NU_Sleep(6);
   i2cw_string(0x80, "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC");
   NU_Sleep(6);
   i2cw_string(0x80, "DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD");
   sprintf(s, "err=0x%x", err);
   ShowMSG(1, (int)s);
 
/*  
int c=32;
while(c--) { i2c_write_arduino(0x80, 'A'); NU_Sleep(1);}

*/
 // int err=i2cw_pmu(&i2cram, I2C_REG_KEYPADLIGHT, 0, 0);
  
 // int err = i2c_write_pmu(I2C_REG_KEYPADLIGHT, 0);
 // int err = i2c_write_cam(0x2B, 0x40);
  
       
    //int err=i2c_write_pmu(I2C_REG_POWER, 0x28);
   // int err = i2c_write_arduino(4, 'A');


  
 /* 
   int err=i2c_read_pmu(I2C_REG_POWER, &data);
   if(!err)
   {
     sprintf(s, "0x%x", data);
     ShowMSG(1, (int)s);
   }
   else ShowMSG(1, (int)"i2c error");
*/
    
    SUBPROC((void *)ElfKiller);
    return 0;
}

