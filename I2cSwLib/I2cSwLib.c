#include "..\inc\swilib.h"
#include "..\inc\nu_swilib.h"

NU_QUEUE *I2c_Queue;

typedef struct {
   char  addr;
   char  mode;  // 0-sub_addr используется, 2-не используется
#ifdef NEWSGOLD
   char tf;    // тип функции(1-запись, 2-чтении, 4-запись одного байта(структура I2C_MSG будет другой)
   char unk;
   short sub_addr; //sub address
#else
   short sub_addr;
   char  unk; 
   char  tf;
#endif
   short cdata; 
   void (*callback)(void *i2c_msg, int err);
   char *data; 
   int size;
}I2C_MSG;


unsigned int I2cSwInit()
{
  CHAR queue_name[8];
  VOID *start_address;
  UNSIGNED size;
  UNSIGNED available;
  UNSIGNED messages;
  OPTION message_type;
  UNSIGNED message_size;
  OPTION suspend_type;
  UNSIGNED tasks_suspended;
  NU_TASK *first_task;
 
  NU_QUEUE  *Pointer_Array[20];
  UNSIGNED number;
  
  number = NU_Queue_Pointers(Pointer_Array, 20);
  
  while(--number)
  {
    I2c_Queue = Pointer_Array[number];
    
    NU_Queue_Information(I2c_Queue, queue_name, &start_address, &size, &available,
                                &messages, &message_type, &message_size, &suspend_type, &tasks_suspended, &first_task);
    
    if(strncmp(queue_name, "I2cSwQue", 8) == 0)
      return (0);
  }
 return (1);
}


unsigned int I2cSwWrite(unsigned char address, signed char sub_addr, char *buffer, int count)
{
  I2C_MSG I2c_Msg;
  I2c_Msg.addr = address;
  I2c_Msg.mode = 0;
  I2c_Msg.tf = 1;
  I2c_Msg.unk = 0;
  I2c_Msg.sub_addr = sub_addr;
  I2c_Msg.cdata = 0;
  I2c_Msg.callback = 0;
  I2c_Msg.data = buffer;
  I2c_Msg.size = count;  
  return NU_Send_To_Queue(I2c_Queue, &I2c_Msg, 5, NU_NO_SUSPEND);
}

unsigned I2cSwRead(unsigned char address, signed char sub_addr, char *buffer, int count)
{
  I2C_MSG I2c_Msg;
  I2c_Msg.addr = address;
  I2c_Msg.mode = 0;
  I2c_Msg.tf = 2;
  I2c_Msg.unk = 0;
  I2c_Msg.sub_addr = sub_addr;
  I2c_Msg.cdata = 0;
  I2c_Msg.callback = 0;
  I2c_Msg.data = buffer;
  I2c_Msg.size = count;  
  return NU_Send_To_Queue(I2c_Queue, &I2c_Msg, 5, NU_NO_SUSPEND); 
}
