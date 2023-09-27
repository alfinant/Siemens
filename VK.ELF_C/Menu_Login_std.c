#include <siemens\swilib.h>
#include "rect_patcher.h"
#include "dyn_images.h"
#include "dyn_theme.h"
#include "anim_widget.h"
#include "main.h"
#include "socket_work.h"
#include "http.h"
#include "process.h"

static const char percent_t[]="%t";
static const char HEADER_TEXT[]="Вконтакте";

extern int CreateDebugGUI();

int vk_com_parsed=0;
char action_url[256];
char email[32];
char pass[32];
char captcha_key[32];
char captcha_sid[32];
static char post_data[128];

static HEADER_DESC hdr={0,0,0,0,NULL,NULL,LGP_NULL};

static SOFTKEY_DESC ed_menu_sk[]=
{
  {0x0018,0x0000,(int)"Лев"},
  {0x0001,0x0000,(int)"Прав"},
  {0x003D,0x0000,(int)LGP_DOIT_PIC}
};

static SOFTKEYSTAB ed_menu_skt=
{
  ed_menu_sk,0
};

static void ed_inp_locret(void){}

static int ed_inp_onkey(GUI *data, GUI_MSG *msg)
{
  EDITCONTROL ec;
  
  if ((msg->gbsmsg->msg==KEY_DOWN)||(msg->gbsmsg->msg==LONG_PRESS))
  { 
    switch(msg->gbsmsg->submess)
    {
    case LEFT_SOFT:
      
      AnimWidget_Wait_bottom(); 
      
      ExtractEditControl(data, 2, &ec);//email
      ws_2str(ec.pWS, email, 31);
      
      ExtractEditControl(data, 4, &ec);//pass
      ws_2str(ec.pWS, pass, 31);
      
      *captcha_key='\0';
      if(ExtractEditControl(data,6,&ec))//captcha_key
        ws_2str(ec.pWS, captcha_key, 31); 
      
      if (vk_com_parsed == 0)
      {
        process=AUTH_PARSE_M_VK_COM_LOGIN;
        sock_keepalive=1;
        SUBPROC((void *)HttpSendReq, "https://m.vk.com/login");
      }
      else
      {
        process=AUTH_SEND_LOGIN_PASS;
        
        if (*captcha_key)
          snprintf(post_data, 127, "email=%s&pass=%s&captcha_sid=%s&captcha_key=%s", email, pass, captcha_sid, captcha_key); 
        else
          snprintf(post_data, 127, "email=%s&pass=%s", email, pass);
        
        sock_keepalive=1;
        SUBPROC((void*)HttpSendPostReq, action_url, post_data);
      }
      break;
    
    case GREEN_BUTTON: CreateDebugGUI();
    break;
    
  }
  }
  return(0);
}


static void ed_inp_ghook(GUI *data, int cmd)
{
 // static int hdr_pic;
  static SOFTKEY_DESC sk = {0x0FFF,0x0000,(int)"Войти"};
   
  if (cmd == TI_CMD_CREATE)
  {    
    //LoadDynTheme();
    //LoadDynImages();

    //hdr_pic=GetDynPicNum(VK_HEADER_ICON);
    //hdr.icon=&hdr_pic;
    
    void* hdr_pointer=GetHeaderPointer(data);
    WSHDR* ws=AllocWS(32);
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
    if (process)
      AnimWidget_Wait_bottom();
    
    EnableDynImages();
    EnableDynTheme();  
    DisableIDLETMR();
  }  
  
  if (cmd == TI_CMD_REDRAW)
  {
    EnableDynImages(); 
    SetSoftKey(data, &sk, 0);
  }
  
  if (cmd == TI_CMD_DESTROY)
  { 
    DisableDynTheme();
    DisableDynImages();
  }
  
}

static INPUTDIA_DESC ed_inp_desc=
{
  1,
  ed_inp_onkey,
  ed_inp_ghook,
  (void *)ed_inp_locret,
  0,
  &ed_menu_skt,
  {0,0,0,0},
  4,
  100,
  101,
  0,
  0,
  0x40000000
};

int CreateLoginDialog(int flag)
{
  void *ma = malloc_adr();
  void *eq;
  EDITCONTROL ec;

  if (csm->login_dialog_gui_id)//закрываем до этого созданный гуй
  {
    GeneralFunc_flag1(csm->login_dialog_gui_id, 1);
    csm->login_dialog_gui_id=NULL;
  }
  
  WSHDR ws;
  unsigned short wsbody[256];
  
  CreateLocalWS(&ws, wsbody, 255);
  
  PrepareEditControl(&ec);
  eq=AllocEQueue(ma,mfree_adr());

  wsprintf(&ws, "\n%t", "Телефон или email:");
  ConstructEditControl(&ec, ECT_HEADER, ECF_APPEND_EOL, &ws, 32);
  AddEditControlToEditQend(eq, &ec, ma);
  
  wsprintf(&ws, "%s", "alfinant@gmail.com");
  ConstructEditControl(&ec,ECT_NORMAL_TEXT, ECF_NORMAL_STR | ECF_APPEND_EOL, NULL, 32);
  AddEditControlToEditQend(eq, &ec, ma);
  
  wsprintf(&ws, "%t", "Пароль:");
  ConstructEditControl(&ec, ECT_HEADER, ECF_APPEND_EOL, &ws, 32);
  AddEditControlToEditQend(eq, &ec, ma);
  
  ConstructEditControl(&ec, ECT_NORMAL_TEXT, ECF_PASSW | ECF_APPEND_EOL , NULL, 32);
  AddEditControlToEditQend(eq, &ec, ma); 
  
  if (flag)
  {
    wsprintf(&ws, "%c\n%t", FIRST_UCS2_BITMAP + 0, "Код с картинки:");
    ConstructEditControl(&ec, ECT_HEADER, ECF_APPEND_EOL, &ws, 32);
    AddEditControlToEditQend(eq, &ec, ma);
     
    ConstructEditControl(&ec,ECT_NORMAL_TEXT, ECF_NORMAL_STR | ECF_APPEND_EOL, NULL, 32);
    AddEditControlToEditQend(eq, &ec, ma);      
  }
  
  patch_header(&hdr);
  patch_input(&ed_inp_desc);
  
  return (csm->login_dialog_gui_id=CreateInputTextDialog(&ed_inp_desc,&hdr,eq,1,0));
}
