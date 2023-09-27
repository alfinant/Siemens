#ifndef CONNECTOR_H_
#define CONNECTOR_H_

#include "i2c.h"

#ifdef NEWSGOLD
#include "reg8876.h"
#else
#include "reg8875.h"
#endif

#define  TX      1
#define  RX      2
#define  CTS     3
#define  RTS     4
#define  DCD     5
#define  POWER   6             

#define  LOW     0
#define  HIGH    1
#define  INPUT   0
#define  OUTPUT  1

uint32_t connector[]={ 0, 0, 0, 0, 0, 0, 0, 0};
uint32_t save_connector[]={ 0, 0, 0, 0, 0, 0, 0 };

void InitConnectorMap()
{
  connector[1]=(uint32_t)&GPIO.USART0_TXD;
  connector[2]=(uint32_t)&GPIO.USART0_RXD;
  connector[3]=(uint32_t)&GPIO.USART0_CTS;
  connector[4]=(uint32_t)&GPIO.USART0_RTS;
  connector[5]=(uint32_t)&GPIO.DSPOUT0;
  connector[6]=POWER;    
}

void InitPinSafe(uint8_t pin, int save)
{  
  if(pin < 8)
  { 
    __IO uint32_t *gpin = ( __IO uint32_t*) connector[pin];
   
   if(connector[pin])
   {
     if(connector[pin] == POWER)
     {
       if(save) i2c_pmu_read(PMU_REG_POWER, (char*) save_connector[pin], 0, NULL, 1);      
     }
     else
     {
       //отключаем только те прерывани€ CAPCOM0,CAPCOM1 которые нам мешают
       switch(pin)
       {
       case TX: { CCU0.CLC = 0x100; CCU0.CC2IC &= ~ICR_IEN; }
       break;
#ifdef NEWSGOLD      
       case CTS: { CCU0.CLC = 0x100; CCU0.CC6IC &= ~ICR_IEN; }
       break;         
       case RTS: { CCU1.CLC = 0x100; CCU1.CC2IC &= ~ICR_IEN; }
       break;
#else
       case CTS: { CCU1.CLC = 0x100; CCU1.CC2IC &= ~ICR_IEN; }
       break;         
       case RTS: { CCU0.CLC = 0x100; CCU0.CC6IC &= ~ICR_IEN; }
       break;
#endif       
       case DCD: { CCU1.CLC = 0x100; CCU1.CC6IC &= ~ICR_IEN; }      
       break;
       }

       if(save) save_connector[pin] = *gpin;
       //сброс, высокоимпедансное состо€ние(эквивалентно 100 кќм)
       *gpin |= GPIO_ENAQ;
       //режим ручного управлени€
       *gpin = (GPIO_ENAQ | GPIO_PS);//0x8100
     }
   }
  }
}

void RestorePin(uint8_t pin)
  { 
    __IO uint32_t *gpin = ( __IO uint32_t*) connector[pin];
   
   if(save_connector[pin]!=0)
   {
     if(connector[pin] == POWER)
     {
       if(save_connector[pin]) i2c_pmu_write(PMU_REG_POWER, (char*) save_connector[pin], NULL, 0, 1);      
     }
     else
     {
       *gpin = save_connector[pin];
       
       switch(pin)
       {
       case TX: { CCU0.CLC = 0x100; CCU0.CC2IC |= ICR_CLRFL; CCU0.CC2IC |= ICR_IEN; }
       break;
#ifdef NEWSGOLD
       case CTS: { CCU0.CLC = 0x100; CCU0.CC6IC |= ICR_CLRFL; CCU0.CC6IC |= ICR_IEN; }
       break;         
       case RTS: { CCU1.CLC = 0x100; CCU1.CC2IC |= ICR_CLRFL; CCU1.CC2IC |= ICR_IEN; }
       break;
#else       
       case CTS: { CCU1.CLC = 0x100; CCU1.CC2IC |= ICR_CLRFL; CCU1.CC2IC |= ICR_IEN; }
       break;         
       case RTS: { CCU0.CLC = 0x100; CCU0.CC6IC |= ICR_CLRFL; CCU0.CC6IC |= ICR_IEN; }
       break;
#endif
       case DCD: { CCU1.CLC = 0x100; CCU1.CC6IC |= ICR_CLRFL; CCU1.CC6IC |= ICR_IEN; }      
       break;
       }


     }
   }
 }

void pinSetIO(uint8_t pin, int out, int in)
{
    __IO uint32_t *gpin = ( __IO uint32_t*) connector[pin];
   
   if(save_connector[pin]!=0)
   {
     *gpin |= GPIO_ENAQ;
     *gpin |= (in | out << 4);
     *gpin &= ~GPIO_ENAQ;      
   }
}

void pinMode( uint8_t pin , uint8_t mode)
{
  __IO uint32_t *gpin = ( __IO uint32_t*) connector[pin];
  
  if(connector[pin])
  {
    if (mode == INPUT)
    {
      *gpin |= GPIO_ENAQ;
      *gpin &= ~(GPIO_DIR | GPIO_ENAQ);
    }
    else
      if (mode == OUTPUT) 
      {
        *gpin |= GPIO_ENAQ;
        *gpin |= GPIO_DIR;
        *gpin &= ~GPIO_ENAQ;        
      }
      else
        if (mode == OPENDRAIN)
        {
          *gpin |= GPIO_ENAQ;
          *gpin |= GPIO_PPEN;
          *gpin &= ~GPIO_ENAQ;
        }    
  }
}

void digitalWrite(uint8_t pin , uint8_t level)
{
  __IO uint32_t *gpin = ( __IO uint32_t*) connector[pin];
  
  if(connector[pin])
  {
    if(level == HIGH)
    {
      *gpin |= GPIO_ENAQ;
      *gpin |= GPIO_DAT;
      *gpin &= ~ GPIO_ENAQ;      
    }
 else
    if(level == LOW)
    {
      *gpin |= GPIO_ENAQ;
      *gpin &= ~(GPIO_ENAQ | GPIO_DAT);
    }
  }
}

int digitalRead(uint8_t pin)
{
  int val = 0;
  __IO uint32_t *gpin = ( __IO uint32_t*) connector[pin];
  
  if(connector[pin] != 0) val = (*gpin & GPIO_DAT) >> 9 ;
  return val; 
}

#endif /* CONNECTOR_H_ */
