#include <siemens\swilib.h>
#include "rect_patcher.h"

#include "socket_work.h"
#include "ssl_work.h"
#include "http.h"
#include "cookie.h"
#include "process.h"
#include "main.h"
#include "buffer.h"

char logmsg[256];
static const char percent_t[]="%t";

typedef struct
{
  GUI gui;
  WSHDR *ws1;
}MAIN_GUI;

static int gui_id = NULL;

void SMART_REDRAW()
{
  if(gui_id == 0)
    return;
  
  LockSched();
  if (IsGuiOnTop(gui_id))
    REDRAW();
  UnlockSched();
}

//******************************************************************************

static void OnRedraw(MAIN_GUI *data)
{
#ifdef ELKA
  DisableIconBar(1);
#endif
  int scr_w=ScreenW();
  int scr_h=ScreenH();
  char color[]={0x5D, 0x80, 0xA6, 0x64};
  unsigned long RX=ALLTOTALRECEIVED; unsigned long TX=ALLTOTALSENDED;
  //const char *cipher_name;
  
  CONNDATA *conn = CONNDATA_getTop();
  
//  if (conn && conn->ssl && conn->ssl->session && conn->ssl->session->cipher)
//    cipher_name=conn->ssl->session->cipher->name;

  //DrawRoundedFrame(0,0/*YDISP*/,scr_w-1,scr_h-1,0,0,0,color,color);
  DrawRoundedFrame(0,0/*YDISP*/,scr_w-1,scr_h-1,0,0,0,GetPaletteAdrByColorIndex(1),GetPaletteAdrByColorIndex(1));
  
  data->ws1->wsbody[0]='\0';
  
  wstrcatprintf(data->ws1, "Rx:%d, Tx:%d\n", RX, TX);
  wstrcatprintf(data->ws1, "Rxbuf: %X\n", recv_buf);
  
  if (conn)
    wstrcatprintf(data->ws1, "-host: %s\n", conn->hostname);
  
  if (conn)
    wstrcatprintf(data->ws1, "-sock_st=%d, ssl_st=%d\n", conn->sock_state, conn->ssl_state);
  
  if (conn && conn->ssl_state == 1)
  {
    wstrcatprintf(data->ws1, "-ssl handshake OK\n");
    wstrcatprintf(data->ws1, "-cipher %s\n", conn->ssl->session->cipher->name);
  }
  wstrcatprintf(data->ws1, "-LOG:<%s>\n", logmsg);

/*  
  wsprintf(data->ws1,
          // "State: %d\n"
             "Rx:%d,Tx:%d\n"
               "%s\n"//host
                 "%t\n"//logmsg
                   "cipher: %s\n"//cipher name
                   "recv_buf: %X\n"
                     "send_buf: %X\n"
                       "http_stat: %d, proc:%d\n"
                         "connect_state: %d\n"
                           "http_content_len: %d\n"
                           "ssl_write: %d\n"
                             "ssl_read: %d\n"
                               "ssl_con: %d\n"
                                 "sess_list: %X\n"
    ,RX,TX, host, logmsg, cipher_name, recv_buf, send_buf, HTTP_STATUS, INET_PROCESS, connect_state, HTTP_CONTENT_LENGTH, ssl_write_err, ssl_read_err, ssl_con_err, &connect_list);
*/  
  DrawString(data->ws1, 3, 3+0/*YDISP*/, scr_w-4, scr_h-4-GetFontYSIZE(FONT_MEDIUM_BOLD),
             FONT_SMALL, 0, GetPaletteAdrByColorIndex(0), GetPaletteAdrByColorIndex(23));

 // wsprintf(data->ws1,_percent_t,"Login");
 // DrawString(data->ws1,3,scr_h-4-GetFontYSIZE(FONT_MEDIUM_BOLD),scr_w>>1,scr_h-4,
             //FONT_MEDIUM_BOLD,TEXT_ALIGNLEFT,GetPaletteAdrByColorIndex(0),GetPaletteAdrByColorIndex(23));
  wsprintf(data->ws1, percent_t, "Exit");
  DrawString(data->ws1,scr_w>>1,scr_h-4-GetFontYSIZE(FONT_MEDIUM_BOLD),scr_w-4,scr_h-4,
             FONT_MEDIUM_BOLD,TEXT_ALIGNRIGHT,GetPaletteAdrByColorIndex(0),GetPaletteAdrByColorIndex(23));  
}

//******************************************************************************

static void onCreate(MAIN_GUI *data, void *(*malloc_adr)(int))
{
  data->ws1 = AllocWS(256);
  data->gui.state = 1;

}

static void onClose(MAIN_GUI *data, void (*mfree_adr)(void *))
{
  data->gui.state = 0;
  FreeWS(data->ws1);
  gui_id = NULL;
}

static void onFocus(MAIN_GUI *data, void *(*malloc_adr)(int), void (*mfree_adr)(void *))
{
#ifdef ELKA
  DisableIconBar(1);
#endif
  DisableIDLETMR();
  data->gui.state = 2;
  DirectRedrawGUI();
}

static void onUnfocus(MAIN_GUI *data, void (*mfree_adr)(void *))
{
#ifdef ELKA
  DisableIconBar(0);
#endif
  if (data->gui.state != 2)
    return;
  data->gui.state = 1;
}

//******************************************************************************
static int OnKey(MAIN_GUI *data, GUI_MSG *msg)
{ 
  if (msg->gbsmsg->msg==KEY_DOWN)
  {
    switch(msg->gbsmsg->submess)
    {
    case '0':
      SMART_REDRAW();
      break;
      
    case '5':
    break;
    
    case '6':
     // CreateAccessDialog(NULL);
      break;

    case GREEN_BUTTON:
      break;

    case LEFT_SOFT:
      break;

    case RIGHT_SOFT:
      return (1);
    }
  }
  SMART_REDRAW();
  return(0);
}

//******************************************************************************
extern void kill_data(void *p, void (*func_p)(void *));
int method8(void){return(0);}
int method9(void){return(0);}

const void * const gui_methods[11]={
  (void *)OnRedraw,
  (void *)onCreate,
  (void *)onClose,
  (void *)onFocus,
  (void *)onUnfocus,
  (void *)OnKey,
  0,
  (void *)kill_data,
  (void *)method8,
  (void *)method9,
  0
};

static const RECT Canvas={0,0,0,0};

int CreateDebugGUI()
{
  MAIN_GUI *gui = malloc(sizeof(MAIN_GUI));
  zeromem(gui, sizeof(MAIN_GUI));
  patch_rect((RECT*)&Canvas, 0, YDISP, ScreenW()-1, ScreenH()-1);
  gui->gui.canvas = (void *)(&Canvas);
  gui->gui.flag30 = 0;
  gui->gui.methods = (void *)gui_methods;
  gui->gui.item_ll.data_mfree = (void (*)(void *))mfree_adr();
  return (gui_id = CreateGUI(gui));
}

