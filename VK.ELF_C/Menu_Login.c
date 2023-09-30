#include <siemens\swilib.h>
#include "rect_patcher.h"
#include "dyn_images.h"
#include "dyn_theme.h"
#include "anim_widget.h"
#include "main.h"
#include "socket_work.h"
//#include "ssl_work.h
#include "http.h"
#include "process.h"
#include "vk_api.h"

static int gui_id = 0;

static const char percent_t[]="%t";
static const char HEADER_TEXT[]="Вконтакте";

extern int CreateDebugGUI();

int vk_com_parsed=0;
char action_url[256];
char login[32];
char pass[32];
char captcha_key[32];
char captcha_sid[32];
//static char post_data[128];


static HEADER_DESC hdr = {0,0,0,0,NULL,NULL,LGP_NULL};

//static const int softkeys[] = {0, 1, 2};

static SOFTKEY_DESC sk[]=
{
  {0x0018, 0x0000, (int)"Ок "},
  {0x0001, 0x0000, (int)"Выход"},
  {0x003D, 0x0000, (int)LGP_DOIT_PIC}
};

static SOFTKEYSTAB skt=
{
  sk, 0
};

static void ed_inp_locret(void){}

static int ed_inp_onkey(GUI *data, GUI_MSG *msg)
{
  EDITCONTROL ec_login;
  EDITCONTROL ec_pass;
  EDITCONTROL ec_captcha;
  
  if (msg->keys==0xFFF)  // OK
  {
    ExtractEditControl(data, 2, &ec_login);//email orr number
      ws_2str(ec_login.pWS, login, 31);
      
      ExtractEditControl(data, 4, &ec_pass);//pass
      ws_2str(ec_pass.pWS, pass, 31);
      
      *captcha_key = '\0';
      if (ExtractEditControl(data,6,&ec_captcha))//captcha_key
        ws_2str(ec_captcha.pWS, captcha_key, 31); 
      
      if (wstrlen(ec_login.pWS) && wstrlen(ec_pass.pWS))
      {
        INET_PROCESS = AUTH_DIRECT;
        //sock_keepalive = 1;
        SUBPROC((void *)HttpSendReq, url_auth_direct(login, pass, STATUS+MESSAGES+FRIENDS+GROUPS), 0);
        AnimWidget_Wait(2);
      }
      else
        ShowMSG(1, (int)"Заполните все поля");    
  }
  
  if (msg->keys==0xFFE)  // close
  {
    return (1);
  }
 
  if ((msg->gbsmsg->msg==KEY_DOWN)||(msg->gbsmsg->msg==LONG_PRESS))
  { 
    switch(msg->gbsmsg->submess)
    {
    case GREEN_BUTTON: CreateDebugGUI();
    break;
    }
  }

  return(0);
}

static void ed_inp_ghook(GUI *data, int cmd)
{
  static SOFTKEY_DESC ok = {0x0FFF, 0x0000,(int)"OK"};
  static SOFTKEY_DESC close = {0x0FFE, 0x0000,(int)"Отмена"};

 // static int hdr_pic;
   
  if (cmd == TI_CMD_CREATE)
  {    
    //hdr_pic=GetDynPicNum(VK_HEADER_ICON);
    //hdr.icon=&hdr_pic;
    
    void *hdr_pointer = GetHeaderPointer(data);
    WSHDR *ws = AllocWS(32);
    wsprintf(ws, percent_t, HEADER_TEXT);
    SetHeaderText(hdr_pointer, ws, malloc_adr(), mfree_adr());   
  }
     
  if (cmd == TI_CMD_UNFOCUS)
  {
    AnimWidget_Close();
    
    DisableDynImages();  
    DisableDynTheme();
  }
  
  if (cmd == TI_CMD_FOCUS)
  {
    EnableDynImages();
    EnableDynTheme();
    DisableIDLETMR();
    
    if (INET_PROCESS == AUTH_DIRECT)
      AnimWidget_Wait(2);
  }  
  
  if (cmd == TI_CMD_REDRAW)
  {
    //EnableDynImages();    
    SetSoftKey(data, &ok, SET_SOFT_KEY_N);
    int i = EDIT_GetCursorPos(data);
   
    if (i == 1)
      SetSoftKey(data, &close, !SET_SOFT_KEY_N);
  }
  
  if (cmd == TI_CMD_DESTROY)
  { 
    DisableDynTheme();
    DisableDynImages();
    gui_id = 0;
  }
}

static INPUTDIA_DESC ed_inp_desc=
{
  1,
  ed_inp_onkey,
  ed_inp_ghook,
  (void *)ed_inp_locret,
  0,
  &skt,
#ifdef ELKA  
  {1,56,238,287},
#else
  {1,23,130,154},
#endif
  FONT_SMALL,
  100,
  101,
  0,
//  0x00000001 - Выровнять по правому краю
//  0x00000002 - Выровнять по центру
//  0x00000004 - Инверсия знакомест
//  0x00000008 - UnderLine
//  0x00000020 - Не переносить слова
//  0x00000200 - bold
  0,
//  0x00000002 - ReadOnly
//  0x00000004 - Не двигается курсор
//  0x40000000 - Поменять местами софт-кнопки
  0x40000000
};

int CreateLoginDialog()
{
  void *ma = malloc_adr();
  void *eq;
  EDITCONTROL ec;

  if (gui_id)//закрываем до этого созданный гуй
  {
    GeneralFunc_flag1(gui_id, 1);
    gui_id = 0;
  }
  
  WSHDR ws;
  unsigned short wsbody[256];
  
  CreateLocalWS(&ws, wsbody, 255);
  
  PrepareEditControl(&ec);
  eq = AllocEQueue(ma, mfree_adr());

  wsprintf(&ws, "\n%t", "Телефон или email:");
  ConstructEditControl(&ec, ECT_HEADER, ECF_APPEND_EOL, &ws, 32);
  AddEditControlToEditQend(eq, &ec, ma);
  
  wsprintf(&ws, "%s", "");
  ConstructEditControl(&ec, ECT_NORMAL_TEXT, ECF_NORMAL_STR | ECF_APPEND_EOL, &ws, 32);
  AddEditControlToEditQend(eq, &ec, ma);
  
  wsprintf(&ws, "%t", "Пароль:");
  ConstructEditControl(&ec, ECT_HEADER, ECF_APPEND_EOL, &ws, 32);
  AddEditControlToEditQend(eq, &ec, ma);
  
  ConstructEditControl(&ec, ECT_NORMAL_TEXT, ECF_PASSW | ECF_APPEND_EOL , NULL, 32);
  AddEditControlToEditQend(eq, &ec, ma); 
  
  patch_header(&hdr);
  patch_input(&ed_inp_desc);
  
  return (gui_id = CreateInputTextDialog(&ed_inp_desc, &hdr, eq, 1, 0));
}
