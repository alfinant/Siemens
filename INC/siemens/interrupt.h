#ifndef INTERRUPT_H_
#define INTERRUPT_H_

#include <intrinsics.h>

typedef struct{
  char state; //3
  char prio; //max priority==15
  char unk2;
  char unk3;  
  void (*handler)(int vector);
} IRQ_DESC;

#ifdef  CX75
#define Register_LISR ((void(*)(int vector, IRQ_DESC*, IRQ_DESC *old )) 0xA0ACA5F8)
#endif

#ifdef  S75v52
#define Register_LISR ((void(*)(int vector, IRQ_DESC*, IRQ_DESC *old )) 0xA0233140)
#endif

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
