/******************************************************************************/
/* The include file name: I2C_SW.H				 	      */
/*			                                 		      */
/* This include file is the function declaration of I2C_SW.C standard module. */	
/* It must be included in any application that make use of the I2C standard   */
/* module.                                      			      */
/*                                                                            */                    
/*                                                                    	      */
/******************************************************************************/
				

void Delay(unsigned int count);
unsigned int I2cInit();
void I2cStart();
unsigned int I2cMasterWrite(unsigned char input_byte);
unsigned int I2cMasterRead(unsigned char ack);
unsigned int I2cStop();

