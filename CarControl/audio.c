#include "../inc/swilib.h"


HObj hobj = NULL;
int played = 0;
int duration = 0;
int MSG_Report = 0xB034;


KillObj(){
 if (!hobj) return;
  Obs_DestroyObject(hobj);
  hobj=NULL;
  played = 0;
  duration = 0;
}

int isPlaying()
{
  return played;
}

void Pause()
{
  Obs_Pause (hobj);
  played = 2;
}

void Stop()
{
  Obs_Stop (hobj);
  KillObj();
}

void Resume()
{
  Obs_Resume (hobj);
  played = 1;
}

void SetVolume(int volume)
{
  Obs_Sound_SetVolumeEx (hobj, volume, 1);
}

int obError(HObj hobj,int error)
{
  //ShowMSG(1,(int)"Àâîòõóé!");
  KillObj();
  return 0;
}

int obPrep(HObj hobj,int error)
{
  Obs_Start(hobj);
  return 0;
}

int obDestroy(HObj hobj,int err)
{
  KillObj();
  return 0;
}

int getDuration()
{
  GetPlayObjDuration((void*)hobj, &duration);
  return(duration);
}

int obInfo(HObj hobj,int error){
  return 0;
}

int obResumeCon(HObj hobj,int error)
{
  return 0;
}

int obParam (HObj hobj,int pl, int error)
{
  //if (pl==2)obFrameUpd(hobj);
  if (pl==1)Obs_Resume(hobj);
  return 0;
}

int obSetPause(HObj hobj,int err)
{
  return 0;
}

int obSetStop(HObj hobj,int err)
{
  return 0;
}

int obNext(HObj hobj,int err)
{
  //PlayNext();
  return 0;
}

int obPause (HObj hobj,int pl, int error)
{
  return 0;
}

OBSevent ObsEventsHandlers[]={
  OBS_EV_FrameUpdate,NULL,
  OBS_EV_Error,(void*)obError,
  OBS_EV_GetInfoCon,(void*)obInfo,
  OBS_EV_PauseCon,(void*)obPause,
  OBS_EV_ParamChanged,(void*)obParam,
  OBS_EV_ResumeCon,(void*)obResumeCon,
  OBS_EV_PauseInd,(void*)obSetPause, 
  OBS_EV_StopInd,(void*)obSetStop,
  OBS_EV_LoopUpdate,(void*)obNext,
  OBS_EV_PrepareCon,(void*)obPrep,
  OBS_EV_ConvDestroyed,(void*)obDestroy,
  OBS_EV_EndList,NULL
};

void ParseMsg(GBS_MSG *msg)
{
  Obs_TranslateMessageGBS(msg,ObsEventsHandlers);
}

void getHobj()
{
  char tmp[128];
  sprintf(tmp, "hObj = %04X", hobj);
  ShowMSG(1,(int)tmp);
}

int Play(const char *fname, int vol)
{ 
  unsigned err=0;
  WSHDR ws;
  unsigned short wsbody[256];
  
  KillObj();
  CreateLocalWS(&ws, wsbody, 255);
  str_2ws(&ws, fname, 255);
  int uid = GetExtUidByFileName(&ws);
  hobj=Obs_CreateObject(uid, 0x34, 2, CSM_root()->csm_q->id, 1, 0, &err);
  if(err)
    return err;
  err = Obs_SetInput_File(hobj,0,&ws);
  if(err)
    return err;
  Obs_Sound_SetVolumeEx (hobj, vol, 1);
  Obs_Sound_SetPurpose(hobj,0x16);
  //SetEq(0);
  //setVis();
  return Obs_Prepare(hobj);


}

