//Использование в коммерческих целях запрещено.
//Наказание - неминуемый кряк и распространение по всему инет.
//Business application is forbidden.
//Punishment - unavoidable crack and propagation on everything inet.
unit BFB;

interface
uses Windows,SysUtils,Crc16,ComPort;

const
MAXBFBDATA = 32;

  BFB_OK            =0;
  ERR_BFB           =-1;
  ERR_BFB_PAR       =-2;
  ERR_BFB_IN_CRC16  =-3;
  ERR_BFB_RD_CMD    =-4;
  ERR_BFB_INIT_HID  =-5;
  ERR_BFB_DATA      =-6;
  ERR_BFB_INFO      =-7;
  ERR_BFB_EEPBLKNONE=-8;
  ERR_BFB_CHK       =-9;
  ERR_BFB_EEPWAIT   =-10;
  ERR_BFB_EEPFREE   =-11;
  ERR_BFB_CMDEXIT   =-12;
  ERR_BFB_TIMEOUT   =-14;
  ERR_BFB_IO_RS     =-15;

type
// BFB Head
 sbfbhead = packed record
   id   : BYTE; // id
   len  : BYTE; // size data
   chk  : BYTE; // =id^len
 end;
 sbfbdata = packed record case byte of
   0: ( cmdb : Byte;
        datab : array[0..MAXBFBDATA] of Byte ; );
   1: ( cmdbw : Byte;
        dataw : array[0..(MAXBFBDATA shr 1)] of Word ; );
   2: ( cmdbd : Byte;
        datad : array[0..(MAXBFBDATA shr 2)] of Dword ; );
   3: ( cmdm  : word;
        datam : array[0..(MAXBFBDATA shr 1)] of Word ; );
 end;

// BFB block
 sbfb = packed record case byte of
   0: (
      head : sbfbhead;
      data : array[0..MAXBFBDATA+1] of Byte ;
      size : integer; );
   1: (
      b  : array[0..MAXBFBDATA+1+sizeof(sbfbhead)] of byte; );
   2: (
      headx : sbfbhead;
      code : sbfbdata; );
 end;

 sbfbrdmem = packed record case byte of
   0: ( subcmd : Byte;
        addr   : dword;
        len    : word; );
   1: ( b  : array[0..7] of byte; );
 end;

 sbfbcomspd = packed record
    spd : integer;
    code : string;
 end;

 T_BFB_EEP_GetInfo = packed record case byte of
 0:( cmd       : BYTE;
     num       : WORD;
     chk       : BYTE; );
 1:( b : array[0..3] of Byte );
 end;

 T_EEP_Read_Block = packed record case byte of
 0:( cmd       : BYTE;
     num       : WORD;
     off       : WORD;
     len       : WORD;
     chk       : BYTE; );
 1:( b : array[0..7] of Byte );
 end;

 T_EEP_Write_Block = packed record case byte of
 0:( cmd       : BYTE;
     num       : WORD;
     off       : WORD;
     data      : array[0..19] of Byte;
     chk       : Byte ); //
 1:( b : array[0..25] of Byte ); //
 end;

 T_EEP_Create_Block = packed record case byte of
 0:( cmd       : BYTE;
     num       : WORD;
     len       : WORD;
     ver       : Byte;
     chk       : BYTE; );
 1:( b : array[0..6] of Byte );
 end;

var
 bfbcomspd : array[0..16] of sbfbcomspd = (
        ( spd: 4800; code: #$34+#$38+#$30+#$30+#$3F+#$87+#$CF; ),
        ( spd: 9600; code: #$39+#$36+#$30+#$30+#$3F+#$49+#$CF; ),
        ( spd: 14400; code: #$31+#$34+#$34+#$30+#$30+#$CE+#$8B+#$CF ),
        ( spd: 19200; code: #$31+#$39+#$32+#$30+#$30+#$CE+#$4D+#$CF; ),
        ( spd: 23040; code: #$32+#$33+#$30+#$34+#$30+#$CD+#$CF+#$8F; ),
        ( spd: 28800; code: #$32+#$38+#$38+#$30+#$30+#$CD+#$47+#$CF; ),
        ( spd: 38400; code: #$33+#$38+#$34+#$30+#$30+#$CC+#$4B+#$CF; ),
        ( spd: 57600; code: #$35+#$37+#$36+#$30+#$30+#$CA+#$89+#$CF; ),
        ( spd: 100000; code: #$31+#$30+#$30+#$30+#$30+#$30+#$0C+#$90+#$2B; ),
        ( spd: 115200; code: #$31+#$31+#$35+#$32+#$30+#$30+#$0D+#$D2+#$2B; ),
        ( spd: 200000; code: #$32+#$30+#$30+#$30+#$30+#$30+#$0C+#$90+#$2B; ),
        ( spd: 203000; code: #$32+#$30+#$33+#$30+#$30+#$30+#$0C+#$90+#$2B; ),
        ( spd: 230000; code: #$32+#$33+#$30+#$30+#$30+#$30+#$0F+#$90+#$2B; ),
        ( spd: 400000; code: #$34+#$30+#$30+#$30+#$30+#$30+#$4C+#$D0+#$2B; ),
        ( spd: 406000; code: #$34+#$30+#$36+#$30+#$30+#$30+#$4C+#$D0+#$2B; ),
        ( spd: 460000; code: #$34+#$36+#$30+#$30+#$30+#$30+#$4A+#$90+#$2B; ),
        ( spd: 0; code: ''; ));

 ibfb : sbfb;
 obfb : sbfb;
 BFB_Error : integer=BFB_OK;
 sInstanceNames : array[0..5] of pchar =
  ('Voice Memo','Voice Dialing','Browser Cache','File System','Tegic','Address Book');
 sBFBExit : string;
 flgBFBExit : boolean = False;

function CmdBFB(id : Byte; buf : array of byte; len : Byte) : integer;
function ReadBFB : integer;


function BFB_Ping : boolean;
function BFB_SimulateChipCard : boolean;
function BFB_SendAT(S: String): boolean;
function BFB_PhoneModel: PChar;
function BFB_GetImei: PChar;
function BFB_GetLg: PChar;
function BFB_PhoneFW: byte; // if $ff -> Error
function BFB_FlagStatus : Byte; // if $ff -> Error
function BFB_GetSecurityMode(var mode : byte) : boolean;
function BFB_SecurityMode : String;
function SetSpeedBFB(Baud:integer): boolean;
function BFB_GetESN(var ESN: Dword): boolean;
function BFB_GetHWID(var HW: word): boolean;
function BFB_GetDisplayType(var id: byte): boolean;
function BFB_SendSkey(xSkey: dword): boolean;
function BFB_Freeze(xIMEI: string; var x: word): boolean;
function BFB_to_BFC : boolean;
function BFB_PhoneOff : boolean;
function BFBReadMem(Addr: Dword; Len : Word; var Buffer :  Array of Byte): boolean;
function BFB_SetDisplayContrast(Contrast : Byte) : boolean;
function BFB_ControlLight(Light : Byte) : boolean;
function BFB_ReadSensors(var x: dword): boolean;
function BFB_GetMobileMode(var x: word): boolean;
function BFB_GetBatteryVoltage(var UmV: word): boolean;
function BFB_ReadDSPFirmwareVersion(var dspver: word): boolean;
function BFB_ReadPowerAsicProject(var num: byte): boolean;
function BFB_GetHardwareInf(x : byte; var num: byte): boolean;
function BFB_GoSwup(spd: dword): boolean;

function BFB_EEFULL_GetBufferInfo(var freeb,freea,freed : dword) : boolean;
function BFB_EELITE_GetBufferInfo(var freeb,freea,freed : dword) : boolean;
function BFB_EEFULL_MaxIndexBlk(var num : dword) : boolean;
function BFB_EELITE_MaxIndexBlk(var num : dword) : boolean;
function BFB_EEFULL_Format : boolean;
function BFB_EELITE_Format : boolean;
function BFB_EE_Finish_Block(num : dword) : boolean;
function BFB_EE_Write_Block(num,off,len : dword; var buf: array of byte ): boolean;
function BFB_EE_Create_Block(num,len,ver: dword) : boolean;
function BFB_EE_Del_block(num: dword): boolean;
function BFB_EE_Read_Block(num,off,len : dword; var buf: array of byte ): boolean;
//function BFB_EE_Read_Block_(num,off,len : dword; var buf: array of byte ): boolean;
function BFB_EE_Get_Block_Info(num : dword; var len: dword; var ver: byte): boolean;
function BFB_DeleteInstance(num : Byte) : boolean;

//function BFBReadMem(addr: dword; len: word);

implementation

function SendBFB(id : Byte; buf : array of byte; len : Byte) : integer;
begin
   result:=ERR_BFB_PAR;
   if (len>MAXBFBDATA) then exit;
   obfb.head.id:=id;
   obfb.head.len:=len;
   obfb.head.chk:=len xor id;
   obfb.size:=len+sizeof(sbfbhead);
   if len<>0 then Move(buf,obfb.data,len);
   result:=ERR_BFB_IO_RS;
   if not WriteCom(@obfb.b,obfb.size) then exit;
   result:=BFB_OK;
end;

function ReadBFB : integer;
begin
  ibfb.size:=0;
  ibfb.head.len:=0;
  result:=ERR_BFB_TIMEOUT;
  if not ReadCom(@ibfb.b,sizeof(sbfbhead)) then exit;
  repeat begin
    if (((ibfb.head.id=obfb.head.id) or (ibfb.head.id=$09))
    and (ibfb.head.len<=MAXBFBDATA)
    and (ibfb.head.chk =(ibfb.head.id xor ibfb.head.len))) then begin
     if ibfb.head.len<>0 then
       if not ReadCom(@ibfb.data,ibfb.head.len) then exit
       else result:=BFB_OK
     else result:=BFB_OK;
     if result=BFB_OK then begin
      if (ibfb.head.id=$09) then begin
       ibfb.data[ibfb.head.len]:=0;
       sBFBExit:=sBFBExit+pchar(@ibfb.data[0])+#13+#10;
       flgBFBExit:=True;
       while ReadBFB=ERR_BFB_CMDEXIT do;
       result:=ERR_BFB_CMDEXIT;
       exit;
      end
      else exit;
     end;
    end;
    ibfb.b[0]:=ibfb.b[1];
    ibfb.b[1]:=ibfb.b[2];
    if not ReadCom(@ibfb.b[2],1) then exit;
  end
  until true;
end;

function CmdBFB(id : Byte; buf : array of byte; len : Byte) : integer;
begin
   BFB_Error:=SendBFB(id, buf, len);
   if BFB_Error=BFB_OK then begin
    BFB_Error:=ReadBFB;
    if (BFB_Error=BFB_OK) and ((ibfb.head.len=0) or (ibfb.code.cmdb<>obfb.code.cmdb)) then BFB_Error:=ERR_BFB_RD_CMD;
   end;
   result:=BFB_Error;
end;
// 14 02 16 50 50  Wait!
// 14 02 16 35 35  Free buufer small !
function ReadBFB_CHK : integer;
var
chk : byte;
i,x : integer;
begin
//   BFB_Error:=ERR_BFB_TIMEOUT;
   result:=BFB_OK;
   x:=33;
   while result=BFB_OK do begin
    result:=ReadBFB;
    if result=BFB_OK then begin
     if ((ibfb.code.cmdb=$35) and (ibfb.head.id=$14) and (ibfb.head.len=2) and (ibfb.data[0]=$35)) then begin
      result:=ERR_BFB_EEPFREE;
      exit;
     end
     else if not ((ibfb.head.len=2) and (ibfb.code.cmdb=$50) and (ibfb.data[0]=$50)) then begin
      if ((ibfb.head.len=0) or (ibfb.code.cmdb<>obfb.code.cmdb)) then begin
       result:=ERR_BFB_RD_CMD;
       exit;
      end
      else begin
       chk:=0;
       for i:=0 to ibfb.head.len-2 do chk:=chk xor ibfb.data[i];
       if ibfb.data[ibfb.head.len-1]<>chk then result:=ERR_BFB_CHK
       else result:=BFB_OK;
       exit;
      end;
     end; // if not Wait
     dec(x);
     if (x=0) then result:=ERR_BFB_EEPWAIT;
    end; // if BFB_Error=BFB_OK
   end; // while BFB_Error=BFB_OK
 //  result:=BFB_Error;
end;

function CmdBFB_CHK(id : Byte; var buf : array of byte; len : Byte) : integer;
var
chk : byte;
i : integer;
begin
   chk:=0;
   for i:=0 to len-2 do begin
    chk:=chk xor buf[i];
   end;
   buf[len-1]:=chk;
   BFB_Error:=SendBFB(id, buf, len);
   if BFB_Error<>BFB_OK then begin
    result:=BFB_Error;
    exit;
   end;
   BFB_Error:=ReadBFB_CHK;
   if (BFB_Error=ERR_BFB_TIMEOUT)
   or (BFB_Error=ERR_BFB_RD_CMD)
   then begin
    if (BFB_Error=ERR_BFB_RD_CMD)
    and (ibfb.data[0]=$32)
    and (ibfb.head.id=$14)
    and (ibfb.data[1]=$32)
    and (ibfb.head.len=$2)
    then BFB_Error:=ERR_BFB_EEPBLKNONE
    else BFB_Error:=ReadBFB_CHK;
   end;
   result:=BFB_Error;
end;

function BFB_Ping : boolean;
begin
  result:=False;
  if CmdBFB($02,[$14],1)<>BFB_OK then exit;
  if((ibfb.head.len<>2) or (ibfb.code.datab[0]<>$AA)) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  result:=True;
end;

function BFB_SendAT(S: String): boolean;
var
 i: integer;
 Buf: array [0..255] of Byte;
begin
  Result:=False;
  i:=Length(S);
  if i>255 then begin
    BFB_Error:=ERR_BFB_PAR;
    exit;
  end;
  Move(S[1],Buf,i);
  if SendBFB($06,Buf,i)<>BFB_OK then exit;
  result:=True;
end;

function BFB_PhoneModel: PChar;
begin
  result:=Nil;
  if CmdBFB($0E,[$07],1)<>BFB_OK then exit;
  if (ibfb.head.len<3) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  ibfb.code.datab[ibfb.head.len-1]:=0;
  Result:=@ibfb.code.datab;
end;

function BFB_PhoneFW: byte; // if $ff -> Error
begin
  result:=$ff;
  if CmdBFB($0E,[$03],1)<>BFB_OK then exit;
  if (ibfb.head.len<>2) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  Result:=ibfb.code.datab[0];
end;

function BFB_GetImei: PChar;
begin
  result:=Nil;
  if CmdBFB($0E,[$0A],1)<>BFB_OK then exit;
  if (ibfb.head.len<$11) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  ibfb.code.datab[ibfb.head.len-1]:=0;
  Result:=@ibfb.code.datab[1];
end;

function BFB_GetLg: PChar;
begin
  result:=Nil;
  if CmdBFB($0E,[$09],1)<>BFB_OK then exit;
  if (ibfb.head.len<$11) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  ibfb.code.datab[ibfb.head.len-1]:=0;
  Result:=@ibfb.code.datab;
end;

function BFB_GetSecurityMode(var mode : byte) : boolean;
begin
  result:=False;
  mode:=$FF;
  if CmdBFB($0E,[$0C],1)<>BFB_OK then exit;
  if (ibfb.head.len<2) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   mode:=$FE;
   exit;
  end;
  mode:=ibfb.code.datab[0];
  result:=True;
end;

function BFB_SecurityMode : String;
begin
  result:='Error';
  if CmdBFB($0E,[$0C],1)<>BFB_OK then exit;
  if (ibfb.head.len<2) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  Case ibfb.code.datab[0] of
   00: Result:='Repair';
   01: Result:='Developer';
   02: Result:='Factory';
   03: Result:='Customer';
   else
    Result:='Unknown('+IntToHex(ibfb.code.datab[0],2)+')';
  end;
end;

function BFB_FlagStatus : Byte; // if $ff -> Error
begin
  result:=$ff;
  if CmdBFB($0E,[$05],1)<>BFB_OK then exit;
  if (ibfb.head.len<>2) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  Result:=ibfb.code.datab[0];
end;

function BFB_to_BFC : boolean;
begin
  if SendBFB($01,[$04],1)<>BFB_OK then result := False
  else begin
   ReadBFB;
   result := True;
  end;
//  if result=BFB_OK then
end;

function SetSpeedBFB(Baud:integer): boolean;
var
 save_baud,i,z : integer;
 Buf: array [0..32] of Byte;
begin
  result:=False;
  i:=0;
  while bfbcomspd[i].spd <> Baud do begin
   inc(i);
   if (bfbcomspd[i].spd=0) then begin
    BFB_Error:=ERR_BFB_PAR;
    exit;
   end;
  end;
  save_baud:=dcb.BaudRate;
  if Baud>115200 then begin
   if not ChangeComSpeed(Baud) then exit;
   if not ChangeComSpeed(save_baud) then exit;
  end;
  if Not BFB_Ping then exit;
//  BFB_Error:=SendBFB($01,[$A1],1);
//  if BFB_Error<>BFB_OK then exit;
//  BFB_Error:=ReadBFB;
//  if BFB_Error<>BFB_OK then exit;
//  if not ((ibfb.head.len<>0) and ((ibfb.code.cmdb and $8F)=$83)) then exit;
  Buf[0]:=$C0;
  z:=Length(bfbcomspd[i].code);
  Move(bfbcomspd[i].code[1],Buf[1],z);
  if CmdBFB($01,buf,z+1)<>ERR_BFB_RD_CMD then exit;
  if ((ibfb.head.len=1) or (ibfb.code.cmdb=$CC)) then begin
    if not ChangeComSpeed(Baud) then exit;
    sleep(50);
    result:=BFB_Ping;
  end;
end;

function BFBReadMem(Addr: Dword; Len : Word; var Buffer : Array of Byte): boolean;
var
bfbrdmem: sbfbrdmem;
begin
   result:=False;
   if Len>31 then begin
    BFB_Error:=ERR_BFB_PAR;
    exit;
   end;
   bfbrdmem.subcmd:=$02;
   bfbrdmem.addr:=Addr;
   bfbrdmem.len:=Len;
   if CmdBFB($02,bfbrdmem.b,7)<>BFB_OK then exit;
   if (ibfb.head.len<>len+1) then begin
    BFB_Error:=ERR_BFB_RD_CMD;
    exit;
   end;
   BFB_Error:=BFB_OK;
   Move(ibfb.code.datab,Buffer,len);
   result:=True;
end;

function BFB_GetESN(var ESN: Dword): boolean;
begin
//  ESN:=$FFFFFFFF;
  result:=False;
  if CmdBFB($05,[$23],1)<>BFB_OK then exit;
  if (ibfb.head.len<>5) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  ESN:=Dword((@ibfb.code.datab)^);
  result:=True;
end;

function BFB_GetHWID(var HW: word): boolean;
begin
  result:=False;
  if CmdBFB($05,[$21],1)<>BFB_OK then exit;
  if (ibfb.head.len>=3) then begin
   HW:=word((@ibfb.code.datab)^);
   result:=True;
  end
  else BFB_Error:=ERR_BFB_RD_CMD;
end;

function BFB_SendSkey(xSkey: dword): boolean;
var
s : string;
buf : array[0..8] of byte;
begin
  result:=False;
  buf[0]:=Ord('X');
  s:=IntToStr(xSkey);
  while dword(length(s))<8 do s:='0'+s;
  Move(s[1],buf[1],8);
  if CmdBFB($0B,buf,9)<>BFB_OK then exit;
  result:=True;
end;

function BFB_SimulateChipCard : boolean;
begin
  result:=False;
  if CmdBFB($05,[$39],1)<>BFB_OK then exit;
  if ibfb.head.len<>1 then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  result:=True;
end;

function BFB_PhoneOff : boolean;
begin
  result:=False;
  if CmdBFB($0E,[$04],1)<>BFB_OK then exit;
  if ibfb.head.len<>1 then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  result:=True;
end;
// < 14 04 10 15 FB 14 FA
// > 14 02 16 32 32
// > 14 04 10 15 FC 14 FD
// < 14 05 11 15 1E 00 00 0B
// > 14 04 10 15 01 14 00
// < 14 05 11 15 38 00 00 2D

function BFB_EE_Get_Block_Info(num : dword; var len: dword; var ver: byte): boolean;
var
EEP_GetInfo: T_BFB_EEP_GetInfo;
begin
  result:=False;
  if num>=5000 then begin
   EEP_GetInfo.cmd:=$15;
  end
  else begin
   EEP_GetInfo.cmd:=$05;
  end;
  EEP_GetInfo.num:=num;
  BFB_Error:=CmdBFB_CHK($14,EEP_GetInfo.b,sizeof(EEP_GetInfo));
  if BFB_Error=BFB_OK then begin
   if (ibfb.head.len>=$5) then begin
    len := word(Pointer((@ibfb.code.datab[0])^));
    ver := ibfb.code.datab[2];
    result:=True;
   end
   else BFB_Error:=ERR_BFB_DATA;
  end;
//  else if (BFB_Error=ERR_BFB_RD_CMD)and(ibfb.head.len=$2)and(ibfb.data[0]=$32) then BFB_Error:=ERR_BFB_EEPBLKNONE
end;
// 14 08 1C 14 01 14 00 00 1E 00 1F
// 14 20 34 14 FE CF
function BFB_EE_Read_Block_(num,off,len : dword; var buf: array of byte ): boolean;
var
EEP_Read_Block :T_EEP_Read_Block;
begin
  result:=False;
{  if len=0 then begin
   BFB_Error:=ERR_BFB_PAR;
   exit;
  end; }
  if num>=5000 then begin
   EEP_Read_Block.cmd:=$14;
  end
  else begin
   EEP_Read_Block.cmd:=$04;
  end;
  EEP_Read_Block.num:=num;
  EEP_Read_Block.off:=off;
  EEP_Read_Block.len:=len;
  BFB_Error:=CmdBFB_CHK($14,EEP_Read_Block.b,sizeof(EEP_Read_Block));
  if (BFB_Error=BFB_OK)
  and (dword((ibfb.head.len-2))=len)
  then begin
    move(ibfb.data[1],buf[0],ibfb.head.len-2);
    result:=True;
    exit;
  end;
  BFB_Error:=ERR_BFB_DATA;
end;

function BFB_EE_Read_Block(num,off,len : dword; var buf: array of byte ): boolean;
const
DEFRAG_BLK_SIZE = $1E;
var
xoff,xlen : dword;
begin
    result:=False;
    SetComRxTimeouts(100,2,200);
    if len=0 then exit;
    if len>DEFRAG_BLK_SIZE then begin
     xoff:=0;
     while(xoff<len) do begin
      if (len-xoff)>=DEFRAG_BLK_SIZE then xlen:=DEFRAG_BLK_SIZE
      else xlen:=len-xoff;
      result:=BFB_EE_Read_Block_(num,xoff,xlen,buf[xoff]);
      if Not result then break;
      inc(xoff,xlen);
     end;
    end
    else result:=BFB_EE_Read_Block_(num,off,len,buf);
end;
// 14 04 10 17 01 15 03  
// 14 02 16 17 17
// 14 02 16 08 08 - Error
function BFB_EE_Del_block(num: dword): boolean;
var
EEP_del_blk: T_BFB_EEP_GetInfo;
begin
  result:=False;
  if num>=5000 then begin
   EEP_del_blk.cmd:=$17;
  end
  else begin
   EEP_del_blk.cmd:=$07;
  end;
  EEP_del_blk.num:=num;
  BFB_Error:=CmdBFB_CHK($14,EEP_del_blk.b,sizeof(EEP_del_blk));
  if BFB_Error<>BFB_OK then exit;
  result:=True
end;
// < 14 07 13 11 01 15 5E 00 00 5B
// > 14 02 16 11 11
function BFB_EE_Create_Block(num,len,ver: dword) : boolean;
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
  BFB_Error:=CmdBFB_CHK($14,EEP_Create_Block.b,sizeof(EEP_Create_Block));
  if BFB_Error<>BFB_OK then exit;
  result:=True;
end;
// 14 1A 0E 12 01 15 00 00 69 FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 90
// 14 02 16 12 12
function BFB_EE_Write_Block(num,off,len : dword; var buf: array of byte ): boolean;
var
EEP_Write_Block : T_EEP_Write_Block;
cur : dword;
begin
  result:=False;
  if len=0 then begin
    BFB_Error:=ERR_BFB_PAR;
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
    BFB_Error:=ERR_BFB_PAR;
  end;
  while(len<>0) do begin
   if (len>sizeof(EEP_Write_Block.data)) then cur:=sizeof(EEP_Write_Block.data)
   else cur:=len;
   move(buf[off],EEP_Write_Block.data[0],cur);
   EEP_Write_Block.off:=off;
   BFB_Error:=CmdBFB_CHK($14,EEP_Write_Block.b,cur+6);
   if BFB_Error<>BFB_OK then exit;
   off:=off+cur;
   len:=len-cur;
  end; // while
  result:=True;
end;
//< 14 04 10 13 01 15 07
//> 14 02 16 13 13
function BFB_EE_Finish_Block(num : dword) : boolean;
var
EEP_end_blk: T_BFB_EEP_GetInfo;
begin
  result:=False;
  if num>=5000 then begin
   EEP_end_blk.cmd:=$13;
  end
  else begin
   EEP_end_blk.cmd:=$03;
  end;
  EEP_end_blk.num:=num;
  BFB_Error:=CmdBFB_CHK($14,EEP_end_blk.b,sizeof(EEP_end_blk));
  if BFB_Error<>BFB_OK then exit;
  result:=True;
end;

function BFB_EELITE_Format : boolean;
var
buf : array[0..1] of byte;
begin
  result:=False;
  SetComRxTimeouts(2500,200,2500);
  buf[0]:=$09;
  BFB_Error:=CmdBFB_CHK($14,buf,Sizeof(buf));
  SetComRxTimeouts(500,2,500);
  if BFB_Error=BFB_OK then result:=True;
end;

function BFB_EEFULL_Format : boolean;
var
buf : array[0..1] of byte;
begin
  result:=False;
  SetComRxTimeouts(2500,200,2500);
  buf[0]:=$1B;
  BFB_Error:=CmdBFB_CHK($14,buf,Sizeof(buf));
  SetComRxTimeouts(500,2,500);
  if BFB_Error=BFB_OK then result:=True;
end;

function BFB_EELITE_MaxIndexBlk(var num : dword) : boolean;
var
buf : array[0..1] of byte;
begin
  result:=False;
  buf[0]:=$06;
  BFB_Error:=CmdBFB_CHK($14,buf,Sizeof(buf));
  if BFB_Error<>BFB_OK then exit;
  if (ibfb.head.len>=$4) then begin
   num := word(Pointer((@ibfb.code.datab[0])^));
   result:=True;
  end
  else BFB_Error:=ERR_BFB_DATA;
end;

function BFB_EEFULL_MaxIndexBlk(var num : dword) : boolean;
var
buf : array[0..1] of byte;
begin
  result:=False;
  buf[0]:=$16;
  BFB_Error:=CmdBFB_CHK($14,buf,Sizeof(buf));
  if BFB_Error<>BFB_OK then exit;
  if (ibfb.head.len>=$4) then begin
   num := word(Pointer((@ibfb.code.datab[0])^));
   result:=True;
  end
  else BFB_Error:=ERR_BFB_DATA;
end;
// 14 02 16 08 08
// 14 0E 1A 08 06 CF 01 00 26 CF 01 00 26 CF 01 00 C0
function BFB_EELITE_GetBufferInfo(var freeb,freea,freed : dword) : boolean;
var
buf : array[0..1] of byte;
begin
  result:=False;
  buf[0]:=$08;
  BFB_Error:=CmdBFB_CHK($14,buf,Sizeof(buf));
  if BFB_Error<>BFB_OK then exit;
  if (ibfb.head.len>=$0E) then begin
   freeb := Dword(Pointer((@ibfb.code.datab[0])^));
   freea := Dword(Pointer((@ibfb.code.datab[4])^));
   freed := Dword(Pointer((@ibfb.code.datab[8])^));
   result:=True;
  end
  else BFB_Error:=ERR_BFB_DATA;
end;

function BFB_EEFULL_GetBufferInfo(var freeb,freea,freed : dword) : boolean;
var
buf : array[0..1] of byte;
begin
  result:=False;
  buf[0]:=$18;
  BFB_Error:=CmdBFB_CHK($14,buf,Sizeof(buf));
  if BFB_Error<>BFB_OK then exit;
  if (ibfb.head.len>=$0E) then begin
   freeb := Dword(Pointer((@ibfb.code.datab[0])^));
   freea := Dword(Pointer((@ibfb.code.datab[4])^));
   freed := Dword(Pointer((@ibfb.code.datab[8])^));
   result:=True;
  end
  else BFB_Error:=ERR_BFB_DATA;
end;

//< 14 03 17 51 00 51
//> 14 02 16 34 34
//....
//< 14 03 17 51 05 54
//> 14 03 17 51 05 54
function BFB_DeleteInstance(num : Byte) : boolean;
var
buf : array[0..2] of byte;
begin
  result:=False;
  buf[0]:=$51;
  buf[1]:=num;
  BFB_Error:=CmdBFB_CHK($14,buf,Sizeof(buf));
  if BFB_Error<>BFB_OK then exit;
  if (ibfb.head.len>=$3) and (ibfb.code.datab[0]=num) then result:=True
  else BFB_Error:=ERR_BFB_DATA;
end;

function BFB_SetDisplayContrast(Contrast : Byte) : boolean;
begin
  result:=False;
  BFB_Error:=CmdBFB($05,[$10,Contrast],2);
  if BFB_Error<>BFB_OK then exit;
  result:=True;
end;

function BFB_ControlLight(Light : Byte) : boolean;
begin
  result:=False;
  BFB_Error:=CmdBFB($05,[$46,Light],2);
  if BFB_Error<>BFB_OK then exit;
  result:=True;
end;

function BFB_GetDisplayType(var id: byte): boolean;
begin
  result:=False;
  if CmdBFB($05,[$14],1)<>BFB_OK then exit;
  if (ibfb.head.len<2) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  id:=ibfb.code.datab[0];
  result:=True;
end;


function BFB_ReadSensors(var x: dword): boolean;
begin
  result:=False;
  if CmdBFB($05,[$35,0,0],3)<>BFB_OK then exit;
  if (ibfb.head.len<5) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  x:=ibfb.code.datad[0];
  result:=True;
end;

function BFB_GetBatteryVoltage(var UmV: word): boolean;
begin
  result:=False;
  if CmdBFB($0E,[$02],1)<>BFB_OK then exit;
  if (ibfb.head.len<3) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  UmV:=ibfb.code.dataw[0];
  result:=True;
end;

function BFB_GetMobileMode(var x: word): boolean;
begin
  result:=False;
  if CmdBFB($05,[$3F],1)<>BFB_OK then exit;
  if (ibfb.head.len<3) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  x:=ibfb.code.dataw[0];
  result:=True;
end;

function BFB_Freeze(xIMEI: string; var x: word): boolean;
var
buf : array[0..16] of byte;
begin
  result:=False;
  if length(xIMEI)<>15 then begin
   BFB_Error:=ERR_BFB_PAR;
   exit;
  end;
  move(xIMEI[1],buf[1],15);
  buf[0]:=$52;
  if CmdBFB_CHK($14,buf,17)<>BFB_OK then exit;
  if (ibfb.head.len<3) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  x:=ibfb.code.dataw[0];
  result:=True;
end;

function BFB_ReadDSPFirmwareVersion(var dspver: word): boolean;
begin
  result:=False;
  if CmdBFB($05,[$53],1)<>BFB_OK then exit;
  if (ibfb.head.len<3) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  dspver:=ibfb.code.dataw[0];
  result:=True;
end;

function BFB_ReadPowerAsicProject(var num: byte): boolean;
begin
  result:=False;
  if CmdBFB($05,[$4F],1)<>BFB_OK then exit;
  if (ibfb.head.len<2) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  num:=ibfb.code.datab[0];
  result:=True;
end;

// 01 - RF Chipset, 04 - PowerAmpl
function BFB_GetHardwareInf(x : byte; var num: byte): boolean;
begin
  result:=False;
  if CmdBFB($05,[$24,x],2)<>BFB_OK then exit;
  if (ibfb.head.len<3) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  num:=ibfb.code.datab[1];
  result:=True;
end;

function BFB_GoSwup(spd: dword): boolean;
begin
  result:=False;
  if CmdBFB($0E,[$20,0,Byte(spd),Byte(spd shr 8),Byte(spd shr 16),Byte(spd shr 24)],6)<>BFB_OK then exit;
  if (ibfb.head.len<6) then begin
   BFB_Error:=ERR_BFB_RD_CMD;
   exit;
  end;
  result:=True;
end;


end.
