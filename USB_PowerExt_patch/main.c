#include <siemens\swilib.h>
#include "def.h"

/*
typedef struct
{
  int mode; //0-normal mode, 1-select mode 
  int dir_enum; //0x26 by default
  WSHDR* path_to_file; //path to file
  WSHDR* file_name; //put cursor to this file
  int unk5;
  int is_exact_dir;
  int unk7;
  int unk8;
  int unk9;
  int unk10;
#ifdef NEWSGOLD  
  int unk11;
#endif 
  WSHDR* full_filename;
  int unk13;
  int (*user_handler)(void*); //called in select mode
  void* this_struct_addr;
  int unk16;
  int unk17_26[10]; 
}NativeExplorerData;
*/

typedef struct 
{ 
/*0x00*/ CSM_RAM csm;
/*0x28*/ int unk28;
/*0x2C*/ int unk2C;
/*0x30*/ void *gui;
/*0x34*/ int unk34;
/*0x38*/ int unk38;
/*0x3C*/ int unk3C;
/*0x40*/ int unk40;
/*0x44*/ int *unk44;
/*0x48*/ char *appid_cur;
/*0x4C*/ int unk4C;
/*0x50*/ int unk50; 
/*0x54*/ int unk54;
/*0x58*/ int unk58;
/*0x5C*/ void *unk5C;
/*0x60*/ int unk60;
/*0x64*/ int unk64;
/*0x68*/ const char appid[16];
/*0x78*/ char *appid_new;
/*0x7C*/ int unk7C;
/*0x80*/ int unk80;
//------------------------------------------
/*0x84*/ NativeExplorerData expl; //0x64
/*0x88*/ int EXP_CSM_ID;
/*0x98*/ WSHDR ws1;
/*0x98*/ WSHDR ws2;
/*0x98*/ WSHDR ws3;
/*0x8C*/ unsigned short ws1_body[140];
/*0x8C*/ unsigned short ws2_body[140];
/*0x8C*/ unsigned short ws3_body[140];
} MAIN_CSM;

int isNoJava(char * fname)
{ 
  return j_strcmp(fname+j_strlen(fname)-2, "jar");
}

//показываем вместо имени папки имя файла
void setFName(int *data, char *fname)
{
  int len;
  char *s;
  WSHDR *ws;
  
  s=j_strrchr(fname, '\\') + 1;
  if((len=j_strrchr(s, '.') - s) < 0 ) len=j_strlen(s);
  ws=j_AllocWS(len);
  data[30]=(int)ws;
  j_str_2ws(ws, s, len);
  somecode_2(ws, data[4]);
}

void checkFile(char *fname)
{
  WSHDR ws;
  unsigned short ws_body[140];
  
  j_CreateLocalWS(&ws, ws_body, 139);
  if(isNoJava(fname)==0) j_StartMidlet(fname, 1);
  else
  {
    j_str_2ws(&ws, fname, 139);
    j_ExecuteFile(&ws,0,0);
  }
}   

int my_handler (void *data) {return (1);}

void _OpenExplorer(MAIN_CSM *csm)
{  
  j_zeromem(&csm->expl, sizeof(NativeExplorerData));
        
  csm->expl.mode=1;
  csm->expl.path_to_file=j_CreateLocalWS(&csm->ws1,csm->ws1_body, 140);
  j_wsprintf(csm->expl.path_to_file,"%s","0:");
  csm->expl.file_name=j_CreateLocalWS(&csm->ws2,csm->ws2_body, 140);
  csm->expl.full_filename=j_CreateLocalWS(&csm->ws3,csm->ws3_body, 140);
  j_wsprintf(csm->expl.full_filename,"%s","None"); 
  csm->expl.user_handler=my_handler;
  //csm->expl->this_struct_addr=csm;
   
//обнуляем первое полуслово wsbody,по нему определятся выбран файл или нет.                               
  csm->expl.full_filename->wsbody[0]=0;
  csm->EXP_CSM_ID=j_OpenExplorer(&csm->expl);
}

int my_onmessage(CSM_RAM *data, GBS_MSG *msg)
{
  WSHDR *ws;
  int crc;
  int reslen;
  char str[140];
  char entry[32];
       
  MAIN_CSM *csm=(MAIN_CSM*)data; 
  //устанавливаем имя для 3го пункта меню
  if (msg->msg==0x1B4 && msg->submess==0x66 && (int)msg->data0==2)  
   { 
     ws=j_AllocMenuWS(csm->gui, 32);
     j_wsprintf(ws,"<%t>",LGPID_FILE);
     somecode_1(csm, 2, ws, (void*)SHORTCUTS_BASE);
     csm->unk40=2;
     return 0;
   }
  //при открытии 3го пункта меню
  if (msg->msg==0x1B4 && msg->submess==0x65 && (int)msg->data0==2)  
   {
     csm->csm.state=4;
     _OpenExplorer(csm);
     return 0;
   }
  //выбрали файл в CardExplorer
  if (msg->msg==MSG_CSM_DESTROYED && (int)msg->data0==csm->EXP_CSM_ID)  
   {
     if(csm->expl.full_filename->wsbody[0]!=0)
     {
       j_ws_2str(csm->expl.full_filename, str, 139);
       crc=j_strcrc32(str);
       j_sprintf(entry,"%1u", crc);
       j_SettingsRead(0x302, entry, str, &reslen);
       if(reslen==0)
       {
         j_SettingsWrite(0x302, entry, str, j_strlen(str));//запись в javaregdb.pd
         j_SettingsUpdate(0x302, entry);//добавили в кэш
       }
       j_sprintf(csm->appid_new, "XTRA_JC%08x", crc);
       j_GBS_SendMessage(0x4209, 0x1B6, 1, csm->appid_new, csm->appid_cur);
       csm->appid_new=0;
       csm->unk50=1;
       csm->csm.state=-3;
     }

       if(csm->expl.full_filename->wsbody[0]==0) csm->csm.state=1;
       return 0;
   }
  return onmessage_hotkey_menu(data, msg);
}
