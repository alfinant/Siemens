//стандартная авторизация
#include "auth.h"
#include <siemens\swilib.h>
#include "vk_ipc.h"
#include "anim_widget.h"
#include "string_util.h"
#include "dyn_images.h"

#include "socket_work.h"
#include "http.h"
#include "cookie.h"
#include "process.h"

static int auth_mode=AUTH_STD;

static char tmp_url[256];

extern const char ipc_my_name[];
extern IPC_REQ ipc;

extern int CreateAccessDialog(char* url);
extern int CreateLoginDialog(int flag);
extern char logmsg[];
extern const char DIR[];

void AuthFast()
{

  
}


void AuthStd()
{
  extern char action_url[];
  extern char captcha_sid[];
  extern char email[];
  extern char pass[];
  extern int vk_com_parsed;
  
  char fname_token[128];
  int f;
  unsigned  err; 
  
  char *s;
  char post_data[128];
  char captcha_path[128];

  
  WSHDR ws;
  unsigned short wsbody[128];
 
   if (HTTP_STATUS==302)//перенаправление
   {    
     if (strcmp(HTTP_LOCATION, "/")==0)//перенаправление на главную страницу-это и есть признак входа
     {
       if (process==AUTH_SEND_LOGIN_PASS)
       {
         process=OAUTH_AUTHORIZE;
         HttpSendReq("https://oauth.vk.com/authorize?client_id=5582937&display=mobile&scope=offline,status,notifications,messages,friends,wall,group,photos"
                "&redirect_uri=https://oauth.vk.com/blank.html"
                  "&response_type=token&v=5.62");
       }
     }
     else
       HttpSendReq(HTTP_LOCATION);
   }
   else
     if (HTTP_STATUS==200)
     {
       switch(process)
       {
       
       case AUTH_PARSE_M_VK_COM_LOGIN:
       case AUTH_SEND_LOGIN_PASS: 
           
         if ((s=strstr(recv_buf + HTTP_HEADER_LENGTH, "<form method=\"post\"")))
         {
           if((s=strstr(s, "https:")))//начало url
           {
             *strchr(s, '\"')='\0';//конец         
             strcpy(action_url, s);

             if((s=strstr(s+strlen(action_url)+2, "<img id=\"captcha\"")))//проверяем на наличие капчи
             {
               if((s=strstr(s, "src=\"")))
               {
                 s+=5;
                 *strchr(s, '\"')='\0';//конец
                 strcpy(captcha_path, s);
                 
                 if((s=strstr(s+strlen(captcha_path)+2, "value=\"")))
                 {
                   s+=7;
                   *strchr(s, '\"')='\0';//конец
                   strcpy(captcha_sid, s);
                   
                   snprintf(tmp_url, 255, "https://m.vk.com%s", captcha_path);                
                   process=AUTH_LOAD_CAPTCHA;
                   HttpSendReq(tmp_url); //грузим каптчу
                   return;
                 }
               }
             }
             
             vk_com_parsed=1;
             
             if(process==AUTH_PARSE_M_VK_COM_LOGIN)
             {
               process=AUTH_SEND_LOGIN_PASS;
               snprintf(post_data, 127, "email=%s&pass=%s", email, pass);
               HttpSendPostReq(action_url, post_data); 
               return;
             }
             
             AnimWidget_Close();
             ShowMSG(1, (int)"Неверный логин или пароль");
           }
         }
         AnimWidget_Close();
         break;
       
       case AUTH_LOAD_CAPTCHA:
         
         if (stricmp(HTTP_CONTENT_TYPE, "image/jpeg")==0)
         {
           CreateLocalWS(&ws, wsbody, 127);
           wsprintf(&ws, "jpg");
#ifdef ELKA           
           CreateDynImage(130, 50, GetExtUid_ws(&ws), 0, recv_buf+HTTP_HEADER_LENGTH, HTTP_CONTENT_LENGTH);//индех капчи 0
#else
           CreateDynImage(124, 35, GetExtUid_ws(&ws), 0, recv_buf+HTTP_HEADER_LENGTH, HTTP_CONTENT_LENGTH);//ограничим разрешение капчи, иначе можем сломать editcontrol    
#endif           
           ipc.name_to=ipc_my_name;
           ipc.name_from=ipc_my_name;
           ipc.data=0;
           GBS_SendMessage(MMI_CEPID, MSG_IPC, IPC_SHOW_CAPTCHA, &ipc);
         }
         break;
       
       case OAUTH_AUTHORIZE:
         
         if (s=strstr(recv_buf + HTTP_HEADER_LENGTH, "<form method=\"post\""))
         {
           process=0;
           AnimWidget_Close();
           s=strstr(s, "https:");//начало url
           *strchr(s, '\"')='\0';//конец
           CreateAccessDialog(s);
           return;
         }
       
       case OAUTH_GET_TOKEN:
         
         if (s=strstr(HTTP_URL, "error="))
           ShowMSG(1, (int)s+6);
         else
           if (s=strstr(HTTP_URL, "access_token="))
           {
             snprintf(fname_token, 127, "%stoken", DIR);
             if((f=fopen(fname_token, A_ReadWrite+A_Create+A_Truncate+A_BIN, P_WRITE+P_READ, &err))!=-1)
             {
               s+=13;
               *strchr(s, '&')='\0';
               fwrite(f, s, strlen(s), &err);
               fclose(f, &err);
             }
           
             AnimWidget_Close();
             vk_com_parsed=0;
             //ShowMSG(1,(int)"Ключ доступа получен");
             
             ipc.name_to=ipc_my_name;
             ipc.name_from=ipc_my_name;
             ipc.data=s;//token
             GBS_SendMessage(MMI_CEPID, MSG_IPC, IPC_TOKEN_READED, &ipc);            
           }      
         break;
         
       }//switch
       
     }//200
   else
   {
     ShowMSG(1,(int)"ERROR: HTTP UNK STATUS");     
   }
}

void AuthProcess()
{
  if (auth_mode==AUTH_FAST)
    AuthFast();
  else
    if (auth_mode==AUTH_STD)
      AuthStd();
}
