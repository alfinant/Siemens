#include <intrinsics.h>

#define FMRADIO    0x20 // TEA5761UK	
#define CAMERA     0x60 // OmniVision
#define MOZART     0x62 //

#define I2C_0x00       *(volatile int*) 0xF7600000 
#define I2C_0x10       *(volatile int*) 0xF7600010 
#define I2C_0x14       *(volatile int*) 0xF7600014
#define I2C_0x18       *(volatile int*) 0xF7600018 
#define I2C_0x20       *(volatile int*) 0xF7600020 
#define I2C_0x68       *(volatile int*) 0xF7600068 
#define I2C_0x28       *(volatile int*) 0xF7600028 
#define I2C_RCNT       *(volatile int*) 0xF760002C 
#define I2C_WCNT       *(volatile int*) 0xF7600034 
#define I2C_0x74       *(volatile int*) 0xF7600074 
#define I2C_0x78       *(volatile int*) 0xF7600078 
#define I2C_STAT       *(volatile int*) 0xF7600080 
#define I2C_0x84       *(volatile int*) 0xF7600084 
#define I2C_0x8C       *(volatile int*) 0xF760008C 
#define I2C_TBUF       *(volatile int*) 0xF7608000 
#define I2C_RBUF       *(volatile int*) 0xF760C000 

#define GPIO_I2C_DAT   *(volatile int*) 0xF4300090
#define GPIO_I2C_CLK   *(volatile int*) 0xF4300094

#define GPIO_I2C_2_DAT *(volatile int*) 0xF43000F0 
#define GPIO_I2C_2_CLK *(volatile int*) 0xF43000F8

#define SCU_0x18       *(volatile int*) 0xF4400018
#define PLL_SIFCLKS    *(volatile int*) 0xF45000B4  //Serial Interface Clock Select Register
#define STM_0x10       *(volatile int*) 0xF4B00010


void i2c_check_port_1()
{
   GPIO_I2C_CLK = 0x1211;
   GPIO_I2C_DAT = 0x1211;
   GPIO_I2C_2_DAT = 0x8200;
   GPIO_I2C_2_CLK = 0x8200;	
}

void i2c_check_port_2()
{
   GPIO_I2C_2_DAT = 0x1222;
   GPIO_I2C_2_CLK = 0x1244;
   GPIO_I2C_CLK = 0x8200;
   GPIO_I2C_DAT = 0x8200;        
}

void i2c_clk_on(void)
{
  __disable_interrupt();
    PLL_SIFCLKS &= ~ 0x33 | 2;
  __enable_interrupt();
}

void i2c_clk_off(void)
{
  __disable_interrupt();
    PLL_SIFCLKS &= ~ 0x33 | 3;
  __enable_interrupt();
}

void i2c_scu_init(void)
{
   SCU_0x18 |= 0x8000;
   SCU_0x18 &= ~ 0x8000;	
}

void setConf() 
{
  I2C_0x00 = 0x200;
  I2C_0x10 = 0;
  I2C_0x20 = 0x80000;
  I2C_0x28 = 0x30022;
  I2C_0x18 = 0x10040; 
  I2C_0x10 = 1;
  I2C_0x8C = 0x3F;
  I2C_0x78 = 0x3F; 
  I2C_0x68 = 0xF;
}


void disable_I2C_INT() 
{
  I2C_0x84 &= 0xFFC0;
}

void enable_I2C_INT() 
{
  I2C_0x84 &= 0x3F;
}

void stop() 
{
   disable_I2C_INT();
   I2C_0x10 = 0;
   I2C_0x00 = 1;
}

/*=============================================================================*/

int __i2cw_pmu(int adr, int reg, unsigned char data)
{
   int status;   
	
   setConf();
   disable_I2C_INT();
   I2C_WCNT = 3;
	
   while((status=I2C_STAT & 0x1) == 0);   
   I2C_TBUF = adr & 0x7F | reg << 8 | data << 16;
   I2C_0x8C = 1;	

       while(!(I2C_STAT & 0x20));     
       if((status = I2C_0x74) & 0x20)
   {
       I2C_0x14 |= 2;
       I2C_0x78 = 0x20;
       I2C_0x8C = 0x20;
   }
	 else if(status & 0x10) return 4;
   else return 0xD;
   
   while(!(I2C_STAT & 0x20));    
   if((status = I2C_0x74) & 0x10)  return 0x4;
   if(!(status & 0x20)) return 0xD;
   I2C_0x78 = 0;
   I2C_0x8C = 0;   
   stop();
   return 0;
}

/*==========================================================================*/

int __i2cr_pmu(int adr, int reg, unsigned char *data)
{  
   int status;		
	
   setConf();
   disable_I2C_INT();
   I2C_WCNT = 2;
	
   while((I2C_STAT & 0x1) == 0);   
   I2C_TBUF =  reg << 8 | (adr & 0x7F) | 1  ;
   I2C_0x8C = 1;	
	 
   while(!(I2C_STAT & 0x20));     
   if((status = I2C_0x74) & 0x20)
   {	
      I2C_RCNT = 1;
      I2C_WCNT = 1;
      I2C_0x78 = 0x20;
      I2C_0x8C = 0x20;      
   }
         else if(status & 0x10) return 4;
   else return 0xE;
		 
   while(!(I2C_STAT & 0x1));     
   I2C_TBUF = (adr & 0x7F) | 1;	 
   I2C_0x8C = 1;
   
   while((status=I2C_STAT & 0xF) == 0);   
   *data = I2C_RBUF;
   I2C_0x8C = 1; 
   
   while(!(I2C_STAT & 0x20));     
   if((status =I2C_0x74) & 0x60)
   {
       I2C_0x78 = 0x20;
       I2C_0x14 |= 2;
       I2C_0x78 = 0x40;		 
       I2C_0x8C = 0x20;
   }
         else if(status & 0x10) return 4;
   else return 0xE;
	 
   while(!(I2C_STAT & 0x20));     
   if((status =I2C_0x74) & 0x20)
   {
       I2C_0x78 = 0x20;	 
       I2C_0x8C = 0x20;
   }
	 else if(status & 0x10) return 4;
   else return 0xE; 
	 
   stop();
   return 0;
}
/*=============================================================================*/

int __i2cr_fcam(int adr, int reg, unsigned char *data, int size)
{  
   int status;		
	
   setConf();
   disable_I2C_INT();
   I2C_WCNT = 2;
   while(!(I2C_STAT & 0x1));     // Wait   
   I2C_TBUF  = (adr & 0x7F) | (reg << 8);
   I2C_0x8C = 1;
   while(!(I2C_STAT & 0x20));     // Wait 
   if((status = I2C_0x74) & 0x20)
   {	
      I2C_0x78 = 0x20;
      I2C_0x8C = 0x20;
      I2C_RCNT = size;
      I2C_WCNT = 0x1;
      while(!(I2C_STAT & 0x1));     // Wait
   }
      else if(status & 0x10) return 4;
   else return 0xE;
   
   I2C_TBUF = (adr & 0x7F) | 1 ;	 
   I2C_0x8C = 1;
 //  while(!(I2C_STAT & 0x1));     // Wait 
	 
   for( int i=0; i < size;) 
	 {  unsigned t1 = STM_0x10;
            while((status = I2C_STAT & 0xF) == 0 ) { if((STM_0x10 - t1) > 1000) return 0xD; }  
		 for( int k=0; k < 4 && i < size ; ++k)
		 {
			 int j = 0;
			 int rx = I2C_RBUF;
			 while(j < 4 && i < size) data[i++] = rx >> (j++ << 3);		 
		 }
		 I2C_0x8C = status;
	 }
   
   while(!(I2C_STAT & 0x20));     // Wait  
   if((status =I2C_0x74) & 0x60)
   {
       I2C_0x78 = 0x20;
       I2C_0x14 |= 2;
       I2C_0x78 = 0x40;		 
       I2C_0x8C = 0x20;
   }
	 else if(status & 0x10) return 4;
   else return 0xE;
	 
   while(!(I2C_STAT & 0x20));     // Wait
   if((status =I2C_0x74) & 0x20)
   {
       I2C_0x78 = 0x20;	 
       I2C_0x8C = 0x20;
   }
	 else if(status & 0x10) return 4;
   else return 0xE; 
	 
   stop();
   return 0;
}
/*=============================================================================*/

int __i2cw_fm(int adr, unsigned char *data, int size)
{ 
   int  status, tx, j=1;

   setConf();
   disable_I2C_INT();
   I2C_WCNT = size + 1;
   tx = (adr & 0x7F);
	
	 while((status=I2C_STAT & 0xF) == 0);   // Wait
	
   for (int i=0; i < size;) {	   
     while (j < 4 && i < size) { tx |= data[i++] << (j++ << 3); }
     I2C_TBUF = tx;
                       j = 0; tx = 0;
   }
	 
   I2C_0x8C = status;
	 
   while(!(I2C_STAT & 0x20));     // Wait
   if((status = I2C_0x74) & 0x20)
   {
	     I2C_0x14 |= 2;
       I2C_0x78 = 0x20;
       I2C_0x8C = 0x20;
   }
	 else if(status & 0x10) return 4;
	 else return 0xD;
   
   while(!(I2C_STAT & 0x20));     // Wait
   if((status = I2C_0x74) & 0x10)	 return 0x4;
	 if(!(status & 0x20)) return 0xD;
   I2C_0x78 = 0;
   I2C_0x8C = 0;   
   stop();
   return 0;
}   

/*=============================================================================*/

int __i2cr_fm(int adr, unsigned char *data, int size)
{ 
   int  status;
	
   setConf();
   disable_I2C_INT();
   I2C_RCNT = size;
   I2C_WCNT = 1;

   while((status=I2C_STAT & 0xF) == 0); 
   I2C_TBUF = (adr & 0x7F) | 1;
   I2C_0x8C = 1; 
	 
   while((status=I2C_STAT & 0xF) == 0);   // Wait
	 
   for( int i=0; i < size;) 
	 { 
		 int j = 0;
		 int rx = I2C_RBUF;
		 while(j < 4 && i < size) data[i++] = rx >> (j++ << 3);
	 }
	 
   I2C_0x8C = status;
	 
	 while(!(I2C_STAT & 0x20));     // Wait
   if((status =I2C_0x74) & 0x60)
   {
	     I2C_0x14 |= 2;
       I2C_0x78 = 0x60;
       I2C_0x8C = 0x60;
   }
	 else if(status & 0x10) return 4;
   else return 0xD;
	 
   while(!(I2C_STAT & 0x20));     // Wait
   if((status = I2C_0x74) & 0x10)	 return 0x4;
	 if(!(status & 0x20)) return 0xD;
   I2C_0x78 = 0;
   I2C_0x8C = 0;   
   stop();
   return 0;
}

/*=============================================================================*/

int i2cw_pmu(int reg, unsigned char data)
{
  int cpsr, err;
      cpsr = __get_CPSR();
      i2c_check_port_1();
    __asm("SWI 4");
      i2c_clk_on();
      err = __i2cw_pmu(MOZART, reg, data);
      i2c_clk_off();
    __set_CPSR(cpsr);
      return err;		
}

/*=============================================================================*/

int i2cr_pmu(int reg, unsigned char *data)
{
  int cpsr, err;
      cpsr = __get_CPSR();
      i2c_check_port_1();
    __asm("SWI 4");
      i2c_clk_on();	
      err = __i2cr_pmu(MOZART, reg, data);
      i2c_clk_off();
    __set_CPSR(cpsr);
      return err;	
}

/*=============================================================================*/
int i2cw_fm(unsigned char *data, int size)
{  
  int cpsr, err;
      cpsr = __get_CPSR();
      i2c_check_port_1();
    __asm("SWI 4"); 
      i2c_clk_on();	
      err = __i2cw_fm(FMRADIO, data, size);
      i2c_clk_off();
    __set_CPSR(cpsr);
      return err;
}
/*=============================================================================*/
int i2cr_fm(int adr, unsigned char *data,int size)
{  
  int cpsr, err;
      cpsr = __get_CPSR();
      i2c_check_port_1();
    __asm("SWI 4"); 
      i2c_clk_on();	
      err = __i2cr_fm(FMRADIO, data, size);
      i2c_clk_off();
    __set_CPSR(cpsr);
      return err;
}
/*=============================================================================*/

int i2cwx_cam(int reg, unsigned char data)
{
  int cpsr, err;
      cpsr = __get_CPSR();
      i2c_check_port_2();
    __asm("SWI 4");
      i2c_clk_on();		
      err = __i2cw_pmu(CAMERA, reg, data);
      i2c_clk_off();
    __set_CPSR(cpsr);
      return err;	
}

/*=============================================================================*/

int i2crx_cam(int reg, unsigned char *data, int size)
{
  int cpsr, err;
      cpsr = __get_CPSR();
      i2c_check_port_2();
    __asm("SWI 4");
      i2c_clk_on();	
      err = __i2cr_fcam(CAMERA, reg, data, size);
      i2c_clk_off();
    __set_CPSR(cpsr);
      return err;	
}
	
/*=============================================================================*/

