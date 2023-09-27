#ifndef INTERRUPT_H_
#define INTERRUPT_H_

#include <intrinsics.h>

int disable_interrupts(void)
{
  unsigned long cpsr; 
  cpsr = __get_CPSR();
  if((cpsr & 0x1F) == 0x10) 
#ifdef NEWSGOLD
  __asm("SWI 4"); 
#else
   __asm("SWI 0");
#endif
   __set_CPSR(cpsr | 0xC0);
   return cpsr & 0xC0;
}

void enable_interrupts(int saved)
{
  unsigned long cpsr; 
  cpsr = __get_CPSR();
  if((cpsr & 0x1F) == 0x10)
#ifdef NEWSGOLD
  __asm("SWI 4"); 
#else
   __asm("SWI 0");
#endif
   __set_CPSR((cpsr &~ 0xC0) | saved);
}

#endif /* INTERRUPT_H_ */
