#include <siemens\swilib.h>
#include "rect_patcher.h"
#include "dyn_images.h"
#include "dyn_theme.h"
#include "http.h"
#include "process.h"
#include "vk_api.h"
#include "main.h"
#include "anim_widget.h"

extern const TTime GMT;

static int gui_id = 0;

static const char percent_t[]="%t";
static const char percent_d[]="%d";
static const char MY_NAME_IN_CHAT[]="Вы";

static int ec_n;
static int close_by_user;
static int gui_restarted;
void CreateChat(VkDialog *dialog);

#ifdef ELKA
static int hdr_icon=0x599;
#else
static int hdr_icon=0x5C5;
#endif

static char utf8_str[256];

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

extern int CreateDebugGUI();

static void ed_options_handler(USR_MENU_ITEM *item)
{
  int i=item->cur_item;
  
  if (item->type==0)
  {
    switch(i)
    {
    case 0:
      wsprintf(item->ws, percent_t, "Очистить чат");
      break;
    }
  }
  
  if (item->type==1)
  {
    switch(i)
    {
    case 0:
      if (INET_PROCESS == 0)
      {
        //process=DELETE_DIALOG;
        //SUBPROC((void *)HttpSendReq, messages_deleteDialog(csm->chat->user_id, 10000));
        //GBS_SendMessage(MMI_CEPID, 0x6C20, 0x1D, 0);//при закрытии
        break;
      }
    }
  }
  
}

static int ed_inp_onkey(GUI *gui, GUI_MSG *msg)
{
  EDITCONTROL ec;
  int result_length;
  
  if (msg->keys==0xFFF)//левый софт
  {
    AnimWidget_Close();
    EDIT_OpenOptionMenuWithUserItems(gui, ed_options_handler, NULL, 1);
    return(-1);
  }
  
  if (msg->keys==1)//закрытие
  {
    close_by_user=1;
    gui_id = 0;
    return (0);
  }
  
  if ((msg->gbsmsg->msg==KEY_DOWN)||(msg->gbsmsg->msg==LONG_PRESS))
  { 
    switch(msg->gbsmsg->submess)
    {    
    case VOL_UP_BUTTON:
      EDIT_SetFocus(gui, 1);
      return(-1);
      
    case VOL_DOWN_BUTTON:
      EDIT_SetFocus(gui, ec_n);
      return(-1);  
     
    case GREEN_BUTTON:
/*      if (process==0)
      {
        if (ExtractEditControl(gui, ec_n, &ec))
        {
          if (wstrlen(ec.pWS))
          {
            ws_2utf8(ec.pWS, utf8_str, &result_length, 255);
            process=CHECK_NEW_MESSAGES;
            char* params=execute_sendAndGet(csm->chat->user_id, utf8_str, last_message_id);
            SUBPROC((void *)HttpSendPostReq, API_METHOD_EXECUTE_SEND_URL, params);          
          }
        }
      }  
      else
        ShowMSG(1, (int)"Повторите позже...");
      */
    break;
  }
  }
  return(0);//Do standart keys
  //1: close  
}

static void ed_inp_ghook(GUI *gui, int cmd)
{
  static SOFTKEY_DESC sk={0x0FFF,0x0000,(int)"Опции"};
  
  if (cmd==TI_CMD_CREATE)
  {
    EDIT_SetFocus(gui, ec_n);
    
    hdr.icon=&hdr_icon;
    void* hdr_pointer=GetHeaderPointer(gui);
    WSHDR* ws=AllocWS(32);
    VkDialog *dialog = csm->chat;
    VkUser *user = csm->chat->user;
    
    //wsAppendChar(ws, UTF16_ENA_CENTER);
    if (user && wstrlen(user->first_name))
      wstrcat(ws, user->first_name);
    else
      wstrcatprintf(ws, percent_d, dialog->from_id);
    
    SetHeaderText(hdr_pointer, ws, malloc_adr(), mfree_adr());
    
    LoadDynTheme();
    //LoadDynImages();
    
    if (gui_restarted==0)
    {
      if (INET_PROCESS == 0)
      {
        //process=LOAD_HISTORY;
       // SUBPROC((void *)HttpSendReq, execute_getHistory(csm->chat_c->user_id, 10));
        
       // AnimWidget_Wait(0);
      }
    }
  }
     
  if (cmd==TI_CMD_UNFOCUS)
  {
    AnimWidget_Close();
    
    DisableDynImages();
    DisableDynTheme();
  }
   
  if (cmd==TI_CMD_FOCUS) 
  {
    //EDIT_SetFocus(data, ec_n);
    //EDIT_SetCursorPos(data, ec_n);
    
    if (INET_PROCESS == LOAD_HISTORY)
      AnimWidget_Wait(0);   
        
    EnableDynImages();
    EnableDynTheme();  
    DisableIDLETMR();
  }  
  
  if (cmd==TI_CMD_SUBFOCUS_CHANGE)
  {
  }
  
  if (cmd==TI_CMD_REDRAW)
  {
    EnableDynImages(); 
    SetSoftKey(gui, &sk, 0);//0-left soft
  }
  
  if (cmd==TI_CMD_DESTROY)
  {
    DisableDynTheme();
    DisableDynImages();
    //если чат был закрыт вручную
    if (close_by_user)
    {
      //if (csm->chat_c->msglist==NULL)//значит история сообщений очищена.Удаляем контакт из списка
      //  DeleteContact(&csm->dialogs_list, csm->chat_c->user_id);
    }
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
  &ed_menu_skt,
#ifdef ELKA  
  {1,56,238,287},
#else
  {1,23,130,154},
#endif
  FONT_SMALL,
  100,
  101,
  0,
  0,
  0x40000000
};

void CreateChat(VkDialog *dialog)
{
  void* ma;
  void *eq;
  EDITCONTROL ec;
  EDITC_OPTIONS ec_options; 
  VkMsg *msg;
  
  TDate t_date;
  TTime time;
  TDate s_date;
  int timestap; 
  TDate phone_date;
  TTime phone_time; 
  
  WSHDR ws;
  unsigned short wsbody[512];
 
  if (dialog == NULL)
    return;

  VkUser *user = dialog->user;
  
  int color = 1;//черный
  int font = 1;

  csm->chat = dialog;
  
  close_by_user = 0;
  gui_restarted = 0;
  
  if (gui_id)//закрываем до этого созданный гуй
  {
    GeneralFunc_flag1(gui_id, 1);
    gui_id = 0;
    gui_restarted = 1;
  }
  
  CreateLocalWS(&ws, wsbody, 511);
  
  ec_n=0;//обнулить счетчик эдитконтролов
  PrepareEditControl(&ec);
  ma=malloc_adr();
  eq=AllocEQueue(ma,mfree_adr());

  msg = get_DialogMsg(dialog);

  
//  while (msg)
//  {
    wsbody[0]=0;
    
    wsAppendChar(&ws, UTF16_FONT_SMALL_BOLD);
    
    if (msg->out)
    {
      wsAppendChar(&ws, UTF16_INK_RGBA);
      wsAppendChar(&ws, 0xFF00);//RG
      wsAppendChar(&ws, 0x0064);//BA - red
    }
    else
    {
      wsAppendChar(&ws, UTF16_INK_RGBA);
      wsAppendChar(&ws, 0x5D80);//RG
      wsAppendChar(&ws, 0xA664);//BA - вк синий
    }
    
    if (msg->out)
      wstrcatprintf(&ws, percent_t, MY_NAME_IN_CHAT);
    else
    {
      if (user && wstrlen(user->first_name))
        wstrcat(&ws, user->first_name);
      else
        wstrcatprintf(&ws, percent_d, dialog->from_id);
    }
    
    wsAppendChar(&ws, ':');
    wsAppendChar(&ws, ' ');
    
    wsAppendChar(&ws, UTF16_FONT_SMALL);
    wsAppendChar(&ws, UTF16_ALIGN_RIGHT);
    wsAppendChar(&ws, UTF16_INK_RGBA); 
    wsAppendChar(&ws, 0x8080);//RG
    wsAppendChar(&ws, 0x8064);//BA - серый
    
    //TDateTimeSettings* time_set=RamDateTimeSettings();
    //int time_zone=GetTimeZoneShift(NULL, NULL, time_set->timeZone) * 60;
    
    GetDateTime(&phone_date, &phone_time);
    
    timestap=msg->date + (GMT.hour*3600)+(GMT.min*60);
    s_date.year=1970;
    s_date.month=1;
    s_date.day=1;
    GetDateTimeFromSeconds(&timestap, &t_date, &time, &s_date);
    
    if (phone_date.day==t_date.day && phone_date.month==t_date.month && phone_date.year==t_date.year)
      wstrcatprintf(&ws, "%d:%02d", time.hour, time.min);
    else
      if ((phone_date.day-1)==t_date.day && phone_date.month==t_date.month && phone_date.year==t_date.year)
        wstrcatprintf(&ws, "%t %d:%02d", "вчера в", time.hour, time.min);
    else
      wstrcatprintf(&ws, "%d.%02d %d:%02d", t_date.day, t_date.month, time.hour, time.min);    
    
    ConstructEditControl(&ec, ECT_HEADER, ECF_APPEND_EOL, &ws, wstrlen(&ws));
    ec_n=AddEditControlToEditQend(eq, &ec, ma);    
    
    wsbody[0]=0;
    
    wsAppendChar(&ws, UTF16_ALIGN_LEFT);
    wsAppendChar(&ws, UTF16_INK_RGBA);
    wsAppendChar(&ws, 0x0000);//RG
    wsAppendChar(&ws, 0x0064);//BA - черный}  
    
    if (msg->text)
      wstrcat(&ws, msg->text);
    
    ConstructEditControl(&ec, ECT_NORMAL_TEXT, ECF_APPEND_EOL, &ws, wstrlen(&ws));
    PrepareEditCOptions(&ec_options);
    SetFontToEditCOptions(&ec_options, font);
    CopyOptionsToEditControl(&ec,&ec_options);
    ec_n=AddEditControlToEditQend(eq, &ec, ma);
    
//  }
  
  wsbody[0]=0;
  ConstructEditControl(&ec,ECT_NORMAL_TEXT, ECF_NORMAL_STR | ECF_APPEND_EOL, &ws, 256);
  PrepareEditCOptions(&ec_options);
  SetPenColorToEditCOptions(&ec_options,color);
  SetFontToEditCOptions(&ec_options, font);
  CopyOptionsToEditControl(&ec,&ec_options);   
  ec_n=AddEditControlToEditQend(eq, &ec, ma);
  
  patch_header(&hdr);
  gui_id = CreateInputTextDialog(&ed_inp_desc, &hdr, eq, 1, NULL);
}
