#ifdef NEWSGOLD
#include "..\inc\reg8876.h"
#else
#include "..\inc\reg8875.h"
#endif

#include "..\inc\clkman.h"
#include "..\inc\interrupt.h"

#define SDA   GPIO.USART0_RTS
#define SCL   GPIO.USART0_CTS

#define period 10000		/* 10 ms time out for bus faulty */

void int_timer1_handler(int irq);

unsigned char I2cStop();

unsigned int time_out;

unsigned char rec_data;

int TX_RX,Ackge,COM_ON,RecAck,temp_SDA;

unsigned char bit_count,input_data,mask;

IRQ_DESC irq_old;

IRQ_DESC irq_ccu_t1=
{
  2,
  0x0F,
  0,
  0,
  int_timer1_handler,
};

/******************************************************************************/
/*      Subroutine:	Delay	  					      */
/*                                                                            */
/*      Description:    This routine creates a time delay.                    */
/*			                                                      */     															
/*      Input:	        Time in microseconds	   		              */
/*                                                                            */
/*      Return:		None						      */
/*                                                                            */
/******************************************************************************/

void Delay(unsigned us)
{
  unsigned endTime = STM_TIM0 + us;
  while(endTime > STM_TIM0);
}

/******************************************************************************/
/*	Subroutine:	Check_SCL 				    	      */
/*			                             			      */
/*	Description:	Send HIGH and read the SCL line. It will wait until   */
/* 			the line has been released from slave device with the */
/* 			time-out of 10 ms.				      */	
/*                                                                            */
/*      Input:	    	None						      */
/*                       	                                              */
/*      Return:		"0" - SCL line is OK			       	      */
/*			"1" - SCL line is faulty			      */
/*                                                                            */
/******************************************************************************/
unsigned char Check_SCL()
{
  unsigned endTime;
  time_out = period;
  
  SCL = 0x1100;     /* Настраиваем SCL на вход*/
  
  endTime = STM_TIM0 + time_out;
  while(endTime > STM_TIM0)
  {
    if((SCL & GPIO_DAT) >> 9) /* Ждем пока slave закончит свои дела и отпустит линию */
    {
      SCL = 0x1700;  
      return (0);
    }
  }
  return (1);
}

void I2cDeInit()
{
  IRQ_DESC temp_irq_old;
  
 // ClkStateOff(CAPCOM_MASK);
  
#ifdef NEWSGOLD
  Register_LISR(CCU0_T1_IRQn, &irq_old, &temp_irq_old);
#else
  Register_LISR(CCU1_T1_IRQn, &irq_old, &temp_irq_old)
#endif  
}


unsigned char I2cInit()
{
  ClkStateOn(CAPCOM_MASK);
  
#ifdef NEWSGOLD
  CCU0.CLC = 0x100; CCU0.CC6IC &= ~ICR_IEN; //CTS
  CCU1.CLC = 0x100; CCU1.CC2IC &= ~ICR_IEN; //RTS
  CCU0.T1REL = 0xFF00;
  CCU0.T1 = 0xFFF0; //Разрешение таймера при делителе частоты 1(26 Mhz) будет 39.0625 ns, P = 39.0625  * 256 = 1/100000
  CCU0.CC6 = 0xFF80;
  CCU0.CCSEM &= ~ CCSEM6;  /* Отключаем режим одного события */
  CCU0.CCSEE &= ~ CCSEE6;
  CCU0.CCM1 |= CCM1_MOD6 & (MODE_COMPARE_3 << 8); /* Режим сравнения 3:Выходной контакт устанавливается на каждое совпадение.При переполнение таймера выходной контакт сбрасывается.Только одно прерывание за период таймера */
  CCU0.CCM1 |= CCM1_ACC6;  /* регистр захвата/сравнения CC6 будет привязан к таймеру T1 */ 
  CCU0.CCIOC &= ~ PL;
  CCU0.CCIOC |= STAG;      /* Если не установлен этот бит, значение пределителя увеличится в 8 раз */
  CCU0.CCIOC &= ~ PDS;
  CCU0.T01CON &= ~ T1I;    /* пределитель 1, входная частота для таймера 26 Мгц */
  CCU0.T01CON &= ~ T1M;    /* режим таймера */
  CCU0.T1IC |= ICR_CLRFL;       /* Сбрасываем флаг прерывания таймера T1 */
  CCU0.T1IC |= ICR_IEN;         /* Разрешаем прерывания для таймера T1*/
  Register_LISR(CCU0_T1_IRQn, &irq_ccu_t1, &irq_old);
#else
  CCU1.CLC = 0x100; CCU1.CC2IC &= ~ICR_IEN; //CTS
  CCU0.CLC = 0x100; CCU0.CC6IC &= ~ICR_IEN; //RTS
  CCU1.T1REL = 0xFF00;
  CCU1.T1 = 0xFF80;
  CCU1.CC2 = 0xFF80;
  CCU1.CCSEM &= ~ CCSEM2;
  CCU1.CCSEE &= ~ CCSEE2;
  CCU1.CCM0 |= CCM0_MOD2 & (MODE_COMPARE_3 << 8);
  CCU1.CCM0 |= CCM0_ACC2;
  CCU1.CCIOC &= ~ PL;
  CCU1.CCIOC |= STAG;
  CCU1.CCIOC &= ~ PDS;
  CCU1.T1IC &= ~ ICR_IEN;
  CCU1.T01CON &= ~ T1I;
  CCU1.T01CON &= ~ T1M;
  Register_LISR(CCU1_T1_IRQn, &irq_ccu_t1, &irq_old)
#endif
      
  SCL |= GPIO_ENAQ;
  SCL = 0x1100;     /* Настраиваем SCL на вход, открытый сток */
        
  SDA |= GPIO_ENAQ;
  SDA = 0x1100;     /* Настраиваем SDA на вход, открытый сток */
  
  if (!(SDA & GPIO_DAT) >> 9)   /* Если линия SDA прижата */
    if (I2cStop())
      return (1);
  
  if (!(SCL & GPIO_DAT) >> 9)  /* Если линия SCL прижата */
    if (I2cStop())
      return (1);
  
  return (0);
}
	 	
/******************************************************************************/
/*	Subroutine:	I2cStart     					      */
/*			                              			      */
/*	Description:	Generate a START condition on I2C-bus.		      */	
/*                                                                            */
/*      Input:	    	None						      */
/*                                                                            */
/*      Return:		None						      */
/*                                                                            */
/******************************************************************************/

void I2cStart()
{
  SDA = 0x1700; /* Поднимаем линию SDA */
  SCL = 0x1700; /* Поднимаем линию SCL */
  Delay(5);
  SDA = 0x1500; /* Прижимаем линию SDA */
  Delay(5);
  SCL = 0x1500; /* Прижимаем линию SCL */
}


/******************************************************************************/
/*	Subroutine:	I2cMasterWrite			 		      */
/*			                                 		      */
/*	Description:	Check for any WAIT condition before writing one byte  */
/*			of data to the slave device. Set-up the first bit of  */
/*			data right after the START condition.		      */	
/*                                                                            */
/*      Input:	    	one byte of data to be sent to slave.		      */
/*                                                                            */
/*      Return:		none						      */                       
/*                                                                    	      */
/******************************************************************************/

void I2cMasterWrite(unsigned char input_byte)
{
  input_data = input_byte;      /* to be used in interrupt routine */
  
  COM_ON = 1;			/* communication is on */
  TX_RX = 0;			/* in transmission mode */
  mask = 0x80;			/* to send the MSB bit first */
  bit_count = 0; 		/* counter for clock pulse */
  if (mask & input_data) 	/* send the first bit of data while */
    SDA = 0x1700;               /* the clock is low */
  else SDA = 0x1500;
  
  mask = mask >> 1;		/* shift right for the next bit */
  //Check_SCL();
  
  SCL = 0x1030;                 /* Привязка SCL к интерфейсу CAPCOM */
  
#ifdef NEWSGOLD
  CCU0.T01CON |= T1R;           /* Старт таймера T1 */
#else
  CCU1.T1IC |= ICR_CLRFL;
  CCU1.T1IC |= ICR_IEN;
  CCU1.T01CON |= T1R;
#endif  
}


/******************************************************************************/
/*	Subroutine:	I2cMasterRead			 		      */
/*			                                 		      */
/*	Description:	Check for WAIT condition before reading one byte of   */
/*			data from the slave device.			      */	
/*                                                                            */
/*      Input:	     	Acknowledge require:				      */
/*			0 - generate LOW output by the master after a byte of */
/*			    data is received.      			      */
/*			1 - generate HIGH output by the master after a byte   */
/*			    of data is received.     			      */
/*                                                                            */
/*      Return:  	none						      */
/*		        						      */                       
/*                                                                    	      */
/******************************************************************************/
				
void I2cMasterRead(unsigned char ack)
{

        Ackge = ack;                    /* to be used in interrupt routine */
	rec_data = 0;
	COM_ON = 1;			/* communication is on */
	TX_RX = 1;			/* in reception mode */
	mask = 0x80;
	SDA = 0x1100;			/* configure SDA as an input */  
	bit_count = 0; 			/* counter for clock pulses */

	Check_SCL();                    /* check for any WAIT condition before 
					   receiving one byte of data */ 

        //T2IE = 1;			/* interrupt enable for T2  */
	//T3R = 1;			/* timer starts running */
}


  


/******************************************************************************/
/*	Функция:	I2cStop				 		      */
/*			                                 		      */
/*	Описание:	генерирует условие STOP на i2c шине.В дополнении,     */
/*                      генерирует тактовые импульсы до тех пор,пока линия    */
/*                      освобождается ведомым устройством.Время ожидания      */
/*			высокого уровня на линии состовляет 10 миллисекунд.   */
/*                                                                            */
/*      Параметры:	нет                                                   */
/*                                                                            */
/*      Возвращает:  	"0" - все OK		                              */
/*		        "1" - линия удерживалась более 10 миллисекунд         */                       
/*							                      */
/*                                                                    	      */
/******************************************************************************/
				
unsigned char I2cStop()
{ 
  unsigned endTime;
  time_out = period;
  
  SDA = 0x1100;     /* SDA настроен как вход */
  
  endTime = STM_TIM0 + time_out;
  while(endTime > STM_TIM0) 
  {
    if ((SDA & GPIO_DAT) >> 9) /* Ждем когда slave отпустит линию SDA после ответа(ASK) */
    {
      SDA = 0x1500;            /* Прижимаем SDA */
      Delay(5);
      if (Check_SCL())         /* Проверяем отпустил ли slave SCL */
        return (1);            /* ERROR: SCL line is stuck to low */
      
      Delay(10);
      SDA = 0x1700;
      return (0);
    }
  }
  
  return (1);   	       /* ERROR: SDA line is stuck to low */
}

/******************************************************************************/
/*	Subroutine:	Timer 2 interrupt service routine		      */
/*			                                 		      */
/*	Description:	The timer 2 is configured as an reload timer. The     */
/*                      timer 3 is the core timer with 400ns resolution, and  */
/* 		 	is reloaded with the contents of the timer 2 register.*/
/*			The resolution of the timer interrupt is t2 * t3.     */
/* 			(25 * 400ns). Each interrupt will send/receive one    */
/* 			bit of data.					      */
/*	  		         					      */
/******************************************************************************/
    	

void int_timer1_handler(int irq)   
{
#ifdef NEWSGOLD
  CCU0.T1IC |= ICR_CLRFL;       /* Сбрасываем флаг прерывания таймера T1 */
#else
  CCU1.T1IC |= ICR_CLRFL;
#endif  

        if (TX_RX)
	{                              		/* In receiving mode */
           SCL = 1;

	   bit_count++;

	   if (bit_count <= 8)
	   {
              if (SDA)
	         rec_data |= mask;              /* store byte in rec_data while */
	      else                              /* the clock is high */
	      {
		 time_out = period;            	/* for time delay */
		 SCL = 1;
	      }

	      mask = mask >> 1;
	
	      SCL = 0;                          /* set clock to low */

              if (bit_count == 8)
	      {
		 if (Ackge)          		/* set the acknowledge bit */
	            SDA = 0x1700;
	         else SDA = 0x1500;
       	      }
           }
	                    
           else if (bit_count == 9)
	        {                    		/* end of Transmission for 1 byte */
		   if (bit_count == 9) 		/* for time delay purposes only */
		   {
		      SCL = 1;
		      SCL = 1;
		      SCL = 1;
   		     // T2IE = 0;                 /* reset interrupt */
		    //  T3IE = 0;
		    //  T2IR = 0;
		    //  T3R = 0;
		      COM_ON = 0;		/* completed the communication */

		      SCL = 0;
                   }
	        }
	}


/* In transmission mode */
        else 
        {
          bit_count++; 
          if (bit_count <= 8)
          {
            temp_SDA = 0x1500;
            if (mask & input_data)  	/* prepare for the next bit of data */
              temp_SDA = 0x1700;
            mask = mask >> 1;		/* shift right for the next bit */
            
            if (bit_count != 8)
            {
                SDA |= GPIO_ENAQ;
                SDA = temp_SDA;      /* send one bit of data while clock is low */
            }
            else SDA = 0x1100;        /* освобождаем SDA линию после 8 го 
                                                  импульса, ждем потверждение */
          }
          else if (bit_count == 9)
          {
#ifdef NEWSGOLD
            CCU0.T01CON &= ~T1R;           /* Останавливаем таймер T1 */
            CCU0.T1 = 0xFF80;
#else
            CCU1.T01CON &= ~T1R;
            CCU1.T1 = 0xFF80;
#endif
            RecAck = (SDA & GPIO_DAT) >> 9; /* 9 ый импульс, читаем бит потверждения */
            COM_ON = 0;	/* completed communication */
            //SCL = 0x1500;
          }
        }                         	/* end of transmission */
}						     			
















		 
