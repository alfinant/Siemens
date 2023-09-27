#include <siemens\swilib.h>
#include "rect_patcher.h"
#include "dyn_images.h"
#include "dyn_theme.h"
#include "socket_work.h"
#include "http.h"
#include "process.h"
#include "vk_api.h"
#include "main.h"
#include "main.h"
#include "anim_widget.h"

static const char percent_t[]="%t";
static const char percent_d[]="%d";
static const char HEADER_TEXT[]="Друзья";

extern int CreateDebugGUI();

static HEADER_DESC hdr={0,0,0,0,NULL,NULL,LGP_NULL};
static WSHDR* hdr_ws=NULL;

static const int menusoftkeys[]={0,1,2};

static SOFTKEY_DESC sk[]=
{
  {0x0018,0x0000,(int)"Еще+50"},
  {0x0001,0x0000, (int)"Назад"},
  {0x003D,0x0000,(int)LGP_DOIT_PIC}
};

static SOFTKEYSTAB skt=
{
  sk,0
};

static int items_menu_onkey(void *gui, GUI_MSG *msg)
{
  CLIST* c;
  CLIST* c2;
  int i;
  
  if ((msg->gbsmsg->msg==KEY_DOWN)||(msg->gbsmsg->msg==LONG_PRESS))
  {
    switch(msg->gbsmsg->submess)
    {
    case UP_BUTTON:
      break;
      
    case ENTER_BUTTON:
      i=GetCurMenuItem(gui);
      c=FindContactByN(csm->friends_list, i);
      if (c2=FindContactById(csm->dialogs_list, c->user_id))
        c=c2;
      CreateChat(c); 
      break;
    
    case GREEN_BUTTON:
#ifdef DEVELOP      
      CreateDebugGUI();
#endif
    break;
    
    case LEFT_SOFT:
      if (process==0)
      {
        sock_keepalive=1;
        process=LOAD_FRIENDS;
        int count=CLIST_GetCount(csm->friends_list);
        SUBPROC((void *)HttpSendReq, friends_get(50, count, "mobile", "photo_50"));
        AnimWidget_Wait_headline();
      }
    break;
    
    case RIGHT_SOFT:
      csm->friends_menu_gui_id=NULL;
      return(1);//close
    }
  }
  return (0); 
}

static void items_menu_ghook(void *gui, int cmd)
{
  if (cmd==TI_CMD_CREATE)
  { 
    void* hdr_pointer=GetHeaderPointer(gui);
    hdr_ws=AllocWS(128);
    wsprintf(hdr_ws, percent_t, HEADER_TEXT);
    SetHeaderText(hdr_pointer, hdr_ws, malloc_adr(), mfree_adr()); 
    
    //LoadDynTheme();
    //LoadDynImages();
    
    if (process==0 && csm->friends_list==NULL)
    {
      process=LOAD_FRIENDS;
      SUBPROC((void *)HttpSendReq, url_friends_get(50, 0, "mobile", "photo_50"),  1);
      if (csm->friends_list==NULL)
        AnimWidget_Wait_body();
      else
        AnimWidget_Wait_headline();
    }     
  }
     
  if (cmd==TI_CMD_UNFOCUS)
  {
    AnimWidget_Close();
    //DisableDynImages();
    DisableDynTheme();
  }
  
  if (cmd==TI_CMD_FOCUS)
  {
    if (GetMenuItemCount(gui)==0)
      AnimWidget_Wait_body();
    
    EnableDynImages();
    EnableDynTheme();  
    DisableIDLETMR();
  }  
  
  if (cmd==TI_CMD_REDRAW)
  {
    EnableDynImages();
  }
  
  if (cmd==TI_CMD_DESTROY)
  {
    csm->friends_menu_gui_id=NULL;
    /*csm->c=NULL;
    csm->cl=NULL;
    CLIST_Free(&csm->friends_clist); */
    DisableDynTheme();
    //DisableDynImages();
  }
}

static void items_menu_iconhndl(void *gui, int curitem, void *user_pointer)
{
  struct list_head * pos;
  VkUser *c=NULL;
  
  pos = get_ListByIndex(&friends, curitem);
  c = list_entry(pos, VkUser, list);
  
  WSHDR *ws1=AllocMenuWS(gui,64);
  WSHDR *ws2=AllocMenuWS(gui,64);
  void* item=AllocMLMenuItem(gui);
  
  if (c)
  {
    wsAppendChar(ws1, UTF16_FONT_SMALL_BOLD);
    //wsAppendChar(ws1, 0x5D80);//RG
    //wsAppendChar(ws1, 0xA664);//BA - вк синий    
    if (user->first_name)
      wstrcat(ws1, c->first_name);
    else
      wstrcatprintf(ws1,percent_d, c->user_id);
    
    wsAppendChar(ws2, UTF16_FONT_SMALL_BOLD);
    //wsAppendChar(ws2, 0x5D80);//RG
    //wsAppendChar(ws2, 0xA664);//BA - вк синий 
    if (c->last_name)
      wstrcat(ws2, c->last_name);    
    
    //SetMenuItemIconArray(gui, item, &i1_pic); //первым рисуется картинка из SetMenuItemIconArray
    if (c->photo)
      SetMenuItemIconIMGHDR(gui, item, c->photo);
    else
    {
      IMGHDR* img;
      
      if (c->deactivated)
        img=PNGLIST_GetImgByIndex(0);//deactivated.png
      else
        img=PNGLIST_GetImgByIndex(1);//camera.png
      
      if (img)
        SetMenuItemIconIMGHDR(gui, item, img);
      
      if (c->deactivated==0)
        c->flag_load_photo=1;//надо загрузить
      
      if (process==0) 
      {
        csm->list=&friends;
        csm->user=csm->cl;
        process=LOAD_USERS_PHOTO_FROM_INET;
        ipc.name_to=ipc_my_name;
        ipc.name_from=ipc_my_name;
        ipc.data=0;
        GBS_SendMessage(MMI_CEPID, MSG_IPC, IPC_RUN_MAIN_PROCESS, &ipc);        
      }           
    }
    
    SetMLMenuItemText(gui, item, ws1, ws2, curitem);
  }
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
void RecountFriendsMenu()
{
  if (csm->friends_menu_gui_id)
  {
    GUI* gui=FindGUIbyId(csm->friends_menu_gui_id, NULL);
    Menu_SetItemCountDyn(gui, CLIST_GetCount(csm->friends_list));

  }
}

//******************************************************************************

void CreateFriendsMenu()
{
  void *ma=malloc_adr(); 
  void *mf= mfree_adr();
  void *gui=GetMultiLinesMenuGUI(ma, mf); 
  SetMenuToGUI(gui,&items_menu_desc); 
  SetMenuItemCount(gui, CLIST_GetCount(csm->friends_list));
  patch_header(&hdr);
  SetHeaderToMenu(gui,&hdr,ma); 
  csm->friends_menu_gui_id=CreateGUI(gui); 
}


