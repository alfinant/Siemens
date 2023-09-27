#include "..\inc\swilib.h"
#include "..\inc\strings.h"
#include "..\inc\clkman.h"
#include "I2C_SW.H"

#define IPC_CHECK_DOUBLERUN 1
#define IPC_I2C_WRITE 2

int dooble_run=0;

int i2c_writeByte()
{
  I2cStart();
  I2cMasterWrite(0x88);
  while(COM_ON);

  if (RecAck) //если slave не ответил
  {
    ShowMSG(1, (int)"Адрес: иди NACK!");
    I2cStop();
    return (1);
  }
  if(!RecAck)
  {
    I2cMasterWrite(0x88);
    while (COM_ON);
    if (RecAck) //если slave не ответил
    {
      ShowMSG(1, (int)"Данные: иди NACK!");
      I2cStop();
      return (1);
    }
  }
  
  I2cStop();
  ShowMSG(1, (int)"I2C_SW: Молодцом!");  
  return (0);
}

const int minus11=-11;
const char ipc_my_name[32]="I2C_SW";
IPC_REQ ipc;

extern const char LOGFILE[];

typedef struct
{
  CSM_RAM csm;
}MAIN_CSM;

int maincsm_id;

void destroyApp()
{
   if(!dooble_run)
     I2cDeInit();
}

void startApp()
{
  I2cInit();
}

void CheckDoubleRun(void)
{
  if ((int)ipc.data !=-1)
  {
    dooble_run=1;
    ipc.name_to=ipc_my_name;
    ipc.name_from=ipc_my_name;
    ipc.data=0;
    GBS_SendMessage(MMI_CEPID,MSG_IPC,IPC_I2C_WRITE,&ipc); 

  //  ShowMSG(0x11,(int)"I2C_SW был уже запущен!");    
    LockSched();
    CloseCSM(maincsm_id);
    UnlockSched();
    
   
  }
  else
  {
    SUBPROC((void *) startApp );
  }
}


int maincsm_onmessage(CSM_RAM* data,GBS_MSG* msg)
{   
//IPC
    if (msg->msg==MSG_IPC)
    {
      if (msg->submess!=392305998)
      {
        IPC_REQ *ipc;
        if ((ipc=(IPC_REQ*)msg->data0))
        {
          if (strcmp_nocase(ipc->name_to,ipc_my_name)==0)
          {
            switch (msg->submess)
            {
            case IPC_CHECK_DOUBLERUN:
	    //Если приняли свое собственное сообщение, значит запускаем чекер
	    if (ipc->name_from==ipc_my_name) SUBPROC((void *)CheckDoubleRun);
            else ipc->data=(void *)maincsm_id;
	    break;
            case IPC_I2C_WRITE:
               if(!dooble_run) i2c_writeByte();
              break;
            }
          }
        }
      }
    }
  
  return (1);  
}

static void maincsm_oncreate(CSM_RAM *data)
{
  ipc.name_to=ipc_my_name;
  ipc.name_from=ipc_my_name;
  ipc.data=(void *)-1;
  GBS_SendMessage(MMI_CEPID,MSG_IPC,IPC_CHECK_DOUBLERUN,&ipc);
}

extern void kill_data(void *p, void (*func_p)(void *));
void ElfKiller(void)
{
  extern void *ELF_BEGIN;
  kill_data(&ELF_BEGIN,(void (*)(void *))mfree_adr());
}

static void maincsm_onclose(CSM_RAM *csm)
{
  destroyApp();
  SUBPROC((void *)ElfKiller);
}

static unsigned short maincsm_name_body[140];

static const struct
{
  CSM_DESC maincsm;
  WSHDR maincsm_name;
}MAINCSM =
{
  {
  maincsm_onmessage,
  maincsm_oncreate,
#ifdef NEWSGOLD
  0,
  0,
  0,
  0,
#endif
  maincsm_onclose,
  sizeof(MAIN_CSM),
  1,
  &minus11
  },
  {
    maincsm_name_body,
    NAMECSM_MAGIC1,
    NAMECSM_MAGIC2,
    0x0,
    139
  }
};

static void UpdateCSMname(void)
{
  wsprintf((WSHDR *)(&MAINCSM.maincsm_name),"I2C_SW");
}

int main(char *exename, char *fname)
{
  CSM_RAM *save_cmpc;
  char dummy[sizeof(MAIN_CSM)];
  UpdateCSMname();  
  LockSched();
  save_cmpc=CSM_root()->csm_q->current_msg_processing_csm;
  CSM_root()->csm_q->current_msg_processing_csm=CSM_root()->csm_q->csm.first;
  maincsm_id=CreateCSM(&MAINCSM.maincsm,dummy,0);
  CSM_root()->csm_q->current_msg_processing_csm=save_cmpc;
  UnlockSched();


  
 // SUBPROC((void *)ElfKiller);
  return(1);  

}

