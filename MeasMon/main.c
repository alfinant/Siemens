#include "../inc/swilib.h"
#include "../inc/nu_swilib.h"
#include "clkman.h"
#include "irq_work.h"
#include "rect_patcher.h"
#include "meas.h"

#ifdef NEWSGOLD
#include "../inc/reg8876.h"
#else
#include "../inc/reg8875.h"
#endif

#define C72

#ifdef CX75
#define     GUI_AddTimer             ((int(*)(GUI* gui)) 0xA0800A17)//таймеров всего 10
//pattern SGOLD=EC,54,58,19,C2,60,08,1C,??,??,01,31,0A,29 - 0x17
#define     GUI_StartTimerProc       ((void(*)(GUI* gui, int id, long ms, void ptr())) 0xA0800A89)
//pattern SGOLD=F8,B5,16,1C,18,1C,0A,29,??,??,14,23,59,43 +1
#define     GUI_DeleteTimer          ((int(*)(GUI* gui, int id)) 0xA0800B03)
//pattern SGOLD=10,B5,0C,1C,0A,29,??,??,21,1C,??,??,EE,FF,14,22,62,43 +1
#endif
   
#ifdef C72
#define     GUI_AddTimer             ((int(*)(GUI* gui)) 0xA0CC8B3B)
#define     GUI_StartTimerProc       ((void(*)(GUI* gui, int id, long ms, void ptr())) 0xA0CC8BAD)
#define     GUI_DeleteTimer          ((int(*)(GUI* gui, int id)) 0xA0CC8C27)
#endif
   
#define PM_CHARGE_UC   GPIO.TOUT1

extern int adata;

int VREF=1960;//»змеренное опорное напр€жение 
int VMAX=15220; 
int volt=0;

int tmr_id;
GUI* tvgui;
int maingui_id;

static const char percent_t[]="%t";
static const char HEADER_TEXT[]="MEAS Monitor";

static HEADER_DESC hdr={0,0,0,0,NULL,NULL,LGP_NULL};

static const int mmenusoftkeys[]={0,1,2};

static SOFTKEY_DESC sk[]=
{
  {0x0018,0x0000,(int)""},
  {0x0001,0x0000, (int)"¬ыход"},
  {0x0000,0x0000,0xFFFFFFFF},
};

static SOFTKEYSTAB skt=
{
  sk,0
};

static void tmr_hndl()
{
  if (adata != -1)
  {
    WSHDR* ws=AllocWS(80);
    wsAppendChar(ws, UTF16_FONT_MEDIUM_BOLD); 
    wstrcatprintf(ws, "\n\n"
                "M2: "
                  "0x%X\n"
                    "V: %d mV", adata, volt);
    TViewSetText(tvgui, ws, malloc_adr(), mfree_adr());
    DirectRedrawGUI();
  }
  
  MEAS_Start();
  GUI_StartTimerProc (tvgui, tmr_id, 1000, tmr_hndl);
}

static void proc3(){}

static int onKey(void* gui, GUI_MSG *msg)
{
  if (msg->keys==1)//закрытие
  {
    //
    return (0);
  }
  
  if ((msg->gbsmsg->msg==KEY_DOWN)||(msg->gbsmsg->msg==LONG_PRESS))
  {
    switch(msg->gbsmsg->submess)
    {
    case LEFT_SOFT:
      break;
      
    case RIGHT_SOFT:
      return(1);//выход
    }
  }
  return(0);
}

static void gHook(void* data, int cmd)
{ 
  if (cmd==TI_CMD_CREATE)
  {
    void* hdr_pointer=GetHeaderPointer(data);
    WSHDR* ws=AllocWS(32);
    wsprintf(ws, percent_t, HEADER_TEXT);
    SetHeaderText(hdr_pointer, ws, malloc_adr(), mfree_adr());
  }
  
  if (cmd==TI_CMD_UNFOCUS)
  {

  }
  
  if (cmd==TI_CMD_FOCUS)
  {  
    DisableIDLETMR();
  }
  
  if (cmd==TI_CMD_DESTROY)
  {

  }
}

static TVIEW_DESC tv_desc=
{
  8,
  onKey,
  gHook,
  proc3,
  mmenusoftkeys,
  &skt,
  {0, 0, 0, 0},//RECT текста
  8,//font
  0x64,
  0x65,
  0,
  2 //выравнивание по центру
};

//---------------------------- CSM -------------------------------------------

typedef struct
{
  CSM_RAM csm;
  int gui_id;
}MAIN_CSM;


static void maincsm_oncreate(CSM_RAM *data)
{
  MAIN_CSM *csm=(MAIN_CSM *)data;
  csm->csm.state=0;
  csm->csm.unk1=0;
  
  tvgui=TViewGetGUI(malloc_adr(), mfree_adr());
  TViewSetDefinition(tvgui, &tv_desc);
  patch_header(&hdr);
  SetHeaderToMenu(tvgui, &hdr, malloc_adr());
  patch_header(&hdr);
  patch_tview(&tv_desc);
  WSHDR* ws=AllocWS(80);
  wsAppendChar(ws, UTF16_FONT_MEDIUM_BOLD); 
  wstrcatprintf(ws, "\n\n"
                "M2: -----");
  TViewSetText(tvgui, ws, malloc_adr(), mfree_adr());
  maingui_id=CreateGUI(tvgui);
  csm->gui_id=maingui_id;
  
  tmr_id=GUI_AddTimer(tvgui);
  GUI_StartTimerProc (tvgui, tmr_id, 0, tmr_hndl);
}

extern void kill_data(void *p, void (*func_p)(void *));

#pragma segment="ELFBEGIN"
void ElfKiller(void)
{
  kill_data(__segment_begin("ELFBEGIN"),(void (*)(void *))mfree_adr());
}

static void maincsm_onclose(CSM_RAM *data)
{ 
  GUI_DeleteTimer(tvgui, tmr_id);
  MEAS_Delete(); 
  SUBPROC((void *)ElfKiller);
}

static int maincsm_onmessage(CSM_RAM *data, GBS_MSG *msg)
{
  MAIN_CSM *csm=(MAIN_CSM*)data;
  if ((msg->msg==MSG_GUI_DESTROYED)&&((int)msg->data0==csm->gui_id))
  {
    csm->csm.state=-3;
  }

  return(1);
}

static unsigned short maincsm_name_body[140];
static const int minus11=-11;

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

void UpdateCSMname(void)
{
  wsprintf((WSHDR *)(&MAINCSM.maincsm_name),"Meas Monitor");
}

void meas_callback()
{
  int data=adata-2045;
  if (data < 50 ) data=0;
  int v0 = divide(2045, VREF * data);//напр€жение на входе M2
  int mux = divide(VREF, VMAX * 1000);//множитель дл€ резисторного делител€
  volt = divide(1000, v0 * mux);
} 

int main(void)
{   

  if (MEAS_Init(meas_callback))
  {  
    MAIN_CSM main_csm;
    zeromem(&main_csm, sizeof(MAIN_CSM));
    UpdateCSMname();
    LockSched();
    CreateCSM(&MAINCSM.maincsm,&main_csm,0);
    UnlockSched();
  }
  else
  {
    ShowMSG(1,(int)"HISR not created:(" );
    SUBPROC((void *)ElfKiller);
  }
  
  return 0;
}

