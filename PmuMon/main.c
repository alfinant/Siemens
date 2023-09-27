#include "../inc/swilib.h"
#include "../inc/i2c.h"
#include "rect_patcher.h"

#define TMR_SECOND 216

GBSTMR tmr;
int ready=0;

int page=1;
int page_size=64;
int cursor=0;
char reg_buf[140];
char reg_buf_prev[140];

typedef struct
{
  CSM_RAM csm;
  int gui_id;
}MAIN_CSM;

typedef struct
{
  GUI gui;
  WSHDR *ws1;
}MAIN_GUI;

int maingui_id;

void callback(void *i2c_msg, int err)
{
  ready++;
  REDRAW(); 
}

void do_tmr()
{
  i2cr_pmu(0, reg_buf, callback, 0, sizeof(reg_buf));
  GBS_StartTimerProc(&tmr,TMR_SECOND,do_tmr); 
}

static void OnRedraw(MAIN_GUI *data)
{
  WSHDR ws;
  unsigned short wsbody[32];

  int scr_w=ScreenW();
  int scr_h=ScreenH(); 
  int MYYDISP=0;
  int MYXDISP=4;
  int header_h=1+GetFontYSIZE(FONT_SMALL);
  int rec_w=27;//для экранов 320x240
  int rec_h=27;
  
  RECT rc[sizeof(reg_buf)];//массив 
  char* _reg_buf=reg_buf;
  char* _reg_buf_prev=reg_buf_prev;
  
  if(scr_w==132)//для экранов 176x132
  {
    rec_w=14;
    rec_h=14;
    MYYDISP=2;
    MYXDISP=2;
  }
    
  //int sym_w=GetSymbolWidth('D', FONT_SMALL);
  
  CreateLocalWS(&ws, wsbody, 31);
  
  DrawRoundedFrame(0,0,scr_w-1,scr_h-1,0,0,0,GetPaletteAdrByColorIndex(1),GetPaletteAdrByColorIndex(1));
  
  wsprintf(&ws, "PMU-MON");
  DrawString(&ws, MYXDISP, MYYDISP, scr_w-MYXDISP, scr_h+header_h, FONT_SMALL, TEXT_ALIGNLEFT, GetPaletteAdrByColorIndex(0),GetPaletteAdrByColorIndex(23));

  if(page!=1)
  {
    wsprintf(&ws, "PAGE-2");
    _reg_buf=reg_buf+page_size;
    _reg_buf_prev=reg_buf_prev+page_size;
  }
  else
     wsprintf(&ws, "PAGE-1");
  
  DrawString(&ws, MYXDISP, MYYDISP, scr_w-MYXDISP-2, scr_h+header_h, FONT_SMALL, TEXT_ALIGNRIGHT, GetPaletteAdrByColorIndex(0),GetPaletteAdrByColorIndex(23));

  int x_offset=MYXDISP;
  int y_offset=MYYDISP+header_h; 
  
  for(int i=0; i < page_size; i++)
  {
    rc[i].x=x_offset;
    rc[i].y=y_offset;
    rc[i].x2=x_offset+rec_w;
    rc[i].y2=y_offset+rec_h; 
    
    x_offset+=rec_w+2;
    if (i>0 && (i+1)%8==0)
    {
      x_offset=MYXDISP;
      y_offset+=rec_h+2;
     }
    
    char* color_rec_fon=GetPaletteAdrByColorIndex(5);
    if(ready > 1 && _reg_buf[i] != _reg_buf_prev[i]) color_rec_fon=GetPaletteAdrByColorIndex(2); 
    
    DrawRectangle(rc[i].x, rc[i].y, rc[i].x2, rc[i].y2, 0, color_rec_fon, color_rec_fon);
    if(i==cursor)
      DrawRectangle(rc[i].x, rc[i].y, rc[i].x2, rc[i].y2, 0, GetPaletteAdrByColorIndex(0), GetPaletteAdrByColorIndex(23));
    wsprintf(&ws, "%02X", _reg_buf[i]);
    int font_h=GetFontYSIZE(FONT_SMALL);   
    int y_text_offset=(rec_h-font_h)/2;
    if(ready)
      DrawString(&ws, rc[i].x, rc[i].y+y_text_offset, rc[i].x2, rc[i].y2, FONT_SMALL, TEXT_ALIGNMIDDLE, GetPaletteAdrByColorIndex(0),GetPaletteAdrByColorIndex(23));
  }

  wsprintf(&ws, "REG 0x%02X", cursor);
  DrawString(&ws, MYXDISP, scr_h-GetFontYSIZE(FONT_SMALL_BOLD)-8, scr_w-MYXDISP-2, scr_h, FONT_SMALL_BOLD, TEXT_ALIGNLEFT, GetPaletteAdrByColorIndex(0),GetPaletteAdrByColorIndex(23));  
  
  memcpy(reg_buf_prev, reg_buf, sizeof(reg_buf));
  __asm("NOP"); // !MOV PC,Rn
}


static void onCreate(MAIN_GUI *data, void *(*malloc_adr)(int))
{
  data->ws1=AllocWS(256);
  data->gui.state=1;
  GBS_StartTimerProc(&tmr,TMR_SECOND,do_tmr);
}

static void onClose(MAIN_GUI *data, void (*mfree_adr)(void *))
{
  data->gui.state=0;
  FreeWS(data->ws1);
  GBS_DelTimer(&tmr);
}

static void onFocus(MAIN_GUI *data, void *(*malloc_adr)(int), void (*mfree_adr)(void *))
{
  #ifdef ELKA
  DisableIconBar(1);
  #endif 
  data->gui.state=2;
  DisableIDLETMR();
  //SetCpuClockLow(2); 
}

static void onUnfocus(MAIN_GUI *data, void (*mfree_adr)(void *))
{
  #ifdef ELKA
  DisableIconBar(0);
  #endif 
  if (data->gui.state!=2) return;
  data->gui.state=1;
}

char dat42;
char dat44;
char dat46;

static int OnKey(MAIN_GUI *data, GUI_MSG *msg)
{
  if (msg->gbsmsg->msg==KEY_DOWN)
  {
    switch(msg->gbsmsg->submess)
    {
    case '1': page=1;
    break;
      
    case '2': page=2;
    break;
    
    case '*':
      dat44=0x24;
      i2cw_pmu(0x44, &dat44, NULL, NULL);
      dat46=0x5f;
      i2cw_pmu(0x46, &dat46, NULL, NULL);     
      dat42=8;
      i2cw_pmu(0x42, &dat42, NULL, NULL);     
      break;
      
    case LEFT_BUTTON:
      if(cursor > 0)cursor--;
      break;
      
    case RIGHT_BUTTON:
      if(cursor < (sizeof(reg_buf)-1)) cursor++;
      break;
      
    case UP_BUTTON:
      if(cursor >= 8)cursor-=8;
      break;
      
    case DOWN_BUTTON:
      if((cursor +8) <= (page_size-1)) cursor+=8;
      break;      

    case RIGHT_SOFT:
      return (1);
    }
  }
  if(page==1 && cursor > page_size-1)
  {
    page=2;
    cursor=0;
  }
  REDRAW();
  return(0);
}

extern void kill_data(void *p, void (*func_p)(void *));

int method8(void){return(0);}
int method9(void){return(0);}
const void * const gui_methods[11]={
  (void *)OnRedraw,
  (void *)onCreate,
  (void *)onClose,
  (void *)onFocus,
  (void *)onUnfocus,
  (void *)OnKey,
  0,
  (void *)kill_data,
  (void *)method8,
  (void *)method9,
  0
};

static void maincsm_oncreate(CSM_RAM *data)
{
  static const RECT Canvas={0,0,0,0};
  MAIN_GUI *main_gui=malloc(sizeof(MAIN_GUI));
  MAIN_CSM *csm=(MAIN_CSM *)data;
  zeromem(main_gui,sizeof(MAIN_GUI));
  patch_rect((RECT*)&Canvas,0,0,ScreenW()-1,ScreenH()-1);
  main_gui->gui.canvas=(void *)(&Canvas);
  main_gui->gui.methods=(void *)gui_methods;
  main_gui->gui.color1=0x65;
  main_gui->gui.item_ll.data_mfree=(void (*)(void *))mfree_adr();
  main_gui->gui.unk10=2;
  main_gui->gui.flag30=1;
  csm->csm.state=0;
  csm->csm.unk1=0;

  maingui_id=csm->gui_id=CreateGUI(main_gui);
}

#pragma segment="ELFBEGIN"
void ElfKiller(void)
{
  kill_data(__segment_begin("ELFBEGIN"),(void (*)(void *))mfree_adr());
}

static void maincsm_onclose(CSM_RAM *data)
{ 
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
  wsprintf((WSHDR *)(&MAINCSM.maincsm_name),"PmuMon");
}

int main(char *exename, char *fname)
{ 
  MAIN_CSM main_csm;
  zeromem(&main_csm, sizeof(MAIN_CSM));
  UpdateCSMname();
  LockSched();
  CreateCSM(&MAINCSM.maincsm,&main_csm,0);
  UnlockSched();
  return 0;
}
