#ifndef _I2C_SGOLD2_H_
#define _I2C_SGOLD2_H_

int i2c_send(char adr,char reg,char data);

int i2c_read(char adr,char reg,char * data);

#endif
