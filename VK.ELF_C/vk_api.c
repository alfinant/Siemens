//https://russianblogs.com/article/3077706523/ - как работать с jSON
#include "vk_api.h"
#include <siemens/swilib.h>
#include "socket_work.h"
#include "http.h"
#include "url_utils.h"
#include "main.h"
#include "vk_objects.h"
#include "string_util.h"
#include "buffer.h"
#include "parser_error.h"
#include "constants.h"

#include "json/cJSON.h"

extern int maincsm_id;

int my_id = 0;

char ACCESS_TOKEN[ACCESS_TOKEN_MAXLEN];
static const unsigned APP_ID = 5582937;
static const char SECRET_KEY[] = "yJVDQi2ry8J1hWS5MlYH";
static const char API_DIR[]="https://api.vk.com/method";
const char API_VER[]="5.131";


int captcha_seed;
const char captcha_img[128];
static char sbuf[1024];

//LongPoolServer
#define LP_VERSION     3
static char lp_key[64];
static char lp_server[32];
unsigned lp_ts = 0;
unsigned pts = 0;

//Прямая авторизация. Разрешение выдано 11.09.2017.
char* url_auth_direct(char *username, char *password, unsigned scope)
{
  snprintf(sbuf, 511, "https://oauth.vk.com/token?grant_type=password&client_id=%d&client_secret=%s"
           "&username=%s&password=%s&scope=%d&v=%s&2fa_supported=0", APP_ID, SECRET_KEY, username, password, scope, API_VER);
  return sbuf;
}

char* url_stats_track_visitor()
{
  snprintf(sbuf, 511, "%s/stats.trackVisitor?v=%s&access_token=%s", API_DIR, API_VER, ACCESS_TOKEN);
  return sbuf;
}

char* url_messages_getLongPollServer(int need_pts, int group_id/*,int lp_version*/)
{
  snprintf(sbuf, 511, "%s/messages.getLongPollServer?v=%s&access_token=%s&need_pts=%d&group_id=%d&lp_version=%d", API_DIR, API_VER, ACCESS_TOKEN, need_pts, group_id, LP_VERSION);
  return sbuf;
}


char* url_messages_getLongPollHistory(/*int ts, int pts, */ const char* fields)
{
  snprintf(sbuf, 511, "%s/messages.getLongPollHistory?v=%s&access_token=%s&ts=%d&pts=%d&fields=%s&lp_version=%d", API_DIR, API_VER, ACCESS_TOKEN, lp_ts, pts, fields, LP_VERSION);
  return sbuf;
}


char* url_messages_getConversations(int offset, int count, int extended, const char* fields)
{
  snprintf(sbuf, 511, "%s/messages.getConversations?v=%s&access_token=%s&offset=%d&count=%d&extended=%d&fields=%s", API_DIR, API_VER, ACCESS_TOKEN, offset, count, extended, fields);
  return sbuf;  
}

char* url_users_get(const char* user_ids, const char* fields)
{
  snprintf(sbuf, 1023, "%s/users.get?v=%s&access_token=%s&user_ids=%s&fields=%s", API_DIR, API_VER, ACCESS_TOKEN, user_ids, fields);
  return sbuf;
}

char* url_messages_getHistory(int user_id, int count, int start_msg_id)
{
  snprintf(sbuf, 511, "%s/messages.getHistory?access_token=%s&v=%s&user_id=%d&count=%d&start_message_id=%d", API_DIR, ACCESS_TOKEN, API_VER, user_id, count, start_msg_id);
  return sbuf;
}

char* url_messages_deleteDialog(int user_id, int count)
{
  snprintf(sbuf, 511, "%s/messages.deleteDialog?access_token=%s&v=%s&user_id=%d&count=%d", API_DIR, ACCESS_TOKEN, API_VER, user_id, count);
  return sbuf;
}

char* url_messages_markAsRead(char* message_ids, unsigned peer_id)
{
  snprintf(sbuf, 1023, "%s/messages.markAsRead?v=%s&access_token=%s&message_ids=%s&peer_id=%d", API_DIR, API_VER, ACCESS_TOKEN, message_ids, peer_id);
  return sbuf;  
}

char* url_friends_get(int count, int offset, char* order, char* fields)
{
  snprintf(sbuf, 511, "%s/friends.get?v=%s&access_token=%s&count=%d&offset=%d&order=%s&fields=%s", API_DIR, API_VER, ACCESS_TOKEN, count, offset, order, fields);
  return sbuf;  
}

char* url_messages_send(int user_id, char* message)
{
  char* msg=URL_reencode_escapes(message);//кодируем строку
  snprintf(sbuf, 511, "v=%s&access_token=%s&user_id=%d&message=%s", API_VER, ACCESS_TOKEN, user_id, msg);
  mfree(msg);
  return sbuf;
}

char* url_groups_get(int offset, int count)//список груп+инфо
{
  snprintf(sbuf, 511, "%s/groups.get?v=%s&access_token=%s&offset=%d&count=%d&extended=1", API_DIR, API_VER, ACCESS_TOKEN, offset, count);
  return sbuf;
}

char* url_groups_getById(const char* group_ids, const char* fields)//инфо о группе
{
  snprintf(sbuf, 511, "%s/groups.getById?v=%s&access_token=%s&group_ids=%s&fields=%s", API_DIR, API_VER, ACCESS_TOKEN, group_ids, fields);
  return sbuf;  
}

char* url_wall_get(int owner_id, int offset, int extended)
{
  snprintf(sbuf, 511, "%s/wall.get?v=%s&access_token=%s&owner_id=%d&count=1&offset=%d&extended=%d", API_DIR, API_VER, ACCESS_TOKEN, owner_id, offset, extended);
  return sbuf;
}

//Вариант отправки с помощью скрипта. Требует маскировки двойных кавычек в сообщении. Проще вызывать хранимые процедуры.
/*char* execute_send(int user_id, char* message)
{
  char* msg=URL_reencode_escapes(message);//кодируем строку
  snprintf(sbuf, 511, "v=%s&access_token=%s&code="
           "var id=API.messages.send({\"user_id\":%d, \"message\":\"%s\"});"
           "return API.messages.getById({\"message_ids\":id});"
           ,API_VER, ACCESS_TOKEN, user_id, msg);
  mfree(msg);
  return sbuf;
}*/

//хранимые процедуры
char* url_execute_getHistory(int user_id, int count)
{
  snprintf(sbuf, 511, "%s/execute.getHistory.xml?access_token=%s&v=%s&user_id=%d&count=%d&func_v=1", API_DIR, ACCESS_TOKEN, API_VER, user_id, count);
  return sbuf;
}

//через post
char* url_execute_sendAndGet(int user_id, char* message, int last_msg_id)
{
  //char* msg=URL_reencode_escapes(message);//кодируем строку  
  snprintf(sbuf, 511, "access_token=%s&v=%s&func_v=1&user_id=%d&last_message_id=%d&message=%s", ACCESS_TOKEN, API_VER, user_id, last_msg_id, message);
  //mfree(msg);
  return sbuf;
}

//******************************************************************************


static void __parse_obj_attachments(cJSON* json, struct list_head *attachments)
{
  if (cJSON_GetArraySize(json) > 0)
  {
    cJSON* i = NULL;  
    cJSON_ArrayForEach(i, json)
    {
      cJSON *j_item = cJSON_GetObjectItem(i, t_type);
      if (j_item)
      {
        VkAttach *attach = malloc(sizeof(VkAttach));
        INIT_LIST_HEAD(&attach->list);
        attach->type = 0;
        
        if (strcmp(j_item->valuestring, t_photo) == 0)
            attach->type = 1;
        list_add_tail(&attach->list, attachments);
      }
    }
  }
}

static void __parse_obj_Message(cJSON* json, struct message_args *msg_args, struct list_head *attachments)
{
  zeromem(msg_args, sizeof(struct message_args));
  
  cJSON *j_item = cJSON_GetObjectItem(json, t_date);
  if (j_item)
    msg_args->date = j_item->valueint; 
  
  j_item = cJSON_GetObjectItem(json, t_from_id);
  if (j_item)
    msg_args->from_id = j_item->valueint;
  
  j_item = cJSON_GetObjectItem(json, t_peer_id);
  if (j_item)
    msg_args->peer_id = j_item->valueint;
  
  j_item = cJSON_GetObjectItem(json, t_id);
  if (j_item)
    msg_args->id = j_item->valueint;
  
  j_item = cJSON_GetObjectItem(json, t_text);
  if (j_item)
    msg_args->text = j_item->valuestring;
  
  j_item = cJSON_GetObjectItem(json, t_out);
  if (j_item)
    msg_args->out = j_item->valueint;
  
    j_item = cJSON_GetObjectItem(json, t_attachments);
  if (j_item)
    __parse_obj_attachments(j_item, attachments);
}

static void __parse_obj_User(cJSON* json, struct user_args *args)
{ 
  zeromem(args, sizeof(struct user_args));
  
  cJSON* j_item = cJSON_GetObjectItem(json, t_id);
  if (j_item)
    args->id = j_item->valueint;           
          
  j_item = cJSON_GetObjectItem(json, t_first_name);
  if (j_item)
    args->first_name = j_item->valuestring;
          
  j_item = cJSON_GetObjectItem(json, t_last_name);
  if (j_item)
    args->last_name = j_item->valuestring;  

  j_item = cJSON_GetObjectItem(json, t_deactivated);
  if (j_item)
    args->deactivated = 1;//string: "deleted", "banned"
  
  j_item = cJSON_GetObjectItem(json, t_photo_50);
  if (j_item)
    args->photo_50 = j_item->valuestring;

   j_item = cJSON_GetObjectItem(json, t_has_photo);
  if (j_item)
    args->has_photo = j_item->valueint; 

  j_item = cJSON_GetObjectItem(json, t_friend_status);
  if (j_item)
    args->friend_status = j_item->valueint; 
  
  j_item = cJSON_GetObjectItem(json, t_online);
  if (j_item)
    args->online = j_item->valueint;  
}

static void __parse_obj_profiles(cJSON *json)
{
  if (cJSON_GetArraySize(json) > 0)
  {
    cJSON* i = NULL;
    
    cJSON_ArrayForEach(i, json)
    {
      struct user_args res;
      struct list_head *list;
      
      __parse_obj_User(i, &res);
      
      if (res.friend_status == 3)
        list = &friends;
      else
        list = &profiles;
      
      if (find_User(list, res.id) == 0)
      {
        VkUser *user = new_User(&res);
        list_add(&user->list, list);
        VkDialog *dialog = FindDialog(&dialogs, user->id);
        if (dialog)
          dialog->user = user;
      }
    }
  } 
}

//******************************************************************************
//******************************************************************************

static void __parse_obj_Group(cJSON* json, struct group_args *args)
{ 
  
  zeromem(args, sizeof(struct group_args));
  
  cJSON* j_item = cJSON_GetObjectItem(json, t_id);
  if (j_item)
    //здесь id положительный почему-то - делаем отрицательным
    args->id = -j_item->valueint;
          
  j_item = cJSON_GetObjectItem(json, t_name);
  if (j_item)
    args->name = j_item->valuestring;
          
  j_item = cJSON_GetObjectItem(json, t_screen_name);
  if (j_item)
    args->screen_name = j_item->valuestring;

  j_item = cJSON_GetObjectItem(json, t_is_closed);
  if (j_item)
    args->is_closed = j_item->valueint;
  
  j_item = cJSON_GetObjectItem(json, t_deactivated);
  if (j_item)
    args->deactivated = 1;//string: "deleted", "banned"
  
  j_item = cJSON_GetObjectItem(json, t_type);
  if (j_item)
  {
    if (strcmp(j_item->valuestring, t_group) == 0)
      args->type = 0;
    else
      if (strcmp(j_item->valuestring, t_page) == 0)
        args->type = 1;
      else
        if (strcmp(j_item->valuestring, t_event) == 0)
          args->type = 2;
  }
  
  j_item = cJSON_GetObjectItem(json, t_is_member);
  if (j_item)
    args->is_member = j_item->valueint;
  
  j_item = cJSON_GetObjectItem(json, t_has_photo);
  if (j_item)
    args->has_photo = j_item->valueint;
  
  j_item = cJSON_GetObjectItem(json, t_photo_50);
  if (j_item)
    args->photo_50 = j_item->valuestring;  
}

static void __parse_obj_groups(cJSON *j_items)
{
  if (cJSON_GetArraySize(j_items) > 0)
  {
    cJSON* i = NULL;
    
    cJSON_ArrayForEach(i, j_items)
    {
      struct group_args res;
      struct list_head *list;
      
      __parse_obj_Group(i, &res);
      
      if (res.is_member == 1)
        list = &my_groups;
      else
        list = &groups;
      
      if (find_Group(list, res.id) == 0)
      {
        VkGroup *group = new_Group(&res);
        list_add_tail(&group->list, list);
        VkDialog *dialog = FindDialog(&dialogs, group->id);
        if (dialog)
        {
          if (dialog->group)//если вдруг уже создан
            del_Group(dialog->group);
          dialog->group = group;
        }
      }
    }
  } 
}
/******************************************************************************/

int parse_answer_groups_get(char *json_answer, int *count)
{
  int error = 0;
  cJSON *j_err;
  const char *return_parse_end = 0;
  
  cJSON *json = cJSON_ParseWithOpts(json_answer, &return_parse_end, 0);
  if (json == NULL)
    return(-1);//cJSON parse error
  
  cJSON* j_response = cJSON_GetObjectItem(json, t_response);
  
  if (j_response)
  {
    cJSON* j_count = cJSON_GetObjectItem(j_response, t_count);
    if (j_count)
      *count = j_count->valueint;
    
    cJSON *j_items = cJSON_GetObjectItem(j_response, t_items);    
    if (j_items)
      __parse_obj_groups(j_items);
  }
  else
    if (j_err = cJSON_GetObjectItem(json, t_error))
      error = __parse_obj_Error(j_err);
  
  if (json) cJSON_Delete(json);
  
  return error;
}

//******************************************************************************

int __parse_answer_users_get()
{
  int error = 0;
  
  char* end = (char*)(recv_buf+HTTP_HEADER_LENGTH+HTTP_CONTENT_LENGTH);
  *end = '\0';
  
  cJSON* json = cJSON_Parse(recv_buf + HTTP_HEADER_LENGTH);
  if (json == NULL)
    return 0;
  
  cJSON* j_response = cJSON_GetObjectItem(json, t_response);
  if (j_response)
  {
    if (cJSON_GetArraySize(j_response) > 0)
    {
      cJSON* i = NULL;
      cJSON_ArrayForEach(i, j_response)
      {
        struct user_args res;
        
        __parse_obj_User(i, &res);
        
        if (find_User(&profiles, res.id) == 0)
        {
          VkUser *user = new_User(&res);
          list_add(&user->list, &profiles);
        }
      }
    }
  }
  else
    if (j_response = cJSON_GetObjectItem(json, t_error))
      error = __parse_obj_Error(j_response);
  
  if (json) cJSON_Delete(json);
  
  return error;
}
/******************************************************************************/

int __parse_answer_friends_get()
{
  return parse_answer_users_get();  
}

/******************************************************************************/

int parse_answer_auth_direct()
{
  int error = 0;
  const char *return_parse_end;
  
  cJSON *json = cJSON_ParseWithOpts(recv_buf+HTTP_HEADER_LENGTH, &return_parse_end, 0);
  if (json == NULL)
    return(-1);//cJSON parse error
  
  cJSON* j_item = cJSON_GetObjectItem(json, t_access_token);
  if (j_item)
  {
    strncpy(ACCESS_TOKEN, j_item->valuestring, ACCESS_TOKEN_MAXLEN-1);
    
    j_item = cJSON_GetObjectItem(json, t_user_id);
    if (j_item)
      my_id = j_item->valueint;
  }
  else
    if (j_item = cJSON_GetObjectItem(json, t_error))
    {
      if (strcmp(j_item->valuestring, t_need_captcha) == 0)
      {
        strncpy(error_msg, j_item->valuestring, 255);
        error = 14;
      }
      else
        if (stricmp(j_item->valuestring, t_need_validation) == 0)
        {
          strncpy(error_msg, j_item->valuestring, 255);
          error = 17;
        }
        else
          if (j_item = cJSON_GetObjectItem(json, t_error_description))
            {
              utf82win(error_msg, j_item->valuestring);
              error = 1;
            }
          else
          {
            strncpy(error_msg, j_item->valuestring, 255);
            error = 1;
          }
    }
  
  if (json)
    cJSON_Delete(json);
 
  return error;
}

//***************************** messages.getLongPollServer *********************

int parse_answer_messages_getLongPollServer() /// json->response->{key, server, ts, pts} 
{ 
  int error = 0;
  
  char* end=(char*)(recv_buf+HTTP_HEADER_LENGTH+HTTP_CONTENT_LENGTH);
  *end='\0';
  
  cJSON* json = cJSON_Parse(recv_buf+HTTP_HEADER_LENGTH);
  if (json == NULL)
    return 0;
  
  cJSON* j_response = cJSON_GetObjectItem(json, t_response);
  if (j_response)
  {
    error = 0;
    
    cJSON* j_item = cJSON_GetObjectItem(j_response, "key");
    if (j_item)
      strncpy(lp_key, j_item->valuestring, 63);
    
    j_item = cJSON_GetObjectItem(j_response, "server");
    if (j_item)
      strncpy(lp_server, j_item->valuestring, 31);
    
    j_item = cJSON_GetObjectItem(j_response, "ts");
    if (j_item)
      lp_ts = j_item->valueint;
    
    j_item = cJSON_GetObjectItem(j_response, "pts");
    if (j_item)
      pts = j_item->valueint;
  }
  else
    if (j_response = cJSON_GetObjectItem(json, t_error))
      error = __parse_obj_Error(j_response);
    
  if (json) cJSON_Delete(json);
  
  return error;
}

//************************** messages.getLongPollHistory ***********************
/*
int parse_answer_messages_getLongPollHistory(LIST_HEAD *messages, LIST_HEAD *profiles)
{// json->response->{history[], messages->{count, items[{conversation, last_message}], new_pts, profiles[], conversations[]} 
  
  int error = 0;
  int count = 0;
  
  char* end=(char*)(recv_buf+HTTP_HEADER_LENGTH+HTTP_CONTENT_LENGTH);
  *end='\0';
  
  cJSON* json = cJSON_Parse(recv_buf+HTTP_HEADER_LENGTH);
  if (json == NULL)
    return 0;
  
  cJSON* j_response = cJSON_GetObjectItem(json, t_response);
  if (j_response)
  { 
    cJSON* j_messages = cJSON_GetObjectItem(j_response, "messages");
    if (j_messages)
    {
      cJSON* j_count = cJSON_GetObjectItem(j_messages, t_count);
      if (j_count)
        count = j_count->valueint;
      
      cJSON* j_items = cJSON_GetObjectItem(j_messages, t_items);
      if (j_items)
      {                            
        if (cJSON_GetArraySize(j_items) > 0)
        {
          cJSON* i = NULL;              
          cJSON_ArrayForEach(i, j_items)
          {
            struct message_args __msg_args;
            LIST_HEAD(__attachments);
            __parse_obj_Message(i, &__msg_args, &__attachments);
            VkMsg *message = new_Message(&__msg_args, &__attachments);
            list_add(&message->list, messages);
          }
        }
      }
    }
    
    cJSON* j_new_pts = cJSON_GetObjectItem(j_response, "new_pts");
    if (j_new_pts)
      pts = j_new_pts->valueint;
    
    cJSON* j_profiles = cJSON_GetObjectItem(j_response, t_profiles);
    if (j_profiles)
      __parse_obj_profiles(j_profiles);
  }
  else
    if (j_response = cJSON_GetObjectItem(json, t_error))
      error = __parse_obj_Error(j_response);
  
  if (json) cJSON_Delete(json);

  return error;
}
*/
//************************** messages.getConversations *************************

int parse_answer_messages_getConversations(char *json_answer, int *count)
{/* json->response->{count, items[{conversation, last_message}], profiles[]} */
  int error = 0;
  const char *return_parse_end = 0;
  
  cJSON *json = cJSON_ParseWithOpts(json_answer, &return_parse_end, 0);
  if (json == NULL)
    return(-1);//cJSON parse error
  
  cJSON* j_response = cJSON_GetObjectItem(json, t_response);
  if (j_response)
  {
    cJSON* j_count = cJSON_GetObjectItem(j_response, t_count);
    if (j_count)
      *count = j_count->valueint;    
    
    cJSON* j_items = cJSON_GetObjectItem(j_response, t_items);
    if (j_items)
    {
      if (cJSON_GetArraySize(j_items) > 0)
      {       
        cJSON* i = NULL;
        
        cJSON_ArrayForEach(i, j_items)
        {
          int unread_count = 0;
          int out_read = 0;
          cJSON* j_item = cJSON_GetObjectItem(i, t_conversation);
          if (j_item)
          {
            j_item = cJSON_GetObjectItem(j_item, t_out_read);
            if (j_item)
              out_read = j_item->valueint;            
            
            j_item = cJSON_GetObjectItem(j_item, t_unread_count);
            if (j_item)
              unread_count = j_item->valueint;
          }
          
          j_item = cJSON_GetObjectItem(i, t_last_message);
          if (j_item)
          {
            struct message_args __msg_args;
            LIST_HEAD(__attachments);
            int id;
            
            __parse_obj_Message(j_item, &__msg_args, &__attachments);
            VkMsg *message = new_Message(&__msg_args, &__attachments);
            
            if (__msg_args.out)
              id = __msg_args.peer_id;
            else
              id = __msg_args.from_id;
            
            VkDialog *dialog = FindDialog(&dialogs, id);
            if (dialog)
            {
              del_Messages(&dialog->messages);
              list_add_tail(&message->list, &dialog->messages);
            }
            else
            {
              dialog = new_Dialog(message, id, unread_count, out_read);
              list_add_tail(&dialog->list, &dialogs);       
            }
          }
        }
      }
    }
   
  cJSON* j_profiles = cJSON_GetObjectItem(j_response, t_profiles);
    if (j_profiles)
      __parse_obj_profiles(j_profiles);
    
  cJSON* j_groups = cJSON_GetObjectItem(j_response, t_groups);
    if (j_groups)
      __parse_obj_groups(j_groups);    
  }
  else
    if (j_response = cJSON_GetObjectItem(json, t_error))
      error = __parse_obj_Error(j_response);
  
  if (json) cJSON_Delete(json);

  return error;  
}


/* Старые функции, под xml данные.

int parse_answer_messages_get(int* item_count, int* result_out)
{
  int err=0;
  int n=0;
  CLIST*c;
  char* body_utf8;
  char* url;
  int url_len;

  WSHDR* body_ws; 
  int count;
  int id;//for message
  unsigned date;
  int user_id;
  int read_state;
  int out;
  int emoji;  
  int attach;
  
  char* s=recv_buf+HTTP_HEADER_LENGTH;
  char* msgblk;
  char* msgblk_end;
  
  char* start_tag=NULL;
  char* end_tag=NULL;
  
  if (err=checkError(s))
    return err;
  
  count=0;
  if (s=strstr(s, "<count>"))
  {
    s+=7;
    count=strtol(s, 0, 10);
  }
  
  if(count==0)
    return err;
  
  if (strstr(s, "<message>"))
  {
    start_tag="<message>";
    end_tag="</message>";
  }
  else
  {
    start_tag="<item>";
    end_tag="</item>";
  }
  
  if (start_tag==NULL || end_tag==NULL)
    return parseError();
  
  while (msgblk=strstr(s, start_tag))
  {
    if(msgblk_end=strstr(s, end_tag))
       *msgblk_end='\0';
    else
      return parseError();
    
    id=0; 
    if(s=strstr(msgblk, "<id>"))
    {
      s+=4;
      id=strtol(s, 0, 10); 
     }
    
    date=0;
    if(s=strstr(msgblk, "<date>"))
    {
      s+=6;
      date=strtol(s, 0, 10); 
     }    

    user_id=0;
    if(s=strstr(msgblk, "<user_id>"))
    {
      s+=9;
      user_id=strtol(s, 0, 10);
    }

    read_state=0;
    if(s=strstr(msgblk, "<read_state>"))
    {
      s+=12;
      read_state=strtol(s, 0, 10); 
    }
    
    out=0;
    if(s=strstr(msgblk, "<out>"))
    {
      s+=5;
      out=strtol(s, 0, 10); 
    }
       
    body_utf8=NULL;
    body_ws=NULL;
    emoji=0;
    if(s=strstr(msgblk, "<body>"))
    {
      s+=6;
      char* body_end=strstr(s, "</body>"); 
      *body_end='\0';
      body_utf8=Replace_Special_Syms(s);
      *body_end='<';      
      
      if (s=strstr(s, "<emoji>"))
      {
        s+=7;
        emoji=strtol(s, 0, 10);
      }
    }
    
    attach=0;
    url=NULL;
    if (s=strstr(msgblk, "<attachment>"))
    {
      if (s=strstr(s, "<type>"))
      {
        s+=6;
        for (; *s == ' ' || *s == '\n' || *s == '\r'; s++);
         
        if (strncmp(s, "wall", 4)==0)
          attach=8;
        else
          if (strncmp(s, "photo", 5)==0)
            attach=1;
          else
            if (strncmp(s, "video", 5)==0)
            attach=2;
          else
            if (strncmp(s, "link", 4)==0)
            {
              if(s=strstr(s, "<url>"))
              {
                s+=5;
                url=s;
                url_len=strstr(s, "</url>")-s;
                attach=5;
              }
            }
      }
    }
    
    *msgblk_end='<';
    s=msgblk_end+strlen(end_tag);
    
    if (body_utf8)
    {
      int len=strlen(body_utf8);
      if (emoji)
        len=Replace_Smiles_Syms(body_utf8);

      body_ws=AllocWS(utf8_syms_n(body_utf8, len));
      utf8_2ws(body_ws, body_utf8, len);
      mfree(body_utf8);
    }
    else
      if (url)
      {
        body_ws=AllocWS(url_len);
        str_2ws(body_ws, url, url_len);
       }

    
    if (user_id && date)//иначе итем без полезной инфы
    {
    
    if ((c=FindContactById(csm->dialogs_list, user_id))==0)//если контакта нет в списке
      c=CreateContact(user_id);
      //тут можно скопировать данные контакта из списка друзей

    
    PERSONAL_MSG* msg=FindMsgById(c, id);

    if (msg)//если сообщение уже есть в списке,то обновим его статус прочтения
    {
      msg->read_state=read_state;
      if (body_ws)
        FreeWS(body_ws); 
    }
      
    else//новое сообщение
    {
      msg=AllocMSG();
      msg->id=id;
      msg->date=date;
      msg->user_id=user_id; 
      msg->read_state=read_state;
      msg->out=out;
      msg->body=body_ws;
      msg->emoji=emoji;
      msg->attach=attach;
      
      AddMsg(c, msg);  
      AddContactToList(&csm->dialogs_list, c);
      
      if (out==0 && msg->read_state==0)
        total_unread_messages++;
      
      if (out)
        *result_out=1;
      
      if (msg->id > last_message_id)
        last_message_id=msg->id;
      
      n++;
    }
    }
  }
  *item_count=n;
  return err;
}



int parse_answer_messages_getHistory()
{
  int result_count;
  int result_out;
  return parse_answer_messages_get(&result_count, &result_out);  
}



int parse_answer_messages_getDialogs()
{
  int result_count;
  int result_out;
  return parse_answer_messages_get(&result_count, &result_out);
}



int parse_answer_groups_get(CLIST** cltop_adr)
{
  int err=0;
  CLIST* c;
  CLIST** cl=(CLIST**)cltop_adr;
  WSHDR* ws1;
  WSHDR* ws2;
  
  int id=0;
  const char* first_name;//for name
  const char* last_name;//for sreen_name
  const char* photo50_url;  
  int first_name_len=0;
  int last_name_len=0;
  int photo50_url_len=0;
  int deactivated;
  
  char* content=recv_buf+HTTP_HEADER_LENGTH;
  char* userblk;
  char* userblk_end;
  char* s=content;
  
  if (err=checkError(content))
    return err;
  
   while (userblk=strstr(s, "<group>"))
   {
     s=userblk+6;
     userblk_end=strstr(s, "</group>");
     *userblk_end='\0';
    
     id=0;
     if(s=strstr(userblk, "<id>"))
     {
       s+=4;
       id=strtol(s, 0, 10);
       if (id > 0)
         id=-id; //тут знак у id положительный-делаем отрицательным
     }
     
     first_name=NULL;
     if(s=strstr(userblk, "<name>"))
     {
       s+=6;
       first_name=s;
       first_name_len=strstr(s, "</name>") - s;
       s+=first_name_len;
     }
     
     last_name=NULL;
     if(s=strstr(userblk, "<screen_name>"))
     {
       s+=13;
       last_name=s;
       last_name_len=strstr(s, "</screen_name>") - s;
       s+=last_name_len;         
     }

     deactivated=0;
     if(s=strstr(userblk, "<deactivated>"))
       deactivated=1;        
     
     photo50_url=NULL;
     if(s=strstr(userblk, "<photo_50>"))
     {
       s+=10;
       photo50_url=s;
       photo50_url_len=strstr(s, "</photo_50>") - s;
       s+=photo50_url_len;
     }
     
     s=userblk_end+7;   
     
     
     if ((c=FindContactById(*cl, id))==0)
     {
       c=CreateContact(id);
       AddContactToList(cl, c);
     }
     
     if (c->first_name)
       FreeWS(c->first_name);
     if (c->last_name)
       FreeWS(c->last_name);
     
     ws1=AllocWS(65);
     ws2=AllocWS(65);
     utf8_2ws(ws1, first_name, first_name_len);
     utf8_2ws(ws2, last_name, last_name_len);
     c->first_name=ws1;
     c->last_name=ws2;
     c->deactivated=deactivated;
     c->photo_url=malloc(photo50_url_len+1);
     strncpy(c->photo_url, photo50_url, photo50_url_len);
     c->photo_url[photo50_url_len]='\0';
   }
   return err;
}


int parse_answer_messages_send()
{
  int err=0;
  char* s=recv_buf+HTTP_HEADER_LENGTH;
  
  if (err=checkError(s))
    return err;
  
  return err;
}

int parse_answer_messages_deleteDialog(int* user_id)
{
  int err=0;
  char* s=recv_buf+HTTP_HEADER_LENGTH;
  
  *user_id=last_user_id;
  
  if (err=checkError(s))
    return err;
  
  return err;
}

int parse_answer_friends_get()
{
  return parse_answer_users_get();  
}


int parse_answer_wall_get(int* item_count)//!!!рассчитано на чтение только одного сообщения
{
  int err=0;
  int n=0;
  CLIST*c;
  WALL_MSG* msg;
  char* text_utf8;

  WSHDR* text_ws; 
  int id;
  unsigned date;
  int from_id;
  int owner_id;
  int emoji;  
  WALL_ATTACH* attach_list=NULL;
  int likes;
  int comments;
  
  char* s=recv_buf+HTTP_HEADER_LENGTH;
  char* postblk;
  char* postblk_end;
  
  if (err=checkError(s))
    return err;
  
  if (postblk=strstr(s, "<post>"))
  {
    s=postblk + (sizeof("<post>")-1);

    if(postblk_end=strstr(s, "</post>"))
       *postblk_end='\0';
    else
      return parseError();
    
    id=0; 
    if(s=strstr(postblk, "<id>"))
    {
      s+=4;
      id=strtol(s, 0, 10); 
     }
    
    from_id=0;
    if(s=strstr(postblk, "<from_id>"))
    {
      s+=9;
      from_id=strtol(s, 0, 10);
    }
    
    owner_id=0;
    if(s=strstr(postblk, "<owner_id>"))
    {
      s+=10;
      owner_id=strtol(s, 0, 10);
    }    

    date=0;
    if(s=strstr(postblk, "<date>"))
    {
      s+=6;
      date=strtol(s, 0, 10);
    }    
    
    text_utf8=NULL;
    text_ws=NULL;
    emoji=0;
    if(s=strstr(postblk, "<text>"))
    {
      s+=6;
      char* text_end=strstr(s, "</text>");
      *text_end='\0';
      text_utf8=Replace_Special_Syms(s);
      *text_end='<';
      
      if (s=strstr(s, "<emoji>"))
      {
        s+=7;
        emoji=strtol(s, 0, 10);
      }
    }
//------------------------------------------------------------------------------    
    attach_list=NULL;                                  
    char* attachblk=postblk; 
    while (s=strstr(attachblk, "<attachment>"))
    {
      char* attachblk_end=strstr(attachblk, "</attachment>");
      *attachblk_end='\0';
        
      if (s=strstr(s, "<type>"))
      {
        s+=6;
        for (; *s == ' ' || *s == '\n' || *s == '\r'; s++);
        
        if (strncmp(s, "photo", 5)==0)
        {
          if(s=strstr(s, "<photo_604>"))//130 маловат а 604 большой:(
          {
            s+=11; 
            int len=strstr(s, "</photo_604>") - s;
            WALL_ATTACH* wall_attach=malloc(sizeof(WALL_ATTACH));
            wall_attach->next=0;
            wall_attach->type=1;
            wall_attach->url=malloc(len+1);
            strncpy(wall_attach->url, s, len);
            wall_attach->url[len]='\0';
            WALL_ATTACH* a=attach_list;
            while (a)
            {
              if (a->next==0)
                break;
              a=a->next;
            }
            if (a)
              a->next=wall_attach;
            else
              attach_list=wall_attach;
          }
        }
        else
          if (strncmp(s, "link", 4)==0)
          {
            if(s=strstr(s, "<url>"))
            {
              s+=5;
              int len=strstr(s, "</url>") - s;
              WALL_ATTACH* wall_attach=malloc(sizeof(WALL_ATTACH));
              wall_attach->next=0;
              wall_attach->type=7;
              wall_attach->url=malloc(len+1);
              strncpy(wall_attach->url, s, len);
              wall_attach->url[len]='\0';
              WALL_ATTACH* a=attach_list;
              while (a)
              {
                if (a->next==0)
                break;
              a=a->next;
              }
              if (a)
                a->next=wall_attach;
              else
                attach_list=wall_attach;            
            }
          }
          else
            if (strncmp(s, "video", 5)==0)
            {
              WALL_ATTACH* wall_attach=malloc(sizeof(WALL_ATTACH));
              wall_attach->next=0;   
              wall_attach->type=3;
              wall_attach->url=NULL;
              WALL_ATTACH* a=attach_list;
              while (a)
              {
                if (a->next==0)
                  break;
                a=a->next;
              }
              if (a)
                a->next=wall_attach;
              else
                attach_list=wall_attach;  
            }
      }
      
      *attachblk_end='<';
      attachblk=attachblk_end + (sizeof("</attachment>")-1);
    }     
//------------------------------------------------------------------------------  
    comments=0;
    if (s=strstr(postblk, "<comments>"))
    {
      if(s=strstr(s, "<count>"))
      {
        s+=(sizeof("<count>")-1);
        comments=strtol(s, 0, 10);
      }
    }
    
    likes=0;
    if (s=strstr(postblk, "<likes>"))
    {
      if(s=strstr(s, "<count>"))
      {
        s+=(sizeof("<count>")-1);
        likes=strtol(s, 0, 10);
      }
    }    
//------------------------------------------------------------------------------    
    *postblk_end='<';
    s=postblk_end+7;
    
    if (text_utf8)
    {
      int len=strlen(text_utf8);
      if (emoji)
        len=Replace_Smiles_Syms(text_utf8);

      text_ws=AllocWS(utf8_syms_n(text_utf8, len));
      utf8_2ws(text_ws, text_utf8, len);
      mfree(text_utf8);
    }
    
    if (from_id && date)//иначе итем без полезной инфы
    {
      if ((c=FindContactById(csm->groups_list, owner_id))==0)
        c=CreateContact(id);
      
      msg=(WALL_MSG*)FindMsgById(c, id);

    if (msg)//если сообщение уже есть в списке
    {
      if (text_ws)
        FreeWS(text_ws);      
    }
    else//новое сообщение
    {
      msg=malloc(sizeof(WALL_MSG));
      msg->next=0;
      msg->prev=0;
      msg->id=id;
      msg->from_id=from_id;
      msg->date=date;
      msg->owner_id=owner_id;
      msg->date=date;
      msg->text=text_ws;
      msg->emoji=emoji;
      msg->attach_list=attach_list;
      msg->comments=comments;
      msg->likes=likes;
      
      c->wall_msglist=msg;  
      
      n++;
    }
    }
  }
  
  *item_count=n;
  
  s=postblk_end + (sizeof("</post>")-1);
  msg->profiles=NULL;
  parse_answer_users_get();
  
  return err;
}

*/

