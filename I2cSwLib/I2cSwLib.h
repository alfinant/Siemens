
unsigned int I2cSwInit();
unsigned int I2cSwWrite(unsigned char address, signed char sub_addr, char *buffer, int count);
unsigned int I2cSwRead(unsigned char address, signed char sub_addr, char *buffer, int count);
