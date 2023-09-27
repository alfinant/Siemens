#include "../inc/swilib.h"
#include "../inc/strings.h"
#include "conf_loader.h"
#include "carcontrol_ipc.h"
#include "connector.h"
#include "meas.h"
#include "sms.h"

extern const char MYNUMBER[];
extern const char MAGICWORD[];

//здесь происходит перехват входящих sms сообщений
void my_sms_simif_sm(void)  
{
  SMS *mysms=NULL; 
  char *s;
  GBS_MSG msg;
  
  GBS_ReceiveMessage(&msg);
  
  if(msg.msg==0x69)
  {
    if(mysms=UnpackTPDU((TPDU*)((char*)msg.data0 + 0x28)))
    { 
      if (strcmp_nocase(mysms->number, MYNUMBER)==0) s=mysms->text;
      else
      { //если номер левый, проверяем наличие волшебного слова
        if(s=strchr(mysms->text, ' '))
        {
          *s=0;
          s++;
          if(strcmp_nocase(mysms->text, MAGICWORD) !=0) s=NULL;
        }
           if(!s)
           {
             mfree(mysms);
             mysms=NULL;
           }
      }
      if(mysms)
      { extern void CheckCmd(char *cmd, SMS *sms);
        SUBPROC((void *)CheckCmd, s, mysms);
        //подтвержаем что сообщение успешно получено       
        GBS_AcceptMessage();
        GBS_SendMessage(SMS_TLT_SM, 0x66, 0, 0, 0);
      }
    }
  }
  
  if(!mysms) sms_simif_sm();
  __asm("NOP"); // во избежании генерации инструкции MOV PC,Rn
}

/******************************************************************************/

const int minus11=-11;
const char ipc_my_name[32]=IPC_CARCONTROL_NAME;
IPC_REQ ipc;

extern const char LOGFILE[];

typedef struct
{
  CSM_RAM csm;
}MAIN_CSM;

int maincsm_id;

//Illumination by BoBa 19.04.2007
///////////
/*extern*/ const unsigned int ILL_DISP_RECV=30;
/*extern*/ const unsigned int ILL_KEYS_RECV=30;
/*extern*/ const unsigned int ILL_DYNL_RECV=100;
/*extern*/ const unsigned int ILL_DISP_SEND;
/*extern*/ const unsigned int ILL_RECV_TMR=3;
/*extern*/ const unsigned int ILL_RECV_FADE=256;
/*extern*/ const unsigned int ILL_OFF_FADE=256;
/*extern*/ const int SLI_State=1;

GBSTMR tmr_illumination;
 
#pragma swi_number=0x0036
__swi __arm void SLI_SetState(unsigned char state);

void IlluminationOff(){
  SetIllumination(0,1,0,ILL_OFF_FADE);
  SetIllumination(1,1,0,ILL_OFF_FADE);
  SetIllumination(2,1,0,ILL_OFF_FADE);
  #ifdef ELKA
  if(SLI_State) SLI_SetState(0);
  #endif
}

void IlluminationOn(const int disp, const int key, int dynlight,const int tmr, const int fade){
  if(!tmr) return;
  GBS_DelTimer(&tmr_illumination);
  SetIllumination(0,1,disp,fade);
  SetIllumination(1,1,key,fade);
  SetIllumination(2,1,dynlight,fade);
  #ifdef ELKA
  if(SLI_State) SLI_SetState(SLI_State);
  #endif 
  GBS_StartTimerProc(&tmr_illumination,tmr*225,IlluminationOff);
}
//==============================================================================

GBSTMR tmr_blink;
int blink_n;

void tmr_blink_proc()
{
  if(blink_n & 1)
  {
    GBS_DelTimer(&tmr_blink);
    if(blink_n > 1) SetIllumination(0,1,0,0);
    SetIllumination(1,1,0,0);
    SetIllumination(2,1,0,0);
    #ifdef ELKA
    if(SLI_State) SLI_SetState(0);
    #endif
  }
  else
  {
    SetIllumination(0,1,50,0);
    SetIllumination(1,1,50,0);
    SetIllumination(2,1,100,0);
    #ifdef ELKA
    if(SLI_State) SLI_SetState(1);
    #endif  
  }

  blink_n--;
  if(blink_n > 0)
  {
    if(blink_n & 1) GBS_StartTimerProc(&tmr_blink, 125, tmr_blink_proc);
    else GBS_StartTimerProc(&tmr_blink, 50, tmr_blink_proc);
  }
  
}

void Blink(int n)
{
  blink_n=n+(n-1);
  GBS_DelTimer(&tmr_blink);
  SetIllumination(0,1,50,0); //display
  SetIllumination(1,1,50,0); //key
  SetIllumination(2,1,100,0); //dynlight
  #ifdef ELKA
  if(SLI_State) SLI_SetState(1);
  #endif
  GBS_StartTimerProc(&tmr_blink, 50, tmr_blink_proc);
}

//by KreN 27.09.2007
//============================ воспроизведение звука ===========================
extern const char DIR[];
extern const int soundEnabled;
extern const int sndVolume;
char *sndLock;
char *sndUnlock;

int Play(const char *fname)
{
  if (!IsCalling() && soundEnabled)
  {
    FSTATS fstats;
    unsigned int err;
    if (GetFileStats(fname,&fstats,&err)!=-1)
    {
      PLAYFILE_OPT _sfo1;
      WSHDR* sndPath=AllocWS(128);
      WSHDR* sndFName=AllocWS(128);
      char s[128];
      const char *p=strrchr(fname,'\\')+1;
      str_2ws(sndFName,p,128);
      strncpy(s,fname,p-fname);
      s[p-fname]='\0';
      str_2ws(sndPath,s,128);

      zeromem(&_sfo1,sizeof(PLAYFILE_OPT));
      _sfo1.repeat_num=1;
      _sfo1.time_between_play=0;
      _sfo1.play_first=0;
      _sfo1.volume=sndVolume;
#ifdef NEWSGOLD
      _sfo1.unk6=1;
      _sfo1.unk7=1;
      _sfo1.unk9=2;
      PlayFile(0x10, sndPath, sndFName, GBS_GetCurCepid(), MSG_PLAYFILE_REPORT, &_sfo1);
#else
#ifdef X75
      _sfo1.unk4=0x80000000;
      _sfo1.unk5=1;
      PlayFile(0xC, sndPath, sndFName, 0,GBS_GetCurCepid(), MSG_PLAYFILE_REPORT, &_sfo1);
#else
      _sfo1.unk5=1;
      PlayFile(0xC, sndPath, sndFName, GBS_GetCurCepid(), MSG_PLAYFILE_REPORT, &_sfo1);
#endif
#endif
      FreeWS(sndPath);
      FreeWS(sndFName);
      return 1;
    }else return 0;
  }else return 2; 
}
//==============================================================================
#define  SHORT 0
#define  LONG  1
#define  DOUBLESHORT 2
#define  LONG_AND_SHORT 3

extern const char lock_word[];
extern const char unlock_word[];
extern const char start_word[];
extern const char stop_word[];
extern const char trunk_word[];
extern const char search_word[];
extern const char panicOn_word[];
extern const char panicOff_word[];

extern const int lock_t;
extern const int lock_key1;
extern const int lock_key2;
extern const int lock_delay;

extern const int unlock_t;
extern const int unlock_key1;
extern const int unlock_key2;
extern const int unlock_delay;

extern const int start_t;
extern const int start_key1;
extern const int start_key2;
extern const int start_delay;

extern const int stop_t;
extern const int stop_key1;
extern const int stop_key2;
extern const int stop_delay;

extern const int trunk_t;
extern const int trunk_key1;
extern const int trunk_key2;
extern const int trunk_delay;

extern const int search_t;
extern const int search_key1;
extern const int search_key2;
extern const int search_delay;

extern const int panicOn_t;
extern const int panicOn_key1;
extern const int panicOn_key2;
extern const int panicOn_delay;

extern const int panicOff_t;
extern const int panicOff_key1;
extern const int panicOff_key2;
extern const int panicOff_delay;

int keytab[]={0, TX, RX, CTS, RTS};

GBSTMR tmr_key;
int type,pin1,pin2,n,delay;

void tmr_key_proc()
{
  if(digitalRead(pin1) || digitalRead(pin2))
  {
    pinMode(pin1, INPUT);
    pinMode(pin2, INPUT);
  }
  else
  {
    pinMode(pin1, OUTPUT);
    digitalWrite(pin1, HIGH);
    pinMode(pin2, OUTPUT);
    digitalWrite(pin2, HIGH);
  }
   
  if(type==LONG_AND_SHORT)
  {
    if(pin2) pin1=0;   
  }
  
  n--;
  if(n > 0)
  {  
    if(digitalRead(pin1) == 0 && digitalRead(pin2) == 0 ) GBS_StartTimerProc(&tmr_key, (delay*225)/2, tmr_key_proc);//пауза
    else
      GBS_StartTimerProc(&tmr_key, 10, tmr_key_proc);
  }
}

void keyPress(int _type, int _key1, int _key2, int _delay)
{
  type=_type;
  pin1=keytab[_key1];
  pin2=keytab[_key2];  
  delay=_delay;
  n=1;
  if(type==DOUBLESHORT || type==LONG_AND_SHORT) n=2;
    
  n=n+(n-1);
  
  if(n > 0)
  {
    if(type==LONG_AND_SHORT)
    {
      pinMode(pin1, OUTPUT);
      digitalWrite(pin1, HIGH);
      GBS_StartTimerProc(&tmr_key, delay*225, tmr_key_proc);
    }
    else if(type==DOUBLESHORT)
      {
        pinMode(pin1, OUTPUT);
        digitalWrite(pin1, HIGH);
        GBS_StartTimerProc(&tmr_key, 10, tmr_key_proc);        
      }
    else if(type==SHORT)
      {
        pinMode(pin1, OUTPUT);
        digitalWrite(pin1, HIGH);
        pinMode(pin2, OUTPUT);
        digitalWrite(pin2, HIGH);
        GBS_StartTimerProc(&tmr_key, 10, tmr_key_proc);
      }
    else if(type==LONG)
      {
        pinMode(pin1, OUTPUT);
        digitalWrite(pin1, HIGH);
        pinMode(pin2, OUTPUT);
        digitalWrite(pin2, HIGH);
        GBS_StartTimerProc(&tmr_key, delay * 225, tmr_key_proc);
      }
  }
}
/******************************************************************************/

void CheckCmd(char *cmd, SMS *sms)
{
  char s[32];
  const char *snd;
  
  if(strcmp_nocase(cmd, start_word)==0)
  {
    keyPress(start_t, start_key1, start_key2, start_delay);
    snd=sndUnlock;
  }
  else if(strcmp_nocase(cmd, stop_word)==0)
  {
    keyPress(stop_t, stop_key1, stop_key2, stop_delay);
    snd=sndLock;
  }
  else if(strcmp_nocase(cmd, unlock_word)==0)
  {
    keyPress(unlock_t, unlock_key1, unlock_key2, 0);
    snd=sndUnlock;
  }
  else if(strcmp_nocase(cmd, lock_word)==0)
  {
    keyPress(lock_t, lock_key1, lock_key2, 0);
    snd=sndLock;
  }
  else if(strcmp_nocase(cmd, trunk_word)==0)
  {
    keyPress(trunk_t, trunk_key1, trunk_key2, trunk_delay);
    snd=sndUnlock;
  }
  else if(strcmp_nocase(cmd, search_word)==0)
  {
    keyPress(search_t, search_key1, search_key2, search_delay);
    snd=sndUnlock;
  }  
  else if(strcmp_nocase(cmd, panicOn_word)==0)
  {
    keyPress(panicOn_t, panicOn_key1, panicOn_key2, panicOn_delay);
    snd=sndLock;
  }
  else if(strcmp_nocase(cmd, panicOff_word)==0)
  {
    keyPress(panicOff_t, panicOff_key1, panicOff_key2, panicOff_delay);
    snd=sndLock;
  }  
  else
  {
    cmd=NULL;
    snd=sndLock;
  }
    
  IlluminationOn(ILL_DISP_RECV,ILL_KEYS_RECV,ILL_DYNL_RECV,ILL_RECV_TMR,ILL_RECV_FADE);
  Play(snd);
  
  if(cmd)
  {
    sprintf(s,"CarControl:\n%s", cmd);
    ShowMSG(0x11,(int)s);
  }
  else
    ShowMSG(0x11,(int)"CarControl:\nНеизвестная команда!");

  mfree(sms);
}

GBSTMR tmr_call;

void UnpackIncomingNumber(char *s)
{
  char *p=RamCallState()+ 0x5A;
  //Длина номера в байтах
  int i=*p++;
  //Длина номера в ниблах
  i=s[i]&0x0F?(i-1)*8/4-1:(i-1)*8/4;
  //Если номер в международном формате добавляем '+'
  if (*p++==0x91) {*s='+'; s++;};  
  unsigned int m=0;
  char c=0;
  char c1;
  while(m<i)
  {
    if (m&1) c1=c>>4;
    else c1=(c=*p++)&0x0F;
    *s=c1+0x30; 
    s++;
    m++;
  }
  *s=0;   
}

void tmr_call_proc()
{
  char s[32];
  
  UnpackIncomingNumber(s);
  
  if (strcmp_nocase(s, MYNUMBER)==0)
  {
    keyPress(start_t, start_key1, start_key2, start_delay); // автозапуск двигателя
    EndCall();
  }
}


//============================ Voltage Control =================================

extern const int VOLTAGE_CONTROL_ENA;
extern const int MEASUREMENT_TIME;
extern const int VConst;//разрешение для 1000 mV
extern const int VOffset;//mV, коррекция
extern const int VOffsetMode;
int voltage=-1;

GBSTMR tmr_voltage_control;
void meas_callback(int data);

void tmr_voltage_control_entry()
{
  meas_get_volt_m2(meas_callback); 
}

char dat42;
char dat44;
char dat46;

void meas_callback(int data)
{
  char s[32];
  int VOffset2=0;
  
  SetVibration(50);
  
  //data: 0x800-значение при нуле, 0xFFF-макс. значение   
  int adata = data - 0x800;
  if (VOffsetMode == 0)
    VOffset2 = 0 - VOffset;
  voltage = divide(VConst, adata * 1000) + VOffset2; 
  if (voltage < 0)
    voltage=0;
  
  sprintf(s, "MEAS:0x%X\nV: %dmV ", adata, voltage);
  ShowMSG(1,(int)s );
  
  if (VOLTAGE_CONTROL_ENA)
    GBS_StartTimerProc(&tmr_voltage_control, 225 * MEASUREMENT_TIME, tmr_voltage_control_entry);
    
  SetVibration(0);
}

//==============================================================================

void InitPath()
{
  sndLock=malloc(strlen(DIR)+32);
  sprintf(sndLock, "%sSounds\\lock.wav", DIR);
  
  sndUnlock=malloc(strlen(DIR)+32);
  sprintf(sndUnlock, "%sSounds\\unlock.wav", DIR); 
}

void DeInitPath()
{
  mfree(sndLock);
  mfree(sndUnlock);
}

void destroyApp()
{
  if(sms_simif_sm) DeleteSMSListener();
  if(IsTimerProc(&tmr_illumination)) GBS_DelTimer(&tmr_illumination);
  if(IsTimerProc(&tmr_key)) GBS_DelTimer(&tmr_key);
  if(IsTimerProc(&tmr_call)) GBS_DelTimer(&tmr_call);
  if(IsTimerProc(&tmr_blink)) GBS_DelTimer(&tmr_blink);
  if(IsTimerProc(&tmr_voltage_control)) GBS_DelTimer(&tmr_voltage_control);
  
  DeInitPath();
  RestorePin(TX);
  RestorePin(RX);
  RestorePin(CTS);
  RestorePin(RTS);
  meas_deinit();
}

void startApp()
{
  SetSMSListener((void*)my_sms_simif_sm);
  InitConnectorMap();
  InitPinSafe(TX,1); 
  InitPinSafe(RX,1);
  InitPinSafe(RTS,1);
  InitPinSafe(CTS,1);
  
  if (meas_init())
  {
    if (VOLTAGE_CONTROL_ENA)
      meas_get_volt_m2(meas_callback);
  }
  else
    ShowMSG(1,(int)"Sorry, MEAS driver not install:(");
  
  InitPath();
  Play(sndUnlock);
  Blink(2);
  ShowMSG(0x11,(int)"CarControl запущен!");  
}

void CheckDoubleRun(void)
{
  if ((int)ipc.data !=-1)
  {
    LockSched();
    CloseCSM(maincsm_id);
    UnlockSched();
    ShowMSG(0x11,(int)"CarControl был уже запущен!");   
  }
  else
  {
    SUBPROC((void *) startApp );
  }
}

int maincsm_onmessage(CSM_RAM* data,GBS_MSG* msg)
{ /* имеет смысл только если CTS замкнут на землю
  if(msg->msg == 0x6161)//при вкл/выкл. зарядки, сообщение от AKKU_ANZEIGE(0x4e00)
  {
    InitPinSafe(TX,0); 
    InitPinSafe(RX,0);
    InitPinSafe(RTS,0);
    InitPinSafe(CTS,0); 
  }
*/  
  
  if((short)msg->pid_from==0x420E)// && msg->msg == 0x5A)  // вызов, сообщение от AOC_AL_P(0x420E) 
  {
    if (*RamCallState()==0)//0-входящий, 1-исходящий
    {
      GBS_StartTimerProc(&tmr_call, 225*4, tmr_call_proc);   
    }
  }
 
  if(msg->msg == MSG_RECONFIGURE_REQ) 
  {
    extern const char *successed_config_filename;
    if (strcmp_nocase(successed_config_filename,(char *)msg->data0)==0)
    {
      InitConfig();
      InitPath();
      
      if (VOLTAGE_CONTROL_ENA)
      { 
        if (IsTimerProc(&tmr_voltage_control)==NULL)
          GBS_StartTimerProc(&tmr_voltage_control, 225 * MEASUREMENT_TIME, tmr_voltage_control_entry);          
      }
      else
      {
        if (IsTimerProc(&tmr_voltage_control))
          GBS_DelTimer(&tmr_voltage_control);
      }
      ShowMSG(0x11,(int)"CarControl:\nнастройки обновлены!");
    }
  }  
//IPC
    if (msg->msg==MSG_IPC)
    {
      if (msg->submess!=392305998)
      {
        IPC_REQ *ipc;
        if ((ipc=(IPC_REQ*)msg->data0))
        {
          if (strcmp_nocase(ipc->name_to,ipc_my_name)==0)
          {
            switch (msg->submess)
            {
            case IPC_CHECK_DOUBLERUN:
	    //Если приняли свое собственное сообщение, значит запускаем чекер
	    if (ipc->name_from==ipc_my_name) SUBPROC((void *)CheckDoubleRun);
            else ipc->data=(void *)maincsm_id;
	    break;
            }
          }
        }
      }
    }
  
  return (1);  
}

static void maincsm_oncreate(CSM_RAM *data)
{
  ipc.name_to=ipc_my_name;
  ipc.name_from=ipc_my_name;
  ipc.data=(void *)-1;
  GBS_SendMessage(MMI_CEPID,MSG_IPC,IPC_CHECK_DOUBLERUN,&ipc);
}

extern void kill_data(void *p, void (*func_p)(void *));
void ElfKiller(void)
{
  extern void *ELF_BEGIN;
  kill_data(&ELF_BEGIN,(void (*)(void *))mfree_adr());
}

static void maincsm_onclose(CSM_RAM *csm)
{
  destroyApp();
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
  wsprintf((WSHDR *)(&MAINCSM.maincsm_name),"CarControl2");
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
