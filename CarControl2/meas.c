//by alfinant 07.06.2017
//============================ Measurement Interface ===========================

#include "../inc/swilib.h"
#include "../inc/nu_swilib.h"
//#include "clkman.h"
#include "irq_work.h"

#ifdef NEWSGOLD
#include "reg8876.h"
#else
#include "reg8875.h"
#endif

#define HISR_STACK_SIZE 512
static unsigned long hisr_stack[HISR_STACK_SIZE];
static NU_HISR hisr;

static int adata=0, adata0, adata1, adata2, adata3, adata4, adata5, adata6;
static int saved_meas_ctrl2;
static IRQ_DESC irq_saved;
static void (*callback_func)(int data)=NULL;

void H_MEAS_RDY_M2_entry()
{
  adata = divide(7,(adata0+adata1+adata2+adata3+adata4+adata5+adata6));    
  SUBPROC((void*)callback_func, adata); 
}

static void meas_rdyirq(int vector)//vector==0x46
{
  MEAS.RDYIRQ = 0x4000;//сбросили флаг
  MEAS.RDYIRQ = 0;//вообще отключили 
  MEAS.CTRL2 &=~ MEAS_ENTRIG;
  
  if (MEAS.STAT & MEAS_READY)
  {
    adata0=MEAS.DATA0; 
    adata1=MEAS.DATA1;
    adata2=MEAS.DATA2;
    adata3=MEAS.DATA3;
    adata4=MEAS.DATA4;
    adata5=MEAS.DATA5;
    adata6=MEAS.DATA6;
  }
  
  MEAS.CTRL2=saved_meas_ctrl2;//восстанавливаем
  irq_set_prio(0x72, 8);//разблокируем прерывание gsm_tpu_meas  
  NU_Activate_HISR(&hisr);  
}


int meas_init()
{
  int ret=0;
  
  STATUS status=
    NU_Create_HISR(&hisr, "H_MEAS_RDY_M2", H_MEAS_RDY_M2_entry, 0, (void*)hisr_stack, HISR_STACK_SIZE);

  if (status==NU_SUCCESS)
  {
    ret=1;
    //ClkStateOn(MEASIF_MASK);
    MEAS.CLK &= ~ 1;
    MEAS.CLK &= 0x114;
    MEAS.RDYIRQ = 0;
    irq_req(0x46, 3, 8, meas_rdyirq, &irq_saved);
  }
  
  return ret;
}

void meas_deinit()
{
  irq_req(0x46, irq_saved.state, irq_saved.prio, irq_saved.handler, &irq_saved);
  NU_Delete_HISR(&hisr); 
}

void meas_get_volt_m2(void (*callback)(int data))
{
  callback_func = callback;
  irq_set_prio(0x72, 0);
  //ClkStateOn(MEASIF_MASK);
  MEAS.CLK &= ~ 1;
  MEAS.CLK &= 0x114;
  saved_meas_ctrl2 = MEAS.CTRL2;//сохраняемся
  MEAS.CTRL2 &=~ MEAS_ENTRIG;
  //while (MEAS.STAT & MEAS_BUSY);//ждемс
  MEAS.RDYIRQ = 0x4000;//сброс флага
  MEAS.RDYIRQ = 0x1000;//активируем прерывание
  MEAS.CTRL2=0x30300003; //конфиг-я для чтения напряжения с M2
  //while ((MEAS.STAT & MEAS_READY) == 0);//только если не используешь прерывание
}
