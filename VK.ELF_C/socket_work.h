#ifndef __SOCKET_WORK_H
#define __SOCKET_WORK_H

#include <siemens\swilib.h>
#include "conndata.h"

#define WAITING_FOR_GPRS_UP        1
#define CONNECT_FAULT              2
#define ERROR_CREATE_SOCK          3
#define GPRS_OFFLINE               4
#define GPRS_ONLINE                5
#define ERROR_WRITE                6
#define ERROR_READ                 7
#define ERROR_READ_TIMEOUT         8
#define ERROR_SSL_CONNECTION       9
#define ERROR_SSL_CONNECT_TIMEOUT  10

extern int is_gprs_online;
extern int disautorecconect;

extern int (*sock_data_read_handler)(CONNDATA *conn);
extern void (*sock_remote_closed_handler)(short sock);
extern void (*sock_error_handler)(int err);

void socket_work_init(void* err_handler, void* data_read_handler, void* remote_close_handler);
void end_socket(int sock);
void end_socket_work();

void connect_socket(CONNDATA *conn);
void reconnect();
void send_answer(const char* url, char *buf, int len, int flag);
void socket_msg_handler(GBS_MSG *msg);

#endif
//******************************************************************************
//socklasterr()
//0xD5- sock closed
//0xD8- time-out???
