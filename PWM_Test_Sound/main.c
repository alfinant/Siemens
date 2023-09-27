#include <swilib.h>
#include <siemens/nu_swilib.h>
#include <siemens/capcom.h>
#include <siemens/i2c.h>
#include <siemens/gpio.h>
#include <siemens/interrupt.h>
#include <siemens/pin_control.h>

int Prescaler = 1;
int Frequency = 1000;
int Dutycycle = 50; 

I2C_MSG msg_40; char dat_40 = 0x26;
I2C_MSG msg_42; char dat_42 = 0x04;

#ifdef  NEWSGOLD
#define PM_RINGIN   GPIO_RF_STR1
#else
#define PM_RINGIN   GPIO_CC_VZ
#endif

void pwm_test_sound()
{
  int period;

   PM_RINGIN = (ALT2 << OS); 
   int input_clk = hw_clk;
   int saved = disable_interrupts();
   period = divide(Frequency << 10, input_clk) << 10;
   CCU1->CLK = 0x100;
   CCU1->T0REL = 65536 - period;
   CCU1->T0 = 65536 - period; 
   CCU1->CC5 = 65536 - divide(1000, Dutycycle * period * 10);
   
   CCU1->CCSEM &= ~ _BV(CCSEM5);    //отключаем режим одного события
   CCU1->CCSEE &= ~ _BV(CCSEE5);     
   CCU1->CCM1  |=  (MODE_7 << CCM1_MOD5); /* Режим сравнения 3: Выходной контакт устанавливается на каждое совпадение.При переполнение таймера выходной контакт сбрасывается.Только одно прерывание за период таймера */
   CCU1->CCM1  &= ~ _BV(CCM1_ACC5);    /* Обнуляем  бит,регистр захвата/сравнения CC5 будет привязан к таймеру T0 */

   CCU1->CCIOC &= ~ _BV(PL);
   CCU1->CCIOC |= _BV(STAG);      /* Если не установлен этот бит,значение пределителя увеличится в 8 раз */
   CCU1->CCIOC &= ~ _BV(PDS);

   CCU1->T0IC |= _BV(IC_AC);
   CCU1->T0IC  &= ~ _BV(IC_IE);     /* отключаем прерывание при переполнении таймера T0 */
   CCU1->CC5IC |= _BV(IC_AC); 
   CCU1->CC5IC &= ~ _BV(IC_IE);     /* отключаем прерывание при совпадении */
   
   CCU1->T01CON  &= ~ _BV(T0I);  /* пределитель 1, входная частота для таймера 26 Мгц */
   CCU1->T01CON  &= ~ _BV(T0M);  /* обнуляем бит-режим таймера */
   CCU1->T01CON  |= _BV(T0R);    /* установка этого бита запускает таймер */
   enable_interrupts(saved);

   i2cw_pmu(&msg_42, 0x42, &dat_42); //устанавливаем PM_RINGIN источником входного сигнала на Dialog
   i2cw_pmu(&msg_40, 0x40, &dat_40); //громкость
}

void pwm_disable()
{
  CCU1->T01CON &= ~ _BV(T0R);
  CCU1->CCIOC &= ~ _BV(STAG);  //
  CCU1->CCM1 &= ~ (MODE_7 << CCM1_MOD5);  
}

void test_led_blink()
{
  int period;
  
   GPIO_USART0_RXD = (ALT2 << OS);
   
   period = divide(Frequency << 10, hw_clk) << 10;
   CCU0->T0REL = 65536 - period;
   CCU0->T0 = CCU0->T0REL;
   CCU0->CC2 = 65536 - divide(1000, Dutycycle * period *10);
   
   CCU0->CCSEM &= ~ _BV(CCSEM2);    //отключаем режим одного события
   CCU0->CCSEE &= ~ _BV(CCSEE2);     
   CCU0->CCM0  |=   (MODE_7 << CCM0_MOD2) ; /* Режим сравнения 3: Выходной контакт устанавливается на каждое совпадение.При переполнение таймера выходной контакт сбрасывается.Только одно прерывание за период таймера */
   CCU0->CCM0  &= ~ _BV(CCM0_ACC2);  /* Обнуляем  бит,регистр захвата/сравнения CC5 будет привязан к таймеру T0 */
   
   CCU0->CCIOC |= _BV(STAG);      /* Если не установлен этот бит,значение пределителя увеличится в 8 раз.Отключаем.. */
         
   CCU0->T0IC  |= _BV(IC_AC);   
   CCU0->T0IC  &= ~ _BV(IC_IE);   /* отключаем прерывание при переполнении таймера T0 */ 
   CCU0->CC2IC |= _BV(IC_AC);
   CCU0->CC2IC &= ~ _BV(IC_IE);    /* отключаем прерывание при совпадении */
   
   CCU0->T01CON  &= ~ _BV(T0I);  /* пределитель 1, входная частота для таймера 26 Мгц */
   CCU0->T01CON  &= ~ _BV(T0M);  /* режим таймера */
   CCU0->T01CON  |= _BV(T0R);    /* cтарт таймера */  
}


const int minus11=-11;

typedef struct
{
  CSM_RAM csm;
}MAIN_CSM;

int maincsm_id;


int maincsm_onmessage(CSM_RAM* data,GBS_MSG* msg)
{
  return (1);  
}

static void maincsm_oncreate(CSM_RAM *data)
{
  pwm_test_sound();
}

extern void kill_data(void *p, void (*func_p)(void *));
void ElfKiller(void)
{
  extern void *ELF_BEGIN;
  kill_data(&ELF_BEGIN,(void (*)(void *))mfree_adr());
}

static void maincsm_onclose(CSM_RAM *csm)
{
    pwm_disable();
    SUBPROC((void *)ElfKiller);
}


static unsigned short maincsm_name_body[140];

static const struct
{
  CSM_DESC maincsm;
  WSHDR maincsm_name;
}MAINCSM =
{
  {
  maincsm_onmessage,
  maincsm_oncreate,
#ifdef NEWSGOLD
  0,
  0,
  0,
  0,
#endif
  maincsm_onclose,
  sizeof(MAIN_CSM),
  1,
  &minus11
  },
  {
    maincsm_name_body,
    NAMECSM_MAGIC1,
    NAMECSM_MAGIC2,
    0x0,
    139
  }
};


static void UpdateCSMname(void)
{
  wsprintf((WSHDR *)(&MAINCSM.maincsm_name),"PWM_TestSound");
}


int main(void)
{  
   CSM_RAM *save_cmpc;
   char dummy[sizeof(MAIN_CSM)];
   UpdateCSMname();  
   LockSched();
   save_cmpc=CSM_root()->csm_q->current_msg_processing_csm;
   CSM_root()->csm_q->current_msg_processing_csm=CSM_root()->csm_q->csm.first;
   maincsm_id=CreateCSM(&MAINCSM.maincsm,dummy,0);
   CSM_root()->csm_q->current_msg_processing_csm=save_cmpc;
   UnlockSched();
   return 0;
}

