#include "irq_work.h"
#include "interrupt.h"

int irq_set_prio(int irq_n, int prio)
{
  int prv_prio;
  
  int saved = disable_interrupts();
  int* pa= (int*)(IRQ_PRIO_TAB_BASE + (irq_n << 2));
  prv_prio = (*pa & 0xF);
  *pa = (prio & 0xF);
  enable_interrupts(saved);
  
  return prv_prio;
}

int irq_get_prio(int irq_n)
{
  int* pa= (int*)(IRQ_PRIO_TAB_BASE + (irq_n << 2));
  int prio = *pa;
  
  return (prio & 0xF);
}

static int irq_get_state(int irq_n)
{
  char* sa= (char*)(IRQ_STATE_TAB_BASE + irq_n);
  
  return *sa;  
}

static void irq_set_state(int irq_n, int state)
{
  int saved = disable_interrupts();
  char* sa=(char*)(IRQ_STATE_TAB_BASE + irq_n);
  *sa=state;
  enable_interrupts(saved);
}

static void* irq_get_handler(int irq_n)
{
  unsigned* ha= (unsigned*)(IRQ_HANDLER_TAB_BASE + (irq_n << 2));
  return (void*)*ha;
}

static void irq_set_handler(int irq_n, void handler(int))
{
  int saved = disable_interrupts();
   unsigned *ha= (unsigned*)(IRQ_HANDLER_TAB_BASE + (irq_n << 2));
  *ha=(unsigned)handler;
  enable_interrupts(saved);
}

void irq_req(int irq_n, int state, int prio, void handler(int), IRQ_DESC* d)
{
  d->state=irq_get_state(0x46);
  d->prio=irq_get_prio(0x46);
  d->handler=(void(*)(int))irq_get_handler(0x46);
  
  irq_set_handler(irq_n, handler);
  irq_set_state(irq_n, state);
  irq_set_prio(irq_n, prio);
    
}

