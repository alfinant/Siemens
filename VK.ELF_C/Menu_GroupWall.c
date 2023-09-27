//Это меню можно было реализовать через EDITCONTROL, но там нет скроллбара в режиме readonly. Поэтому TVIEW.
//Пока все заточено под один шрифт. С другим шрифтом корректная работа курсора не гарантируется.
/*27.02.2023 
    - подрубил функции для списков из include/linux/list.h.
*/

#include <siemens\swilib.h>
#include "rect_patcher.h"
#include "process.h"
#include "http.h"
#include "vk_api.h"
#include "dyn_images.h"
#include "dyn_theme.h"
#include "anim_widget.h"
#include "main.h"
#include "parser_wall.h"
#include "anim_widget.h"

#ifdef ELKA
#define TWIEW_SCROLLBAR_WIDTH  4
#else
#define TWIEW_SCROLLBAR_WIDTH  3
#endif

extern const TTime GMT;
extern char logmsg[];

static const char percent_d[]="%d";
static const char percent_t[]="%t";
static const char percent_t_d[]="%t %d";

static const char* MONTH_NAME[]={"янв","фев","март","апр","май","июнь","июль","авг","сен","окт","ноя","дек"};

extern const char DIR[];
extern int CreateDebugGUI();

static VkGroup* selected_group=NULL;

VkPost* post=NULL;
static int offset=0;

static int full_text_h;
static int offset_text_h;
static int IsScrollbar;
static int cursor;
static int attach_count;

static int header_icon=0x4E74;
static IMGHDR* img_icon=NULL;

static HEADER_DESC hdr={0,0,0,0,NULL,NULL,LGP_NULL};

static const int menusoftkeys[]={0, 1, 2};

static SOFTKEY_DESC sk[]=
{
  {0x0000, 0x0000, 0xFFFFFFFF},
  {0x0001, 0x0000, (int)"Назад"},
  {0x0000, 0x0000, 0xFFFFFFFF}, 
};

static SOFTKEY_DESC lsk={0x0018, 0x0000, (int)"Выбрать"};
static SOFTKEY_DESC esk={0x001D, 0x0000, (int)LGP_DOIT_PIC};

static SOFTKEYSTAB skt=
{
  sk,0
};

static void proc3(){}

void Wall_Refresh();
extern TVIEW_DESC tv_desc;

static int onKey(void* gui, GUI_MSG *msg)
{ 
  int font_h;
  
  switch (msg->keys)
  {
  case 1: //закрытие по нажатию кнопки
      offset=0;
      if(post)
        //FreePost(post);
      post=NULL;
      csm->wallgui_id=NULL;
      return (0);
  
  case 0x26://up
  case 0x2B://up (long press)
    if(post){
    font_h=GetFontYSIZE(tv_desc.font);
    if (offset_text_h > 0) offset_text_h-=font_h;
    if (cursor > 0)
      cursor--;
    if (IsScrollbar==0)
      DirectRedrawGUI();}
    break;
  
  case 0x25://down
  case 0x2A://down (long press)
    if(post){
    font_h=GetFontYSIZE(tv_desc.font);
    if ((full_text_h - offset_text_h) > (tv_desc.rc.y2-tv_desc.rc.y+1))
    {
      offset_text_h+=font_h;
      cursor=0;
    }
    else
      if (attach_count)
      {
        cursor++;
        if (cursor > attach_count)
          cursor=attach_count;
      }
    if (IsScrollbar==0)
      DirectRedrawGUI();}
    break;
  }

  
  if ((msg->gbsmsg->msg==KEY_DOWN)||(msg->gbsmsg->msg==LONG_PRESS))
  { 
    switch(msg->gbsmsg->submess)
    {
    case LEFT_BUTTON:
      if (INET_PROCESS==0 && offset > 0)
      {
        offset--;
        //if(post) FreePost(post);
        post=NULL;
        Wall_Refresh();
      }       
      break;
      
    case RIGHT_BUTTON:
      if (INET_PROCESS==0)
      {
        offset++;
        //if(post) FreePost(post);
        post=NULL;
        Wall_Refresh();
      }       
      break;
        
    case GREEN_BUTTON:
#ifdef DEBUG
      CreateDebugGUI();
#endif
    break;
    
    case ENTER_BUTTON:
    break;
    
    case LEFT_SOFT:
      if (INET_PROCESS==0 && cursor)
      {
        if (post && !list_empty(&post->attachments))
        {
          struct list_head* i=get_ListByIndex(&post->attachments, cursor-1);
          ATTACH_WALL* entry = list_entry(i, ATTACH_WALL, list);
          if (entry->type==1 && entry->url)//photo
          {
            INET_PROCESS=DOWNLOAD_ATTACH_PHOTO;
            SUBPROC((void *)HttpSendReq, entry->url);
            AnimWidget_Wait(0);
          }
        }   
      }
      break;
      
    case RIGHT_SOFT:
      //не срабатывает
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
    if (selected_group->name)
      wstrcat(ws, selected_group->name);
    else
      wsprintf(ws, percent_d, selected_group->id);
    SetHeaderText(hdr_pointer, ws, malloc_adr(), mfree_adr());
    
    if (INET_PROCESS==0 && post==0)
    {
      INET_PROCESS=LOAD_WALL; 
      SUBPROC((void *)HttpSendReq, url_wall_get(selected_group->id, offset,1));
      AnimWidget_Wait(0);
    }           
  }
  
  if (cmd==TI_CMD_UNFOCUS)
  {
    AnimWidget_Close();
    DisableDynTheme();
  }
  
  if (cmd==TI_CMD_FOCUS)
  {
    EnableDynTheme();  
    DisableIDLETMR();
  }
  
  if (cmd==TI_CMD_DESTROY)
  { 
    AnimWidget_Close();
    DisableDynTheme();
    /* else if (img_icon)
      {
        mfree(img_icon->bitmap);
        mfree(img_icon);
        img_icon=NULL;
      }*/
  }
 
}

static TVIEW_DESC tv_desc=
{
  8,
  onKey,
  gHook,
  proc3,
  menusoftkeys,//menusoftkeys
  &skt,
#ifdef ELKA  
  {1,56,239,287},
#else
  {1,23,131,154},
#endif
  FONT_SMALL,
  0x64,
  0x65,
  0,
  0 //выравнивание
};

int CalcTextH(WSHDR* ws, int ws_len, int font, int w, int text_flag)
{
  DRWOBJ drwobj;
  RECT rc;
  int _w=0;
  int _h=0;
  
  int len=wstrlen(ws);
  ws->wsbody[0]=ws_len;
  StoreXYWHtoRECT(&rc, 0, 0, w, 0x7FFF);
  SetPropTo_Obj1(&drwobj, &rc, 0, ws, font, text_flag);
  //UnkFunc_Obj1(&drwobj, 0);
  Get_Obj1_WH(&drwobj, &_w, &_h);
  ws->wsbody[0]=len;
  FreeDrawObject_subobj(&drwobj);
  return _h;
}

static WSHDR* crt_text(VkPost* msg)
{
  WSHDR* ws=NULL;
  
  TDate t_date;
  TTime time;
  TDate s_date;
  int timestap; 
  TDate phone_date;
  TTime phone_time;  
  
  if (msg)
  {
    ws=AllocWS(254+wstrlen(msg->text));
    
    wsAppendChar(ws, UTF16_FONT_SMALL_BOLD);  
    wsAppendChar(ws, UTF16_INK_RGBA); 
    wsAppendChar(ws, 0x5D80);//RG
    wsAppendChar(ws, 0xA664);//BA - вк синий 
    
    if (msg->from_id != selected_group->id)//если сообщение не от сообщества, то указываем от кого
    {
      if (!list_empty(&msg->profiles))
      {
        struct list_head *i;
        list_for_each(i, &msg->profiles)
        {
          VkUser* entry = list_entry(i, VkUser, list);
          wstrcat(ws, entry->first_name);
          wsAppendChar(ws, ' ');
          wstrcat(ws, entry->last_name);
        }
      }
      else
        wstrcatprintf(ws, percent_d, msg->from_id);
    }
    else
      wstrcat(ws, selected_group->name);
    
    wsAppendChar(ws, ':');
    wsAppendChar(ws, '\n');
    
    wsAppendChar(ws, UTF16_FONT_SMALL);
    wsAppendChar(ws, UTF16_INK_RGBA); 
    wsAppendChar(ws, 0x8080);//RG
    wsAppendChar(ws, 0x8064);//BA - серый
    
    timestap=msg->date + (GMT.hour*3600)+(GMT.min*60);
    s_date.year=1970;
    s_date.month=1;
    s_date.day=1;
    GetDateTimeFromSeconds(&timestap, &t_date, &time, &s_date);    
    GetDateTime(&phone_date, &phone_time);
    
    if (phone_date.day==t_date.day && phone_date.month==t_date.month && phone_date.year==t_date.year)
      wstrcatprintf(ws, "%t %d:%02d", "сегодня в", time.hour, time.min);
    else
      if ((phone_date.day-1)==t_date.day && phone_date.month==t_date.month && phone_date.year==t_date.year)
        wstrcatprintf(ws, "%t %d:%02d", "вчера в", time.hour, time.min);
    else
      wstrcatprintf(ws, "%d %t %d:%02d", t_date.day, MONTH_NAME[t_date.month-1], time.hour, time.min);
     
    if (msg->text)
    {
      wsAppendChar(ws, '\n');
      wsAppendChar(ws, UTF16_INK_RGBA);
      wsAppendChar(ws, 0x0000);//RG
      wsAppendChar(ws, 0x0064);//BA - черный    
      wstrcat(ws, msg->text);
    }
    
    wsAppendChar(ws, '\n');
    
    attach_count=0;
    if (!list_empty(&msg->attachments))
    {
      struct list_head *i;
      list_for_each(i, &msg->attachments)
      {
        ATTACH_WALL* entry = list_entry(i, ATTACH_WALL, list);       
        //wsAppendChar(ws, UTF16_FONT_SMALL);
        //wsAppendChar(ws, UTF16_INK_RGBA); 
        //wsAppendChar(ws, 0x319A);//RG
        //wsAppendChar(ws, 0xFF64);//BA - сочный синий  
        entry->offset_ws=wstrlen(ws);
        wsAppendChar(ws, '\n');
        attach_count++;
      }
    }
    
    wsAppendChar(ws, UTF16_FONT_SMALL);
    wsAppendChar(ws, UTF16_INK_RGBA); 
    wsAppendChar(ws, 0x8080);//RG
    wsAppendChar(ws, 0x8064);//BA - серый  
    wstrcatprintf(ws, percent_t_d, "Нравится", msg->likes);
    wsAppendChar(ws, '\n');
    wstrcatprintf(ws, percent_t_d, "Комментарии", msg->comments_count);
  }
  return ws;
}

static void (*OnRedraw)(void*);
static void* gui_methods_copy[24];
static void* tvgui_methods;

static void MyOnRedraw(void *gui)
{
  WSHDR ws;
  unsigned short wsbody[32];
  unsigned color_blue=0x64FF9A31;// сочный синий 
  unsigned color_white=0x64FFFFFF;// белый
  unsigned brush=0;
  
  if (cursor)
  {
    SetMenuSoftKey(gui, &lsk, 0);
    SetMenuSoftKey(gui, &esk, 2);
  }
  else
  {
    SetMenuSoftKey(gui, &sk[0], 0);
    SetMenuSoftKey(gui, &sk[2], 2);
  }
  
  OnRedraw(gui);// тут отрисуется текст который добавили с помощью TViewSetText
  
  //void* data=GetDataOfItemByID(gui, 4);
  //int* ptr=(void*)GetItemTextPtr(data);
  //int* data_unk=ptr;
  //int offset_t=TVIEW_GetTextOffset((void*)data_unk[3]);//счетчик прочитанных WS символов-тупит частенько
  //int offset_h1=CalcTextH(ws, offset_t, tv_desc.font, w, tv_desc.unk4);
  
  //wsAppendChar(ws, UTF16_FONT_SMALL);
  //wsAppendChar(ws, UTF16_INK_RGBA); 
  //wsAppendChar(ws, 0x319A);//RG
  //wsAppendChar(ws, 0xFF64);//BA - сочный синий  
  // WSHDR* ws=(WSHDR*)ptr[2];
  
  if (post && !list_empty(&post->attachments))
  { 
    CreateLocalWS(&ws, wsbody, 31);
    
    int n=0;
    struct list_head *i;
    list_for_each(i, &post->attachments)
    {
      ATTACH_WALL* entry = list_entry(i, ATTACH_WALL, list);
      
      if (entry->type==1)//photo
        wsprintf(&ws, percent_t, "фото");
      else
        if (entry->type==7)//link
          wsprintf(&ws, percent_t, "ссылка");
        else
          if (entry->type==3)//video
            wsprintf(&ws, percent_t, "видео");
        
        int y=tv_desc.rc.y + (entry->offset_h - offset_text_h);
        int font_h=GetFontYSIZE(tv_desc.font);
        
        SetDrawingCanvas(tv_desc.rc.x, tv_desc.rc.y, tv_desc.rc.x2, tv_desc.rc.y2);
        //DrawIMGHDR(30, y, img_link);
        if (cursor && n==cursor-1)
          DrawString(&ws, tv_desc.rc.x, y, 131, y+font_h, tv_desc.font, 0, (char*)&color_white, (char*)&color_blue);
        else
          DrawString(&ws, tv_desc.rc.x, y, 131, y+font_h, tv_desc.font, 0, (char*)&color_blue, (char*)&brush);
        
        n++;
    }
  }
}

int CreateWall(VkGroup *group)
{
  WSHDR* ws=NULL;
  
  if(csm->wallgui_id)//закрываем до этого созданный гуй
  {
    GUI* gui=FindGUIbyId(csm->wallgui_id, 0);
    gui->methods=tvgui_methods;//восстанавливаем методы
    GeneralFunc_flag1(csm->wallgui_id, 1);
    csm->wallgui_id=NULL;
  }

  selected_group=group;
  
  GUI* tvgui=TViewGetGUI(malloc_adr(), mfree_adr());
  TViewSetDefinition(tvgui, &tv_desc);
  patch_header(&hdr);
  SetHeaderToMenu(tvgui, &hdr, malloc_adr());

  offset_text_h=0;
  IsScrollbar=0;
  attach_count=0;
  cursor=0;
    
  if (post)
    ws=crt_text(post);
  if (ws==NULL)
    ws=AllocWS(32);
  
  int w=tv_desc.rc.x2-tv_desc.rc.x+1;
  
  full_text_h=CalcTextH(ws, wstrlen(ws), tv_desc.font, w, tv_desc.unk4);
  
  if (full_text_h > (tv_desc.rc.y2-tv_desc.rc.y+1))//значит будет скроллбар
  {
    IsScrollbar=1;
    w-=TWIEW_SCROLLBAR_WIDTH;
    full_text_h=CalcTextH(ws, wstrlen(ws), tv_desc.font, w, tv_desc.unk4);//пересчитаем занова высоту
  }
   
  //вычисляем смещение до вложений
  if (post && !list_empty(&post->attachments))
  {
    struct list_head *i;
    list_for_each(i, &post->attachments)
    {
      ATTACH_WALL* entry = list_entry(i, ATTACH_WALL, list);
      entry->offset_h=CalcTextH(ws, entry->offset_ws, tv_desc.font, w, tv_desc.unk4);
    }
  } 
   
  TViewSetText(tvgui, ws, malloc_adr(), mfree_adr());
  
  //захват OnRedraw
  tvgui_methods=tvgui->methods;
  memcpy(gui_methods_copy, tvgui->methods, sizeof(gui_methods_copy));
  OnRedraw=(void(*)(void*))gui_methods_copy[0];
  gui_methods_copy[0]=(void*)MyOnRedraw;
  tvgui->methods=gui_methods_copy;
  
  return (csm->wallgui_id=CreateGUI(tvgui));
}

void Wall_Refresh()
{
  if (selected_group)
    CreateWall(selected_group);//проще занова создать GUI,чем обновить
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
 
    MENU_ITEM_TXT* ptr=GetItemTextPtr(data);
    WSHDR* ws=crt_text((WALLMSG*)selected_group->msglist);
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
