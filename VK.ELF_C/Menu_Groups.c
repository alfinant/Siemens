#include <siemens\swilib.h>
#include "rect_patcher.h"
#include "dyn_images.h"
#include "dyn_theme.h"
#include "socket_work.h"
#include "http.h"
#include "process.h"
#include "vk_api.h"
#include "main.h"
//#include "chat.h"
#include "anim_widget.h"

static int gui_id = 0;
static int timer_id;

static const char percent_t[]="%t";
static const char percent_d[]="%d";

extern int CreateDebugGUI();
extern int CreateWall(VkGroup *group);
extern void LoadSavedGroups();

#ifdef ELKA
static int hdr_icon=0x599;
#else
static int hdr_icon=0x5C5;
#endif

static HEADER_DESC hdr={0,0,0,0,NULL,NULL,LGP_NULL};
static WSHDR *ws_hdr = NULL;
static int groups_count = 0;
static int cursor_pos = 0;
static int loaded_count = 0;

static const int menusoftkeys[]={0,1,2};

static SOFTKEY_DESC sk[]=
{
  {0x0018,0x0000,(int)"обновить"},
  {0x0001,0x0000, (int)"Назад"},
  {0x003D,0x0000,(int)LGP_DOIT_PIC}
};

static SOFTKEYSTAB skt=
{
  sk,0
};

//extern int CreateWall(VkGroup *group);

static void UpdateHeader()
{
  ws_hdr->wsbody[0] = 0; 
  wsAppendChar(ws_hdr, UTF16_ENA_CENTER);
  wsprintf(ws_hdr, percent_t, "Группы");
  wsAppendChar(ws_hdr, UTF16_ALIGN_RIGHT);
  wstrcatprintf(ws_hdr, "%d/%d", cursor_pos, groups_count);
}

void set_GroupsCount(int count)
{
  groups_count = count;
}

int get_GroupsCount()
{
  return groups_count;
}

static int items_menu_onkey(void *gui, GUI_MSG *msg)
{ 
  int i;
  VkGroup *group;
  struct list_head *pos;
  
  if ((msg->gbsmsg->msg==KEY_DOWN)||(msg->gbsmsg->msg==LONG_PRESS))
  {
    switch(msg->gbsmsg->submess)
    {
    case UP_BUTTON:
      break;
      
    case ENTER_BUTTON://открыть стену группы
      i=GetCurMenuItem(gui);
      pos = get_ListByIndex(&my_groups, i);
      group = list_entry(pos, VkGroup, list);
      CreateWall(group);
      break;
    
    case GREEN_BUTTON:
#ifdef DEBUG
      CreateDebugGUI();
#endif
      break;
    
    case LEFT_SOFT://обновить
      if (IsGPRSEnabled())
      {
        if (INET_PROCESS==0)
        {
          //INET_PROCESS=TEST_SSL_CON;
          //SUBPROC((void *)HttpSendReq, "https://team-sc.ru", 1);
          INET_PROCESS=LOAD_GROUPS;
          int offset=0;
          SUBPROC((void *)HttpSendReq, url_groups_get(offset, 100), 1);
          AnimWidget_Wait(0);
          //AnimWidget_Wait_headline();
        }
      }      
      break;
      
    case RIGHT_SOFT:
      return(1);//close
    }
  }
  return (0); 
}

static void items_menu_ghook(void *gui, int cmd)
{
  if (cmd==TI_CMD_CREATE)
  { 
    timer_id = GUI_NewTimer(gui);
    hdr.icon = &hdr_icon;
    void *hdr_pointer=  GetHeaderPointer(gui);
    ws_hdr=AllocWS(64);
    //wsprintf(hdr_ws, percent_t, HEADER_TEXT);
    //SetHeaderText(hdr_pointer, hdr_ws, malloc_adr(), mfree_adr());     
    UpdateHeader();
    SetHeaderText(hdr_pointer, ws_hdr, malloc_adr(), mfree_adr());
    
    //LoadDynTheme();
    //LoadDynImages();
    
    if (list_empty(&my_groups))
    {
      AnimWidget_Wait(0);
      GUI_StartTimerProc(gui, timer_id, 100, LoadSavedGroups);//загружаем сохраненные диалоги
      return;
    }    
/*    
    if (IsGPRSEnabled())
      {
        if (INET_PROCESS==0 && list_empty(&my_groups))
        {
          INET_PROCESS=LOAD_GROUPS;
          SUBPROC((void *)HttpSendReq, url_groups_get(0, 100), 1);
          //AnimWidget_Wait(0);
        }
      }
    */
  }
     
  if (cmd==TI_CMD_UNFOCUS)
  {
    AnimWidget_Close();
    //DisableDynImages();
    DisableDynTheme();
  }
  
  if (cmd==TI_CMD_FOCUS)
  {
    //if (GetMenuItemCount(gui)==0)
      //AnimWidget_Wait(0);
    
    EnableDynImages();
    EnableDynTheme();  
    DisableIDLETMR();
  }  
  
  if (cmd==TI_CMD_REDRAW)
  {
    cursor_pos = GetCurMenuItem(gui);
    if (loaded_count)
      cursor_pos++;
    UpdateHeader();
    EnableDynImages();
  }
  
  if (cmd==TI_CMD_DESTROY)
  {
    GUI_DeleteTimer(gui, timer_id);
    gui_id=0;
    AnimWidget_Close();
    DisableDynTheme();
    DisableDynImages();
  }
}

static void items_menu_iconhndl(void *gui, int curitem, void *user_pointer)
{
  
  IMGHDR *item_icon = NULL;
  struct list_head *pos;
  VkGroup *group;
  
  pos = get_ListByIndex(&my_groups, curitem);
  group = list_entry(pos, VkGroup, list);
  
  WSHDR *ws1=AllocMenuWS(gui,64);
  WSHDR *ws2=AllocMenuWS(gui,64);
  void* item=AllocMLMenuItem(gui);

  wsAppendChar(ws1, UTF16_FONT_SMALL_BOLD);
  wsAppendChar(ws2, UTF16_FONT_SMALL);
  
  if (group)
  {
    /*wsAppendChar(ws1, UTF16_INK_RGBA);
    wsAppendChar(ws1, 0x5D80);//RG
    wsAppendChar(ws1, 0xA664);//BA - вк синий  */
    
    if (group->name)
      wstrcat(ws1, group->name);
    else
      wstrcatprintf(ws1,percent_d, group->id);
    
    wsAppendChar(ws2, UTF16_INK_RGBA);
    wsAppendChar(ws2, 0x8080);//RG
    wsAppendChar(ws2, 0x8064);//BA - серый
    /*wsAppendChar(ws2, 0x5D80);//RG
    wsAppendChar(ws2, 0xA664);//BA - вк синий */
    
    if (group->screen_name)
      wstrcat(ws2, group->screen_name);    
    
    //SetMenuItemIconArray(gui, item, &i1_pic); //первым рисуется картинка из SetMenuItemIconArray
#ifdef NEWSGOLD
    
    if (group->photo_50_img)
      item_icon = group->photo_50_img;
    else
      if (group->deactivated)
        item_icon = PNGLIST_GetImgByIndex(0);//deactivated.png
    
    if (item_icon == NULL)
      item_icon = PNGLIST_GetImgByIndex(1);//camera.png
    
    if (item_icon)
      SetMenuItemIconIMGHDR(gui, item, item_icon);
#endif
 /*     
      if (process==0) 
      {
        csm->cl=csm->groups_list;
        csm->c=csm->cl;
        process=LOAD_USERS_PHOTO_FROM_INET;
        ipc.name_to=ipc_my_name;
        ipc.name_from=ipc_my_name;
        ipc.data=0;
        GBS_SendMessage(MMI_CEPID, MSG_IPC, IPC_RUN_MAIN_PROCESS, &ipc);        
      } 
  */
    SetMLMenuItemText(gui, item, ws1, ws2, curitem);
  }
  else
    SetMLMenuItemText(gui, item, 0, 0, curitem);
}

static const ML_MENU_DESC items_menu_desc=
{
  8,
  items_menu_onkey,
  items_menu_ghook,
  NULL,
  menusoftkeys,
  &skt,
  0x40010092, //0x40010092//0x80000083
  items_menu_iconhndl,
  NULL,   //Items
  NULL,   //Procs
  0,   //n
  1 //Добавочных строк  
};

//******************************************************************************
void RefreshGroupsMenu()
{  
  if (gui_id)
  {
    GUI* gui = FindGUIbyId(gui_id, NULL);
    //csm->list = &dialogs;
    //GUI_StartTimerProc(gui, timer_id, 100, LoadUserPhoto);//ищем авки в cache    
    loaded_count = count_ListElements(&my_groups);
    Menu_SetItemCountDyn(gui, loaded_count);
  }
}
//******************************************************************************

int CreateGroupsMenu()
{
  void *ma=malloc_adr(); 
  void *mf= mfree_adr();
  void *gui=GetMultiLinesMenuGUI(ma, mf); 
  SetMenuToGUI(gui,&items_menu_desc); 
  SetMenuItemCount(gui, count_ListElements(&my_groups));
  patch_header(&hdr);
  SetHeaderToMenu(gui,&hdr,ma); 
  return gui_id=CreateGUI(gui); 
}



