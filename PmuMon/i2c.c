#include "../inc/swilib.h"
#include "../inc/i2c.h"

/*
void callback(void *i2c_msg, int err)
{
  if(!err)
}
*/

int i2cw_pmu(short reg, char *val, void (*callback)(void *i2c_msg, int err), short cdata )
{ 
  I2C_MSG msg;
  zeromem(&msg, sizeof(I2C_MSG));
  msg.addr = 0x31;
  msg.mode = 0;  // 0-nRegister используется, 2-не используется
  msg.tf = 0;
  msg.unk = 0;
  msg.nRegister = reg;
  msg.cdata = cdata;
  msg.data = val;
  msg.callback = callback;
  msg.size = 1;
  return i2c_transfer(&msg);
}

int i2cr_byte_pmu(short reg, char *val, void (*callback)(void *i2c_msg, int err), short cdata)
{
  I2C_MSG msg;
  zeromem(&msg, sizeof(I2C_MSG));
  msg.addr = 0x31;
  msg.mode = 0;
  msg.tf = 0;
  msg.unk = 0;
  msg.nRegister = reg;
  msg.cdata = cdata;
  msg.data = val;
  msg.callback = callback;
  msg.size = 1;
  return i2c_receive(&msg);
}

int i2cr_pmu(short reg, char *buf, void (*callback)(void *i2c_msg, int err), short cdata, int len)
{
  I2C_MSG msg;
  zeromem(&msg, sizeof(I2C_MSG));
  msg.addr = 0x31;
  msg.mode = 0;
  msg.tf = 0;
  msg.unk = 0;
  msg.nRegister = reg;
  msg.cdata = cdata;
  msg.data = buf;
  msg.callback = callback;
  msg.size = len;
  return i2c_receive(&msg);
}

#ifdef ELKA
int i2cw_cam(short reg, char *val, void (*callback)(void *i2c_msg, int err) )
{
  I2C_MSG msg;
  zeromem(&msg, sizeof(I2C_MSG));
  msg.addr = 0xB0;
  msg.mode = 0;
  msg.tf = 0;
  msg.unk = 0;
  msg.nRegister = reg;
  msg.cdata = 0;
  msg.data = val;
  msg.callback = callback;
  msg.size = 1;
  return i2c_transfer(&msg);
}

int i2cr_cam(short reg, char *val, void (*callback)(void *i2c_msg, int err))
{
  I2C_MSG msg;
  zeromem(&msg, sizeof(I2C_MSG));  
  msg.addr = 0xB0;
  msg.mode = 4;
  msg.tf = 0;
  msg.unk = 0;
  msg.nRegister = reg;
  msg.cdata = 0;
  msg.data = val;
  msg.callback = callback;
  msg.size = 1;
  return i2c_receive(&msg);
}
#endif

//для внешних устройтв
int i2cw_string(char addr, char * str)
{  
  I2C_MSG msg;
  zeromem(&msg, sizeof(I2C_MSG));
  msg.addr = addr;
  msg.mode = 2;
  msg.tf = 0;
  msg.unk = 0;
  msg.nRegister = 0;
  msg.cdata = 0;
  msg.data = str;
  msg.callback = 0; //callback;
  msg.size =strlen(str);
  return i2c_transfer(&msg);
}

