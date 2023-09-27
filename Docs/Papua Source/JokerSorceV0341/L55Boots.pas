//Business application is forbidden.
//Punishment - unavoidable crack and propagation on everything inet.
unit l55boots;

{ $ DEFINE DEBUGLDR}

interface
uses Windows,SysUtils, ComPort, CryptEEP, HexUtils;

const
 MA50 = 0;
 MA51 = 1;
 MA55 = 2;
 MC55 = 3;
 MM55 = 4;
 MS55 = 5;
 MSL55 = 6;
 MA60 = 7;
 MA65 = 8;
 MMC60 = 9;
 MA70 = 10;
 MA75 = 11;
 MAX75 = 12; //MC110 = 12;
 MCF62 = 13;
 MSX1 = 14;
 MMAX = MSX1;

   tFFBase = 0;
   tFFSize = 1;
   tBCBase = 2;
   tBCSize = 3;
   tEEBase = 4;
   tEESize = 5;
   tLGBase = 6;
   tLGSize = 7;
   tT9Base = 8;
   tT9Size = 9;
   tESBase = 10;
   tESSize = 11;
   tFSBase = 12;
   tFSSize = 13;
   tFBBase = 14;
   tFBSize = 15;
   tFCBase = 16;
   tFCSize = 17;
   tFLSize = 18;

   nFullFlash = 0;
   nBootCore = 1;
   nEEPROM = 2;
   nLGPack = 3;
   nT9 = 4;
   nEE_FS = 5;
   nFFS = 6;
   nFFS_B = 7;
   nFFS_C = 8;
   nManual = 9;

{ BOOT_OK = $4B4F; // Ok
 BOOT_UC = $4355; // Unknown Command
 BOOT_AF = $4651; // Address is too Far
 BOOT_EF = $4645; // Entry not Found
}
type
 TBootType = (Boot_Normal,Boot_BCoreBag,Boot_BootKey, Boot_swup);
 tTabFlash = packed record
   FlashBase  : dword;
   FullSize   : dword;
   BCOREBase  : dword;
   BCORESize  : dword;
   EEPROMBase : dword;
   EEPROMSize : dword;
   LGPackBase : dword;
   LGPackSize : dword;
   T9Base : dword;
   T9Size : dword;
   FlashSize : dword;
 end;
 tEraseBlkRegs = packed record
   NumN  : word; // number of identical-size erase blocks +1
   SizeN : word; // region erase block(s) size are z x 256 bytes
 end;
 tCFI = packed record
   FlashSizeN  : word; // УnФ such that device size = n<<16 in number of bytes
//   BusType   : byte; // 01 = 16Bit
   WrBuffer  : byte; // Number of erase block regions (x) within device
   BlkRegs   : byte; // Number of erase block regions
   BlkReg    : array[0..8] of tEraseBlkRegs;
 end;
 tFlashInfo = packed record  case byte of
 00: (
   SegEELITE: word;
//   RamSize  : word;
   Flash1IM : word;
   Flash1ID : word;
   Flash2IM : word;
   Flash2ID : word;
   FSN  : dword;
   BCDIMEI : array[0..7] of byte;
   CFI : tCFI; );
 01: ( b : array[0..$3F] of Byte; );
 end;
var
 Model : integer = MA70;
 sBootErr : string;
 sBootModel : array[0..MMAX] of pchar =
 ('A50','A51','A55','C55','M55','S55','SL55','A60','A65','MC60','A70','A75','AX75','CF62','SX1');
 TabFlash : array[0..MMAX] of array[0..tFLSize] of dword =(
//  FFBase, FFSize, BCBase, BCSize, EEBase, EESize, LGBase, LGSize, T9Base, T9Size, ESBase, ESSize, FSBase, FSSize, FBBase, FBSize, FCBase, FCSize, FLSize
  ($800000,$0400000,$800000,$010000,$BF0000,$010000,$AC0000,$040000,$B80000,$030000,$BB0000,$020000,$000000,$000000,$000000,$000000,$000000,$000000,$0400000), //A50
  ($800000,$0400000,$800000,$020000,$BA0000,$060000,$B00000,$060000,$A80000,$040000,$000000,$000000,$000000,$000000,$000000,$000000,$000000,$000000,$0400000), //A51,52
  ($800000,$0800000,$800000,$020000,$FA0000,$060000,$DA0000,$060000,$880000,$040000,$E80000,$060000,$F40000,$040000,$000000,$000000,$000000,$000000,$0800000), //A55,A57  +
  ($800000,$0800000,$800000,$020000,$FA0000,$060000,$E00000,$080000,$880000,$040000,$E80000,$060000,$F00000,$080000,$000000,$000000,$000000,$000000,$0800000), //C55 +
  ($000000,$1000000,$800000,$010000,$FC0000,$030000,$7A0000,$060000,$880000,$040000,$BC0000,$030000,$D00000,$200000,$A80000,$070000,$000000,$000000,$1000000), //M55 ?
  ($400000,$0C00000,$800000,$010000,$FE0000,$020000,$F00000,$070000,$880000,$040000,$BC0000,$030000,$AC0000,$100000,$000000,$000000,$000000,$000000,$0C00000), //S55  +
  ($400000,$0C00000,$800000,$010000,$FE0000,$020000,$7A0000,$060000,$880000,$040000,$BC0000,$030000,$D00000,$1C0000,$A80000,$070000,$000000,$000000,$0C00000), //SL55
  ($800000,$0800000,$800000,$010000,$FC0000,$030000,$E00000,$050000,$000000,$000000,$000000,$000000,$E80000,$0A0000,$B00000,$050000,$000000,$000000,$0800000), //A60
  ($000000,$1000000,$800000,$010000,$7C0000,$030000,$600000,$060000,$000000,$000000,$000000,$000000,$D00000,$200000,$A00000,$0C0000,$000000,$000000,$1000000), //A65, C60 +
  ($000000,$1000000,$800000,$010000,$FC0000,$030000,$760000,$080000,$000000,$000000,$BC0000,$030000,$D00000,$200000,$A80000,$070000,$F00000,$060000,$1000000), //MC60
  ($800000,$0400000,$800000,$010000,$BC0000,$030000,$A00000,$040000,$AB0000,$050000,$000000,$000000,$000000,$000000,$000000,$000000,$000000,$000000,$0800000), //A70  +
  ($800000,$0800000,$800000,$010000,$FC0000,$030000,$E00000,$060000,$000000,$000000,$000000,$000000,$E80000,$0A0000,$D00000,$050000,$000000,$000000,$0800000), //A75  +
//  ($000000,$1000000,$800000,$020000,$7A0000,$060000,$600000,$060000,$000000,$000000,$000000,$000000,$D00000,$180000,$E80000,$0E0000,$A80000,$100000,$1000000), //AX75 +
  ($000000,$1000000,$800000,$020000,$7A0000,$060000,$600000,$060000,$000000,$000000,$BC0000,$040000,$D00000,$180000,$E80000,$0E0000,$A80000,$100000,$1000000), //AX75/72,C110 +
  ($000000,$1000000,$800000,$010000,$FC0000,$030000,$760000,$060000,$880000,$040000,$BC0000,$030000,$CD0000,$1B0000,$E80000,$0E0000,$A80000,$100000,$1000000), //CF62 ?
  ($800000,$0800000,$800000,$020000,$FE0000,$020000,$A60000,$020000,$000000,$000000,$000000,$000000,$000000,$000000,$000000,$000000,$000000,$000000,$0800000)  //SX1
//($800000,$0400000,$800000,$010000,$BF0000,$010000,$B80000,$020000,$AC0000,$040000,$9C0000,$030000,$000000,$000000,$000000,$000000,$000000,$000000,$0400000), //M50
 );
 TabBootBaud : array[0..2] of array[1..3] of array[0..4] of byte =(
  (($42,$09,$00,$6B,$01), // 115200 00 C2 01 00 A55
  ($42,$02,$00,$B4,$01),  // 460800 00 08 07 00
  ($42,$00,$00,$1A,$01)), // 921600 00 10 0E 00

  (($42,$04,$00,$6B,$01), // 115200 00 C2 01 00 A70
  ($42,$00,$00,$22,$01),  // 460800 00 08 07 00
  ($42,$06,$00,$FC,$01)), // 921600 00 10 0E 00

  (($42,$06,$00,$FC,$01), // 115200 00 C2 01 00 A50
  ($42,$00,$00,$22,$01), // 460800 00 08 07 00
  ($42,$00,$00,$1A,$01))); // 921600 00 10 0E 00

 segsize : dword; // кол-во записанных байт
 cmderr: integer;

function SendSBPl55Boot(code : byte ; pBkey : pointer ) : boolean;
function Sendl55ServiceBoot( mode: byte) : boolean;
function SendStartl55Boot(boottype : TBootType ) : boolean;
function SendMainl55Boot : boolean;

function Ackl55Boot : boolean;
function Terminatel55Boot : boolean;
function GetFlashInfol55Boot(var buf : tFlashInfo) : boolean;
function SetBaudl55Boot ( nBaud : integer ) : boolean;
function ReadFlashl55Boot(addr, size : dword ; var buf : array of byte) : boolean;
function ReadEEPl55Boot(num, len : word; var ver: byte; var buf : array of byte) : boolean;
function WriteSegFlashl55Boot(addr, size : dword ; var buf : array of byte) : boolean;
function GoTol55Boot(addr: dword; var x: word) : boolean;
function WritelMem55Boot(addr, size : dword ; var buf : array of byte) : boolean;

function GetSeg55Boot(addrx: dword;  var addr, size : dword ; var FI: tFlashInfo) : boolean;

implementation

type
 tTabBoot = packed record
   ptr  : pointer;
   len  : integer; // size data
 end;

var

{ BIN->PAS : siemboot.PAS }
L55bootSBP : array[0..34] of byte = (
 $a5, $5a, $a5, $a5, $e6, $58, $a5, $00, $7e, $b6, $0d, $ff, $53, $49, $45, $4d,
 $45, $4e, $53, $20, $42, $4f, $4f, $54, $20, $50, $41, $52, $41, $4d, $45, $54,
 $45, $52, $3a);
{ total 35 bytes }
{
A55=C55=S55...
A57=SX1...
A60=A65=CF62=MC60=C60....
A70=A75=AX75...
}
{$IFDEF DEBUGLDR}
     {$include L55v1l55.pas}
     {$include L55v4l55.pas}
{$ELSE}
     {$include L55v1c55.pas}
//     {$include L55v1a57.pas}
     {$include L55v1s55.pas}
     {$include L55v1a60.pas}
     {$include L55v1a70.pas}
     {$include L55v1a50.pas}
     {$include L55v4a50.pas}
     {$include L55v4c55.pas}
     {$include L55v4m55.pas}
     {$include L55v4s55.pas}
     {$include L55v4a60.pas}
     {$include L55v4a65.pas}
     {$include L55v4a70.pas}
     {$include L55v4a75.pas}
     {$include L55v4ax75.pas}
{$ENDIF}
     {$include L55B1BAG.PAS}
     {$include L55SRV.pas}

 TabBoot : array[0..MMAX] of array[1..2] of tTabBoot =
 (
{$IFDEF DEBUGLDR}
  // A50
  (( ptr: @l55b1l55; len: SizeOf(l55b1l55)),
   ( ptr: @l55b4l55; len: SizeOf(l55b4l55))),
  // A51, A52
  (( ptr: @l55b1l55; len: SizeOf(l55b1l55)),
   ( ptr: @l55b4l55; len: SizeOf(l55b4l55))),
  // A55
  (( ptr: @l55b1l55; len: SizeOf(l55b1l55)),
   ( ptr: @l55b4l55; len: SizeOf(l55b4l55))),
  // C55
  (( ptr: @l55b1l55; len: SizeOf(l55b1l55)),
   ( ptr: @l55b4l55; len: SizeOf(l55b4l55))),
  // M55
  (( ptr: @l55b1l55; len: SizeOf(l55b1l55)),
   ( ptr: @l55b4l55; len: SizeOf(l55b4l55))),
  // S55
  (( ptr: @l55b1l55; len: SizeOf(l55b1l55)),
   ( ptr: @l55b4l55; len: SizeOf(l55b4l55))),
  // SL55
  (( ptr: @l55b1l55; len: SizeOf(l55b1l55)),
   ( ptr: @l55b4l55; len: SizeOf(l55b4l55))),
  // A60
  (( ptr: @l55b1l55; len: SizeOf(l55b1l55)),
   ( ptr: @l55b4l55; len: SizeOf(l55b4l55))),
  // A65
  (( ptr: @l55b1l55; len: SizeOf(l55b1l55)),
   ( ptr: @l55b4l55; len: SizeOf(l55b4l55))),
  // MC60
  (( ptr: @l55b1l55; len: SizeOf(l55b1l55)),
   ( ptr: @l55b4l55; len: SizeOf(l55b4l55))),
  // A70
  (( ptr: @l55b1l55; len: SizeOf(l55b1l55)),
   ( ptr: @l55b4l55; len: SizeOf(l55b4l55))),
  // A75
  (( ptr: @l55b1l55; len: SizeOf(l55b1l55)),
   ( ptr: @l55b4l55; len: SizeOf(l55b4l55))),
  // AX72/75,C110
  (( ptr: @l55b1l55; len: SizeOf(l55b1l55)),
   ( ptr: @l55b4l55; len: SizeOf(l55b4l55))),
  // CF62
  (( ptr: @l55b1l55; len: SizeOf(l55b1l55)),
   ( ptr: @l55b4l55; len: SizeOf(l55b4l55))),
  // SX1
  (( ptr: @l55b1l55; len: SizeOf(l55b1l55)),
   ( ptr: @l55b4l55; len: SizeOf(l55b4l55)))
{$ELSE}
  // A50 0020/88BA
  (( ptr: @l55b1a50; len: SizeOf(l55b1a50)),
   ( ptr: @l55b4a50; len: SizeOf(l55b4a50))),
  // A51 A52 002C/0016
  (( ptr: @l55b1c55; len: SizeOf(l55b1c55)),
   ( ptr: @l55b4c55; len: SizeOf(l55b4c55))),
  // A55 0089/0017 ; A57 FlashID: 002C/0017
  (( ptr: @l55b1c55; len: SizeOf(l55b1c55)),
   ( ptr: @l55b4c55; len: SizeOf(l55b4c55))),
  // C55  FlashID: 0089/0017 ;  FlashID: 002C/0017
  (( ptr: @l55b1c55; len: SizeOf(l55b1c55)),
   ( ptr: @l55b4c55; len: SizeOf(l55b4c55))),
  // M55
  (( ptr: @l55b1a60; len: SizeOf(l55b1a60)),
   ( ptr: @l55b4m55; len: SizeOf(l55b4m55))),
  // S55  FlashID: 0020/8810, 0020/88BA
  (( ptr: @l55b1s55; len: SizeOf(l55b1s55)),
   ( ptr: @l55b4s55; len: SizeOf(l55b4s55))),
  // SL55  FlashID: 0020/8810, 0020/88BA FlashID: 0089/8854 (0089/0016)
  (( ptr: @l55b1s55; len: SizeOf(l55b1s55)),
   ( ptr: @l55b4s55; len: SizeOf(l55b4s55))),
  // A60 FlashID: 0001/227E
  (( ptr: @l55b1a60; len: SizeOf(l55b1a60)),
   ( ptr: @l55b4a60; len: SizeOf(l55b4a60))),
  // A65 FlashID: 0089/8856
  (( ptr: @l55b1a60; len: SizeOf(l55b1a60)),
   ( ptr: @l55b4a65; len: SizeOf(l55b4a65))),
  // MC60 FlashID: ?
  (( ptr: @l55b1a60; len: SizeOf(l55b1a60)),
   ( ptr: @l55b4a65; len: SizeOf(l55b4a65))),
  // A70 FlashID: 0001/227E
  (( ptr: @l55b1a70; len: SizeOf(l55b1a70)),
   ( ptr: @l55b4a70; len: SizeOf(l55b4a70))),
  // A75 FlashID: 0001/227E
  (( ptr: @l55b1a70; len: SizeOf(l55b1a70)),
   ( ptr: @l55b4A75; len: SizeOf(l55b4A75))),
  // AX75/72,C110
  (( ptr: @l55b1a70; len: SizeOf(l55b1a70)),
   ( ptr: @l55b4AX75; len: SizeOf(l55b4AX75))),
  // CF62
  (( ptr: @l55b1a60; len: SizeOf(l55b1a60)),
   ( ptr: @l55b4m55; len: SizeOf(l55b4m55))),
  // SX1
  (( ptr: @l55b1a60; len: SizeOf(l55b1a60)),
   ( ptr: @l55b4c55; len: SizeOf(l55b4c55)))
//   ( ptr: @l55b4s55; len: SizeOf(l55b4s55)))
{$ENDIF}
 );

function CalcChk( p : pointer; len : integer) : byte;
begin
   result:=0;
   while (len>0) do begin
    result:=result xor byte(p^);
    inc(dword(p));
    dec(len);
   end;
end;

function CalcChk2( p : pointer; len : integer) : word;
begin
   result:=0;
   while (len>0) do begin
    result:= (result xor byte(p^)) + (byte(p^) shl 8);
    inc(dword(p));
    dec(len);
   end;
end;

function Sendl55ServiceBoot( mode: byte) : boolean;
var
 b : byte;
begin
    result := False;
    l55BootSrvM[$47]:=mode;
// 2 - Normal Mode
// 5 - Battery Care
// 7 - Service Mode
// 8 - Burn in test
    l55BootSrvM[SizeOf(l55BootSrvM)-1]:=CalcChk(@l55BootSrvM[1],SizeOf(l55BootSrvM)-2);
    sBootErr := 'No send Boot!';
    b := CalcChk(TabBoot[Model,2].ptr,TabBoot[Model,2].len);
    if not WriteCom(@l55BootSrvM,SizeOf(l55BootSrvM)) then exit;
    if not ReadCom(@b,1) then begin
     if not ReadCom(@b,1) then begin
      if not ReadCom(@b,1) then begin
        sBootErr := 'ServiceBoot does not answer!';
        exit;
      end;
     end;
    end;
    if (b=$A5) then begin
     sBootErr := 'Sending ServiceBoot Ok.';
     result := True;
     exit;
    end;
    sBootErr := 'Error:  ServiceBoot answer code 0x'+IntToHex(b,2)+'!';
end;

function SendSBPl55Boot(code : byte ; pBkey : pointer ) : boolean;
var
crc,b : byte;
w : word;
begin
    result := False;
    sBootErr := 'PapameterBoot error!';
    case code of
     01: w:=16;
     02: w:=4;
    else w:=0;
    end;
    if (w<>0) and (pBkey = Nil) then exit;
    sBootErr := 'Not send PapameterBoot!';
    crc := CalcChk(@l55bootSBP[0],SizeOf(l55bootSBP)) xor code;
    if pBkey = Nil then b:=SizeOf(l55bootSBP)+1
    else b:=SizeOf(l55bootSBP)+1+w;
    if not WriteCom(@b,1) then exit;
    if not WriteCom(@l55bootSBP[0],SizeOf(l55bootSBP)) then exit;
    if not WriteCom(@code,1) then exit;
    if w<>0 then begin
     if not WriteCom(pBkey,w) then exit;
     crc := crc xor CalcChk(pBkey,w);
    end;
    if not WriteCom(@crc,1) then exit;
    SetComRxTimeouts(1200,1,1300);
    if not ReadCom(@w,2) then begin
     sBootErr := 'PapameterBoot does not answer!';
     exit;
    end;
    if (w=$06A5) then begin
     sBootErr := 'Sending PapameterBoot: Ok.';
     result := True;
     exit;
    end
    else if (w=$A5A5) then begin
     sBootErr := 'Sending PapameterBoot: No Bcore (TP open)!';
     exit;
    end
    else if (w=$15A5) then begin
     sBootErr := 'Sending PapameterBoot: Error!';
    end
    else sBootErr := 'Error: StartBoot answer code 0x'+IntToHex(w,4)+'!';
end;

function SendStartl55Boot(boottype : TBootType ) : boolean;
var
 crc : byte;
begin
    result := False;
    sBootErr := 'Not send StartBoot!';
    case boottype of
     Boot_BCoreBag : begin
      crc := 0;
      if not WriteCom(@crc,1) then exit;
      if not WriteCom(TabBoot[Model,1].ptr,TabBoot[Model,1].len) then exit;
      if not WriteCom(@l55boot1BAG[TabBoot[Model,1].len],SizeOf(l55boot1BAG)-TabBoot[Model,1].len) then exit;
     end;
     else begin
      crc := CalcChk(TabBoot[Model,1].ptr,TabBoot[Model,1].len);
      if not WriteCom(@TabBoot[Model,1].len,1) then exit;
      if not WriteCom(TabBoot[Model,1].ptr,TabBoot[Model,1].len) then exit;
      if not WriteCom(@crc,1) then exit;
     end;
    end; // case
    if not ReadCom(@crc,1) then begin
     sBootErr := 'StartBoot does not loded!';
     exit;
    end;
    if (crc<>$A5) then begin
     sBootErr := 'Error: Load StartBoot answer code 0x'+IntToHex(crc,2)+'!';
     while ReadCom(@crc,1) do;
     exit;
    end;
    if not ReadCom(@crc,1) then begin
     sBootErr := 'StartBoot does not answer!';
     exit;
    end;
    if (crc=$55) then begin
      sBootErr := 'Sending StartBoot Ok.';
      result := True;
      exit;
    end;
    sBootErr := 'Error: StartBoot answer code 0x'+IntToHex(crc,2)+'!';
    while ReadCom(@crc,1) do;
end;

function SendMainl55Boot : boolean;
var
 crc : byte;
 sbuf : string;
begin
    result := False;
    sbuf :='boot';
    sBootErr := 'Not send MainBoot!';
    crc := CalcChk(TabBoot[Model,2].ptr,TabBoot[Model,2].len);
    if not WriteCom(@TabBoot[Model,2].len,2) then exit;
    if not WriteCom(TabBoot[Model,2].ptr,TabBoot[Model,2].len) then exit;
    if not WriteCom(@crc,1) then exit;
    SetComRxTimeouts(500,1,700);
    if not ReadCom(@sbuf[1],4) then begin
     SetComRxTimeouts(100,1,200);
     if sbuf[1]='Z' then sBootErr := 'MainBoot does not load! Error boot CRC or RAM!'
     else sBootErr := 'MainBoot does not answer!';
     exit;
    end;
    SetComRxTimeouts(100,1,200);
    if sbuf='PVOK' then begin
     sBootErr := 'Sending MainBoot Ok.';
     result := True;
     exit;
    end;
    sBootErr := 'Error: MainBoot answer code 0x'+sbuf+'!';
    while ReadCom(@crc,1) do;
end;

// 49 -> 00 20 88 10

function Ackl55Boot : boolean;
var
 b : byte;
begin
    result := False;
    b := ord('A');
    if not WriteCom(@b,1) then begin
     sBootErr := 'BootACK: Not write Com'+IntToStr(iComNum)+'!';
     cmderr:=0;
     exit;
    end;
    if not ReadCom(@b,1) then begin
     sBootErr := 'BootACK does not answer!';
     cmderr:=1;
     exit;
    end;
    if b <> Ord('R') then begin
     sBootErr := 'Error: CmdACK answer code 0x'+IntToHex(b,2)+'!';
     while ReadCom(@b,1) do;
     cmderr:=2;
     exit;
    end;
    result := True;
end;

function Terminatel55Boot : boolean;
var
 w : word ;
begin
    result := False;
    w := ord('T');
    if not WriteCom(@w,1) then begin
     sBootErr := 'Terminate Boot: Not write Com'+IntToStr(iComNum)+'!';
     exit;
    end;
    if not ReadCom(@w,2) then begin
     sBootErr := 'TerminatesBoot does not answer!';
     exit;
    end;
    if w <> $4B4F then begin
     sBootErr := 'Error: TerminatesBoot answer code 0x'+IntToHex(w,4)+'!';
     while ReadCom(@w,1) do;
     exit;
    end;
    sBootErr := 'Boot terminated.';
    result := True;
end;

function GetFlashInfol55Boot(var buf : tFlashInfo) : boolean;
var
 w,x : word ;
 i : integer;
// buf : tFlashInfo;
begin
    result := False;
    w := ord('I');
    if not WriteCom(@w,1) then begin
     sBootErr := 'GetFlashInfo: Not write Com'+IntToStr(iComNum)+'!';
     exit;
    end;
    if not ReadCom(@buf,$40) then begin
     sBootErr := 'GetFlashInfo does not answer!';
     exit;
    end;
    if not ReadCom(@w,2) then begin
     sBootErr := 'GetFlashInfoCRC does not answer!';
     exit;
    end;
    x:=CalcChk2(@buf,$40);
    if x<>w then begin
     sBootErr := 'GetFlashInfoCRC(0x'+IntToHex(x,2)+'<>0x'+IntToHex(w,2)+') error!';
     while ReadCom(@w,1) do;
     exit;
    end;
    sBootErr := 'FlashID: '+IntToHex(buf.Flash1IM,4)+'/'+IntToHex(buf.Flash1ID,4);
//    move(buf.b[0],FlashID[0],8);
    case buf.Flash1IM of
    $0001 : sBootErr := sBootErr+'-'+IntToHex(buf.Flash2IM,4)+'-'+IntToHex(buf.Flash2ID,4);
//    $0020 : sBootErr := sBootErr+', '+IntToHex(buf.Flash2IM,4)+'/'+IntToHex(buf.Flash2ID,4);
    else if //(buf.Flash1IM<>buf.Flash2IM) or (buf.Flash1ID<>buf.Flash2ID) or
    ((buf.Flash2IM or buf.Flash2ID)<>0)
    then
     sBootErr := sBootErr+' ('+IntToHex(buf.Flash2IM,4)+'/'+IntToHex(buf.Flash2ID,4)+')';
    end;
    sBootErr := sBootErr+#13+#10+'Flash Size: '+IntToStr(buf.CFI.FlashSizeN shr 8)+'Mb';
//    sBootErr := sBootErr+', Type: '+IntToHex(buf.CFI.BusType,1);
    if buf.CFI.WrBuffer>1 then sBootErr := sBootErr+', WriteBuffer: '+IntToStr(buf.CFI.WrBuffer shl 1)+' bytes';
//    sBootErr := sBootErr+', Number of erase block regions: '+IntToStr(buf.CFI.BlkRegs);
    i:=0;
    while (i< buf.CFI.BlkRegs) do begin
     sBootErr := sBootErr+#13+#10+'Region('+IntToStr(i+1)+'): Blocks '+IntToStr(buf.CFI.BlkReg[i].NumN+1) + ', Size '+IntToStr(buf.CFI.BlkReg[i].SizeN shr 2)+'Kb';
     inc(i);
    end;
//    sBootErr := sBootErr+#13+#10+'Window RAM block: '+IntToStr(buf.RamSize shl 4)+'Kb';
    if (buf.CFI.FlashSizeN shl 12)<>TabFlash[Model][tFLSize] then begin
     if Not ((Model=MA70) and (buf.CFI.FlashSizeN=$400)) then begin
      sBootErr := sBootErr+#13+#10+'Warning: Not valid Flash Size in set phone model!';
     end;
     beep;
    end;
    if buf.SegEELITE<>0 then begin
     sBootErr := sBootErr+#13+#10+'Start EEPROM segments at addres 0x'+IntToHex(buf.SegEELITE shl 14,6);
     if (buf.SegEELITE shl 14)<>TabFlash[Model][tEEBase] then begin
      sBootErr := sBootErr+#13+#10+'Warning: Not valid addres Start EEPROM in set phone model!';
      beep;
     end;
    end
    else sBootErr := sBootErr+#13+#10+'EEPROM segments not found!';
    sBootErr := sBootErr+#13+#10+'FSN: '+IntToHex(buf.FSN,8)+' -> PhoneID: '+BufToHexStr(@buf.FSN,4);
//    sBootErr := sBootErr+#13+#10+'BCDIMEI: '+BufToHexStr(@buf.BCDIMEI,7);
//    sBootErr := 'FlashManufacturerID: '+BufToHexStr(@FlashID[0],2);
    result := True;
end;
// 115200 42 00 09 01 6B AA      AA 4F 4B
// 460800 42 00 02 01 B4 AA
// 921600 42 00 00 01 1A AA
function SetBaudl55Boot ( nBaud : integer ) : boolean;
var
 i,x : integer;
 d : dword;
begin
    result := False;
    if (nBaud < 1) or (nBaud > 3) then begin
     sBootErr := 'Error parameters SetSpeedBaud('+IntToStr(nBaud)+')!';
     exit;
    end;
    i := 57600;
    case nBaud of
     1 : i := 115200;
     2 : i := 460800;
     3 : i := 921600;
    end;
    case Model of
     MA50,MA70,MA75,MAX75 : if i>460800 then begin i:=460800; nBaud:=2; end;
    end;
    x := dcb.BaudRate;
    if x=i then begin
     sBootErr := 'SetSpeedBaud: Com'+IntToStr(iComNum)+' already use '+IntToStr(i)+' BAUD!';
     result := True;
     exit;
    end;
    if Not ChangeComSpeed(i) then begin
     sBootErr := 'Error SetSpeedBaud '+IntToStr(i)+' Com'+IntToStr(iComNum)+'!';
     exit;
    end;
    if Not ChangeComSpeed(x) then begin
     sBootErr := 'Error SetSpeedBaud '+IntToStr(i)+' Com'+IntToStr(iComNum)+'!';
     exit;
    end;
    if (Model=MA70) or (Model=MA75) or (Model=MAX75) 
    then x:=1
    else if (Model=MA50) then x:=2
    else x:=0;
    if Not WriteCom(@TabBootBaud[x][nBaud][0],5) then begin
      sBootErr := 'SetSpeedBaud: Not write Com'+IntToStr(iComNum)+'!';
      exit;
    end;
    Sleep(50);
    if Not ChangeComSpeed(i) then begin
     sBootErr := 'Error SetSpeedBaud '+IntToStr(d)+' Com'+IntToStr(iComNum)+'!';
     exit;
    end;
//    Sleep(100);
    d:=$AA;
    if not WriteCom(@d,1) then begin
     sBootErr := 'SetSpeedBaud: Not write Com'+IntToStr(iComNum)+'!';
     exit;
    end;
    if not ReadCom(@d,3) then begin
     sBootErr := 'SetSpeedBaud does not answer!';
     exit;
    end;
    if d <> $4B4FAA then begin
     sBootErr := 'Error: SetSpeedBaud answer code 0x'+IntToHex(d,6)+'!';
     while ReadCom(@d,1) do;
     exit;
    end;
    sBootErr := 'Com'+IntToStr(iComNum)+' '+IntToStr(i)+' BAUD: Ok.';
    result := True;
end;

type
 tGetEEP = packed record case byte of
  00: (
   cmd  : byte;
   num  : word;
   len  : word; );
  01: ( b : array[0..4] of Byte; );
 end;
function ReadEEPl55Boot(num, len : word; var ver: byte; var buf : array of byte) : boolean;
var
 GetEEP : tGetEEP;
 w,x : word ;
begin
    result := False;
//    if Not Ackl55Boot then exit;
    GetEEP.cmd := ord('J');
    GetEEP.num := num;
    GetEEP.len := len;
    if not WriteCom(@GetEEP,SizeOf(GetEEP)) then begin
     sBootErr := 'ReadEEP: Not write Com'+IntToStr(iComNum)+'!';
     exit;
    end;
    SetComRxTimeouts(2000,1,2000);
    if not ReadCom(@w,2) then begin
     SetComRxTimeouts(100,1,200);
     sBootErr := 'ReadEEP'+Int2Digs(num,4)+' does not answer!';
     exit;
    end;
    SetComRxTimeouts(100,1,200);
    if (w and $ff) <> Ord('N') then begin
     if w = $4645 then sBootErr := 'Error: EEP'+Int2Digs(num,4)+' not found!'
     else sBootErr := 'Error: Read EEP'+Int2Digs(num,4)+' answer code 0x'+IntToHex(w,1)+'!';
     while ReadCom(@w,1) do;
     exit;
    end;
    ver := Byte(w shl 8);
    if not ReadCom(@buf[0],len) then begin
     sBootErr := 'Read EEP'+Int2Digs(num,4)+' data does not answer!';
     exit;
    end;
    if not ReadCom(@w,2) then begin
     sBootErr := 'Read EEP'+Int2Digs(num,4)+' does not answer CRC!';
     exit;
    end;
    x:=CalcChk2(@buf,len);
    if x<>w then begin
     sBootErr := 'Read EEP'+Int2Digs(num,4)+' CRC('+IntToHex(x,4)+'<>'+IntToHex(w,4)+') error!';
     while ReadCom(@w,1) do;
     exit;
    end;
    sBootErr := 'Read EEP'+Int2Digs(num,4)+' block (ver'+IntToHex(ver,2)+'), size '+IntToStr(len)+' bytes - Ok.';
    result := True;
end;

type
 rdfl55 = packed record case byte of
   0: (
      cmd : byte;
      addr : array[0..2] of Byte ;
      size : array[0..2] of Byte ; );
   1: (
      b  : array[0..6] of byte; );
 end;
function _ReadFlashl55Boot(addr, size : dword ; var buf : array of byte) : boolean;
var
 rdf : rdfl55;
 w,x : word ;
 len : dword;
 blkoff,blksize : integer;
begin
    result := False;
    cmderr:=0;
    if size = 0 then begin
     sBootErr := 'ReadFlash: parameters error!';
     exit;
    end;
    rdf.cmd := ord('R');
    rdf.addr[2]:=Byte(addr);
    rdf.addr[1]:=Byte(addr shr 8);
    rdf.addr[0]:=Byte(addr shr 16);
    rdf.size[2]:=Byte(size);
    rdf.size[1]:=Byte(size shr 8);
    rdf.size[0]:=Byte(size shr 16);
    if not WriteCom(@rdf.b,Sizeof(rdf)) then begin
     sBootErr := 'ReadFlash: Not write Com'+IntToStr(iComNum)+'!';
     exit;
    end;
    len := size;
    blksize:=8192;
    blkoff:=0;
    SetComRxTimeouts(200,1,300);
    While size>0 do begin
     if blksize>integer(size) then blksize:=size;
     if not ReadCom(@buf[blkoff],blksize) then begin
      sBootErr := 'Error Read Flash block 0x'+IntToHex(addr+dword(blkoff),6)+' size 0x'+IntToHex(Size,6)+'!';
      cmderr:=1;
      exit;
     end;
     size:=size-dword(blksize);
     blkoff:=blkoff+blksize;
    end;
    if not ReadCom(@w,2) then begin
     sBootErr := 'ReadFlash does not answer!';
     cmderr:=2;
     exit;
    end;
    x:=CalcChk2(@buf[0],len);
    if w <> x then begin
     sBootErr := 'ReadFlash error CRC (0x'+IntToHex(x,4)+'<>0x'+IntToHex(w,4)+')!';
     while ReadCom(@w,1) do;
     cmderr:=3;
     exit;
    end;
    result := True;
end;

function ReadFlashl55Boot(addr, size : dword ; var buf : array of byte) : boolean;
var
serr : string;
begin
// result := False;
// if Not Ackl55Boot then exit;
 result:=_ReadFlashl55Boot(addr, size, buf);
 if Not result then begin
  serr:=sBootErr;
  if cmderr=0 then exit;
  if Ackl55Boot or Ackl55Boot then begin
   if cmderr=0 then exit;
   result:=_ReadFlashl55Boot(addr, size, buf);
   if Not result then begin
    serr:=sBootErr;
    if cmderr=0 then exit;
    if Ackl55Boot or Ackl55Boot then begin
     if cmderr=0 then exit;
     result:=_ReadFlashl55Boot(addr, size, buf);
    end // if Ackl55Boot
    else sBootErr:=serr;
   end;
  end // if Ackl55Boot
  else sBootErr:=serr;
 end;
end;

function _WriteSegFlashl55Boot(addr, size : dword ; var buf : array of byte) : boolean;
var
 w : word ;
 blkoff,d : dword;
 i : integer;
begin
    result := False;
    cmderr:=0;
    if size = 0 then begin
     sBootErr := 'WriteFlash: parameters error!';
     exit;
    end;
    w:=swap(addr shr 12);
    d:= ord('F') or (w shl 8);
    if not WriteCom(@d,3) then begin
     sBootErr := 'WriteFlash: Not write Com'+IntToStr(iComNum)+'!';
     exit;
    end;
    SetComRxTimeouts(3000,1,4000);
    w:=0;
    if not ReadCom(@w,1) then begin
     SetComRxTimeouts(100,1,200);
     sBootErr := 'WriteFlash block at 0x'+IntToHex(addr,6)+' does not answer!';
     exit;
    end;
    if (w > $40) or (w = 0) then begin
     if (w = $FF) then sBootErr := 'WriteFlash: No Flash block at 0x'+IntToHex(addr,6)+'!'
     else sBootErr := 'WriteFlash: Segment Size error=0x'+IntToHex(w,2)+' at block 0x'+IntToHex(addr,6)+'!';
     while ReadCom(@w,1) do;
     exit;
    end;
    SetComRxTimeouts(100,1,200);
    segsize := w shl 12; // по 4096 кило
    if size < segsize then begin
     sBootErr := 'Error: Minimal write block '+IntToStr(segsize)+' bytes!';
     exit;
    end;
    blkoff:=0;
    while blkoff<segsize do begin
     if not WriteCom(@buf[blkoff],4096) then begin
      sBootErr := 'Error Write Flash block 0x'+IntToHex(addr+blkoff,6)+' size 0x'+IntToHex(Size,6)+')!';
//      cmderr:=0;
      exit;
     end;
     blkoff:=blkoff+4096;
    end;
//    w:=$AA;
//    if not WriteCom(@w,1) then begin
//     sBootErr := 'Not write Com'+IntToStr(iComNum)+'!';
//     exit;
//    end;
    SetComRxTimeouts(6000,1,7000);
    if not ReadCom(@w,2) then begin
     SetComRxTimeouts(100,1,200);
     sBootErr := 'ClearFlashSeg at 0x'+IntToHex(addr,6)+' does not answer!';
//     cmderr:=2;
     exit;
    end;
    if CalcChk2(@buf[0],segsize)<>w then begin
     SetComRxTimeouts(100,1,200);
     sBootErr := 'CRC error in transfer buffer or bad RAM! (Block at 0x'+IntToHex(addr,6)+').';
     cmderr:=5;
     exit;
    end;
    blkoff:=0;
    i:=0;
    while dword(i)<segsize do begin
      blkoff:=blkoff+dword((@buf[i])^);
      inc(i,4);
    end;
    SetComRxTimeouts(8000,1,9000);
    if not ReadCom(@w,1) then begin
     SetComRxTimeouts(100,1,200);
     sBootErr := 'WriteFlash block at 0x'+IntToHex(addr,6)+' does not answer crc!';
     cmderr:=1;
     exit;
    end;
    SetComRxTimeouts(200,1,300);
    if not ReadCom(@d,3) then begin
     sBootErr := 'WriteFlash block at 0x'+IntToHex(addr,6)+' does not answer crc!';
//     cmderr:=1;
     exit;
    end;
    d:=(w and $FF) or (d shl 8);
    if d<>blkoff then begin
     sBootErr := 'WriteFlash CRC Error (0x'+IntToHex(d,8)+'<>0x'+IntToHex(blkoff,8)+')! (Block at 0x'+IntToHex(addr,6)+').';
     while ReadCom(@w,1) do;
     cmderr:=3;
     exit;
    end;
    result := True;
end;

function WriteSegFlashl55Boot(addr, size : dword ; var buf : array of byte) : boolean;
var
serr : string;
begin
// result := False;
// if Not Ackl55Boot then exit;
 result:=_WriteSegFlashl55Boot(addr, size, buf);
 if Not result then begin
  serr:=sBootErr;
  if cmderr=0 then exit;
  if Ackl55Boot then begin
   if cmderr=0 then exit;
   result:=_WriteSegFlashl55Boot(addr, size, buf);
   if Not result then begin
    serr:=sBootErr;
    if cmderr=0 then exit;
    if Ackl55Boot then begin
     if cmderr=0 then exit;
     result:=_WriteSegFlashl55Boot(addr, size, buf);
    end // if Ackl55Boot
    else sBootErr:=serr;
   end;
  end // if Ackl55Boot
  else sBootErr:=serr;
 end;
end;

type
 tBootGo = packed record case byte of
  00: (
   cmd  : byte;
   seg  : byte;
   addr  : word; );
  01: ( b : array[0..3] of Byte; );
 end;
function GoTol55Boot(addr: dword; var x: word) : boolean;
var
 w : word ;
 BootGo : tBootGo;
begin
    result := False;
    BootGo.cmd := ord('G');
    BootGo.seg := byte(addr shr 16);
    BootGo.addr := Swap(word(addr));
    if not WriteCom(@BootGo,SizeOf(BootGo)) then begin
     sBootErr := 'BootGo: Not write Com'+IntToStr(iComNum)+'!';
     exit;
    end;
    SetComRxTimeouts(1200,1,1300);
    if not ReadCom(@w,2) then begin
     SetComRxTimeouts(100,1,200);
     sBootErr := 'BootGo does not answer!';
     exit;
    end;
    SetComRxTimeouts(100,1,200);
    x:=w;
    sBootErr := 'BootGo answer code '+IntToHex(w,4);
    result := True;
end;
type
 twrxl55 = packed record case byte of
   0: (
      cmd : byte;
      addr : array[0..2] of Byte ;
      size : array[0..2] of Byte ; );
   1: (
      b  : array[0..6] of byte; );
 end;

function WritelMem55Boot(addr, size : dword ; var buf : array of byte) : boolean;
var
 wrx : twrxl55;
 w,x : word ;
 len : dword;
 blkoff,blksize : integer;
begin
    result := False;
    if size = 0 then begin
     sBootErr := 'ReadFlash: parameters error!';
     exit;
    end;
    wrx.cmd := ord('X');
    wrx.addr[2]:=Byte(addr);
    wrx.addr[1]:=Byte(addr shr 8);
    wrx.addr[0]:=Byte(addr shr 16);
    wrx.size[2]:=Byte(size);
    wrx.size[1]:=Byte(size shr 8);
    wrx.size[0]:=Byte(size shr 16);
    if not WriteCom(@wrx.b,Sizeof(wrx)) then begin
     sBootErr := 'WriteMemBoot: Not write Com'+IntToStr(iComNum)+'!';
     exit;
    end;
    len := size;
    blksize:=8192;
    blkoff:=0;
    While size>0 do begin
     if blksize>integer(size) then blksize:=size;
     if not WriteCom(@buf[blkoff],blksize) then begin
      sBootErr := 'Error Write Memory block 0x'+IntToHex(addr+dword(blkoff),6)+' size 0x'+IntToHex(Size,6)+'!';
      cmderr:=1;
      exit;
     end;
     size:=size-dword(blksize);
     blkoff:=blkoff+blksize;
    end;
    x:=CalcChk2(@buf[0],len);
    SetComRxTimeouts(200,1,300);
    if not ReadCom(@w,2) then begin
     sBootErr := 'Write Memory block does not answer!';
     cmderr:=2;
     exit;
    end;
    if w <> x then begin
     sBootErr := 'Write Memory block error CRC (0x'+IntToHex(x,4)+'<>0x'+IntToHex(w,4)+')!';
     while ReadCom(@w,1) do;
     cmderr:=3;
     exit;
    end;
    sBootErr := 'Write Memory block at 0x'+IntToHex(addr+dword(blkoff),6)+' size 0x'+IntToHex(Size,6)+' - Ok.';
    result := True;
end;

function GetSeg55Boot(addrx: dword;  var addr, size : dword ; var FI: tFlashInfo) : boolean;
var
i,x : integer;
dw,dx : dword;
begin
    result := False;
    if (addrx > (FI.CFI.FlashSizeN shl 12)+TabFlash[Model][tFFBase])
    or (addrx < TabFlash[Model][tFFBase])
    then begin
     sBootErr := 'GetSeg: The addres 0x'+IntToHex(addrx,6)+' overstep the flash size!';
     exit;
    end;
    dx:=addrx-TabFlash[Model][tFFBase];
    for i:=0 to FI.CFI.BlkRegs do begin
     for x:=0 to FI.CFI.BlkReg[i].NumN do begin
      dw := FI.CFI.BlkReg[i].SizeN shl 8; // размер сегмента
      if dx<dw then begin
       addr := addrx and ((dw-1) xor $FFFFFFFF);
       size := dw;
       sBootErr := 'GetSeg: Addr 0x'+IntToHex(addrx,6)+' -> Seg 0x'+IntToHex(addr,6)+' Size 0x'+IntToHex(size,6);
       result := True;
       exit;
      end;
      dx := dx-dw;
     end;
    end;
    sBootErr := 'GetSeg: Error in CFI table!';
end;

// A55  512Kb Ram
// 0..10000h      RAM
// 10000h..10800h ROM
// 10800h..80000h RAM
end.
