typedef struct
{
  struct list_head list;
  int state;//-1-socket closed, 0-sock connecting, 1-sock connected, 2-ssl handshake started, 3-ssl handshake OK
  int socket;
  unsigned int port;
  SSL *ssl;
  SSL_SESSION *ssl_session;  
  char hostname[64];
} CDATA;

LIST_HEAD(connect_list);

CDATA * CDATA_new(char *hostname, int sock, SSL *ssl, SSL_SESSION *session)
{   
  CDATA *con = malloc(sizeof(CDATA));
  INIT_LIST_HEAD(&con->list);
  list_add(&con->list, &connect_list);
  con->ssl_session = session;
  con->ssl = ssl;
  con->socket = sock;
  snprintf(con->hostname, 63, hostname);
  return con;
}


CDATA *CDATA_findBySSL(SSL *ssl)
{
  struct list_head *iter;
  
  list_for_each(iter, &connect_list)
  {
    CDATA *entry = list_entry(iter, CDATA, list);
    
    if (entry->ssl == ssl)
      return entry;
  }
  return(0);  
}


CDATA * CDATA_findBySock(unsigned int sock)
{
  struct list_head *iter;
  
  list_for_each(iter, &connect_list)
  {
    CDATA *entry = list_entry(iter, CDATA, list);
    
    if (entry->socket == sock && entry->ssl)
      return entry;
  }
  return(0);  
}


CDATA *CDATA_findByHostname(char *hostname)
{
  struct list_head *iter;
  
  list_for_each(iter, &connect_list)
  {
    CDATA *entry = list_entry(iter, CDATA, list);
    if (strcmp(entry->hostname, hostname) == 0)
      return entry;
  }
  return(0);
}