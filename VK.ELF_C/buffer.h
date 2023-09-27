#ifndef __BUFFER_H
#define __BUFFER_H

extern char *send_buf;
extern char *recv_buf;

extern int send_buf_len;
extern int recv_buf_len;

void free_buffers();
void free_recv_buf();
void free_send_buf();

#endif
