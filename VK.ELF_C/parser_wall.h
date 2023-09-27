#ifndef _PARSER_WALL_H_
#define _PARSER_WALL_H_

#include "json/cJSON.h"
#include "vk_objects.h"

VkPost* parse_answer_wall_get(char *json_answer, unsigned *err);

#endif
