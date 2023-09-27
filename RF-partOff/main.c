#include <siemens/swilib.h>

#ifdef NEWSGOLD
#include "..\inc\reg8876.h"
#else
#include "..\inc\reg8875.h"
#endif

const int minus11=-11;

typedef struct
{
  CSM_RAM csm;
}MAIN_CSM;

int maincsm_id;

void RFpart_activate()
{
  GPIO.TOUT7  &= ~ GPIO_ENAQ; // радиотракт включился 
}

void RFpart_deactivate()
{
  GPIO.TOUT7 |= GPIO_ENAQ;  //сброс, радиотракт отключился
}

int maincsm_onmessage(CSM_RAM* data,GBS_MSG* msg)
{
  return (1);  
}

static void maincsm_oncreate(CSM_RAM *data)
{
  RFpart_deactivate();
  ShowMSG(1,(int)"RF-part deactivated!" );
}

extern void kill_data(void *p, void (*func_p)(void *));
void ElfKiller(void)
{
  extern void *ELF_BEGIN;
  kill_data(&ELF_BEGIN,(void (*)(void *))mfree_adr());
}

static void maincsm_onclose(CSM_RAM *csm)
{
    RFpart_activate();
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
  wsprintf((WSHDR *)(&MAINCSM.maincsm_name),"RF-partOff");
}


int main(void)
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

   return 0;
}

