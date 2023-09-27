#include "parser_error.h"
#include "json/cJSON.h"
#include <siemens\swilib.h>
#include "constants.h"

int error_code;
char error_msg[256];

int __parse_obj_Error(cJSON* j_error)
{   
  int error = 0;
  
  cJSON* j_item = cJSON_GetObjectItem(j_error, t_error_code);
  if (j_item)
  {
    error = j_item->valueint;
    error_code = error;
  }
  
  j_item = cJSON_GetObjectItem(j_error, t_error_msg);
  if (j_item)
    strncpy(error_msg, j_item->valuestring, 255);     

  return error;
}
