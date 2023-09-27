//Использование в коммерческих целях запрещено.
//Наказание - неминуемый кряк и распространение по всему инет.
//Business application is forbidden.
//Punishment - unavoidable crack and propagation on everything inet.

unit BFC;

interface
uses Windows,SysUtils,Crc16,ComPort;

const
MAXBFCDATA = 1024;

  ERR_NO            =0;
  ERR_X             =-1;
  ERR_BFC_PAR       =-2;
  ERR_BFC_IN_CRC16  =-3;
  ERR_BFC_RD_CMD    =-4;
  ERR_BFC_INIT_HID  =-5;
  ERR_BFC_DATA      =-6;
  ERR_BFC_INFO      =-7;
  ERR_EEP_NONE      =-8;
  ERR_BFC_IO_RS     =-15;

type
// xName = (xS,xD);

 T_DisplayInfo = packed record  // T_DisplayInfo
//   subcom       : BYTE; //=07
   Width        : WORD;
   Height       : WORD;
   ClientId     : BYTE;
 end;

 T_DisplayUpdateInfo = packed record
//   subcom       : BYTE; //=08
   DisplayNum     : BYTE;   // Display Num
   ClientId       : BYTE;   // client id
   XOffset        : WORD;   // horizontal start position
   YOffset        : WORD;   // vertical start position
   Width          : WORD;   // width
   Height         : WORD;   // height
 end;

 E_DisplayDataType = (E_DISP_DONTCARE,E_DISP_1BIT,E_DISP_8BIT_RGB332,E_DISP_12BIT_RGB444,
 E_DISP_16BIT_RGB565,E_DISP_18BIT_RGB666,E_DISP_24BIT_RGB888);
// 03 0084 00B0 0000 0000 00 A844C120 04
 T_DisplayBufferInfo = packed record
    ClientId       : Byte;
    Width          : WORD;
    Height         : WORD;
    XOffset        : WORD;
    YOffset        : WORD;
    unknown        : Byte;
    BufferAddress  : DWORD;
    DataType       : E_DisplayDataType;
 end;

 T_EEP_GetInfo = packed record case byte of
 0:( cmd       : BYTE;
     num       : DWORD; );
 1:( b : array[0..4] of Byte );
 end;

 T_EEP_Read_Block = packed record case byte of
 0:( cmd       : BYTE;
     num       : DWORD;
     off       : DWORD;
     len       : DWORD; );
 1:( b : array[0..12] of Byte );
 end;

 T_EEP_Write_Block = packed record case byte of
 0:( cmd       : BYTE;
     num       : DWORD;
     off       : DWORD;
     data      : array[0..$35] of Byte); //
 1:( b : array[0..$3E] of Byte ); // +9
 end;

 T_EEP_Create_Block = packed record case byte of
 0:( cmd       : BYTE;
     num       : DWORD;
     len       : DWORD;
     ver       : Byte; );
 1:( b : array[0..9] of Byte );
 end;

 t_OTP_BLK = packed record  case byte of
 0:(   cmd : byte;
       num : dword;
       off : dword;
       len : dword;);
 1:(   b : array[0..12] of Byte );
 end;

 T_BCF_data = packed record case byte of
     0: ( pb : array[0..MAXBFCDATA-2] of Byte );
     1: ( pw : array[0..((MAXBFCDATA-2) shr 1)] of Word );
     2: ( pd : array[0..((MAXBFCDATA-2) shr 2)] of Dword );
     3: ( DisplayInfo : T_DisplayInfo );
     4: ( DisplayUpdateInfo : T_DisplayUpdateInfo );
     5: ( DisplayBufferInfo : T_DisplayBufferInfo);
     6: ( EEP_GetInfo : T_EEP_GetInfo );
 end;
 eLightDest=(Display,Keyboard,Dinamiclight); // for BFC_SetLight
{ T_BCF_data = packed record case byte of
     0: ( data : array[0..MAXBFCDATA-1] of Byte );
     1: ( cmddata : T_BCF_indata );
 end; }

// BFC Head
 sbfchead = packed record
   idtx : BYTE; // bfc input Sapi
   idrx : BYTE; // bfc output Sapi
   len  : WORD; // length Motorola (hi,lo)
   tpe  : BYTE; // 0,4,0x20,0x30. if tpe and 0x20 -> CRC16
   chk  : BYTE; // XorCrc = idtx^idrx^len^(len>>8)^type;
 end;
// BFC block
 sbfc = packed record case byte of
   0: (
      head : sbfchead;
      data : array[0..MAXBFCDATA-1] of Byte ;
      size : integer; );
   1: (
      b  : array[0..MAXBFCDATA-1+sizeof(sbfchead)] of byte; );
   2:  (
      headx : sbfchead;
      subcmd : byte;
      cd : T_BCF_data  );
 end;

 sRoutingRec = packed record case byte of
  0: (
  Wired_accessory,  // NONE,CK_COMFORT,CK_PORTABLE,CK_EASY,CK_LINEFIT,CK_PROF_BT,CK_COMFORT_VOICE,HEADSET_MONO,HEADSET_STEREO,TTY_EXT,TTY,HEADSET_FMRADIO,MP3_PLAYER
  BT_accessory,     // NONE,CARKIT_BT,CARKIT_BT_DSP,CARKIT_PROFESSIONAL_BT,HEADSET_BT,HEADSET_BT_R65,HEADSET_BT_STEREO
  Clip_it_accessory,// NONE,CLIPIT_LED,EMO
  Mmi_option,       // STANDARD_HANDSET,ALTERNATE_HANDSET,STANDARD_HANDSFREE,ALTERNATE_HANDSFREE
  Downlink_destination, // NONE,SPEAKER,BT,WIRE,SPEAKER_AND_BT,SPEAKER_AND_WIRE,SPEAKER_AND_BT_AND_WIRE,BT_AND_WIRE
  Downlink_pcm0_source, // NONE,MP3_AAC,TTS,FM_SYNTH_ADPCM,MP3_AAC_AND_FM_SYNTH_ADPCM
  Uplink_source,   // NONE,INT_MIC,EXT_MIC,BT_MIC
  Audio_mode,      // NONE,CALL,VOICE_RECOGNITION,RINGING,DTMF_ONLY,VOICE_MEMO_ONLY
  Voice_memo,      // NONE,RECORD_AMR,RECORD_FR,PLAY_AMR,PLAY_FR
  Logical_analog_source, // NONE,FM_RADIO,SOUND_CHIP
  Mic_mute,        // ON,OFF
  Slider_mode,     // OPEN,CLOSE
  Test_mode,       // NONE,MICROPHONE,SPEAKER,RECEIVER,MICREC
  Volume_speech,   // 0,1,2,3,4
  Volume_player,   // 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14
  Sample_mode_voice,  // VB08,VB16
  Sample_mode_pcm0,   // P08,P11,P12,P16,P22,P24,P32,P44,P48
  Sample_channels_voice, // MONO,BINAURAL
  Sample_channels_pcm0, // MONO,STEREO
  Asp : byte; );       // ON,OFF
  1: ( b  : array[0..19] of byte; );
 end;

var
 hostid:  BYTE = $01;
 oldhost: BYTE = 0;
 obfc : sbfc;
 ibfc : sbfc;
 BFC_Error : integer=0;
 bSecyrMode : Byte=0;
 bTelMode : Byte = $FF;

 sCameraSensor : array[0..14] of pchar =
 ('Unknown',
  'Toshiba TCM8219MD',
  'Agilent ADCM2700',
  'Samsung S5X433CA03',
  'Agilent ADCM1700',
  'Hitachi HAM49002H03',
  'Samsung AU70B',
  'Omnivision OV9640',
  'Renesas M64286E',
  'Omnivision OV9650',
  'Samsung AU70C',
  'Toshiba TCM8240MD',
  'Pixelplus PO2030N',
  'Omnivision OV7660',
  'Samsung AU80B');
 sDisplayController : array[0..63] of pchar =
 ('Unknown',
  'Epson Hitachi HD66728',
  'Hyundai Samsung KS0718',
  'Hyundai Hitachi HD66728',
  'Sharp Rohm BU97979',
  'Philips Epson SED1568',
  'Philips Nec UPD16682a',
  'Hyundai Epson SED1568',
  'Hyundai Samsung KS0724-old',
  'Samsung Samsung KS0724',
  'Philips Philips OM6206-old',
  'Epson Epson SED1568',
  'Epson Epson SED15E0',
  'Hyundai Solomon SSD1812',
  'Sharp Samsung KS0718',
  'Tecdis Emmarin EM6124',
  'Hyundai Radio NJU6578',
  'Optrex HD66740',
  'Hyundai S6B0718',
  'Optrex BU41142',
  'Optrex dialog',
  'Epson SED15E0',
  'Hyundai Samsung KS0724',
  'Epson Epson SED1065',
  'Philips Philips OM6206',
  'Philips Philips OM6206-2',
  'Sharp LH15A1',
  'Hitachi HD66760',
  'Epson S1D15G14',
  'Philips PCF8813',
  'Hyundai D0986EA',
  'Epson BU97865',
  'Philips PCF8813-old',
  'Philips NJU6821',
  'Sharp Hynix HM17CM4101',
  'Hyundai D0986ED',
  'Samsung S6B1400X',
  'Philips Epson S1D15G14',
  'Epson L2F50126T',
  'Sharp Nec PD161691',
  'Sharp Sharp LH15KAH2',
  'Hyundai Samsung S6B33B1X',
  'Epson L2F50250',
  'Hyundai Dialog DA8912A',
  'Sharp Sharp LR38836',
  'Philips Hitachi HD66773R',
  'Wintek STE2020',
  'Epson Rohm BU98232',
  'Sharp Sharp LR38826A',
  'Alps Solomon SSD1286',
  'Philips Philips PCf8882',
  'Byd Solomon SSD1779',
  'Hyundai D0986EF',
  'Sharp Dialog DA8912A',
  'Philips Leadis LDS183',
  'Byd Solomon SSD1783',
  'Byd Solomon SSD1788',
  'Byd Samsung S6B33B2',
  'Sharp Dialog DA8934A',
  'Epson L2F50333T',
  'Philips Philips PCF8882 serial',
  'Alps Solomon SSD1286 serial',
  'Sharp Nec PD161700',
  'Byd Toppoly C1C104'); //63

function ReadBFC: integer;
function BFC_InitHost(hid: byte): integer;
////
function BFC_SendAT(S: String): integer;
function BFC_GetInfo(data: word): integer;
function BFC_ReadOperateAndTalkTime(var Operate,TalkTime: dword) : boolean;
function BFC_GetPhoneModel: pChar;
function BFC_GetLgVer: pChar;
function BFC_GetSoftWareVer: pChar;
function BFC_GetIMEI: pChar;
function BFC_GetDevMan: pChar;
function BFC_PhoneOff: boolean;
function BFC_SwitchFromServiceToNormalMode: boolean;
function BFC_SimSim : boolean;
function BFC_SetLight(LightDest:eLightDest; level:BYTE): boolean;
function BFC_GetCurentMode(var mode: byte): boolean; // Srv,Norm,Charg,Burnin...
function BFC_CurentMode: string;
function BFC_GetHardwareIdentification : integer; // <0 -> Error
function BFC_GetCurentUbat(var Ubat: word): boolean;
function BFC_to_BFB: boolean;  // old x65 Sw < 36
function BFC_PressKeypad(key:byte): boolean;
// Flash, SecurMode
function BFC_GetSecurityMode: string;
function BFC_SecurityMode: boolean;
function BFC_SendSkey(Skey:string; var answer : byte): boolean;
function BFC_CloseSkey: boolean;
function BFC_GetSecurityInfo(var buf: array of word; buf_len: integer): boolean;
function BFC_GetFlashTypes(var buf: array of dword; buf_len: integer): boolean;
function BFC_FreezeSecurityData(sxIMEI: string; var err: word): boolean;
function BFC_GetOtpLockState(var state: word): boolean;
function BFC_FlashManagerLockOtp: boolean;
function BFC_GetEsn(var OTP_ESN: dword): boolean;
function BFC_GetOtpBlockLength(blk_num: byte; var blk_size: dword): boolean;
function BFC_ReadOtpBlk(blk_num: dword; blk_off: dword; blk_len: dword): boolean;
function BFCReadMem(addr, len: dword;var Buf: array of byte): Boolean;
// EEPROM // EEPROM // EEPROM
function BFC_EE_Get_Block_Info(num : dword; var len: dword; var ver: byte): boolean;
function BFC_EE_Read_Block(num,off,len : dword; var buf: array of byte ): boolean;
function BFC_EE_Del_block(num: dword): boolean;
function BFC_EE_Create_Block(num,len,ver: dword) : boolean;
function BFC_EE_Write_Block(num,off,len : dword; var buf: array of byte ): boolean;
function BFC_EE_Finish_Block(num : dword) : boolean;
function BFC_EELITE_Format : boolean;
function BFC_EEFULL_Format : boolean;
function BFC_EELITE_MaxIndexBlk(var num : dword) : boolean;
function BFC_EEFULL_MaxIndexBlk(var num : dword) : boolean;
function BFC_EELITE_GetBufferInfo(var freeb,freea,freed : dword) : boolean;
function BFC_EEFULL_GetBufferInfo(var freeb,freea,freed : dword) : boolean;
// Disks // Disks // Disks
function BFC_Format_Instance_Ready : boolean;
function BFC_Invalidate_Instance(InstName: string): boolean;
// Display // Display // Display
function BFC_GetDisplayCount(var DisplayCount:byte): boolean;
function BFC_GetDisplayType(NumID : byte; var DisplayID : byte): boolean;
function BFC_GenerateDisplayPattern(NumID, number:byte): boolean;
function BFC_SetDisplayContrast(NumID, Contrast:byte): boolean;
function BFC_RestoreDisplay(NumID : byte): boolean;
function BFC_SwitchOffDisplay(NumID : byte): boolean;
function BFC_GetDisplayInformation(NumID : byte; var DisplayInfo : T_DisplayInfo): boolean;
function BFC_GetDisplayBufferInfo(ClientId : byte; var DisplayBufferInfo : T_DisplayBufferInfo): boolean;
// CAMERA // CAMERA // CAMERA
function BFC_ReadCameraId(var id : integer) : boolean;
function BFC_SetCameraParameters(id,data : byte ) : boolean;
function BFC_TakeCameraPicture(Resolution : byte; var size: dword) : boolean;
function BFC_GetCameraBuf(var addr,size : dword ) : boolean;
function BFC_ShutdownCamera : boolean;
// Audio // Audio // Audio // Audio // Audio
function BFC_ActScalAddRouting(iAudi,iAudo: integer) : boolean;
function BFC_AddRoutingReconfigure(var RoutingRec : sRoutingRec) : boolean;
function BFC_ActivateAddRouting : boolean;
function BFC_DeactivateAddRouting : boolean;
function BFC_AddRoutingOff : boolean;
function BFC_CommandDsp(lenbuf : integer; buf : array of byte) : boolean;
// ReadBufDSP?(StartAddress=0xf6001207, Length=24)
////
var
sExit : string;
flgExit : boolean;

implementation

function WriteBFC(bfcnum, bfctype: byte; buf: array of byte; lenbuf: integer): integer;
begin
   if lenbuf > (sizeof(obfc.data)-2) then result:=ERR_BFC_PAR
   else begin
    with obfc.head do begin
     idtx:=bfcnum;
     tpe:=bfctype;
     idrx:=hostid;
     len:=Swap(lenbuf);
     chk:=idtx xor idrx xor Lo(len) xor Hi(len) xor tpe;
    end;
    obfc.size:=lenbuf+sizeof(sbfchead);
    Move(buf,obfc.data,lenbuf);
    if (obfc.head.tpe and $20)<>0 then begin
      WORD(pointer(@obfc.data[lenbuf])^):=Swap(CalkBlkCRC16(@obfc.b,obfc.size));
      inc(obfc.size,2);
    end;
    if not WriteCom(@obfc,obfc.size) then begin
      result:=ERR_BFC_IO_RS;
      exit;
    end;
    result:=ERR_NO;
   end;
end;

function ReadBfc: integer;
var
 i : integer;
 xlen : WORD;
 xchk : BYTE;
begin
  if not ReadCom(@ibfc.b,sizeof(sbfchead)) then begin
    result:=ERR_BFC_IO_RS;
    exit;
  end;
  while true do begin
    xlen:=Swap(ibfc.head.len);
    with ibfc.head do xchk := idtx xor idrx xor Lo(len) xor Hi(len) xor tpe;
    if (ibfc.head.idrx=obfc.head.idtx)
       and (xlen<=MAXBFCDATA)
       and (ibfc.head.chk=xchk)
//       and ((ibfc.tpe and $CB)=0)
       then begin
      ibfc.size:=xlen+sizeof(sbfchead);
      if (ibfc.head.tpe and $20)<>0 then begin
        if (xlen<>0) then begin
          if not ReadCom(@ibfc.data,xlen+2) then begin
            result:=ERR_BFC_IO_RS;
            exit;
          end;
        end;
        if (WORD(pointer(@ibfc.data[xlen])^)<>Swap(CalkBlkCRC16(@ibfc.b,ibfc.size))) then begin
          result:=ERR_BFC_IN_CRC16;
          exit;
        end;
      end
      else if (xlen<>0) then begin
       if not ReadCom(@ibfc.data,xlen) then begin
         result:=ERR_BFC_IO_RS;
         exit;
       end;
      end;
      result:=ERR_NO;
      exit;
    end
    else begin
      if ((ibfc.head.idtx=$ff)
          and(ibfc.head.idrx=$fe)
          and (xlen<=MAXBFCDATA)
          and (ibfc.head.chk=xchk)) then begin
        if (xlen<>0) then begin
          if not ReadCom(@ibfc.data,xlen) then begin
            result:=ERR_BFC_IO_RS;
            exit;
          end;
          ibfc.data[xlen]:=0;
          sExit:=sExit+pchar(@ibfc.data)+#$0D+#$0A;
          flgExit:=True;
        end;
        if not ReadCom(@ibfc.b,sizeof(sbfchead)) then begin
          result:=ERR_BFC_IO_RS;
          exit;
        end
        else continue;
      end;
    end;
    for i:=1 to sizeof(sbfchead) do ibfc.b[i-1]:=ibfc.b[i];
    if not ReadCom(@ibfc.b[sizeof(sbfchead)-1],1) then begin
      result:=ERR_BFC_IO_RS;
      exit;
    end;
  end;
end;

//------------------------------------------------------------------

function BFC_InitHost(hid: byte): integer;
var
 i: integer;
 bb: array [0..1] of byte absolute i;
begin
  i:=$1180;
  Result:=WriteBFC(hid,$04,bb, 2 );
  if Result<>ERR_NO then exit;
  Result:=ReadBfc;
  if Result<>ERR_NO then exit;
  if ibfc.head.len=$200 then begin
   if (ibfc.data[1]=$13) or (ibfc.data[1]=$11) then begin
     oldhost:=hid;
     Result:=ERR_NO;
     exit;
   end;
  end;
  Result:=ERR_BFC_INIT_HID;
end;

//-----------------

function BFC_Funcs20(Hid:Byte; buf: array of byte; lenbuf: integer): integer;
begin
 if oldhost<>Hid then begin
   result:=BFC_InitHost(Hid);
   if result<>ERR_NO then exit;
 end;
 Result:=WriteBFC(Hid,$20,buf,lenbuf);
 if Result<>ERR_NO then exit;
 result:=ReadBFC;
 if Result<>ERR_NO then exit;
 if ibfc.data[0]<>obfc.data[0] then result:=ERR_BFC_DATA;
 if ibfc.head.len=0 then result:=ERR_BFC_DATA;
end;

//-----------------
function BFC_Funcs00(Hid:Byte; buf: array of byte; lenbuf: integer): integer;
begin
 if oldhost<>Hid then begin
   result:=BFC_InitHost(Hid);
   if result<>ERR_NO then exit;
 end;
 Result:=WriteBFC(Hid,$00,buf,lenbuf);
 if Result<>ERR_NO then exit;
 result:=ReadBFC;
 if Result<>ERR_NO then exit;
 if ibfc.data[0]<>obfc.data[0] then result:=ERR_BFC_DATA;
 if ibfc.head.len=0 then result:=ERR_BFC_DATA;
end;
//-----------------

function BFC_GetInfo(data: word): integer;
var
 sz: integer;
begin
 sz:=1;
 if hi(Data)<>0 then Inc(sz);
 Result:=BFC_Funcs20($11,[Lo(Data),Hi(Data)],sz);
 if Swap(ibfc.head.len)<2 then result:=ERR_BFC_INFO;
// BFC_Error:=result;
end;

//-----------------

function BFC_GetPhoneModel: pChar;
begin
  Result:=nil;
  BFC_Error:=BFC_GetInfo($0D);
  if BFC_Error<>ERR_NO then Exit;
  Result:=@ibfc.data[1];
end;

function BFC_GetSoftWareVer: pChar;
begin
  Result:=nil;
  BFC_Error:=BFC_GetInfo($0B);
  if BFC_Error<>ERR_NO then Exit;
  Result:=@ibfc.data[1];
end;

function BFC_GetLgVer: pChar;
begin
  Result:=nil;
  BFC_Error:=BFC_GetInfo($0E);
  if BFC_Error<>ERR_NO then Exit;
  Result:=@ibfc.data[1];
end;

function BFC_GetIMEI: pChar;
begin
  Result:='?';
  BFC_Error:=BFC_GetInfo($05);
  if BFC_Error<>ERR_NO then Exit;
  Result:=@ibfc.data[1];
end;

function BFC_GetDevMan: pChar;
begin
  Result:=nil;
  BFC_Error:=BFC_GetInfo($0C);
  if BFC_Error<>ERR_NO then Exit;
  Result:=@ibfc.data[1];
end;

//-----------------

// SwitchMobileOff 19 01 00 01 20 39 03 CF F5 -> 01 19 00 01 00 19 03
function BFC_PhoneOff: boolean;
begin
  BFC_Error:=BFC_Funcs20($19,[$03],1);
  if BFC_Error<>ERR_NO then result:=False
  else result:=True
end;

// SwitchFromServiceToNormalMode 19 01 00 01 20 39 01 EC E7 -> 01 19 00 01 00 19 01
function BFC_SwitchFromServiceToNormalMode: boolean;
begin
  BFC_Error:=BFC_Funcs20($19,[$01],1);
  if BFC_Error<>ERR_NO then result:=False
  else result:=True
end;
// 1A 01 00 07 20 3C 47 01 AF 01 10 00 00 31 A6
function BFC_SetLight(LightDest:eLightDest; level:BYTE): boolean;
begin
  BFC_Error:=BFC_Funcs20($1A,[$47,Byte(LightDest),$AF,$01,level,0,0],7);
  if BFC_Error<>ERR_NO then result:=False
  else result:=True
end;

function BFC_SimSim : boolean;
begin
  BFC_Error:=BFC_Funcs20($1C,[$01],1);
  if BFC_Error<>ERR_NO then result:=False
  else result:=True
end;


function BFC_SecurityMode: boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($25,[$15,$00,$10,$00],4);
  if BFC_Error<>ERR_NO then exit;
  if((ibfc.data[0]=$15) and (ibfc.data[1]=$01)) then begin
    bSecyrMode:=ibfc.data[2];
    if (ibfc.data[2]=$12) or (ibfc.data[2]=$13) then result:=True; //='FactoryMode';
  end;
end;

function BFC_GetSecurityMode: string;
begin
  result:='Error';
  bSecyrMode:=0;
  BFC_SecurityMode;
  if BFC_Error<>ERR_NO then exit;
  case bSecyrMode of
   $12,$13: result:='FactoryMode';
   $11: result:='RepairMode';
   $10: result:='CustomerMode';
  else result:='UnknownMode('+IntToHex(bSecyrMode,2)+')';
  end;
end;

function BFC_SendAT(S: String): integer;
var
 i: integer;
 Buf: array [0..255] of Byte;
begin
  i:=Length(S);
  if i>255 then begin
    Result:=ERR_BFC_PAR;
    exit;
  end;
  Move(S[1],Buf,i);
  Buf[i]:=0;
  result:=BFC_Funcs20($17,buf,i+1)
end;

//11-01 -> 01 43 01
function BFC_GetHardwareIdentification : integer;
begin
  BFC_Error:=BFC_Funcs20($11,[$01],1);
  if BFC_Error<>ERR_NO then Result:=0
  else Result:=ibfc.cd.pw[0];
end;

// 11 01 00 01 20 31 07 99 FD -> 01 11 00 05 00 15 07 D6 64 A6 00
// 11 01 00 01 20 31 08 61 0A -> 01 11 00 05 00 15 08 98 00 00 00
function BFC_ReadOperateAndTalkTime(var Operate,TalkTime: dword) : boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($11,[$07],1);
  if BFC_Error<>ERR_NO then exit;
  if (ibfc.head.len=$500)then begin
    Operate := ibfc.cd.pd[0];
    BFC_Error:=BFC_Funcs20($11,[$08],1);
    if BFC_Error<>ERR_NO then exit;
    if (ibfc.head.len=$500)then begin
     TalkTime := ibfc.cd.pd[0];
     result:=True;
    end;
  end;
  BFC_Error:=ERR_BFC_DATA;
end;

function BFC_to_BFB: boolean;
begin
  result:=False;
  hostid:=$01;
  BFC_Error:=BFC_InitHost($01);
  if BFC_Error<>ERR_NO then Exit;
  BFC_Error:=WriteBFC($01,$00,[$10],1);
  if BFC_Error<>ERR_NO then Exit;
  ReadBfc;
  if ChangeComSpeed(57600) then begin
    BFC_Error:=ERR_NO;
    result:=True;
  end;
end;


function BFC_CloseSkey: boolean;
begin
  BFC_Error:=BFC_Funcs20($25,[$12,$00],2);
  if BFC_Error<>ERR_NO then result:=False
  else result:=True
end;

function BFC_SendSkey(Skey:string; var answer : byte): boolean;
var
 i: integer;
 Buf: array [0..16] of Byte;
begin
  i:=Length(Skey);
  result:=False;
  if i>15 then begin
    BFC_Error:=ERR_BFC_PAR;
    exit;
  end;
  if not ((Skey[1]<>'D')or(Skey[1]<>'S')or(Skey[1]<>'X')) then begin
    BFC_Error:=ERR_BFC_PAR;
    exit;
  end;
  Move(Skey[1],Buf[1],i);
  Buf[0]:=$11;
  Buf[i+1]:=$00;
  BFC_Error:=BFC_Funcs20($25,Buf,i+2);
  if BFC_Error<>ERR_NO then exit;
  answer:=ibfc.cd.pb[0];
  result:=True
end;
//09 01 00 02 20 2A 03 0C 46 C4
function BFC_PressKeypad(key:byte): boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($09,[$03,key],2);
  if BFC_Error<>ERR_NO then exit;
  result:=True;
end;

// 0x12=NormalMode, 0x16=ServiceMode, 0x07=BurninMode
function BFC_GetCurentMode(var mode: byte): boolean; // Srv,Norm,Charg,Burnin...
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($19,[$02],1);
  bTelMode:=$FF;
  if BFC_Error<>ERR_NO then exit;
  if (ibfc.head.len=$200)then begin
    mode := ibfc.data[1];
//    if ibfc.data[1]=$16 then
    result:=True;
  end
  else begin
   mode := $FE;
   result:=True;
//   BFC_Error:=ERR_BFC_DATA;
  end;
  if result then bTelMode := mode;
end;

function BFC_CurentMode: string;
var
b : byte;
begin
  result:='Error';
  BFC_GetCurentMode(b);
  if BFC_Error<>ERR_NO then exit;
  case b of
   $03: result:='Charge Mode';
   $07: result:='BurnIn Mode';
   $12: result:='Normal Mode';
   $16: result:='Service Mode';
   $FE: result:='Format FFS?';
  else result:='Unknown Mode ('+IntToHex(b,2)+')';
  end;
end;
{Запрос: 0E 01 00 03 00 0C 02 00 00
  Ответ: 01 0E 00 03 00 0C 02 0F D4}
function BFC_GetCurentUbat(var Ubat: word): boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs00($0E,[$02,0,0],3);
  if BFC_Error<>ERR_NO then exit;
  if (ibfc.head.len=$300)then begin
    Ubat := swap(ibfc.cd.pw[0]);
    result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
//// Display // Display // Display // Display
// 0a 01 00 01 20 2a 06 3a 06
// 01 0a 00 02 00 09 06 01
function BFC_GetDisplayCount(var DisplayCount:byte): boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($0A,[$06],1);
  if BFC_Error<>ERR_NO then exit;
  if (ibfc.head.len=$200)then begin
    DisplayCount := ibfc.data[1];
    result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
// BFC_GetDisplayType
// 0A 01 00 02 20 29 01 01 CB 25 ->
// 01 0A 00 02 00 09 01 2C (DisplayType = 44)
function BFC_GetDisplayType(NumID : byte; var DisplayID : byte): boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($0A,[$01,NumID],2);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=2) then begin
    DisplayID := ibfc.data[1];
    result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
// BFC_RestoreDisplay(1) = Ok
// 0A 01 00 02 20 29 03 01 F8 95 ->  01 0A 00 02 00 09 03 01
function BFC_RestoreDisplay(NumID : byte): boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($0A,[$03,NumID],2);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=2) and (ibfc.data[1]=1) then begin
    result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
// BFC_SwitchOffDisplay(1)
// 0A 01 00 02 20 29 05 01 AC 45 -> 01 0A 00 02 00 09 05 01
function BFC_SwitchOffDisplay(NumID : byte): boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($0A,[$05,NumID],2);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=2) and (ibfc.data[1]=1) then begin
    result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
// BFC_GetDisplayInformation(1) = Ok (Width x Height 132x176 pixels, ClientId 3)
// 0A 01 00 02 20 29 07 01 9F F5 -> 01 0A 00 06 00 0D 07 84 00 B0 00 03
function BFC_GetDisplayInformation(NumID : byte; var DisplayInfo : T_DisplayInfo): boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($0A,[$07,NumID],2);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=6) then begin
    DisplayInfo := ibfc.cd.DisplayInfo;
    result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
// BFC_WaitForDisplayUpdateNotification(1) = Ok, (ID:3, 132x176, 0:0)
// -> 01 0A 00 0B 00 00 08 01 03 00 00 00 00 84 00 B0 00
function BFC_WaitForDisplayUpdateNotification(DisplayNum : byte; var DisplayUpdateInfo : T_DisplayUpdateInfo): boolean;
begin
  result:=False;
  obfc.head.idtx:=$0A;
  BFC_Error:=ReadBFC;
  if BFC_Error<>ERR_NO then exit;
  if  (swap(ibfc.head.len)>=$0B)
  and (ibfc.data[0]=$08)
  and (ibfc.cd.DisplayUpdateInfo.DisplayNum = DisplayNum)
  then begin
   BFC_Error:=ERR_BFC_DATA;
   exit;
  end;
  if (swap(ibfc.head.len)>=$0B) then begin
    DisplayUpdateInfo := ibfc.cd.DisplayUpdateInfo;
    result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
// BFC_GetDisplayBufferInfo(3) = Ok, (ID:3, 132x176, 0:0, 0, 0xA844C120, 16 Bit, RGB565)
// 0A 01 00 02 20 29 09 03 26 F7 -> 01 0A 00 0F 00 04 09 03 84 00 B0 00 00 00 00 00 20 C1 44 A8 04
function BFC_GetDisplayBufferInfo(ClientId : byte; var DisplayBufferInfo : T_DisplayBufferInfo): boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($0A,[$09,ClientId],2);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=$0F)
  and (ibfc.cd.DisplayBufferInfo.ClientId = ClientId)
  then begin
    DisplayBufferInfo := ibfc.cd.DisplayBufferInfo;
    result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
// 0A 01 00 03 20 28 0A 01 00 47 52
function BFC_GenerateDisplayPattern(NumID, number:byte): boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($0A,[$0A,NumID,number],3);
  if BFC_Error<>ERR_NO then exit;
  result:=True;
end;
// 0a 01 00 03 20 28 04 01 7d ff 2b
// 01 0a 00 02 00 09 04 01
function BFC_SetDisplayContrast(NumID,Contrast:byte): boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($0A,[$04,NumID,Contrast],3);
  if BFC_Error<>ERR_NO then exit;
  if (ibfc.head.len=$200) and (ibfc.data[1]=1) then begin
    result:=True;
  end
end;
// BFC_FlashManagerInvalidateInstance(FFx) = Ok
// 23 01 00 05 20 07 10 46 46 78 00 2F C0 ->  01 23 00 02 20 00 10 05 6D 39
// 23 01 00 01 20 03 12 BA 32 ->  01 23 00 02 20 00 12 00 09 24
function BFC_Format_Instance_Ready : boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($23,[$12],1);
  if BFC_Error<>ERR_NO then exit;
  if (ibfc.head.len=$200)and(ibfc.cd.pb[0]=0) then
   result:=True
end;

function BFC_Invalidate_Instance(InstName: string): boolean;
var
 i: integer;
 Buf: array [0..15] of Byte;
begin
  i:=Length(InstName);
  result:=False;
  if i>=14 then begin
    BFC_Error:=ERR_BFC_PAR;
    exit;
  end;
  Buf[i]:=0;
  Move(InstName[1],Buf[1],i);
  Buf[0]:=$10;
  BFC_Error:=BFC_Funcs20($23,Buf,i+1);
  if BFC_Error<>ERR_NO then exit;
  if (ibfc.head.len=$200)and(ibfc.cd.pb[0]=0) then begin
    result:=True;
    exit;
  end;
  BFC_Error:=ERR_BFC_DATA;
end;

// BFC_FreezeSecurityData
// 25 01 00 11 20 15 17 33 35 33 39 31 30 30 30 32 33 36 36 37 30 39 25 4E B7
// ->  01 25 00 03 00 27 17 06 00  (6) BootFreezeFailed
function BFC_FreezeSecurityData(sxIMEI: string; var err: word): boolean;
var
 i: integer;
 Buf: array [0..16] of Byte;
begin
  result:=False;
  if Length(sxIMEI)<>15 then begin
    BFC_Error:=ERR_BFC_PAR;
    exit;
  end;
  Move(sxIMEI[1],Buf[1],15);
  Buf[0]:=$17;
  Buf[16]:=Buf[0];
  for i:=1 to 15 do
   Buf[16]:=Buf[16] xor Buf[i];
  BFC_Error:=BFC_Funcs20($25,Buf,17);
  if BFC_Error<>ERR_NO then exit;
  if (ibfc.head.len=$300) then begin
    err := ibfc.cd.pw[0];
    result:=True;
    exit;
  end;
  BFC_Error:=ERR_BFC_DATA;
  err:=$FFFF;
end;
// BFC_FlashManagerGetOtpLockState
// 23 01 00 01 20 03 04 CF 85 -> 01 23 00 03 20 01 04 00 01 3D 7A  = Locked
function BFC_GetOtpLockState(var state: word): boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs00($23,[$04],1);
  if BFC_Error<>ERR_NO then exit;
  if (ibfc.head.len=$300)then begin
    state := ibfc.cd.pw[0];
    result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
// BFC_FlashManagerLockOtp
// 23 01 00 01 20 03 05 DE 0C -> 01 23 00 02 20 00 05 00 D1 BD  = Ok
function BFC_FlashManagerLockOtp: boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs00($23,[$05],1);
  if BFC_Error<>ERR_NO then exit;
  if (ibfc.head.len=$200) and (ibfc.cd.pb[0]=0)then  result:=True
  else BFC_Error:=ERR_BFC_DATA;
end;
// BFC_FlashManagerGetEsn
// 23 01 00 01 20 03 01 98 28 -> 01 23 00 05 20 07 01 49 93 7C FA 16 69
function BFC_GetEsn(var OTP_ESN: dword): boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($23,[$01],1);
  if BFC_Error<>ERR_NO then exit;
  if (ibfc.head.len=$500)then begin
    OTP_ESN := ibfc.cd.pd[0];
    result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
// BFC_FlashManagerGetOtpBlockLength
// 23 01 00 05 20 07 06 00 00 00 00 13 9E -> 01 23 00 06 20 04 06 00 08 00 00 00 86 F6
// 23 01 00 05 20 07 06 01 00 00 00 0F 25 -> 01 23 00 06 20 04 06 00 18 00 00 00 45 57
function BFC_GetOtpBlockLength(blk_num: byte; var blk_size: dword): boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($23,[$06,blk_num,0,0,0],5);
  if BFC_Error<>ERR_NO then exit;
  if (ibfc.head.len=$600) and (ibfc.cd.pb[0]=0) then begin
    blk_size := Dword(Pointer((@ibfc.data[2])^));
    result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
// BFC_FlashManagerReadOtp
// 23 01 00 0D 20 0F 03  00 00 00 00  00 00 00 00  08 00 00 00  F4 56
// -> 01 23 00 0A 20 08 03 00 53 93 01 00 32 66 07 FF 41 08
function BFC_ReadOtpBlk(blk_num: dword; blk_off: dword; blk_len: dword): boolean;
var
cmdbuf : t_OTP_BLK;
begin
  result:=False;
  cmdbuf.cmd:=$03;
  cmdbuf.num:=blk_num;
  cmdbuf.off:=blk_off;
  cmdbuf.len:=blk_len;
  BFC_Error:=BFC_Funcs20($23,cmdbuf.b,sizeof(cmdbuf));
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)=blk_len+2) and (ibfc.cd.pb[0]=0) then begin
    result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;

// Special type for memory reading
type
 BfcRdMemType = packed record case byte of
  0: ( sub: byte; addr,len: Cardinal;);
  1: ( b: array [0..8] of byte;);
 end;

function BFCReadMem(addr, len: dword;var Buf: array of byte): Boolean;
var
 RdMem: BfcRdMemType;
 Pos: Cardinal;
 ll: word; // Loaded Length
 bx : byte;
begin
  Result:=False;
  if (len and $FFFF0000)<>0 then begin
    BFC_Error:=ERR_BFC_PAR;
    exit;
  end;
  RdMem.sub :=$01;
  RdMem.addr := addr;
  RdMem.len := len;
  BFC_Error:=BFC_Funcs20($06,RdMem.b,sizeof(RdMem));
  if BFC_Error<>ERR_NO then exit;
  if Word((@ibfc.data[0])^)=$01 then begin
   Pos:=0; bx:=1;
   while Pos<len do begin
     BFC_Error:=ReadBfc;
     if BFC_Error<>ERR_NO then exit;
     ll:=swap(ibfc.head.len);
     if len<>ll then begin
      if ((ibfc.data[0] and $80) <> 0) then begin
       if (len<>Pos+ll-1) or (ibfc.data[0]<> (bx or $80)) then begin
        BFC_Error:=ERR_BFC_DATA;
        exit;
       end;
      end
      else begin
       if (ibfc.data[0]<>bx) then begin
        BFC_Error:=ERR_BFC_DATA;
        exit;
       end;
      end;
      ll:=ll-1;
      if len<Pos+ll then ll:=Len-Pos;
      Move(ibfc.data[1], Buf[Pos], ll);
     end //if len<>ll
     else begin
      if len<Pos+ll then ll:=Len-Pos;
      Move(ibfc.data, Buf[Pos], ll);
     end;
     pos:=pos+ll;
     bx:=bx+1;
   end;
   Result:=True;
  end;
end;

function BFC_GetSecurityInfo(var buf: array of word; buf_len: integer): boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($25,[$15,$08,0,0],4);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=6) and (ibfc.cd.pb[0]=8)then begin
    if buf_len >= (swap(ibfc.head.len)-2) then begin
      buf[0]:= (swap(ibfc.head.len)-2) shr 1;
      move(ibfc.cd.pb[1],buf[1],(swap(ibfc.head.len)-2));
      result:=True;
    end
    else begin
     BFC_Error:=ERR_BFC_PAR;
     exit;
    end;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
// BFC_FlashManagerGetFlashType
// 23 01 00 01 20 03 20 A8 A3 -> 01 23 00 0A 20 08 20 00 89 00 00 00 0D 88 00 00 70 3C
//  NumOfFlashes = 1, ManufactureID: 89000000, DeviceID: 0D880000
function BFC_GetFlashTypes(var buf: array of dword; buf_len: integer): boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($23,[$20],1);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=$A)then begin
    if buf_len >= (swap(ibfc.head.len)-2) then begin
      buf[0] := (swap(ibfc.head.len)-2) shr 3;
      move(ibfc.cd.pb[1],buf[1],(swap(ibfc.head.len)-2));
      result:=True;
    end
    else begin
     BFC_Error:=ERR_BFC_PAR;
     exit;
    end;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
// EELITE
// 14 01 00 05 20 30 05 34 00 00 00 D8 64 ->
// 01 14 00 07 20 32 05 00 22 01 00 00 00 6A 3D
//
// 14 01 00 05 20 30 15 8f 13 00 00 a7 5c   // BFC_EeGiveBlockVersionAndSizeEEFULL 0x138F=5007
// 01 14 00 07 20 32 15 00 04 00 00 00 00 98 46 // *BlockSize = 4, *Version = 0
function BFC_EE_Get_Block_Info(num : dword; var len: dword; var ver: byte): boolean;
var
EEP_GetInfo: T_EEP_GetInfo;
begin
  result:=False;
  if num>=5000 then begin
   EEP_GetInfo.cmd:=$15;
  end
  else begin
   EEP_GetInfo.cmd:=$05;
  end;
  EEP_GetInfo.num:=num;
  BFC_Error:=BFC_Funcs20($14,EEP_GetInfo.b,sizeof(EEP_GetInfo));
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=$7)and(ibfc.data[1]=$0) then begin
    len := Dword(Pointer((@ibfc.data[2])^));
    ver := ibfc.data[6];
    result:=True;
  end
  else
  if (swap(ibfc.head.len)=$2)and(ibfc.data[1]=$2) then BFC_Error:=ERR_EEP_NONE
  else BFC_Error:=ERR_BFC_DATA;
end;
// 14 01 00 0D 20 38 04 34 00 00 00 00 00 00 00 10 00 00 00 96 4A
//->
// 01 14 00 12 20 27 04 00 41 23 63 FF 74 3B C8 DB F8 FD 5E 64 46 FF D6 F2 93 7F

// 14 01 00 0D 20 38 04 2D 01 00 00 00 00 00 00 E0 00 00 00 2E 91
// 14 01 00 0D 20 38 04 2D 01 00 00 00 00 00 00 00 10 00 00 1F 8E
function BFC_EE_Read_Block_(num,off,len : dword; var buf: array of byte ): boolean;
var
EEP_Read_Block :T_EEP_Read_Block;
cur : dword;
//b : byte;
begin
  result:=False;
  if num>=5000 then begin
   EEP_Read_Block.cmd:=$14;
  end
  else begin
   EEP_Read_Block.cmd:=$04;
  end;
  EEP_Read_Block.num:=num;
  EEP_Read_Block.off:=off;
  EEP_Read_Block.len:=len;
  BFC_Error:=BFC_Funcs20($14,EEP_Read_Block.b,sizeof(EEP_Read_Block));
  if (BFC_Error=ERR_BFC_DATA)
  and (dword((swap(ibfc.head.len)-2))<len)
  and (ibfc.data[0]=1)
  then begin
   cur:=swap(ibfc.head.len)-3;
   move(ibfc.data[3],buf[0],cur);
   obfc.data[0]:=2;
   BFC_Error:=ERR_NO;
   while(cur<len) do begin
    BFC_Error:=ReadBFC;
    if BFC_Error<>ERR_NO then exit;
    if ibfc.data[0]<>obfc.data[0] then
    begin
      if (len-cur=dword(swap(ibfc.head.len)-1)) then begin
       move(ibfc.data[1],buf[cur],swap(ibfc.head.len)-1);
       result:=True;
       exit;
      end
      else begin
       BFC_Error:=ERR_BFC_DATA;
       exit;
      end;
    end;
    move(ibfc.data[1],buf[cur],swap(ibfc.head.len)-1);
    cur:=cur+swap(ibfc.head.len)-1;
    obfc.data[0]:=obfc.data[0]+1;
//     if
   end;
//   result:=True;
   exit;
  end;
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=$2)and(ibfc.data[1]=0)and
    (len = dword(swap(ibfc.head.len)-2)) then begin
      if len<>0 then move(ibfc.data[2],buf[0],len);
      result:=True;
  end
  else
   BFC_Error:=ERR_BFC_DATA;
end;

function BFC_EE_Read_Block(num,off,len : dword; var buf: array of byte ): boolean;
const
DEFRAG_BLK_SIZE = $3EE;
var
xoff,xlen : dword;
begin
    result:=False;
    if len=0 then exit;
    if len>DEFRAG_BLK_SIZE then begin
     xoff:=0;
     while(xoff<len) do begin
      if (len-xoff)>=DEFRAG_BLK_SIZE then xlen:=DEFRAG_BLK_SIZE
      else xlen:=len-xoff;
      result:=BFC_EE_Read_Block_(num,xoff,xlen,buf[xoff]);
      if Not result then break;
      inc(xoff,xlen);
     end;
    end
    else result:=BFC_EE_Read_Block_(num,off,len,buf);
end;


function BFC_EE_Del_block(num: dword): boolean;
var
EEP_del_blk: T_EEP_GetInfo;
begin
  result:=False;
  if num>=5000 then begin
   EEP_del_blk.cmd:=$17;
  end
  else begin
   EEP_del_blk.cmd:=$07;
  end;
  EEP_del_blk.num:=num;
  BFC_Error:=BFC_Funcs20($14,EEP_del_blk.b,sizeof(EEP_del_blk));
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=$2)and(ibfc.data[1]=0) then result:=True
  else BFC_Error:=ERR_BFC_DATA;
end;
// 14 01 00 0A 20 3F 01 34 00 00 00 22 01 00 00 00 62 5A
// 01 14 00 02 20 37 01 00 AD 24
function BFC_EE_Create_Block(num,len,ver: dword) : boolean;
var
EEP_Create_Block : T_EEP_Create_Block;
begin
  result:=False;
  if num>=5000 then begin
   EEP_Create_Block.cmd:=$11;
  end
  else begin
   EEP_Create_Block.cmd:=$01;
  end;
  EEP_Create_Block.num:=num;
  EEP_Create_Block.len:=len;
  EEP_Create_Block.ver:=Byte(ver);
  BFC_Error:=BFC_Funcs20($14,EEP_Create_Block.b,sizeof(EEP_Create_Block));
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=$2) then begin
   if (ibfc.data[1]=0) then begin
    result:=True;
    exit;
   end;
   // 08 - не верный формат команды?
  end;
  BFC_Error:=ERR_BFC_DATA;
end;
// 14 01 00 1D 20 28 02 34 00 00 00 00 00 00 00 data...
// 01 14 00 02 20 37 02 00 87 4C
function BFC_EE_Write_Block(num,off,len : dword; var buf: array of byte ): boolean;
var
EEP_Write_Block : T_EEP_Write_Block;
cur : dword;
begin
  result:=False;
  if len=0 then begin
    BFC_Error:=ERR_BFC_PAR;
    exit;
  end;
  if num>=5000 then begin
   EEP_Write_Block.cmd:=$12;
  end
  else begin
   EEP_Write_Block.cmd:=$02;
  end;
  EEP_Write_Block.num:=num;
  if (len=0) or (len>16384) then begin
    BFC_Error:=ERR_BFC_PAR;
  end;
  while(len<>0) do begin
   if (len>sizeof(EEP_Write_Block.data)) then cur:=sizeof(EEP_Write_Block.data)
   else cur:=len;
   move(buf[off],EEP_Write_Block.data[0],cur);
   EEP_Write_Block.off:=off;
   BFC_Error:=BFC_Funcs20($14,EEP_Write_Block.b,9+cur);
   if BFC_Error<>ERR_NO then exit;
   if (swap(ibfc.head.len)<$2) or (ibfc.data[1]<>0) then begin
    BFC_Error:=ERR_BFC_DATA;
    // 05 - не верный адрес записи?
    exit;
   end;
   off:=off+cur;
   len:=len-cur;
  end; // while
  result:=True;
end;

function BFC_EE_Finish_Block(num : dword) : boolean;
var
EEP_end_blk: T_EEP_GetInfo;
begin
  result:=False;
  if num>=5000 then begin
   EEP_end_blk.cmd:=$13;
  end
  else begin
   EEP_end_blk.cmd:=$03;
  end;
  EEP_end_blk.num:=num;
  BFC_Error:=BFC_Funcs20($14,EEP_end_blk.b,sizeof(EEP_end_blk));
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=$2)and(ibfc.data[1]=0) then result:=True
  else if (swap(ibfc.head.len)=$1) then result:=True
  else BFC_Error:=ERR_BFC_DATA;
end;

function BFC_EELITE_Format : boolean;
begin
  result:=False;
  ComTimeouts.ReadIntervalTimeout:=2500;
  ComTimeouts.ReadTotalTimeoutMultiplier:=2500;
  ComTimeouts.ReadTotalTimeoutConstant:=2500;
  ComTimeouts.WriteTotalTimeoutMultiplier:=MAXDWORD;
  ComTimeouts.WriteTotalTimeoutConstant:=MAXDWORD;
  SetComTimeouts;
  BFC_Error:=BFC_Funcs20($14,[$09],1);
  ComTimeouts.ReadIntervalTimeout:=0;
  ComTimeouts.ReadTotalTimeoutMultiplier:=20;
  ComTimeouts.ReadTotalTimeoutConstant:=200;
  SetComTimeouts;
  if BFC_Error=ERR_NO then result:=True;
end;

function BFC_EEFULL_Format : boolean;
begin
  result:=False;
  ComTimeouts.ReadIntervalTimeout:=2500;
  ComTimeouts.ReadTotalTimeoutMultiplier:=2500;
  ComTimeouts.ReadTotalTimeoutConstant:=2500;
  ComTimeouts.WriteTotalTimeoutMultiplier:=MAXDWORD;
  ComTimeouts.WriteTotalTimeoutConstant:=MAXDWORD;
  SetComTimeouts;
  BFC_Error:=BFC_Funcs20($14,[$19],1);
  ComTimeouts.ReadIntervalTimeout:=0;
  ComTimeouts.ReadTotalTimeoutMultiplier:=20;
  ComTimeouts.ReadTotalTimeoutConstant:=200;
  SetComTimeouts;
  if BFC_Error=ERR_NO then result:=True;
end;
//14 01 00 01 20 34 06 06 6F
//01 14 00 06 20 33 06 00 5E 01 00 00
function BFC_EELITE_MaxIndexBlk(var num : dword) : boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($14,[$06],1);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=$6)and(ibfc.data[1]=0) then begin
   num := Dword(Pointer((@ibfc.data[2])^));
   result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
//14 01 00 01 20 34 16 16 EE
//01 14 00 06 20 33 16 00 7B 15 00 00
function BFC_EEFULL_MaxIndexBlk(var num : dword) : boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($14,[$16],1);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=$6)and(ibfc.data[1]=0) then begin
   num := Dword(Pointer((@ibfc.data[2])^));
   result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
//
function BFC_EELITE_GetBufferInfo(var freeb,freea,freed : dword) : boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($14,[$08],1);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=14)and(ibfc.data[1]=0) then begin
   freeb := Dword(Pointer((@ibfc.data[2])^));
   freea := Dword(Pointer((@ibfc.data[6])^));
   freed := Dword(Pointer((@ibfc.data[10])^));
   result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;

function BFC_EEFULL_GetBufferInfo(var freeb,freea,freed : dword) : boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($14,[$18],1);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=14)and(ibfc.data[1]=0) then begin
   freeb := Dword(Pointer((@ibfc.data[2])^));
   freea := Dword(Pointer((@ibfc.data[6])^));
   freed := Dword(Pointer((@ibfc.data[10])^));
   result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
//WRITE: 16 01 00 01 20 36[01]76 DB //BFC_ReadCameraId(id) = Ok,
//READ : 01 16 00 02 00 15 01[07] //CameraSensorType = 7
function BFC_ReadCameraId(var id : integer) : boolean;
begin
  result:=False;
  ComTimeouts.ReadIntervalTimeout:=2500;
  ComTimeouts.ReadTotalTimeoutMultiplier:=2500;
  ComTimeouts.ReadTotalTimeoutConstant:=2500;
  ComTimeouts.WriteTotalTimeoutMultiplier:=MAXDWORD;
  ComTimeouts.WriteTotalTimeoutConstant:=MAXDWORD;
  SetComTimeouts;
  BFC_Error:=BFC_Funcs20($16,[$01],1);
  ComTimeouts.ReadIntervalTimeout:=0;
  ComTimeouts.ReadTotalTimeoutMultiplier:=20;
  ComTimeouts.ReadTotalTimeoutConstant:=200;
  SetComTimeouts;
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=2) then begin
   id:=ibfc.data[1];
   result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
//WRITE: 16 01 00 03 20 34[06 00 02]33 15 //Camerapar
//READ : 01 16 00 02 00 15 06 [01]
//WRITE: 16 01 00 03 20 34[06 01 50]5B 5A //CameraPar
//READ : 01 16 00 02 00 15 06[01]
function BFC_SetCameraParameters(id,data : byte ) : boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($16,[$06,id,data],3);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=2) and (ibfc.data[1]=$01) then result:=True
  else BFC_Error:=ERR_BFC_DATA;
end;
//WRITE: 16 01 00 05 00 12 02 00 00 00 00 // ChotCamera?
//READ : 01 16 00 05 00 12 02 FD 4C 01 00 // SizeBuf=14CFD
function BFC_TakeCameraPicture(Resolution : byte; var size: dword) : boolean;
begin
  result:=False;
  ComTimeouts.ReadIntervalTimeout:=700;
  ComTimeouts.ReadTotalTimeoutMultiplier:=100;
  ComTimeouts.ReadTotalTimeoutConstant:=1000;
  ComTimeouts.WriteTotalTimeoutMultiplier:=MAXDWORD;
  ComTimeouts.WriteTotalTimeoutConstant:=MAXDWORD;
  SetComTimeouts;
//  BFC_Error:=BFC_Funcs20($16,[$02,Format,Resolution,$00,$00],5);
  BFC_Error:=BFC_Funcs20($16,[$02,0,0,Resolution,0],5);
  ComTimeouts.ReadIntervalTimeout:=0;
  ComTimeouts.ReadTotalTimeoutMultiplier:=20;
  ComTimeouts.ReadTotalTimeoutConstant:=200;
  SetComTimeouts;
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=5) then begin
   size:=ibfc.cd.pd[0];
   result:=True
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
//WRITE: 16 01 00 01 20 36[04]21 76
//READ : 01 16 00 09 00 1E 04[4C 9C 2C A8 FD 4C 01 00]
function BFC_GetCameraBuf(var addr,size : dword ) : boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($16,[$04],1);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=9) then begin
   addr:=ibfc.cd.pd[0];
   size:=ibfc.cd.pd[1];
   result:=True;
  end
  else BFC_Error:=ERR_BFC_DATA;
end;
//Send    16 01 00 01 20 36 07 13 ed
//Receive 01 16 00 02 00 15 07 01
function BFC_ShutdownCamera : boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($16,[$07],1);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=2) and (ibfc.data[1]=$01) then result:=True
  else BFC_Error:=ERR_BFC_DATA;
end;
// Audio // Audio // Audio // Audio // Audio
//Send    0b 01 00 05 20 2f (70) [1f fd,1f fe] cd 56
//Receive 01 0b 00 02 00 08 (70) [01]
function BFC_ActScalAddRouting( iAudi,iAudo: integer) : boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($0B,[$70,Byte(iAudi shr 8),Byte(iAudi),Byte(iAudo shr 8),Byte(iAudo)],5);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=2) and (ibfc.data[1]=$01) then result:=True
  else BFC_Error:=ERR_BFC_DATA;
end;
//WRITE  : 0B 01 00 15 20 3F(6F)00 00 00 00 00 00 00 00 00 00 00 00 04 00 00 00 00 00 00 00 ...
//READ   : 01 0B 00 02 00 08(6F)01
// test_mode =1 - microphone, =2 - speaker, =3 - receiver, =4 - micrec.
function BFC_AddRoutingReconfigure(var RoutingRec : sRoutingRec) : boolean;
var
buf : array[0..21] of byte;
begin
  result:=False;
  move(RoutingRec.b,buf[1],SizeOf(RoutingRec));
  buf[0]:=$6F;
  BFC_Error:=BFC_Funcs20($0B,buf,$15);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=2) and (ibfc.data[1]=$01) then result:=True
  else BFC_Error:=ERR_BFC_DATA;
end;
// Send    0b 01 00 01 20 2b (6d) 61 de
// Receive 01 0b 00 02 00 08 (6d) [01]
function BFC_ActivateAddRouting : boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($0B,[$6D],1);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=2) and (ibfc.data[1]=$01) then result:=True
  else BFC_Error:=ERR_BFC_DATA;
end;
// Send    0b 01 00 01 20 2b (6e) 53 45
// Receive 01 0b 00 02 00 08 (6e) [01]
function BFC_DeactivateAddRouting : boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($0B,[$6E],1);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=2) and (ibfc.data[1]=$01) then result:=True
  else BFC_Error:=ERR_BFC_DATA;
end;
// Send    0b 01 00 01 20 2b (71) bb 33
// Receive 01 0b 00 02 00 08 (71) [01]
function BFC_AddRoutingOff : boolean;
begin
  result:=False;
  BFC_Error:=BFC_Funcs20($0B,[$71],1);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=2) and (ibfc.data[1]=$01) then result:=True
  else BFC_Error:=ERR_BFC_DATA;
end;
//WRITE  : 08 01 00 15 20 3C(01)09 00,00 00 19 00 80 00 00 20 FF 1F/01 20
//READ   : 01 08 00 01 00 08(01)
function BFC_CommandDsp(lenbuf : integer; buf : array of byte) : boolean;
var
bufx : array[0..1023] of byte;
begin
  result:=False;
  if (lenbuf <= 0) or (lenbuf > 1023) then begin
   BFC_Error:=ERR_BFC_PAR;
   exit;
  end;
  if oldhost<>$08 then begin
   BFC_Error:=BFC_InitHost($08);
   if BFC_Error<>ERR_NO then exit;
  end;
  bufx[0]:=$01;
  move(buf,bufx[1],lenbuf);
  BFC_Error:=BFC_Funcs20($08,bufx,lenbuf+1);
  if BFC_Error<>ERR_NO then exit;
  if (swap(ibfc.head.len)>=1) then result:=True
  else BFC_Error:=ERR_BFC_DATA;
end;
// ReadMobileMemory(StartAddress=0xf6001207, Length=24)
// Receive 01 06 00 18 00 1f 00 03 00 00 00 ff ff 7b 00 90 ff 03 00 03 00 03 00 00 00 00 00 00 00 00

//--------------------- Full Open BFC Only !------------------------------------
// BFC_FlashManagerEraseInstance(FFx,3 sec) = Ok
// 23 01 00 05 20 07 11 46 46 78 00 24 84 ->  01 23 00 02 20 00 11 05 74 E1
// 23 01 00 01 20 03 12 BA 32 ->  01 23 00 02 20 00 12 00 09 24
// BFC_FlashManagerIncrementalWriteOtp
// 23 01 00 21 20 23 02 01 00 00 00 00 00 00 00 FF ..... FF 4B 1D
// BFC_FlashManagerGetEraseCounts(FFS)
// 23 01 00 09 20 0B 21 46 46 53 00 00 00 00 00 49 1F -> (FFS)
// 01 23 00 12 20 10 21 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7A 79
// 23 01 00 09 20 0B 21 46 46 53 00 0C 00 00 00 DE 2B ->
// 01 23 00 12 20 10 21 00 05 00 00 00 01 00 00 00 02 00 00 00 01 00 00 00 4E 8A

// BFC_GetMmcId (CSD,CID)
// 28 01 00 01 20 08 01 0A 02 ->
// 01 28 00 22 00 0B 01 00 8F 57 13 56 F3 18 01 20 20 20 4D 32 33 00 00 06 8D 00
// 40 8A E1 81 D9 F6 E9 81 F9 0F 2A 01 0E 8C

// BFC_TestServiceMode
// 19 01 00 01 20 39 02 DE 7C ->  01 19 00 02 00 1A 02 12 (Normal Mode)
// BFC_GetBaseBandProcessorVersion
// 11 01 00 01 20 31 03 DF D9 -> 01 11 00 05 00 15 03 1A 05 00 00 (BaseBandProcessorVersion = 15)


// BFC_ReadOperateAndTalkTime() = Ok, Operation and Talk time : 1224795847, 55053
// 11 01 00 01 20 31 07 99 FD -> 01 11 00 05 00 15 07 E6 C7 49 00
// 11 01 00 01 20 31 08 61 0A -> 01 11 00 05 00 15 08 D7 0D 00 00

// BFC_ControlVibra(On) = Ok
// 1B 01 00 01 20 3B 02 DA 77 -> 01 1B 00 02 00 18 02 01
// BFC_ControlVibra(Off) = Ok
// 1B 01 00 01 20 3B 01 E8 EC -> 01 1B 00 02 00 18 01 01

// BFC_RedirectKeypad() = Ok
// 09 01 00 01 20 29 01 CC BF -> 01 09 00 02 00 0A 01 01
// BFC_GetKeypad() = Ok,
// 01 09 00 02 00 0A 04 0C, 01 09 00 02 00 0A 04 8C
// BFC_RestoreKeypad() = Ok
// 09 01 00 01 20 29 02 FE 24 -> 01 09 00 02 00 0A 02 01
// BFC_PressKeypad(0x1A,0) = Ok,BFC_L2_PressKeypad(0x1A,1) = Ok
// 09 01 00 02 20 2A 03 1A 33 73 -> 01 09 00 02 00 0A 03 01
// 09 01 00 02 20 2A 03 9A B7 7B -> 01 09 00 02 00 0A 03 01

// BFC_GetNormalModeRxLevel() = Ok, RxLevel = 81
// 1C 01 00 01 20 3C 02 50 67 -> 01 1C 00 03 00 1E 02 51 00

// BFC_SetRfChannel(12) = Ok
// 07 01 00 06 20 20 06 00 0C 00 01 01 BE DB ->
// -> 01 07 00 01 00 07 06
// BFC_SetRxTxTiming(1) = Ok
// 07 01 00 03 20 25 03 01 01 4C 98 -> 01 07 00 01 00 07 03
// BFC_SetRxTxTiming(8) = Ok
// 07 01 00 03 20 25 03 08 01 9B 80 -> 01 07 00 01 00 07 03
// BFC_ReadIqOffsetAmplitudeFromEelite() = Ok
{iOffsetGSM850 = 0
qOffsetGSM850 = 0
iOffsetGSM900 = 0
qOffsetGSM900 = 0
iOffsetPCN1800 = 0
qOffsetPCN1800 = 0
iOffsetPGS1900 = 0
qOffsetPGS1900 = 0
iAmplitude = 250
qAmplitude = 250
deltaF_GMSK = 0
deltaF_8PSK = 0}
// 14 01 00 05 20 30 05 41 00 00 00 EC 76 -> 01 14 00 07 20 32 05 00 18 00 00 00 06 8B C9
// 14 01 00 0D 20 38 04 41 00 00 00 00 00 00 00 18 00 00 00 9A B9 ->
// -> 01 14 00 1A 20 2F 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 FA
// 00 FA 00 00 00 00 00 1D 1F

// BFC_InitDsp(0,...) = Ok
// 08 01 00 17 20 3E(01)0A 00 00 00 01 00 00 00 00 00 00 00 00 00 FA 00 FA 00 00 00 00 00 61 70
// -> 01 08 00 01 00 08 01
// BFC_RebootDspInternal() = Ok
// 08 01 00 01 20 28(03)69 A0 -> 01 08 00 01 00 08 03
// BFC_CommandDsp (01,02)
// 08 01 00 07 20 2E(01)02 00 01 02 00 00 13 98 ->  01 08 00 01 00 08 01 (OK)

// Audio // Audio // Audio // Audio // Audio
// AudioMeasurement parms:
//(wScaleAudi =(dec) ? ,wScaleAudo =(dec) ?)
//(NoOfFrames =(dec) ? ,AverageExponent =(dec) ?)
//(ToneArray.freq =(dec) ? ,ToneArray.volume =(dec) ?)
//(MicroArray.MidFreq =(dec) ? ,MicroArray.UpperLimit =(dec) ? ,MicroArray.LowerLimit =(dec) ?)
//(RevLevel =(dec) ? ,QFormat = Q14 ,nftype = test_mode_test_speaker)
//(wScaleAudi =(dec) ? ,wScaleAudo =(dec) ?))





end.
