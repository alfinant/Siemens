#include "buffer.h"
#include <siemens/swilib.h>

char *send_buf=0;
char *recv_buf=0;

int send_buf_len=0;
int recv_buf_len=0;

void free_recv_buf()
{
  recv_buf_len=0;
  if (recv_buf)
    mfree(recv_buf);
  recv_buf=NULL;
}

void free_send_buf()
{
  send_buf_len=0;
  if (send_buf)
    mfree(send_buf);
  send_buf=NULL;
}

void free_buffers()
{
  free_recv_buf();
  free_send_buf();
}
