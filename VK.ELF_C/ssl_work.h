#ifndef __SSL_WORK_H
#define __SSL_WORK_H

#include <siemens\swilib.h>
#include "conndata.h"

void ssl_send_answer(const char *url, char *buf, int len, int flag);
void ssl_socket_msg_handler(GBS_MSG *msg);
void end_ssl(CONNDATA *conn);
void end_ssl_work();

#endif


