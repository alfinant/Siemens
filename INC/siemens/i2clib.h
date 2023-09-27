#ifndef I2CLIB_H_
#define I2CLIB_H_

int i2cw_pmu(int reg, unsigned char data);
int i2cr_pmu(int reg, unsigned char *data);

int i2cw_cam(int reg, unsigned char data);
int i2cr_cam(int reg, unsigned char *data);

int i2cw_fm(unsigned  char *data, int size);
int i2cr_fm(unsigned  char *data, int size);

#endif /*I2CLIB_H_*/
