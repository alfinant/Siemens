#ifndef _VK_API_H_
#define _VK_API_H_

#include "vk_objects.h"

#define ACCESS_TOKEN_MAXLEN    256

#define API_METHOD_MESSAGES_SEND_URL   "https://api.vk.com/method/messages.send.xml"
#define API_METHOD_EXECUTE_URL         "https://api.vk.com/method/execute.xml"
#define API_METHOD_EXECUTE_SEND_URL    "https://api.vk.com/method/execute.sendAndGet.xml"

//scope
#define NOTIFY            (1 << 0)
#define FRIENDS           (1 << 1)
#define PHOTOS            (1 << 2)
#define AUDIO             (1 << 3)
#define VIDEO             (1 << 4)
#define STORIES           (1 << 6)
#define PAGES             (1 << 7)
#define __256             (1 << 8)
#define STATUS            (1 << 10)
#define NOTES             (1 << 11)
#define MESSAGES          (1 << 12)
#define WALL              (1 << 13)
#define ADDS              (1 << 15)
#define OFFLINE           (1 << 16)
#define DOCS              (1 << 17)
#define GROUPS            (1 << 18)
#define NOTIFICATIONS     (1 << 19)
#define STATS             (1 << 20)
#define EMAIL             (1 << 22)
#define MARKET            (1 << 27)


extern int my_id;
extern char my_first_name[];
extern char my_last_name[];
extern char my_photo_50[];

extern char ACCESS_TOKEN[];
extern int vkapi_func;
extern unsigned lp_ts;

extern int total_unread_messages;
extern int last_message_id;

char* url_auth_direct(char *username, char *password, unsigned scope);
char* url_stats_track_visitor();
char* url_messages_getLongPollServer(int need_pts, int group_id/*, int lp_version*/);
char* url_messages_getLongPollHistory(/*int ts, int pts, */ const char* fields);
char* url_messages_getConversations(int offset, int count, int extended, const char* fields);
char* url_groups_get(int offset, int count);
char* url_wall_get(int owner_id, int offset, int extended);
/*
char* users_get(const char* user_ids, const char* fields);
char* groups_getById(const char* group_ids, const char* fields);
char* messages_send(int user_id, char* message);
char* messages_getHistory(int user_id, int count, int start_msg_id);
char* messages_deleteDialog(int user_id, int count);
char* friends_get(int count, int offset, char* order, char* fields);
char* execute_sendAndGet(int user_id, char* message, int last_message_id);
char* execute_getHistory(int user_id, int count);
char* groups_get(int offset, int count);
char* wall_get(int owner_id, int count, int extended);
*/

int parse_answer_auth_direct();
int parse_answer_messages_getLongPollServer();
int parse_answer_messages_getLongPollHistory(LIST_HEAD *messages, LIST_HEAD *profiles);
int parse_answer_messages_getConversations(char *json, int *count);
int parse_answer_users_get();
int parse_answer_friends_get();
int parse_answer_groups_get(char *json, int *n);
/*
int parse_answer_messages_send();
int parse_answer_messages_getHistory();
int parse_answer_messages_deleteDialog(int* user_id);
int parse_answer_wall_get(int* item_count);
*/

#endif

