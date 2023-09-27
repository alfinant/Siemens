#include <siemens/i2clib.h>
#include <siemens/gpio.h>
#include <siemens/clkman.h>
#include <siemens/swilib.h>
#include "rect_patcher.h"

#ifdef E71v45
#define CapCom_RegClient        ((int(*)(char* label, int channel)) 0xA04CE1C8)
#define CapCom_UnRegClient      ((int(*)(unsigned pwm_id)) 0xA04CE3D4)
#define CapCom_ConnectTimer     ((int(*)(unsigned pwm_id, int frequency, int dutycycle))0xA04CE25C)
#define CapCom_DisconnectTimer  ((int(*)(unsigned pwm_id)) 0xA04CE32C)
#define CapCom_TimerOn          ((int(*)(unsigned pwm_id)) 0xA04CE454)
#define CapCom_TimerOn_CSS      ((int(*)(unsigned pwm_id)) 0xA04CE4E4)
#define CapCom_TimerOff         ((int(*)(unsigned pwm_id)) 0xA04CE574) 
#define CapCom_SetFreq          ((int(*)(unsigned pwm_id, int frequency, void (*callback)(void) )) 0xA04CE600)
#define CapCom_SetDutycycle     ((int(*)(unsigned pwm_id, int dutycycle, void (*callback)(void) )) 0xA04CE69C)
#define CapCom_SetDutycycle_2   ((int(*)(unsigned pwm_id, int dutycycle, void (*callback)(void) )) 0xA04CE73C) 

#define SetClock                ((int(*)(unsigned dev,int))0xA04D0728)
#endif

#ifdef S75v47
#define CapCom_RegClient       ((int(*)(char* name, char channel)) 0x)
#define CapCom_UnRegClient     ((int(*)(unsigned id)) 0x)
#define CapCom_ConnectTimer    ((int(*)(unsigned id, int frequency, int dutycycle))0x)
#define CapCom_DisconnectTimer ((int(*)(unsigned id)) 0x)
#define CapCom_TimerOn         ((int(*)(unsigned id)) 0x)
#define CapCom_TimerOff        ((int(*)(unsigned id)) 0x)
#define CapCom_TimerOn_CSS     ((int(*)(unsigned id)) 0x) 
#define CapCom_SetFreq         ((int(*)(unsigned id, int frequency, int zero)) 0x)
#define CapCom_SetDutycycle    ((int(*)(unsigned id, int dutycycle, int zero)) 0x)
#define CapCom_SetDutycycle2   ((int(*)(unsigned id, int dutycycle, int zero)) 0x)
#define SetClkState            ((int(*)(unsigned port_id,int))0xA01D0C78)
#endif

unsigned pwm = 0x2F1C71;
int FREQUENCY=1000; 
int DUTYCYCLE=50;
int STATE=1;

const int minus11=-11;
unsigned int MAINCSM_ID = 0;
unsigned int MAINGUI_ID = 0;


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



void OnRedraw(MAIN_GUI *data)
{
  int scr_w=ScreenW();
  int scr_h=ScreenH();
  
 DrawRoundedFrame(0,YDISP,scr_w-1,scr_h-1,0,0,0,GetPaletteAdrByColorIndex(0),GetPaletteAdrByColorIndex(1));
 
 wsprintf(data->ws1,
          "Frequency:\n"
            "%dHz\n"
             "Dutycycle:\n"
               "%d%\n"
                 ,FREQUENCY,DUTYCYCLE);
  DrawString(data->ws1,15,20+YDISP,scr_w,scr_h-20,
             FONT_LARGE,0,GetPaletteAdrByColorIndex(0),GetPaletteAdrByColorIndex(23));

  if(STATE==0)  wsprintf(data->ws1,"Off");
  if(STATE==1)  wsprintf(data->ws1,"On");
  
  DrawString(data->ws1,6,scr_h-6-GetFontYSIZE(FONT_MEDIUM_BOLD),scr_w-6,scr_h-6,
             FONT_MEDIUM_BOLD,TEXT_ALIGNLEFT,GetPaletteAdrByColorIndex(0),GetPaletteAdrByColorIndex(23)); 

  
  wsprintf(data->ws1,"Exit");
  DrawString(data->ws1,scr_w>>1,scr_h-4-GetFontYSIZE(FONT_MEDIUM_BOLD),scr_w-6,scr_h-6,
             FONT_MEDIUM_BOLD,TEXT_ALIGNRIGHT,GetPaletteAdrByColorIndex(0),GetPaletteAdrByColorIndex(23)); 

}

void onCreate(MAIN_GUI *data, void *(*malloc_adr)(int))
{

  data->ws1=AllocWS(80);
  data->gui.state=1;
}

void onClose(MAIN_GUI *data, void (*mfree_adr)(void *))
{
  FreeWS(data->ws1);
  data->gui.state=0;
}

void onFocus(MAIN_GUI *data, void *(*malloc_adr)(int), void (*mfree_adr)(void *))
{ 
  DisableIDLETMR();
  data->gui.state=2;
}

void onUnfocus(MAIN_GUI *data, void (*mfree_adr)(void *))
{
  if (data->gui.state!=2) return;
  data->gui.state=1;
}

static int OnKey(MAIN_GUI *data, GUI_MSG *msg)
{
  if (msg->gbsmsg->msg==KEY_DOWN)
  {
    switch(msg->gbsmsg->submess)
    {
    case '1': CapCom_SetFreq (pwm, FREQUENCY+=1000, 0);  //шаг 1kHz
    break;      
    case '4': if((FREQUENCY-1000) < 0)  CapCom_SetFreq (pwm,FREQUENCY=0 , 0); 
              else CapCom_SetFreq (pwm, FREQUENCY-=1000, 0);
    break;     
    case RIGHT_BUTTON: if(DUTYCYCLE <100)  CapCom_SetDutycycle (pwm, ++DUTYCYCLE, 0);
    break;     
    case LEFT_BUTTON: if(DUTYCYCLE != 0)  CapCom_SetDutycycle (pwm, --DUTYCYCLE, 0);
    break; 
    case UP_BUTTON: CapCom_SetFreq (pwm, ++FREQUENCY, 0); //шаг 1Hz
    break;         
    case DOWN_BUTTON: if(FREQUENCY != 0) CapCom_SetFreq (pwm, --FREQUENCY, 0); 
    break;
    case VOL_UP_BUTTON: CapCom_SetFreq (pwm, FREQUENCY+=100, 0); //шаг 1000Hz
    break;
    case VOL_DOWN_BUTTON: if((FREQUENCY-100) < 0) CapCom_SetFreq (pwm,FREQUENCY=0 , 0); 
              else CapCom_SetFreq (pwm, FREQUENCY-=100, 0);
    break;
    case LEFT_SOFT:
      if(STATE==1) {STATE=0; GPIO_USART0_TXD = 0x500; } // ножка отключена
      else {STATE=1; GPIO_USART0_TXD = 0x30; }          // ножка управляется ШИМ'ом
    break;
    case RIGHT_SOFT: return (1);
    }
  REDRAW();
  }

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
  patch_rect((RECT*)&Canvas,0,YDISP,ScreenW()-1,ScreenH()-1);
  main_gui->gui.canvas=(void *)(&Canvas);
  main_gui->gui.flag30=2;
  main_gui->gui.methods=(void *)gui_methods;
  main_gui->gui.item_ll.data_mfree=(void (*)(void *))mfree_adr();
  csm->csm.state=0;
  csm->csm.unk1=0;
  MAINGUI_ID=csm->gui_id=CreateGUI(main_gui);
}

#pragma segment="ELFBEGIN"
void ElfKiller(void)
{
  kill_data(__segment_begin("ELFBEGIN"),(void (*)(void *))mfree_adr());
}

static void maincsm_onclose(CSM_RAM *data)
{ 
  CapCom_TimerOff(pwm);
  CapCom_DisconnectTimer(pwm); 
  CapCom_UnRegClient(pwm);
  ClkStateOff(1 << CAPCOM);

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
  wsprintf((WSHDR *)(&MAINCSM.maincsm_name),"PWM");
}


void callback() {GPIO_USART0_TXD = 0x500; }

void test_pm_ringin() {
    // ClkStateOn(CLKSTATE.capcom);
     GPIO_RF_STR1 = 0x30;
     CapCom_UnRegClient(pwm);
     pwm=CapCom_RegClient("PM_RINGIN", 13);
     CapCom_ConnectTimer(pwm,FREQUENCY,DUTYCYCLE);
     CapCom_TimerOn(pwm);
     i2cw_pmu(0x42, 0x04); //устанавливаем PM_RINGIN источником входного сигнала на Dialog  
     i2cw_pmu(0x40, 0x28); //громкость
}
    
void test_pin() {
  ClkStateOn(1 << CAPCOM);
  GPIO_DSPOUT0 = 0x30;
  pwm=CapCom_RegClient("Pin", 14);
  CapCom_ConnectTimer (pwm, FREQUENCY, DUTYCYCLE);
  CapCom_TimerOn(pwm);                           
}
int main(char *exename, char *fname)
{ 
   test_pin();
   MAIN_CSM main_csm;
   zeromem(&main_csm, sizeof(MAIN_CSM));
   LockSched();
   UpdateCSMname();
   MAINCSM_ID=CreateCSM(&MAINCSM.maincsm,&main_csm,0);
   UnlockSched();

   return 0;
}
