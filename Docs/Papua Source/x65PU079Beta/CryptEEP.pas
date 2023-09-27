//Использование в коммерческих целях запрещено.
//Наказание - неминуемый кряк и распространение по всему инет.
//Business application is forbidden.
//Punishment - unavoidable crack and propagation on everything inet.
unit CryptEEP;

interface
uses Windows,SysUtils,MD5;
type
//   array of byte = array[0..9] of byte;
   TBlock = array of byte;
const
   C35 = 0;
   A35 = 1;
   S45 = 2;
   C45 = 2;
   C30 = 3;
   S40 = 3;
   A50 = 4;
   C55 = 5;
// C35
// A35
// C45
// S45
// SL45
// C30,S40
// A50,C55
var
EEP5121 : array[0..55] of byte;
EEP5122 : array[0..5] of byte;
EEP5123 : array[0..31] of byte;
EEP5008 : array[0..223] of byte;
EEP5077 : array[0..231] of byte;
EEP5009 : array[0..9] of byte;
EEP0076 : array[0..9] of byte;
EEP0052 : array[0..289] of byte;

blkEEP52 : array[0..289] of Byte = (
 $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,
 $ff, $ff, $01, $00, $00, $01, $03, $00, $01, $00, $01, $00, $54, $00, $55, $00,
 $80, $00, $d9, $d9, $f3, $bb, $3f, $70, $85, $83, $86, $91, $d8, $a0, $da, $c3,
 $95, $a5, $a3, $4d, $d0, $4f, $cf, $e3, $50, $4a, $54, $a6, $34, $52, $60, $34,
 $d2, $fb, $76, $69, $5d, $ef, $36, $96, $56, $0f, $c0, $6d, $ef, $38, $12, $b7,
 $c7, $2f, $bf, $d6, $a0, $d5, $15, $e7, $13, $24, $14, $45, $40, $40, $f9, $69,
 $49, $08, $b1, $3b, $ed, $97, $9a, $ef, $9f, $20, $63, $da, $07, $f8, $40, $3c,
 $eb, $30, $32, $68, $08, $49, $86, $a2, $3b, $3e, $61, $21, $fe, $7b, $ce, $d2,
 $ad, $3b, $02, $00, $5c, $41, $30, $a3, $8d, $52, $79, $f0, $97, $28, $4e, $fc,
 $18, $6a, $e9, $5e, $0a, $b2, $be, $4b, $a7, $a8, $58, $44, $28, $91, $f4, $be,
 $ec, $ef, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,
 $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,
 $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,
 $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,
 $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,
 $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,
 $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,
 $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff,
 $ff, $ff);

procedure CRCBuffer(var Block : array of byte; BlockSize : integer);
function  CalkImei15(si: string; var i15: char ):boolean;
procedure IMEI2xBCD(IMEI: string);
procedure Crypt5121key1(var OutBuf: array of byte);
procedure Crypt5121mkey(mkey: dword; num : dword; var OutBuf: array of byte);
procedure Crypt5008blk(EKey: dword; var blk5008: array of byte);
procedure DeCrypt5008blk(EKey: dword; var blk5008: array of byte);
procedure Crypt5077blk(EKey: dword; var blk5077: array of byte);
procedure DeCrypt5077blk(EKey: dword; var blk5077: array of byte);
procedure ProviderLock5008(Provider1, Provider2 : byte; var blk5008: array of byte);
procedure Decode76(var Block: array of byte; PhoneModel: byte);
procedure Encode76(var Block: array of byte; PhoneModel: byte);
procedure Decode5009(var Block: array of byte; PhoneModel: byte);
procedure Encode5009(var Block: array of byte; PhoneModel: byte);
procedure Create76(IMEI: string; var Block: array of byte; PhoneModel: byte);
procedure Create5009(IMEI: string; var Block: array of byte; PhoneModel: byte);
procedure Create5008(IMEI: string; ESN: dword; var Block: array of byte; PhoneModel: byte);
procedure Create5077(IMEI: string; ESN: dword; var Block: array of byte; PhoneModel: byte);
procedure Create512x(xIMEI: string; xESN, xSkey: dword; var xMkey: array of Dword );
procedure Create52(xESN, xSkey: dword; MinSW : byte);
//
procedure StartCalk5121mkeys(xIMEI: string; xESN, MKey: dword);
function StepCalk5121mkeys(CmpBuf :pointer ; var Mkeys: array of dword) : boolean;
//
procedure DeCodeImeiBlock(var Block : array of byte; blockType, PhoneModel : byte);
function IMEI2BCD(IMEI: string; var BCDImei: array of byte): boolean; // 8 байт
function BCD2IMEI(var BCDImei: array of Byte; var IMEI: string): boolean; // 8 байт
//function DeCodeMailKeys( var xkey : array of byte; len : integer; x,y : byte): boolean;
//procedure CodeMailKeys( var xkey : array of byte; len : integer; x,y : byte);


var
eepESN,eepSKey: Dword;
{NewEEP5008 : array[0..223] of byte = (
// random1 8
        $50,$56,$50,$56,$00,$00,$00,$00,
// LocksData  24                                         бит0    код телефона
        $00,$03,$00,$00,$00,$00,$67,$00,$00,$00,$00,$00,$FF,$00,$FF,$FF,
        $FF,$FF,$FF,$FF,$00,$FF,$62,$64,
// random2 8
        $53,$49,$20,$20,$00,$00,$00,$00,
// block5008
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $50,$00,$FF,$FF,$FF,$00,$FF,$FF); }
{ 5008: [random1][locksdata][random2][block5008]
SizeOf(random1) = 8
SizeOf(LocksData) = 24
SizeOf(random2) = 8
SizeOf(block5008) = 184 }
{ NewEEP5077: array[0..231] of byte = (
// random  8
        $50,$56,$50,$56,$00,$00,$00,$00,
// Block5077  224
        $FF,$FF,$FF,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
        $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$29,$FF,$00,$00,$00,$00,$00,$00);
        // $29,$FF,$FA,$A1,$F9,$F3,$E8,$C9); }
{ 5077: [random][block5077]
SizeOf(random) = 8
SizeOf(Block5077) = 224 }
implementation
const
   b76 = 0;
   b5009 = 1;
var
 CodeTable00 : array [0..15] of byte = (
      $02, $06, $0A, $0E, $00, $05, $07, $09,
      $0B, $01, $0D, $03, $0F, $0C, $04, $08);
 CodeTable01 : array [0..15] of byte = (
      $04, $0D, $02, $06, $01, $0F, $00, $0C,
      $03, $08, $0B, $07, $0E, $0A, $05, $09);
    { C45 }
 CodeTable02 : array [0..15] of byte = (
      $00, $0F, $0A, $0A, $0B, $06, $02, $09,
      $0A, $0C, $0E, $08, $01, $05, $00, $0E);
 CodeTable03 : array [0..15] of byte = (
      $0B, $00, $07, $0D, $03, $00, $0C, $0F,
      $0E, $00, $0F, $08, $02, $05, $01, $09);
    { x55, x65, etc. }
 CodeTable04 : array [0..15] of byte = (
      $03, $0F, $01, $0D, $05, $0B, $0D, $09,
      $0D, $07, $06, $00, $0E, $06, $0B, $08);
 CodeTable05 : array [0..15] of byte = (
      $0A, $0E, $01, $05, $03, $06, $02, $0F,
      $0B, $0A, $03, $05, $06, $05, $04, $02);
{
 Cod00XORKey : array [0..5, 0..7] of byte = (
       ($9F, $84, $74, $2D, $4F, $60, $CB, $D4),   // C35
       ($9F, $84, $74, $2D, $4F, $60, $CB, $D4),   // A35
       ($8F, $1D, $74, $F4, $71, $8A, $0E, $35),   // C45
       ($00, $00, $00, $00, $00, $00, $00, $00),   // C30,S40
       ($8F, $1D, $74, $F4, $71, $8A, $0E, $35),   // A50
       ($8F, $1D, $74, $F4, $71, $8A, $0E, $35)    // C55
    );
}
 Pars : array [0..5, 0..7] of byte = (

       ($E8, $2D, $AA, $92, $E1, $0E, $9F, $51),   // C35
       ($F1, $14, $AE, $46, $4F, $44, $15, $39),   // A35, SL45
       ($42, $77, $DE, $8F, $37, $1A, $12, $83),   // C45, S45
       ($E1, $CD, $3D, $A1, $E6, $71, $21, $FE),   // C30, S40
       ($E3, $B7, $5C, $13, $B0, $D2, $C4, $19),   // A50
       ($E3, $B7, $5C, $13, $B0, $D2, $C4, $19)    // C55, A50
{
freia
       ($E8, $2D, $AA, $92, $E1, $0E, $9F, $51),   // C35
       ($F1, $14, $AE, $46, $4F, $44, $15, $39),   // A35
       ($42, $77, $DE, $8F, $37, $1A, $12, $83),   // C45
       ($42, $77, $DE, $8F, $37, $1A, $12, $83),   // S45
       ($F1, $14, $AE, $46, $4F, $44, $15, $39),   // SL45
       ($E1, $CD, $3D, $A1, $E6, $71, $21, $FE),   // C30,S40
       ($E3, $B7, $5C, $13, $B0, $D2, $C4, $19),   // A50,C55
}
    );
   SecKey1: array[0..15] of dword = (
      $E5EE0A14, $F8FFFBD7, $03C64D76, $B2F9B2FD, // A50,C55
      $A266CDB4, $A410F726, $43C2113E, $AFF651F4,
      $8C986DDC, $8E588F08, $8EB84FDC, $4128E208,
      $00000000, $08555555, $00000000, $00000000);
   SecKey2: array[0..15] of dword = (
      $00000000, $EEEEEEEE, $9CDCD00A, $B9AAECAF,
      $857BA551, $B3E980E0, $F8017FF6, $428F719D,
      $E1A0F54D, $4FD21ED2, $8C986DDC, $8E588F08,
      $8EB84FDC, $0828E208, $7654321A, $54321098);
   SecKey3: array[0..15] of dword = (
      $54321A08, $32109876, $7C72C5D8, $59C8F825,
      $CA22EEDB, $F3B47DB5, $B16E5EA5, $67A5B10D,
      $8C986DDC, $8E588F08, $8EB84FDC, $4128E208,
      $F7FAEA16, $2AD9C4D7, $7F0BF23B, $EEEEEEEE);
   MD4InitBlock: array[0..3] of dword = (
      $67452301, $0EFCDAB89, $98BADCFE, $10325476
      );
   MD4Padding: array[0..15] of dword = (
      $80, 0, 0, 0, 0, 0, 0, 0,
      0, 0, 0, 0, 0, 0, $200, 0);

//   Log, Exp : array[0..255] of byte;
//   Prev: dword = 0;

   S: array[0..255] of byte;
   RC4_S: array[0..255] of byte;
   BCDImei: array[0..7] of byte;
   UserKey: array[0..15] of byte;
   RC4_i, RC4_j, RC4_k : byte;
//   DecodedBlock: array of byte;

function IMEI2BCD(IMEI: string; var BCDImei: array of byte): boolean; // 8 байт
var
   i, j: integer;
begin
   // Перевод IMEI в BCD
   result:=False;
   if length(IMEI)<>15 then exit;
   i := 0;
   j := 1;
   while i < 7 do begin
      BCDImei[i] := (Byte(IMEI[j]) and $0F) or (Byte(IMEI[j+1]) shl 4);
      inc(i);
      inc(j,2);
   end; { while }
      BCDImei[i] := Byte(IMEI[j]) or $F0;
   result:=True;
end;

function BCD2IMEI(var BCDImei: array of Byte; var IMEI: string): boolean; // 8 байт
var
  i,j : integer;
  c : Char;
begin
   // Перевод BCDIMEI в StringIMEI
   result:=False;
   IMEI:='';
   i := 0; j:= 0;
   while i < 8 do begin
    c:=Char((BCDImei[i] and $0F)+$30);
    if c>#$39 then break;
    IMEI:=IMEI+c; inc(j);
    c:=Char((BCDImei[i] shr 4)+$30);
    if c>#$39 then break;
    IMEI:=IMEI+c; inc(j);
    inc(i);
   end;
   if j<>15 then exit;
   result:=True;
end;

// csegBF:D458 CryptMD4andK1
procedure CodeBlock(var Block: array of byte; Size : integer; var SecKey: array of dword; Mode : boolean);
var
   i: integer;
   RC4_tmp : byte;
begin
   // Инициализация S-блока
   //   for i := 0 to 255 do  RC4_S[i] := i;
   asm
        push      edi
        push      esi

        cld
        lea edi,RC4_S[0]
        mov eax,$03020100
@@SetS:
        stosd
        add eax,$04040404
        stosd
        add eax,$04040404
        stosd
        add eax,$04040404
        stosd
        add eax,$04040404
        test eax,$ff
        jnz @@SetS
//   end;

//   asm
      push      ebx
      cld
      lea       esi, MD4InitBlock[0]
      lea       edi, UserKey[0]
      movsd
      movsd
      movsd
      movsd
      lea       edi, UserKey[0]
      mov       esi, SecKey

      push      ebp
     {$include md4trans.inc}

      lea       esi, MD4Padding[0]
     {$include md4trans.inc}

      pop       ebp
      cld
      lea       esi, RC4_S[0]
      lea       edi, S[0]
      mov       ecx, 256 / 4
      rep       movsd

      push   ebp
      xor    eax, eax
      xor    ecx, ecx

      lea    edi, S[0]
      lea    ebp, UserKey[0]

   @@loop:
      mov    edx, ecx
      and    edx, $F
      add    eax, [ebp + edx]
      mov    edx, [edi + ecx] //Считываем M[i]
      add    eax, edx         //A += M[i]

      movzx  esi, al

      mov    ebx, [edi + esi] //Считываем M[A]

      mov    byte ptr [edi + ecx],bl
      inc    ecx
      mov    byte ptr [edi + esi],dl
      and    ecx, $0FF
      jnz    @@loop
      pop    ebp
      pop    ebx

        pop     esi
        pop     edi
   end;
   RC4_i := 0;
   RC4_j := 0;
   RC4_k := 0;
   // (Де)кодирование блока.
   for i := 0 to Size-1 do begin
      inc(RC4_i);
      inc(RC4_k, S[RC4_i]);
      inc(RC4_j, RC4_k);
      RC4_tmp := RC4_k + S[RC4_j];
      S[RC4_i] := S[RC4_j];
      S[RC4_j] := RC4_k;
      if Mode then begin
         RC4_k := Block[i] xor S[RC4_tmp];
         Block[i] := RC4_k;
      end else begin
         RC4_k := Block[i];
         Block[i] := RC4_k xor S[RC4_tmp];
      end;
   end; { for }
end;

procedure CRCBuffer(var Block : array of byte; BlockSize : integer);
var
   i : integer;
   c1, c2 : byte;
begin
   c1 := 0; c2 := 0;
   for i := 0 to BlockSize - 1 do begin
      inc(c1, Block[i]);
      c2 := c2 xor Block[i];
   end; { for }
   Block[BlockSize] := c1;
   Block[BlockSize + 1] := c2;
end;
{
procedure Cod00XORWithKey (var buf : array of byte; PhoneModel byte;)
var
i : ineger;
begin
    for i:=0 to 7 do buf[i]:= Cod00XORKey[PhoneModel][i] xor buf[i];
end;
}

function GetXByte(PhoneModel, s : byte): byte;
var
   hi, lo : byte;
begin
   hi := (s SHR 4) AND $F;
   lo := s AND $F;
   case PhoneModel of
      C45, C55 : Result := (CodeTable04[hi] SHL 4) +
                       CodeTable05[lo];
      A50 : Result := (CodeTable02[hi] SHL 4) +
                       CodeTable03[lo];
      else Result := (CodeTable00[hi] SHL 4) +
                       CodeTable01[lo];
   end; { case }
end;

procedure DeFaistelStep(PhoneModel, StepConst : byte;
                      var Block : array of byte);
var
   i, NStep, tmpStep : byte;
begin
   NStep := 0;
   for i := 0 to 4 do begin
      tmpStep := Block[i + 5];
      Block[i + 5] := StepConst XOR Block[i] XOR GetXByte(PhoneModel, tmpStep) XOR NStep;
      NStep := NStep XOR $FF;
      Block[i] := tmpStep;
   end; { for i }
end;

procedure FaistelStep(PhoneModel, StepConst : byte;
                      var Block : array of byte);
var
   i, NStep, tmpStep : byte;
begin
   NStep := 0;
   for i := 0 to 4 do begin
      tmpStep := Block[i];
      Block[i] := StepConst XOR Block[i + 5] XOR GetXByte(PhoneModel, tmpStep) XOR NStep;
      NStep := NStep XOR $FF;
      Block[i + 5] := tmpStep;
   end; { for i }
end;


procedure EnCodeImeiBlock(var Block : array of byte; blockType, PhoneModel : byte);
var
   i : integer;
begin
   if BlockType=b76 then i := 1
   else i := 0;
   while i < 8 do begin
      FaistelStep(PhoneModel, Pars[PhoneModel, i], Block);
      inc(i, 2);
   end; { while }
end;


procedure DeCodeImeiBlock(var Block : array of byte; blockType, PhoneModel : byte);
var
   i : integer;
begin
   if BlockType=b76 then i := 7
   else i := 6;
   while i >= 0 do begin
      DeFaistelStep(PhoneModel, Pars[PhoneModel, i], Block);
      dec(i, 2);
   end; { while }
end;

procedure CreateIMEIBlock(IMEI : string; var Block : array of byte; PhoneModel, BlockType : byte );
var
   i, j : integer;
   CRCDword : integer;
   BP0A, BP0B, BP0C,
   CRC, b, c : byte;
begin
   CRCDword := 0;
   j := 0;
   for i := 0 to 13 do begin
      b := Byte(IMEI[i + 1]) - $30;
      c := b SHL (i and 1);
      inc (CRCDword, c div 10);
      inc (CRCDword, c mod 10);
      if (i and 1) = 1 then begin
         Block[j] := Block[j] + (b SHL 4);
         inc(j);
      end else begin
         Block[j] := b;
      end; { if }
   end; { for }
//   CRC := (10 - (CRCDword mod 10)) MOD 10;
   CRC := 10 - (CRCDword mod 10);
   if CRC=10 then CRC:=0;
   Block[7] := CRC SHL 4;
   BP0A := 0;
   BP0B := 0;
   for i:= 0 to 7 do begin
      if (i and 1) = 1 then
         BP0A := BP0A xor Block[i]
      else
         BP0B := BP0B xor Block[i];
   end; { for }
   BP0C := BP0A xor BP0B XOR $FF;
   if BlockType = b76 then
      Block[8] := BP0B
   else
      Block[8] := BP0A;
   Block[9] := BP0C;
   EnCodeImeiBlock(Block, BlockType, PhoneModel);
end;


procedure IMEI2xBCD(IMEI: string);
var
   i, j: integer;
begin
   // Перевод IMEI в BCD
   i := 0;
   j := 1;
   BCDImei[0] := 10;
   while i < 7 do begin
      BCDImei[i] := BCDImei[i] or ((Byte(IMEI[j]) + $D0) shl 4);
      inc(i);
      inc(j);
      BCDImei[i] := (Byte(IMEI[j]) + $D0);
      inc(j);
   end; { while }
end;

function CalkImei15(si: string; var i15: char ):boolean;
var
i,x,c : integer;
s : string;
begin
  result:=False;
  x:=length(si);
  if x < 14 then exit;
  c:=0;
  for i:=1 to 14 do begin
    if (si[i]<'0') or (si[i]>'9') then exit;
    if ((i and 1)<>0) then c := c + (Byte(si[i]) and $0F)
    else
     if (si[i]>'4') then c := c + ((Byte(si[i]) and $0F)shl 1) - 9
     else c := c + ((Byte(si[i]) and $0F) shl 1);
  end;
  s:=IntToStr(c);
  i:=length(s);
  i15:=s[i];
  if i15<>'0' then Byte(i15):=$6A-Byte(i15);
  result:=True;
end;

//const
//PVkey1 = $50565056;
//PVkey2 = $6736978E;

procedure Crypt5121key1(var OutBuf: array of byte);
begin
            SecKey2[0] := eepSkey xor $7F0BF23B; // ServiceKey
            SecKey2[1] := eepESN;   // ESN
            SecKey2[14] := DWord((@BCDImei[0])^);
            SecKey2[15] := DWord((@BCDImei[4])^);
            DWord((@OutBuf[0])^):=$77C5742D;
            DWord((@OutBuf[4])^):=$F49A4ADA;
            CodeBlock(OutBuf, 8, SecKey2, True);
end;

procedure Crypt5121mkey(mkey: dword; num : dword; var OutBuf: array of byte);
begin
//    SecKey2[0] := MasterCode xor $7F0BF23B;
//    SecKey3[14] := MasterCode xor $7F0BF23B;
//    потом этим ключом расшифровывается соответствующий блок 5121
//    и если он равен 2D 74 C5 77... то мастер правильный

//            SetLength(DecodedBlock, 8);
            SecKey2[0] := mkey xor $7F0BF23B;
            SecKey2[1] := eepESN;   // ESN
            SecKey2[14] := DWord((@BCDImei[0])^);
            SecKey2[15] := DWord((@BCDImei[4])^);

            SecKey3[0] := $08 + (BCDImei[0] shl 8)+ (BCDImei[1] shl 16)+ (BCDImei[2] shl 24); // bcdimei
            SecKey3[1] := DWord((@BCDImei[3])^);
            SecKey3[14] := SecKey2[0];
            SecKey3[15] := SecKey2[1]; // ESN

            DWord((@OutBuf[0])^):= num xor $77C5742D;
            DWord((@OutBuf[4])^):=$F49A4ADA;

            CodeBlock(OutBuf, 8, SecKey3, True);
            CodeBlock(OutBuf, 8, SecKey2, True);
end;

procedure StartCalk5121mkeys(xIMEI: string; xESN, MKey: dword);
begin
            IMEI2xBCD(xIMEI);
            SecKey2[0] := MKey xor $7F0BF23B; // Mkey
            SecKey2[1] := xESN;   // ESN
            SecKey2[14] := DWord((@BCDImei[0])^);
            SecKey2[15] := DWord((@BCDImei[4])^);
//
            SecKey3[0] := $08 + (BCDImei[0] shl 8)+ (BCDImei[1] shl 16)+ (BCDImei[2] shl 24); // bcdimei
            SecKey3[1] := DWord((@BCDImei[3])^);
            SecKey3[14] := SecKey2[0];
            SecKey3[15] := SecKey2[1]; // ESN
end;

//function StepCalk5121mkeys(var CmpBuf: array of dword; var Mkeys: array of dword) : boolean;
function StepCalk5121mkeys(CmpBuf :pointer ; var Mkeys: array of dword) : boolean;
var
dw :dword;
i,x : dword;
TmpBuf : array[0..7] of byte;
//pd : array of dword;
begin
            x:=6;
            dw := SecKey2[0] xor $7F0BF23B;
//            pd := @Cmpbuf;
            for i:=0 to 5 do begin
             if Mkeys[i]=$FFFFFFFF then begin
              Dword((@TmpBuf[0])^):= Dword(CmpBuf^);
              inc(dword(CmpBuf),4);
              Dword((@TmpBuf[4])^):= Dword(CmpBuf^);
              inc(dword(CmpBuf),4);
              CodeBlock(TmpBuf, 8, SecKey2, False);
              CodeBlock(TmpBuf, 8, SecKey3, False);
              if (DWord((@TmpBuf[4])^)=$F49A4ADA)
              and (DWord((@TmpBuf[0])^)=i xor $77C5742D)
              then begin
               Mkeys[i] := dw;
              end;
             end
             else begin
              dec(x);
              inc(dword(CmpBuf),8);
             end
            end;
            inc(dw);
            if x=0 then result:=True
            else if dw>99999999 then result:=True
            else begin
             SecKey2[0] := dw xor $7F0BF23B;
             SecKey3[14] := dw xor $7F0BF23B;
             result:=False;
            end;
end;


procedure code5077(var eBlock: array of byte; CryptMode: boolean);
begin
   if CryptMode then begin
      DWord((@eBlock[0])^):=DWord((@eBlock[0])^) xor $BA1FE5D7;
      DWord((@eBlock[4])^):=DWord((@eBlock[4])^) xor $D95D2DFD;
      CodeBlock(eBlock, 232, SecKey1, CryptMode);
   end
   else begin
      CodeBlock(eBlock, 232, SecKey1, CryptMode);
      DWord((@eBlock[0])^):=DWord((@eBlock[0])^) xor $BA1FE5D7;
      DWord((@eBlock[4])^):=DWord((@eBlock[4])^) xor $D95D2DFD;
   end; { if }
end;

procedure code5008(var eBlock: array of byte; CryptMode: boolean);
begin
   if CryptMode then begin
      DWord((@eBlock[0])^):=DWord((@eBlock[0])^) xor $BA1FE5D7;
      DWord((@eBlock[4])^):=DWord((@eBlock[4])^) xor $D95D2DFD;
      DWord((@eBlock[32])^):=DWord((@eBlock[32])^) xor $BA1FE5D7;
      DWord((@eBlock[36])^):=DWord((@eBlock[36])^) xor $D95D2DFD;
      CodeBlock(eBlock,32,SecKey1, CryptMode);
      CodeBlock(eBlock[32],192,SecKey1, CryptMode);
   end
   else begin
      CodeBlock(eBlock[32],192,SecKey1, CryptMode);
      CodeBlock(eBlock,32,SecKey1, CryptMode);
      DWord((@eBlock[0])^):=DWord((@eBlock[0])^) xor $BA1FE5D7;
      DWord((@eBlock[4])^):=DWord((@eBlock[4])^) xor $D95D2DFD;
      DWord((@eBlock[32])^):=DWord((@eBlock[32])^) xor $BA1FE5D7;
      DWord((@eBlock[36])^):=DWord((@eBlock[36])^) xor $D95D2DFD;
   end; { if }
end;

procedure ProviderLock5008(Provider1, Provider2 : byte; var blk5008: array of byte);
begin
   if Provider1 > 0 then begin
      if Provider1 = 1 then begin
      // Autolock to network
         blk5008[10] := 2;
         blk5008[26] := $0;
      end else begin
      // Lock to provider
         blk5008[10] := 1;
         blk5008[11] := Provider1;
         blk5008[26] := $FE;
         if Provider2 > 0 then
            blk5008[17] := Provider2;
      end; { if }
   end;
end;

procedure Crypt5008blk(EKey: dword; var blk5008: array of byte);
begin
//      SetLength(blk5008, 224);
      CRCBuffer(blk5008[8],22);
      CRCBuffer(blk5008[40],176);
      SecKey1[12]:=EKey;
      SecKey1[14]:=DWord((@BCDImei[0])^);
      SecKey1[15]:=DWord((@BCDImei[4])^);
      code5008(blk5008,True);
end;

procedure DeCrypt5008blk(EKey: dword; var blk5008: array of byte);
begin
//      SetLength(DecodedBlock, 224);
      SecKey1[12]:=EKey;
      SecKey1[14]:=DWord((@BCDImei[0])^);
      SecKey1[15]:=DWord((@BCDImei[4])^);
      code5008(blk5008,False);
end;

procedure Crypt5077blk(EKey: dword; var blk5077: array of byte);
begin
//      SetLength(blk5077, 232);
      CRCBuffer(blk5077[8],216);
//      CRCBuffer(blk5077[0],8);
//      CRCBuffer(blk5077[8+216],6);
      SecKey1[12]:=EKey;
      SecKey1[14]:=DWord((@BCDImei[0])^);
      SecKey1[15]:=DWord((@BCDImei[4])^);
      code5077(blk5077,True);
end;

procedure DeCrypt5077blk(EKey: dword; var blk5077: array of byte);
begin
      SecKey1[12]:=EKey;
      SecKey1[14]:=DWord((@BCDImei[0])^);
      SecKey1[15]:=DWord((@BCDImei[4])^);
//      SetLength(blk5077, 232);
      code5077(blk5077,False);
end;


procedure Decode76(var Block: array of byte; PhoneModel: byte);
begin
   DeCodeImeiBlock(Block, b76, PhoneModel);
end;

procedure Encode76(var Block: array of byte; PhoneModel: byte);
begin
   EnCodeImeiBlock(Block, b76, PhoneModel);
end;

procedure Decode5009(var Block: array of byte; PhoneModel: byte);
begin
   DeCodeImeiBlock(Block, b5009, PhoneModel);
end;

procedure Encode5009(var Block: array of byte; PhoneModel: byte);
begin
   EnCodeImeiBlock(Block, b5009, PhoneModel);
end;

procedure Create76(IMEI: string; var Block: array of byte; PhoneModel: byte);
begin
   CreateIMEIBlock(IMEI, Block, PhoneModel, b76);
end;

procedure Create5009(IMEI: string; var Block: array of byte; PhoneModel: byte);
begin
   CreateIMEIBlock(IMEI, Block, PhoneModel, b5009);
end;

procedure Create5008(IMEI: string; ESN: dword; var Block: array of byte; PhoneModel: byte);
begin
{
$06,$CC,$48,$CC,$00,$00,$00,$00, // FC 9F 60 A0 00 00 00 00 // Freia 58 F8 6B 4E 8C A7 53 EC
$00,$03,$00,$00,$00,$00,$67,$00,$00,$00,$00,$00,$FF,$00,$FF,$FF,$FF,$FF,$FF,$FF,$00,$FF,$62,$64,
$D6,$CE,$13,$CF,$00,$00,$00,$00, // EC A2 29 A3 00 00 00 00 // Freia 58 F8 6B 4E 8C A7 53 EC
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$50,$00,$FF,$FF,$FF,$00,$FF,$FF }
// 58 F8 6B 4E 8C A7 53 EC
   Dword((@Block[0])^):=$56505650+$00100000;//$4E6BF858;// $A0609FFC;//$CC48CC06;
   Dword((@Block[4])^):=0;//$EC53A78C; //0;
   Dword((@Block[8])^):=$00000300;
   Dword((@Block[8+4])^):=$00670000;
   Dword((@Block[8+8])^):=$00000000;
   Dword((@Block[8+12])^):=$FFFFFFFF; //$FFFF00FF;
   Dword((@Block[8+16])^):=$FFFFFFFF;
   Dword((@Block[8+20])^):=$6462FF00; // CRCBuffer(Block[8],22);
   Dword((@Block[8+24])^):=$56505650+$00300020;//$4E6BF858;//$A329A2EC;//$CF13CED6;
   Dword((@Block[8+24+4])^):=0;//$EC53A78C;//0;
   FillChar(Block[8+24+8],184,$ff);
   dWord((@Block[8+24+8+176])^):=$0050;  // CRCBuffer(Block[8+24+8],176);
   dWord((@Block[220])^):=$00;
   IMEI2xBCD(IMEI);
   Crypt5008blk(ESN,Block);
end;

procedure Create5077(IMEI: string; ESN: dword; var Block: array of byte; PhoneModel: byte);
begin
{
$4A,$D2,$99,$D2,$00,$00,$00,$00, // 00 A6 3C A6 00 00 00 00
// Freia 58 F8 6B 4E 8C A7 53 EC
$FF,$FF,$FF,$00,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
$29,$FF,$3D,$06,$06,$0B,$80,$F3  // 29 FF 75 7B 2E D4 B8 4A
}
// 0xD7, 0xE5, 0x1F, 0xBA, 0xFD, 0x2D, 0x5D, 0xD9
   Dword((@Block[0])^):=$56505650+$00500040;//$4E6BF858;//$A63CA600;//$D299D24A;
   Dword((@Block[4])^):=0;//$EC53A78C;//0;
   FillChar(Block[8],224,$ff);
   Block[11]:=0;
   Dword((@Block[224])^):=$063DFF29;//$7B75FF29;  //   CRCBuffer(Block[8],216);
   Dword((@Block[228])^):=$F3800B06;//$4AB8D42E; // ??
   IMEI2xBCD(IMEI);
   Crypt5077blk(ESN,Block);
end;

procedure Create512x(xIMEI: string; xESN, xSkey: dword; var xMkey: array of Dword );
var
i : integer;
begin
          eepESN:=xESN;
          eepSkey:=xSkey;
          IMEI2xBCD(xIMEI);
          // Create 5121 block
          Crypt5121key1(EEP5121[0]);
          for i:=0 to 5 do Crypt5121mkey(xMkey[i],i,EEP5121[(i shl 3)+8]);
          // Create 5122 block
          DWord((@EEP5122[0])^):=eepSKey;
          Word((@EEP5122[4])^):=$0058;
          // Create 5123 block
          DWord((@EEP5123[0])^):=$FFFF1F07;
          Move(EEP5121,EEP5123[4],8);
          Move(xIMEI[5],EEP5123[12],11);
          EEP5123[23]:=0;
          IMEI2BCD(xIMEI,EEP5123[24]);
          EEP5123[31]:=$FF;
end;

procedure Create52(xESN, xSkey: dword; MinSW : byte);
var
i : integer;
buffer : array[0..63] of byte;
s : string;
b : byte;
begin
          // Create bootkey
          buffer[16]:=$80;
          FillChar(buffer[17], 64-17, 0);
          buffer[56]:=$80;
          Dword((@buffer[0])^):=xESN;
          Dword((@buffer[4])^):=xSkey;
          for i:=0 to 7 do buffer[i+8]:=buffer[i] xor buffer[i+3];
          MD5Init;
          MD5Transform(@buffer);
          // Create 52 block
          Move(MD5buf,EEP0052,16);
          s:=IntToStr(MinSW);
          i:=length(s);
          if i=1 then b:=Byte(s[1]) and $0f
          else if i=2 then b:=(Byte(s[2]) and $0f) or ((Byte(s[1]) and $0f) shl 4)
          else b:=$FF;
          EEP0052[$10]:=b;
          Move(blkEEP52[$11],EEP0052[$11],290-17);
end;
end.
