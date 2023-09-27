#include <siemens\swilib.h>
#include "rect_patcher.h"
#include "dyn_images.h"
#include "anim_widget.h"
#include "dyn_theme.h"

extern const char APP_DIR[];

static int gui_id = 0;

static const char percent_t[]="%t";
static const char HEADER_TEXT[]="О программе";
static int header_icon=0x4E74;

static IMGHDR* img_logo=NULL;
static IMGHDR* img_icon=NULL;

static HEADER_DESC hdr={0,0,0,0,NULL,NULL,LGP_NULL};

static const int mmenusoftkeys[]={0,1,2};

static SOFTKEY_DESC sk[]=
{
  {0x0018,0x0000,(int)""},
  {0x0001,0x0000, (int)"Назад"},
  {0x0000,0x0000,0xFFFFFFFF},
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
    case LEFT_SOFT:
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
    LoadDynTheme();
    if (img_icon)
      hdr.icon=&header_icon;
    void* hdr_pointer=GetHeaderPointer(data);
    WSHDR* ws=AllocWS(32);
    wsprintf(ws, percent_t, HEADER_TEXT);
    SetHeaderText(hdr_pointer, ws, malloc_adr(), mfree_adr());
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
    if (img_logo)
    {
      mfree(img_logo->bitmap);
      mfree(img_logo);
      img_logo = NULL;
    }
    
    if (img_icon)
    {
      mfree(img_icon->bitmap);
      mfree(img_icon);
      img_icon=NULL;      
    }
    DisableDynTheme();
    gui_id = 0;
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
  {0,26,131,153},
#endif
  8,//font
  0x64,
  0x65,
  0,
  2 //выравнивание по центру
};

static void (*OnRedraw)(void*);
static void* gui_methods_copy[24];

static void MyOnRedraw(void *data)
{
  OnRedraw(data);
  
  if (img_logo)
  { 
    int x=(ScreenW() >> 1) - (img_logo->w >> 1);
    int y=tv_desc.rc.y + GetFontYSIZE(tv_desc.font);
    DrawIMGHDR(x,y, img_logo);
  }
}

extern const char API_VER[];

void OpenAboutMenu()
{
  WSHDR* ws;
  char path[128];
  
  GUI* tvgui=TViewGetGUI(malloc_adr(), mfree_adr());
  TViewSetDefinition(tvgui, &tv_desc);
  patch_header(&hdr);
  SetHeaderToMenu(tvgui, &hdr, malloc_adr());
  patch_header(&hdr);
  
  ws=AllocWS(256);
  wsAppendChar(ws, UTF16_INK_RGBA);
  wsAppendChar(ws, 0x8080);//RG
  wsAppendChar(ws, 0x8064);//BA-серый
  wsAppendChar(ws, UTF16_FONT_SMALL); 
  wstrcatprintf(ws, "\n\n\n\n\n\n"
                "VK ELF\n"
                  "api version %t\n"
                    "rev. %s",API_VER, __DATE__);
  TViewSetText(tvgui, ws, malloc_adr(), mfree_adr());
  
  //захват OnRedraw
  memcpy(gui_methods_copy, tvgui->methods, sizeof(gui_methods_copy));
  OnRedraw=(void(*)(void*))gui_methods_copy[0];
  gui_methods_copy[0]=(void*)MyOnRedraw;
  tvgui->methods=gui_methods_copy;

  snprintf(path, 127, "%simg\\%about.png", APP_DIR);
  img_logo=CreateIMGHDRFromPngFile(path, 2);
  
  snprintf(path, 127, "%simg\\%about_h.png", APP_DIR);
  img_icon=CreateIMGHDRFromPngFile(path, 2);
  if (img_icon)
    SetDynIcon(0x4E74, img_icon, 0);
  
  gui_id = CreateGUI(tvgui);
}

