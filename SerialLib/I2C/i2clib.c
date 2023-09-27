#include <siemens/reg8876.h>
#include <intrinsics.h>
#include <stdint.h>

#define  __IO    volatile

#define   FMRADIO    0x10  /* TEA5761UK */	
#define   CAMERA     0xB0  /* OmniVision */
#define   PMU        0x31  /* Mozart/Dialog/Twigo */

#define   DEF_PORT      0
#define   ALT_PORT      1


#define   I2C_CLK          *( __IO uint32_t*)     0xF7600000 
#define   I2C_0x10         *( __IO uint32_t*)     0xF7600010 
#define   I2C_0x14         *( __IO uint32_t*)     0xF7600014
#define   I2C_0x18         *( __IO uint32_t*)     0xF7600018 
#define   I2C_0x20         *( __IO uint32_t*)     0xF7600020 
#define   I2C_0x68         *( __IO uint32_t*)     0xF7600068 
#define   I2C_0x28         *( __IO uint32_t*)     0xF7600028 
#define   I2C_RXCNT        *( __IO uint32_t*)     0xF760002C 
#define   I2C_TXCNT        *( __IO uint32_t*)     0xF7600034 
#define   I2C_0x74         *( __IO uint32_t*)     0xF7600074 
#define   I2C_0x78         *( __IO uint32_t*)     0xF7600078 
#define   I2C_STAT         *( __IO uint32_t*)     0xF7600080 
#define   I2C_0x84         *( __IO uint32_t*)     0xF7600084 
#define   I2C_0x8C         *( __IO uint32_t*)     0xF760008C 
#define   I2C_TXBUF        *( __IO uint32_t*)     0xF7608000 
#define   I2C_RXBUF        *( __IO uint32_t*)     0xF760C000 

#define   RST_CTRL_ST      *( __IO uint32_t*)     0xF4400018       /* Reset Control And Status Register */
#define   SIFCLKS          *( __IO uint32_t*)     0xF45000B4       /* Serial Interface Clock Select Register */

void i2c_reset(void)
{
   RST_CTRL_ST |= (1 << 15);
   RST_CTRL_ST &= (1 << 15);
}

void i2c_clkOn(void)
{
  __disable_interrupt();
    SIFCLKS &= ~ 0x33 | 2;
  __enable_interrupt();
}

void i2c_clkOff()
{
  __disable_interrupt();
    SIFCLKS &= ~ 0x33 | 3;
  __enable_interrupt();
}

void i2c_disable_INT() 
{
  I2C_0x84 &= 0xFFC0;
}

void i2c_enable_INT() 
{
  I2C_0x84 &= 0x3F;
}

void i2c_wakeup(int rw) /* 0-read, 1-write */
{
  i2c_clkOn();
  
  I2C_CLK = 0x400;
  I2C_0x10 = 0;
  if(rw) I2C_0x20 = 0x280000;
  else I2C_0x20 = 0x80000;
  I2C_0x28 = 0x30022;
  I2C_0x18 = 0x4003D; 
  I2C_0x10 = 1;
  I2C_0x8C = 0x3F;
  I2C_0x78 = 0x7F; 
  I2C_0x68 = 0xF;
  
  i2c_disable_INT();
}

void i2c_sleep() 
{
   i2c_disable_INT();
   I2C_0x10 = 0;
   I2C_CLK = 1;
   
   i2c_clkOff();
}

int check_port(int port)
{  int old;

   if(!(GPIO_I2C_SCL & _BV(ENAQ))) old = DEF_PORT;
   else
     if(!(GPIO_TOUT9 & _BV(ENAQ))) old = ALT_PORT;
   
   if(port == old) return old;
   
   if(port == DEF_PORT)
   {
     GPIO_I2C_SCL = (OPENDRAIN << PPEN) | (ALT0 << OS) | (ALT0 << IS);
     GPIO_I2C_SDA = (OPENDRAIN << PPEN) | (ALT0 << OS) | (ALT0 << IS);
     GPIO_TOUT9 =  (1 << ENAQ);
     GPIO_TOUT11 = (1 << ENAQ);
   }
   else
     if(port == ALT_PORT)
     {
       GPIO_I2C_SCL = (1 << ENAQ);
       GPIO_I2C_SDA = (1 << ENAQ);
       GPIO_TOUT9 =  (OPENDRAIN << PPEN) | (ALT1 << OS) | (ALT1 << IS);
       GPIO_TOUT11 = (OPENDRAIN << PPEN) | (ALT3 << OS) | (ALT3 << IS);
     }
      
   return old;
}
/*============================================================================*/

int __i2cw_byte(uint8_t addr, uint8_t data)
{  	   
   I2C_TXCNT = 2;
   while(!(I2C_STAT & 0x1));   
   I2C_TXBUF = ((addr << 1) & 0x7F) | data << 8;  
   I2C_0x8C = 1;
   
   while(!(I2C_STAT & 0x20));
   if(I2C_0x74 & 0x10) return 4;  
   if(I2C_0x74 & 0x20)
   {
     I2C_0x78 = 0x20;
     I2C_0x8C = 0x20;
   }
   else return 0xD;
   
   return 0;
}
/*============================================================================*/

int __i2cw_short(uint8_t addr, short data)
{  	
   I2C_TXCNT = 3;	
   while(!(I2C_STAT & 0x1));   
   I2C_TXBUF = ((addr << 1) & 0x7F) | data << 8;   // отправка данных
   I2C_0x8C = 1; // далее идет проверка ошибок
  
   while(!(I2C_STAT & 0x20));
   if(I2C_0x74 & 0x10)  return 4;   
   if(I2C_0x74 & 0x20)
   {
     I2C_0x78 = 0x20;
     I2C_0x8C = 0x20;
   }
   else return 0xD;
   
   return 0;
}

/*============================================================================*/

/********************** int writeByte(uint8_t addr, uint8_t data) *************/
int __i2cr_byte(uint8_t address, uint8_t reg, char *data)
{  	
   I2C_TXCNT = 2;
   while(!(I2C_STAT & 0x1));  
   I2C_TXBUF = ((address << 1) & 0x7F) | reg << 8;
   I2C_0x8C = 1;	
	 
   while(!(I2C_STAT & 0x20));
   if(I2C_0x74 & 0x10) return 4;
   if(I2C_0x74 & 0x20)
   { 
      I2C_0x78 = 0x20;
      I2C_0x8C = 0x20;
   }
   else return 0xD;
/*************** int requestByteFrom(uint8_t address); ************************/   
   I2C_RXCNT = 1;
   I2C_TXCNT = 1;
   while(!(I2C_STAT & 0x1));     
   I2C_TXBUF = ((address << 1) & 0x7F) | 1; //set read bit
   I2C_0x8C = 1;
   
   while(!(I2C_STAT & 0x1));  
   *data = I2C_RXBUF;
   I2C_0x8C = 1; 
   
   while(!(I2C_STAT & 0x20));
   if(I2C_0x74 & 0x10) return 4;    
   if(I2C_0x74 & 0x40) 
   {
       I2C_0x78 = 0x40;
       I2C_0x8C = 0x20;
   }
   else return 0xD;
	 
   while(!(I2C_STAT & 0x20));
   if(I2C_0x74 & 0x10) return 4;   
   if(I2C_0x74 & 0x20)
   {
     I2C_0x78 = 0x20;
     I2C_0x8C = 0x20;
   }
   else return 0xD; 

   return 0;
}

/*============================================================================*/

int i2c_write_arduino(uint8_t addr, uint8_t data)
{
  int cpsr, old, err;
      cpsr = __get_CPSR();
    __asm("SWI 4");
      old = check_port(ALT_PORT);    
      i2c_wakeup(1);
      err = __i2cw_byte(addr, data );
      i2c_sleep();
      check_port(old);      
    __set_CPSR(cpsr);
      return err;		
}

/*============================================================================*/

int i2c_write_pmu(int reg, char data)
{
  int cpsr, old, err;
      cpsr = __get_CPSR();
    __asm("SWI 4");
      old = check_port(DEF_PORT);    
      i2c_wakeup(1);
      err = __i2cw_short(PMU, data << 8 | reg);
      i2c_sleep();
      check_port(old);      
    __set_CPSR(cpsr);
      return err;		
}

/*============================================================================*/

int i2c_read_pmu(int reg, char *data)
{
  int cpsr, old, err;
      cpsr = __get_CPSR();
    __asm("SWI 4");
      old = check_port(DEF_PORT);    
      i2c_wakeup(0);
      err = __i2cr_byte(PMU, reg, data);
      i2c_sleep();
      check_port(old);      
    __set_CPSR(cpsr);
      return err;	
}

/*============================================================================*/

int i2c_write_cam(int reg, char data)
{
  int cpsr, old, err;
      cpsr = __get_CPSR();
    __asm("SWI 4");
      old = check_port(ALT_PORT);    
      i2c_wakeup(1);    
      err = __i2cw_short(CAMERA, data << 8 | reg);
      i2c_sleep();
      check_port(old);      
    __set_CPSR(cpsr);
      return err;	
}

/*============================================================================*/

int  i2c_read_cam(int reg, char *data)
{
  int cpsr, old, err;
      cpsr = __get_CPSR();
    __asm("SWI 4"); //system mode
      old = check_port(ALT_PORT);     
      i2c_wakeup(0);
      err = __i2cr_byte(CAMERA, reg, data);
      i2c_sleep();
      check_port(old);
    __set_CPSR(cpsr);
      return err;	
}
	



