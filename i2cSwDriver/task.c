#include "..\inc\swilib.h"
#include "..\inc\nu_swilib.h"
#include "I2CSW_TS.H"

#define I2C_SW_QUEUE_NAME           "I2cSwQueue"
#define I2C_SW_QUEUE_STACK_SIZE     0xC8
#define I2C_SW_TASK_NAME            "I2cSwTask"
#define I2C_SW_TASK_STACK_SIZE      0x800
#define I2C_SW_TASK_PRIO            0x3C

UNSIGNED stack_i2c_sw_task[I2C_SW_TASK_STACK_SIZE];
UNSIGNED stack_i2c_sw_queue[I2C_SW_QUEUE_STACK_SIZE];

NU_QUEUE i2c_queue;
NU_TASK i2c_task;

typedef struct {
   char  addr;
   char  mode;  // 0-sub_addr используетс€, 2-не используетс€
#ifdef NEWSGOLD
   char tf;    // тип функции(1-запись, 2-чтении, 4-запись одного байта)
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


void  i2c_sw_task_entry(UNSIGNED argc, VOID *argv)
{
  STATUS status;
  I2C_MSG i2c_msg;
  UNSIGNED received_size;
    
  while(1)
  {   
    status = NU_Receive_From_Queue(&i2c_queue, &i2c_msg, 5, &received_size, NU_SUSPEND);
      
    /* Determine if the message was received successfully.  */   
    if (status == NU_SUCCESS)
    {      
      if(i2c_msg.tf==1)
        i2cWrite(i2c_msg.addr, i2c_msg.sub_addr, i2c_msg.data, i2c_msg.size);
      else
        if(i2c_msg.tf==2)
          i2cRead(i2c_msg.addr, i2c_msg.sub_addr, i2c_msg.data, i2c_msg.size);
    }    
  }
}

unsigned int initalize()
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
  STATUS status;

  NU_QUEUE  *Pointer_Array[20];
  UNSIGNED number;
 
  //«ащита от повторного запуска  
  number = NU_Queue_Pointers(Pointer_Array, 20);
  
  while(--number)
  {
    NU_Queue_Information(Pointer_Array[number], queue_name, &start_address, &size, &available,
                                &messages, &message_type, &message_size, &suspend_type, &tasks_suspended, &first_task);
    
    if(strncmp(queue_name, I2C_SW_QUEUE_NAME, 8) == 0)
    {
      ShowMSG(1,(int)"I2cSwDriver already loaded!");
      return (1);
    }
  } 
  //—оздадим очередь дл€ наших сообщений   
  status = NU_Create_Queue(&i2c_queue, I2C_SW_QUEUE_NAME, stack_i2c_sw_queue, I2C_SW_QUEUE_STACK_SIZE, NU_FIXED_SIZE, 5, NU_FIFO); 
  if (status != NU_SUCCESS)
  {
    ShowMSG(1,(int)"I2cSwDRv: don`t create queue!");
    return 1;
  }
  //—оздадим задачу.ѕосле старта задача остановитс€ и возобновитс€ только после поступлени€ в очередь i2c_queue сообщени€
  status = NU_Create_Task(&i2c_task, I2C_SW_TASK_NAME, i2c_sw_task_entry, 0, 0,(void *)stack_i2c_sw_task, I2C_SW_TASK_STACK_SIZE, I2C_SW_TASK_PRIO , 0x50, NU_PREEMPT, NU_START);
  if (status != NU_SUCCESS)
  {
    ShowMSG(1,(int)"I2cSwDRv: don`t create task!");
    return 1;
  }
  
  return 0;
}
