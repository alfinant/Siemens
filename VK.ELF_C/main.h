#ifndef _MAIN_H_
#define _MAIN_H_

#include "vk_objects.h"
#include "vk_ipc.h"

//IPC
extern const char ipc_my_name[];
extern const char ipc_xtask_name[];
extern IPC_REQ ipc;

typedef struct
{
  CSM_RAM csm;
  int maingui_id;
  int wallgui_id;
  VkDialog *chat;
  VkUser *user;
  VkGroup *group;
  LIST_HEAD *list;
  HObj obj;
}MAIN_CSM;

extern MAIN_CSM* csm;

#endif
