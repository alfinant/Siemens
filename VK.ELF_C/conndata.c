#include "conndata.h"
#include "url_utils.h"

static LIST_HEAD(connection_list);

int ALLTOTALCONNECTIONS=0;
int ALLTOTALRECEIVED=0;
int ALLTOTALSENDED=0;

CONNDATA *CONNDATA_new(const char *url, int flag)
{
  CONNDATA *conn = malloc(sizeof(CONNDATA));
  INIT_LIST_HEAD(&conn->list);
  list_add(&conn->list, &connection_list);
  get_host_from_url(conn->hostname, url);
  conn->url = malloc(strlen(url)+1);
  strcpy(conn->url, url);
  conn->sock = -1;
  conn->sock_state = -1;
  conn->recv_mode = 0;
  
  if (strncmp(url, "https://", 8)==0)
    conn->port=443;
  else
    conn->port=80;
  
  conn->flag = flag;
  conn->DNR_ID=0;
  conn->DNR_TRIES=3;
  
  conn->TOTALSENDED=0;
  conn->TOTALRECEIVED=0;
  //conn->tmr_connect=NULL;
  //conn->tmr_read=NULL;
  
  conn->ssl = NULL;
  conn->ssl_sess = NULL;
  conn->ssl_state = -1;
  return conn;
}

void CONNDATA_free(CONNDATA *conn)
{
  list_del(&conn->list);
  mfree(conn->url);
  mfree(conn);
}

CONNDATA *CONNDATA_getTop()
{
  return list_empty(&connection_list) ? 0 : (CONNDATA*)connection_list.next;
}

CONNDATA *CONNDATA_findBySock(int sock)
{
  struct list_head *iter;
  
  list_for_each(iter, &connection_list)
  {
    CONNDATA *entry = list_entry(iter, CONNDATA, list);
    
    if (entry->sock == sock)
      return entry;
  }
  return(0);  
}

CONNDATA *CONNDATA_findBySSL(SSL *ssl)
{
  struct list_head *iter;
  
  list_for_each(iter, &connection_list)
  {
    CONNDATA *entry = list_entry(iter, CONNDATA, list);
    
    if (entry->ssl == ssl)
      return entry;
  }
  return(0);  
}

CONNDATA *CONNDATA_findBySession(SSL_SESSION *sess)
{
  struct list_head *iter;
  
  list_for_each(iter, &connection_list)
  {
    CONNDATA *entry = list_entry(iter, CONNDATA, list);
    
    if (entry->ssl_sess == sess)
      return entry;
  }
  return(0);  
}

CONNDATA *CONNDATA_findByHostname(const char *hostname)
{
  struct list_head *iter;
  
  list_for_each(iter, &connection_list)
  {
    CONNDATA *entry = list_entry(iter, CONNDATA, list);
    if (strcmp(entry->hostname, hostname) == 0)
      return entry;
  }
  return(0);
}

CONNDATA *CONNDATA_findByURL(const char *url)
{
  char hostname[64];
  hostname[0]='\0';
  get_host_from_url(hostname, url);
  return CONNDATA_findByHostname(hostname);
}

CONNDATA *CONNDATA_findByDNR(int dnr)
{
  struct list_head *iter;
  
  list_for_each(iter, &connection_list)
  {
    CONNDATA *entry = list_entry(iter, CONNDATA, list);
    
    if (entry->DNR_ID == dnr)
      return entry;
  }
  return(0);  
}


