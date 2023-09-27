#ifdef C81v51
       #define menu_onmessage       (*(int(*)(CSM_RAM *,GBS_MSG*))0xA02D1897)
       #define GetFileNameWithExt   (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA06F3583)
       #define GetFileName          (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA06F35CB)
       #define GetFileDir           (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA06F3549)
       #define JAM_StartApp         (*(int(*)(WSHDR * FileName,int param1,void *param2,void *param3))0xA09EE55D)
       #define isdir_ws             (*(int(*)(WSHDR * cDirectory, unsigned int *ErrorNumber))0xA0568028)
       #define UnkFunc              (*(void(*)(void *unk1,void *unk2,int d,WSHDR *text,int item_id,int unk3,void *mfree_adr))0xA033Ñ945)
       #define OpenBookmarks        (*(void(*)(char *appid))0xA033CFC5)
#endif 


#ifdef E71v45
       #define menu_onmessage       (*(int(*)(CSM_RAM *,GBS_MSG*))0xA063B877)
       #define FRDB_GetIndex        (*(int(*)(WSHDR * FileName))0xA06354C1)
       #define GetFileNameWithExt   (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA06F3583)
       #define GetFileName          (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA06F35CB)
       #define GetFileDir           (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA06F3549)
       #define JAM_StartApp         (*(int(*)(WSHDR * FileName,int param1,void *param2,void *param3))0xA09EE55D)
       #define isdir_ws             (*(int(*)(WSHDR * cDirectory, unsigned int *ErrorNumber))0xA0568028)
       #define UnkFunc              (*(void(*)(void *csm,int pos,WSHDR *ws))0xA063B4A1)
       #define UnkFunc2             (*(void(*)(void *unk1,void *unk2,int d,WSHDR *text,int item_id,int unk3,void *mfree_adr))0xA06ED2B5)
       #define OpenBookmarks        (*(void(*)(char *appid))0xA06ED935)
#endif  

#ifdef EL71v45
       #define menu_onmessage       (*(int(*)(CSM_RAM *,GBS_MSG*))0xA063D4A7)   
       #define FRDB_GetIndex        (*(int(*)(WSHDR * FileName))0xA06370F1)             
       #define GetFileNameWithExt   (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA0700BE7)
       #define GetFileDir           (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA0700BAD)
       #define JAM_StartApp         (*(int(*)(WSHDR * FileName,int param1,int param2,int param3))0xFFFFFFFF)
       #define isdir_ws             (*(int(*)(WSHDR * cDirectory, unsigned int *ErrorNumber))0xFFFFFFFF)
       #define UnkFunc              (*(void(*)(void *csm,int pos,WSHDR *ws))0xFFFFFFFF)
#endif

#ifdef S75v47
       #define menu_onmessage       (*(int(*)(CSM_RAM *,GBS_MSG*))0xA02CE617)
       #define _FRDB_GetIndex        (*(int(*)(WSHDR * FileName))0xA02C8D31)              
       #define GetFileNameWithExt   (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA0336F8F)
       #define GetFileDir           (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA0336F55)
       #define JAM_StartApp         (*(int(*)(WSHDR * FileName,int param1,int param2,int param3))0xFFFFFFFF)
       #define _isdir_ws             (*(int(*)(WSHDR * cDirectory, unsigned int *ErrorNumber))0xFFFFFFFF)
       #define UnkFunc              (*(void(*)(void *csm,int pos,WSHDR *ws))0xFFFFFFFF)
#endif

#ifdef S75v52
#define LGP_FILE 0xDA9
#define menu_onmessage        (*(int(*)(CSM_RAM *,GBS_MSG*))0xA02CE88F)  
#define _FRDB_GetIndex        (*(int(*)(WSHDR * FileName))0xA02C8FA9)
#define _SettingsAE_Read_ws   (*(int(*)(WSHDR *,int setting,char * entry,char *keyword)) 0xA028A779)
#define _SettingsAE_SetFlag   (*(int(*)(int val,int setting,char * entry,char *keyword)) 0xA028A713)
#define _SettingsAE_Update_ws (*(int(*)(WSHDR *,int setting,char * entry,char *keyword)) 0xA028A7BB)
#define GetFileNameWithExt    (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA03373BB)
#define GetFileDir            (*(int(*)(WSHDR * FileName,WSHDR *dest))0xA0337381)
#define JAM_StartApp          (*(int(*)(WSHDR * FileName,int param1,int param2,int param3))0xFFFFFFFF)
#define UnkFunc               (*(void(*)(void *csm,int pos,WSHDR *ws))0xFFFFFFFF)
#endif 




