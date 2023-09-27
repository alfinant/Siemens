unit SWPio;

interface
uses Windows,SysUtils,ComPort;

const
MAXSWPDATA  = $40;
MAXSWPBSIZE = MAXSWPDATA+5;  // indx : DWORD;  chk : byte

  SWP_OK            =1;
  ERR_NO            =0;
  ERR_X             =-1;
  ERR_SWP_PAR       =-2;
  ERR_SWP_IN_CRC16  =-3;
  ERR_SWP_RD_CMD    =-4;
  ERR_SWP_INIT_HID  =-5;
  ERR_SWP_DATA      =-6;
  ERR_SWP_INFO      =-7;
  ERR_SWP_CHK       =-9;
  ERR_SWP_TIMEOUT   =-14;
  ERR_SWP_IO_RS     =-15;

type

 rswphead = packed record case byte of // Swup Head
  0:(
     seg  : byte;
     off  : WORD; // Motorola (hi,lo)
     len  : byte; );
  1:(
     b1 : byte;
     b2 : byte;
     b3 : byte;
     bl : byte; );
  2:( dw  : DWORD; );
  3:( b  : array[0..3] of byte;);
 end;
 rswpblk = packed record case byte of // Swup blk
   0: (
       head : rswphead;
       data : array[0..MAXSWPDATA-1] of Byte ;
       chk  : byte; );
   1: (
       indx : rswphead;
       cmdb : byte; );
   2: (
       b  : array[0..MAXSWPBSIZE-1] of byte;
       size : integer );
 end;
var
 swperr : integer;
 swpblk :  rswpblk;
 oswp,iswp :  rswpblk;

function SWPblkData(addr: dword; lenbuf: integer; var buf: array of byte ): integer;
function SWPblkFF(cmdb: byte; lenbuf: integer; buf: array of byte ): integer;
function SendSWPdata(addr: dword; lenbuf: integer; var buf: array of byte ): boolean;
function SendSWPcmd(cmdb: byte; lenbuf: integer; buf: array of byte ): boolean;
function SendSWPok : boolean;
function ReadSWPcmd : boolean;
function ReadSWP : integer;

implementation

procedure SWPblkSetChk;
var
i : integer;
chk : byte;
begin
    chk:=0;
    i:=0;
    while(i<oswp.size) do begin
     chk:=oswp.b[i] xor chk;
     inc(i);
    end;
    oswp.b[oswp.size]:=chk;
    inc(oswp.size);
end;

function SWPblkData(addr: dword; lenbuf: integer; var buf: array of byte ): integer;
begin
   if ((lenbuf > MAXSWPDATA) or (addr >= $00FFFFFE)) then result:=ERR_SWP_PAR
   else begin
    oswp.head.b1:=Byte(addr shr 16 );
    oswp.head.b2:=Byte(addr shr 8 );
    oswp.head.b3:=Byte(addr);
    oswp.head.len:=Byte(lenbuf);
    Move(buf,oswp.data,lenbuf);
    oswp.size := lenbuf + sizeof(rswphead);
    SWPblkSetChk;
    result:=ERR_NO;
   end;
   swperr:=result;
end;

function SWPblkFE(cmdb: byte; lenbuf: integer; buf: array of byte ): integer;
begin
   if (lenbuf >= MAXSWPDATA-1) then result:=ERR_SWP_PAR
   else begin
    oswp.head.dw :=$FEFFF;
    oswp.head.len:=byte(lenbuf+sizeof(cmdb));
    oswp.cmdb:=cmdb;
    if lenbuf<>0 then Move(buf,oswp.data[sizeof(cmdb)],lenbuf);
    oswp.size := lenbuf + sizeof(rswphead) + sizeof(cmdb);
    SWPblkSetChk;
    result:=ERR_NO;
   end;
   swperr:=result;
end;

function SWPblkFF(cmdb: byte; lenbuf: integer; buf: array of byte ): integer;
begin
   if (lenbuf >= MAXSWPDATA-1) then result:=ERR_SWP_PAR
   else begin
    oswp.head.dw :=$FFFFF;
    oswp.head.len:=byte(lenbuf+sizeof(cmdb));
    oswp.cmdb:=cmdb;
    if lenbuf<>0 then Move(buf,oswp.data[sizeof(cmdb)],lenbuf);
    oswp.size := lenbuf + sizeof(rswphead) + sizeof(cmdb);
    SWPblkSetChk;
    result:=ERR_NO;
   end;
   swperr:=result;
end;

function ReadSWP : integer;
var
i : integer;
chk : byte;
begin
  iswp.size:=0;
  iswp.head.len:=0;
  result:=ERR_SWP_TIMEOUT;
  if not ReadCom(@iswp.b[0],1) then exit;
  if iswp.b[0]=$06 then begin
   result:=SWP_OK;
   exit;
  end
  else if iswp.b[0]<>$FF then begin
   result:=iswp.b[0] or $100;
   exit;
  end
  else if not ReadCom(@iswp.b[1],3) then exit;
  repeat begin
    if (iswp.head.b1=$FF)
    and (iswp.head.b2=$FF)
    and (iswp.head.b3=$FF)
    and (iswp.head.len<=MAXSWPDATA)
    and (iswp.head.len<>0)  then begin
     if not ReadCom(@iswp.data,iswp.head.len+1) then exit
     else begin
      chk:=$FF xor iswp.head.len;
      i:=0;
      while(byte(i)<iswp.head.len) do begin
       chk:=iswp.data[i] xor chk;
       inc(i);
      end;
      if iswp.data[i]<>chk then result:=ERR_SWP_CHK
      else result:=ERR_NO;
      exit;
     end;
    end;
    iswp.b[0]:=iswp.b[1];
    iswp.b[1]:=iswp.b[2];
    if not ReadCom(@iswp.b[2],1) then exit;
  end
  until true;
end;


function SendSWPdata(addr: dword; lenbuf: integer; var buf: array of byte ): boolean;
begin
   result:=False;
   if ((lenbuf > MAXSWPDATA) or (addr >= $00FFFFFE)) then begin
    swperr:=ERR_SWP_PAR;
    exit;
   end
   else begin
    oswp.head.b1:=Byte(addr shr 16 );
    oswp.head.b2:=Byte(addr shr 8 );
    oswp.head.b3:=Byte(addr);
    oswp.head.len:=Byte(lenbuf);
    Move(buf,oswp.data,lenbuf);
    oswp.size := lenbuf + sizeof(rswphead);
    SWPblkSetChk;
    if not WriteCom(@oswp.b,oswp.size) then swperr:=ERR_SWP_IO_RS
    else swperr:=ReadSWP;
   end;
   if swperr=SWP_OK then result:=True;
end;

function SendSWPcmd(cmdb: byte; lenbuf: integer; buf: array of byte ): boolean;
begin
   result:=False;
   if (lenbuf >= MAXSWPDATA-1) then begin
    swperr:=ERR_SWP_PAR;
    exit;
   end
   else begin
    oswp.head.b1:=$FF;
    oswp.head.b2:=$FF;
    oswp.head.b3:=$FF;
    oswp.head.len:=byte(lenbuf+sizeof(cmdb));
    oswp.cmdb:=cmdb;
    if lenbuf<>0 then Move(buf,oswp.data[sizeof(cmdb)],lenbuf);
    oswp.size := lenbuf + sizeof(rswphead) + sizeof(cmdb);
    SWPblkSetChk;
    if not WriteCom(@oswp.b,oswp.size) then swperr:=ERR_SWP_IO_RS
    else swperr:=ReadSWP;
   end;
   if (swperr=SWP_OK) or (swperr=ERR_NO) then result:=True;
end;

function ReadSWPcmd : boolean;
begin
   result:=False;
   swperr:=ReadSWP;
   if swperr=ERR_NO then result:=SendSWPok;
end;

function SendSWPok : boolean;
var
b : byte;
begin
   result:=False;
   b:=$06;
   if not WriteCom(@b,1) then swperr:=ERR_SWP_IO_RS
   else begin
    swperr:=ERR_NO;
    result:=True;
   end;
end;


end.
