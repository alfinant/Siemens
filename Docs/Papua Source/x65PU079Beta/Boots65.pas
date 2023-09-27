//Использование в коммерческих целях запрещено.
//Наказание - неминуемый кряк и распространение по всему инет.
//Business application is forbidden.
//Punishment - unavoidable crack and propagation on everything inet.
unit Boots65;

interface
uses Windows,SysUtils,ComPort,HwProject;

type

eSRV_BOOT=(SERVICE_MODE,BURNIN_MODE,NORMAL_MODE);
ePV_BOOT=(TP_MODE,INFO_MODE);//,FLASH_MODE);

rHeadBootInfo = packed record case byte of
 0: (
  cTelName : array[0..15] of char;
  cTelSiem : array[0..15] of char;
  cTelImei : array[0..15] of char;
  bTelHash : array[0..15] of byte;
  dFlashBase : dword;
  dFlashESN : array[0..2] of dword;
  wFlashID0 : word;
  wFlashID1 : word;
  bFlashSize : byte; // Size of flash = 2^N
  wFlashLenB : word; //size of write-buffer (not used by program)
  bNumRegs : byte; // number of regions.
  wCFIbuf  : array[0..13] of word; // number of blocks in 1st region = N+1, size of blocks in 1st region = N*256
  dFlashESN1 : dword;
  bOtpImei : array[0..7] of byte;
   );
 1: ( b : array[0..127] of  byte; );
end;

rHeadBootR65 = packed record
        code    : array[0..$27] of BYTE;
        idSB    : array[0..15] of BYTE;
        par     : DWORD;
        subpar  : DWORD;
        bootkey : array[0..15] of BYTE;
end;

rSrvBootR65 = packed record case byte of
  0: (  head    : rHeadBootR65;
        srvpar  : array[0..$6] of BYTE; );
  1: (  b       : array[0..$56] of BYTE; );
end;

rBufSrvBootR65 = packed record case byte of
  0: (  cmd     : BYTE;
        size    : WORD;
        Boot    : rSrvBootR65;
        chk     : BYTE; );
  1: (  b       : array[0..$5A] of BYTE; );
end;

function CreateSrvBoot(SRV_BOOT_TYPE: eSRV_BOOT; var BufSrvBoot: rBufSrvBootR65) : boolean;
procedure Ignition;
function SendSrvBoot(SRV_BOOT_TYPE: eSRV_BOOT): boolean;

implementation
var
srvsubpars : array[0..2] of array[0..$6] of BYTE = (
        ($01,$04,$05,$00,$8B,$00,$8B), // service mode
        ($01,$04,$05,$80,$83,$00,$03), // burnin mode
        ($01,$04,$05,$00,$89,$00,$89) );  //normal mode
idSB    : array[0..15] of BYTE = (
       $53,$49,$45,$4D,$45,$4E,$53,$5F,$42,$4F,$4F,$54,$43,$4F,$44,$45);
bcode : array[0..$27] of BYTE = (
       $F1,$04,$A0,$E3,$20,$10,$90,$E5,$FF,$10,$C1,$E3,$A5,$10,$81,$E3,
       $20,$10,$80,$E5,$1E,$FF,$2F,$E1,$04,$01,$08,$00,$00,$00,$00,$00,
       $00,$00,$00,$00,$00,$00,$00,$00);


function CreateSrvBoot(SRV_BOOT_TYPE: eSRV_BOOT; var BufSrvBoot: rBufSrvBootR65) : boolean;
var
i : integer;
begin
    result := FALSE;
    if DWORD(SRV_BOOT_TYPE)>2 then exit;
    Move(srvsubpars[integer(SRV_BOOT_TYPE)],BufSrvBoot.boot.srvpar,sizeof(BufSrvBoot.boot.srvpar));
    BufSrvBoot.boot.head.subpar:=0;
    BufSrvBoot.boot.head.par:=$70001;
    BufSrvBoot.cmd:=$30;
    BufSrvBoot.size:=sizeof(rSrvBootR65);
    Move(bcode,BufSrvBoot.boot.head.code,sizeof(BufSrvBoot.boot.head.code));
    Move(idSB,BufSrvBoot.boot.head.idSB,sizeof(BufSrvBoot.boot.head.idSB));
    FillChar(BufSrvBoot.boot.head.bootkey,sizeof(BufSrvBoot.boot.head.bootkey),$00);
    BufSrvBoot.chk:=0;
    for i:=0 to (sizeof(BufSrvBoot.Boot)-1) do BufSrvBoot.chk:=BufSrvBoot.chk xor BufSrvBoot.Boot.b[i];
    result := TRUE;
end;


procedure Ignition;
begin
        EscapeComFunction(CLRRTS);
        EscapeComFunction(CLRDTR);
        sleep(100);
        EscapeComFunction(SETDTR);
        EscapeComFunction(SETRTS);
//        sleep(100);
end;

function SendSrvBoot(SRV_BOOT_TYPE: eSRV_BOOT): boolean;
var
BufSrvBoot: rBufSrvBootR65;
i : integer;
begin
    result := False;
    if not CreateSrvBoot(SRV_BOOT_TYPE,BufSrvBoot) then exit;
    if not WriteCom(@BufSrvBoot,sizeof(BufSrvBoot)) then exit;
    i:=0;
    if not ReadCom(@i,2) then exit;
    if (i=$06B1)  then begin
       NewSGold:=False;
       result := True;
    end;
    if (i=$06C1)  then begin
       NewSGold:=True;
       result := True;
    end;
end;


end.


