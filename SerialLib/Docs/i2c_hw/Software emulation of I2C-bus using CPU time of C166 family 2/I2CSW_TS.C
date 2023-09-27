/******************************************************************************/
/*                                                      		      */
/*                      SIEMENS standard Software                    	      */
/*                                                                     	      */
/*                      Unauthorized copying prohibited               	      */
/*                                                                            */
/*============================================================================*/
/*      	Programmer: 	Tan Choon Hock                                */
/*      	Department: 	Siemens SCPL HLM                              */
/*      	Revision  : 	1.0 					      */
/*			                                                      */
/*============================================================================*/
/*  	Description: 	This program is just for testing only. The purpose    */
/* 			of this program is to make use of the standard I2C    */
/*			protocol module (I2C_SW.C) to control the nonvolatile */
/*			memory(E2PROM).             			      */
/*      	       							      */
/*                      This program writes 10 bytes of data into E2PROM      */
/*			in sequence and the data is retrieved from the array  */
/*                      location of "raw_data". Then read back 10 bytes of    */
/*			data from the E2PROM at the same location which have  */
/*			been programmed and store it in the array location of */
/*			"stored_data".					      */
/*                                                                            */
/*                                                                            */
/*============================================================================*/
/*      History:          						      */
/*			02/10/96: Start of the program   		      */
/*            								      */
/*									      */
/******************************************************************************/   

#include <reg165.h>
#include "i2c_sw.h"


#define device_addr 0xA0     	/* device address = A0 */

#define number_byte 10


unsigned char idata stored_data[10];

static const unsigned char raw_data[10] = {0x11,0x22,0x33,0x44,0x55,0x66,0x77,
					   0x88,0x99,0x00};



/******************************************************************************/
/*	Subroutine:	CheckWrite			 		      */
/*			                                 		      */
/*	Description:	Check for the completion of programming after the     */
/*			memory write. If the programming is completed, the    */
/* 			acknowledge bit will be "0".			      */	
/*                                                                            */
/*      Input:	     	none                                                  */
/*                                                                            */
/*      Return:  	"0" - the programming is finished                     */
/*		        "1" - the programming is not finished  		      */                       
/*                                                                    	      */
/******************************************************************************/
				
unsigned char CheckWrite()
{

	I2cStart();
        return (I2cMasterWrite(device_addr+1));
                          /* send read address and read the acknowledge bit */
} 



/******************************************************************************/
/*	Subroutine:	WriteE2prom			 		      */
/*			                                 		      */
/*	Description:	Write number of data bytes to E2PROM		      */	
/*									      */
/*			Data format for writing into memory:		      */
/*      		|ST|  CS/E  |As|  WA  |As|  DE  |As|SP|		      */
/*									      */
/*			ST=START, CS/E=device write address,                  */
/*			As=acknowledge from slave, WA=memory word 	      */
/*			address/sub-address, DE=data to be sent, SP=stop      */ 	
/*                                                                            */
/*      Input:	     	(address) = slave device address.		      */
/*			(sub_addr) = sub-address/word address, if no          */
/*				     sub-address, the value is -1. 	      */
/*			(*buffer) = location of data to be sent.	      */
/*			(count) = number of byte to be sent.		      */
/*                                                                            */
/*      Return:  	"0" - the programming is OK		              */
/*		        "1" - the data transfer has no acknowledge from slave */                       
/*                                                                    	      */
/******************************************************************************/
				

unsigned char WriteE2prom(unsigned char address,signed int sub_addr,
			  unsigned char *buffer,unsigned char count)

{

	unsigned char i;

	I2cStart();                   		/* START condition */

        if (I2cMasterWrite(address))         	/* device write address */
	{
	   I2cStop();
	   return(1);	
        }
                                               	/* check for any sub-address */
        if (sub_addr != -1)
	{
           if (I2cMasterWrite(sub_addr))        /* memory word address */	
       	   {
	      I2cStop();
	      return(1);
	   }
        }

	for (i=0; i < count; i++)		/* byte of data to be sent */
	{
	   if (I2cMasterWrite(*buffer))           
	   {
	      I2cStop();
	      return(1);
	   }
	}

	I2cStop();                             	/* STOP condition */
	return(0);
}		
 


/******************************************************************************/
/*	Subroutine:	ReadE2prom			      		      */
/*			                                 		      */	
/*	Description:	Read number of data bytes from E2PROM	     	      */	
/*                                                                            */
/*      Input:	     	(address) = slave device address.		      */
/*			(sub_addr) = sub-address/word address, if no          */
/*				     sub-address, the value is -1. 	      */
/*			(*buffer) = location of data to be stored.	      */
/*			(count) = number of byte to be received.	      */
/*									      */
/*			Data format for reading from the memory:	      */
/*      		|ST| CS/E |As| WA |As|ST| CS/A |As| DA |Am| DA |Am|SP|*/
/*									      */
/*			ST=START, CS/E=device address with write,             */
/*			As=acknowledge from slave, WA=memory word             */
/*			address/sub-address, CS/A=device read address,        */
/*			Am=aknowledge from master, DA=data to be read, SP=stop*/
/*                                                                            */                                                                         
/*      Return:  	"0" - the reading of data is OK		              */
/*		        "1" - the data transfer has no acknowledge from slave */                       
/*                                                                    	      */
/******************************************************************************/

				
unsigned char ReadE2prom(unsigned char address,signed int sub_addr,
			 unsigned char *buffer,unsigned char count)

{

	unsigned char i;


 	I2cStart();           	 		/* START condition */

	if (I2cMasterWrite(address)) 	/* device write address */
        {
	   I2cStop();
	   return(1);
	}

	if (sub_addr != -1)             /* check for any sub-address/word address */
	{
	   if (I2cMasterWrite(sub_addr))	
           {                            /* memory word address */
	      I2cStop();
	      return(1);
	   }
        }

	I2cStart();                     /* START condition */
                                           	
	if (I2cMasterWrite(address+1))  /* device read address */
        {                                       
	   I2cStop();
	   return(1);
	}
	
	for (i=0; i<count-1; i++)    	/* number of bytes to be read */
	{
    	   *buffer = I2cMasterRead(0);
	   buffer++;
	}
		
        *buffer = I2cMasterRead(1);     /* last byte read with "HIGH" acknowlege */
				 		
	I2cStop();                      /* STOP condition */
        return(0);

}



void main(void)
{

	unsigned char i,j,error,word_addr; 
	unsigned int expire;


	I2cInit();

	word_addr = 0;

        ReadE2prom(device_addr,word_addr,stored_data,1);   /* initialization */


	for (i=0; i<number_byte; i++)   /* write 10 bytes of data */
	{
	   for (j=0; j<3; j++)          /* jump out of loop after 3 trials 
					   of writing the E2PROM unsuccessfully */
	   {
		if (!WriteE2prom(device_addr,word_addr,&raw_data[i],1))
                break;
	   }	
        
           word_addr++;

	   if (j == 3)
	   {
	      error = 1;		/* error occur */
	      break;                  	/* break out of (FOR..) loop  */
	   }
		
	   expire = 50000;		/* 20ms time-out for writing the E2PROM */
   
	   while (expire--)
	   {
	      if (!CheckWrite())    	/* check for end of programming to E2PROM */
	      break;
	   }

/* if expire = 0, the E2PROM location is faulty */


	   I2cStop();

/* alternatively, complete the read cycle after received the acknowledge bit = 0, or 
   the I2cStop() will generate extra clock pulses to overcome the missing read cycle */
		  		  
        }
                                                
        word_addr = 0;

	for (i=0; i<3; i++)
        {
	    if (!ReadE2prom(device_addr,word_addr,stored_data,number_byte))
					/* read 10 bytes of data from E2PROM */   	    
            break;
        }

	if (i == 3)
	   error = 1;

	while (1);
 

}


		



		
