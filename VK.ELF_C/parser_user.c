#include "parser_user.h"
#include "constants.h"

VkUser* parse_obj_User(cJSON* json)
{ 
  VkUser* user=malloc(sizeof(VkUser));
  zeromem(user, sizeof(VkUser));
  INIT_LIST_HEAD(&user->list);
  
  cJSON* j_item = cJSON_GetObjectItem(json, t_id);
  if (j_item)
    user->id = j_item->valueint;           
          
  j_item = cJSON_GetObjectItem(json, t_first_name);
  if (j_item)
    user->first_name=CreateWS_emoji(j_item->valuestring);
          
  j_item = cJSON_GetObjectItem(json, t_last_name);
  if (j_item)
    user->last_name=CreateWS_emoji(j_item->valuestring);

  j_item = cJSON_GetObjectItem(json, t_deactivated);
  if (j_item)
    user->deactivated = 1;//string: "deleted", "banned"
  
  j_item = cJSON_GetObjectItem(json, t_photo_50);
  if (j_item)
  {
    user->photo_50 = malloc(strlen(j_item->valuestring) + 1);
    strcpy(user->photo_50, j_item->valuestring);    
  }
  
  j_item = cJSON_GetObjectItem(json, t_has_photo);
  if (j_item)
    user->has_photo = j_item->valueint; 

  j_item = cJSON_GetObjectItem(json, t_friend_status);
  if (j_item)
    user->friend_status = j_item->valueint; 
  
  j_item = cJSON_GetObjectItem(json, t_online);
  if (j_item)
    user->online = j_item->valueint;
  
  return user;  
}

VkUser* parse_obj_profiles(cJSON *json)
{
  VkUser* user=NULL;
  
  if (cJSON_GetArraySize(json) > 0)
  {
    cJSON* i = NULL;
    
    cJSON_ArrayForEach(i, json)
    {      
      VkUser* _user=parse_obj_User(i);
      if(user==NULL)
          user=_user;
      else
        list_add_tail(&_user->list, &user->list);
    }
  }
  return user;
}
