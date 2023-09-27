#ifndef DEF_H_
#define DEF_H_

#ifdef CX70v56
#define LGPID_FILE 0x0DEC
#define SHORTCUTS_BASE 0xA09476DC
#define onmessage_hotkey_menu (*(int(*)(CSM_RAM *,GBS_MSG*))0xA08FA2CB)              
#define somecode_1            (*(void(*)(void *csm,int pos,WSHDR *ws, void* ))0xA08F9F0B)
#define somecode_2            (*(void(*)(WSHDR *, char )) 0xA08C62DF)
#define somecode_3  0xA0CECC87
#define back_addr   0xA171B87B
#define j_strcrc32            (*(int(*)(const char *str)) 0xA0BF5699)
#define j_SettingsRead        (*(int(*)(short , const char * entry , const char *uni_str, int *reslen))0xA0B8AA2B)//javaregdb==0x302
#define j_SettingsWrite       (*(int(*)(short , const char * entry , const char  *uni_str, int len))0xA0B8AA33)
#define j_SettingsUpdate      (*(int(*)(short , const char * entry ))0xA0B8AA69)
//------------------------------------------------------------------------------
#define j_AllocWS             (*(WSHDR*(*)(int len))0xA0C8CFB7)
#define j_FreeWS              (*(void(*)(WSHDR *wshdr))0xA0C8C901)
#define j_CreateLocalWS       (*(WSHDR*(*)(WSHDR *wshdr,unsigned short *wsbody,int len))0xA0C8CF4F)
#define j_AllocMenuWS         (*(WSHDR*(*)(void *gui, int len))0xA0C96D21)
#define j_strrchr             (*(char*(*)(const char *, int c))0xA16EF621)
#define j_strcmp              (*(int(*)(const char *, const char*))0xA16EF3BC)
#define j_str_2ws             (*(int(*)(WSHDR *ws, const char *str, unsigned int size))0xA113A6A4)
#define j_ws_2str             (*(int(*)( WSHDR *from, char *to ,int len))0xA113A7C4)
#define j_strlen              (*(unsigned(*)(const char *))0xA16EF4D9)
#define j_wstrlen             (*(int(*)(WSHDR *))0xA0C8CA1B)
#define j_wsprintf            (*(int(*)(WSHDR *,const char *format,...))0xA0C8C7BF)
#define j_sprintf             (*(int(*)(char *buf, const char *str, ...))0xA1610211)
#define j_zeromem             (*(void(*)(void *dest,int n))0xA16EEC14)
#define j_StartMidlet         (*(int(*)(const char *fname, int))0xA0CD94A4)
#define j_OpenExplorer        (*(int(*)(NativeExplorerData*)) 0xA098F71C)
#define j_ExecuteFile         (*(int(*)(WSHDR *filepath, WSHDR *mimetype, void *param))0xA09526B8)
#define j_GBS_SendMessage     (*(void(*)(int cepid_to, int msg, ...))0xA0827B04)
#endif

//==============================================================================

#ifdef CX75v25
#define LGPID_FILE 0x13A7
#define SHORTCUTS_BASE 0xA04B4368
#define onmessage_hotkey_menu (*(int(*)(CSM_RAM *,GBS_MSG*))0xA032A20F)              
#define somecode_1            (*(void(*)(void *csm,int pos,WSHDR *ws, void* ))0xA0329E53)
#define somecode_2            (*(void(*)(WSHDR *, char ))0xA02B7DAB)
#define j_strcrc32            (*(int(*)(const char *str))0xA049DEBC)
#define j_SettingsRead        (*(int(*)(short , const char * entry , const char *uni_str, int *reslen))0xA049DEE0)//javaregdb==0x302
#define j_SettingsWrite       (*(int(*)(short , const char * entry , const char  *uni_str, int len))0xA049DEC8)
#define j_SettingsUpdate      (*(int(*)(short , const char * entry ))0xA049DD48)
//------------------------------------------------------------------------------
#define j_AllocWS             (*(WSHDR*(*)(int len))0xA0289114)
#define j_FreeWS              (*(void(*)(WSHDR *wshdr))0xA049D210)
#define j_CreateLocalWS       (*(WSHDR*(*)(WSHDR *wshdr,unsigned short *wsbody,int len))0xA0288E28)
#define j_AllocMenuWS         (*(WSHDR*(*)(void *gui, int len))0xA049E0E0)
#define j_strrchr             (*(char*(*)(const char *, int c))0xA049FDC0)
#define j_strcmp              (*(int(*)(const char *, const char*))0xA0288F20)
#define j_str_2ws             (*(int(*)(WSHDR *ws, const char *str, unsigned int size))0xA0288E34)
#define j_ws_2str             (*(int(*)( WSHDR *from, char *to ,int len))0xA0289180)
#define j_strlen              (*(unsigned(*)(const char *))0xA049D19C)
#define j_wstrlen             (*(int(*)(WSHDR *))0xA028CC4C)
#define j_wsprintf            (*(int(*)(WSHDR *,const char *format,...))0xA049D148)
#define j_sprintf             (*(int(*)(char *buf, const char *str, ...))0xA028CF04)
#define j_zeromem             (*(void(*)(void *dest,int n))0xA006F748)
#define j_StartMidlet         (*(int(*)(const char *fname, int))0xA049DE4C)
#define j_OpenExplorer        (*(int(*)(NativeExplorerData*))0xA03539C8)
#define j_ExecuteFile         (*(int(*)(WSHDR *filepath, WSHDR *mimetype, void *param))0xA02A10D8)
#define j_GBS_SendMessage     (*(void(*)(int cepid_to, int msg, ...))0xA020A770)
#endif

#endif
