 #include "anim_widget.h"

#include <siemens\swilib.h>
#include "main.h"

extern const char APP_DIR[];

static HObj obj_anim = 0;
static IMGHDR* img_anim = 0;

static int widget_type;
static int transparent;

int AnimWidget_IsBottom()
{
  return widget_type == 2;
}

static int HandleObsPrepareCon(HObj obj)
{
  Obs_Start(obj);
  return(0);
}

static int HandleObsFrameUpdate(HObj obj)
{
  IMGHDR* temp;  
  unsigned err;
  DRWOBJ drwobj;
  RECT rect;
  int x=0;
  int y=0;
  
  err=Obs_Output_GetPictstruct(obj, &temp);
  
  if (err == 0)
  {
    if (img_anim)//очистка предыдущего изображения
    {
      mfree(img_anim->bitmap);
      mfree(img_anim);
    }
      
    img_anim=  malloc(sizeof(IMGHDR));
    img_anim->w = temp->w;
    img_anim->h = temp->h;
    img_anim->bpnum = (char)temp->bpnum;// читаем только один байт
    int len = CalcBitmapSize(temp->w, temp->h,(char)temp->bpnum);
    img_anim->bitmap = malloc(len);
    memcpy(img_anim->bitmap, temp->bitmap, len);
  }  
  
  short w = img_anim->w;
  short h = img_anim->h;
  
  if (obj_anim)
  {
    if (widget_type == 0)//center
    {
      x = (ScreenW() >> 1) - (w >> 1);
      y = (YDISP+HeaderH()) + ((ScreenH()-YDISP-HeaderH()-SoftkeyH()) >> 1) - (h >> 1);
    }
    else
      if (widget_type == 1)//headline
      {
        x = (ScreenW()- w -2);
        y = YDISP+0;        
      }
    else
      if (widget_type == 2)//bottom
      {
        x = (ScreenW() >> 1) - (w >> 1);
        y = ScreenH()-SoftkeyH() - h + 1;        
      }
      
    StoreXYXYtoRECT (&rect, x, y, x+w, y+h);
    SetPropTo_Obj5(&drwobj, &rect, 0, img_anim);
    if (transparent)
      DirectRedrawGUI();//если гифка с прозрачным фоном
    DrawObject(&drwobj);
  }
  
  return 0;
}

static int HandleObsError(HObj obj, int err)
{
  Obs_SetCSM(obj_anim, 0);
  Obs_DestroyObject(obj_anim);
  obj_anim = NULL;
  return (0);
}

static OBSevent ObsEventsHandlers[]={
#ifdef NEWSGOLD
  OBS_EV_PrepareCon,  (void*) HandleObsPrepareCon,
#endif
  OBS_EV_FrameUpdate, (void*) HandleObsFrameUpdate,
  OBS_EV_Error,       (void*) HandleObsError,
  OBS_EV_EndList, 0
};


void AnimWidgetHandler(void* data)
{
  GBS_MSG* msg=(GBS_MSG*)data;
  if (obj_anim && (HObj)msg->data0==obj_anim)
    Obs_TranslateMessageGBS(msg, ObsEventsHandlers);
}

//******************************************************************************

static char* LoadFile(char* fname, int* len)
{
  char *_buf = NULL;
  
  FSTATS stat;
  int f;
  int fsize;
  unsigned  err;
  
  if (GetFileStats(fname, &stat, &err)==-1)
    return NULL;
  
  if ((fsize=stat.size)<=0)
    return NULL;
  
  *len=fsize;
  
  if ((f=fopen(fname, A_ReadOnly+A_BIN, P_READ, &err))!= -1)
  {
    _buf = malloc(fsize);
    fread(f, _buf, fsize, &err);
    fclose(f, &err);
  }
  return _buf;
}


static void AnimWidget_Wait_fn(WSHDR* fname)
{//Вызывать только в контексте MMI(CepID==0x4209). SUBPROC не прокатит
#ifdef NEWSGOLD
  
  unsigned int err = 0;
  HObj obj;
  int uid;
  
  uid = GetExtUidByFileName(fname);
  
  obj=Obs_CreateObject(uid, 0x2D, 2, 0x8055, 1, 0, &err);
  if (err) goto exit;
  
  err = Obs_SetCSM(obj, (CSM_RAM*)csm);
  
  err = Obs_SetInputFile(obj, 0, fname);
  if (err) goto exit;
  
  err = Obs_SetRotation(obj, 0);
  if (err) goto exit;
  
  if (widget_type == 1)
#ifdef ELKA
    err = Obs_SetOutputImageSize(obj, 32, 32);
  else
    err = Obs_SetOutputImageSize(obj, 240, 232);
#else    
    err = Obs_SetOutputImageSize(obj, 22, 22);
  else
    err = Obs_SetOutputImageSize(obj, 132, 132);
#endif
  
  if(err) goto exit;
  
  err = Obs_SetScaling(obj, 5);
  if (err) goto exit;

#ifdef NEWSGOLD  
  err = Obs_Prepare(obj);
  if (err == 0x8006)
#else
  err = Obs_Start(obj);
  if (err == 0x8008)//sgold
#endif
  {
    obj_anim = obj;
    return;
  } 

exit:
  Obs_DestroyObject(obj);
#endif
}
//******************************************************************************

static void AnimWidget_Wait_center()
{
  WSHDR ws;
  unsigned short wsbody[128];
  
  AnimWidget_Close();
  
  CreateLocalWS(&ws, wsbody, 127);
  wsprintf(&ws, "%simg\\body_wait.gif", APP_DIR);
  widget_type = 0;//body centr
  transparent = 1;
  AnimWidget_Wait_fn(&ws);
}

static void AnimWidget_Wait_bottom()
{
  WSHDR ws;
  unsigned short wsbody[128];
  
  AnimWidget_Close();
  
  CreateLocalWS(&ws, wsbody, 127);
  wsprintf(&ws, "%simg\\body_wait.gif", APP_DIR);
  widget_type = 2;//bottom
  transparent = 1;
  AnimWidget_Wait_fn(&ws);
}

static void AnimWidget_Wait_headline()
{
  WSHDR ws;
  unsigned short wsbody[128];
  
  AnimWidget_Close();
  
  CreateLocalWS(&ws, wsbody, 127);
  wsprintf(&ws, "%simg\\headline_wait.gif", APP_DIR);
  widget_type = 1;//headline
  transparent = 1;
  AnimWidget_Wait_fn(&ws);
}

void AnimWidget_Wait(unsigned int type)
{
  if(type == 0)
    AnimWidget_Wait_center();
  else if(type == 1)
    AnimWidget_Wait_headline();
  else if(type == 2)
    AnimWidget_Wait_bottom();
}

void AnimWidget_Close()
{
  if (obj_anim)
  {
    Obs_SetCSM(obj_anim, 0);
    Obs_DestroyObject(obj_anim);
    obj_anim = NULL;
  }
  
  if (img_anim)
  {
    mfree(img_anim->bitmap);
    mfree(img_anim);
    img_anim = NULL;
  } 
}


