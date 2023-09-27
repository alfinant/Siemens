#ifndef _VK_OBJECTS_H_
#define _VK_OBJECTS_H_

#include <siemens\swilib.h>
#include "list.h"

extern struct list_head dialogs;
extern struct list_head friends;
extern struct list_head my_groups;
extern struct list_head profiles;
extern struct list_head groups;
extern WSHDR * CreateWS_emoji(char *utf8_str);

typedef struct list_head LIST_HEAD;
typedef struct user_st VkUser;
typedef struct group_st VkGroup;
typedef struct post_st VkPost;
typedef struct message_st VkMsg;
typedef struct dialog_st VkDialog;
typedef struct attachment_st VkAttach;


struct user_st
{
  struct list_head list;
  int id;//положительное число < 2000 000 000
  WSHDR *first_name;
  WSHDR *last_name;
  int deactivated;
  int friend_status;//0—не друг,1—отправлена заявка,2—имеется вход. заявка,3—друг. 
  int has_photo;
  char *photo_50;//url
  IMGHDR *photo_50_img;
  int online;

  //unsigned short first_name_body[64];
  //unsigned short last_name_body[64];
};

struct user_args
{
  int id;
  char *first_name;
  char *last_name;
  int deactivated;
  int is_closed;
  int can_access_closed;
  int online;
  int friend_status;
  char *photo_50;
  int has_photo;
};

typedef struct //https://dev.vk.com/reference/objects/attachments-wall
{
  struct list_head list;
  int type;//1-photo, 2-posted_photo, 3-video, 4-audio, 5-doc, 6-graffiti, 7-link, 8-note, 9-app, 10-poll, 11-page, 12-album, 13-photos_list, 14-market, 15-market_album, 16-sticker
  char* url;
  int offset_ws;
  int offset_h;
}ATTACH_WALL;

struct post_st//запись на стене
{
  struct list_head list;
  int count;//общее кол-во записей на стене
  int id;
  unsigned date;
  int from_id;
  int owner_id;
  WSHDR* text;
  int type;
  int likes;
  int views;
  int comments_count;
  int can_post;
  struct list_head attachments;//тут будет голова списка вложений (ATTACH_WALL)
  struct list_head profiles;//тут будет голова списка вложений (VkUser)
  //COMMENT* comments;
};

struct group_args
{
  int id;
  char *name;//unicode
  char *screen_name;//unicode
  int is_closed;
  int deactivated;  
  int type;//0-group(группа), 1-page(публичная страница), 2-event(мероприятие)
  int is_member;
  int has_photo;
  char *photo_50;
};

struct message_args
{ 
  int id;
  unsigned date;
  int from_id;
  int peer_id;
  char *text;
  int out;  
};

struct dialog_st
{
  struct list_head list;
  int from_id;//положительное число < 2000 000 000 или отрицательное(для сообщества)
  int unread_count;
  int out_read;
  struct list_head messages;
  struct user_st *user; //из списка profiles
  struct group_st *group; //из списка groups
};


struct group_st
{
  struct list_head list;
  int id;//отрицательное число
  WSHDR *name;
  WSHDR *screen_name;
  int deactivated;
  int is_member;//0,1
  int has_photo;
  char *photo_50;//url
  IMGHDR *photo_50_img;  
  int is_closed;//0-открытое, 1-закрытое, 2-частное  
  int type;//0-group(группа), 1-page(публичная страница), 2-event(мероприятие)
  //unsigned short name_body[64];
  //unsigned short sreen_name_body[64];
};

struct message_st//личные сообщения
{ 
  struct list_head list;
  int id;
  unsigned date;
  int from_id;
  int peer_id;
  WSHDR* text;
  int out;  
  struct list_head attachments;
};

struct attachment_st//в личных сообщениях
{
  struct list_head list;
  int type;//1-photo, 2-video, 3-audio, 4-doc, 5-link, 6-market, 7-market_album, 8-wall, 9-wall_reply, 10-sticker, 11-gift
  //void* data;
};

/*
struct clist_st {//список диалогов
  void* prev;  
  void* next;
  int type;
  struct personal_msg_st* msglist;//личные сообщенмя
  struct wall_msg_st* wall_msglist;
  int user_id;//положительное число < 2000 000 000 или отрицательное(для сообщества) 
  WSHDR* first_name;
  WSHDR* last_name;
  int deactivated;  
  IMGHDR* photo;
  char* photo_url;
  int flag_load_photo;  
  int msg_count;
  int unread;
};
*/

VkMsg* new_Message(struct message_args *args, struct list_head *attachments);
void del_Messages(LIST_HEAD *head);
VkDialog* new_Dialog(VkMsg* msg, int from_id, int unread, int out_read);
VkDialog* FindDialog(LIST_HEAD* list, int from_id);
VkMsg* get_DialogMsg(VkDialog* dialog);
void del_Dialogs();
void del_Profiles();
void del_Groups();
void del_Group(VkGroup *group);
VkUser *new_User(struct user_args *args);
VkUser *find_User(LIST_HEAD *head, int id);
VkGroup *new_Group(struct group_args *args);
VkGroup *find_Group(LIST_HEAD *head, int id);
int count_ListElements(LIST_HEAD* head);
struct list_head *get_ListByIndex(LIST_HEAD *head, int index);
void FreePost(VkPost* post);

/*
USER* CreateContact(int id);
void AddContactToList(CLIST** cl, CLIST* c);
void DeleteContact(CLIST** cl, int user_id);
CLIST* FindContactById(CLIST* cl, int id);
CLIST* FindContactByN(CLIST* cl, int n);
int CLIST_GetCount(CLIST* cl);
int GetContactN(CLIST* cl, CLIST* c);
void CLIST_Free(CLIST** cl);

PERSONAL_MSG* AllocMSG();
void AddMsg(CLIST* cl, PERSONAL_MSG* msg);
void FreeMSGLIST(CLIST* c);
void FreeWALLMSG(CLIST* c);
PERSONAL_MSG* FindMsgById(CLIST* cl, int id);
WALL_ATTACH* FindAttachByIndex(WALL_MSG* msg, int i);

char* create_noninfo_users_ids(CLIST* cl);
char* create_noninfo_groups_ids(CLIST* cl);
*/
#endif
