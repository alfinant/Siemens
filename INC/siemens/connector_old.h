#ifndef CONNECTOR_H_
#define CONNECTOR_H_

#include <siemens/reg8876.h>
#include <siemens/i2c.h>

#ifdef NEWSGOLD 
#define  RTS                  1
#define  CTS                  2
#define  TX                   3
#define  RX                   4
#define  DCD                  6
#define  POWER                7
#else
#define  POWER                1
#define  TX                   3
#define  RX                   4
#define  CTS                  5
#define  RTS                  6
#define  DCD                  7
#endif

#define  LOW                  0
#define  HIGH                 1

#define  INPUT                0
#define  OUTPUT               1
#define  INPUT_OPENDRAIN      2
#define  OUTPUT_OPENDRAIN     3
#define  INPUT_PULLUP         4

#ifdef NANO   
uint32_t connector[] = { 0, 0xF4300054, 0xF4300058, 0xF4300050, 0xF430004C, 0, 0xF430005C, POWER, 0, 0, 0, 0, 0};  /* IO_Nano_LUMBERG */
#else
uint32_t connector[] = { 0, POWER, 0, 0xF4300050, 0xF430004C, 0xF4300058, 0xF4300054, 0xF430005C, 0, 0, 0, 0, 0};  /* IO_LUMBERG */
#endif

uint32_t old[] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}; 

I2C_RAM i2cram;


void InitPin(uint8_t pin)
{
  if(pin > 12) return;
  
    __IO uint32_t *reg = ( __IO uint32_t*) connector[pin];
   
   if(reg)
   {
     if(connector[pin] == POWER)
     {
       i2cram.msg.data = (char*)&old[pin];
       i2cr_pmu(&i2cram, I2C_REG_POWER, 0);      
     }
     else
     {
       CCU0.CLC = 0;
       CCU1.CLC = 0;
       old[pin] = *reg;
       *reg = 0;
       CCU0.CLC = 0x100;
       CCU1.CLC = 0x100;
     }
   }
}

void pinMode( uint8_t pin , uint8_t mode)
{
  __IO uint32_t *reg = ( __IO uint32_t*) connector[pin];
  
  if(connector[pin] != 0)
  {
    if (mode == INPUT) *reg = _BV(PS);
    else
      if (mode == OUTPUT) *reg = _BV(DIR) | _BV(PS);    
      else
        if (mode == INPUT_OPENDRAIN) *reg = _BV(PPEN) | _BV(PS) ;
        else
          if (mode == OUTPUT_OPENDRAIN) *reg = _BV(PPEN) | _BV(DIR) | _BV(PS);
        else
          if (mode == INPUT_PULLUP) *reg = _BV(PDPU) | _BV(PS) ;
  }
}

void digitalWrite(uint8_t pin , uint8_t level)
{
  __IO uint32_t *reg = ( __IO uint32_t*) connector[pin];
  
  if(connector[pin] != 0)
  {
    if(level == HIGH) *reg |= _BV(DAT);
 else
    if(level == LOW) *reg &= ~ _BV(DAT);
  }
}

int digitalRead(uint8_t pin)
{
  int val = 0;
  __IO uint32_t *reg = ( __IO uint32_t*) connector[pin];
  
  if(connector[pin] != 0) val = *reg & _BV(DAT);
  return val; 
}

#endif /* CONNECTOR_H_ */
