/******************************************************************************/
/*                                                      		      */
/*                      SIEMENS Standard Software                     	      */
/*                                                                     	      */
/*                      Unauthorized copying prohibited               	      */
/*                                                                            */
/*============================================================================*/
/*      	Programmer: 	Tan Choon Hock                                */
/*      	Department: 	Siemens SCPL HLM                              */
/*      	Revision  : 	1.0 					      */
/*			                                                      */
/*============================================================================*/
/*     	Description: 	This module is a standard I2c bus single master       */
/*     			prococol by using CPU time.    	                      */
/*                                     	                                      */
/*      The clock frequency is approximately 100KHz with 20 MHz CPU clock of  */
/*	C166 family. The timing of the clock pulses are controlled by using   */
/*	the time delay loop.						      */
/*									      */
/*	Subroutines can be called from main program: I2cInit, I2cStart,       */
/*	I2cMasterWrite, I2cMasterRead, I2cStop.	  		  	      */
/*									      */
/*	Requirement: In application program, the include files called 	      */
/*	I2C_SW.H and I2C.DEF must be attached to the program. In the          */
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
/*      checked in the main program to take an approprite action.	      */
/*                                                                            */
/*      Input and output parameters of those subroutines:		      */
/*      (1) I2cInit: no input		                                      */
/*	             output = "0" - no error, "1" - error		      */
/* 									      */
/*      (2) I2cStart: no input, no output                                     */
/* 									      */
/*      (3) I2cMasterWrite: input = one byte of data to be sent to slave      */
/*				    device.				      */
/* 			    output = acknowledge bit.  			      */
/*                          (0 - received, 1 - not received)		      */
/* 									      */
/*	(4) I2cMasterRead: input = "1"/"0" of acknowledge bit to slave device */
/*			   (send on 9th clock pulse of data received)	      */	
/*                         output = A byte of data from slave device.	      */
/*									      */
/*	(5) I2cStop: no input						      */
/* 		     output = "0" - no error, "1" - error		      */
/*									      */
/*============================================================================*/
/*      History:          						      */
/*			01/10/96: Start of the module   		      */
/*            								      */
/******************************************************************************/   

#include <reg165.h>
#include <INTRINS.H>
#include "i2c.def"


void Delay(unsigned int count);
void CheckClock();
unsigned char Check_SCL();
unsigned char I2cInit();
void I2cStart();
unsigned char I2cMasterWrite(unsigned char input_byte);
unsigned char I2cMasterRead(unsigned char ack);
unsigned char I2cStop();

#define period 20000		/* 10 ms time out for bus faulty */

unsigned int time_out;


/******************************************************************************/
/*      Subroutine:	Delay	  					      */
/*                                                                            */
/*      Description:    This routine creates a time delay. It will	      */
/*			loop until the 'count' becomes zero. 		      */     															
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
/*	Subroutine:	CheckClock 				    	      */
/*			                             			      */
/*	Description:	Send HIGH and read the SCL line. It will wait until   */
/* 			the line has been released from slave device for      */
/*			every bit of data to be sent or received.	      */
/*                                                                            */
/*      Input:	    	None						      */
/*                       	                                              */
/*      Return:		None			       	      		      */
/*                                                                            */
/******************************************************************************/

void CheckClock()
{
                                
        DSCL = 0;	       	/* as an input port. */
	
        while (!SCL);           /* check for wait state before sending or */
				/* receiving any data. */
        SCL = 1;

	DSCL = 1; 		/* as an output port. */

}



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
/*	Description:	Initialize the I2C bus 			              */	
/*                                                                            */
/*      Input:	    	None						      */
/*                       	                                              */
/*      Return:		"0" - bus line is OK   			       	      */
/*			"1" - bus line is faulty			      */
/*                                                                            */
/******************************************************************************/

unsigned char I2cInit()
{

	_bfld_(ODP3,0x0088,0x0088);  /* configure P3.3 and P3.7 to open drain output */

	DSDA = 0;    		/* configure SDA and SCL as an input */
	DSCL = 0;

	if (!SDA)   		/* if lines are low, set them to high */
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
/*	Description:	Generate a START condition on I2C bus		      */	
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

	SDA = 0;        /* SDA line go LOW first */
	Delay(10);
	SCL = 0;        /* then followed by SCL line with time delay */

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

unsigned char I2cMasterWrite(unsigned char input_byte)
{
	unsigned char mask,i;

  
        mask = 0x80;                    /* configure SDA as an output */  
	DSDA = 1;

	for (i=0; i<8; i++)		/* send one byte of data */
	{
    	   if (mask & input_byte) 	/* send bit according to data */
	      SDA = 1;
	   else SDA = 0;
	
	   mask = mask >> 1;		/* shift right for the next bit */

	   Delay(0);

	   CheckClock();               	/* check SCL line */

           Delay (1);

	   SCL = 0;                     /* clock is low */
	   SCL = 0;
	   SCL = 0;
        }


   	DSDA = 0;      		/* configure SDA as an input */
      	Delay(3);

        SCL = 1;		/* generate 9th clock pulse */
        Delay (0);
      	mask = SDA;		/* read acknowledge */
	Delay(1);

	SCL = 0;                /* clock is low */
	
	Delay(6);		/* to avoid short pulse transition on SDA line */
	
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
				
unsigned char I2cMasterRead(unsigned char ack)
{

	unsigned char mask,i,rec_data;
    

	rec_data = 0;	
	mask = 0x80;
	DSDA = 0;			/* configure SDA as an input */  
	
	for (i=0; i<8; i++)
	{	   
      	    Delay(2);

            CheckClock();       	/* clock is high */

	    Delay(0);

            if (SDA)                    /* read data while clock is high */
	    	rec_data |= mask;

	    mask = mask >> 1;
       
	    SCL = 0;                    /* clock is low */
                                                                                                  
	} 


	if (ack)               	/* set SDA data first before port direction */	
	   SDA = 1;             /* send acknowledge */
	else SDA = 0;
       
        DSDA = 1;		/* configure SDA as an output */

	Delay(1);

 	SCL = 1;    	  	/* clock is high */

	Delay(4);

	SCL = 0;                /* clock is low */
	
	Delay(6);		/* to avoid short pulse transition on SDA line */
	

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
				
unsigned char I2cStop()
{

	time_out = period;

	DSDA =0;        		/* configure SDA as an input */

	while (time_out --)
	{
	   if (!SDA)                   	/* check SDA line */
	   {
	       	SCL = 1;                /* generate a clock pulse if SDA is pull */
		Delay(6);		/* down to low */
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



    	







































































		 
