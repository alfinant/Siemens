#include "../inc/swilib.h"
#include "rect_patcher.h"
#include "new_functions.h"
#include "process.h"
#include "http.h"
#include "vk_api.h"
#include "clist.h"
#include "dyn_images.h"
#include "dyn_theme.h"
#include "anim_widget.h"
#include "main.h"


static const char percent_d[]="%d";
static const char percent_t[]="%t";

static const char* MONTH_NAME[]={"янв","фев","март","апр","май","июнь","июль","авг","сен","окт","ноя","дек"};

extern const char DIR[];

CLIST* selected_group=NULL;
int gui_restarted=0;

static int header_icon=0x4E74;
static IMGHDR* img_icon=NULL;

static HEADER_DESC hdr={0,0,0,0,NULL,NULL,LGP_NULL};

static const int mmenusoftkeys[]={0,1,2};

static SOFTKEY_DESC sk[]=
{
  {0x0018,0x0000,(int)""},
  {0x0001,0x0000, (int)"Назад"},
  {0x003D,0x0000,(int)LGP_DOIT_PIC}
};

static SOFTKEYSTAB skt=
{
  sk,0
};


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
    case ENTER_BUTTON:
      break;
  
    case GREEN_BUTTON:
#ifdef DEVELOP      
      CreateDebugGUI();
#endif
    break;
      
    case RIGHT_SOFT:
      return(1);
    }
  }
  return(0);
}

static void gHook(void* data, int cmd)
{
  //static int hdr_pic;
  
  if (cmd==TI_CMD_CREATE)
  {
    gui_restarted=0;
    
    LoadDynTheme();
    
    if (img_icon)
      hdr.icon=&header_icon;
    void* hdr_pointer=GetHeaderPointer(data);
    WSHDR* ws=AllocWS(32);
    if (selected_group->first_name)
      wstrcat(ws, selected_group->first_name);
    else
      wsprintf(ws, percent_d, selected_group->user_id);
    SetHeaderText(hdr_pointer, ws, malloc_adr(), mfree_adr());
    
    if (process==0 && selected_group->msglist==NULL)
    {
      process=LOAD_WALL;
      SUBPROC((void *)HttpSendReq, wall_get(selected_group->user_id, 1, 0));
      AnimWidget_Wait_body();
    }           
  }
  
  if (cmd==TI_CMD_UNFOCUS)
  {
    DisableDynTheme();
  }
  
  if (cmd==TI_CMD_FOCUS)
  {
    EnableDynTheme();  
    DisableIDLETMR();
  }
  
  if (cmd==TI_CMD_DESTROY)
  { 
    if (gui_restarted==0)
      csm->wall_gui_id=NULL;
    
    if (img_icon)
    {
      mfree(img_icon->bitmap);
      mfree(img_icon);
      img_icon=NULL;      
    }
    DisableDynTheme();
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
#ifdef ELKA  
  {4,56,239,287},
#else
  {0,22,131,153},
#endif
  8,//font
  0x64,
  0x65,
  0,
  0 //выравнивание
};

static void (*OnRedraw)(void*);
static void* gui_methods_copy[24];

static void MyOnRedraw(void *data)
{
  OnRedraw(data);

}

static WSHDR* crt_text(POSTMSG* msg)
{
  WSHDR* ws=NULL;
  
  TDate t_date;
  TTime time;
  TDate s_date;
  int timestap; 
  TDate phone_date;
  TTime phone_time;  
  
  while (msg)
  {
    ws=AllocWS(100+wstrlen(msg->text));
  
    timestap=msg->date + 10800;//+3 часа(time_zone)
    s_date.year=1970;
    s_date.month=1;
    s_date.day=1;
    GetDateTimeFromSeconds(&timestap, &t_date, &time, &s_date);
    
    wsAppendChar(ws, UTF16_FONT_SMALL_BOLD);
    
    wsAppendChar(ws, UTF16_INK_RGBA); 
    wsAppendChar(ws, 0x5D80);//RG
    wsAppendChar(ws, 0xA664);//BA - вк синий  
    wstrcatprintf(ws, percent_d, msg->from_id);
    wsAppendChar(ws, ':');
    wsAppendChar(ws, '\n');
    
    wsAppendChar(ws, UTF16_FONT_SMALL);
    wsAppendChar(ws, UTF16_INK_RGBA); 
    wsAppendChar(ws, 0x8080);//RG
    wsAppendChar(ws, 0x8064);//BA - серый
    
    GetDateTime(&phone_date, &phone_time);
    
    if (phone_date.day==t_date.day && phone_date.month==t_date.month && phone_date.year==t_date.year)
      wstrcatprintf(ws, "%t %d:%02d", "сегодня в", time.hour, time.min);
    else
      if ((phone_date.day-1)==t_date.day && phone_date.month==t_date.month && phone_date.year==t_date.year)
        wstrcatprintf(ws, "%t %d:%02d", "вчера в", time.hour, time.min);
    else
      wstrcatprintf(ws, "%d %t %d:%02d", t_date.day, MONTH_NAME[t_date.month-1], time.hour, time.min);
      
    wsAppendChar(ws, '\n');
    
    wsAppendChar(ws, UTF16_INK_RGBA);
    wsAppendChar(ws, 0x0000);//RG
    wsAppendChar(ws, 0x0064);//BA - черный    
    wstrcat(ws, msg->text);
    wsAppendChar(ws, '\n');
    
    msg=msg->next;
  }
  return ws;
}

int CreateWall(CLIST* c)
{
  POSTMSG* msg;
  WSHDR* ws=NULL;
  //char path[128];
  
  if(csm->wall_gui_id)//закрываем до этого созданный гуй
  {
    gui_restarted=1;
    GeneralFunc_flag1(csm->wall_gui_id, 1);
    csm->wall_gui_id=NULL;
  }

  
  selected_group=c;
  msg=(POSTMSG*)c->msglist;
  
  GUI* tvgui=TViewGetGUI(malloc_adr(), mfree_adr());
  TViewSetDefinition(tvgui, &tv_desc);
  patch_header(&hdr);
  SetHeaderToMenu(tvgui, &hdr, malloc_adr());

  if (msg)
    ws=crt_text(msg);
  if (ws==NULL)
    ws=AllocWS(32);
  
  TViewSetText(tvgui, ws, malloc_adr(), mfree_adr());
  /*захват OnRedraw
  memcpy(gui_methods_copy, tvgui->methods, sizeof(gui_methods_copy));
  OnRedraw=(void(*)(void*))gui_methods_copy[0];
  gui_methods_copy[0]=(void*)MyOnRedraw;
  tvgui->methods=gui_methods_copy;
  */
  
 // snprintf(path, 127, "%simg\\%about_h.png", DIR);
 // img_icon=CreateIMGHDRFromPngFile(path, 2);
  
  //if (img_icon)
  //SetDynIcon(0x4E74, img_icon, 0);
  
  return (csm->wall_gui_id=CreateGUI(tvgui));
}

void Wall_Refresh()
{
  if (selected_group)
    CreateWall(selected_group);
}


/*
typedef struct 
{
  void* malloc_adr;
  void* mfree_adr;
  WSHDR* text;  
}
MENU_ITEM_TXT;

void Wall_Refresh()
{
  if (csm->wall_gui_id)
  {
    GUI* gui=FindGUIbyId(csm->wall_gui_id, NULL);
    void* data=GetDataOfItemByID(gui, 4);
    GetProfile();
    MENU_ITEM_TXT* ptr=GetItemTextPtr(data);
    WSHDR* ws=crt_text((POSTMSG*)selected_group->msglist);
    if (ws)
    {
      FreeWS(ptr->text);
      ptr->text=ws;
      SetItemTextLength(ptr, wstrlen(ws));
    }
    if (IsGuiOnTop(csm->wall_gui_id))
      DirectRedrawGUI();
 
  }
}
*/