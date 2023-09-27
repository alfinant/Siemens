#include "http.h"

#include <siemens\swilib.h>
#include "string_util.h"
#include "cookie.h"
#include "socket_work.h"
#include "ssl_work.h"
#include "buffer.h"
#include "url_utils.h"

static char host[64];

int HTTP_HEADER_LENGTH;

int HTTP_VER_MAJOR;
int HTTP_VER_MINOR;
int HTTP_STATUS;
int HTTP_CONTENT_LENGTH;
int HTTP_CONNECTION;
char HTTP_CONTENT_TYPE[256];
char HTTP_LOCATION[512];
char HTTP_URL[512];

//******************************************************************************

int get_line_len(char *s)
{
  int len=0;
  
  while(!(*s++=='\n'))
    len++;

  return len+1; 
}

int parse_line_HTTP(char *s, int *r)
{
  HTTP_STATUS=0;
  
  if(sscanf(s, "HTTP/%d.%d %d", &HTTP_VER_MAJOR, &HTTP_VER_MINOR, &HTTP_STATUS) != 3)
    return 0;//это не http заголовок
  *r=1;
  return get_line_len(s);
}

int parse_line_SERVER(char *s, int *r)
{
  *r=1;
  return get_line_len(s);
}

int parse_line_DATE(char *s, int *r)
{
  *r=1;
  return get_line_len(s);
}

int parse_line_CONTENT_TYPE(char *s, int *r)
{
  int len;
  
  len=get_line_len(s);
  
  if (s[len-2]=='\r')
    s[len-2]='\0';
  else
    s[len-1]='\0';

  strncpy(HTTP_CONTENT_TYPE, s + 14, 127);
  *r=1;
  return len; 
}

int parse_line_CONTENT_LENGTH(char *s, int *r)
{ 
  int len;
  HTTP_CONTENT_LENGTH=0;
  
  len=get_line_len(s); 
  s+=15;
  HTTP_CONTENT_LENGTH=strtol(s, 0, 10);
  if(HTTP_CONTENT_LENGTH==0xFFFFFFFF)
    return 0;
  *r=1;
  return len;
}

int parse_line_CONNECTION(char *s, int  *r)
{
  int len;
  
  len=get_line_len(s);
  
  if (s[len-2]=='\r')
    s[len-2]='\0';
  else
    s[len-1]='\0';
  
  s+=12;//sizeof("Connection: ");
  
  if(strcmp(s, "keep-alive")==0)
    HTTP_CONNECTION=1;
  else
    HTTP_CONNECTION=0;
  
  *r=1;
  
  return len;
}

int parse_line_X_POWERED_BY(char *s, int *r)
{
  *r=1;
  return get_line_len(s);
}

int parse_line_SET_COOKIE(char *s, int *r)
{
  int len;
  int len2;
  char *s1;
  char c[256];
  char d[64]; 
  
  len=get_line_len(s);
  
  if (sscanf(s, "Set-Cookie: %s", c )==1)
  {
    if ((s1=strstr(s, "domain")))
      sscanf(s1, "domain=%s", d);
    
    len2=strlen(d);
    
    if (d[len2-1]==';')
      d[len2-1]='\0';
         
    Cookies_Add(c, d);
  }
  return len;
}

int parse_line_PRAGMA(char *s, int *r)
{
  *r=1;
  return get_line_len(s); 
}

int parse_line_CACHE_CONTROL(char *s, int *r)
{
  *r=1;
  return get_line_len(s); 
}

int parse_line_X_FRAME_OPTIONS(char *s, int *r)
{
  *r=1;
  return get_line_len(s); 
}

int parse_line_Location(char *s, int *r)
{
  int len;
  
  len=get_line_len(s);
  
  if (s[len-2]=='\r')
    s[len-2]='\0';
  else
    s[len-1]='\0';

  strncpy(HTTP_LOCATION, s + 10, 511);
  
  *r=1;
  
  return len;  
}

int parse_line_RN(char *s, int *r)
{
  *r=1;
  return 0;
}

int parse_line_UNKNOWN(char *s)
{
  return get_line_len(s);
}

  void *response_headers[]=
  {
    0, "HTTP/",           (void*)parse_line_HTTP,
    0, "Server:",         (void*)parse_line_SERVER,
    0, "Date:",           (void*)parse_line_DATE,
    0, "Content-Type:",   (void*)parse_line_CONTENT_TYPE,
    0, "Content-Length:", (void*)parse_line_CONTENT_LENGTH,
    0, "Connection:",     (void*)parse_line_CONNECTION,
    0, "X-Powered-By:",   (void*)parse_line_X_POWERED_BY,
    0, "Set-Cookie:",     (void*)parse_line_SET_COOKIE,
    0, "Pragma:",         (void*)parse_line_PRAGMA,
    0, "Cache-control:",  (void*)parse_line_CACHE_CONTROL,
    0, "X-Frame-Options:",(void*)parse_line_X_FRAME_OPTIONS,
    0, "Location:",       (void*)parse_line_Location,    
    0, "\r\n",            (void*)parse_line_RN,
    0, NULL,              NULL,
};

//******************************************************************************

int parseLine(char *s, void *pointer[])
{
  int (*f)(char *, void *[]);
  
  for(int i=0; pointer[i+1]; i+=3)
  {
    if(pointer[i]==0)
    {
      if(strncmp(s, pointer[i+1], strlen(pointer[i+1]))==0)
      {
        f=(int(*)(char *, void *[]))pointer[i+2];
        return f(s, pointer+i);  
      }
    }
  }
    return
      parse_line_UNKNOWN(s);
}

//******************************************************************************

int ParseHeader()
{
  int len=0;
  int len_line;
  char *buf=recv_buf;
  
  
  HTTP_HEADER_LENGTH=0;
  
  if(!buf)
    return 0;

   // for(int i=0; i < sizeof(response_headers); i+=3)
    //  response_headers[i]=0;
    response_headers[0]=0;
    response_headers[3]=0;
    response_headers[6]=0;
    response_headers[9]=0;
    response_headers[12]=0;
    response_headers[15]=0;
    response_headers[18]=0;
    response_headers[21]=0;
    response_headers[24]=0;
    response_headers[27]=0;
    response_headers[30]=0;
    response_headers[33]=0;
    response_headers[36]=0;
    response_headers[39]=0;
    
  while(len_line=parseLine(buf, response_headers))
  {
    len+=len_line;
    buf+=len_line;
  }
  if(len > 0)
  {
    HTTP_HEADER_LENGTH=len+2;
    //HTTP_CONTENT=recv_buf+HTTP_HEADER_LENGTH;//плохая идея, ибо recv_buf выделяется через realloc
  }
  return HTTP_HEADER_LENGTH;
}

//******************************************************************************

int get_path_from_url(char *dest, const char *source)
{
  char *s1;
  int c;
  int len=0;
  const char *s2=source;
  
  if ((s1=strchr(source, '.')))//by alfinant 10.10.2016
  {
    if (strchr(s1, '/')==0)
    {
      dest[0]='/';
      dest[1]='\0';
      return 1;
    }
  }  
  
  while((s1=strchr(s2, '/')))
  {
    s2=s1;
    if (*(s2+1)!='/') break;
    s2+=2;
  }   
  while((c=*s2++))
  {
    *dest++=c;
    len++;
  }
  *dest=0;
  return (len);   
}

//******************************************************************************

static char* __create_http_req(const char *url, const char *postdata, int *res_len, int flag)
{ 
  char *cookies;
  char path[512];
  char req_buf[4096];
  
  HTTP_HEADER_LENGTH=0;

  get_host_from_url(host, url);
  get_path_from_url(path, url);
  
  strncpy(HTTP_URL, url, 511);
  
  if (postdata)
    snprintf(req_buf, 1023, "POST %s"
                 " HTTP/1.0\r\nHost: %s"
                   "\r\n", path, host);
  else
    snprintf(req_buf, 1023, "GET %s"
                 " HTTP/1.0\r\nHost: %s"
                   "\r\n", path, host);
  
  if (flag)
    strcat(req_buf, "Connection: keep-alive\r\n");
  
  //if(postdata)
   // strcat(req_buf, "Content-Type: application/x-www-form-urlencoded; charset=utf-8\r\n");
  
//куки добавим
  if((cookies=Cookies_GetByHost(host)))
  {
    sprintf(req_buf + strlen(req_buf), "Cookie: %s\r\n", cookies);
    if(cookies)
      mfree(cookies);
  }
  
  if (postdata)
    sprintf(req_buf+strlen(req_buf), "Content-Length: %d\r\n", strlen(postdata));

  sprintf(req_buf+strlen(req_buf), "User-Agent: %s %s;\r\n", Get_Phone_Info(8), Get_Phone_Info(9));
  
  strcat(req_buf, "\r\n");
  
  if (postdata)
    strcat(req_buf, postdata);
  
  int len = strlen(req_buf);
  char *buf = malloc(len);
  memcpy(buf, req_buf, len);
  *res_len = len;
  
  return buf;
}

//******************************************************************************

static void __http_send(const char *url, char *data, int len, int flag)
{
  if (strncmp(url, "https://", 8) == 0)
    ssl_send_answer(url, data, len, flag);
  else
    send_answer(url, data, len, flag);   
}

void HttpSendReq(const char *url, int flag)
{
  int len; 
  char *req = __create_http_req(url, NULL, &len, flag);
  __http_send(url, req, len, flag); 
}

void HttpSendReqPost(const char *url, const char *postdata)
{
  int len;  
  char *req = __create_http_req(url, postdata, &len, NULL);
  __http_send(url, req, len, NULL);
}
