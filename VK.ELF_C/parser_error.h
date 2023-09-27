#ifndef _PARSER_ERROR_H_
#define _PARSER_ERROR_H_

#include "json/cJSON.h"

extern int error_code;
extern char error_msg[];

int __parse_obj_Error(cJSON* j_error);

#endif
