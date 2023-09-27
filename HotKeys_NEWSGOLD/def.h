#ifdef E71v45
#define LGP_FILE 0xDA9
#define onmessage_hotkey_menu  (*(int(*)(CSM_RAM *,GBS_MSG*))0xA063B877)
#define _SetItemName           (*(void(*)(void *csm,int pos,WSHDR *ws))0xA063B4A1)
//#define GetFileNameWithExt   (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA06F3583)
//#define GetFileName          (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA06F35CB)
//#define GetFileDir           (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA06F3549)
#define j_FRDB_GetIndex        (*(int(*)(WSHDR * FileName))0xA06354C1)
#define j_SettingsAE_Read_ws   (*(int(*)(WSHDR *,int setting,char * entry,char *keyword)) 0xA05ACFEB)
#define j_SettingsAE_SetFlag   (*(int(*)(int val,int setting,char * entry,char *keyword)) 0xA05ACF85)
#define j_SettingsAE_Update_ws (*(int(*)(WSHDR *,int setting,char * entry,char *keyword)) 0xA05AD02D)
#define j_CreateLocalWS        (*(WSHDR*(*)(WSHDR *wshdr,unsigned short *wsbody,int len)) 0xA04FB25B)
#define j_AllocMenuWS          (*(WSHDR*(*)(void *gui, int len)) 0xA095469D)
#define j_wsprintf             (*(int(*)(WSHDR *,const char *format,...)) 0xA093EB4D)
#define j_GetExtUid_ws         (*(int(*)(WSHDR * ext)) 0xA0502624)
#define j_GetExtUidByFileName  (*(int(*)(WSHDR * fname)) 0xA05026F8)
#define j_zeromem              (*(void(*)(void *dest,int n)) 0xA0FAFC00)
#define j_StartNativeExplorer  (*(int(*)(NativeExplorerData*)) 0xA0699924)
#define j_sprintf              (*(int(*)(char *buf, const char *str, ...)) 0xA093EB4D)
#define j_GBS_SendMessage      (*(void(*)(int cepid_to, int msg, ...)) 0xA0091EAB)
#endif 

//==============================================================================

#ifdef S75v52
#define LGP_FILE 0xDA9
#define onmessage_hotkey_menu  (*(int(*)(CSM_RAM *,GBS_MSG*))0xA02CE88F)  
#define _SetItemName           (*(void(*)(void *csm,int pos,WSHDR *ws))0xA02CE4B9)
//#define GetFileNameWithExt   (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA03373BB)
//#define GetFileDir           (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA0337381)
#define j_FRDB_GetIndex        (*(int(*)(WSHDR * FileName))0xA02C8FA9)
#define j_SettingsAE_Read_ws   (*(int(*)(WSHDR *,int setting,char * entry,char *keyword)) 0xA028A779)
#define j_SettingsAE_SetFlag   (*(int(*)(int val,int setting,char * entry,char *keyword)) 0xA028A713)
#define j_SettingsAE_Update_ws (*(int(*)(WSHDR *,int setting,char * entry,char *keyword)) 0xA028A7BB)
#define j_CreateLocalWS        (*(WSHDR*(*)(WSHDR *wshdr,unsigned short *wsbody,int len)) 0xA01F7653)
#define j_AllocMenuWS          (*(WSHDR*(*)(void *gui, int len)) 0xA097D8E1)
#define j_wsprintf             (*(int(*)(WSHDR *,const char *format,...)) 0xA0968D75)
#define j_GetExtUid_ws         (*(int(*)(WSHDR * ext)) 0xA04D43DB)
#define j_GetExtUidByFileName  (*(int(*)(WSHDR * fname)) 0xA04D445D)
#define j_zeromem              (*(void(*)(void *dest,int n)) 0xA0FC496C)
#define j_StartNativeExplorer  (*(int(*)(NativeExplorerData*)) 0xA052A5F7)
#define j_sprintf              (*(int(*)(char *buf, const char *str, ...)) 0xA0FC3785)
#define j_GBS_SendMessage      (*(void(*)(int cepid_to, int msg, ...)) 0xA0092A94)
#endif 

//==============================================================================

#ifdef EL71v45
#define menu_onmessage         (*(int(*)(CSM_RAM *,GBS_MSG*))0xA063D4A7)   
#define FRDB_GetIndex          (*(int(*)(WSHDR * FileName))0xA06370F1)             
//#define GetFileNameWithExt   (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA0700BE7)
//#define GetFileDir           (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA0700BAD)
#endif

//==============================================================================

#ifdef S75v47
#define onmessage_hotkey_menu  (*(int(*)(CSM_RAM *,GBS_MSG*))0xA02CE617)
#define _FRDB_GetIndex         (*(int(*)(WSHDR * FileName))0xA02C8D31)              
//#define GetFileNameWithExt   (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA0336F8F)
//#define GetFileDir           (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA0336F55)
#endif

//==============================================================================

#ifdef C81v51
#define onmessage_hotkey_menu       (*(int(*)(CSM_RAM *,GBS_MSG*))0xA02D1897)
//#define GetFileNameWithExt   (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA06F3583)
//#define GetFileName          (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA06F35CB)
//#define GetFileDir           (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA06F3549)
#endif




