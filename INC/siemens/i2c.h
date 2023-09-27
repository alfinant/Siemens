#ifndef I2C_H_
#define I2C_H_

#ifdef ELKA
#define  FMRADIO 0x10  /* TEA5761UK */	
#define  CAMERA  0xB0  /* OmniVision */
#endif
#define  PMU     0x31  /* Mozart/Dialog/Twigo */

#define  PMU_REG_POWER        0x10    /* 0x20-default, 0x28-high   */
#define  PMU_REG_DISPLAYLIGHT 0x12
#define  PMU_REG_KEYPADLIGHT  0x13

typedef struct {
   char  addr;  // прим. адреса начиная с 0x80 будут переключены на альтернативный порт
   char  mode;// 0-nRegister учитывается, 2-nRegister не учитывается, 4-nRegister учитывается
#ifdef NEWSGOLD
   char tf; // тип функции(передача,прием,передача одного байта),устаналивается функцией
   char unk;
   short nRegister; //sub address
#else
   short nRegister;
   char  unk; 
   char  tf;
#endif
   short cdata; 
   void (*callback)(void *i2c_msg, int err); // 
   char *data; 
   int size;
}I2C_MSG; 

#pragma swi_number=0x2EC
__swi __arm int i2c_transfer(I2C_MSG *msg); // возвращает 1 если удалось отправить сообщение I2C_TASK, 0-извините
#pragma swi_number=0x2ED
__swi __arm int i2c_receive(I2C_MSG *msg);

int i2cw_byte_pmu(short reg, char *val, void (*callback)(void *i2c_msg, int err), short cdata);
//int i2cw_pmu(short reg, char *val, void (*callback)(void *i2c_msg, int err), short cdata);
int i2cr_byte_pmu(short reg, char *val, void (*callback)(void *i2c_msg, int err), short cdata);
int i2cr_pmu(short reg, char *buf, void (*callback)(void *i2c_msg, int err), short cdata, int len);
int i2cw_cam(short reg, char *val, void (*callback)(void *i2c_msg, int err));
int i2cr_cam(short reg, char *val, void (*callback)(void *i2c_msg, int err));
int i2cw_string(char addr, char * str);

#endif /* I2C_H_ */
