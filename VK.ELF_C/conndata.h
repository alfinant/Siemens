#ifndef __CONNDATA_H
#define __CONNDATA_H

#include "list.h"
#include <openssl/ssl.h>
#include <siemens/swilib.h>

extern int ALLTOTALCONNECTIONS;
extern int ALLTOTALRECEIVED;
extern int ALLTOTALSENDED;

typedef struct
{
  struct list_head list;
  char *url;
  char hostname[64];
  int sock;//socket
  unsigned short port;
  int sock_state;//-1-socket closed, 0-socket connecting, 1-socket connected.
  int recv_mode;
  int DNR_ID;
  int DNR_TRIES;
  int flag;//1-keepalive
  int TOTALSENDED;
  int TOTALRECEIVED;
  GBSTMR tmr_connect;
  GBSTMR tmr_read;
  SSL *ssl;
  int ssl_state;//-1-ssl shutdown, 0-ssl handshake started, 1-ssl handshake OK.
  SSL_SESSION *ssl_sess;
} CONNDATA;

CONNDATA *CONNDATA_new(const char *url, int flag);
CONNDATA *CONNDATA_getTop();
CONNDATA *CONNDATA_findBySSL(SSL *ssl);
CONNDATA *CONNDATA_findBySession(SSL_SESSION *sess);
CONNDATA *CONNDATA_findBySock(int sock);
CONNDATA *CONNDATA_findByDNR(int id);
CONNDATA *CONNDATA_findByHostname(const char *hostname);
CONNDATA *CONNDATA_findByURL(const char *url);
void CONNDATA_free(CONNDATA *conn);
void CONNDATA_set2Top(CONNDATA *con);

#endif


