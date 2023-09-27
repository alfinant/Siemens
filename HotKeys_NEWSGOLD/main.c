#include "..\inc\swilib.h"
#include "def.h"

#define FRDB  9

typedef struct 
{ CSM_RAM csm;
  int unk28;
  int unk2C;
  int unk30;  
  void *gui; 
  int unk38[3]; 
  int unk44; //pos
  int unk48[8];  
  char *appID;
  int zero;
//----------------------------
  NativeExplorerData expl;
  int EXP_CSM_ID;
  char entry[24];
  WSHDR ws1;
  WSHDR ws2;
  WSHDR ws3;
  unsigned short ws1_body[140];
  unsigned short ws2_body[140];
  unsigned short ws3_body[140];  
} MAIN_CSM;

static int my_handler (void *data) {return (1);}

 int isJAR(WSHDR *fname)
{

  j_wsprintf(&ws,"%s","jar");
  int jar=j_GetExtUid_ws(&ws);
  if(j_GetExtUidByFileName(fname) == jar) return 1;
  return 0;
}   

void _openExplorer(void *data)
{ 
  MAIN_CSM *csm=(MAIN_CSM*)data;
 
  j_zeromem(&csm->expl, sizeof(NativeExplorerData)+4+24);
  
  csm->expl.mode=1;
  csm->expl.path_to_file=j_CreateLocalWS(&csm->ws1,csm->ws1_body, 139);
  j_wsprintf(csm->expl.path_to_file,"%s","0:");
  csm->expl.file_name=j_CreateLocalWS(&csm->ws2,csm->ws2_body, 139);
  csm->expl.full_filename=j_CreateLocalWS(&csm->ws3,csm->ws3_body, 139);
  j_wsprintf(csm->expl.full_filename,"%s","None"); 
  csm->expl.user_handler=my_handler;

/*  
  //Проверяем текущий appID,если наш,то получаеи его путь
  if(memcmp(csm->appID,"FIL_",4)!=0) goto _openExplorer;
  strcpy(csm->entry,"ENTRY_");
  strcat(csm->entry,csm->appID+4);
  SettingsAE_Read_ws(csm->exp_data.full_filename,FRDB,csm->entry,"FILENAME");
  if(isJAR(csm->exp_data.full_filename)==1) goto _openExplorer;
  GetFileNameWithExt(csm->exp_data.full_filename,csm->exp_data.file_name);
  GetFileDir(csm->exp_data.full_filename,csm->exp_data.path_to_file);
*/
  
/*_openExplorer: */
  { //обнуляем первое полуслово wsbody,по нему будем определять выбран файл или нет.
    csm->expl.full_filename->wsbody[0]=0;
    csm->EXP_CSM_ID=j_StartNativeExplorer(&csm->expl);
  }
}

int my_onmessage(CSM_RAM *data, GBS_MSG *msg)
{
  WSHDR ws;
  unsigned short ws_body[140];
  
  MAIN_CSM *csm=(MAIN_CSM*)data;

  if(csm->appID != 0)
  { 
    //устанавливаем имя для 3го пункта меню
    if (msg->msg==0x1B3 && msg->submess==0x2 && (int)msg->data0==2) 
    {
      WSHDR *ws=j_AllocMenuWS(csm->gui, 32);
      j_wsprintf(ws,"<%t>", LGP_FILE);
      _SetItemName(csm, 2, ws);
      csm->unk44=2;
      return 0;
    }
    
  //при открытии 3го пункта меню
  if (msg->msg==0x1B3 && msg->submess==0x1 && (int)msg->data0==2)  
   {
     csm->csm.state=4;
     _openExplorer(csm);
     return 0;
   }
  
  if (msg->msg==MSG_CSM_DESTROYED && (int)msg->data0==csm->EXP_CSM_ID)  
   {
     if(csm->expl.full_filename->wsbody[0]!=0) 
     {
       int index=j_FRDB_GetIndex(csm->expl.full_filename);
       if( index==-1)
       {
         j_CreateLocalWS(&ws, ws_body, 139);
         do {
           index++;
           j_sprintf(csm->entry,"ENTRY_%.10lu",index);
         } while(j_SettingsAE_Read_ws(&ws,FRDB,csm->entry,"FILENAME"));
         
         if(isJAR(csm->expl.full_filename)==1) j_SettingsAE_SetFlag(0,FRDB,csm->entry,"RESIDENTMIDLET");
         j_SettingsAE_SetFlag(0,FRDB,csm->entry,"READONLY"); 
         j_SettingsAE_Update_ws(csm->expl.full_filename,FRDB,csm->entry,"FILENAME");
       }
       j_sprintf(csm->appID,"FIL_%.10lu",index);
       j_GBS_SendMessage(MMI_CEPID,0x01B3,3);
     }
     else csm->csm.state=1;
     return 0;
   }
  }
  return onmessage_hotkey_menu(data,msg); 
}


