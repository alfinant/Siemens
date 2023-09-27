#include "..inc/swilib.h"
#include "..inc/reg8876.h"
#include "..inc/i2c.h"
#include "..inc/clkman.h"
#include "..inc/interrupt.h"

int Prescaler = 1;
int Frequency = 1000;
int Dutycycle = 50; 

I2C_RAM msg_40, msg_42;
char dat_40 = 0x26;
char dat_42 = 0x04;

#define _BV(bit) (1 << (bit))

#ifdef SGOLD
#define PM_RINGIN   GPIO_CC_VZ
#endif
#ifdef NEWSGOLD
#define PM_RINGIN   GPIO_RF_STR1
#endif

extern void kill_data(void *p, void (*func_p)(void *));
void ElfKiller(void)
{
  extern void *ELF_BEGIN;
  kill_data(&ELF_BEGIN,(void (*)(void *))mfree_adr());
}

void pwm_test_sound()
{
  int count;

   PM_RINGIN = (ALT2 << OS); 
   int saved = disable_interrupts();
   count = divide(Frequency << 10, hw_clk) << 10; // Алгоритм вычислений взят из прошивки.Есть ограничение-частота не должна быть больше 26kHz
   CCU1->CLK = 0x100;
   CCU1->T0REL = 65536 - count;
   CCU1->T0 = 65536 - count; 
   CCU1->CC5 = 65536 - divide(1000, Dutycycle * count * 10);
   
   CCU1->CCSEM &= ~ _BV(CCSEM5);    //отключаем режим одного события
   CCU1->CCSEE &= ~ _BV(CCSEE5);     
   CCU1->CCM1  |=  (MODE_7 << CCM1_MOD5); /* Режим сравнения 3: При совпадении устанавливается флаг прерывания  и дополнительно выходной контакт CCxIO будет установлен в 1.При переполнение таймера выходной контакт сбрасывается. */
   CCU1->CCM1  &= ~ _BV(CCM1_ACC5);    /* Обнуляем  бит,регистр захвата/сравнения CC5 будет привязан к таймеру T0 */

   CCU1->CCIOC &= ~ _BV(PL);
   CCU1->CCIOC |= _BV(STAG);      /* Если не установлен этот бит,значение пределителя увеличится в 8 раз */
   CCU1->CCIOC &= ~ _BV(PDS);


   CCU1->T0IC  &= ~ SFR_ICEN;  /* отключаем прерывание при переполнении таймера T0 */
   CCU1->CC5IC &= ~ SFR_ICEN;  /* отключаем прерывание при совпадении значения регистра CC5 со значением таймера*/
   
   CCU1->T01CON  &= ~ _BV(T0I);  /* пределитель 1, входная частота для таймера 26 Мгц */
   CCU1->T01CON  &= ~ _BV(T0M);  /* обнуляем бит-режим таймера */
   CCU1->T01CON  |= _BV(T0R);    /* установка этого бита запускает таймер */
   enable_interrupts(saved);

   i2cw_pmu(&msg_42, 0x42, 4, 0); //устанавливаем PM_RINGIN источником входного сигнала на Dialog
   i2cw_pmu(&msg_40, 0x40, 0x26, 0); //громкость
}

void test_pin()
{
  int count;
  
   GPIO_DSPOUT0 = (ALT2 << OS); // pin 6
   int saved = disable_interrupts();   
   count = divide(Frequency << 10, hw_clk) << 10; // Алгоритм вычислений взят из прошивки.Есть ограничение-частота не должна быть больше 26kHz
   CCU1->CLK = 0x100;  
   CCU1->T0REL = 65536 - count;
   CCU1->T0 = 65536 - count; 
   CCU1->CC6 = 65536 - divide(1000, Dutycycle * count * 10);
   
   CCU1->CCSEM &= ~ _BV(CCSEM6);    //отключаем режим одного события
   CCU1->CCSEE &= ~ _BV(CCSEE6);     
   CCU1->CCM1  |=   (MODE_5 << CCM1_MOD6) ; /* Режим сравнения 3: Выходной контакт устанавливается на каждое совпадение.При переполнение таймера выходной контакт сбрасывается.Только одно прерывание за период таймера */
   CCU1->CCM1  &= ~ _BV(CCM1_ACC6);  /* Обнуляем  бит,регистр захвата/сравнения CC6 будет привязан к таймеру T0 */
   
   CCU1->CCIOC &= ~ _BV(PL);
   CCU1->CCIOC |= _BV(STAG);      /* Если не установлен этот бит,значение пределителя увеличится в 8 раз */
   CCU1->CCIOC &= ~ _BV(PDS);
           
   CCU1->T0IC  &= ~ SFR_ICEN;   /* отключаем прерывание при переполнении таймера T0 */ 
   CCU1->CC6IC &= ~ SFR_ICEN;    /* отключаем прерывание при совпадении */
   
   CCU1->T01CON  &= ~ _BV(T0I);  /* пределитель 1, входная частота для таймера 26 Мгц */
   CCU1->T01CON  &= ~ _BV(T0M);  /* режим таймера */
   CCU1->T01CON  |= _BV(T0R);    /* cтарт таймера */ 
   enable_interrupts(saved);
}


void test_100kHz()
{
 
   GPIO_DSPOUT0 = (ALT2 << OS); // pin 6
   int saved = disable_interrupts();   

   CCU1->CLK = 0x100;
   CCU1->T0REL = 0xFF00;  //Разрешение таймера при делителе частоты 1 будет 39.0625 ns, P = 39.0625  * 256 = 1/100000
   CCU1->T0 = 0xFF00; 
   CCU1->CC6 = 0xFF80;
   
   CCU1->CCSEM &= ~ _BV(CCSEM6);    //отключаем режим одного события
   CCU1->CCSEE &= ~ _BV(CCSEE6);     
   CCU1->CCM1  |=   (MODE_7 << CCM1_MOD6) ; /* Режим сравнения 3: Выходной контакт устанавливается на каждое совпадение.При переполнение таймера выходной контакт сбрасывается.Только одно прерывание за период таймера */
   CCU1->CCM1  &= ~ _BV(CCM1_ACC6);  /* Обнуляем  бит,регистр захвата/сравнения CC6 будет привязан к таймеру T0 */
   
   CCU1->CCIOC &= ~ _BV(PL);
   CCU1->CCIOC |= _BV(STAG);      /* Если не установлен этот бит,значение пределителя увеличится в 8 раз */
   CCU1->CCIOC &= ~ _BV(PDS);
           
   CCU1->T0IC  &= ~ _BV(CCU_INT_EN);   /* отключаем прерывание при переполнении таймера T0 */ 
   CCU1->CC6IC &= ~ _BV(CCU_INT_EN);    /* отключаем прерывание при совпадении */
   
   CCU1->T01CON  &= ~ _BV(T0I);  /* пределитель 1, входная частота для таймера 26 Мгц */
   CCU1->T01CON  &= ~ _BV(T0M);  /* режим таймера */
   CCU1->T01CON  |= _BV(T0R);    /* cтарт таймера */ 
   enable_interrupts(saved);
}

void test_1Gz()
{
  int count;
  
   GPIO_DSPOUT0 = (ALT2 << OS); // pin 6
   int input_clk = divide(Prescaler, hw_clk );
   int saved = disable_interrupts();   

   CCU0->CLK = 0x100;
   CCU0->T0 =  0x3C00;
   CCU0->T0REL = 0x3C00;
   CCU0->CC2 = 0x9E00;
   
   CCU0->CCSEM &= ~ _BV(CCSEM2);    //отключаем режим одного события
   CCU0->CCSEE &= ~ _BV(CCSEE2);     
   CCU0->CCM0  |=   (MODE_5 << CCM0_MOD2) ; /* Режим сравнения 3: Выходной контакт устанавливается на каждое совпадение.При переполнение таймера выходной контакт сбрасывается.Только одно прерывание за период таймера */
   CCU0->CCM0  &= ~ _BV(CCM0_ACC2);  /* Обнуляем  бит,регистр захвата/сравнения CC2 будет привязан к таймеру T0 */
   
   CCU0->CCIOC |= _BV(STAG);      /* Если не установлен этот бит,значение пределителя увеличится в 8 раз.Отключаем.. */
           
   CCU0->T0IC  &= ~ _BV(CCU_INT_EN);   /* отключаем прерывание при переполнении таймера T0 */ 
   CCU0->CC2IC &= ~ _BV(CCU_INT_EN);    /* отключаем прерывание при совпадении */
   
   CCU0->T01CON  |= 6;  /* пределитель 1, входная частота для таймера 26 Мгц */
   CCU0->T01CON  &= ~ _BV(T0M);  /* режим таймера */
   CCU0->T01CON  |= _BV(T0R);    /* cтарт таймера */  
}

int main(void)
{   

   ShowMSG(1,(int)"ELF Started!" );
   ClkStateOn(CAPCOM);
   test_pin();
   //test_100kHz();

   SUBPROC((void *)ElfKiller);
   return 0;
}

