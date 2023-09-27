#include "vk_objects.h"

#include <siemens\swilib.h>
#include "string_util.h"

//Инициализируем головы списков
LIST_HEAD(dialogs);
LIST_HEAD(my_groups);
LIST_HEAD(friends);
LIST_HEAD(profiles);//в этом списке будут пользователи
LIST_HEAD(groups);//в этом списке группы

static int dialogs_cout = 0;//кол-во диалогов на сервере

static const char percent_d[]="%d,";

int utf8_2ws_emoji(WSHDR *ws, char *utf8_str, unsigned int maxLen)
{
  //подмена в utf8 тексте символов эмоджи на сименсовские и перевод в WSHDR
  //char* s = malloc(strlen(utf8_str) + 1);
  int len = Replace_Smiles_Syms(utf8_str);
  return utf8_2ws(ws, utf8_str, len);
  //mfree(s);
}

/******************************************************************************/

VkUser *new_User(struct user_args *args)
{ 
  VkUser *user = malloc(sizeof(VkUser));
  INIT_LIST_HEAD(&user->list); 
  user->id = args->id;
  user->first_name = CreateWS_emoji(args->first_name);
  user->last_name = CreateWS_emoji(args->last_name); 
  //CreateLocalWS(&user->first_name, user->first_name_body, 63);
  //CreateLocalWS(&user->last_name, user->last_name_body, 63);
  //utf8_2ws_emoji(&user->first_name, args->first_name, 31);
  //utf8_2ws_emoji(&user->last_name, args->last_name, 31);
  user->deactivated = args->deactivated;
  user->friend_status = args->friend_status;
  user->online = args->online;
  user->has_photo = args->has_photo;
  if (args->photo_50)
  {
    user->photo_50 = malloc(strlen(args->photo_50) + 1);
    strcpy(user->photo_50, args->photo_50);
  }
  user->photo_50_img = NULL;
  return user;
}

VkUser *find_User(struct list_head *head, int id)
{ 
  LIST_HEAD *iter;
  
  list_for_each(iter, head)
  {
    VkUser *entry = list_entry(iter, VkUser, list);
    if (entry->id == id)
      return entry;
  }
  return NULL;
}

void del_User(VkUser *user)
{
  if (user->first_name)
    FreeWS(user->first_name); 
  
  if (user->last_name)
    FreeWS(user->last_name); 
  
  if (user->photo_50)
    mfree(user->photo_50);
  
  if (user->photo_50_img)
  {
    mfree(user->photo_50_img->bitmap);
    mfree(user->photo_50_img);    
  }
  
  list_del(&user->list);
  mfree(user);
}  
//------------------------------------------------------------------------------
void del_wall_attachments(LIST_HEAD *head)
{
  struct list_head *iter, *n;
  
  list_for_each_safe(iter, n, head)
  {
    ATTACH_WALL *entry = list_entry(iter, ATTACH_WALL, list);
    if(entry->url)
      mfree(entry->url);
    mfree(entry);
  }
  
  INIT_LIST_HEAD(head);
}

void _del_Profiles(LIST_HEAD *head)
{ 
  struct list_head *iter, *n;
    
  list_for_each_safe(iter, n, head)
  {
    VkUser *entry = list_entry(iter, VkUser, list);
    del_User(entry);
  }
}

void FreePost(VkPost* wall)
{
  if(wall == 0)
    return;
  
  struct list_head *iter, *n;
  list_for_each_safe(iter, n, &wall->list)
  {
    VkPost* entry = list_entry(iter, VkPost, list);
    
    if(entry->text)
      FreeWS(entry->text);
    
    if (!list_empty(&entry->attachments))
      del_wall_attachments(&entry->attachments);

    if (!list_empty(&entry->profiles))
      _del_Profiles(&entry->profiles);
    
    list_del(&entry->list);
    mfree(entry);
  }
}


//------------------------------------------------------------------------------
void del_Profiles()
{ 
  struct list_head *iter, *n;
    
  list_for_each_safe(iter, n, &profiles)
  {
    VkUser *entry = list_entry(iter, VkUser, list);
    del_User(entry);
  }
  INIT_LIST_HEAD(&profiles);
}

/******************************************************************************/

void del_attachments(LIST_HEAD *head)
{
  struct list_head *iter, *n;
  
  list_for_each_safe(iter, n, head)
  {
    //VkAttach *a = list_entry(iter, VkAttach, list);
    mfree(iter);
  }
  INIT_LIST_HEAD(head);
}

/******************************************************************************/

VkMsg *new_Message(struct message_args *args, struct list_head *attachments)
{
  VkMsg *message = malloc(sizeof(VkMsg));
  INIT_LIST_HEAD(&message->list);  
  message->id = args->id;
  message->date = args->date;
  message->from_id = args->from_id;
  message->peer_id = args->peer_id;
  message->out = args->out;
  message->text = CreateWS_emoji(args->text);
  INIT_LIST_HEAD(&message->attachments);
  if (!list_empty(attachments))
    list_splice(attachments, &message->attachments);
  return message;
}

void del_Message(VkMsg *msg)
{
  list_del(&msg->list);
  FreeWS(msg->text);
  del_attachments(&msg->attachments);
  mfree(msg);
}

void del_Messages(LIST_HEAD *head)
{ 
  struct list_head *iter, *n;
  
  list_for_each_safe(iter, n, head)
  {
    VkMsg *msg = list_entry(iter, VkMsg, list);
    del_Message(msg);
  }
  INIT_LIST_HEAD(head);
}

/******************************************************************************/

VkGroup *new_Group(struct group_args *args)
{ 
  VkGroup *group = malloc(sizeof(VkGroup));
  INIT_LIST_HEAD(&group->list); 
  group->id = args->id;
  group->name = CreateWS_emoji(args->name);
  group->screen_name = CreateWS_emoji(args->screen_name); 
  //CreateLocalWS(&group->name, group->name_body, 63);
  //CreateLocalWS(&group->screen_name, group->screen_name_body, 63);
  //utf8_2ws_emoji(&group->name, args->name, 31);
  //utf8_2ws_emoji(&group->screen_name, args->screen_name, 31);
  group->is_closed = args->is_closed;
  group->deactivated = args->deactivated;
  group->is_member = args->is_member;
  group->type = args->type;
  group->has_photo = args->has_photo;  
  if (args->photo_50)
  {
    group->photo_50 = malloc(strlen(args->photo_50) + 1);
    strcpy(group->photo_50, args->photo_50);
  }
  group->photo_50_img = NULL;
  return group;
}  
  
VkGroup *find_Group(struct list_head *head, int id)
{ 
  LIST_HEAD *iter;
  
  list_for_each(iter, head)
  {
    VkGroup *entry = list_entry(iter, VkGroup, list);
    if (entry->id == id)
      return entry;
  }
  return NULL;
}

void del_Group(VkGroup *group)
{
  if (group->name)
    FreeWS(group->name); 
  
  if (group->screen_name)
    FreeWS(group->screen_name); 
  
  if (group->photo_50)
    mfree(group->photo_50);
  
  if (group->photo_50_img)
  {
    mfree(group->photo_50_img->bitmap);
    mfree(group->photo_50_img);    
  }
  
  list_del(&group->list);
  mfree(group);
}

void del_Groups()
{ 
  struct list_head *iter, *n;
    
  list_for_each_safe(iter, n, &groups)
  {
    VkGroup *entry = list_entry(iter, VkGroup, list);
    del_Group(entry);
  }
  INIT_LIST_HEAD(&groups);
}
/******************************************************************************/

VkDialog *new_Dialog(VkMsg *msg, int from_id, int unread, int out_read)
{
  VkDialog *dialog = malloc(sizeof(VkDialog));
  INIT_LIST_HEAD(&dialog->list);
  if (msg->out)
    dialog->from_id = msg->peer_id;
  else
    dialog->from_id = msg->from_id;  
  dialog->unread_count = unread;
  dialog->out_read = out_read;
  INIT_LIST_HEAD(&dialog->messages);
  list_add(&msg->list, &dialog->messages);
  dialog->user = NULL;
  dialog->group =NULL;
  return dialog;
}

VkDialog *FindDialog(LIST_HEAD *head, int from_id)
{ 
  LIST_HEAD *iter;
  
  list_for_each(iter, head)
  {
    VkDialog *entry = list_entry(iter, VkDialog, list);
    
    if (!list_empty(&entry->messages))
    {
      VkMsg *msg = list_entry(entry->messages.next, VkMsg, list);
      if (msg->out)
      {
        if (msg->peer_id == from_id)
          return entry;
      }
      else
        if (msg->from_id == from_id)
          return entry;
    }     
  }
  return NULL;
}

VkMsg *get_DialogMsg(VkDialog *dialog)
{
  VkMsg *msg = NULL;
  
  if (!list_empty(&dialog->messages))
    msg = list_entry(dialog->messages.next, VkMsg, list);
  
  return msg;
}

void del_Dialogs()
{ 
  struct list_head *iter, *n;
    
  list_for_each_safe(iter, n, &dialogs)
  {
    VkDialog *entry = list_entry(iter, VkDialog, list);
    
    if (!list_empty(&entry->messages))
      del_Messages(&entry->messages);
    
    if (entry->user)
      del_User(entry->user);
    
    if (entry->group)
      del_Group(entry->group);
    
    list_del(iter);
    mfree(entry);
  }
  INIT_LIST_HEAD(&dialogs);
}

/******************************************************************************/

int count_ListElements(LIST_HEAD *head)
{
  struct list_head *iter;
  int i = 0;
  
  list_for_each(iter, head)
    i++;
  
  return i;
}

struct list_head *get_ListByIndex(LIST_HEAD *head, int index)
{
  struct list_head *iter;
  int i = 0;
  
  list_for_each(iter, head)
  {
    if (i == index)
      return iter;
    i++;
  }
  
  return 0;
}


/*
int AddMsg2Dialog(PRS_MSG* msg)
{
  DIALOG* d = FindDialog(msg->from_id);
  
  if (d == NULL)//если диалога нет, то создаем
    d = new_Dialog(from_id, NULL);
  
  PRS_MSG* msg = FindMsgById(id);
  
  if (msg)//если сообщение уже есть в списке
    return 1;
  
  list_add(&d->message, &msg->list); 
  return 0;
}

void FreeAtachments(ATTACH* a)
{
  while (a)
  {
    if (a->url)
      mfree(a->url);
    void* next=a->next;
    mfree(a);
    a=next;
  }
}

WALL_ATTACH* FindAttachByIndex(WALL_MSG* msg, int i)
{
  WALL_ATTACH* attach=msg->attach_list;
  int n=0;
  
  while(attach)
  {
    if (i == n)
      break;
    n++;
    attach=attach->next;
  }
  return attach;  
}

PERSONAL_MSG* AllocMSG()
{
  PERSONAL_MSG* msg;
  
  msg=malloc(sizeof(PERSONAL_MSG));
  msg->prev=0;  
  msg->next=0;
  msg->body=NULL;  
  msg->id=0;
  msg->date=0;  
  msg->user_id=0;
  msg->read_state=0;
  msg->out=0;
  msg->emoji=0;
  msg->attach=0;
  
  return msg;
};

void FreeWALLMSG(CLIST* c)
{
  WALL_MSG* msg=(WALL_MSG*)c->wall_msglist;
  c->wall_msglist=NULL;
  
  while (msg)
  {
    if (msg->text)
      FreeWS(msg->text);
    if (msg->attach_list)
      FreeAtachments(msg->attach_list);
    if (msg->profiles)
      CLIST_Free(&msg->profiles);
    void* next=msg->next;
    mfree(msg);
    msg=next;
  }
}

void FreeMSGLIST(CLIST* c)
{
  PERSONAL_MSG* msg=c->msglist;
  
  while (msg)
  {
    void* next=msg->next;
    if (msg->body)
      FreeWS(msg->body);
    mfree(msg);
    msg=next;
  }
  c->msglist=NULL;
}

PERSONAL_MSG* FindMsgById(CLIST* c, int id)
{
  PERSONAL_MSG* msg;
  
  if (c==NULL)
    return(0);
  
  msg=c->msglist;
  
  while(msg)
  {
    if (msg->id==id)
      return msg;
    msg=msg->next;
  }
  return(0);  
}

void AddMsg(CLIST* c, PERSONAL_MSG* msg)
{
  PERSONAL_MSG* msg_i; 
  PERSONAL_MSG* msg_prev;
  
  c->msg_count++;//счетчик сообщений
  
  if (msg->out==0 && msg->read_state==0)//если не прочитано
    c->unread++;
  
  if (c->msglist==NULL)//добавляем первое сообщение
  {
     c->msglist=msg;
    return;
  }
  
  msg_i=c->msglist;
  
  while (msg_i)
  {
    if (msg->id > msg_i->id)//ищем мессагу с id мньше нашего
    {
      msg_prev=msg_i->prev;
      if (msg_prev==0)//значит топ
        c->msglist=msg;
      else
        msg_prev->next=msg;
      msg->next=msg_i;
      msg->prev=msg_prev;
      msg_i->prev=msg;
      break;
    }
    else
      if (msg_i->next==NULL)//не нашли,вставляем в конец списка
      {
        msg->next=0;
        msg->prev=msg_i;
        msg_i->next=msg;     
        break;
      }
    msg_i=msg_i->next;
  }  
}


void AddUserInfo(int id, int deactivated, char* first_name, char* last_name, char* photo_50)
{
  if (id == my_id)//свои данные пока не обновляем
    return;
  
  CLIST* c = FindContactById(csm->dialogs_list, id);
  
  if (c == NULL)//если контакта нет в списке
    return;
     
  if (first_name)
  {
    if (c->first_name == NULL)
      c->first_name = AllocWS(65);     
    utf8_2ws(c->first_name, first_name, strlen(first_name));

  }
  
  if (last_name)
  {
    if (c->last_name == NULL)
      c->last_name = AllocWS(65);     
    utf8_2ws(c->last_name, last_name, strlen(last_name));
  }
  
  if (photo_50)
  {
    if (c->photo_url == NULL)
      c->photo_url = malloc(strlen(photo_50));
    c->photo_url = photo_50;
  }
 
}


CLIST* CreateContact(int id)
{
  CLIST* c;
  
  c=malloc(sizeof(CLIST));
  c->next=NULL;
  c->prev=NULL;
  c->msglist=NULL;
  c->wall_msglist=NULL;
  c->user_id=id;
  c->first_name=NULL;
  c->last_name=NULL;
  c->photo=NULL;
  c->photo_url=NULL;
  c->flag_load_photo=0;
  c->deactivated=0;
  c->msg_count=0;  
  c->unread=0;
  return c;
}

static void FreeContact(CLIST* c)
{
  if (c->first_name)
    FreeWS(c->first_name);
  
  if (c->last_name)
    FreeWS(c->last_name);
  
  if (c->msglist)
    FreeMSGLIST(c);

  if (c->wall_msglist)
    FreeWALLMSG(c);
  
  if (c->photo_url)
    mfree(c->photo_url);
  
  if (c->photo)
  {
    mfree(c->photo->bitmap);
    mfree(c->photo);
  }
  mfree(c);
}

void CLIST_Free(CLIST** cl)
{
  CLIST* c=*cl;

  while(c)
  {
    CLIST* c_next=c->next;
    FreeContact(c);
    c=c_next;
  }
  *cl=NULL;
}

static int FindContact(CLIST* cl, CLIST* c)
{
  CLIST* c_next=cl;
  
  while(c_next)
  {
    if (c_next == c)
      return (1);
    c_next=c_next->next;
  }
  return(0);
}

CLIST* FindContactById(CLIST* cl, int user_id)
{
  CLIST* c=cl;
  
  while(c)
  {
    if (c->user_id==user_id)
      return c;
    c=c->next;
  }
  return(0);
}

static void CutContactFromList(CLIST** cl, CLIST* c)
{ 
  CLIST* c_prev=c->prev;
  CLIST* c_next=c->next;
  c->prev=0;
  c->next=0;
  if (c_prev)
    c_prev->next=c_next;
  else//если контакт был в топе
    *cl=c_next;
  if (c_next)
    c_next->prev=c_prev;
}

void DeleteContact(CLIST** cl, int user_id)
{
  CLIST* c;
  
  if (c=FindContactById(*cl, user_id))
  {
    CutContactFromList(cl, c);
    FreeContact(c);
  }
}

void AddContactToList(CLIST** cl, CLIST* c)//добавление с сортировкой по дате
{
  CLIST* c_next;
  CLIST* c_prev;
  
  if (*cl==NULL)
  {
    *cl=c;
    return;
  }
  
  if (FindContact(*cl, c))
  {
    if (c->next==NULL && c->prev==0)//если в списке только наш контакт
      return;
    else 
      CutContactFromList(cl, c);  
  }
  
  c_next=*cl;
  
  while (c_next)
  {
    if (c->msglist->date > c_next->msglist->date)//ищем сообщение с date меньше нашего
    {
      c_prev=c_next->prev;
      
      if (c_prev == 0)//непорядок-контакт с меньшим id сообщения в топе.
        *cl=c;
      else
        c_prev->next=c;
      c->next=c_next;
      c->prev=c_prev;
      c_next->prev=c;
      break;
    }
    else
      if (c_next->next==NULL)//не нашли,вставляем в конец списка
      {
        c->next=0;
        c->prev=c_next;
        c_next->next=c;
        break;
      }
    
    c_next=c_next->next;
  } 
}


CLIST* FindContactByN(CLIST* cl, int n)
{
  CLIST* c;
  int i=0;
  
  c=cl;
  
  while(c)
  {
    if (i == n)
      break;
    i++;
    c=c->next;
  }
  return c;
}

int GetContactN(CLIST* cl, CLIST* c)
{
  CLIST* c_next;
  int i=0;
  
  c_next=cl;
  
  while(c_next)
  {
    if (c_next == c)
      break;
    i++;
    c_next=c->next;
  }
  return i;
}

CLIST* FindLastContact(CLIST* cl)
{
  CLIST* c=cl;
  
  if(c==NULL)
    return(0);
  
  while(c)
  {
    if (c->next == NULL)
      break;
    c=c->next;
  }
  
  return c;     
}

int CLIST_GetCount(CLIST* cl)
{
  CLIST* c=cl;
  int count=0;
  
  if(c==NULL)
    return(0);
  
  while(c)
  {
    count++;
    c=c->next;
  }
  
  return count;  
}


char* create_noninfo_users_ids(CLIST* cl) 
{
  int len_c=0;
  int len_s=0;
  char* s=NULL;
  char c[32];
  
  CLIST* user=cl;
  
  while (user)
  {
    if (user->first_name==NULL && user->user_id > 0)
    {
      sprintf(c, percent_d, user_id);
      len_c=strlen(c);
      if (s)
        len_s=strlen(s);
      s=realloc(s, len_s+len_c+2);
      if (len_s)
      {
        s[len_s]=',';
        s[len_s+1]='\0';
      }
      strcat(s, c);
    }
    user=user->next;
  }
  
  return s;
}
*/

char* create_noninfo_dialog_users_ids(LIST_HEAD *head) 
{
  char* s;
  char* s1;
  int i=0;
  
  struct list_head *iter;
  
  list_for_each(iter, head)
  {
    VkDialog *dialog = list_entry(iter, VkDialog, list);
    if (dialog->user == NULL)
      i++;
  }
 
  if (i == 0)
    return NULL;
  
  s=malloc(16 * i);
  s1=s;
  
  list_for_each(iter, head)
  {
    VkDialog *dialog = list_entry(iter, VkDialog, list);
    if (dialog->user == NULL)
    {
      VkMsg *msg = get_DialogMsg(dialog);
      int user_id;
      if (msg->out == 0)
        user_id = msg->from_id;
      else
        user_id = msg->peer_id;
      s1 += sprintf(s1, percent_d, user_id);
    }    
  }
  
  return s;
}
//******************************************************************************

