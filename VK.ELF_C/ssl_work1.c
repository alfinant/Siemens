#include "ssl_work.h"
#include "socket_work.h"
#include <openssl/ssl.h>
#include <siemens/swilib.h>
#include "list.h"

extern char logmsg[];
extern void SMART_REDRAW();

static SSL_CTX *ctx = NULL;
int SSL_MAX_SESS_COUNT = 1;
int ssl_con_err = -1;
int ssl_write_err = -1;
int ssl_read_err = -1;
int ssl_peek_err = -1;
int ssl_shut_err = -1;

static SSL *ssl_last = NULL;
static int sock_last = -1;
static char hostname_last[64];

//******************************************************************************

int SSL_session_reused(SSL *ssl)
{
  return ssl->hit;
}

//методы BIO реализуем сами, чтобы SSL_connect() нормально работал. Ибо разрабы привязали BIO методы к стандартному браузеру.
int bwrite(BIO *b, const char *data, int len)
{
  *socklasterr() = 0;
  
  int send_res = send(b->num, data, len, 0);
  
  if (send_res == -1 && *socklasterr() == 0xC9)
    return 0;
  
  return send_res;
}

int bread(BIO *b, char *data, int len)
{
  *socklasterr() = 0;
  
  int recv_res = recv(b->num, data, len, 0);
  
  if (recv_res == -1 && *socklasterr() == 0xC9)
    return 0;
  
  return recv_res;  
}

//******************************************************************************

GBSTMR tmr_connect_timeout;
GBSTMR tmr_read_timeout;

void tmr_connect_timeout_handler()
{
  end_ssl_last();
  if (socket_error_handler)
    socket_error_handler(ERROR_SSL_CONNECT_TIMEOUT);
}

void tmr_read_timeout_handler()
{
  end_ssl_last();
  if (socket_error_handler)
    socket_error_handler(ERROR_READ_TIMEOUT);
}

//******************************************************************************
typedef struct
{
  struct list_head list;
  SSL_SESSION *ssl_session;  
  SSL *ssl;
  int sock;
  unsigned short port;  
  char hostname[64];
} SSLWORK;

LIST_HEAD(connect_list);

void end_ssl(SSL* ssl);

static SSLWORK * SSLWORK_new(char *hostname, SSL *ssl, SSL_SESSION *session)
{   
  SSLWORK *connect = malloc(sizeof(SSLWORK));
  INIT_LIST_HEAD(&connect->list);
  connect->ssl_session = session;
  connect->ssl = ssl;
  snprintf(connect->hostname, 63, hostname);
  return connect;
}

static SSLWORK * SSLWORK_findBySSL(SSL *ssl)
{
  struct list_head *iter;
  
  list_for_each(iter, &connect_list)
  {
    SSLWORK *entry = list_entry(iter, SSLWORK, list);
    
    if (entry->ssl == ssl)
      return entry;
  }
  return(0);  
}

static SSLWORK * SSLWORK_findBySock(short sock)
{
  struct list_head *iter;
  
  list_for_each(iter, &connect_list)
  {
    SSLWORK *entry = list_entry(iter, SSLWORK, list);
    
    if (entry->ssl && entry->ssl->wbio->num == sock)
      return entry;
  }
  return(0);  
}

static SSLWORK *SSLWORK_findByHostname(char *hostname)
{
  struct list_head *iter;
  
  list_for_each(iter, &connect_list)
  {
    SSLWORK *entry = list_entry(iter, SSLWORK, list);
    if (strcmp(entry->hostname, hostname))
      return entry;
  }
  return(0);
}

//------------------------------------------------------------------------------

void end_ssl(SSL* ssl)
{
  SSLWORK *connect;
  
  GBS_DelTimer(&tmr_read_timeout);
  
  short sock = ssl->wbio->num;
  ssl_shut_err = SSL_shutdown(ssl);//Отправим серверу "close notify".Ожидать подтверждения конечно же не будем
  
  SSL_free(ssl_last);
  
  if (connect = SSLWORK_findBySSL(ssl))
    connect->ssl = NULL;
  
  if (ssl == ssl_last)
  {
    ssl_last = NULL;
    sock_last = -1;
    connect_state = -1;
    receive_mode = 0;
  }
  
  shutdown(sock, 2);
  closesocket(sock);
}

void end_ssl_last()
{
  end_ssl(ssl_last);
}

void end_ssl_by_sock(short sock)
{
  struct list_head *iter;
  
  list_for_each(iter, &connect_list)
  {
    SSLWORK *entry = list_entry(iter, SSLWORK, list);
    
    if (entry->ssl && entry->ssl->wbio->num == sock)
      end_ssl(entry->ssl);
  }
}

void end_ssl_work()
{ 
  struct list_head *iter, *n;
    
  list_for_each_safe(iter, n, &connect_list)
  {
    SSLWORK *entry = list_entry(iter, SSLWORK, list);
    
    if (entry->ssl)
      end_ssl(entry->ssl);
    
    if (entry->ssl_session)
        SSL_SESSION_free(entry->ssl_session);
    
    mfree(entry);
  }
  
  INIT_LIST_HEAD(&connect_list);
}

//******************************************************************************

static int ssl_get_answer()
{ 
  char tmp_dat[4096];
  
  if (recv_buf==NULL)
  {
    TOTALRECEIVED=0;
    free_recv_buf();
  }
  
  ssl_read_err = SSL_read(ssl_last, tmp_dat, 4096);
  
  if (ssl_read_err > 0)
  {
    recv_buf=realloc(recv_buf, TOTALRECEIVED+ssl_read_err);
    memcpy(recv_buf+TOTALRECEIVED, tmp_dat, ssl_read_err);
    TOTALRECEIVED+=ssl_read_err;
  }

#ifdef DEBUG  
  if(ssl_read_err ==-1)
  {
    sprintf(logmsg,"SSL_read error!"); 
    SMART_REDRAW();
  }
#endif
  
  return ssl_read_err;
}
//******************************************************************************
//
void ssl_send_answer(const char *url, char *buf, int len)
{
  static int send_q_size;
  
  if (url)//если первый вызов
  {
    ssl_write_err = -1; 
    free_send_buf();
    send_buf = buf;
    send_buf_len = len;
    send_q_size = len;
    
    get_host_from_url(hostname_last, url);
    SSLWORK *connect = SSLWORK_findByHostname(hostname_last);
    
    connect_state = -1;
    
    if (connect && connect->ssl)//коннект активен(при keep-alive)
    {
      ssl_last = connect->ssl;
      connect_state = 3;
    }
  }
    
    if (connect_state == -1)
    {
      DNR_TRIES=3;
      create_connect(url);
      return;
    }
    
  ssl_write_err=SSL_write(ssl_last, send_buf+(send_buf_len-send_q_size), send_buf_len);
  
  if (ssl_write_err !=-1)
  {
    send_q_size -= ssl_write_err;
    TOTALSENDED += ssl_write_err;
    ALLTOTALSENDED += TOTALSENDED;
  }
  
  if (ssl_write_err >  0)
  {
    if (send_q_size)//послали меньше чем заказывали
    {
#ifdef DEVELOP
    ShowMSG(1,(int)"send_q_size");
#endif
        return;//ожидаем сообщения ENIP_BUFFER_FREE???
    }
    
    receive_mode = 1;
    GBS_DelTimer(&tmr_read_timeout);
    GBS_StartTimerProc(&tmr_read_timeout, 216* 30 , tmr_read_timeout_handler);
    
#ifdef DEBUG      
    sprintf(logmsg,"SSL_write Ok");
    SMART_REDRAW();
#endif
    
    return;
  }
  
  if (ssl_write_err ==0)//...? 
  {
    //end_ssl_last();
    socket_error_handler(ERROR_WRITE);
    
#ifdef DEBUG
    ShowMSG(1,(int)"SSL write==0");
    sprintf(logmsg,"ssl_write==0");
    SMART_REDRAW();
#endif
    
    return;
  } 
  
  if(ssl_write_err ==-1)
  {
    end_ssl_last();
    socket_error_handler(ERROR_WRITE);
    return;
  }
}

//******************************************************************************
/*
static int verify_callback(int mode, X509_STORE_CTX *ctx)
{
  return 0;
}
*/
//****************************************************************************

//Вызывается после создания новой сессии
static int new_session(SSL *ssl, SSL_SESSION *new_session)
{
  SSLWORK *connect = SSLWORK_findByHostname(hostname_last);
  
  if (connect)
  {
    connect->ssl_session = new_session;
    connect->ssl = ssl;
  }
  else
    connect = SSLWORK_new(hostname_last, ssl, new_session);

  TOTALNEWSSLSESSIONS++;

  return(1);
}

static void remove_session(SSL_CTX *ctx, SSL_SESSION *sess)
{//Сессия удалена из контекста по причине истечения тайм-аута, либо удаляется сам контекст
  
  SSLWORK *connect;
  
  //раз сессия больше не нужна
  sess->references = 1;
  
  if (connect = SSLWORK_findByHostname(hostname_last))//ищем сессию в кэше
  {
    if (connect->ssl_session == sess)
      connect->ssl_session = NULL;    
#ifdef DEBUG    
    ShowMSG(1,(int)"Session Remove");
#endif    
  } 
}

//******************************************************************************
/*
//ищем в кэше нужную сессию(при работе с внутренним кэшем)
static SSL_SESSION *get_session(SSL* ssl, unsigned char *data, int len, int *copy)
{
//Не разобрался еще..
  return 0;
}
*/
//******************************************************************************
 
static int ssl_connect(short sock)
{
  SSLWORK *connect;

#ifdef DEBUG
  sprintf(logmsg,"SSL connect...");
  SMART_REDRAW();
#endif
 
  if (sock)
  {
    sock_last = sock;
    ssl_con_err = -1;
    
    if (!ctx)
    {    
      ctx = SSL_CTX_new(TLSv1_client_method());
      SSL_CTX_ctrl(ctx, SSL_CTRL_SET_SESS_CACHE_MODE, SSL_SESS_CACHE_CLIENT | SSL_SESS_CACHE_NO_INTERNAL_LOOKUP, 0);//запрещаем внутренний кэш
      //ssl_ctx_ctrl(ctx, SSL_CTRL_SET_SESS_CACHE_SIZE, 5, 0);
      SSL_CTX_sess_set_new_cb(ctx, new_session);
      SSL_CTX_sess_set_remove_cb(ctx, remove_session);
      //SSL_CTX_sess_set_get_cb(ctx, get_session);
    }   
    
    SSL *ssl = SSL_new(ctx);  
    ssl_last = ssl;
    
    if (connect = SSLWORK_findByHostname(hostname_last))//ищем сохраненную сессию
    {
      connect->ssl = ssl;//
      
      if (connect->ssl_session)
      {
        if (connect->ssl_session->not_resumable)//на всякий случай
        {
          connect->ssl_session->references = 0;
          SSL_SESSION_free(connect->ssl_session);
          connect->ssl_session = NULL;
        }
        else
        {     
          connect->ssl_session->references = 2;//если 1-сессия удаляется.Хз почему...
          SSL_set_session(ssl, connect->ssl_session);
        }
      }
    }
    
    SSL_set_fd(ssl, sock);
    ssl->wbio->method->bwrite = bwrite;
    ssl->rbio->method->bread = bread;
  }
  
  ssl_con_err = SSL_connect(ssl_last);
  
  if (ssl_con_err == -1)//error
  {
    end_ssl_last();
    
    socket_error_handler(ERROR_SSL_CONNECTION);
#ifdef DEBUG    
    sprintf(logmsg, "SSL_connect Error!");
    SMART_REDRAW();
#endif
  }
  
#ifdef DEBUG  
  if (ssl_con_err == 1)//ok
    sprintf(logmsg,"SSL_connect Ok!");
#endif
  return ssl_con_err;
}

//******************************************************************************

void ssl_socket_msg_handler(GBS_MSG* msg)
{
  switch((int)msg->data0)
  {
  case LMAN_DISCONNECT_IND:
    is_gprs_online=0;
    socket_error_handler(GPRS_OFFLINE);
    
#ifdef DEBUG      
    sprintf(logmsg,"GPRS offline...");
    SMART_REDRAW();
#endif    
    return;
  
  case LMAN_CONNECT_CNF:
    //start_vibra(VIBR_ON_CONNECT);
    is_gprs_online=1;
    socket_error_handler(GPRS_ONLINE);
      if (!disautorecconect)
      {
#ifdef DEBUG          
        sprintf(logmsg,"GPRS online");
        SMART_REDRAW();
#endif
        reconnect();
      }
    break; 
  
  case ENIP_DNR_HOST_BY_NAME:
    if ((int)msg->data1 == DNR_ID)
    {
      if (DNR_TRIES)
        create_connect(NULL);
    }
    break;
  
  case ENIP_SOCK_CONNECTED:
    if ((int)msg->data1 == sock)
    {
      //Если посылали запрос
      if (connect_state == 1)
      {
        connect_state = 2;
        receive_mode = 0;
        sock_last = (int)msg->data1;
        ssl_connect((int)msg->data1);
        GBS_StartTimerProc(&tmr_connect_timeout, 216* 30 , tmr_connect_timeout_handler);      
      }
    }
    break;
  
  case ENIP_SOCK_DATA_READ:
    //Если посылали send
    if ((int)msg->data1 != sock_last)
      return;
   
    if (connect_state == 2) 
    {
      if (ssl_con_err == 0)//если хэндшейк еще не закончен
      {
        ssl_connect(0);//повторно вызываем 
        
        if (ssl_con_err == 1)//SSL соединение установлено
        {
          GBS_DelTimer(&tmr_connect_timeout);
          connect_state = 3;
          ssl_send_answer(0, 0, 0);//возобновляем передачу данных
          return;
        }
      }
    }
    
    if (connect_state == 3)
    {
      if (receive_mode && ssl_write_err > 0)
      {
        int answer=ssl_get_answer();
          
        if (answer > 0)//если есть данные
        {
          if (socket_data_readed_handler((int)msg->data1==sock))//все данные получены
          {
            ALLTOTALRECEIVED+=TOTALRECEIVED;
            receive_mode = 0;
            GBS_DelTimer(&tmr_read_timeout);
            
#ifdef DEBUG               
            sprintf(logmsg,"SSL_Read OK");
            SMART_REDRAW();
#endif
            return;
          }
          GBS_DelTimer(&tmr_read_timeout);
          GBS_StartTimerProc(&tmr_read_timeout, 216* 30 , tmr_read_timeout_handler);
        }
        else
          if (answer < 0)
          {
            receive_mode = 0;
            return;
          }
      }
    }
    break;
  
  case ENIP_BUFFER_FREE://Досылаем очередь
  case ENIP_BUFFER_FREE1:
    
    if (!SSLWORK_findBySock((int)msg->data1))
      return;
    //ssl_send_answer(0, 0, 0); 
#ifdef DEBUG 
    ShowMSG(1, (int)"bffer free");
    sprintf(logmsg,"ENIP_BUFFER_FREE");
    SMART_REDRAW();
#endif    
    break;
  
  case ENIP_SOCK_REMOTE_CLOSED://Закрыт со стороны сервера
    
    if (!SSLWORK_findBySock((int)msg->data1))
      return;
     
#ifdef DEBUG   
    sprintf(logmsg,"Сервер %s закрыл соед.");
    SMART_REDRAW();
#endif 
    
    if (sock_last == (int)msg->data1)//если это текущее соединение
    {
      GBS_DelTimer(&tmr_read_timeout); 
      socket_remote_closed_handler((int)msg->data1); 
    }
    end_ssl_by_sock((int)msg->data1);
    break;
  
  case ENIP_SOCK_CLOSED:        
    //Закрыт вызовом closesocket
    //sprintf(logmsg,"Соединение закрыто вызовом closesocket");
    break;
  }
}

