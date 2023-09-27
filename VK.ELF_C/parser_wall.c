#include "parser_wall.h"
#include <siemens\swilib.h>
#include "list.h"
#include "json/cJSON.h"
#include "string_util.h"
#include "parser_error.h"
#include "parser_user.h"
#include "constants.h"
#include "vk_objects.h"

//https://dev.vk.com/reference/objects/attachments-wall
//166454362


VkPost* parse_answer_wall_get(char* json_answer, unsigned* err)
{
  VkPost* post=NULL;
  *err=0;
  int count=0;
  const char *return_parse_end = 0;
  
  cJSON *json = cJSON_ParseWithOpts(json_answer, &return_parse_end, 0);
  if (json == NULL)
    return NULL;//cJSON parse error
  
  cJSON* j_response = cJSON_GetObjectItem(json, t_response);
  
  if (j_response)
  {  
    cJSON* j_count = cJSON_GetObjectItem(j_response, t_count);//кол-во записей на стене
    if (j_count)
      count = j_count->valueint;
    
    cJSON *j_items = cJSON_GetObjectItem(j_response, t_items);//находим массив "items" 
    if (j_items)
    {
      cJSON* j_item = NULL;
      cJSON_ArrayForEach(j_item, j_items)//массив записей
      {
        VkPost* _post=malloc(sizeof(VkPost));
        zeromem(_post, sizeof(VkPost));
        INIT_LIST_HEAD(&_post->list);
        INIT_LIST_HEAD(&_post->attachments);//голова списка вложений
        INIT_LIST_HEAD(&_post->profiles);//голова списка профилей
        
        _post->count=count;
       
        cJSON* j_comments = cJSON_GetObjectItem(j_item, t_comments);//comments
        if (j_comments)
        {
          cJSON* j_can_post = cJSON_GetObjectItem(j_comments, t_can_post);
          if (j_can_post)
            _post->can_post = j_can_post->valueint;
          
          cJSON* j_count = cJSON_GetObjectItem(j_comments, t_count);
          if (j_count)          
          _post->comments_count = j_count->valueint;
        }
        
        cJSON* j = cJSON_GetObjectItem(j_item, t_date);//date
        if (j)
          _post->date = j->valueint;

        j = cJSON_GetObjectItem(j_item, t_from_id);//from_id
        if (j)
          _post->from_id = j->valueint; 
        
        j = cJSON_GetObjectItem(j_item, t_id);//id
        if (j)
          _post->id = j->valueint;
        
        cJSON* j_likes = cJSON_GetObjectItem(j_item, t_likes);//likes
        if (j_likes)
        {
          cJSON* j_count = cJSON_GetObjectItem(j_likes, t_count);
          if (j_count)
            _post->likes = j_count->valueint;
        }
//------------------------------------------------------------------------------     
        cJSON* j_attachments = cJSON_GetObjectItem(j_item, t_attachments);//массив вложений          
        cJSON* j_attach = NULL;
        cJSON_ArrayForEach(j_attach, j_attachments)
        {
          cJSON* j_photo = cJSON_GetObjectItem(j_attach, t_photo);
          if(j_photo)
          {
            cJSON* j_photo_sizes = cJSON_GetObjectItem(j_photo, t_sizes);//массив
            if(j_photo_sizes)
            {
              cJSON* i=NULL;
              cJSON_ArrayForEach(i, j_photo_sizes)//ищем в массиве url c "type": q
              {
                cJSON* j_type = cJSON_GetObjectItem(i, t_type);
                if(j_type)
                {
                  if (strcmp(j_type->valuestring, "q") == 0)
                  {
                    cJSON* j_url = cJSON_GetObjectItem(i, t_url);
                    if(j_url)//нашли url, добавляем в список.
                    {
                      ATTACH_WALL* attach=malloc(sizeof(ATTACH_WALL));
                      zeromem(attach, sizeof(ATTACH_WALL));
                      INIT_LIST_HEAD(&attach->list);
                      
                      attach->type=1;
                      attach->url=malloc(strlen(j_url->valuestring)+1);
                      strcpy(attach->url,j_url->valuestring);
                      list_add_tail(&attach->list, &_post->attachments);
                    }
                  }
                }
              }        
            }   
          }
        }
//------------------------------------------------------------------------------
        cJSON* j_text = cJSON_GetObjectItem(j_item, t_text);
        if (j_text)
          _post->text=CreateWS_emoji(j_text->valuestring);
        
        if(post==NULL)
          post=_post;
        else//если запросили больше 1го поста, юзаем список 
          list_add_tail(&_post->list, &post->list);
        
      }//конец цикла массива "items" 
    }
    
    cJSON *j_profiles = cJSON_GetObjectItem(j_response, t_profiles);//находим массив "items" 
    if (j_profiles)
    {
      VkUser* user=parse_obj_profiles(j_profiles);
      if(user)
         list_add_tail(&user->list, &post->profiles);
    }
  }
  else
  {
    cJSON* j_err=cJSON_GetObjectItem(json, t_error);
    if(j_err)
      *err = __parse_obj_Error(j_err);
  }
  
  if (json) cJSON_Delete(json);
  
  return post;
}
