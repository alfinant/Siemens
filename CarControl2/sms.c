#include "../inc/swilib.h"
#include "sms.h"

typedef struct{ 
  int word[26]; 
}GBSPROC;

#pragma swi_number=0x385
__swi __arm GBSPROC *GBS_GetProcAddress(short cepid);

static GBSPROC* gproc;
void (*sms_simif_sm)();

//sms_hook
void SetSMSListener(void *new_handler)
{
  gproc = GBS_GetProcAddress(SMS_SIMIF_SM);
  sms_simif_sm = (void(*)()) gproc->word[15];
  gproc->word[15] = (int) new_handler;  
}

void DeleteSMSListener()
{
  gproc->word[15] = (int) sms_simif_sm;  
}

//код распаковки (c)BoBa
SMS *UnpackTPDU(TPDU *tpdu)
{ 
  char *s;
  const char *p=tpdu->data;
  SMS *sms=NULL;
  unsigned int i;
  unsigned int m;
  int c;
  int c1;
  int c2;
  unsigned int is_udhl;
  if ((*p++)!=1) return NULL;
  if ((*p++)==0) return NULL; //длина TPDU
  is_udhl=*p&0x40;
  if ((*p++)&3) return NULL; //Неподходящий тип сообщения ;)
  s=malloc(sizeof(SMS));
  zeromem(s, sizeof(SMS));
  sms=(SMS*)s;
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
         
  //PID-идентификатор протокола,пропускаем
  p++;
  //DCS-схема кодирования данных 
  c1=*p++;
  //SCTS-Время/дата
  s=sms->time;
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
    s=sms->header;
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

  s=sms->text;
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
 // *s=0x0D; s++;
 // *s=0x0A; s++; 
  *s=0;

  return sms;
}
/******************************************************************************/
