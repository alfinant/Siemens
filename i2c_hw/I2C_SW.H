/******************************************************************************/
/* The include file name: I2C_SW.H				 	      */
/*			                                 		      */
/* This include file is the function declaration of I2C_SW.C standard module. */	
/* It must be included in any application that make use of the I2C standard   */
/* module.                                      			      */
/*                                                                            */                    
/*                                                                    	      */
/******************************************************************************/
	
extern void Delay(unsigned int count);
extern unsigned char I2cInit();
extern void I2cDeInit();
extern void I2cStart();
extern void I2cMasterWrite(unsigned char input_byte);
extern void I2cMasterRead(unsigned char ack);
extern unsigned char I2cStop();

extern unsigned char rec_data;
extern int COM_ON,RecAck;

