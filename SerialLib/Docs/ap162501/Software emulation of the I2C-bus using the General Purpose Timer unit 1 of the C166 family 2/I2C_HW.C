/******************************************************************************/
/*                                                      		      */
/*                      SIEMENS Standard Software                     	      */
/*                                                                     	      */
/*                      Unauthorized copying prohibited               	      */
/*                                                                            */
/*============================================================================*/
/*      	Programmer: 	Tan Choon Hock                                */
/*      	Department: 	Siemens SCPL HL RM LAB                        */
/*      	Revision  : 	1.0 					      */
/*			                                                      */
/*============================================================================*/
/*     	Description: 	This module is a standard I2c-bus single master       */
/*     			prococol by using timer interrupt.                    */
/*                                     	                                      */
/*      The clock frequency is approximately 100KHz with 20 MHz CPU clock of  */
/*	C166 family. The clock and as well as transmit/receive data are       */
/*	handled by the timer interrupt.    				      */
/*									      */
/*	Subroutines can be called from main program: I2cInit, I2cStart,       */
/*	I2cMasterWrite, I2cMasterRead, I2cStop.	  		  	      */
/*									      */
/*	Requirement: In application program, the include files called 	      */
/*	I2C_HW.H and I2C.DEF must be attached to the program. In the          */
/* 	I2C.DEF file, the variable SDA and SCL must be declared as any        */
/*	two of the I/O pins. The DSDA and DSCL are the direction of I/O for   */
/*	SDA and SCL respectively.					      */
/*									      */
/*	In case there is a fault on the bus, for instance, the SDA line is    */
/*      shorted to ground or pulled down to LOW by the slave device. This     */
/*      module will generate clock pulses until the line is released and the  */
/*      time-out is 10 ms before returing a "HIGH" value from the I2cInit or  */
/*      I2cStop. For SCL line, it will monitor until the line is released and */
/*      the time-out is 10 ms. The return value of I2cInit or I2cStop will be */
/*      checked in the main program to take an appropriate action.	      */
/*                                                                            */
/*      Input and output parameters of those subroutines:		      */
/*      (1) I2cInit: no input		                                      */
/*	             output = "0" - no error, "1" - error		      */
/* 									      */
/*      (2) I2cStart: no input, no output                                     */
/* 									      */
/*      (3) I2cMasterWrite: input = one byte of data to be sent to slave      */
/*				    device.  				      */
/* 			    no output 		  			      */
/* 									      */
/*	(4) I2cMasterRead: input = "1"/"0" of acknowledge bit to slave device */
/*			   (send on 9th clock pulse of data received)	      */	
/*                         no output 					      */
/*									      */
/*	(5) I2cStop: no input						      */
/* 		     output = "0" - no error, "1" - error		      */
/*									      */
/*============================================================================*/
/*      History:          						      */
/*			9/12/96: Start of the module   		     	      */
/*            								      */
/******************************************************************************/   

#include <reg165.h>
#include "i2c.def"      	/* select ouput port for SCL and SDA */ 
				/*   P3.2 = SCL, P3.3 = SDA */


void Delay(unsigned int count);
unsigned char Check_SCL();
unsigned char I2cInit();
void I2cStart();
void I2cMasterWrite(unsigned char input_byte);
void I2cMasterRead(unsigned char ack);
unsigned char I2cStop();

#define period 20000		/* 10 ms time out for bus faulty */

unsigned int time_out;

unsigned char idata rec_data;

bit TX_RX,Ackge,COM_ON,RecAck,temp_SDA;

unsigned char idata bit_count,input_data,mask;


/******************************************************************************/
/*      Subroutine:	Delay	  					      */
/*                                                                            */
/*      Description:    This routine creates a time delay for clock and data  */
/*			signal. It will loop until the 'count' becomes zero.  */     															
/*                                                                            */
/*      Input:	        1 count = 400ns			   		      */
/*                                                                            */
/*      Return:		None						      */
/*                                                                            */
/******************************************************************************/

void Delay(unsigned int count)
{
	while (count--);
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

	time_out = period;

 	DSCL = 0;      		/* configure SCL as an input */ 

	while (time_out--)	
	{
 	   if (SCL)      	/* wait if SCL is pulled down to LOW by slave device */
	   {
	      SCL = 1;          /* set clock to high */
              DSCL = 1;    	/* configure SCL as an output */ 
 	      return (0);
	   }
       	}

	return (1);   		/* ERROR: SCL line is stuck to low */

}


/******************************************************************************/
/*	Subroutine:	I2cInit 				    	      */
/*			                             			      */
/*	Description:	Set up timer in reload mode which requires two timer; */
/*			T2 as the reload timer, and T3 as the core timer.     */ 	
/* 			Those two timers will act like a reload timer and     */ 
/*			have an resolution of 100 Khz.(1/(400ns * 25)).       */
/* 			Afterthat, check the clock and data lines for any bus */
/* 			faulty like no pull-up resistor on SDA/SCL or         */
/*			pull-down to low by the slave device.		      */
/*                                                                            */
/*      Input:	    	None						      */
/*                       	                                              */
/*      Return:		"0" - bus line is OK   			       	      */
/*			"1" - bus line is faulty			      */
/*                                                                            */
/******************************************************************************/

unsigned char I2cInit()
{
        
	T3CON = 0x0080;		/* Timer mode; resolution=400ns; count down */

	T2CON = 0x0027;		/* Reload mode; input edge selection(T2l) = any 
	 			   transition of output toggle latch T3OTL */

	T2 = 0x0018;		/* reload value for T2 = 24 */

	T3 = 0x0018;		/* initial value for T3 */

	T2IC = 0x0004;		/* Interrupt priority level(ILVL) = 1 (set to
				   the lowest priority). Group level(GLVL) = 0 */

	DSDA = 0;    		/* configure SDA and SCL as an input */
	DSCL = 0;

	if (!SDA)   		/* check the clock and data lines */
	  if (I2cStop())
		return (1);

    	if (!SCL) 
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

	SDA = 1;        /* to make sure the SDA and SCL are both high */
	SCL = 1;

	DSDA = 1;	/* configure SDA and SCL as an output */
	DSCL = 1;

        Delay(5);

	SDA = 0;
	Delay(10);
	SCL = 0;

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

        input_data = input_byte;        /* to be used in interrupt routine */

 	COM_ON = 1;			/* communication is on */
 
        TX_RX = 0;			/* in transmission mode */

        mask = 0x80;			/* to send the MSB bit first */
	DSDA = 1;			/* configure SDA as an output */
	bit_count = 0; 			/* counter for clock pulse */

        if (mask & input_data) 		/* send the first bit of data while */
	   SDA = 1;                     /* the clock is low */
	else SDA = 0;

        mask = mask >> 1;		/* shift right for the next bit */

	Check_SCL();                    /* check for any WAIT condition before 
					   transmitting one byte of data */ 

	T2IE = 1;			/* interrupt enable for T2  */
        T3R = 1;			/* timer starts running */
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
	DSDA = 0;			/* configure SDA as an input */  
	bit_count = 0; 			/* counter for clock pulses */

	Check_SCL();                    /* check for any WAIT condition before 
					   receiving one byte of data */ 

        T2IE = 1;			/* interrupt enable for T2  */
	T3R = 1;			/* timer starts running */
}


  


/******************************************************************************/
/*	Subroutine:	I2cStop				 		      */
/*			                                 		      */
/*	Description:	generate a STOP condition on the I2C bus. In          */
/*                      addition, it will generate clock pulses until the     */
/*                      line is released by the slave device and the time-out */
/*			is 10 ms before returing a "HIGH" value indicating an */
/*			error.						      */
/*                                                                            */
/*      Input:	     	none                                                  */
/*                                                                            */
/*      Return:  	"0" - the bus line is OK		              */
/*		        "1" - the bus line has been pulled down to low for    */                       
/*			more than 10ms					      */
/*                                                                    	      */
/******************************************************************************/
				
unsigned char I2cStop()
{

	time_out = period;

	DSDA =0;        		/* configure SDA as an input */

	while (time_out --)
	{
	   if (!SDA)                   	/* check SDA line */
	   {
	       	SCL = 1;               	/* generate a clock pulse if SDA is pull 
					   down to low */
		Delay(6);
	    	SCL = 0;
	    	Delay(6);
	   }
	   else                 	/* check SCL line */
           {
	       	SDA  = 0;
	     	DSDA = 1;       	/* configure SDA as an output */

        	if (Check_SCL())     	/* to generate STOP condition */
	   	   return (1);     	/* ERROR: SCL line is stuck to low */

                Delay(10);

		SDA = 1;
		return (0);
	  }
        }

        return (1);   	       		/* ERROR: SDA line is stuck to low */

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
    	

void int_timer2_handler(void) interrupt 0x22   
{


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
                 DSDA = 1;			/* configure SDA as an output */

		 if (Ackge)          		/* set the acknowledge bit */
	            SDA = 1;
	         else SDA = 0;
       	      }
           }
	                    
           else if (bit_count == 9)
	        {                    		/* end of Transmission for 1 byte */
		   if (bit_count == 9) 		/* for time delay purposes only */
		   {
		      SCL = 1;
		      SCL = 1;
		      SCL = 1;
   		      T2IE = 0;                 /* reset interrupt */
		      T3IE = 0;
		      T2IR = 0;
		      T3R = 0;
		      COM_ON = 0;		/* completed the communication */

		      SCL = 0;
                   }
	        }
	}


/* In transmission mode */

	else 
        {  
           SCL = 1;

           bit_count++; 

           if (bit_count <= 8)
	   {
	      temp_SDA = 0;

              if (mask & input_data)  	/* prepare for the next bit of data */
	    	 temp_SDA = 1;

              mask = mask >> 1;		/* shift right for the next bit */

	      SCL = 0; 

              if (bit_count != 8)
                 SDA = temp_SDA;        /* send one bit of data while clock is low */
              else DSDA = 0;            /* free SDA line to receive ack bit if it 
					   is at 8th clock pulse */
           }

           else if (bit_count == 9)     	
		{
		   RecAck = SDA;	/* at 9th clock pulse, read acknowledge bit */ 
                      
    		   if (bit_count == 9) 	/* for time delay purposes only */
		   { 
		      SCL = 1;	       	/* end of Transmission for 1 byte */
		      T2IE = 0;
		      T3IE = 0;
		      T2IR = 0;
		      T3R = 0;
		      COM_ON = 0;	/* completed communication */  
		      SCL = 0;
                   }
               }
        }                         	/* end of transmission */

}						     			


	     




































































		 
