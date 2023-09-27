#include "socket_work.h"
#include "buffer.h"

#define TMR_SECOND 216
static unsigned int RECONNECT_TIME=3;//сек
int disautorecconect=0;

extern char logmsg[];
extern void SMART_REDRAW();

int (*sock_data_read_handler)(CONNDATA *conn)=NULL;
void (*sock_remote_closed_handler)(short sock)=NULL;
void (*sock_error_handler)(int err)=NULL;

int is_gprs_online=1;

static GBSTMR reconnect_tmr;

//******************************************************************************

void socket_work_init(void* error_handler, void* data_read_handler, void* remote_close_handler)
{
  sock_data_read_handler=(int(*)(CONNDATA*))data_read_handler;
  sock_remote_closed_handler=(void(*)(short))remote_close_handler;
  sock_error_handler=(void(*)(int))error_handler;
}

//******************************************************************************

void end_socket(int sock)
{
  GBS_DelTimer(&reconnect_tmr);

  if (sock !=-1)
  {
    shutdown(sock, 2);
    closesocket(sock);
  }
  
}

void end_socket_work()
{
  GBS_DelTimer(&reconnect_tmr);
  CONNDATA *conn=CONNDATA_getTop();
  if (conn)
    end_socket(conn->sock);
  free_buffers();
}

//******************************************************************************

static void reconnect_tmr_handler()
{
  if (is_gprs_online)
  {
    CONNDATA_getTop()->DNR_TRIES=3;
    SUBPROC((void*)connect_socket, NULL);
  }
}

void reconnect()
{
  GBS_StartTimerProc(&reconnect_tmr,TMR_SECOND*RECONNECT_TIME, reconnect_tmr_handler);
}

//******************************************************************************
void connect_socket(CONNDATA *conn)
{
  static CONNDATA *__conn;
  HOSTENT *hst=NULL;
  SOCK_ADDR sa;
  int err;
  
  if (conn)
  {
    __conn = conn;
    conn->sock_state=0;
  }
   
  GBS_DelTimer(&reconnect_tmr);
  
  if (!IsGPRSEnabled())
  {
#ifdef DEBUG     
    sprintf(logmsg, "Waiting for GPRS up...");
    SMART_REDRAW();
#endif
    is_gprs_online = 0;
    sock_error_handler(WAITING_FOR_GPRS_UP);
    return;
  }
  
  __conn->DNR_ID=0;
  *socklasterr()=0;
  
#ifdef DEBUG   
  sprintf(logmsg, "Connect to: %s Using port: %d", __conn->hostname, __conn->port);
  SMART_REDRAW();
#endif  
  
  //err=gethostbyname(host, &hst, &DNR_ID, 0); //используется в браузере. Если флаг==1, то вернет counter.rambler.ru и err==0xD3, connect не всегда удается с этой функцией
  err=async_gethostbyname(__conn->hostname, &hst, &__conn->DNR_ID);
  if (err)
  {
    if ((err==0xC9)||(err==0xD6))
    {
      if (__conn->DNR_ID)
      {
#ifdef DEBUG         
        strcpy(logmsg, "Wait DNR..");
        SMART_REDRAW();
#endif        
	return; //Ждем готовности DNR
      }
    }
    else
    {
      //snprintf(logmsg,255,"DNR error %d",err);
      //SMART_REDRAW();
      //sendError();
      reconnect();
      return;
    }
  }
 
  if (hst)
  {
    if (hst->h_addr_list)
    {
#ifdef DEBUG      
      strcpy(logmsg,"DNR ok!");
      SMART_REDRAW();
#endif            
      __conn->DNR_TRIES=0;
      sa.ip=**((int**)hst->h_addr_list);
      
      __conn->sock=socket(1,1,0);
      
      if (__conn->sock != -1)
      {       
	sa.family=hst->h_addrtype;//1
	sa.port=htons(__conn->port);
	if (connect(__conn->sock, &sa, sizeof(sa)) != -1)
	{
	  __conn->sock_state = 1;
#ifdef DEBUG          
          snprintf(logmsg,255,"Socket connected");
          SMART_REDRAW();
#endif          
	}
	else
	{
#ifdef DEBUG           
          snprintf(logmsg,255,"Connect fault");
          SMART_REDRAW();
#endif          
	  closesocket(__conn->sock);          
          sock_error_handler(CONNECT_FAULT);
	}
      }
      else
      {
#ifdef DEBUG         
        snprintf(logmsg,255,"Error Create Socket");
        SMART_REDRAW();
#endif        
        sock_error_handler(ERROR_CREATE_SOCK);
      }
    }
  }
  else
  {
    __conn->DNR_TRIES--;
  }
}

//******************************************************************************

void send_answer(const char *url, char *buf, int len, int flag)
{ 
  static int send_q_size;
  CONNDATA *conn=NULL;
  
  if (url)//если первый вызов функции, проверяем наличии сокета для данного хоста
  { 
    free_send_buf();
    send_buf = buf;
    send_buf_len=len;
    send_q_size=len;
    
    conn=CONNDATA_findByURL(url);
    if(conn==NULL)
      conn=CONNDATA_new(url, flag);
 
    if (conn->sock == -1)
    {
      connect_socket(conn);
      return;
    }
  }
  
  if (send_q_size==0)
    send_q_size=send_buf_len;
  
  while ((len = send_q_size) != 0)
  {
    if (len > 0x400)
    len=0x400;
    
    int send_res = send(conn->sock, send_buf+(send_buf_len-send_q_size), len, 0);

    conn->recv_mode = 1;
    
    if (send_res < 0)
    {
      int err = *socklasterr();
      if (err == 0xC9 || err == 0xD6)
      {
	return; //Видимо, надо ждать сообщения ENIP_BUFFER_FREE
      }
      else
      {
        //error send
	return;
      }
    }
    send_q_size-=send_res;
    conn->TOTALSENDED+=send_res;
    ALLTOTALSENDED+=send_res;
    
    if (send_res < len)
    {
      //Передали меньше чем заказывали
#ifdef SOCK_SEND_TIMER
      Top = this;
      GBS_StartTimerProc(&send_tmr, _tmr_second(5), _resend);
#endif
      return; //Ждем сообщения ENIP_BUFFER_FREE1
    }    
  }
  
#ifdef DEBUG  
  sprintf(logmsg,"sock data sended");
  SMART_REDRAW();
#endif  
}

//******************************************************************************

static int get_answer(CONNDATA *conn)
{
  static int recv_size;
  
  if (recv_buf == NULL)
  {
    recv_size = 0;
    conn->TOTALRECEIVED = 0;
    recv_buf = realloc(recv_buf, 4096);
    recv_buf_len = 4096;
  }
  
  int n=recv(conn->sock, recv_buf+recv_size, 4096, 0);
  
  if (n==4096)
  {
    recv_buf = realloc(recv_buf, recv_buf_len + 4096);
    recv_buf_len += 4096;
    conn->TOTALRECEIVED += n;
    ALLTOTALRECEIVED += n;
    return (0);
   }
   
   else if (n >= 0 && n < 4096)//нихера не работает. Конечный размер данных брать из http заголовка.
   {
     conn->recv_mode = 0;//получены все данные
     conn->TOTALRECEIVED += n;
     ALLTOTALRECEIVED += n;
#ifdef DEBUG     
     sprintf(logmsg,"recv ok");
     SMART_REDRAW();
#endif     
     return (1);
   }
   
   if (n < 0)
     sprintf(logmsg,"recv error!");
   
   return (-1);
}

//******************************************************************************

void socket_msg_handler(GBS_MSG *msg)
{
  CONNDATA *conn=NULL;
  
  switch((int)msg->data0)
  {
  case LMAN_DISCONNECT_IND:
    is_gprs_online=0;
    sock_error_handler(GPRS_OFFLINE);
#ifdef DEBUG     
    sprintf(logmsg,"GPRS offline...");
    SMART_REDRAW();
#endif    
    return;
  
  case LMAN_CONNECT_CNF:
    //start_vibra(VIBR_ON_CONNECT);
    sock_error_handler(GPRS_ONLINE);
    is_gprs_online=1;
      if (!disautorecconect)
      {
#ifdef DEBUG         
        sprintf(logmsg,"GPRS online");
        SMART_REDRAW();
#endif        
        reconnect();
      }
      return;
  
  case ENIP_DNR_HOST_BY_NAME:
    
    conn=CONNDATA_findByDNR((int)msg->data1);
    
    if (conn && conn->DNR_TRIES)
      connect_socket(NULL);
    
    return;
  }
  
  if (conn=CONNDATA_findBySock((int)msg->data1))//если наш сокет
  {
    switch((int)msg->data0)
    {
      
    case ENIP_SOCK_CONNECTED:
      
      conn->sock_state = 1;
      conn->recv_mode = 0;
      send_answer(0,0,0,0);//resend 
      break;
    
    case ENIP_SOCK_DATA_READ:
      //Если посылали send
      if (conn->recv_mode == 1)
      {
        if (get_answer(conn) == 1)
          sock_data_read_handler(conn);
      }
      break;
    
    case ENIP_BUFFER_FREE:
    case ENIP_BUFFER_FREE1:
      //Досылаем очередь
      send_answer(0,0,0,0);
#ifdef DEBUG       
      sprintf(logmsg,"ENIP_BUFFER_FREE");
      SMART_REDRAW();
#endif      
      break;

    case ENIP_SOCK_REMOTE_CLOSED:
      //Закрыт со стороны сервера
      conn->recv_mode=0;
      end_socket((int)msg->data1);
#ifdef DEBUG      
      sprintf(logmsg,"Сервер закрыл соед.");
      SMART_REDRAW();
#endif      
      sock_remote_closed_handler((int)msg->data1);
      break;
    
    case ENIP_SOCK_CLOSED:
      //Закрыт вызовом closesocket
      //sprintf(logmsg,"Соединение закрыто вызовом closesocket");
      break;
    }
  }
}

