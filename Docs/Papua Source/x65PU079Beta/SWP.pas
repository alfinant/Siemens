unit SWP;

interface
uses Windows,SysUtils,ComPort;

const
MAXSWPDATA  = 1024;
MAXSWPBSIZE = MAXSWPDATA+7;  // + addr : DWORD; len  : WORD; chk : byte

  ERR_NO            =0;
  ERR_X             =-1;
  ERR_SWP_PAR       =-2;

  ERR_SWP_IN_CRC16  =-3;
  ERR_SWP_RD_CMD    =-4;
  ERR_SWP_INIT_HID  =-5;
  ERR_SWP_DATA      =-6;
  ERR_SWP_INFO      =-7;
  ERR_SWP_IO_RS     =-15;

type

 rswphead = packed record case byte of // Swup Head
  0:(
     addr : DWORD; // Motorola (hi,mb,mb,lo)
     len  : WORD; );  // Motorola (hi,lo)
  1:(
     idx  : DWORD; //
     size : WORD; );  // Motorola (hi,lo)
 end;
 rswpblk = packed record case byte of // Swup blk
   0: (
       addr : DWORD; // Motorola (hi,mb,mb,lo)
       size : WORD;  // Motorola (hi,lo)
       data : array[0..MAXSWPDATA-1] of Byte ;
       chk  : byte; );
   1: (
       indx : DWORD;
       len : WORD;
       cmdb : byte; );
   2: (
       b  : array[0..MAXSWPBSIZE-1] of byte;
       lenblk : dword );
 end;
var
 swperr : integer;
 swpblk :  rswpblk;
 HeadSMP : pchar = 'Siemens Mobile Phones:SOFTWARE:01.00';
 SAG_JK_WH : pchar = 'SAG_JK_WH';
 CPPV : pchar = '(c) PV`, PapuaSoft & PapuaHard.';
// chkdata : byte = 0;
// HeadSBC : pchar = 'SIEMENS_BOOTCODE';


procedure SWPblkHeadSMP;
procedure SWPblkSizeXBI(size: dword );
function SWPblkData(addr: dword; lenbuf: integer; var buf: array of byte ): integer;
function SWPblkFE(cmdb: byte; lenbuf: integer; buf: array of byte ): integer;
function SWPblkFEs(cmdb: byte; strx : string): integer;
function SWPblkFEstr(cmdb: byte; str : string): integer;
function SWPblk23SizeFlash(size: dword ): boolean;
function SWPblk10Ver(ver: word): boolean;
function SWPblk11Ver(ver: word): boolean;
function SWPblk30EraseBlk(start_addr, end_addr: dword ): boolean;

implementation

procedure SWPblkSetChk;
var
i : integer;
chk : byte;
begin
    chk:=0;
    i:=0;
    while(dword(i)<swpblk.lenblk) do begin
     chk:=swpblk.b[i] xor chk;
     inc(i);
    end;
    swpblk.b[swpblk.lenblk]:=chk;
    inc(swpblk.lenblk);
end;

procedure CodeStrSwp(buf : pointer ; size : integer);
var
i : integer;
begin
  i:=length(HeadSMP);
  while size>0 do begin
    Byte(buf^):=Byte(buf^) xor Byte(HeadSMP[i]);
    dec(i); inc(dword(buf)); dec(size);
    if i=0 then i:=length(HeadSMP);
  end;
end;

procedure SWPblkHeadSMP;
var
ssmp : integer;
begin
  ssmp := length(HeadSMP);
  move(HeadSMP[0],swpblk.b,ssmp);
  swpblk.b[ssmp]:=$1A;
  swpblk.lenblk := ssmp+1;
end;

procedure SWPblkSizeXBI(size: dword );
var
i : integer;
begin
    for i:=0 to 31 do begin
     if (size and 1)<>0 then swpblk.b[i]:=$80
     else swpblk.b[i]:=$00;
     size := size shr 1;
    end;
    Move(CPPV[0],swpblk.b[32],32);
    i := length(HeadSMP);
    Move(HeadSMP[0],swpblk.b[64],i);
    swpblk.lenblk := 64+i+5;
    swpblk.b[64+i+0]:=0;
    swpblk.b[64+i+1]:=0;
    swpblk.b[64+i+2]:=0;
    swpblk.b[64+i+3]:=0;
    swpblk.b[64+i+4]:=0;
    i := length(SAG_JK_WH);
    Move(SAG_JK_WH[0],swpblk.b[swpblk.lenblk],i);
    swpblk.lenblk := swpblk.lenblk+dword(i);
end;

function SWPblkData(addr: dword; lenbuf: integer; var buf: array of byte ): integer;
//var
//i : integer;
begin
   if ((lenbuf > MAXSWPDATA) or (addr < $A0000000) or (addr > $A8000000)) then result:=ERR_SWP_PAR
   else begin
    swpblk.addr:=(addr shl 24) or (addr shr 24 ) or ((addr shr 8 ) and $FF00) or ((addr shl 8 ) and $FF0000);
    swpblk.size:=Swap(lenbuf);
    Move(buf,swpblk.data,lenbuf);
//    for i:=0 to lenbuf-1 do chkdata:=chkdata xor swpblk.data[i];
    swpblk.lenblk := lenbuf + sizeof(rswphead);
    SWPblkSetChk;
    result:=ERR_NO;
   end;
   swperr:=result;
end;

function SWPblkFE(cmdb: byte; lenbuf: integer; buf: array of byte ): integer;
begin
   if (lenbuf >= MAXSWPDATA-1) then result:=ERR_SWP_PAR
   else begin
    swpblk.indx:=$FEFFFFFF;
    swpblk.size:=Swap(lenbuf+sizeof(cmdb));
    swpblk.cmdb:=cmdb;
    if lenbuf<>0 then Move(buf,swpblk.data[sizeof(cmdb)],lenbuf);
    swpblk.lenblk := lenbuf + sizeof(rswphead) + sizeof(cmdb);
    SWPblkSetChk;
    result:=ERR_NO;
   end;
   swperr:=result;
end;

function SWPblkFEstr(cmdb: byte; str : string): integer;
var
lenbuf : integer;
begin
   lenbuf := length(str);
   if (lenbuf >= MAXSWPDATA-1) then result:=ERR_SWP_PAR
   else begin
    swpblk.indx:=$FEFFFFFF;
    swpblk.size:=Swap(lenbuf+sizeof(cmdb));
    swpblk.cmdb:=cmdb;
    Move(str[1],swpblk.data[sizeof(cmdb)],lenbuf);
    CodeStrSwp(@swpblk.data[sizeof(cmdb)],lenbuf);
    swpblk.lenblk := lenbuf + sizeof(rswphead) + sizeof(cmdb);
    SWPblkSetChk;
    result:=ERR_NO;
   end;
   swperr:=result;
end;

function SWPblkFEs(cmdb: byte; strx : string): integer;
var
lenbuf : integer;
begin
   lenbuf := length(strx)+1;
   if (lenbuf >= MAXSWPDATA-1) then result:=ERR_SWP_PAR
   else begin
    swpblk.indx:=$FEFFFFFF;
    swpblk.size:=Swap(lenbuf+sizeof(cmdb));
    swpblk.cmdb:=cmdb;
    Move(strx[1],swpblk.data[sizeof(cmdb)],lenbuf);
    swpblk.data[sizeof(cmdb)+lenbuf]:=0;
    swpblk.lenblk := lenbuf + sizeof(rswphead) + sizeof(cmdb);
    SWPblkSetChk;
    result:=ERR_NO;
   end;
   swperr:=result;
end;

function SWPblk23SizeFlash(size: dword ): boolean;
var
buf : array[0..3] of byte;
begin
   buf[0]:=Byte(size shr 24);
   buf[1]:=Byte(size shr 16);
   buf[2]:=Byte(size shr 8 );
   buf[3]:=Byte(size);
   if SWPblkFE($23,4,buf) = ERR_NO
   then result:=True
   else result:=False;
end;

function SWPblk30EraseBlk(start_addr, end_addr: dword ): boolean;
var
buf : array[0..7] of byte;
begin
   buf[0]:=Byte(start_addr shr 24);
   buf[1]:=Byte(start_addr shr 16);
   buf[2]:=Byte(start_addr shr 8 );
   buf[3]:=Byte(start_addr);
   buf[4]:=Byte(end_addr shr 24);
   buf[5]:=Byte(end_addr shr 16);
   buf[6]:=Byte(end_addr shr 8 );
   buf[7]:=Byte(end_addr);
   if SWPblkFE($30,8,buf) = ERR_NO
   then result:=True
   else result:=False;
end;


function SWPblk10Ver(ver: word): boolean;
var
buf : array[0..1] of byte;
begin
   buf[0]:=Byte(ver shr 8);
   buf[1]:=Byte(ver);
   if SWPblkFE($10,2,buf) = ERR_NO
   then result:=True
   else result:=False;
end;

function SWPblk11Ver(ver: word): boolean;
var
buf : array[0..1] of byte;
begin
   buf[0]:=Byte(ver shr 8);
   buf[1]:=Byte(ver);
   if SWPblkFE($11,2,buf) = ERR_NO
   then result:=True
   else result:=False;
end;

function SWPblk12VerDateTime(vdate: string; vtime: string): boolean;
var
buf : array[0..17] of byte;
begin
   buf[0]:=Byte(vdate[1]);
   buf[1]:=Byte(vdate[2]);
   buf[2]:=Ord('.');
   buf[3]:=Byte(vdate[4]);
   buf[4]:=Byte(vdate[5]);
   buf[5]:=Ord('.');
   buf[6]:=Byte(vdate[7]);
   buf[7]:=Byte(vdate[8]);
   buf[8]:=$00;
   buf[9]:=Byte(vtime[1]);
   buf[10]:=Byte(vtime[2]);
   buf[11]:=Ord(':');
   buf[12]:=Byte(vtime[7]);
   buf[13]:=Byte(vtime[5]);
   buf[14]:=Ord(':');
   buf[15]:=Byte(vtime[8]);
   buf[16]:=Byte(vtime[8]);
   buf[17]:=$00;
   if SWPblkFE($12,18,buf) = ERR_NO
   then result:=True
   else result:=False;
end;

function SWPblk13VerDateTime(vdate: string; vtime: string): boolean;
var
buf : array[0..17] of byte;
begin
   buf[0]:=Byte(vdate[1]);
   buf[1]:=Byte(vdate[2]);
   buf[2]:=Ord('.');
   buf[3]:=Byte(vdate[4]);
   buf[4]:=Byte(vdate[5]);
   buf[5]:=Ord('.');
   buf[6]:=Byte(vdate[7]);
   buf[7]:=Byte(vdate[8]);
   buf[8]:=$00;
   buf[9]:=Byte(vtime[1]);
   buf[10]:=Byte(vtime[2]);
   buf[11]:=Ord(':');
   buf[12]:=Byte(vtime[7]);
   buf[13]:=Byte(vtime[5]);
   buf[14]:=Ord(':');
   buf[15]:=Byte(vtime[8]);
   buf[16]:=Byte(vtime[8]);
   buf[17]:=$00;
   if SWPblkFE($13,18,buf) = ERR_NO
   then result:=True
   else result:=False;
end;


{
S65_47.xbb
Просмотр блоков в XBI:
FECmd:10,Size:3,Data: 04 04
UpDate x date: 404
FECmd:11,Size:3,Data: 01 23
WinSwup x date: 135
FECmd:12,Size:18,Data: 30 05 1E 1E 00 1E 0A 70 72 70 65 6E 73 7C 69 0B 40
Version Date/Time: 05.01.05 12:53:13
FECmd:13,Size:18,Data: 30 01 1E 1F 03 1E 0A 71 72 70 60 6E 76 7B 69 08 40
Version Date/Time: 01.12.04 17:04:23
FECmd:16,Size:9,Data: 4F 76 76 67 72 79 7B 09
String: 'OFFICIAL'
FECmd:17,Size:8,Data: 62 5F 5F 5A 52 5F 48
String: 'bootcor'  Project Name 1*
FECmd:1A,Size:4,Data: 6C 57 00
LG pack: 'lg0'
FECmd:1B,Size:5,Data: 00 00 00 00
dword?: 0x00000000
FECmd:1D,Size:3,Data: 00 31
Software Version 31.00
FECmd:23,Size:5,Data: 02 00 00 00
Size FullFlash 0x02000000 bytes (32 Mbytes)
FECmd:24,Size:3,Data: 4B EA
word?: 0x4BEA
FECmd:25,Size:5,Data: A0 00 0A 00
Addr Flash 'EnableFlashWrite' = 0xA0000A00
FECmd:27,Size:5,Data: 00 00 00 00
dword?: 0x00000000
FECmd:28,Size:5,Data: 42 73 06 1B
MobileName: 'BC65' Project Name 2*
FECmd:29,Size:8,Data: 53 79 75 63 74 7E 69
MF Name: SIEMENS
FECmd:2A,Size:14,Data: 6D 51 59 40 6E 01 14 75 0D 17 65 66 66
String: 'main_1.0_V22 '  Project Name 3* Baseline Version
FECmd:30,Size:9,Data: A0 00 00 00 A0 01 FF FF
Erase Flash block addres 0xA0000000..0xA001FFFF
FECmd:31,Size:2,Data: 01
FECmd:32,Size:2,Data: 00
FECmd:33,Size:3,Data: 00 00
word?: 0x0000
FECmd:34,Size:2,Data: 07
Project Type: 07 'SGOLDLite-Projects(x65)'
FECmd:35,Size:2,Data: 01
FECmd:37,Size:9,Data: A0 00 08 E0 00 00 00 00
Flash Addres: 0xA00008E0, SW Code: 00 00 00 00
FECmd:38,Size:3,Data: 00 04
Use in SW-Transmittion word 0x0004
FECmd:39,Size:2,Data: 00
Compression Type: 00
FECmd:40,Size:2,Data: 00
Type UpDate: 0=MobSw

FECmd:50,Size:3,Data: 00 0E
Size 'Data Map Info' 14 bytes
FECmd:51,Size:15,Data: 02 01 00 10 FF FF FF FF FF FF FF FF FF FF  xbb
//FECmd:51,Size:15,Data: 02 01 43 01 FF FF FF FF FF FF FF FF FF FF xfs
//FECmd:51,Size:15,Data: 02 01 90 01 FF FF FF FF FF FF FF FF FF FF  xbi
Block 'Data Map Info'
FECmd:52,Size:1
End 'Data Map Info'



FECmd:60,Size:2,Data: 00
FECmd:61,Size:13,Data: 6B 5C 56 71 53 5F 55 31 31 2E 25 31
String: 'klf_bootcore'  Database Name*
FECmd:62,Size:14,Data: 6D 51 59 40 6E 01 14 75 0D 17 65 66 66
String: 'main_1.0_V22 ' Project Name 4*
FECmd:63,Size:23,Data: 4D 6F 52 41 5E 44 59 2A 20 24 08 00 0E 10 3E 5B 1A 0B 31 5E 46 60
String: 'M_bootcore_TH_main_1.0' Baseline Release*
FECmd:64,Size:5,Data: 42 43 36 35
NameMobile: BC65
FECmd:70,Size:14,Data: 01 77 73 77 5F 72 36 35 2E 64 6C 6C 00
FileDll: 'wsw_r65.dll'
FECmd:04,Size:1
End Info-blocks
Test End = 0

Общая инфа по файлу XBI:
База блока SIGNATURE 	0x00000000,
База блока SOFTWARE 	0x00000025,
Старт блоков COMMAND 	0x00000025,
База блока HASH_AREA 	0x00000000,
Конец блока SOFTWARE 	0x0001EB31.
Итого:
Комманд Swup-у	36,
Блоков  HASH	0,
Комманд DataInfo	0,
Блоков данных	131,
Всего блоков	167
Ok.
}

end.
