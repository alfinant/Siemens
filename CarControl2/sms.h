#ifndef SMS_H_
#define SMS_H_

#define   SMS_SIMIF_SM       0x4077
#define   SMS_TLT_SM         0x4073

typedef struct
{
 char data[0xA6];
}TPDU;

typedef struct{ 
  char number[20];
  char time[20];
  char header[20];
  char text[161];  
}SMS;

extern void (*sms_simif_sm)();
extern SMS *UnpackTPDU(TPDU *tpdu);
extern void SetSMSListener(void *handler);
extern void DeleteSMSListener();

#endif /* SMS_H_ */
