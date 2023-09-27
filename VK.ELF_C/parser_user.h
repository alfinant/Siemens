#ifndef _PARSER_USER_H_
#define _PARSER_USER_H_

#include "vk_objects.h"
#include "json/cJSON.h"


VkUser* parse_User(cJSON* json);
VkUser* parse_obj_profiles(cJSON *json);

#endif//_PARSER_USER_H_
