#include <siemens\swilib.h>
#include "rect_patcher.h"
#include <siemens\pnglist.h>
#include "dyn_images.h"
#include "dyn_theme.h"
#include "process.h"
#include "socket_work.h"
#include "http.h"
#include "vk_api.h"
#include "main.h"
#include "anim_widget.h"
#include "string_util.h"
#include "vk_objects.h"

static int gui_id = 0;
static int timer_id;

static const char percent_t[]="%t";
static const char percent_d[]="%d";

static HEADER_DESC hdr={0,0,0,0,NULL,NULL,LGP_NULL};
static WSHDR  *ws_hdr = NULL;
static int items_count = 0;
static int cursor_pos = 0;
static int loaded_count = 0;

#ifdef ELKA
static int hdr_icon=0x599;
#else
static int hdr_icon=0x5C5;
#endif

void set_DialogsCount(int count)
{
  items_count = count;
}

int get_DialogsCount()
{
  return items_count;
}

static const int menusoftkeys[]={0,1,2};

static SOFTKEY_DESC sk[]=
{
  {0x0018,0x0000,(int)"Обновить"},
  {0x0001,0x0000, (int)"Назад"},
  {0x003D,0x0000,(int)LGP_DOIT_PIC}
};

static SOFTKEYSTAB skt=
{
  sk,0
};

static int items_menu_onkey(void *gui, GUI_MSG *msg)
{
  extern void CreateChat(VkDialog *dialog);
  extern int CreateDebugGUI();
  extern void Logout();
  
  VkDialog *dialog;
  struct list_head *pos;
  int i;
  
  if ((msg->gbsmsg->msg==KEY_DOWN)||(msg->gbsmsg->msg==LONG_PRESS))
  { 
    switch(msg->gbsmsg->submess)
    {     
    case ENTER_BUTTON:
      i = GetCurMenuItem(gui);
      pos = get_ListByIndex(&dialogs, i);
      dialog = list_entry(pos, VkDialog, list);
      CreateChat(dialog);
      break;
    
    case GREEN_BUTTON:
#ifdef DEBUG
      CreateDebugGUI();
#endif
      break;
      
    case LEFT_SOFT:
      if (INET_PROCESS==0)
      {
        INET_PROCESS=LOAD_DIALOGS;
        int offset= items_count-loaded_count;
        SUBPROC((void*)HttpSendReq, url_messages_getConversations(offset, 10, 1, "photo_50,online"));//запрос списка диалогов
        AnimWidget_Wait(1);
      } 
      break;      
      
    case RIGHT_SOFT://close
      return(1);
    }
  }
  return (0);  
}

static void UpdateHeader()
{
  ws_hdr->wsbody[0] = 0; 
  wsAppendChar(ws_hdr, UTF16_ENA_CENTER);
  wsprintf(ws_hdr, percent_t, "Сообщения");
  wsAppendChar(ws_hdr, UTF16_ALIGN_RIGHT);
  wstrcatprintf(ws_hdr, "%d/%d", cursor_pos, items_count);
}

extern void LoadSavedDialogs();

static void items_menu_ghook(void *data, int cmd)
{
  GUI *gui = (GUI*)data;
  
  if (cmd == TI_CMD_CREATE)
  { 
    timer_id = GUI_NewTimer(data);
    hdr.icon = &hdr_icon;
    void *hdr_pointer=  GetHeaderPointer(gui);
    ws_hdr = AllocWS(64);
    UpdateHeader();
    SetHeaderText(hdr_pointer, ws_hdr, malloc_adr(), mfree_adr());
    
    if (list_empty(&dialogs))
    {
      AnimWidget_Wait(0);
      GUI_StartTimerProc(gui, timer_id, 100, LoadSavedDialogs);//загружаем сохраненные диалоги
    }
    
    if (INET_PROCESS == 0)
    {
      int count;
      if (IsGPRSEnabled())
      {
        INET_PROCESS = LOAD_DIALOGS;
        count = 10;
        SUBPROC((void*)HttpSendReq, url_messages_getConversations(0, count, 1, "friend_status,has_photo,photo_50,online"), 1);//запрос списка диалогов
        
        //INET_PROCESS = TEST_SSL_CON;
        //SUBPROC((void*)HttpSendReq, "https://m.mail.ru");
      }
    }

  }
     
  if (cmd == TI_CMD_UNFOCUS)
  {
    AnimWidget_Close();
    DisableDynImages();
    DisableDynTheme();
  }
  
  if (cmd == TI_CMD_FOCUS)
  {
   // if (GetMenuItemCount(gui) == 0)
   //   AnimWidget_Wait_body();
    
    EnableDynImages();
    EnableDynTheme();  
    DisableIDLETMR();
    //Menu_SetItemCountDyn(gui, CLIST_GetCount(csm->dialogs_clist));
  }  
  
  if (cmd == TI_CMD_REDRAW)
  {
    cursor_pos = GetCurMenuItem(gui);
   if (items_count) cursor_pos++;
  
    if (INET_PROCESS == 0)
    {
      if (items_count && cursor_pos == items_count)
      {
        INET_PROCESS = LOAD_DIALOGS;
        SUBPROC((void*)HttpSendReq, url_messages_getConversations(items_count, 10, 1, "has_photo,photo_50,online"), 1);//запрос списка диалогов
        AnimWidget_Wait(2);
      }
    }
    
    if (INET_PROCESS && AnimWidget_IsBottom() && cursor_pos != items_count)
      AnimWidget_Close();
    
  }
  
  if (cmd == TI_CMD_DESTROY)
  {
    GUI_DeleteTimer(gui, timer_id);
    AnimWidget_Close();
    DisableDynTheme();
    DisableDynImages();
    gui_id = 0;
  }
}

extern void LoadUserPhoto();

static void items_menu_iconhndl(void *gui, int curitem, void *user_pointer)
{
  IMGHDR *item_icon = NULL;
  struct list_head *pos;
  VkDialog *dialog;
  VkMsg *msg;
  VkUser *user = NULL;
  VkGroup *group = NULL;
  
  pos = get_ListByIndex(&dialogs, curitem);
  dialog = list_entry(pos, VkDialog, list);
  msg = get_DialogMsg(dialog);
  if (dialog->from_id > 0)
    user = dialog->user;
  else
    group = dialog->group;
  
  WSHDR *ws1 = AllocMenuWS(gui, 64);
  WSHDR *ws2 = AllocMenuWS(gui, 64);
  void *item = AllocMLMenuItem(gui);
  
  wsAppendChar(ws1, UTF16_FONT_SMALL_BOLD);
  wsAppendChar(ws2, UTF16_FONT_SMALL);

  if (user && wstrlen(user->first_name))
  {
    wstrcat(ws1, user->first_name);
    if (wstrlen(user->last_name))
    {
      wsAppendChar(ws1, ' ');
      wstrcat(ws1, user->last_name);
    }
  }
  else
    if (group && wstrlen(group->name))
      wstrcat(ws1, group->name);
    else
      wstrcatprintf(ws1, percent_d, dialog->from_id);
    
    if (wstrlen(msg->text))//в сообщении есть текст
    {
      if (dialog->unread_count && msg->out == 0)//входящие непроч. красным
      {
        wsAppendChar(ws2, UTF16_INK_RGBA);
        wsAppendChar(ws2, 0xff00);//RG
        wsAppendChar(ws2, 0x0064);//BA - красный
      }
      else
      {
        wsAppendChar(ws2, UTF16_INK_RGBA);
        wsAppendChar(ws2, 0x8080);//RG
        wsAppendChar(ws2, 0x8064);//BA - серый
      }
      wstrcat(ws2, msg->text);
    }
    else//иначе
      if (!list_empty(&msg->attachments))//если есть вложение(я)
    {
      int count = count_ListElements(&msg->attachments);
      
      if (count > 1)
        wstrcatprintf(ws2, "%d вложения", count);
      else
      {
        VkAttach *attach = list_entry(msg->attachments.next, VkAttach, list);
        
        switch(attach->type)
        {
        case 1: wstrcatprintf(ws2, percent_t, "Фотография");
        break;
        case 2: wstrcatprintf(ws2, percent_t, "Видео");
        break;
        case 3: wstrcatprintf(ws2, percent_t, "Аудиозапись");
        break;
        case 4: wstrcatprintf(ws2, percent_t, "Документ");
        break;        
        case 5: wstrcatprintf(ws2, percent_t, "Ссылка");
        break;
        case 6: wstrcatprintf(ws2, percent_t, "Товар");
        break;
        case 7: wstrcatprintf(ws2, percent_t, "Подборка товаров");
        break;
        case 8: wstrcatprintf(ws2, percent_t, "Запись на стене");
        break;
        case 9: wstrcatprintf(ws2, percent_t, "Комментарий на стене");
        break;
        case 10: wstrcatprintf(ws2, percent_t, "Стикер");
        break;
        case 11: wstrcatprintf(ws2, percent_t, "Подарок");
        break;
        }
      }
    }
    
//первым рисуется картинка из SetMenuItemIconArray потом SetMenuItemIconIMGHDR
#ifdef NEWSGOLD
    
    if (user && user->photo_50_img)
      item_icon = user->photo_50_img;
    else
      if (group && group->photo_50_img)
        item_icon = group->photo_50_img;
      else
        if (user && user->deactivated || group && group->deactivated)
          item_icon = PNGLIST_GetImgByIndex(0);//deactivated.png
          
    if (item_icon == NULL)
      item_icon = PNGLIST_GetImgByIndex(1);//camera.png
    
    if (item_icon)
      SetMenuItemIconIMGHDR(gui, item, item_icon);
/*    
    if (process == 0)
    {
      ipc.name_to = ipc_my_name;
      ipc.name_from = ipc_my_name;
      ipc.data = &dialogs ;
      GBS_SendMessage(MMI_CEPID, MSG_IPC, IPC_LOAD_PHOTO_PROCESS, &ipc);        
    }
*/    
#endif
    
    SetMLMenuItemText(gui, item, ws1, ws2, curitem);
 //}
 // else
    //SetMLMenuItemText(gui, item, 0, 0, curitem);
}

static const ML_MENU_DESC items_menu_desc=
{
  0x10,
  items_menu_onkey,
  items_menu_ghook,
  NULL,
  menusoftkeys,
  &skt,
#ifdef NEWSGOLD  
  0x40010092, //0x80000083
#else
  0x40014000,
#endif
  items_menu_iconhndl,
  NULL,   //Items
  NULL,   //Procs
  0,   //n
  1 //Добавочных строк  
};

//******************************************************************************

void RefreshDialogsMenu()
{  
  if (gui_id)
  {
    GUI* gui = FindGUIbyId(gui_id, NULL);
    csm->list = &dialogs;
    GUI_StartTimerProc(gui, timer_id, 100, LoadUserPhoto);//ищем авки в cache    
    items_count = count_ListElements(&dialogs);
    Menu_SetItemCountDyn(gui, items_count);
  }
}

//******************************************************************************

void CreateDialogsMenu()
{
  int item_count = count_ListElements(&dialogs);
  void *ma = malloc_adr(); 
  void *mf = mfree_adr();
  void *gui = GetMultiLinesMenuGUI(ma, mf); 
  SetMenuToGUI(gui,&items_menu_desc);
  SetMenuItemCount(gui, item_count);
  SetCursorToMenuItem(gui, 0);
  patch_header(&hdr);
  SetHeaderToMenu(gui,&hdr,ma); 
  gui_id = CreateGUI(gui); 
}


