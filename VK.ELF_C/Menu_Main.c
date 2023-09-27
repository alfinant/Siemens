#include <siemens\swilib.h>
#include "rect_patcher.h"
#include "dyn_images.h"
#include "dyn_theme.h"
#include "process.h"
#include "http.h"
#include "vk_api.h"
#include "main.h"

static const char percent_t[]="%t";
static const char HEADER_TEXT[]="Вконтакте";

extern int CreateDebugGUI();

static HEADER_DESC hdr={0,0,0,0,NULL,NULL,LGP_NULL};
static WSHDR* hdr_ws=NULL;

static const int menusoftkeys[]={0,1,2};

static SOFTKEY_DESC sk[]=
{
  {0x0018,0x0000,(int)"Опции"},
  {0x0001,0x0000, (int)"Назад"},
  {0x003D,0x0000,(int)LGP_DOIT_PIC}
};

static SOFTKEYSTAB skt=
{
  sk,0
};

extern void CreateDialogsMenu();
extern int CreateGroupsMenu();
extern void OpenAboutMenu();
extern void Logout();

static int items_menu_onkey(void *gui, GUI_MSG *msg)
{ 
  int i=GetCurMenuItem(gui);
  
  if ((msg->gbsmsg->msg==KEY_DOWN)||(msg->gbsmsg->msg==LONG_PRESS))
  { 
    switch(msg->gbsmsg->submess)
    {
    case RIGHT_SOFT:
      return(1);
      
    case GREEN_BUTTON:
      CreateDebugGUI();
      break;
      
    case ENTER_BUTTON:
      if (i==0)
        CreateDialogsMenu();
    /*  else
        if (i==1)
          CreateFriendsMenu(); */
      else
        if (i==2)
          CreateGroupsMenu();
        else
          if (i==3)
            OpenAboutMenu();
      else
        if (i == 4)
          Logout();
        break;
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
  }
     
  if (cmd==TI_CMD_UNFOCUS)
  {
    //DisableDynImages();
    DisableDynTheme();
  }
  
  if (cmd==TI_CMD_FOCUS)
  {
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
    DisableDynTheme();
    //DisableDynImages();
  }
}

static void items_menu_iconhndl(void *gui, int curitem, void *user_pointer)
{
  WSHDR* ws=AllocMenuWS(gui,64);
  void* item=AllocMenuItem(gui);
  
  switch(curitem)
  {
  case 0:
    wsprintf(ws, percent_t, "Сообщения");
    break;
  case 1:
    wsprintf(ws, percent_t, "Друзья");    
    break;
  case 2:
    wsprintf(ws, percent_t, "Группы");    
    break;    
  case 3:
    wsprintf(ws, percent_t, "О программе");
    break;
  case 4:
    wsprintf(ws, percent_t, "Выйти");
    break;    
  }

  //SetMenuItemIconArray(gui, item, &i1_pic); //первым рисуется картинка из SetMenuItemIconArray
  SetMenuItemText(gui, item, ws, curitem);

}

static const MENU_DESC items_menu_desc=
{
  8,
  items_menu_onkey,
  items_menu_ghook,
  NULL,
  menusoftkeys,
  &skt,
  0x11,
  items_menu_iconhndl,
  NULL,   //Items
  NULL,   //Procs
  0   //n
};

//******************************************************************************

int CreateMainMenu()
{
  void *ma=malloc_adr(); 
  void *mf=mfree_adr();
  void *gui=GetMenuGUI(ma, mf); 
  SetMenuToGUI(gui,&items_menu_desc); 
  SetMenuItemCount(gui, 5);
  patch_header(&hdr);
  SetHeaderToMenu(gui,&hdr,ma); 
  return CreateGUI(gui);
}


