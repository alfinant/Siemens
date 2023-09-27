#include "..\inc\swilib.h"
#include "rets.h"

#define FAK   0
#define FRDB  9

typedef struct 
{ CSM_RAM csm;
  char unk_data[0x40];
  char *appID;
  int zero;
  NativeExplorerData exp_data;
  int EXP_CSM_ID;
  char entry[24];
} MAIN_CSM;

static int my_handler (void *data) {return (1);}

 int isJAR(WSHDR *FileName)
{
   WSHDR *ws=AllocWS(20);
   wsprintf(ws,"%s","jar");
   int i=GetExtUid_ws(ws);
   FreeWS(ws);
   int j=GetExtUidByFileName(FileName);
   if(i==j) return 1;
   return 0;
}   

void openItem(void *data)
{ 
  MAIN_CSM *csm=(MAIN_CSM*)data;
 
  zeromem(&csm->exp_data,0x88);
  
  WSHDR *patch_to_folder=AllocWS(0x80);
  wsprintf(patch_to_folder,"%s","0:");
  
  WSHDR *full_filename=AllocWS(0x80);
  wsprintf(full_filename,"%s","None");  
  
  WSHDR *filename=AllocWS(0x80);

  csm->exp_data.mode=1;
  csm->exp_data.dir_enum=0x26;
  csm->exp_data.path_to_file=patch_to_folder;
  csm->exp_data.file_name=filename;
  csm->exp_data.full_filename=full_filename;
  csm->exp_data.unk9=1;
  csm->exp_data.user_handler=my_handler;
  csm->exp_data.this_struct_addr=csm;

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
    csm->exp_data.full_filename->wsbody[0]=0;
    csm->EXP_CSM_ID=StartNativeExplorer(&csm->exp_data);
  }
}

int my_onmessage(CSM_RAM *data, GBS_MSG *msg)
{
  MAIN_CSM *csm=(MAIN_CSM*)data;
  //устанавливаем имя для 3го пункта меню
  if (msg->msg==0x1B3 && msg->submess==0x2 && (int)msg->data0==2)  
   {
     
   }
  
  if (msg->msg==MSG_CSM_DESTROYED && (int)msg->data0==csm->EXP_CSM_ID)  
   {
     if(csm->exp_data.full_filename->wsbody[0]!=0) 
      { int index=_FRDB_GetIndex(csm->exp_data.full_filename);
        if( index==-1)
         {  WSHDR *ws=AllocWS(0x80);
           do {  index++;
                 sprintf(csm->entry,"ENTRY_%.10lu",index);
              }  while(_SettingsAE_Read_ws(ws,FRDB,csm->entry,"FILENAME"));
            if(isJAR(csm->exp_data.full_filename)==1) _SettingsAE_SetFlag(0,FRDB,csm->entry,"RESIDENTMIDLET");
            _SettingsAE_SetFlag(0,FRDB,csm->entry,"READONLY"); 
            _SettingsAE_Update_ws(csm->exp_data.full_filename,FRDB,csm->entry,"FILENAME");            
            FreeWS(ws);                    
         }    
       sprintf(csm->appID,"FIL_%.10lu",index);
       GBS_SendMessage(MMI_CEPID,0x01B3,3);
     }    
  else csm->csm.state=1; 

   FreeWS(csm->exp_data.path_to_file);  
   FreeWS(csm->exp_data.file_name);
   FreeWS(csm->exp_data.full_filename);
   return 0;
  }
  
   return menu_onmessage(data,msg); 
}


