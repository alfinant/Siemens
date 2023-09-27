//!!!Значит так. Нужен свой список для смайлов. Удаление смайлов при выходе через 
//таблицу Dyn иконок не дает 100% ой гарантии.  
#include "dyn_images.h"
#include <siemens/pnglist.h>
#include <siemens/swilib.h>
#include "main.h"
#include "list.h"

extern const char APP_DIR[];

LIST_HEAD(smiles);

struct image_st
{
  struct list_head list;
  IMGHDR img;
};

PNGLIST *pngtop = NULL;
DYNPNGICONLIST *dyn_pnglist = NULL;

//!!!!! 0x4E74 юзать для иконки хэдера в меню. SetDynIcon в помощь

void DisableDynImages()
{
  PNGTOP_DESC* pngtop=PNG_TOP();
  pngtop->dyn_pltop=NULL;
}

void EnableDynImages()
{
  PNGTOP_DESC* pngtop=PNG_TOP();
  pngtop->dyn_pltop=dyn_pnglist;
}

static void AddDynImage(IMGHDR* img, int npic)
{
  DYNPNGICONLIST *dl;
  DYNPNGICONLIST *dynimage;
  
  dynimage=dyn_pnglist;
  
  while(dynimage)
  {
    if (dynimage->icon == npic)//есть уже такой в списке. обновляем imghdr
    {
      mfree(dynimage->img);
      dynimage->img=img;
      return;
    }
    dynimage=dynimage->next;
  }
  
  dl=malloc(sizeof(DYNPNGICONLIST)); 
  dl->img=img;
  dl->icon=npic;
  dl->next=dyn_pnglist;
  dyn_pnglist=dl;
}

void FreeDynPngList()
{
  DYNPNGICONLIST *d=dyn_pnglist;
  
  while (d)
  {
    if (d->img)
    {
      if (d->img->bitmap)
        mfree(d->img->bitmap);
      mfree(d->img);
    }
    void* next=d->next;
    mfree(d);
    d=next;
  }
  
  dyn_pnglist=NULL;
}

//******************************************************************************
//максимальное кол-во доступных иконок начиная с FIRST_UCS2_BITMAP всего 60:(
//остальные символы либо системные, либо ссылыются на один и тот же номер картинки
//Альтернатива только 
void LoadSmilesTo_0xE12A(int start_symbol, int n, int UCS2_offset)
{
  char path[128];
  int symbol=start_symbol;
 
 for(int i=0; i < n; i++)
 {
   snprintf(path, 127, "%ssmiles\\%X.png", APP_DIR, symbol);
   DYNPNGICONLIST* dp=malloc(sizeof(DYNPNGICONLIST));
   dp->icon=GetPicNByUnicodeSymbol(FIRST_UCS2_BITMAP+UCS2_offset+i);
   dp->img=CreateIMGHDRFromPngFile(path, 0);
   dp->next=dyn_pnglist;
   dyn_pnglist=dp;
   
   symbol++;
 }
}


//грузим смайлы в символы 0xE200 стандартным способом
//макс. число смайлов кот. можно загрузить-156
//0xE254-0xE25D используются прошивкой, поэтому доступно только 146
//!!!не хватает 0x1F63A смайлика

typedef struct
{
  IMGHDR imghdr;
  int isBusy;
#ifdef NEWSGOLD  
  int isFree;
#endif
} E200_SYMBOL_STRUCT;

//Альтернатива SetDynIcon. 
static void LoadSmilesTo_0xE200(int unicode_symbol, int offset, int n)
{
  char path[128];
  IMGHDR* img;
  
  E200_SYMBOL_STRUCT* tab;
  
  IMGHDR* first_img=GetPitAdrBy0xE200Symbol(0xE200);
  
  if (first_img)
  {
    tab=(E200_SYMBOL_STRUCT*)first_img;//начало таблицы
    
    for(int i=0; i < n; i++)
    {
      snprintf(path, 127, "%ssmiles\\%X.png", APP_DIR, i + unicode_symbol);
      img=CreateIMGHDRFromPngFile(path, 0);
      if (img)
      {
        E200_SYMBOL_STRUCT* e = &tab[offset+i];
        e->imghdr.w=img->w;
        e->imghdr.h=img->h;
        e->imghdr.bpnum=img->bpnum;
        e->imghdr.bitmap=img->bitmap;
        e->isBusy=1;//если 0, то смайлы не рисуются-значит символ не занят
#ifdef NEWSGOLD        
        e->isFree=1;//флаг на удаление битмапа при вызове FreeDynIcon(only NSG/ELKA)
#endif
        mfree(img);
      }
    }
  }
}


static void Free0xE200(int offset, int n)
{
  IMGHDR *img;
  int E200_SymbolPic=0x4E20;
  
  for(int i=0; i < n; i++)
  {
#ifndef NEWSGOLD
    if (img = GetPitAdrBy0xE200Symbol(0xE200 + offset + i))
      mfree(img->bitmap);
#endif
    FreeDynIcon(E200_SymbolPic + offset + i);
  }
}

static void LoadEmoji()
{
  LoadSmilesTo_0xE200(0x1F600, 3, 80);
}

static void LoadSmiles0x1F440()
{
 LoadSmilesTo_0xE200(0x1F440, 96, 17);  
}

static void LoadSmiles0x2600()
{
  LoadSmilesTo_0xE200(0x2639, 113, 2);
}

static void LoadSmiles0x2700()
{
  LoadSmilesTo_0xE200(0x270C, 115, 1);
  LoadSmilesTo_0xE200(0x2764, 116, 1);
}

void LoadSmiles()
{
  LoadEmoji();
  LoadSmiles0x1F440();
  LoadSmiles0x2600();
  LoadSmiles0x2700();
  //__LoadSmiles(0x1F600, 80, 0);
  //__LoadSmiles(0x1F440, 17, 81);  
  //__LoadSmiles(0x2600, 2, 98);
  //__LoadSmiles(0x2700, 2, 100);
}


void FreeDynSmiles()
{
   Free0xE200(3, 80);
   Free0xE200(96, 21);
  //FreeDynPngList();
}

//******************************************************************************

IMGHDR *CreateIMGHDRFromAnyFile(char *fname, int w, int h);

/*void LoadDynImages()
{
  char path[128];
  int picnum;
  IMGHDR* img;
  
  picnum=GetPicNByUnicodeSymbol(FIRST_UCS2_BITMAP+VK_HEADER_ICON);
  snprintf(path, 127, "%simg\\header.png", DIR);
  img=CreateIMGHDRFromPngFile(path, 0);
  AddDynImage(img, picnum);
  
  picnum=GetPicNByUnicodeSymbol(FIRST_UCS2_BITMAP+ITEM1_ICON);
  snprintf(path, 127, "%simg\\i1.jpg", DIR);
  img=CreateIMGHDRFromAnyFile(path, 58, 58);
  AddDynImage(img, picnum);
  
  picnum=GetPicNByUnicodeSymbol(FIRST_UCS2_BITMAP+ITEM2_ICON);
  snprintf(path, 127, "%simg\\i2.jpg", DIR);
  img=CreateIMGHDRFromAnyFile(path, 58, 58);
  AddDynImage(img, picnum);

}
*/

void PNGLIST_Add(IMGHDR* img)
{
  PNGLIST *pl=malloc(sizeof(PNGLIST));
  //char *s=malloc(strlen(path)+1);
  //strcpy(s, path);
  pl->pngname=NULL;
  pl->img=img;
  pl->next=pngtop;
  pngtop=pl;
}

void PNGLIST_Free()
{
  PNGLIST* pl=pngtop;
  
  while(pl)
  {
    if (pl->pngname)
      mfree(pl->pngname);
    
    if (pl->img)
    {
      mfree(pl->img->bitmap);
      mfree(pl->img);
    }
    void* next=pl->next;
    mfree(pl);
    pl=next;
  }
  pngtop=NULL;
}

IMGHDR* PNGLIST_GetImgByIndex(int index)
{
  IMGHDR* img=NULL;
  PNGLIST *pl=pngtop;
  int n=0;
  
  while (pl)
  {
    if (n==index)
      return pl->img;
    pl=pl->next;
    n++;
  }
  return img;
}

void LoadImages()
{
  IMGHDR* img;
  char path[128];

  //1
  snprintf(path, 127, "%simg\\camera.png", APP_DIR);
  img=CreateIMGHDRFromPngFile(path, 0);
  if (img)
    PNGLIST_Add(img);
  
  //0
  snprintf(path, 127, "%simg\\deactivated.png", APP_DIR);
  img=CreateIMGHDRFromPngFile(path, 0);
  if (img)
    PNGLIST_Add(img);
}

void AddImage(IMGHDR* img)
{
  PNGLIST* pl=malloc(sizeof(PNGLIST));
  pl->pngname=NULL;
  pl->img=img;
  pl->next=pngtop;
  pngtop=pl;
}


//******************************************************************************

HObj CreateIMGHDRFromMemoryAsync(int uid, char *buf, int len, int msg)
{//Вызывать только в контексте MMI(CepID==0x4209). SUBPROC не прокатит
  unsigned int err=0;
  HObj obj;
  
#ifdef ELKA  
  short w=58;
  short h=58;
#else
  short w=32;
  short h=32;
#endif  
  
  obj=Obs_CreateObject(uid, 0x2D, 3, msg, 1, 0, &err);
  
  //err=Obs_SetCSM(obj, csm);
  
  //err=Obs_SetUnk2(obj, 3);
  //if (err) goto exit;
  
  err=Obs_SetInputMemory(obj, 0, buf, len);
       
  err=Obs_SetOutputImageSize(obj, w, h);
  
  err=Obs_SetScaling(obj, 0xF);
  
  //err=Obs_SetUnk(obj, 5);
  //if (err) goto exit;
  
  err=Obs_Start(obj);
    
  return obj;
}

HObj CreateIMGHDRFromFileAsync(char *fname, int msg, short w, short h)
{//Вызывать только в контексте MMI(CepID==0x4209). SUBPROC не прокатит
  unsigned int err=0;
  HObj obj;
  int uid;
  
  WSHDR ws;
  unsigned short wsbody[128];
  
  short _w=w;
  short _h=h;
  
  CreateLocalWS(&ws, wsbody, 127);
  wsprintf(&ws, fname);
  uid=GetExtUidByFileName(&ws);
  
  obj=Obs_CreateObject(uid, 0x2D, 2, msg, 1, 0, &err);
  if (err) goto exit;
  
  //err=Obs_SetCSM(obj, (void*)csm);
  
  err=Obs_SetInputFile(obj, 0, &ws);
  if (err) goto exit;
  
  //err=Obs_SetRotation(obj, 0);
  //if (err) goto exit;
  
  if (w==0 || h==0)
  { 
    err=Obs_GetInfo(obj, 0);
    if (err) goto exit;
    
    err=Obs_GetInputImageSize (obj, &_w, &_h);
    if (err) goto exit;
  }
  
  err=Obs_SetOutputImageSize(obj, _w, _h);
  if(err) goto exit;
  
  err=Obs_SetScaling(obj, 0xF);
  if (err) goto exit;

 // err=Obs_Unk(obj, 5);
 // if (err) goto exit;

  //err=Obs_Prepare(obj);
  //if (err) goto exit;
  
  err=Obs_Start(obj);
  return obj;
  
exit:
  Obs_DestroyObject(obj);
  return NULL;
}

//******************************************************************************

IMGHDR *CreateIMGHDRFromAnyFile(char *fname, int w, int h)
{
  IMGHDR *ret=NULL;
  IMGHDR *temp=NULL;
  HObj obj;
  unsigned int err=0;
  int len;
  
  WSHDR ws;
  unsigned short wsbody[128];
  
  short _w=w;
  short _h=h;
  
  CreateLocalWS(&ws, wsbody, 127);
  str_2ws(&ws, fname, 127);
  int uid=GetExtUidByFileName(&ws);
  
  obj=Obs_CreateObject(uid, 0x2D, 0, 0x0, 1, 1, &err);//синхронный режим
  if(err) return(0);
  
  err=Obs_SetInputFile(obj, 0, &ws);
  if(err) goto exit;
  
  if (_w==NULL)
  {
    err=Obs_GetInfo(obj, 0);
    if(err) goto exit;
    
    err=Obs_GetInputImageSize (obj, &_w, &_h);
    if(err) goto exit;
  }
  
  err=Obs_SetOutputImageSize(obj, _w, _h);
  if(err) goto exit;
  
  err=Obs_SetScaling(obj, 0xF);
  if(err) goto exit;
  
  err=Obs_Start(obj);
  if(err) goto exit;
    
  err=Obs_Output_GetPictstruct(obj, &temp);
  if(err) goto exit;
    
  ret=malloc(sizeof(IMGHDR));
  ret->w=temp->w;
  ret->h=temp->h;
  ret->bpnum=(char)temp->bpnum;// читаем только один байт
  len=CalcBitmapSize(temp->w, temp->h,(char)temp->bpnum);
  ret->bitmap=malloc(len);
  memcpy(ret->bitmap, temp->bitmap, len); 

exit:
  Obs_DestroyObject(obj);
  return ret;
}

//******************************************************************************

IMGHDR *CreateIMGHDRFromMemory(short w, short h, int uid, char *buf, int len)//синхронный режим
{
  IMGHDR *imghdr1=NULL;
  IMGHDR *imghdr2=NULL;
  HObj obj;
  unsigned int err=0;
  
  short w2=w;
  short h2=h;
  
  obj=Obs_CreateObject(uid, 0x2D, 0, 0x0, 1, 1, &err);
  if(err) return(0);
  
  err=Obs_SetInputMemory(obj, 0, buf, len);
  if(err)  goto exit;

  if (w==0 || h==0)
  {
    err=Obs_GetInfo(obj, 0);   
    if(err)  goto exit;
    
    err=Obs_GetInputImageSize (obj, &w2, &h2);
    if(err)  goto exit;
  }
  
  err=Obs_SetOutputImageSize(obj, w2, h2);
  if(err)  goto exit;
  
  err=Obs_SetScaling(obj, 0xF);
  if(err)  goto exit;
  
  err=Obs_Start(obj);
  if(err)  goto exit;
    
  err=Obs_Output_GetPictstruct(obj, &imghdr1);
  if(err)  goto exit;
    
  imghdr2=malloc(sizeof(IMGHDR));
  imghdr2->w=imghdr1->w;
  imghdr2->h=imghdr1->h;
  imghdr2->bpnum=(char)imghdr1->bpnum;// читаем только один байт
  len=CalcBitmapSize(imghdr1->w, imghdr1->h,(char)imghdr1->bpnum);
  imghdr2->bitmap=malloc(len);
  memcpy(imghdr2->bitmap, imghdr1->bitmap, len); 

exit:
  Obs_DestroyObject(obj);
  return imghdr2;
}

//******************************************************************************

void CreateDynImage(short w, short h, int uid, int index, char* buf, int len)
{
  int npic=GetPicNByUnicodeSymbol(FIRST_UCS2_BITMAP + index);
  IMGHDR* img=CreateIMGHDRFromMemory(w, h, uid, buf, len);
  AddDynImage(img, npic);
}

//******************************************************************************

void Example(const char *fname)
{
  WSHDR ws;
  unsigned short wsbody[128];
  
  char *buf;
  
  FSTATS stat;
  int f;
  int fsize;
  unsigned  err;
  
  if (GetFileStats(fname, &stat, &err)==-1)
    return;
  
  if ((fsize=stat.size)<=0)
    return; 
  
  if ((f=fopen(fname, A_ReadOnly+A_BIN, P_READ, &err))!= -1)
  {
    buf=malloc(fsize);
    fread(f, buf, fsize, &err);
    fclose(f, &err);
  }
    
    CreateLocalWS(&ws, wsbody, 127);
    wsprintf(&ws, "%s", "jpg");
    CreateDynImage(0, 0, GetExtUid_ws(&ws), FIRST_UCS2_BITMAP, buf, fsize);
}
