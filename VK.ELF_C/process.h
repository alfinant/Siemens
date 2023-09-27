#ifndef _HTTP_PROC_H_
#define _HTTP_PROC_H_

extern int INET_PROCESS;

#define TEST_SSL_CON                 33
#define AUTH_PARSE_M_VK_COM_LOGIN    1
#define AUTH_SEND_LOGIN_PASS         2
#define AUTH_LOAD_CAPTCHA            3
#define OAUTH_AUTHORIZE              4
#define OAUTH_GET_TOKEN              5
#define AUTH_DIRECT                  6
#define AUTH_DIRECT_NEED_VALIDATIINET_PROCESSON  7

#define ENABLE_STATISTIC             8
#define GET_MY_ID                    9
#define GET_LONG_POOL_SERVER         10
#define CHECK_NEW_MESSAGES           11
#define LOAD_DIALOGS                 12
#define LOAD_USERS_INFO              13
#define DOWNLOAD_USER_PHOTO          15
#define SEND_MESSAGE                 16
#define LOAD_HISTORY                 17
#define DELETE_DIALOG                18
#define LOAD_FRIENDS                 19
#define MSG_MARK_AS_READ             20
#define LOAD_GROUPS                  21
#define LOAD_GROUPS_INFO             22
#define LOAD_WALL                    23
#define DOWNLOAD_ATTACH_PHOTO        24
#endif
