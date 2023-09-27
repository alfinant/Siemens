#include "../inc/swilib.h"
#include "../inc/i2c.h"
#include "../inc/clkman.h"
#include "../inc/interrupt.h"

#ifdef NEWSGOLD
#include "../inc/reg8876.h"
#else
#include "../inc/reg8875.h"
#endif

void int_ccu1_t0_handler(int irq);

typedef struct{
  char state; //3
  char prio; //max priority==15
  char unk2;
  char unk3;  
  void (*handler)(int vector);
} IRQ_DESC;


IRQ_DESC ccu1_t0=
{
  3,
  0xA,
  0,
  0,
  int_ccu1_t0_handler,
};


#ifdef  CX75
#define Register_IRQ ((void(*)(char irq_vector, IRQ_DESC* new, IRQ_DESC *old )) 0xA0ACA5F8)
#endif

int Prescaler = 1; 
int Frequency = 1000;
int Dutycycle = 50; 


char dat_40 = 0x26;
char dat_42 = 0x04;

#ifdef SGOLD
#define PM_RINGIN   GPIO.CC_VZ
#endif
#ifdef NEWSGOLD
#define PM_RINGIN   GPIO.RF_STR1
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

   PM_RINGIN = 0x30; 
   int saved = disable_interrupts();
   count = divide(Frequency << 10, capcom_hw_clk) << 10; // Алгоритм вычислений взят из прошивки.Частота не должна быть больше 26kHz
   CCU1.CLC = 0x100;
   CCU1.T0REL = 65536 - count;
   CCU1.T0 = 65536 - count; 
   CCU1.CC5 = 65536 - divide(1000, Dutycycle * count * 10);
   
   CCU1.CCSEM &= ~ CCSEM5;  //отключаем режим одного события
   CCU1.CCSEE &= ~ CCSEE5;     
   CCU1.CCM1  |=  CCM1_MOD5 & (MODE_COMPARE_3 << 4); /* Режим сравнения 3: При совпадении устанавливается флаг прерывания  и дополнительно выходной контакт CCxIO будет установлен в 1.При переполнение таймера выходной контакт сбрасывается. */
   CCU1.CCM1  &= ~ CCM1_ACC5;    /* Обнуляем  бит,регистр захвата/сравнения CC5 будет привязан к таймеру T0 */

   CCU1.CCIOC &= ~ PL;
   CCU1.CCIOC |= STAG;      /* Если не установлен этот бит,значение пределителя увеличится в 8 раз */
   CCU1.CCIOC &= ~ PDS;


   CCU1.T0IC  &= ~ ICR_IEN;  /* отключаем прерывание при переполнении таймера T0 */
   CCU1.CC5IC &= ~ ICR_IEN;  /* отключаем прерывание при совпадении значения регистра CC5 со значением таймера*/
   
   CCU1.T01CON  &= ~ T0I;  /* пределитель 1, входная частота для таймера 26 Мгц */
   CCU1.T01CON  &= ~ T0M;  /* обнуляем бит,режим таймера */
   CCU1.T01CON |= T0R;    /* установка этого бита запускает таймер */
   enable_interrupts(saved);

   i2cw_pmu(0x42, &dat_42, 0, 0); //устанавливаем PM_RINGIN источником входного сигнала на Dialog
   i2cw_pmu(0x40, &dat_40, 0, 0); //громкость
} 

void test_pin()
{
  int count;
  
   GPIO.DSPOUT0 = 0x30; // pin 6
   int saved = disable_interrupts();   
   count = divide(Frequency << 10, capcom_hw_clk) << 10; // Алгоритм вычислений взят из прошивки.Есть ограничение-частота не должна быть больше 26kHz
   CCU1.CLC = 0x100;  
   CCU1.T0REL = 65536 - count;
   CCU1.T0 = 65536 - count; 
   CCU1.CC6 = 65536 - divide(1000, Dutycycle * count * 10);
   
   CCU1.CCSEM &= ~ CCSEM6;    //отключаем режим одного события
   CCU1.CCSEE &= ~ CCSEE6;     
   CCU1.CCM1  |=  CCM1_MOD6 & (MODE_COMPARE_3 << 8); /* Режим сравнения 3: Выходной контакт устанавливается на каждое совпадение.При переполнение таймера выходной контакт сбрасывается.Только одно прерывание за период таймера */
   CCU1.CCM1  &= ~ CCM1_ACC6;  /* Обнуляем  бит,регистр захвата/сравнения CC6 будет привязан к таймеру T0 */
   
   CCU1.CCIOC &= ~ PL;
   CCU1.CCIOC |= STAG;      /* Если не установлен этот бит,значение пределителя увеличится в 8 раз */
   CCU1.CCIOC &= ~ PDS;
           
   CCU1.T0IC  &= ~ ICR_IEN;   /* отключаем прерывание при переполнении таймера T0 */ 
   CCU1.CC6IC &= ~ ICR_IEN;    /* отключаем прерывание при совпадении */
   
   CCU1.T01CON  &= ~ T0I;  /* пределитель 1, входная частота для таймера 26 Мгц */
   CCU1.T01CON  &= ~ T0M;  /* режим таймера */
   CCU1.T01CON  |= T0R;    /* cтарт таймера */ 
   enable_interrupts(saved);
}


void test_100kHz()
{
   GPIO.DSPOUT0 = GPIO_PPEN | 0x30; // Открытый коллектор, ассоциация с CAPCOM
   int saved = disable_interrupts();   
//CCU1.T0 = 0x10000 - (Period(ns) / 39.0625)
   CCU1.CLC = 0x100;
   CCU1.T0REL = 0xFF00;  //Разрешение таймера при делителе частоты 1(26 Mhz) будет 39.0625 ns, P = 39.0625  * 256 = 1/100000
   CCU1.T0 = 0xFF00; 
   CCU1.CC6 = 0xFF80;
   
   CCU1.CCSEM &= ~ CCSEM6;    //отключаем режим одного события
   CCU1.CCSEE &= ~ CCSEE6;     
   CCU1.CCM1  |=  CCM1_MOD6 & (MODE_COMPARE_3 << 8); /* Режим сравнения 3: Выходной контакт устанавливается на каждое совпадение.При переполнение таймера выходной контакт сбрасывается.Только одно прерывание за период таймера */
   CCU1.CCM1  &= ~ CCM1_ACC6;  /* Обнуляем бит,регистр захвата/сравнения CC6 будет привязан к таймеру T0 */
   
   CCU1.CCIOC &= ~ PL;
   CCU1.CCIOC |= STAG;      /* Если не установлен этот бит,значение пределителя увеличится в 8 раз */
   CCU1.CCIOC &= ~ PDS;
           
   CCU1.T0IC  &= ~ ICR_IEN;  /* отключаем прерывание при переполнении таймера T0 */ 
   CCU1.CC6IC &= ~ ICR_IEN;  /* отключаем прерывание при совпадении значения регистра CC6 со значением таймера T0*/
   
   CCU1.T01CON  &= ~ T0I;  /* пределитель 1, входная частота для таймера 26 Мгц */
   CCU1.T01CON  &= ~ T0M;  /* режим таймера */
   CCU1.T01CON  |= T0R;    /* cтарт таймера */ 
   enable_interrupts(saved);
}

void test_1Gz()
{ 
   GPIO.DSPOUT0 = 0x30; // pin 6
   int input_clk = divide(Prescaler, capcom_hw_clk );  

   CCU0.CLC = 0x100;
   CCU0.T0 =  0x3C00;
   CCU0.T0REL = 0x3C00;
   CCU0.CC2 = 0x9E00;
   
   CCU0.CCSEM &= ~ CCSEM2;    //отключаем режим одного события
   CCU0.CCSEE &= ~ CCSEE2;     
   CCU0.CCM0  |=   CCM0_MOD2 & (MODE_COMPARE_3 << 8); ; /* Режим сравнения 3: Выходной контакт устанавливается на каждое совпадение.При переполнение таймера выходной контакт сбрасывается.Только одно прерывание за период таймера */
   CCU0.CCM0  &= ~ CCM0_ACC2;  /* Обнуляем  бит,регистр захвата/сравнения CC2 будет привязан к таймеру T0 */
   
   CCU0.CCIOC |= STAG;    /* Если не установлен этот бит,значение пределителя увеличится в 8 раз.Отключаем.. */
           
   CCU0.T0IC  &= ~ ICR_IEN;  /* отключаем прерывание при переполнении таймера T0 */ 
   CCU0.CC2IC &= ~ ICR_IEN;  /* отключаем прерывание при совпадении */
   
   CCU0.T01CON  |= 6;  /* пределитель 1, входная частота для таймера 26 Мгц */
   CCU0.T01CON  &= ~ T0M;  /* режим таймера */
   CCU0.T01CON  |= T0R;   /* cтарт таймера */  
}


void test_pin_cts()//sgold
{
   GPIO.USART0_CTS = GPIO_PPEN | 0x30; // Открытый коллектор(open drain), ассоциация с CAPCOM 
   //CCU1.T0 = 0x10000 - (Period(ns) / 39.0625)
   CCU1.CLC = 0x100;
   CCU1.T0REL = 0xFF00;  //Разрешение таймера при делителе частоты 1(26 Mhz) будет 39.0625 ns, P = 39.0625  * 256 = 1/100000
   CCU1.T0 = 0xFF00; 
   CCU1.CC2 = 0xFF80;
   
   CCU1.CCSEM &= ~ CCSEM2;    //отключаем режим одного события
   CCU1.CCSEE &= ~ CCSEE2;     
   CCU1.CCM0 |=  CCM0_MOD2 & (MODE_COMPARE_3 << 8); /* Режим сравнения 3: Выходной контакт устанавливается на каждое совпадение.При переполнение таймера выходной контакт сбрасывается.Только одно прерывание за период таймера */
   CCU1.CCM0 &= ~ CCM0_ACC2;  /* Обнуляем бит,регистр захвата/сравнения CC6 будет привязан к таймеру T0 */
   
   CCU1.CCIOC &= ~ PL;
   CCU1.CCIOC |= STAG;      /* Если не установлен этот бит,значение пределителя увеличится в 8 раз */
   CCU1.CCIOC &= ~ PDS;
           
   CCU1.T0IC  &= ~ ICR_IEN;  /* отключаем прерывание при переполнении таймера T0 */ 
   CCU1.CC2IC &= ~ ICR_IEN;  /* отключаем прерывание при совпадении значения регистра CC2 со значением таймера T0*/
   
   CCU1.T01CON &= ~ T0I;  /* пределитель 1, входная частота для таймера 26 Мгц */
   CCU1.T01CON &= ~ T0M;  /* режим таймера */
   CCU1.T01CON |= T0R;    /* cтарт таймера */
}

void test_pin_tx()
{
   GPIO.USART0_TXD = GPIO_PPEN | 0x30; // Открытый коллектор(open drain), ассоциация с CAPCOM 
   //CCU1.T0 = 0x10000 - (Period(ns) / 39.0625)
   CCU0.CLC = 0x100;
   CCU0.T0REL = 0xFF00;  //Разрешение таймера при делителе частоты 1(26 Mhz) будет 39.0625 ns, P = 39.0625  * 256 = 1/100000
   CCU0.T0 = 0xFF00; 
   CCU0.CC2 = 0xFF80;
   
   CCU0.CCSEM &= ~ CCSEM2;    //отключаем режим одного события
   CCU0.CCSEE &= ~ CCSEE2;     
   CCU0.CCM0 |=  CCM0_MOD2 & (MODE_COMPARE_3 << 8); /* Режим сравнения 3: Выходной контакт устанавливается на каждое совпадение.При переполнение таймера выходной контакт сбрасывается.Только одно прерывание за период таймера */
   CCU0.CCM0 &= ~ CCM0_ACC2;  /* Обнуляем бит,регистр захвата/сравнения CC2 будет привязан к таймеру T0 */
   
   CCU0.CCIOC &= ~ PL;
   CCU0.CCIOC |= STAG;      /* Если не установлен этот бит,значение пределителя увеличится в 8 раз */
   CCU0.CCIOC &= ~ PDS;
           
   CCU0.T0IC  &= ~ ICR_IEN;  /* отключаем прерывание при переполнении таймера T0 */ 
   CCU0.CC2IC &= ~ ICR_IEN;  /* отключаем прерывание при совпадении значения регистра CC2 со значением таймера T0*/
   
   CCU0.T01CON &= ~ T0I;  /* пределитель 1, входная частота для таймера 26 Мгц */
   CCU0.T01CON &= ~ T0M;  /* режим таймера */
   CCU0.T01CON |= T0R;    /* cтарт таймера */
}

int main(void)
{   
   ShowMSG(1,(int)"ELF Started!" );
   ClkStateOn(CAPCOM_MASK);
   test_pin_tx();

   SUBPROC((void *)ElfKiller);
   return 0;
}

