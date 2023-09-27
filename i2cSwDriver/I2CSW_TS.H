
unsigned int I2cInit();
unsigned int i2cWrite(unsigned char address, signed char sub_addr, char *buffer,unsigned int count);
unsigned int i2cRead(unsigned char address, signed char sub_addr, char *buffer, unsigned int count);
