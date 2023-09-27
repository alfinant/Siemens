#include <siemens\swilib.h>

#include "json\cJSON.h"

#pragma segment="ELFBEGIN"
extern void kill_data(void *p, void (*func_p)(void *));
void ElfKiller(void)
{
  kill_data(__segment_begin("ELFBEGIN"),(void (*)(void *))mfree_adr());
}

int main(char *exename, char *fname)
{
  char*p;
  
  //sprintf(s, "Version: %s\n", cJSON_Version());
  //ShowMSG(1, (int)s);
  
  cJSON *root = cJSON_CreateObject();
  cJSON_AddNumberToObject(root, "width", 1920);
  //cJSON *item = cJSON_GetObjectItem(root, "width");
  p=cJSON_Print(root);
  //cJSON_Delete(root);
  ShowMSG(1, (int)p);
  //mfree(p);
  SUBPROC((void*)ElfKiller);
  return 0;
}



