#include <siemens\cfg_items.h>
#include <siemens\swilib.h>

#ifdef NEWSGOLD
#define DEFAULT_DISK "4"
#else
#define DEFAULT_DISK "0"
#endif

__root const CFG_HDR cfghdr0={CFG_STR_UTF8,"Папка приложения",0,127};
__root const char APP_DIR[128]="0:\\Zbin\\Vk\\";

__root const CFG_HDR cfghdr1={CFG_CHECKBOX, "VK Theme", 0, 3};
__root const int CFG_ENA_THEME = 0;

__root const CFG_HDR cfghdr2={CFG_UINT,"Reconnect timeout",0,65535};
__root const unsigned int RECONNECT_TIME=60;

__root const CFG_HDR cfghdr3={CFG_TIME,"Часовой пояс",0,12};
__root const TTime GMT={3,0,0,0};

__root const CFG_HDR cfghdr4={CFG_CBOX,"Включить звук",0,2};
__root const int soundEnabled = 1;
__root const CFG_CBOX_ITEM cfgcbox4_2[2]={"Нет","Да"};

#ifdef NEWSGOLD  
__root const CFG_HDR cfghdr5={CFG_UINT,"Громкость(0-5)",0,5};
__root const int sndVolume=5;
#else
__root const CFG_HDR cfghdr6={CFG_UINT,"Громкость(0-15)",0,15};
__root const int sndVolume=15; 
#endif
