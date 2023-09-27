#include "I2C_SW.H"

unsigned int i2cWrite(unsigned char address,signed char sub_addr,
			 char *buffer, unsigned int count)
{
	unsigned int i;
        
        I2cInit();          /* лишней иницализацией соединение не испортишь:) */
        
	I2cStart();                            /* START condition */

        if (I2cMasterWrite(address << 1))      /* device write address */
	{
	   I2cStop();
	   return(1);	
        }
                                               /* check for any sub-address */
        if (sub_addr != -1)
	{
           if (I2cMasterWrite(sub_addr))       /* memory word address */	
       	   {
              I2cStop();
	      return(1);
	   }
        }

	for (i=0; i < count; i++)              /* byte of data to be sent */
	{
	   if (I2cMasterWrite(buffer[i]))           
	   {
	      I2cStop();
	      return(1);
	   }
	}

	I2cStop();                 	/* STOP condition */
	return(0);
}

unsigned int i2cRead(unsigned char address,signed char sub_addr,
			 char *buffer,unsigned int count)
{
	unsigned int i;
        
        I2cInit();         

 	I2cStart();         /* START condition */
        
        if(sub_addr != -1)  /* check for any sub-address/word address */
        {
           if (I2cMasterWrite(address << 1))  /* device write address */
           {
              I2cStop();
              return(1);
           }
          
          if (I2cMasterWrite(sub_addr))   /* memory word address */
          {
              I2cStop();
              return(1);
          }
          
          I2cStart();                     /* START condition */
        }
        
        if (I2cMasterWrite((address << 1)+1)) /* device read address */
        {
           I2cStop();
           return(1);
	}
        
        for (i=0; i<count-1; i++)        /* number of bytes to be read */
	{
    	   *buffer = I2cMasterRead(0);
	   buffer++;
	}
		
        *buffer = I2cMasterRead(1);     /* last byte read with "HIGH" acknowlege */
				 		
	I2cStop();                      /* STOP condition */
        return(0);

}
