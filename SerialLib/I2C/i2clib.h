#ifndef I2CLIB_H_
#define I2CLIB_H_

int i2c_write_arduino(uint8_t addr, uint8_t data);

int i2c_write_pmu(int reg, char data);
int i2c_read_pmu(int reg, char *data);

int i2c_write_cam(int reg, char data);
int i2c_read_cam(int reg, char *data);

int i2c_write_fm(unsigned  char *data, int size);
int i2c_read_fm(unsigned  char *data, int size);

#endif /*I2CLIB_H_*/
