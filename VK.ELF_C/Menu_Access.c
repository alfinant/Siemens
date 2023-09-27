#include <siemens\swilib.h>
#include "rect_patcher.h"
#include "dyn_images.h"
#include "dyn_theme.h"
#include "anim_widget.h"
#include "main.h"

#include "http.h"
#include "process.h"

static const char percent_t[]="%t";
static const char HEADER_TEXT[]="Вконтакте";

static char* action_url=NULL;

static HEADER_DESC hdr={0,0,0,0,NULL,NULL,LGP_NULL};

static const int mmenusoftkeys[]={0,1,2};

static SOFTKEY_DESC sk[]=
{
  {0x0018,0x0000,(int)"Разреш."},
  {0x0001,0x0000, (int)"Отмена"},
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
    csm->access_dialog_gui_id=NULL;
    return (0);
  }
  
  if ((msg->gbsmsg->msg==KEY_DOWN)||(msg->gbsmsg->msg==LONG_PRESS))
  { 
    switch(msg->gbsmsg->submess)
    {
    case LEFT_SOFT:
      AnimWidget_Wait_headline(); 
      process=OAUTH_GET_TOKEN;
      SUBPROC((void*)HttpSendReq, action_url);
      
     // if(gui_id)//закрываем гуй
        //GeneralFunc_flag1(gui_id, 1);
      break;
      
    case RIGHT_SOFT:
      csm->access_dialog_gui_id=NULL;
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
    LoadDynTheme();
    //LoadDynImages();
    
    //hdr_pic=GetDynPicNum(VK_HEADER_ICON);
    //hdr.icon=&hdr_pic;
    void* hdr_pointer=GetHeaderPointer(data);
    WSHDR* ws=AllocWS(32);
    wsprintf(ws, percent_t, HEADER_TEXT);
    SetHeaderText(hdr_pointer, ws, malloc_adr(), mfree_adr());
  }
  
  if (cmd==TI_CMD_UNFOCUS)
  {
    AnimWidget_Close();
    DisableDynImages();
    DisableDynTheme();
  }
  
  if (cmd==TI_CMD_FOCUS)
  {
    if (process)
      AnimWidget_Wait_headline(); 
    
    EnableDynImages();
    EnableDynTheme();  
    DisableIDLETMR();
  }
  
  if (cmd==TI_CMD_DESTROY)
  {
    DisableDynTheme();
    DisableDynImages();
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
  {4,60,238,287},
#else
  {4,28,131,150},
#endif
  8,
  0x64,
  0x65
};


int CreateAccessDialog(char* url)
{
  WSHDR* ws;
  
  action_url=url;
  
  void* tvgui=TViewGetGUI(malloc_adr(), mfree_adr());
  TViewSetDefinition(tvgui, &tv_desc);
  patch_header(&hdr);
  SetHeaderToMenu(tvgui, &hdr, malloc_adr());

  ws=AllocWS(256);

  wsAppendChar(ws, UTF16_FONT_MEDIUM_BOLD);
  wsAppendChar(ws, UTF16_INK_RGBA);
  wsAppendChar(ws, 0x0000);//RG
  wsAppendChar(ws, 0x0064);//BA-черный
  wstrcatprintf(ws, "%s", "VK.ELF ");

  wsAppendChar(ws, UTF16_FONT_SMALL);
  wsAppendChar(ws, UTF16_INK_RGBA);
  wsAppendChar(ws, 0x8080);//RG
  wsAppendChar(ws, 0x8064);//BA-серый
  wstrcatprintf(ws, "%t", "запрашивает доступ к Вашему аккаунту\n\n");
  
  wsAppendChar(ws, UTF16_FONT_SMALL_BOLD);
  wsAppendChar(ws, UTF16_INK_RGBA);
  wsAppendChar(ws, 0x0000);//RG
  wsAppendChar(ws, 0x0064);//BA - черный  
  wstrcatprintf(ws, "%t", "Приложению будут доступны:\n");

  wsAppendChar(ws, UTF16_FONT_SMALL);
  wsAppendChar(ws, UTF16_INK_RGBA);
  wsAppendChar(ws, 0x8080);//RG
  wsAppendChar(ws, 0x8064);//BA - серый
  wstrcatprintf(ws, "%t", "- сообщения\n"
                "- список Ваших друзей\n"
                "- информация\n  страницы\n"
                  "- фотографии\n"
                    "- доступ в любое\n  время");
  
  patch_header(&hdr);
  TViewSetText(tvgui, ws, malloc_adr(), mfree_adr());
  
  return (csm->access_dialog_gui_id=CreateGUI(tvgui));
}

