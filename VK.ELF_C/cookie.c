#include "cookie.h"
#include <siemens\swilib.h>

typedef struct {
  void *next; 
  char *cookie;
  char domain[64];
} COOKIE_LIST;

COOKIE_LIST *cookie_top=NULL;

extern const char APP_DIR[];

//******************************************************************************

void *Cookies_Get()
{
  return cookie_top;
}

//******************************************************************************

void Cookies_Free()
{
  COOKIE_LIST* c=cookie_top;
  
  while(c)
  {
    if (c->cookie)
      mfree(c->cookie); 
    
    void* next=c->next;
    mfree(c);
    c=next;
  }
  cookie_top=NULL;
}

//******************************************************************************

void Cookies_Save()
{
  int f;
  unsigned  err;
  char rn[]="\r\n";
  char fname[128];
  
  COOKIE_LIST *c;
  
  if ((c=cookie_top)==NULL)
    return;
  
  snprintf(fname, 127, "%scookie", APP_DIR);
    
  if((f=fopen(fname, A_ReadWrite+A_Create+A_Truncate+A_BIN, P_WRITE+P_READ, &err))!=-1)
  {
    while(c)
    {
      fwrite(f, c->domain, strlen(c->domain), &err);
      fwrite(f, ": ", 2, &err);
      fwrite(f, c->cookie, strlen(c->cookie), &err);
      fwrite(f, rn, 2, &err);
      c=c->next;    
    }
    fclose(f, &err);
  }
}

//******************************************************************************

void Cookies_SaveAndFree()
{
  Cookies_Save();
  Cookies_Free();
}

//******************************************************************************

void Cookies_Load()
{
  char *buf;
  char *s;
  char *d;
  int len=0;
  char fname[128];
  
  FSTATS stat;
  int f;
  int fsize;
  unsigned  err;
  
  if(cookie_top)
    return;
  
  snprintf(fname, 127, "%scookie", APP_DIR);
  
  if (GetFileStats(fname, &stat, &err)==-1)
    return;
  
  if ((fsize=stat.size)<=0)
    return; 
  
  if ((f=fopen(fname, A_ReadOnly+A_BIN, P_READ, &err))!= -1)
  {
    buf=malloc(fsize+1);
    buf[fsize]='\0';
    fread(f, buf, fsize, &err);
    fclose(f, &err);
    
    s=buf;
    
    while(len < fsize)
    {
      for(len=0; s[len]==' ' || s[len]=='\r' || s[len]=='\n'; len++);//пропускаем
      if(s[len]=='\0') break;
      s+=len;
      
      for(len=0; !(s[len]==':' || s[len]==0); len++);//ищем разделитель после имени домена 
      if(s[len]=='\0') break;
      s[len]='\0';
      
      d=s;      
      s+=len+1;

      for(len=0; s[len]==' ' || s[len]=='\r' || s[len]=='\n'; len++);//пропускаем
      if(s[len]=='\0') break;
      s+=len;
      
      for(len=0; !(s[len]==' ' || s[len]=='\r' || s[len]=='\n'|| s[len]==0); len++);//ищем конец строки
      if(s[len]=='\0') break;
      s[len]='\0';      
      Cookies_Add(s, d);
      s+=len+1;     
    }
    mfree(buf);
  }
  
}

//******************************************************************************

void Cookies_Add(char *cookie, char *domain)
{
  COOKIE_LIST* c=cookie_top;
  int len;
  
  while(c)
  {
    for(len=0; cookie[len]!='='; len++);
    
    if (strcmp(c->domain, domain)==0)
    {
      if (strncmp(c->cookie, cookie, len + 1)==0)//включая '='
      {//обновляем кукис
        /*if (strncmp(c->cookie+len+1, "DELETED", 7)
        {
          if (c->cookie)
            mfree(c->cookie);
        }*/
        if (c->cookie)
          mfree(c->cookie);
        c->cookie=malloc(strlen(cookie)+1);
        strcpy(c->cookie, cookie);
        return;
      }
    }
    c=c->next;
  }
  
  c=malloc(sizeof(COOKIE_LIST)); 
  snprintf(c->domain, 63, domain); 
  c->cookie=malloc(strlen(cookie)+1);
  strcpy(c->cookie, cookie);
  c->next=cookie_top;
  cookie_top=c; 
}

//******************************************************************************

char* Cookies_GetByHost(char *host)
{
  char *buf;
  int buf_size;
  char *s;  
  char space[]=" ";
  
  COOKIE_LIST* c=cookie_top;
  
  if (c==NULL)
     return NULL;
  
  buf=realloc(buf=NULL, buf_size=256);
  *buf='\0';
  
  while(c)
  {
    s=host;
    
    if (*c->domain=='.')
      s=strchr(host, '.');
    
    if (strcmp(s, c->domain)==0)
    {  
      if(strlen(buf) + strlen(c->cookie) + 2 > buf_size)
        buf=realloc(buf, (buf_size+=256));
      strcat(buf, space);
      strcat(buf, c->cookie);       
    }    
    c=c->next;
  }
  return buf;
}
