//******************************************************************************
// Имеем: openssl-0.9.5a скомпилированный с дефайном NO_DH(Диффи и Хеллман отсутствуют)
// Проблем: vk.com перестал поддерживать наши древние наборы шифров
// Mission: добавить поддержку AES128-SHA из AES ciphersuites from RFC3268(extending TLS v1.0)

/*
Siemens S75 ciphersuites:
1. DES-CBC-SHA  0x0A
2. RC4-SHA 0x05
3. RC4-MD5 0x04
4. EXP1024-RC4-SHA 0x64
5. EXP1024-DES-CBC-SHA 0x62
6. EXP1024-RC4-MD5 0x60
7. DES-CBS-SHA 0x09
8. EXP-DES-CBC-SHA 0x08
9. EXP-RC4-MD5 0x03
*/

//для теста на компе
//s_client -connect m.vk.com:443 -tls1 -cipher AES128-SHA

//s75v52
//int EVP_add_cipher(const EVP_CIPHER *c); 0xA0E8F2B9

/* int SSL_library_init(void):
#ifndef OPENSSL_NO_AES
	EVP_add_cipher(EVP_aes_128_cbc());
	EVP_add_cipher(EVP_aes_192_cbc());
	EVP_add_cipher(EVP_aes_256_cbc());
#endif


*/
//******************************************************************************
#include "ssl_work.h"
#include "socket_work.h"
#include "buffer.h"
#include <siemens/swilib.h>
#include <openssl/ssl.h>
#include "ssl_ext.h"

#include "http.h"

extern char logmsg[];
extern void SMART_REDRAW();

static SSL_CTX *ctx = NULL;
int SSL_MAX_SESS_COUNT = 1;

//******************************************************************************
const char* tls1_alert_code_text(int code)
{
  switch(code)
  {
  case SSL3_AD_CLOSE_NOTIFY: return "close_notify";
  case SSL3_AD_UNEXPECTED_MESSAGE: return "unexpected_message";
  case SSL3_AD_BAD_RECORD_MAC: return "bad_record_mac";
  case SSL3_AD_DECOMPRESSION_FAILURE: return "decompression_failure";
  case SSL3_AD_HANDSHAKE_FAILURE: return  "handshake_failure";
  case SSL3_AD_NO_CERTIFICATE: return "no_certificate";
  case SSL3_AD_BAD_CERTIFICATE: return "bad_certificate";
  case SSL3_AD_UNSUPPORTED_CERTIFICATE: return "unsupported_certificate";
  case SSL3_AD_CERTIFICATE_REVOKED: return "certificate_revoked";
  case SSL3_AD_CERTIFICATE_EXPIRED: return "certificate_expired";
  case SSL3_AD_CERTIFICATE_UNKNOWN: return "certificate_unknown";
  case SSL3_AD_ILLEGAL_PARAMETER: return "illegal_parameter";
  default: return NULL;
  }
}

int SSL_session_reused(SSL *ssl)
{
  return ssl->hit;
}

//Чтобы SSL_connect() работал корректно, методы BIO реализуем сами. Ибо прошивочные BIO функции связаны со стандартным браузером.
int bread(BIO *b, char *data, int len)
{
  CONNDATA *conn=CONNDATA_getTop();
   
  *socklasterr() = 0;
  
  int recv_res = recv(/*b->num*/conn->sock, data, len, 0);
  
  if (recv_res == -1 && *socklasterr() == 0xC9)
    
  {
    if(data[0] == SSL3_RT_ALERT)
    {
      sprintf(logmsg, tls1_alert_code_text(data[6]));
      SMART_REDRAW();
    }
    return 0;
  }
  
  return recv_res;  
}

int bwrite(BIO *b, const char *data, int len)
{ 
  CONNDATA *conn=CONNDATA_getTop();
  
  *socklasterr() = 0; 
  
  if (b->num == 0)
    b->num = conn->sock;
  
  if (conn->ssl->bbio)
  {
    conn->ssl->bbio->method->bread = bread;
    conn->ssl->bbio->method->bwrite = bwrite;
  }
  
  int send_res = send(/*b->num*/conn->sock, data, len, 0);//bio->num может быть пустым...
  
  if (send_res == -1 && *socklasterr() == 0xC9)
    return 0;
  
  return send_res;
}
//******************************************************************************

void tmr_connect_timeout_handler()
{
  end_ssl(CONNDATA_getTop());
  if (sock_error_handler)
    sock_error_handler(ERROR_SSL_CONNECT_TIMEOUT);
}

void tmr_read_timeout_handler(/**/)
{
  end_ssl(CONNDATA_getTop());
  if (sock_error_handler)
    sock_error_handler(ERROR_READ_TIMEOUT);
}

//******************************************************************************

void end_ssl(CONNDATA *conn)
{
  if (conn == NULL)
    return;
  
  GBS_DelTimer(&conn->tmr_read);
  
  SSL_shutdown(conn->ssl);//Отправим серверу "close notify".Ожидать подтверждения конечно же не будем   
  SSL_free(conn->ssl);
  closesocket(conn->sock);
  CONNDATA_free(conn);  
}

void end_ssl_work()
{
  CONNDATA *conn;
    
  while (conn=CONNDATA_getTop())
    end_ssl(conn);
}

//******************************************************************************

static int ssl_get_answer(CONNDATA *conn)
{
  char tmp_dat[4096];
  static int recv_size;
  
  if (recv_buf == NULL)
    recv_size = 0;
              
  int res = SSL_read(conn->ssl, tmp_dat, 4096);
  
  if (res > 0)
  {
    recv_buf=realloc(recv_buf, recv_size+res);
    memcpy(recv_buf+recv_size, tmp_dat, res);
    recv_size+=res;
    conn->TOTALRECEIVED+=res;
    ALLTOTALRECEIVED+=res;
  } 

#ifdef DEBUG
  sprintf(logmsg,"SSL_Read..\nlength: %d\nreceived: %d",HTTP_CONTENT_LENGTH,conn->TOTALRECEIVED-HTTP_HEADER_LENGTH);
  SMART_REDRAW();
#endif
  
#ifdef DEBUG  
  if (res == -1)
  {
    sprintf(logmsg,"SSL_read error!"); 
    SMART_REDRAW();
  }
#endif
  
  return res;
}
//******************************************************************************
//
void ssl_send_answer(const char *url, char *buf, int len, int flag)
{
  static CONNDATA *conn;
  static int send_q_size;
  
  if (url)//если первый вызов функции
  {
    free_send_buf();
    send_buf = buf;
    send_buf_len = len;
    send_q_size = len;
    free_recv_buf();

    conn = CONNDATA_findByURL(url);
   
    if (conn && conn->ssl)//коннект активен(keep-alive)
    {
      conn->TOTALSENDED=0;//сброс счетчиков
      conn->TOTALRECEIVED=0;
    }
    
    else//если соединение не установлено
    {
      conn = CONNDATA_new(url, flag);
      connect_socket(conn);
      return;
    }
  }
  
 int res = SSL_write(conn->ssl, send_buf+(send_buf_len-send_q_size), send_buf_len);
 
 conn->recv_mode = 1;
   
  if (res !=-1)
  {
    send_q_size -= res;
    conn->TOTALSENDED += res;
    ALLTOTALSENDED += res;
  }
  
  if (res > 0)
  {
    if (send_q_size)//послали меньше чем заказывали
    {
#ifdef DEVELOP
    ShowMSG(1,(int)"send_q_size");
#endif
        return;//ожидаем сообщения ENIP_BUFFER_FREE???
    }
    
    //free_recv_buf();нафига это здесь?
    GBS_DelTimer(&conn->tmr_read);
    GBS_StartTimerProc(&conn->tmr_read, 216* 30 , tmr_read_timeout_handler);
    
#ifdef DEBUG      
    sprintf(logmsg,"SSL_write Ok");
    SMART_REDRAW();
#endif
    
    return;
  }
  
  if (res ==0)//...? 
  {
    //end_ssl_last();
    sock_error_handler(ERROR_WRITE);
    
#ifdef DEBUG
    ShowMSG(1,(int)"SSL write==0");
    sprintf(logmsg,"ssl_write==0");
    SMART_REDRAW();
#endif
    
    return;
  } 
  
  if(res ==-1)
  {
    end_ssl(conn);
    sock_error_handler(ERROR_WRITE);
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
  CONNDATA *conn = CONNDATA_findBySSL(ssl);
  
  if (conn)
    conn->ssl_sess = new_session;
  
#ifdef DEBUG
  sprintf(logmsg,"SSL new session");
  SMART_REDRAW();
#endif  
  //else ERROR;   
  //TOTALNEWSSLSESSIONS++;

  return(1);
}

static void remove_session(SSL_CTX *ctx, SSL_SESSION *sess)
{//Вызваетя в случае если сессия удаляется из кэша по причине истечения таймаута или некорректного завершения
  
  CONNDATA *conn;
  
  sess->references = 1;  //сессия больше не нужна
  
  if (conn = CONNDATA_findBySession(sess))//ищем соединение по сессии
  {
    conn->ssl_sess = NULL; 
    
#ifdef DEBUG
    sprintf(logmsg,"SSL session remove: %s",conn->hostname);
    //ShowMSG(1,(int)"Session Remove");//как будто, если вызвать ShowMSG при AnimWidget то краш обеспечен
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
 
static int ssl_connect(int sock)
{
  static int __sock;
 
  if (sock)
    __sock = sock;
  
  CONNDATA *conn = CONNDATA_findBySock(__sock);
  
#ifdef DEBUG
  sprintf(logmsg,"SSL connect...");
  SMART_REDRAW();
#endif
 
  if (sock)
  {
    conn->ssl_state = -1;
    
    if (!ctx)
    {    
      ctx = SSL_CTX_new(TLSv1_client_method());
      
      //Расширение: добавляем  шифры в cipher_list
      //sk_push((STACK*)ctx->cipher_list, (char*)&cipher_2F);
      //sk_push((STACK*)ctx->cipher_list_by_id, (char*)&cipher_2F);
      
      SSL_CTX_ctrl(ctx, SSL_CTRL_SET_SESS_CACHE_MODE, SSL_SESS_CACHE_CLIENT | SSL_SESS_CACHE_NO_INTERNAL_LOOKUP, 0);//запрещаем внутренний кэш сессий(не знаю как корректно с ним работать)
      //ssl_ctx_ctrl(ctx, SSL_CTRL_SET_SESS_CACHE_SIZE, 5, 0);
      SSL_CTX_sess_set_new_cb(ctx, new_session);
      SSL_CTX_sess_set_remove_cb(ctx, remove_session);
      //SSL_CTX_sess_set_get_cb(ctx, get_session);
    }   
    
    SSL *ssl = SSL_new(ctx);  
    conn->ssl = ssl;
    
    //Расширение: метод get_cipher_by_char меняем на свой/
    //get_cipher_by_char_old=ssl->method->get_cipher_by_char;
    //ssl->method->get_cipher_by_char = get_cipher_by_char_new;
       
      if (conn->ssl_sess)
      {
        if (conn->ssl_sess->not_resumable)//на всякий случай
        {
          conn->ssl_sess->references = 0;
          SSL_SESSION_free(conn->ssl_sess);
          conn->ssl_sess = NULL;
        }
        else
        {     
          conn->ssl_sess->references = 2;//если 1я-сессия удаляется.Хз почему...
          SSL_set_session(ssl, conn->ssl_sess);
        }
      }
    
    SSL_set_fd(ssl, sock);
    
    ssl->rbio->method->bread = bread;
    ssl->rbio->method->bwrite = bwrite;    
  }
  
  conn->ssl_state = SSL_connect(conn->ssl);
  
  if (conn->ssl_state == -1)//error
  {
    end_ssl(conn);
    
    sock_error_handler(ERROR_SSL_CONNECTION);
#ifdef DEBUG    
    sprintf(logmsg, "SSL_connect Error!");
    SMART_REDRAW();
#endif
  }
  
#ifdef DEBUG  
  if (conn->ssl_state == 1)//ok
    sprintf(logmsg,"SSL_connect Ok!");
#endif
  return conn->ssl_state;
}

//******************************************************************************
void ssl_socket_msg_handler(GBS_MSG* msg)
{
  CONNDATA *conn;
  
  switch((int)msg->data0)
  {
//------------------------------------------------------------------------------    
  case LMAN_DISCONNECT_IND:
    is_gprs_online=0;
    sock_error_handler(GPRS_OFFLINE);
    
#ifdef DEBUG      
    sprintf(logmsg,"GPRS offline...");
    SMART_REDRAW();
#endif    
    return;
//------------------------------------------------------------------------------  
  case LMAN_CONNECT_CNF:
    //start_vibra(VIBR_ON_CONNECT);
    is_gprs_online=1;
    sock_error_handler(GPRS_ONLINE);
      if (!disautorecconect)
      {
#ifdef DEBUG          
        sprintf(logmsg,"GPRS online");
        SMART_REDRAW();
#endif
        reconnect();
      }
    break; 
//------------------------------------------------------------------------------  
  case ENIP_DNR_HOST_BY_NAME:
    
    conn=CONNDATA_findByDNR((int)msg->data1);
    
    if (conn && conn->DNR_TRIES)
      connect_socket(NULL);
    
    return;
  }
//------------------------------------------------------------------------------

  if (conn=CONNDATA_findBySock((int)msg->data1))//если наш сокет
  {
    switch((int)msg->data0)
    {
    case ENIP_SOCK_CONNECTED:
      conn->sock_state=1;
      ssl_connect(conn->sock);       
      GBS_StartTimerProc(&conn->tmr_connect, 216* 30 , tmr_connect_timeout_handler);
      break;
//------------------------------------------------------------------------------
    case ENIP_SOCK_DATA_READ:
      
        if (conn->ssl_state == 0)//если в процессе хэндшейка
        {
          ssl_connect(0);//повторно вызываем 
          
          if (conn->ssl_state == 1)//SSL соединение установлено
          {
            GBS_DelTimer(&conn->tmr_connect);
            ssl_send_answer(0, 0, 0, 0);//возобновляем передачу данных
          }
          return;
        }
      
      if (conn->ssl_state == 1 && conn->recv_mode == 1 )////если посылали send
      {
        if (ssl_get_answer(conn) > 0)//если есть данные
          {
            if (sock_data_read_handler(conn))//все данные получены
            {
              conn->recv_mode = 0;
              GBS_DelTimer(&conn->tmr_read);
#ifdef DEBUG
             // sprintf(logmsg,"SSL_Read OK");
             // SMART_REDRAW();
#endif
            return;
            }
            GBS_DelTimer(&conn->tmr_read);
            GBS_StartTimerProc(&conn->tmr_read, 216* 30 , tmr_read_timeout_handler);
          }
      }
      break;
//------------------------------------------------------------------------------
    case ENIP_BUFFER_FREE://Досылаем очередь
    case ENIP_BUFFER_FREE1:     
      //ssl_send_answer(0, 0, 0); 
#ifdef DEBUG
      ShowMSG(1, (int)"buffer free!!!");
      sprintf(logmsg,"ENIP_BUFFER_FREE");
      SMART_REDRAW();
#endif
      break;
//------------------------------------------------------------------------------
    case ENIP_SOCK_REMOTE_CLOSED://Закрыт со стороны сервера
#ifdef DEBUG
      sprintf(logmsg,"Сервер %s закрыл соед.", conn->hostname);
      SMART_REDRAW();
#endif
      GBS_DelTimer(&conn->tmr_read); 
      sock_remote_closed_handler(conn->sock);
      end_ssl(conn);
      break;
//------------------------------------------------------------------------------
    case ENIP_SOCK_CLOSED:
      //Закрыт вызовом closesocket
      //sprintf(logmsg,"Соединение закрыто вызовом closesocket");
      break;
    }
  }
}

