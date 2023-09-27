#ifndef CONNECTOR_H_
#define CONNECTOR_H_

#ifdef NEWSGOLD
#include "../inc/reg8876.h"
#else
#include "../inc/reg8875.h"
#endif
#include "../inc/i2c.h"

#ifdef LUMBERG_NANO 
#define  RTS                  1
#define  CTS                  2
#define  TX                   3
#define  RX                   4
#define  DCD                  6
#define  POWER                7
uint32_t connector[]={0,0xF4300058,0xF4300054,0xF4300050,0xF430004C,0,0xF430005C,POWER,0,0,0,0,0};
#else
#define  POWER                1
#define  TX                   3
#define  RX                   4
#define  CTS                  5
#define  RTS                  6
#define  DCD                  7
uint32_t connector[]={0,POWER,0,0xF4300050,0xF430004C,0xF4300058,0xF4300054,0xF430005C,0,0,0,0,0};
#endif

#define  LOW                  0
#define  HIGH                 1
#define  INPUT                0
#define  OUTPUT               1

uint32_t save_connector[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; 

void InitPinSafe(uint8_t pin, int save)
{  
  if(pin < 8)
  { 
    __IO uint32_t *gpin = ( __IO uint32_t*) connector[pin];
   
   if(connector[pin])
   {
     if(connector[pin] == POWER)
     {
       if(save) i2cr_pmu(PMU_REG_POWER, (char*) save_connector[pin], 0, 0);      
     }
     else
     {
       //отключаем только те прерывани€ CAPCOM0,CAPCOM1 которые нам мешают
       switch(pin)
       {
       case TX: { CCU0.CLC = 0x100; CCU0.CC2IC &= ~ICR_IEN; }
       break;
#ifdef LUMBERG_NANO       
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
       *gpin = (GPIO_ENAQ | GPIO_PS);//0x8100 настраиваем на вход
     }
   }
  }
}

void RestorePin(int pin)
  { 
    __IO uint32_t *gpin = ( __IO uint32_t*) connector[pin];
   
   if(save_connector[pin]!=0)
   {
     if(connector[pin] == POWER)
     {
       if(save_connector[pin]) i2cw_pmu(PMU_REG_POWER, (char*) save_connector[pin], 0, 0);      
     }
     else
     {
       *gpin = save_connector[pin];
       
       switch(pin)
       {
       case TX: { CCU0.CLC = 0x100; CCU0.CC2IC |= ICR_CLRFL; CCU0.CC2IC |= ICR_IEN; }
       break;
#ifdef LUMBERG_NANO
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


void pinMode( uint8_t pin , uint8_t mode)
{
  __IO uint32_t *gpin = ( __IO uint32_t*) connector[pin];
  
  if(connector[pin])
  {
    if (mode == INPUT)
    {
      *gpin |= GPIO_ENAQ;
      *gpin &= ~GPIO_DIR; //0x8100
    }
    else
      if (mode == OUTPUT) 
      {
        *gpin |= GPIO_ENAQ;
        *gpin |= GPIO_DIR;      
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
