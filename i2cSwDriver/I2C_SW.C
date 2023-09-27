#ifdef NEWSGOLD
#include "..\inc\reg8876.h"
#else
#include "..\inc\reg8875.h"
#endif

#define SDA   GPIO.USART0_RTS
#define SCL   GPIO.USART0_CTS

void Delay(unsigned int count);
unsigned Check_SCL();
unsigned I2cInit();
void I2cStart();
unsigned I2cMasterWrite(unsigned char input_byte);
unsigned I2cMasterRead(unsigned char ack);
unsigned I2cStop();

#define period 10000		/* 10 ms time out for bus faulty */

unsigned int time_out;


/******************************************************************************/
/*      Subroutine:	Delay	  					      */
/*                                                                            */
/*      Description:    Формирует программную задержку.В качестве счетчика    */
/*                      использует системный таймер.Оригинальный код привиден */
/*                      в delay.asm.Желательно чтобы код функции распологался */
/*                      в быстрой памяти.Адрес оригинальной функции можно     */
/*                      найти по паттерну в INTRAM2.                          */
/*			                                                      */     															
/*      Input:	        Время в микросекундах	   		              */
/*                                                                            */
/*      Return:		Нет						      */
/*                                                                            */
/******************************************************************************/

extern void Delay(unsigned us);

/******************************************************************************/
/*	Subroutine:	Check_SCL 				    	      */
/*			                             			      */
/*	Description:	Send HIGH and read the SCL line. It will wait until   */
/* 			the line has been released from slave device with the */
/* 			time out of 10 ms.				      */	
/*                                                                            */
/*      Input:	    	None						      */
/*                       	                                              */
/*      Return:		"0" - SCL line is OK			       	      */
/*			"1" - SCL line is faulty			      */
/*                                                                            */
/******************************************************************************/

unsigned int Check_SCL()
{

	time_out = period;
        unsigned t0;
        unsigned endTime;
        
        SCL |= GPIO_ENAQ;
 	SCL = 0x1100;      		/* configure SCL as an input */ 
        
        t0 = STM_TIM0;
        endTime = t0 + time_out;
        
        while(endTime > STM_TIM0)
	{
 	   if ((SCL & GPIO_DAT) >> 9)  /* wait if SCL is pulled down to LOW by slave device */
	   {
              SCL |= GPIO_ENAQ;
              SCL = 0x1700;          /* set clock to high */
 	      return (0);
	   }
       	}

	return (1);   		/* ERROR: SCL line is stuck to low */

}


/******************************************************************************/
/*	Subroutine:	I2cInit 				    	      */
/*			                             			      */
/*	Description:	Initialize the I2C bus 			              */	
/*                                                                            */
/*      Input:	    	None						      */
/*                       	                                              */
/*      Return:		"0" - bus line is OK   			       	      */
/*			"1" - bus line is faulty			      */
/*                                                                            */
/******************************************************************************/

unsigned int I2cInit()
{//Отключаем прерывания на выводах через CAPCOM интерфейс.
#ifdef NEWSGOLD
  CCU0.CLC = 0x100; CCU0.CC6IC &= ~ICR_IEN; //CTS
  CCU1.CLC = 0x100; CCU1.CC2IC &= ~ICR_IEN; //RTS
#else
  CCU1.CLC = 0x100; CCU1.CC2IC &= ~ICR_IEN; //CTS
  CCU0.CLC = 0x100; CCU0.CC6IC &= ~ICR_IEN; //RTS  
#endif
  //Проверить бы еще и GPTU на наличие привязок к ножкам..
  
        SDA |= GPIO_ENAQ;
	SDA = 0x1100;    		/* configure SDA and SCL as an input */
        
        SCL |= GPIO_ENAQ;
	SCL = 0x1100;

	if (!((SDA & GPIO_DAT) >> 9))  /* if lines are low, set them to high */
	  if (I2cStop())
		return (1);

    	if (!(SCL & GPIO_DAT) >> 9) 
	  if (I2cStop())
		return (1);
	
	return (0);

}
		
/******************************************************************************/
/*	Subroutine:	I2cStart     					      */
/*			                              			      */
/*	Description:	Generate a START condition on I2C bus		      */	
/*                                                                            */
/*      Input:	    	None						      */
/*                                                                            */
/*      Return:		None						      */
/*                                                                            */
/******************************************************************************/

void I2cStart()
{
        SDA |= GPIO_ENAQ;
	SDA = 0x1700;        /* to make sure the SDA and SCL are both high */
        
        SCL |= GPIO_ENAQ;
	SCL = 0x1700;
	
        Delay(6);
        
        SDA |= GPIO_ENAQ;
	SDA = 0x1500;        /* SDA line go LOW first */
        
	Delay(6);
        
        SCL |= GPIO_ENAQ;
	SCL = 0x1500;        /* then followed by SCL line with time delay */        
}


/******************************************************************************/
/*	Subroutine:	I2cMasterWrite			 		      */
/*			                                 		      */
/*	Description:	Output one byte of data to slave device. Check for    */
/* 			WAIT condition before every bit is sent.	      */ 
/*                                                                            */
/*      Input:	    	one byte of data to be sent to slave device.	      */
/*                                                                            */
/*      Return:		acknowledgement from slave:         		      */
/*		        0 = acknowledge is received			      */
/*	       	 	1 = no acknowledge is received			      */                       
/*                                                                    	      */
/******************************************************************************/

unsigned int I2cMasterWrite(unsigned char input_byte)
{
	unsigned int mask,i;

        mask = 0x80;       
        
	for (i=0; i<8; i++)		/* send one byte of data */
	{          
    	   if (mask & input_byte) 	/* send bit according to data */
           {
             SDA |= GPIO_ENAQ;
             SDA = 0x1700;
           }
           else
           {
             SDA |= GPIO_ENAQ;
             SDA = 0x1500;
           }
	
	   mask = mask >> 1;		/* shift right for the next bit */

	   Delay(5);
           
           if(i==0)
           {
             if(Check_SCL())      /* check SCL line */
               return (1);        /* ERROR: SCL line is stuck to low */
           }
           else
           {
             SCL |= GPIO_ENAQ;
             SCL = 0x1700;
           }

           Delay (5);
           
           SCL |= GPIO_ENAQ;
	   SCL = 0x1500;                     /* clock is low */           
        }
        
        SDA |= GPIO_ENAQ;
   	SDA = 0x1100;      		/* configure SDA as an input */
        
      	Delay(5);
        
        SCL |= GPIO_ENAQ;
        SCL = 0x1700;		/* generate 9th clock pulse */
        
        Delay(3);
        
      	mask = (SDA & GPIO_DAT) >> 9;		/* read acknowledge */
	Delay(2);
        
        SCL |= GPIO_ENAQ;
	SCL = 0x1500;                /* clock is low */
	
	Delay(5);		/* to avoid short pulse transition on SDA line */
	
	return (mask);          /* return acknowledge bit */
}	
						     			


/******************************************************************************/
/*	Subroutine:	I2cMasterRead			 		      */
/*			                                 		      */
/*	Description:	Read one byte of data from the slave device. Check    */
/*			for WAIT condition before every bit is received.      */	
/*                                                                            */
/*      Input:	     	Acknowledge require:				      */
/*			0 - generate LOW output after a byte is received      */
/*			1 - generate HIGH output after a byte is received     */
/*                                                                            */
/*      Return:  	received one byte of data from slave device	      */
/*		        						      */                       
/*                                                                    	      */
/******************************************************************************/
				
unsigned int I2cMasterRead(unsigned char ack)
{

	unsigned int mask,i,rec_data;
    

	rec_data = 0;	
	mask = 0x80;       
        
        SDA |= GPIO_ENAQ;
	SDA = 0x1100;			/* configure SDA as an input */  
	
	for (i=0; i<8; i++)
	{
            Delay(5);
            
           if(i==0)
           {
             if(Check_SCL())      /* check SCL line */
               return (1);        /* ERROR: SCL line is stuck to low */
           }
           else
           {
             SCL |= GPIO_ENAQ;
             SCL = 0x1700;
           }

	    Delay(3);

            if ((SDA & GPIO_DAT) >> 9)     /* read data while clock is high */
	    	rec_data |= mask;
            Delay(2);
            
            SCL |= GPIO_ENAQ;
	    SCL = 0x1500;                    /* clock is low */           
	    
            mask = mask >> 1;
        } 

	if (ack)               	/* set SDA data first before port direction */
        {
          SDA |= GPIO_ENAQ;
          SDA = 0x1700;        /* send acknowledge */
        }
        else
        {
          SDA |= GPIO_ENAQ;
          SDA = 0x1500;
        }
       
	Delay(5);
        
        SCL |= GPIO_ENAQ;
 	SCL = 0x1700;    	/* clock is high */

	Delay(5);
        
        SCL |= GPIO_ENAQ;
	SCL = 0x1500;            /* clock is low */
	
	Delay(5);		/* to avoid short pulse transition on SDA line */
	

	return (rec_data);
}	


/******************************************************************************/
/*	Subroutine:	I2cStop				 		      */
/*			                                 		      */
/*	Description:	generate stop condition on the I2C bus	     	      */	
/*                                                                            */
/*      Input:	     	none                                                  */
/*                                                                            */
/*      Return:  	"0" - the bus line is OK		              */
/*		        "1" - the bus line has been pulled down to low for    */                       
/*			more than 10ms					      */
/*                                                                    	      */
/******************************************************************************/
				
unsigned I2cStop()
{
  
	time_out = period;
        unsigned endTime;
        
        SDA |= GPIO_ENAQ;
	SDA = 0x1100;        		/* configure SDA as an input */
        
        endTime = STM_TIM0 + time_out;
        
        while(endTime > STM_TIM0)
	{
	   if (!((SDA & GPIO_DAT) >> 9))    /* check SDA line */
	   {    
                SCL |= GPIO_ENAQ;
	       	SCL = 0x1700;                /* generate a clock pulse if SDA is pull */
                
		Delay(6);		/* down to low */
                
                SCL |= GPIO_ENAQ;
	    	SCL = 0x1500;
                
	    	Delay(6);
	   }
	   else                 	/* check SCL line */
           {
                SDA |= GPIO_ENAQ;
	       	SDA  = 0x1500;
                
                Delay(6);

        	if (Check_SCL())     	/* to generate STOP condition */
	   	   return (1);     	/* ERROR: SCL line is stuck to low */

       	   	Delay(6);
                
		SDA |= GPIO_ENAQ;
		SDA = 0x1700;
                
		return (0);
	  }
        }

        return (1);   	       		/* ERROR: SDA line is stuck to low */

}



    	







































































		 
