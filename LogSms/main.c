#include <siemens\swilib.h>
#include "strings.h"
#include "conf_loader.h"

#define   EMSAL_PROCESS      0x4210

typedef struct{ 
  int word[26]; 
}GBSPROC;
 
#pragma swi_number=0x385
__swi __arm GBSPROC *GBS_GetProcAddress(short cepid);

GBSPROC * gproc;

void (*old_sms_rlt_sm)();

char *UnpackSMS(const PDU *sms)
{
  char *s;
  const char *p=sms->data;
  char *ss=NULL;
  unsigned int i;
  unsigned int m;
  int c;
  int c1;
  int c2;
  unsigned int is_udhl;
  if ((*p++)!=0x11) return NULL;
  if ((*p++)!=0x11) return NULL;
  p++;//if (!(*p++)) return NULL; пропускаю ибо у меня там нуль
  c=*p++; //Пропускаем SCA
  p+=c;
  is_udhl=*p&0x40;
  if ((*p++)&3) goto LERR; //Неподходящий тип сообщения ;)
  s=malloc(256);
  ss=s;
  i=*p++; //Длина номера в нибблах
  if (*p == 0x91) {*s='+'; s++; } /* если интернациональный номер,добавляем символ '+' */
  if (*p == 0xD0)  /* алфавитно-цифровой тип номера */
{
  p++;
  m = (i * 4 / 7); /* кол-во символов в номере */
  i = 0;
  c2 = 0;
  while(m)
  {
    c=0x80;    do
    {
      if(!i) {c2=*p++; i=8;}
      c>>=1;
      if(c2&1) c|=0x80;
      c2>>=1; i--;
    }while(!(c&1)); 
    c>>=1;
    if(!c) c='@';
    if(c==2) c='$';
    *s = c; s++;
    m--;
  }

}
  else
  {
    p++;
    m=0;
    c=0;
    while(m<i)
    {
      if (m&1) c1=c>>4; else c1=(c=(*p++))&0x0F;
      *s=c1+0x30;
      s++;
      m++;
    }
  }
         
  *s=' '; s++;
  //PID-идентификатор протокола,пропускаем
  p++;
  //DCS-схема кодирования данных 
  c1=*p++;
  //SCTS-Время/дата
  m=6;
  do
  {
    c=*p++;
    *s=(c&0x0F)+'0'; s++;
    *s=(c>>4)+'0'; s++;
    switch(m)
    {
    case 6:
    case 5:
      c='-';
      break;
    case 3:
    case 2:
      c=':';
      break;
    default:
      c=' ';
    }
    *s=c; s++;
  }
  while(--m);
  p++; //Пропускаем TimeZone
  m=*p++; //Длинна текста
  if (is_udhl)
  {
    //Есть доп. заголовок, вычитываем
    is_udhl=*p; //Длина поля данных заголовка
    c=p[1];
    if ((c==0)||(c==8))
    {
      //Длинная смс, добавляем номер
      if (c)
      {
	c=p[6];
	c2=p[5];
      }
      else
      {
	c=p[5];
	c2=p[4];
      }
      s+=sprintf(s,"%u/%u ",c,c2);
    }
    is_udhl++; //Длина заголовка с учетом байта длинны
    
    c1 &= 0xC;/* кодировка */
    
    if (c1 == 0)
    {
      //Для сообщения 7-бит
      is_udhl=((is_udhl*8)+6)/7; //Преобразуем в число пропускаемых септетов
    }
    else if(c1 == 8 || c1 == 4)
    {
      //Для сообщения в юникоде или 8 бит
      p+=is_udhl; //Указатель на текст
      m-=is_udhl; //Убрать длинну
      is_udhl=0; //Все уже пропущено
    }
  }
  
  i=0;
  c2=0;
  if (c1==8) m>>=1;
  while(m)
  {
    switch(c1)
    {
    default:
      //7 бит
      c=0x80; //Символ
      do
      {
	if (!i) {c2=*p++; i=8;}
	c>>=1;
	if (c2&1) c|=0x80;
	c2>>=1; i--;
      }
      while(!(c&1));
      c>>=1;
      if (!c) c='@';
      if (c==2) c='$';
      break;
      
    case 4:
      //8 бит
      c=*p++;
      break;
      
    case 8:
      //Юникод
      i=(*p++)<<8;
      i|=(*p++);
      if ((i>=0x410)&&(i<0x450)) i-=0x350;
      c=i;
      break;
    }
    if (!c) c='?';
    if ((c==0x0A)||(c==0x0D)) c=' ';
    if (is_udhl) //Если необходимо пропустить символы
    {
      is_udhl--; //Пропускаем
    }
    else
    {
      *s=c; s++;
    }
    m--;
  }
  *s=0x0D; s++;
  *s=0x0A; s++; 
  *s=0;
LERR:
  return ss;
}

void my_emsal_process(void)  
{  
  GBS_MSG msg;
  zeromem(&msg, sizeof(GBS_MSG));
  GBS_ReceiveMessage(&msg);

  if (msg.msg == 0x6100) 
  {  
    char *text=UnpackSMS(IncommingPDU());
extern void WriteLog(char *text);
    if(text) SUBPROC((void *)WriteLog, text);
  }
  old_sms_rlt_sm(); 
  __asm("NOP"); // чтобы исключить генерацию невыполнимой инструкции MOV PC,Rn
}
  

void SetSMSListener()
{
  gproc = GBS_GetProcAddress(EMSAL_PROCESS);
  old_sms_rlt_sm = (void(*)()) gproc->word[15]; // сохраняем адрес легитимного обработчика:)
  gproc->word[15] = (int) my_emsal_process;  
}

void DeleteSMSListener()
{
  gproc->word[15] = (int) old_sms_rlt_sm;  
}

/******************************************************************************/

const int minus11=-11;
extern const char LOGFILE[];

typedef struct
{
  CSM_RAM csm;
}MAIN_CSM;

int maincsm_id;

int maincsm_onmessage(CSM_RAM* data,GBS_MSG* msg)
{
  if(msg->msg == MSG_RECONFIGURE_REQ) 
  {
    extern const char *successed_config_filename;
    if (strcmp_nocase(successed_config_filename,(char *)msg->data0)==0)
    {
      ShowMSG(0x11,(int)"LogSms config updated!");
      InitConfig();
    }
  }  
  
  return (1);  
}

static void maincsm_oncreate(CSM_RAM *data)
{ 
}

extern void kill_data(void *p, void (*func_p)(void *));
void ElfKiller(void)
{
  extern void *ELF_BEGIN;
  kill_data(&ELF_BEGIN,(void (*)(void *))mfree_adr());
}

static void maincsm_onclose(CSM_RAM *csm)
{
    DeleteSMSListener();
    SUBPROC((void *)ElfKiller);
}


static unsigned short maincsm_name_body[140];

static const struct
{
  CSM_DESC maincsm;
  WSHDR maincsm_name;
}MAINCSM =
{
  {
  maincsm_onmessage,
  maincsm_oncreate,
#ifdef NEWSGOLD
  0,
  0,
  0,
  0,
#endif
  maincsm_onclose,
  sizeof(MAIN_CSM),
  1,
  &minus11
  },
  {
    maincsm_name_body,
    NAMECSM_MAGIC1,
    NAMECSM_MAGIC2,
    0x0,
    139
  }
};


static void UpdateCSMname(void)
{
  wsprintf((WSHDR *)(&MAINCSM.maincsm_name),"LogSms");
}

void WriteLog(char *text)
{
  unsigned int ul;
  if (!text) return;
  int f=fopen(LOGFILE,A_ReadWrite+A_Create+A_Append+A_BIN,P_READ+P_WRITE,&ul);
  if (f!=-1)
  {    
    fwrite(f,text,strlen(text),&ul);
    fclose(f,&ul);
  }
  mfree(text);
}

int main(void)
{
  SetSMSListener();
  
  InitConfig();
  CSM_RAM *save_cmpc;
  char dummy[sizeof(MAIN_CSM)];
  UpdateCSMname();  
  LockSched();
  save_cmpc=CSM_root()->csm_q->current_msg_processing_csm;
  CSM_root()->csm_q->current_msg_processing_csm=CSM_root()->csm_q->csm.first;
  maincsm_id=CreateCSM(&MAINCSM.maincsm,dummy,0);
  CSM_root()->csm_q->current_msg_processing_csm=save_cmpc;
  UnlockSched();

  
  return 0;
}
