//$PROJ_DIR$\Send_S75.cmd $TARGET_PATH$
#include <siemens\swilib.h>
#include "conf_loader.h"
#include "string_util.h"
#include <siemens/xtask_ipc.h>
#include "anim_widget.h"
#include "dyn_images.h"
#include "dyn_theme.h"

#include "buffer.h"
#include "socket_work.h"
#include "ssl_work.h"
#include "cookie.h"
#include "http.h"
#include "main.h"
#include "vk_api.h"
#include "auth.h"
#include "process.h"
#include "parser_error.h"
#include "parser_wall.h"

static const char percent_t[]="%t";
static const char t_jpg[]="jpg";
static const char t_png[]="png";

extern const unsigned int RECONNECT_TIME;
extern int CreateMainMenu();
extern int CreateLoginDialog();
extern void RefreshDialogsMenu();
extern void RefreshGroupsMenu();

static int auth_state = 0;
static int ena_statistic=0;

static GBSTMR tmr_check_new_msg;

//IPC
const char ipc_my_name[]=IPC_VK_NAME;
const char ipc_xtask_name[]=IPC_XTASK_NAME;
IPC_REQ ipc;
static const int minus11=-11;

int maincsm_id;
MAIN_CSM* csm;

extern VkPost* post;
extern const char APP_DIR[];
extern char logmsg[];
extern void SMART_REDRAW();

//******************************************************************************

void tmr_check_new_msg_handler()
{
  if (ena_statistic == 0)
  {
    INET_PROCESS = ENABLE_STATISTIC; 
    SUBPROC((void *)HttpSendReq, url_stats_track_visitor());    
  }
      
  if (INET_PROCESS == 0)
  {
    if (lp_ts == 0)
    {
      INET_PROCESS = GET_LONG_POOL_SERVER;
      SUBPROC((void *)HttpSendReq, url_messages_getLongPollServer(1, 0));//params: (bool need_pts, int group_id)
    }
    else
    {
      INET_PROCESS = CHECK_NEW_MESSAGES; 
      SUBPROC((void *)HttpSendReq, url_messages_getLongPollHistory(""));
    }
  }
  
  GBS_StartTimerProc(&tmr_check_new_msg, 216*RECONNECT_TIME, tmr_check_new_msg_handler);  
}

//******************************************************************************
//by KreN 27.09.2007
//============================ воспроизведение звука ===========================
extern const int soundEnabled;
extern const int sndVolume;

int Play(const char *fname)
{
  if (!IsCalling() && soundEnabled)
  {
    FSTATS fstats;
    unsigned int err;
    if (GetFileStats(fname,&fstats,&err)!=-1)
    {
      PLAYFILE_OPT _sfo1;
      WSHDR* sndPath=AllocWS(128);
      WSHDR* sndFName=AllocWS(128);
      char s[128];
      const char *p=strrchr(fname,'\\')+1;
      str_2ws(sndFName,p,128);
      strncpy(s,fname,p-fname);
      s[p-fname]='\0';
      str_2ws(sndPath,s,128);

      zeromem(&_sfo1,sizeof(PLAYFILE_OPT));
      _sfo1.repeat_num=1;
      _sfo1.time_between_play=0;
      _sfo1.play_first=0;
      _sfo1.volume=sndVolume;
#ifdef NEWSGOLD
      _sfo1.unk6=1;
      _sfo1.unk7=1;
      _sfo1.unk9=2;
      PlayFile(0x10, sndPath, sndFName, GBS_GetCurCepid(), MSG_PLAYFILE_REPORT, &_sfo1);
#else
#ifdef X75
      _sfo1.unk4=0x80000000;
      _sfo1.unk5=1;
      PlayFile(0xC, sndPath, sndFName, 0,GBS_GetCurCepid(), MSG_PLAYFILE_REPORT, &_sfo1);
#else
      _sfo1.unk5=1;
      PlayFile(0xC, sndPath, sndFName, GBS_GetCurCepid(), MSG_PLAYFILE_REPORT, &_sfo1);
#endif
#endif
      FreeWS(sndPath);
      FreeWS(sndFName);
      return 1;
    }else return 0;
  }else return 2; 
}

//******************************************************************************

void LoadUserPhoto()
{//Obs функции с асинхронным выполнением из SUBPROC работать не будут
  char fname[128];
  FSTATS stat;
  unsigned  err;
  LIST_HEAD *iter;

  if (csm->list == 0)
    return;
 
  list_for_each(iter, csm->list)
  {
    VkUser *entry = NULL;
    
    if (csm->list == &dialogs)
    {
      VkDialog *dialog = list_entry(iter, VkDialog, list);
      if (dialog->user)
        entry = dialog->user;
      else
        if (dialog->group)
          entry =(VkUser*) dialog->group;//структуры совместимы-все продумано;)
    }
    
    if (entry && entry->has_photo && entry->photo_50_img == 0 && entry->deactivated == 0)
    {
    //ищем в папке cache 
    const char *ext = strstr(entry->photo_50, ".png") ? "png" : "jpg";
    snprintf(fname, 127, "%scache\\%d.%s", APP_DIR, entry->id, ext);
    
    if (GetFileStats(fname, &stat, &err) != -1)
    {
#ifdef ELKA
      csm->obj = CreateIMGHDRFromFileAsync(fname, 0x8072, 50, 50);
#else
      csm->obj = CreateIMGHDRFromFileAsync(fname, 0x8072, 32, 32);
#endif
      csm->user = entry;
      return;
    }
    }
  }
  csm->list = 0;
}


static void SaveDialogs(char *data, int len)
{
  char fname[256];
  int f;
  unsigned  err;
   
  snprintf(fname, 255, "%sdialogs.json", APP_DIR);
  if ((f=fopen(fname, A_ReadWrite+A_Create+A_Truncate+A_BIN, P_WRITE+P_READ, &err))!=-1)
  {
    fwrite(f, data, len, &err);
    fclose(f, &err);
  }
}

static void SaveGroups(char *data, int len)
{
  char fname[256];
  int f;
  unsigned  err;
   
  snprintf(fname, 255, "%sgroups.json", APP_DIR);
  if ((f=fopen(fname, A_ReadWrite+A_Create+A_Truncate+A_BIN, P_WRITE+P_READ, &err))!=-1)
  {
    fwrite(f, data, len, &err);
    fclose(f, &err);
  }
}

void LoadSavedDialogs()
{
  FSTATS stat;
  int f;
  int fsize = 0;
  unsigned  err;
  char *data = NULL;
  char path[128];

  if (!list_empty(&dialogs))//
    return;
  
  snprintf(path, 127, "%sdialogs.json", APP_DIR);
  GetFileStats(path, &stat, &err);
  
  if ((fsize = stat.size) > 0)
  {
    if ((f=fopen(path, A_ReadOnly+A_BIN, P_READ, &err))!= -1)
    {
      data = malloc(fsize);
      fread(f, data, fsize, &err);
      fclose(f, &err);
    }
  }
  if (data)
  {
    int count;
    parse_answer_messages_getConversations(data, &count);
    mfree(data);
    AnimWidget_Close();
    RefreshDialogsMenu();
  }
}

void LoadSavedGroups()
{
  FSTATS stat;
  int f;
  int fsize = 0;
  unsigned  err;
  char *data = NULL;
  char path[128];

  if (!list_empty(&my_groups))//
    return;
  
  snprintf(path, 127, "%sgroups.json", APP_DIR);
  GetFileStats(path, &stat, &err);
  
  if ((fsize = stat.size) > 0)
  {
    if ((f=fopen(path, A_ReadOnly+A_BIN, P_READ, &err))!= -1)
    {
      data = malloc(fsize);
      fread(f, data, fsize, &err);
      fclose(f, &err);
    }
  }
  if (data)
  {
    int count;
    parse_answer_groups_get(data,&count);
    mfree(data);
    RefreshGroupsMenu();
  }
  AnimWidget_Close();
}

static void save_token()
{
  char fname[256];
  int f;
  unsigned  err;
   
  snprintf(fname, 255, "%stoken", APP_DIR);
  if ((f=fopen(fname, A_ReadWrite+A_Create+A_Truncate+A_BIN, P_WRITE+P_READ, &err))!=-1)
  {
    fwrite(f, ACCESS_TOKEN, strlen(ACCESS_TOKEN), &err);
    fclose(f, &err);
  }
}

static void del_token()
{
  char fname[256];
  int f;
  unsigned  err;
  
  ACCESS_TOKEN[0] = '\0';
  snprintf(fname, 255, "%stoken", APP_DIR);
  if ((f=fopen(fname, A_ReadWrite+A_Truncate+A_BIN, P_WRITE+P_READ, &err)) != -1)//чистим содержимое файла
    fclose(f, &err);
  //unlink(fname, &err); //или удаляем файл
}

void Logout()
{
  auth_state = 0;
  INET_PROCESS= 0;
  GBS_DelTimer(&tmr_check_new_msg);
  del_token();
  end_ssl_work();//закрываем все соед-я
  if (!IsGuiOnTop(csm->maingui_id))//закрываем текущий гуи,если он не главный
    GeneralFuncF1(1);
  GeneralFunc_flag1(csm->maingui_id, 1);//закрываем главное меню
  csm->maingui_id = CreateLoginDialog();//открываем диалог логина
}

static void DoError(int err)
{
  if (err == 5)//ошибка авторизации
    Logout();    
//  else if (err == 14)//ned_captcha
//  {
//    
//  }
  else if (err == -1)//cJSON parse error
  {
      INET_PROCESS=0;
      ShowMSG(1, (int)"cJSON parse error");
    }
  else
  {
    INET_PROCESS = 0;
    sprintf(logmsg, "Error=%d", err);
    ShowMSG(1, (int)error_msg);
  }
}

extern void set_DialogsCount(int count);
extern void set_GroupsCount(int count);
extern int get_DialogsCount();
extern int get_GroupsCount();

static void MainProcess(char *data)
{
  WSHDR ws;
  unsigned short wsbody[128];
  
  int f;
  FSTATS stat;
  unsigned  err;
  
  char* ext;
  char fname[128];
  
  int count = 0;
  
  switch (INET_PROCESS)
  {
#ifdef DEBUG     
  case TEST_SSL_CON:  
    sprintf(logmsg, "TEST_SSL_CON ok!");
    SMART_REDRAW();     
    INET_PROCESS = 0;
    break;
#endif    
//-------------------------------- AUTH_DIRECT ---------------------------------    
  case AUTH_DIRECT:
    
    err = parse_answer_auth_direct();
    
    AnimWidget_Close();
    
    if (err) {
      DoError(err); return;
    }
    
    save_token();//Токен получен! Сохраняем в файл.
#ifdef DEBUG   
    sprintf(logmsg, "Token readed!");
    SMART_REDRAW();
#endif    
    end_ssl_work();//Закрываем все соед-я
    Cookies_SaveAndFree();//Куки не нужны???;
    if (!IsGuiOnTop(csm->maingui_id))
      GeneralFuncF1(1);//если вдруг открыт debug_gui
    GeneralFunc_flag1(csm->maingui_id, 1);//закрываем диалог логина
    csm->maingui_id = CreateMainMenu();
    INET_PROCESS = 0;
    break;
//---------------------------  ENABLE_STATISTIC --------------------------------     
  case ENABLE_STATISTIC:
    ena_statistic = 1;
    INET_PROCESS = 0;
    //tmr_check_new_msg_handler();
    break;
    
//--------------------------- GET_LONG_POOL_SERVER------------------------------    
  case GET_LONG_POOL_SERVER:
    
    parse_answer_messages_getLongPollServer(&err);
    
    if (err) {
      DoError(err); return;
    }
    
    INET_PROCESS = 0;
    tmr_check_new_msg_handler();
    break;
    
//----------------------------- LOAD_DIALOGS -----------------------------------  
  case LOAD_DIALOGS:

      if (get_DialogsCount() == 0)
      {
        SaveDialogs(recv_buf+HTTP_HEADER_LENGTH, HTTP_CONTENT_LENGTH);//Для отладки
        LockSched();
        del_Dialogs();
        RefreshDialogsMenu();
        UnlockSched();
      } 
      
      err = parse_answer_messages_getConversations(recv_buf+HTTP_HEADER_LENGTH, &count);
      set_DialogsCount(count);
    
    AnimWidget_Close();
    
    if (err) {
      DoError(err); return;
    }
    
    RefreshDialogsMenu();
    
/*    
    if (total_unread_messages > prev_unread_messages)
    {
      snprintf(fname, 127, "%ssounds\\message.wav", APP_DIR);
      Play(fname);
    }

    char* ids = create_noninfo_users_ids(&dialogs);//создаем список id у которых нет инфы
    
    if (ids)
    {
      process=LOAD_USERS_INFO;
      SUBPROC((void*)HttpSendReq, users_get(id_list, "photo_50"));
      mfree((void*)ids);
      return;
    }
    
   //если в списке есть сообщение от группы
    id_list=create_noninfo_groups_ids(csm->dialogs_list);
    
    if (id_list)
    {
      process=LOAD_GROUPS_INFO;
      SUBPROC((void*)HttpSendReq, groups_getById(id_list, "photo_50"));
      mfree((void*)id_list);
      return;
    }
 */   
    //на всех есть инфа
    INET_PROCESS = 0;
    //GBS_StartTimerProc(&tmr_check_new_msg, 216*RECONNECT_TIME, tmr_check_new_msg_handler);      
    break;
//----------------------------- LOAD_USERS_INFO --------------------------------   

/*  case LOAD_USERS_INFO:
    
    err = parse_answer_users_get(recv_buf+HTTP_HEADER_LENGTH, &csm->dialogs_list);
    
    if (err) {
      checkError(err); return;
    }
    
    RefreshDialogsMenu();
    RecountFriendsMenu();
    
    id_list=create_noninfo_groups_ids(csm->dialogs_list);
    //если в списке есть сообщение от группы
    if (id_list)
    {
      process=LOAD_GROUPS_INFO;
      SUBPROC((void*)HttpSendReq, groups_getById(id_list, "photo_50"));
      mfree((void*)id_list);
      return;
    }
    //ищем авки в кэше
    process=LOAD_USERS_PHOTO;
    csm->cl=csm->dialogs_list;
    csm->c=csm->cl;    
    goto load_users_photo;

//----------------------------- LOAD_GROUPS_INFO -------------------------------- 
  case LOAD_GROUPS_INFO:  
   
    err=parse_answer_groups_get(&csm->dialogs_list);
    
    if (err) {
      checkError(err); return;
    }
    
    RefreshDialogsMenu();    
    
    process=LOAD_USERS_PHOTO;
    csm->cl=csm->dialogs_list;
    csm->c=csm->cl;
    
//------------------------------ LOAD_USERS_PHOTO-------------------------------  
  case LOAD_USERS_PHOTO:
load_users_photo:  
    //сначало ищем в кэше
    while (csm->c)
    {
      if (csm->c->photo==NULL)
      {
        ext="jpg";
        if (strstr(csm->c->photo_url, ".png"))
          ext="png";
        
        snprintf(fname, 127, "%scache\\%d.%s", APP_DIR, csm->c->user_id, ext);
        if (GetFileStats(fname, &stat, &err) != -1)
        {
#ifdef ELKA
          csm->obj=CreateIMGHDRFromFileAsync(fname, 0x8072, 50, 50);
#else
          csm->obj=CreateIMGHDRFromFileAsync(fname, 0x8072, 32, 32);
#endif
          return;
        }
      }
      csm->c=csm->c->next;
    }
    process=0;
    break;
 
  case LOAD_USERS_PHOTO_FROM_INET:    
    
    while (csm->c)
    {
      if (csm->c->photo==NULL && csm->c->photo_url  && csm->c->flag_load_photo)
      {
        if (strcmp(csm->c->photo_url, HTTP_URL)==0)//если заказывали загрузку в интернете
        {
          if (strstr(HTTP_CONTENT_TYPE, "image/"))
          {
            CreateLocalWS(&ws, wsbody, 127);
            ext="jpg";
            if (strstr(HTTP_CONTENT_TYPE, "image/png"))
              ext="png";
            wsprintf(&ws, ext);
            snprintf(fname, 127, "%scache\\%d.%s", APP_DIR, csm->c->user_id, ext);
            
            if((f=fopen(fname, A_ReadWrite+A_Create+A_Truncate+A_BIN, P_WRITE+P_READ, &err))!=-1)
            {
              fwrite(f, recv_buf+HTTP_HEADER_LENGTH, HTTP_CONTENT_LENGTH, &err);
              fclose(f, &err);
            }
            
            csm->obj=CreateIMGHDRFromMemoryAsync(GetExtUid_ws(&ws), recv_buf+HTTP_HEADER_LENGTH, HTTP_CONTENT_LENGTH, 0x8072);
            return;
          }
        }
        else//заказываем авку
        {
          SUBPROC((void*)HttpSendReq, csm->c->photo_url);
          return;
        }
      }
      csm->c=csm->c->next;
    }
    //все аватарки загружены
    process=0;
    break;
    
//---------------------------- CHECK_NEW_MESSAGES ------------------------------
   
  case CHECK_NEW_MESSAGES:
    
    prev_unread_messages=total_unread_messages;
    prev_dialogs_count=CLIST_GetCount(csm->dialogs_list);
    
    err = parse_answer_messages_getLongPollHistory(&count);//errors 10-ts устарел, 907,908-pts надо обновить
    
    if (err == 10 || 907 || 908)
    {
      process = GET_LONG_POOL_SERVER;
      SUBPROC((void *)HttpSendReq, messages_getLongPollServer(1, 0));//params: (bool need_pts, int group_id)
      return;
    }
    
    if (err) {
      checkError(err); return;
    }
    
    if (count)//(total_unread_messages > prev_unread_messages)
    { 
      //юзается для обновлнения меню
      RefreshDialogsMenu();
      RecountFriendsMenu();
      
      if (IsGuiOnTop(csm->chat_gui_id))//открыт чат
      { 
        if (csm->chat_c->msglist==NULL)//значит чат открыт из списка друзей
          csm->chat_c=csm->dialogs_list;
        
        if (out)//получили отправиленное сообщение
        {
          snprintf(fname, 127, "%ssounds\\bb3.wav", APP_DIR);
          Play(fname);
        }
        CreateChat(csm->chat_c);
      }
      
      if (out==0)
      {
        snprintf(fname, 127, "%ssounds\\bb2.wav", APP_DIR);
        Play(fname);
      }
      
      if (CLIST_GetCount(csm->dialogs_list) > prev_dialogs_count)//если в списке появился новый контакт
      {
        RefreshDialogsMenu();
        
        process=LOAD_USERS_INFO;//запускаем процесс получения инфы о контакте
        csm->c=csm->dialogs_list;
        id_list=create_noninfo_users_ids(csm->dialogs_list);
        if (id_list)
        {
          SUBPROC((void*)HttpSendReq, users_get(id_list, "photo_50"));
          mfree((void*)id_list);
          return;
        }
      }
    }
    process=0;
    break;

//------------------------------------------------------------------------------
  case LOAD_HISTORY:

    err=parse_answer_messages_getHistory(&count);
    
    if (err) {
      checkError(err); return;
    }
    
    if (IsGuiOnTop(csm->chat_gui_id))
      CreateChat(csm->chat_c);

    process=0;
    break;
//------------------------------------------------------------------------------    
  case  DELETE_DIALOG:
    
    err=parse_answer_messages_deleteDialog(&user_id);
        
    if (err) {
      checkError(err); return;
    }
    
    c=FindContactById(csm->dialogs_list, user_id);
    if (c)
      FreeMSGLIST(c);//удаляем все сообщения
    
    if (IsGuiOnTop(csm->chat_gui_id))
      CreateChat(csm->chat_c);
    else
    {
      if (c)
        DeleteContact(&csm->dialogs_list, user_id);
      
      RefreshDialogsMenu();
    }
    
    process=0;
    break;
//------------------------------------------------------------------------------    
  case LOAD_FRIENDS:
    
    err=parse_answer_friends_get();
    
    if (err) {
      checkError(err); return;
    }
    
    AnimWidget_Close();
    RecountFriendsMenu();

    process=LOAD_USERS_PHOTO;
    csm->cl=csm->friends_list;
    csm->c=csm->cl;
    MainProcess();
    break;
    */
//------------------------------- LOAD_GROUPS ---------------------------------- 
  case LOAD_GROUPS:  

    if (get_GroupsCount() == 0)
      {
        SaveGroups(recv_buf+HTTP_HEADER_LENGTH, HTTP_CONTENT_LENGTH);
        LockSched();
        RefreshGroupsMenu();
        UnlockSched();
      } 
    
    err=parse_answer_groups_get(recv_buf+HTTP_HEADER_LENGTH, &count);//count вернет кол-во групп пользователя
    set_GroupsCount(count);
    
    AnimWidget_Close();
     
    if (err) {
      DoError(err); return;
    }
    
    RefreshGroupsMenu();   
    INET_PROCESS = 0;
    
    //ищем авки в кэше
    //process=LOAD_USERS_PHOTO;
    //csm->cl=csm->groups_list;
    //csm->c=csm->cl;    
    //goto load_users_photo;  
    break;
 //-----------------------------------------------------------------------------   
  case LOAD_WALL:
      
    post=parse_answer_wall_get(recv_buf+HTTP_HEADER_LENGTH, &err);

    AnimWidget_Close();
    
    if (err) {
      DoError(err); return;
    }

    INET_PROCESS = 0;
    
    extern void Wall_Refresh();
    
    if(post)
      Wall_Refresh();
    else
      ShowMSG(1,(int)"jSON psrser error!");

    break;
//------------------------------------------------------------------------------     
    case DOWNLOAD_ATTACH_PHOTO:
      INET_PROCESS = 0;
      AnimWidget_Close();
      if (strstr(HTTP_CONTENT_TYPE, "image/"))
      {
        ext=(char*)t_jpg;
        if (strstr(HTTP_CONTENT_TYPE, "image/png"))
          ext=(char*)t_png;

        snprintf(fname, 127, "%scache\\attachment.%s", APP_DIR, ext);
        
        if((f=fopen(fname, A_ReadWrite+A_Create+A_Truncate+A_BIN, P_WRITE+P_READ, &err))!=-1)
        {
          fwrite(f, recv_buf+HTTP_HEADER_LENGTH, HTTP_CONTENT_LENGTH, &err);
          fclose(f, &err);
        }
        
        CreateLocalWS(&ws, wsbody, 127);
        wsprintf(&ws, fname);
        ExecuteFile (&ws, 0, 0); 
      }
      break;
    
  }

}

static void maincsm_oncreate(CSM_RAM *data)
{
  csm=(MAIN_CSM*)data;
  ipc.name_to=ipc_my_name;
  ipc.name_from=ipc_my_name;
  ipc.data=(void *)-1;
  GBS_SendMessage(MMI_CEPID, MSG_IPC, IPC_CHECK_DOUBLERUN, &ipc);
}

extern void kill_data(void *p, void (*func_p)(void *));
#pragma segment="ELFBEGIN"
void ElfKiller(void)
{
  kill_data(__segment_begin("ELFBEGIN"),(void (*)(void *))mfree_adr());
}

//******************************************************************************

static void maincsm_onclose(CSM_RAM *data)
{
  AnimWidget_Close();
  GBS_DelTimer(&tmr_check_new_msg);
  end_socket_work();
  end_ssl_work();
  del_Dialogs();  
  del_Profiles();
  del_Groups();
  //del_Friends();
  //SUBPROC((void*)Cookies_Free);
  SUBPROC((void*)Cookies_SaveAndFree);
  SUBPROC((void*)FreeDynTheme);
  SUBPROC((void*)PNGLIST_Free);
  SUBPROC((void*)FreeDynSmiles);
  SUBPROC((void *)ElfKiller);
}

//******************************************************************************

void startApp(CSM_RAM *data)
{
  FSTATS stat;
  int f;
  int fsize=0;
  unsigned  err;
  char path[128];
  
  snprintf(path, 127, "%stoken", APP_DIR);
  GetFileStats(path, &stat, &err);
  
  ACCESS_TOKEN[0] = '\0';
  if ((fsize = stat.size) > 0)
  {
    if ((f=fopen(path, A_ReadOnly+A_BIN, P_READ, &err))!= -1)
    {
      fread(f, ACCESS_TOKEN, fsize, &err);
      ACCESS_TOKEN[fsize] = '\0';
      fclose(f, &err);
    }
  }
  
  LoadDynTheme();
  SUBPROC((void*)LoadImages);
  SUBPROC((void*)LoadSmiles); 
  
  if (strlen(ACCESS_TOKEN))
  {
    auth_state = 1;
    csm->maingui_id = CreateMainMenu();
    INET_PROCESS = 0;
    //GBS_StartTimerProc(&tmr_check_new_msg, 216*RECONNECT_TIME, tmr_check_new_msg_handler);
  }
  else
  {
    auth_state = 0;
    INET_PROCESS = 0;
    csm->maingui_id = CreateLoginDialog();
    //SUBPROC((void*)Cookies_Load);
  }
}

void CheckDoubleRun(CSM_RAM *data)
{
  int csm_id;
  if ((csm_id=(int)(ipc.data))!=-1)
  {
    ipc.name_to=ipc_xtask_name;
    ipc.name_from=ipc_my_name;
    ipc.data=(void *)csm_id;
    GBS_SendMessage(MMI_CEPID,MSG_IPC,IPC_XTASK_SHOW_CSM,&ipc);
    LockSched();
    CloseCSM(maincsm_id);
    UnlockSched();
  }
  else
    startApp(data);
}

//******************************************************************************

static int HandleObsFrameUpdate(HObj obj)
{
  IMGHDR *temp;
  IMGHDR *img;
   
  unsigned err = Obs_Output_GetPictstruct(csm->obj, &temp);
  
  if (err == 0)
  {
    img = malloc(sizeof(IMGHDR));
    img->w = temp->w;
    img->h = temp->h;
    img->bpnum = (char)temp->bpnum;// читаем только один байт
    int len = CalcBitmapSize(temp->w, temp->h,(char)temp->bpnum);
    img->bitmap = malloc(len);
    memcpy(img->bitmap, temp->bitmap, len);
        
    if (img)
    {
      if (csm->user)
      {
        csm->user->photo_50_img = img;
        csm->user = 0;
      }
      
      RefreshDialogsMenu();//надо сделать универсальную функцию...
//        RecountFriendsMenu();
//        RefreshGroupsMenu();
        
           /* int id=0;
            if (IsGuiOnTop(csm->dialogs_menu_gui_id))
              id=csm->dialogs_menu_gui_id;
            else
              if (IsGuiOnTop(csm->friends_menu_gui_id))
                id=csm->friends_menu_gui_id;
            if (id)
            {
              GUI* gui=FindGUIbyId(csm->dialogs_menu_gui_id, 0);
              RefreshMenuItem(gui, GetContactN(csm->cl, csm->c));
            } 
            */
      
    }
  }
  
  Obs_DestroyObject(obj);
  csm->obj = NULL;
/*  
  csm->user = list_entry(csm->user->list.next, VkUser, list);
  ipc.name_to = ipc_my_name;
  ipc.name_from = ipc_my_name;
  ipc.data = 0;
  GBS_SendMessage(MMI_CEPID, MSG_IPC, IPC_RUN_MAIN_PROCESS, &ipc);//продолжаем процесс 
  */
  return (0);
}

static int HandleObsError(HObj obj, int err)
{
  Obs_DestroyObject(csm->obj);
  csm->obj=NULL;
  
  csm->user = list_entry(csm->user->list.next, VkUser, list);
  ipc.name_to = ipc_my_name;
  ipc.name_from = ipc_my_name;
  ipc.data = 0;
  GBS_SendMessage(MMI_CEPID, MSG_IPC, IPC_RUN_MAIN_PROCESS, &ipc); 
  return(0);
}

static OBSevent ObsEventsHandlers[]={
  OBS_EV_FrameUpdate, (void*) HandleObsFrameUpdate,
  OBS_EV_Error, (void*) HandleObsError,
  OBS_EV_EndList, 0
};

//******************************************************************************

static int maincsm_onmessage(CSM_RAM *data, GBS_MSG *msg)
{
  //IPC
    if (msg->msg==MSG_IPC)
    {
      if (msg->submess!=392305998)
      {
        IPC_REQ *ipc_req;
        if ((ipc_req=(IPC_REQ*)msg->data0))
        {
          if (stricmp(ipc_req->name_to,ipc_my_name)==0)
          {
            switch (msg->submess)
            {
            case IPC_CHECK_DOUBLERUN:
	    //Если приняли свое собственное сообщение, значит запускаем чекер
	    if (ipc_req->name_from==ipc_my_name) SUBPROC((void *)CheckDoubleRun, data);
            else ipc_req->data=(void *)maincsm_id;
	    break;
            
            case IPC_RUN_MAIN_PROCESS:
              MainProcess(ipc_req->data);
              break;
            
            case IPC_SHOW_CAPTCHA:
              //csm->maingui_id=CreateLoginDialog();//
              AnimWidget_Close();
              break;
            }
          }
        }
      }
    }
   
  if (msg->msg==MSG_HELPER_TRANSLATOR)
  {
    if (strncmp(HTTP_URL, "https://", 8)==0)
      ssl_socket_msg_handler(msg);
   // else
     // socket_msg_handler(msg);
    return(1);
  }
  
  if ((msg->msg==MSG_GUI_DESTROYED)&&((int)msg->data0==csm->maingui_id))
  {
    csm->csm.state=-3;
  }
//------------------------------------------------------------------------------  
  if (msg->msg==0x8072)//)Obs_Ms
  {
    if (csm->obj && (HObj)msg->data0==csm->obj)
      Obs_TranslateMessageGBS(msg, ObsEventsHandlers);
  }
  else
    if (msg->msg==0x8055)//)Msg for AnimWidget
      AnimWidgetHandler(msg);
    
  if(msg->msg == MSG_RECONFIGURE_REQ) 
  {
    extern const char *successed_config_filename;
    if (stricmp(successed_config_filename,(char *)msg->data0)==0)
    {
      InitConfig();
      ShowMSG(0x11,(int)"VK.ELF:\nконфиг обновлен!");
    }
  }
  
#ifdef EL71  
  if (msg->msg==0x1AB) //SLIDER.Сообщение приходит только для активного CSM
    switch(msg->submess)
    {
    case 3://закрыт    
      break;
    case 4://открыт     
      break;
    case 5://вверх       
      break;
    case 6://вниз
      ipc.name_to=ipc_xtask_name;
      ipc.name_from=ipc_my_name;
      ipc.data=(void*)maincsm_id;
      GBS_SendMessage(MMI_CEPID,MSG_IPC,IPC_XTASK_IDLE,&ipc);
      break;
    }
#endif  
  
  return(1);
}

//******************************************************************************

static int socket_data_read_handler(CONNDATA *conn)
{
  char s[32];
  
  if (HTTP_HEADER_LENGTH == 0 && conn->TOTALRECEIVED)
  {
    if (ParseHeader() == 0)
    {
      sprintf(logmsg, "Получен не HTTP формат");
      SMART_REDRAW();
    }
  }
   
  if (conn->TOTALRECEIVED >= HTTP_HEADER_LENGTH + HTTP_CONTENT_LENGTH)//все данные получены
  {   
    if (HTTP_CONNECTION == 0)
    {
      if (strncmp(HTTP_URL, "https://", 8)==0)
        end_ssl(conn);
      else
        end_socket(conn->sock);
    }
    
    if (HTTP_STATUS == 200 || HTTP_STATUS == 401)
      {
        ipc.name_to = ipc_my_name;
        ipc.name_from = ipc_my_name;
        ipc.data = 0;
        GBS_SendMessage(MMI_CEPID, MSG_IPC, IPC_RUN_MAIN_PROCESS, &ipc);        
      }
    else
    {
      INET_PROCESS = 0;
      sprintf(s, "Bad HTTP status: %d", HTTP_STATUS);
      ShowMSG(1,(int)s);
    }
    
    return (1);
  }
  return (0);
}

//------------------------------------------------------------------------------

static void socket_remote_closed_handler(short sock)
{
    INET_PROCESS=0;
    //повторяем предыдущий запрос
    //if (strncmp(HTTP_URL, "https://", 8)==0)
      //SUBPROC((void*)send_ssl_answer, 0);
    //else
      //SUBPROC((void*)send_answer, 0);
}

//------------------------------------------------------------------------------

static void socket_error_handler(int err)
{
  AnimWidget_Close();
  //send_req2(HTTP_URL, 1);
  switch(err)
  {
  case ERROR_SSL_CONNECTION:
    INET_PROCESS=0;
    break;
    
  case ERROR_SSL_CONNECT_TIMEOUT:
    INET_PROCESS=0;
    break;
    
  case ERROR_WRITE:
    INET_PROCESS=0;
    //ShowMSG(1, (int)"ERROR_WRITE");
    break;
    
  case ERROR_READ_TIMEOUT:
    INET_PROCESS=0;
    ShowMSG(1, (int)"ERROR_READ_TIMEOUT");
    break;  
    
  case CONNECT_FAULT:
    ShowMSG(1, (int)"CONNECT_FAULT");
    break;
    
  case ERROR_CREATE_SOCK:
    ShowMSG(1, (int)"ERROR_CREATE_SOCK");    
    break;
    
  case WAITING_FOR_GPRS_UP:
    //ShowMSG(1, (int)"WAITING_FOR_GPRS_UP"); 
    break;
    
  case GPRS_OFFLINE:
    break;
    
  case GPRS_ONLINE:
    //ShowMSG(1, (int)"GPRS_ONLINE"); 
    break;     
  }
 
}

//******************************************************************************

static unsigned short maincsm_name_body[140];

static const struct
{
  CSM_DESC maincsm;
  WSHDR maincsm_name;
}MAINCSM =
{
  {
  maincsm_onmessage,
  maincsm_oncreate,
#ifdef NEWSGOLD
  0,
  0,
  0,
  0,
#endif
  maincsm_onclose,
  sizeof(MAIN_CSM),
  1,
  &minus11
  },
  {
    maincsm_name_body,
    NAMECSM_MAGIC1,
    NAMECSM_MAGIC2,
    0x0,
    139
  }
};

static void UpdateCSMname(void)
{
  wsprintf((WSHDR *)(&MAINCSM.maincsm_name), percent_t,"Вконтакте");
}

//******************************************************************************

int main(char *exename, char *fname)
{
  MAIN_CSM main_csm;

  socket_work_init((void*)socket_error_handler, (void*)socket_data_read_handler, (void*)socket_remote_closed_handler);
  
  InitConfig();
  zeromem(&main_csm, sizeof(MAIN_CSM));
  LockSched();
  UpdateCSMname();
  maincsm_id=CreateCSM(&MAINCSM.maincsm,&main_csm, 0);
  UnlockSched();

  return 0;
}

//******************************************************************************

//E:\Users\alfinant7\Documents\Siemens\Dev\IAR\VK.ELF_C\Send_S75.cmd
