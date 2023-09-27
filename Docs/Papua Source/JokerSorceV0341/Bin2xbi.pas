unit Bin2xbi;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, FileCtrl,

  SwpE, HWID_EGOLD;
type
  TFormBin2Swp = class(TForm)
    ButtonSaveXBI: TButton;
    ProgressBar: TProgressBar;
    GroupBox1: TGroupBox;
    CheckBoxBCORE: TCheckBox;
    CheckBoxSW: TCheckBox;
    CheckBoxLG: TCheckBox;
    CheckBoxEEL: TCheckBox;
    CheckBoxFFSA: TCheckBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    EditMobName: TEdit;
    Label3: TLabel;
    EditLGpack: TEdit;
    ButtonSWP: TButton;
    Button1: TButton;
    CheckBoxFFSB: TCheckBox;
    CheckBoxFFSC: TCheckBox;
    CheckBoxEEF: TCheckBox;
    GroupBox3: TGroupBox;
    EditDataBaseName: TEdit;
    CheckBoxKeys: TCheckBox;
    CheckBoxClrFFA: TCheckBox;
    CheckBoxClrFFB: TCheckBox;
    procedure ButtonSaveXBIClick(Sender: TObject);
    procedure ButtonSWPClick(Sender: TObject);
    procedure CheckBoxEnKeysClick(Sender: TObject);
    procedure CheckBoxFFSAClick(Sender: TObject);
    procedure CheckBoxFFSBClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    function GetSaveMask : byte;
  public
    { Public declarations }
    XBIMemoryStream : TMemoryStream;
    SWPMemoryStream : TMemoryStream;
    function SaveSwpBuf : boolean;
    function CreateXBIHead(MobileName,DatabaseName,lgstr : string; startaddr, endaddr : dword ) : boolean;
    function CreateBIN2XBI(flgXor : boolean; xfilename: string; MobileName,DatabaseName,lgstr : string): boolean;
//    function CreateFileSWP(xfilename: string; MobileName,DatabaseName,lgstr : string): boolean;
    function SaveSWPblk(baseaddr : dword; sizebuf : integer;  var buf : array of byte) : boolean;
    function CreateXBIData(baseaddr: dword; sizebuf : integer; var buf: array of byte) : boolean;
    function OpenUserBinFile(sbinfilename : string) : boolean;
    procedure CloseUserBinFile;
    function OpenSwpFile(NameSwp: string; var xBkey : array of byte) : boolean;
    function ReadSwpExe(hxFile, iSizexData : integer; sNamexFile : string) : boolean;
    function ReadXBZdata(hxFile, iSizexData, iSizeMemAdd : integer; sNamexFile : string) : boolean;
    function OpenSwpExe(wsefilename : string) : boolean;
    procedure SaveXBZfile(xfilename : string);
    function SaveSwpFile(flgmodes : integer; sBaseName : string) : boolean;
end;

var
    FormBin2Swp : TFormBin2Swp;
    sSwp_Err : string; // Последняя Ошибка
    sizebinfile : integer; // размер User Bin файла прошивки
    sizeswpfile : integer; // размер SWPEXE базового файла
    sizeexedata : integer; // размер EXE в WinSwupEXE файле
    sizexbzdata : integer; // размер данных XBZ(I) в WinSwupEXE файлe
    hBinFile : THandle = INVALID_HANDLE_VALUE; // User Bin файла прошивки
    hSWPFile : THandle = INVALID_HANDLE_VALUE; // SWPEXE базового файла ('SWPEXE409.SRC')
    outfilename : string;
    xbzfilename : string;
    binfilename : string;  // User Bin файла прошивки
    swpfilename : string;  // '.\SWPEXE409.SRC'
//    wsefilename : string;  //
//    sBinImei : string = '??????????????';
    NewSGold : boolean = False;
    HWbinFile : integer =0;
    TabSegBin : array[0..512] of byte;
    deletedeep,workeep : integer;
    xmeep : byte; // маска найденных блоков eep

const
XMASKEND = 0;
XMASKSWX = 1;
XMASKBCR = 2;
XMASKLGP = 4;
XMASKEEL = 8;
XMASKEEF = 16;
XMASKFFA = 32;
XMASKFFB = 64;
XMASKFFC = 128;

implementation

uses JMain;

{$R *.DFM}


var
bufexe : array[0..MAXSWPBSIZE] of byte;
//cntrexe : integer;
flgSWP : boolean;

function TFormBin2Swp.SaveSwpBuf : boolean;
var
i : integer;
begin
 result := False;
 if (swpblk.lenblk <> 0)
 then begin
  if flgSWP then begin
   i:=SWPMemoryStream.Read(bufexe,swpblk.lenblk);
   if i <> integer(swpblk.lenblk) then begin
    SWPMemoryStream.Seek(0,soFromBeginning);
    if SWPMemoryStream.Read(bufexe[i],swpblk.lenblk-dword(i)) <> integer(swpblk.lenblk)-i then begin
     sSwp_Err:='MemoryStream: Ошибка чтения!';
     exit;
    end;
   end;
   for i:=0 to swpblk.lenblk-1 do begin
     bufexe[i]:=bufexe[i] xor swpblk.b[i];
   end;
   if XBIMemoryStream.Write(bufexe,swpblk.lenblk) <> integer(swpblk.lenblk) then begin
    sSwp_Err:='MemoryStream: Ошибка записи!';
    exit;
   end  // if NOT FileWrite
   else result := True;
  end
  else begin
   if XBIMemoryStream.Write(swpblk.b,swpblk.lenblk) <> integer(swpblk.lenblk) then begin
    sSwp_Err:='MemoryStream: Ошибка записи!';
    exit;
   end  // if NOT FileWrite
   else result := True;
  end;
 end
 else result := True;
end;

function TFormBin2Swp.GetSaveMask : byte;
begin
        result:=0;
        if CheckBoxBCORE.Checked then result:=result or XMASKBCR;
        if CheckBoxSW.Checked then result:=result or XMASKSWX;
        if CheckBoxLG.Checked then result:=result or XMASKLGP;
        if CheckBoxEEL.Checked then result:=result or XMASKEEL;
        if CheckBoxEEF.Checked then result:=result or XMASKEEF;
        if CheckBoxFFSA.Checked then result:=result or XMASKFFA;
        if CheckBoxFFSB.Checked then result:=result or XMASKFFB;
        if CheckBoxFFSC.Checked then result:=result or XMASKFFC;
end;

function TFormBin2Swp.CreateXBIHead(MobileName,DatabaseName,lgstr : string; startaddr, endaddr : dword ) : boolean;
var
xmask : byte;
xstart : dword;
i : integer;
begin
//--------------- Head SMP
        result:=False;
        SWPblkHeadSMP;
        if NOT SaveSwpBuf then exit;
//--------------- Cmd Info
        if NOT SWPblk10Ver($0404) then exit;
        if NOT SaveSwpBuf then exit;
        if NOT SWPblk11Ver($0123) then exit;
        if NOT SaveSwpBuf then exit;
        if SWPblkFEstr($12,FormatDateTime('dd.mm.yy hh:nn:ss',Now))<> ERR_NO then exit;
        if NOT SaveSwpBuf then exit;
        if SWPblkFEstr($13,FormatDateTime('dd.mm.yy hh:nn:ss',Now))<> ERR_NO then exit;
        if NOT SaveSwpBuf then exit;
        if SWPblkFEstr($16,'OFFICIAL')<> ERR_NO then exit;
        if NOT SaveSwpBuf then exit;

        if NewSGold then begin // S75 xbi
         if SWPblkFEstr($17,'minosem')<> ERR_NO then exit;
        end else begin
         if SWPblkFEstr($17,'pene_in')<> ERR_NO then exit;  // bootcor pene_in
        end;

        if NOT SaveSwpBuf then exit;
        if SWPblkFEstr($1A,lgstr)<> ERR_NO then exit;
        if NOT SaveSwpBuf then exit;
        if SWPblkFE($1B,4,[0,0,0,0])<> ERR_NO then exit;
        if NOT SaveSwpBuf then exit;
        if SWPblkFE($1D,2,[$00,$92])<> ERR_NO then exit; // SVN 63
        if NOT SaveSwpBuf then exit;
        if NOT SWPblk23SizeFlash(sizebinfile) then exit;
        if NOT SaveSwpBuf then exit;
        if SWPblkFE($24,2,[$18,$86])<> ERR_NO then exit; // ??????
//        if SWPblkFE($24,2,[$61,$EA])<> ERR_NO then exit; // ??????
//        if SWPblkFE($24,2,[$C4,$ED])<> ERR_NO then exit; // ??????
        if NOT SaveSwpBuf then exit;
{
        if SWPblkFE($25,4,[$A0,$00,$0A,$00])<> ERR_NO then exit; // Addr Flash 'EnableFlashWrite' = 0xA0000A00 ?
        if NOT SaveSwpBuf then exit;
        if SWPblkFE($27,4,[$00,$00,$00,$00])<> ERR_NO then exit; // ?
        if NOT SaveSwpBuf then exit;

{
        if SWPblkFE($25,4,[$A0,$08,$FE,$00])<> ERR_NO then exit; // Addr Flash 'EnableFlashWrite' = 0xA0000A00 ?
//        if SWPblkFE($25,4,[$A0,$00,$0A,$00])<> ERR_NO then exit; // Addr Flash 'EnableFlashWrite' = 0xA0000A00 ?
        if NOT SaveSwpBuf then exit;
        if SWPblkFE($27,4,[$00,$00,$00,$00])<> ERR_NO then exit; // ?
        if NOT SaveSwpBuf then exit;
//}
        if SWPblkFEstr($28,MobileName)<> ERR_NO then exit; // MobileName: 'BC65' Project Name 2*
        if NOT SaveSwpBuf then exit;
        if SWPblkFEstr($29,'SIEMENS')<> ERR_NO then exit;
        if NOT SaveSwpBuf then exit;
        if SWPblkFEstr($2A,'PV_bin2swp_V0.0')<> ERR_NO then exit;
        if NOT SaveSwpBuf then exit;
{
        i:=0;
        while i
        if startaddr - endaddr > $7FFFFF then begin
         while startaddr - endaddr > $800000 do begin
          if NOT SWPblk30EraseBlk(startaddr,startaddr+$7FFFFF) then exit;
          if NOT SaveSwpBuf then exit;
          startaddr:=startaddr+$800000;
         end;
        end;
//}
        xmask:=GetSaveMask;
        xstart:=0;
        for i:=0 to 512 do begin
// EELITE   $00FE0000...$01000000
// EEFULL   $00220000...$00260000
// langPack $000E0000...$00200000
// FFS      $04E00000...$00800000 $18000000...$20000000
// FFS_B    $02600000...$02E00000
// FFS_C    $02E00000...$04E00000
// SW  $A0020000..$A01FFFFF, $A0820000..$A0FDFFFF, $A1000000..$A17FFFFF
         if (TabSegBin[i] and xmask)<>0 then begin
          if xstart=0 then xstart:=$A0000000+(dword(i) shl 17);
         end
         else begin
          if xstart<>0 then begin
           if NOT SWPblk30EraseBlk(xstart,$A001FFFF+(dword(i-1) shl 17)) then exit;
           if NOT SaveSwpBuf then exit;
           xstart:=0;
          end;
          if TabSegBin[i]=0 then break;
         end;
        end;
        if SWPblkFE($31,1,[$01])<> ERR_NO then exit;
        if NOT SaveSwpBuf then exit;
        if SWPblkFE($32,1,[$00])<> ERR_NO then exit;
        if NOT SaveSwpBuf then exit;
        if SWPblkFE($33,2,[$00,$00])<> ERR_NO then exit;
        if NOT SaveSwpBuf then exit;

        if SWPblkFE($34,1,[$07])<> ERR_NO then exit; //07 'SGOLDLite-Projects(x65)'
        if NOT SaveSwpBuf then exit;
//{
        if SWPblkFE($37,8,[$A0,$00,$08,$E0,$00,$00,$00,$00])<> ERR_NO then exit; // Flash Addres: 0xA00008E0, SW Code: 00 00 00 00
        if NOT SaveSwpBuf then exit;
        if SWPblkFE($38,2,[$00,$04])<> ERR_NO then exit; // Use in SW-Transmittion word 0x0004
        if NOT SaveSwpBuf then exit;

        if SWPblkFE($35,1,[$01])<> ERR_NO then exit;
        if NOT SaveSwpBuf then exit;
        if SWPblkFE($37,8,[$A0,$08,$FC,$E0,$41,$4D,$C0,$5B])<> ERR_NO then exit; // Flash Addres: 0xA00008E0, SW Code: 00 00 00 00
//        if SWPblkFE($37,8,[$A0,$00,$08,$E0,$00,$00,$00,$00])<> ERR_NO then exit; // Flash Addres: 0xA00008E0, SW Code: 00 00 00 00
        if NOT SaveSwpBuf then exit;
        if SWPblkFE($38,2,[$00,$04])<> ERR_NO then exit; // Use in SW-Transmittion word 0x0004
        if NOT SaveSwpBuf then exit;
//}
        if SWPblkFE($39,1,[$00])<> ERR_NO then exit;  // Compression Type: 00
        if NOT SaveSwpBuf then exit;

        if SWPblkFE($40,1,[$00])<> ERR_NO then exit; // Type UpDate: 0=MobSw , 7=ExtendedNewSplit
        if NOT SaveSwpBuf then exit;

        if SWPblkFE($50,2,[$00,$0E])<> ERR_NO then exit;  // Size 'Data Map Info' 14 bytes
        if NOT SaveSwpBuf then exit;
        i:=HWbinFile;
        if i=0 then begin
         i:=320;
         FormMain.AddLinesLog('BI2XBI: Warning! Неизвестен HWID - используем HWID=320!');
        end;
        if SWPblkFE($51,14,[$02,$01,Byte(i),Byte(i shr 8),$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF])<> ERR_NO then exit; // Block 'Data Map Info'
        if NOT SaveSwpBuf then exit;
        if SWPblkFE($52,0,[$00])<> ERR_NO then exit;   // End 'Data Map Info'
        if NOT SaveSwpBuf then exit;

        if SWPblkFE($60,1,[$00])<> ERR_NO then exit;
        if NOT SaveSwpBuf then exit;
        if SWPblkFEstr($61,DatabaseName)<> ERR_NO then exit; //'User#code_data' Database Name*
        if NOT SaveSwpBuf then exit;
        if SWPblkFEstr($62,'Bin2swp_V0.1')<> ERR_NO then exit; // Project Name 4*
        if NOT SaveSwpBuf then exit;
        if SWPblkFEstr($63,'PapuaSoft_and_PapuaHard')<> ERR_NO then exit; // Baseline Release*
        if NOT SaveSwpBuf then exit;
        if SWPblkFEs($64,MobileName)<> ERR_NO then exit; // BC65
        if NOT SaveSwpBuf then exit;
        if NewSGold then begin // S75 xbi
         if SWPblkFEs($70,#01+'wsw_x75.dll')<> ERR_NO then exit; // FileDll: 'wsw_r65.dll'
        end
        else if SWPblkFEs($70,#01+'wsw_r65.dll')<> ERR_NO then exit; // FileDll: 'wsw_r65.dll'
        if NOT SaveSwpBuf then exit;
        if SWPblkFE($04,0,[$00])<> ERR_NO then exit;
        if NOT SaveSwpBuf then exit;
//--------------- Data
{
        if SWPblkData($A0200000,4,[$FF,$FF,$FF,$FF])<> ERR_NO then exit;
        if NOT SaveSwpBuf then exit;
//}
//--------------- End
        result:=True;
end;

function TFormBin2Swp.SaveSWPblk(baseaddr : dword; sizebuf : integer;  var buf : array of byte) : boolean;
var
blkptr : integer;
begin
  result:=False;
  blkptr:=0;
   while sizebuf > MAXSWPDATA do begin
     if SWPblkData(baseaddr,MAXSWPDATA,buf[blkptr])<> ERR_NO then exit;
     if NOT SaveSwpBuf then exit;
     blkptr:=blkptr+MAXSWPDATA;
     baseaddr:=baseaddr+MAXSWPDATA;
     sizebuf:=sizebuf-MAXSWPDATA;
   end;
   if sizebuf>0 then begin
    if SWPblkData(baseaddr,sizebuf,buf[blkptr])<> ERR_NO then exit;
    if NOT SaveSwpBuf then exit;
   end;
  result:=True;
end;

function TFormBin2Swp.CreateXBIData(baseaddr: dword; sizebuf : integer; var buf: array of byte) : boolean;
var
blkptr,readbytes,x : integer;
begin
  result:=False;
  readbytes:=0;
  x:=0;
  blkptr:=0;
  while readbytes < sizebuf do begin
   if buf[readbytes]=$ff then begin
    if x=6 then begin
     if NOT SaveSWPblk(baseaddr+dword(blkptr),readbytes-blkptr-x,buf[blkptr]) then exit;
    end;
    inc(x);
   end
   else if x<>0 then begin
    if x>6 then blkptr:=readbytes;
    x:=0;
   end;
   inc(readbytes);
  end;
  if NOT SaveSWPblk(baseaddr+dword(blkptr),readbytes-blkptr-x,buf[blkptr]) then exit;
  result:=True;
end;

function TFormBin2Swp.CreateBIN2XBI(flgXor : boolean; xfilename: string; MobileName,DatabaseName,lgstr : string): boolean;
var
 F : TFileStream;
 startaddr, endaddr : dword;
 i : integer;
 xmask : byte;
 buf : array[0..$1FFFF] of byte;
begin
        result:=False;
        ProgressBar.Max:=sizebinfile shr 17;
        ProgressBar.Position:=0;
        outfilename := xfilename;
        startaddr:=$A0000000;
        endaddr := dword(sizebinfile)-1 + $A0000000;
        xmask := GetSaveMask;
        XBIMemoryStream := TMemoryStream.Create;
        XBIMemoryStream.SetSize(sizebinfile);
        flgSWP:=flgXor;
        if flgXOR then SWPMemoryStream.Seek(0,soFromBeginning);
        i:=0;
//        chkdata:=0;
        deletedeep:=0; workeep:=0; xmeep:=0;
        FileSeek(hBinFile,0,0);
        if CreateXBIHead(MobileName,DatabaseName,lgstr,startaddr, endaddr) then begin
         while startaddr < endaddr do begin
          if (TabSegBin[i] and xmask)<>0 then begin
           if (CheckBoxClrFFA.Checked and (TabSegBin[i]=XMASKFFA))
           or (CheckBoxClrFFB.Checked and (TabSegBin[i]=XMASKFFB))
           then begin
            FillChar(buf[0],SizeOf(buf),$FF);
            if NewSGold then begin
             if TabSegBin[i] = XMASKFFA then begin
             // 46 46 53 5F-30 00 00 00-00 00 00 00-F0 FF FF FF
              dword((@buf[0])^):=$5F534646;
              dword((@buf[4])^):=$00000030;
             end
             else begin
             // 46 46 53 5F-31 00 00 00-00 00 00 00-F0 FF FF FF
              dword((@buf[0])^):=$5F534646;
              dword((@buf[4])^):=$00000031;
             end;
            end
            else begin
             if TabSegBin[i] = XMASKFFA then begin
             // 46 46 53 00-00 00 00 00-00 00 00 00-F0 FF FF FF
              dword((@buf[0])^):=$00534646;
              dword((@buf[4])^):=$00000000;
             end
             else begin
             // 46 46 53 5F-42 00 00 00-00 00 00 00-F0 FF FF FF
              dword((@buf[0])^):=$5F534646;
              dword((@buf[4])^):=$00000042;
             end;
            end;
            dword((@buf[8])^):=$00000000;
            dword((@buf[12])^):=$FFFFFFF0;
            if FileSeek(hBinFile,0,1)-FileSeek(hBinFile,SizeOf(buf),1)<>-SizeOf(buf) then begin
             FileClose(hBinFile);
             sSwp_Err:='Не преобразовать файл '+binfilename+'!';
             XBIMemoryStream.Free;
             if flgXOR then SWPMemoryStream.free;
             exit;
            end;
           end else
           if FileRead(hBinFile,buf,SizeOf(buf)) <> SizeOf(buf) then begin
            FileClose(hBinFile);
            sSwp_Err:='Не прочитать файл '+binfilename+'!';
            XBIMemoryStream.Free;
            if flgXOR then SWPMemoryStream.free;
            exit;
           end;
           if CheckBoxKeys.Checked and ((TabSegBin[i] and (XMASKBCR or XMASKEEL or XMASKEEF)) <> 0)
           then FormMain.ReCalkKeysData(TabSegBin[i],buf);
           if startaddr<>$A0000000 then begin
            if NOT CreateXBIData(startaddr, SizeOf(buf), buf) then begin
             FileClose(hBinFile);
             sSwp_Err:='Не преобразовать файл '+binfilename+'!';
             XBIMemoryStream.Free;
             if flgXOR then SWPMemoryStream.free;
             exit;
            end;
           end
           else begin
            if NOT CreateXBIData(startaddr+$210,SizeOf(buf)-$210,buf[$210]) then begin
             FileClose(hBinFile);
             sSwp_Err:='Не преобразовать файл '+binfilename+'!';
             XBIMemoryStream.Free;
             if flgXOR then SWPMemoryStream.free;
             exit;
            end;
            if NOT CreateXBIData(startaddr,$210,buf) then begin
             FileClose(hBinFile);
             sSwp_Err:='Не преобразовать файл '+binfilename+'!';
             XBIMemoryStream.Free;
             if flgXOR then SWPMemoryStream.free;
             exit;
            end;
           end;
          end
          else begin
           if FileSeek(hBinFile,0,1)-FileSeek(hBinFile,SizeOf(buf),1)<>-SizeOf(buf) then begin
            FileClose(hBinFile);
            sSwp_Err:='Не преобразовать файл '+binfilename+'!';
            XBIMemoryStream.Free;
            if flgXOR then SWPMemoryStream.free;
            exit;
           end;
          end;
          inc(i);
          startaddr := startaddr+SizeOf(buf);
          ProgressBar.Position:=i;
         end;
         F:=TFileStream.Create(outfilename,fmCreate);
         if flgXOR then begin
          SWPblkSizeXBI(XBIMemoryStream.Seek(0,soFromCurrent));
          flgSWP:=False;
          if NOT SaveSwpBuf then begin
           FileClose(hBinFile);
           XBIMemoryStream.Free;
           if flgXOR then SWPMemoryStream.free;
//           sSwp_Err:='Не преобразовать файл '+binfilename+'!';
           exit;
          end;
          SWPMemoryStream.Seek(0,soFromBeginning);
          F.CopyFrom(SWPMemoryStream,SWPMemoryStream.Size);
         end;
         XBIMemoryStream.SetSize(XBIMemoryStream.Seek(0,soFromCurrent));
         XBIMemoryStream.Seek(0,soFromBeginning);
         F.CopyFrom(XBIMemoryStream,XBIMemoryStream.Size);
         F.Free;
//         ShowMessage(FormatDateTime('dd.mm.yy hh:nn:ss',Now));
         result:=True;
        end;
//        FileClose(hBinFile);
        if flgXOR then SWPMemoryStream.free;
        XBIMemoryStream.Free;
end;

function TFormBin2Swp.OpenUserBinFile(sbinfilename : string) : boolean;
var
buf : array[0..15] of Byte;
i : integer;
b : byte;
begin
        result:=False;
        HWbinFile:=0;
        NewSGold:=False;
        BinFileName := sbinfilename;
        hBinFile := FileOpen(BinFileName,fmOpenRead or fmShareCompat);
        if hBinFile = INVALID_HANDLE_VALUE then begin
         sSwp_Err:='Не открыть файл '+binfilename+'!';
         exit;
        end;
        sizebinfile := FileSeek(hBinFile,0,2);
        if NOT((sizebinfile = $2000000) or (sizebinfile = $4000000)) then begin
         CloseUserBinFile;
         sSwp_Err:='Не верный файл '+binfilename+'!'+#13+#10+'Требуется ФуллФлэш bin файл!';
         exit;
        end;
        // lg?
        FileSeek(hBinFile,$8FC60,0);
        if FileRead(hBinFile,buf,SizeOf(buf)) <> SizeOf(buf) then begin
         CloseUserBinFile;
         sSwp_Err:='Не прочитать файл '+binfilename+'!';
         exit;
        end;
        if (buf[0]=$6C) and (buf[1]=103) and (buf[15]=0) then begin
         EditLGpack.Text:=pchar(@buf);
         // MobName
         if FileRead(hBinFile,buf,SizeOf(buf)) <> SizeOf(buf) then begin
          CloseUserBinFile;
          sSwp_Err:='Не прочитать файл '+binfilename+'!';
          exit;
         end;
         if buf[15]=0 then begin
          EditMobName.Text:=pchar(@buf);
          HWbinFile:=StrToHwID(@buf[0]);
          if (HWbinFile>=400) and (HWbinFile<500) then NewSGold:=True;
         end;
        end;
        FillChar(TabSegBin,SizeOf(TabSegBin),XMASKEND);
        i:=0;
        while i<(sizebinfile shr 17) do begin
         FileSeek(hBinFile,i shl 17,0);
         if FileRead(hBinFile,buf,8) <> 8 then begin
          CloseUserBinFile;
          sSwp_Err:='Не прочитать файл '+binfilename+'!';
          exit;
         end;
         case dword((@buf[0])^) of
          $E51FF004 : if i=0 then TabSegBin[i]:=XMASKBCR else TabSegBin[i]:=XMASKSWX; // BCORE   $00000000...$00020000
          $494C4545 : TabSegBin[i]:=XMASKEEL; // EELITE   $00FE0000...$01000000
          $55464545 : TabSegBin[i]:=XMASKEEF; // EEFULL   $00220000...$00260000
          $0000BBBB :
          begin
           TabSegBin[i]:=XMASKLGP; // langPack $000E0000...$00200000
           // NewlangPack 0xA1640000..0xA16BFFFF
           if i=178 then NewSGold:=True;
          end;
          $00534646 :
          begin
           TabSegBin[i]:=XMASKFFA; // FFS      $04E00000...$00800000 $18000000...$20000000
           NewSGold:=False;
          end;
          $5F534646 : // FFS_C    $02E00000...$04E00000 FFS_B    $02600000...$02E00000
          begin
           if buf[4]=Ord('C') then begin
            TabSegBin[i]:=XMASKFFC;
            NewSGold:=False;
           end
           else if buf[4]=Ord('B') then begin
            TabSegBin[i]:=XMASKFFB;
            NewSGold:=False;
           end
           else if buf[4]=Ord('0') then begin
            TabSegBin[i]:=XMASKFFA;
            NewSGold:=True;
           end
           else if buf[4]=Ord('1') then begin
            TabSegBin[i]:=XMASKFFB;
            NewSGold:=True;
           end
           else if buf[4]=Ord('2') then begin
            TabSegBin[i]:=XMASKFFC;
            NewSGold:=True;
           end;
          end;
         else TabSegBin[i]:=XMASKSWX;
         end;
         inc(i);
        end;
        if NewSGold then begin
         for i:=179 to 204 do TabSegBin[i]:=TabSegBin[178]; // XMASKLGP // langPack 0xA1640000..0xA16BFFFF
        end
        else begin
         for i:=8 to 15 do TabSegBin[i]:=TabSegBin[7]; // XMASKLGP // langPack
        end;
        b:=0;
        i:=0;
        while i<SizeOf(TabSegBin) do begin
         b:=TabSegBin[i] or b;
         if TabSegBin[i]=XMASKEEF then begin
          if TabSegBin[i+1]<>XMASKEEF then begin
           FormMain.AddLinesLog('Нет второго сегмента EEFULL!');
           TabSegBin[i]:=XMASKSWX;
          end
          else inc(i);
         end;
         inc(i);
        end;
        if (b and XMASKBCR) = 0 then begin
         FormMain.AddLinesLog('Отсутствует или неверен сегмент BCORE!');
         CheckBoxBCORE.Enabled:=False;
         CheckBoxBCORE.Checked:=False;
        end
        else CheckBoxBCORE.Enabled:=True;
        if (b and XMASKLGP) = 0 then  begin
         FormMain.AddLinesLog('Отсутствуют или неверны сегменты LgPack!');
         CheckBoxBCORE.Enabled:=False;
         CheckBoxBCORE.Checked:=False;
        end
        else CheckBoxBCORE.Enabled:=True;
        if (b and XMASKEEL) = 0 then begin
         FormMain.AddLinesLog('Отсутствует или неверен сегмент EELITE!');
         CheckBoxEEL.Enabled:=False;
         CheckBoxEEL.Checked:=False;
        end
        else CheckBoxEEL.Enabled:=True;
        if (b and XMASKEEF) = 0 then begin
         FormMain.AddLinesLog('Отсутствуют или неверны сегменты EEFULL!');
         CheckBoxEEF.Enabled:=False;
         CheckBoxEEF.Checked:=False;
        end
        else CheckBoxEEF.Enabled:=True;
        if (b and XMASKFFA) = 0 then begin
         FormMain.AddLinesLog('Отсутствуют или неверны сегменты FFS!');
         CheckBoxFFSA.Enabled:=False;
         CheckBoxFFSA.Checked:=False;
        end
        else CheckBoxFFSA.Enabled:=True;
        if (b and XMASKFFB) = 0 then begin
         FormMain.AddLinesLog('Отсутствуют или неверны сегменты FFS_B!');
         CheckBoxFFSB.Enabled:=False;
         CheckBoxFFSB.Checked:=False;
        end
        else CheckBoxFFSB.Enabled:=True;
        if (b and XMASKFFC) = 0 then begin
         FormMain.AddLinesLog('Отсутствуют или неверны сегменты FFS_C!');
         CheckBoxFFSC.Enabled:=False;
         CheckBoxFFSC.Checked:=False;
        end
        else CheckBoxFFSC.Enabled:=True;
        result:=True;
end;

procedure TFormBin2Swp.CloseUserBinFile;
begin
      if hBinFile <> INVALID_HANDLE_VALUE then begin
        FileClose(hBinFile);
        hBinFile := INVALID_HANDLE_VALUE;
        sizebinfile := 0;
      end;
end;

function TFormBin2Swp.OpenSwpFile(NameSwp: string; var xBkey : array of byte) : boolean;
var
i : integer;
sbuf : string;
//array[0..40] of byte; //27+11+1
begin
    result:=False;
//    SetLength(sbuf):=39;
    if hSwpFile <> INVALID_HANDLE_VALUE then begin
     FileClose(hSwpFile);
     hSwpFile := INVALID_HANDLE_VALUE;
    end;
    SwpFileName := IniFile.ReadString('Setup','SWPEXEFile','.\SWPEXE409.SRC');
    hSwpFile := FileOpen(SwpFileName,fmOpenRead or fmShareCompat);
    if hSwpFile = INVALID_HANDLE_VALUE then begin
     with FormMain.OpenDialog do begin
      FilterIndex:=1;
      FileName := IniFile.ReadString('Setup','SWPEXEFile','.\SWPEXE409.SRC');
      InitialDir := ExtractFilePath(FileName);
      FileName := ExtractFileName(FileName);
      if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
      if not DirectoryExists(InitialDir) then
      InitialDir := IniFile.ReadString('Setup','DirOld','.\');
      DefaultExt := 'src';
      Filter := 'SWPEXE files (*.src)|*.SRC|All files (*.*)|*.*';
      Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
      Title:='Укажите исходный файл SWPEXE.SRC.';
     end;//with OpenDialog
     if FormMain.OpenDialog.execute then begin
       SwpFileName := FormMain.OpenDialog.FileName;
       hSwpFile := FileOpen(SwpFileName,fmOpenRead or fmShareCompat);
       if hSwpFile = INVALID_HANDLE_VALUE then begin
        sSwp_Err:='Нет исходного файла SWPEXE.SRC!';
        exit;
       end;
     end
     else begin
      sSwp_Err:='Нет исходного файла SWPEXE.SRC!';
      exit;
     end;
    end; // if hBinFile = INVALID_HANDLE_VALUE
    sizeswpfile:= FileSeek(hSwpFile,0,2);
    if sizeswpfile<>368640 then begin
     FileClose(hSwpFile);
     hSwpFile := INVALID_HANDLE_VALUE;
     sSwp_Err:='Не верный файл '+SwpFileName+'!';
     exit;
    end;
    FileClose(hSwpFile);
    hSwpFile := INVALID_HANDLE_VALUE;

    SWPMemoryStream := TMemoryStream.Create;
//    SWPMemoryStream.SetSize(i);
    SWPMemoryStream.LoadFromFile(SwpFileName);
    SWPMemoryStream.Seek($27448,soFromBeginning); //$27460
//    16+9+2=27 $35216 ' ) V%d.%02d'
    SetLength(sbuf,16);
    if SWPMemoryStream.Read(sbuf[1],16) <> 16 then begin
     SWPMemoryStream.free;
     sSwp_Err:='ReadStream: Не обработать файл '+SwpFileName+'!';
     exit;
    end;
    if sbuf <> 'SIEMENS_BOOTCODE' then begin
     SWPMemoryStream.free;
     sSwp_Err:='Не верный файл SWPEXE.SRC!';
     exit;
    end;
    if (SWPMemoryStream.Seek($27460,soFromBeginning)<>$27460)
    or (SWPMemoryStream.Write(xBkey,16) <> 16)
    or (SWPMemoryStream.Seek($290F4,soFromBeginning)<>$290F4)
    or (SWPMemoryStream.Write(xBkey,16) <> 16)
    or (SWPMemoryStream.Seek($40EB0,soFromBeginning)<>$40EB0)
    or (SWPMemoryStream.Write(xBkey,16) <> 16) then begin
     SWPMemoryStream.free;
     sSwp_Err:='StoreBkey: Не обработать файл '+SwpFileName+'!';
     exit;
    end;
    SWPMemoryStream.Seek($35216,soFromBeginning);
    sbuf:='12';
    if SWPMemoryStream.Read(sbuf[1],2) <> 2 then begin
     SWPMemoryStream.free;
     sSwp_Err:='ReadStream: Не обработать файл '+SwpFileName+'!';
     exit;
    end;
    if sbuf <> 'PV' then begin
     SWPMemoryStream.free;
     sSwp_Err:='Не верный файл '+SwpFileName+'!';
     exit;
    end;
    i:=Length(NameSWP);
    if i>0 then sbuf:=NameSWP
    else sbuf:='UserBackup';
    if i>29 then SetLength(sbuf,29);
    sbuf:=sbuf+') V%d.%02d';
    SWPMemoryStream.Seek($35215,soFromBeginning);
    if SWPMemoryStream.Write(sbuf[1],Length(sbuf)) <> Length(sbuf) then begin
     SWPMemoryStream.free;
     sSwp_Err:='WriteStream: Не обработать файл '+SwpFileName+'!';
     exit;
    end;
    SWPMemoryStream.Seek(0,soFromBeginning);
////
    IniFile.WriteString('Setup','SWPEXEFile',SwpFileName);
    result:=True;
{////
}
end;

function TFormBin2Swp.ReadSwpExe(hxFile, iSizexData : integer; sNamexFile : string) : boolean;
var
Buf : array[0..16383] of byte;
i,sizeblk : integer;
begin
    result:=False;
    SWPMemoryStream := TMemoryStream.Create;
    SWPMemoryStream.SetSize(iSizexData);
    sizeblk:=SizeOf(Buf);
    i:=0;
    while (i<iSizexData) do begin
     if iSizexData-i < sizeblk then sizeblk := iSizexData-i;
     if FileRead(hxfile, Buf[0], sizeblk )<> sizeblk then begin
      SWPMemoryStream.free; //SWPMemoryStream:=nil;
      sSwp_Err:='Не прочитать файл '+sNamexFile+'!';
      exit;
     end;
     if SWPMemoryStream.Write(Buf[0],sizeblk) <> sizeblk then begin
      SWPMemoryStream.free; //SWPMemoryStream:=nil;
      sSwp_Err:='WriteStream: Не обработать файл '+sNamexFile+'!';
      exit;
     end;
     i:=i+sizeblk;
    end;
    SWPMemoryStream.Seek(0,soFromBeginning);
    result:=True;
end;

function TFormBin2Swp.ReadXBZdata(hxFile, iSizexData, iSizeMemAdd : integer; sNamexFile : string) : boolean;
var
BufXBZ : array[0..16383] of byte;
BufEXE : array[0..16383] of byte;
i,bytesread,sizeblk : integer;
begin
    result:=False;
    XBIMemoryStream := TMemoryStream.Create;
    XBIMemoryStream.SetSize(iSizexData+iSizeMemAdd);
    bytesread:=0;
    while (bytesread<iSizexData) do begin
     sizeblk:=SizeOf(BufXBZ);
     if (iSizexData-bytesread)<sizeblk then sizeblk:=iSizexData-bytesread;
     if FileRead(hxfile, BufXBZ[0], sizeblk )<>sizeblk then begin
      XBIMemoryStream.free; //XBIMemoryStream:=nil;
      SWPMemoryStream.free;
      sSwp_Err:='Не прочитать файл '+sNamexFile+'!';
      exit;
     end;
     i:=SWPMemoryStream.Read(BufEXE[0],sizeblk);
     if i <> sizeblk then begin
      SWPMemoryStream.Seek(0,soFromBeginning);
      if SWPMemoryStream.Read(BufEXE[i],sizeblk-i) <> sizeblk-i then begin
       XBIMemoryStream.free; //XBIMemoryStream:=nil;
       SWPMemoryStream.free;
       sSwp_Err:='MemoryStream(SWE): Ошибка чтения!';
       exit;
      end;
     end;
     for i:=0 to sizeblk-1 do BufXBZ[i]:=BufEXE[i] xor BufXBZ[i];
     if XBIMemoryStream.Write(BufXBZ[0],sizeblk) <> sizeblk then begin
      XBIMemoryStream.free; //SWPMemoryStream:=nil;
      SWPMemoryStream.free;
      sSwp_Err:='WriteStream(XBZ): Не обработать файл '+sNamexFile+'!';
      exit;
     end;
     bytesread:=bytesread+sizeblk;
    end;
//    XBIMemoryStream.Seek(0,soFromBeginning);
    SWPMemoryStream.Seek(0,soFromBeginning);
    result:=True;
end;

function TFormBin2Swp.OpenSwpExe(wsefilename : string) : boolean;
var
Buf : array[0..16383] of byte;
i : integer;
sizewsefile : integer; // размер WinSwupEXE файла
hWSEFile : THandle; // WinSwupEXE
begin
    result:=False;
//    wsefilename:=xFileName;
    hWSEFile:=FileOpen(wsefilename,fmOpenRead or fmShareCompat);
    if hWSEFile<>INVALID_HANDLE_VALUE then begin
     sizewsefile:=FileSeek(hWSEFile, 0, 2);
     if sizewsefile<300000 then begin
      sSwp_Err:='Неверный размер файла '+wsefilename+'!';
      FileClose(hWSEFile);
      exit;
     end;
     FileSeek(hWSEFile, sizewsefile-114, 0);
     if FileRead(hWSEFile, Buf[0], 114)<>114 then begin
      sSwp_Err:='Не прочитать файл '+wsefilename+'!';
      FileClose(hWSEFile);
      exit;
     end;
     if (not CompareMem(@SAG_JK_WH[0],@Buf[105],9))
     or (not CompareMem(@HeadSMP[0],@Buf[64],29))
     then begin
      sSwp_Err:='Неверный формат файла '+wsefilename+'!';
      FileClose(hWSEFile);
      exit;
     end;
     sizexbzdata:=0;
     for i:=0 to 31 do begin
       sizexbzdata:=sizexbzdata shr 1;
       if (Buf[i] and $80)<>0 then dword(sizexbzdata):= dword(sizexbzdata) or $80000000;
     end;
     if (sizewsefile < sizexbzdata) or (sizexbzdata<256) then begin
      FormMain.AddLinesLog('XBZSize = '+IntToStr(sizexbzdata)+' bytes.');
      sSwp_Err:='Неверный размер XBZ(I) данных в файле '+wsefilename+'!';
      FileClose(hWSEFile);
      exit;
     end;
     sizeexedata:=sizewsefile-sizexbzdata-114;
//     sizexbzdata:=sizexbzdata-114;
     FormMain.AddLinesLog('XBZSize = '+IntToStr(sizexbzdata)+' bytes.');
     FormMain.AddLinesLog('EXESize = '+IntToStr(sizeexedata)+' bytes.');
     if (sizeexedata < 200000) or (sizeexedata > 500000) then begin
      FormMain.AddLinesLog('EXESize = '+IntToStr(sizeexedata));
      sSwp_Err:='Неверный размер WinSwupEXE в файле '+wsefilename+'!';
      FileClose(hWSEFile);
      exit;
     end;
     FileSeek(hWSEFile, 0, 0);
     if Not ReadSwpExe(hWSEFile,sizeexedata,wsefilename) then begin
      FileClose(hWSEFile);
      exit;
     end;
     if Not ReadXBZdata(hWSEFile,sizexbzdata,0,wsefilename) then begin
      FileClose(hWSEFile);
      exit;
     end;
     FileClose(hWSEFile);
     result:=True;
     exit;
    end
    else begin
      sSwp_Err:='Не открыть файл '+wsefilename+'!';
    end;
end;

procedure TFormBin2Swp.SaveXBZfile(xfilename : string);
var
F : TFileStream;
begin
     XBIMemoryStream.Seek(0,soFromBeginning);
     F:=TFileStream.Create(xfilename,fmCreate);
     F.CopyFrom(XBIMemoryStream,XBIMemoryStream.Size);
     F.Free;
     XBIMemoryStream.free; //SWPMemoryStream:=nil;
     SWPMemoryStream.free;
end;


procedure TFormBin2Swp.ButtonSaveXBIClick(Sender: TObject);
begin
    ProgressBar.Position:=0;
    FormMain.ProgressBar.Position:=0;
    if GetSaveMask = 0 then begin
      ShowMessage('Необходимо выбрать хоть один параметр в "Include"!');
      exit;
    end;
    if CheckBoxKeys.Checked then begin
     if NOT FormMain.CreateFactoryEEPblks then begin
      ShowMessage(FormMain.StatusBar.Panels[PanelCmd].Text);
      exit;
     end;
    end;
    with FormMain.SaveDialog do begin
     FilterIndex:=1;
     FileName := IniFile.ReadString('Setup','OldXBIFile',EditMobName.text+EditLGpack.text+'.xbi');
     InitialDir := ExtractFilePath(FileName);
     FileName := ExtractFileName(FileName);
     if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
     if not DirectoryExists(InitialDir) then
      InitialDir := IniFile.ReadString('Setup','DirOld','.\');
     DefaultExt := 'xbi';
     Filter := 'XBI files (*.xbi)|*.xbi|All files (*.*)|*.*';
     Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
     Title:='Выберите имя для нового XBI файла';
   end;//with
  if FormMain.SaveDialog.Execute then begin
   Application.ProcessMessages;
   if CreateBIN2XBI(False,FormMain.SaveDialog.FileName,EditMobName.text,EditDataBaseName.text,EditLGpack.text)
   then begin
    if ((GetSaveMask and (XMASKEEF or XMASKEEL))=(XMASKEEF or XMASKEEL))
    and CheckBoxKeys.Checked then begin
     FormMain.AddLinesLog('EEPROM: Всего рабочих блоков '+IntToStr(workeep)+'.');
     FormMain.AddLinesLog('EEPROM: Full содержит '+intToStr(deletedeep)+' "удаленных" блоков!');
     if deletedeep>workeep then begin
      FormMain.AddLinesLog('EEPROM: данный Full требует дефрагментации EEP!');
     end;
    end;
    IniFile.WriteString('Setup','OldXBIFile',FormMain.SaveDialog.FileName);
    FormMain.StatusBar.Panels[PanelCmd].Text:='XBI файл сохранен в '+FormMain.SaveDialog.FileName;
    FormMain.AddLinesLog(FormMain.StatusBar.Panels[PanelCmd].Text);
    ProgressBar.Position:=ProgressBar.Max;
    FormMain.ProgressBar.Position:=100;
    Close;
   end
   else begin
    FormMain.StatusBar.Panels[PanelCmd].Text:=sSwp_Err;
    FormMain.AddLinesLog(FormMain.StatusBar.Panels[PanelCmd].Text);
    ShowMessage(sSwp_Err);
   end;
  end // if save dialog
end;


function TFormBin2Swp.SaveSwpFile(flgmodes : integer; sBaseName : string) : boolean;
var
F : TFileStream;
hXBZFile : THandle;
begin
//   if NOT OpenSwpFile(s+' '+EditDataBaseName.text) then begin
   result:=False;
   if NOT OpenSwpFile(sBaseName,FormMain.BootKey) then begin
    FormMain.AddLinesLog('Базовый файл '+SwpFileName+'...');
    FormMain.StatusBar.Panels[PanelCmd].Text:=sSwp_Err;
    FormMain.AddLinesLog(FormMain.StatusBar.Panels[PanelCmd].Text);
    FormMain.AddLinesLog('Найдите и закачайте данный файл из http://papuas.allsiemens.com');
    FormMain.AddLinesLog('( http://papuas.allsiemens.com/swpexe.rar - 124 KB )');
    FormMain.AddLinesLog('Распакуйте и положите в директорию этой программы.');
    ShowMessage(sSwp_Err);
   end
   else begin
    with FormMain.SaveDialog do begin
     FilterIndex:=1;
     FileName := IniFile.ReadString('Setup','OldSWPFile',EditMobName.text+EditLGpack.text+'.exe');
     InitialDir := ExtractFilePath(FileName);
     FileName := ExtractFileName(FileName);
     if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
     if not DirectoryExists(InitialDir) then
      InitialDir := IniFile.ReadString('Setup','DirOld','.\');
      DefaultExt := 'exe';
      Filter := 'SWPEXE files (*.exe)|*.exe|All files (*.*)|*.*';
      Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
      Title:='Выберите имя для нового Свуп файла';
    end;//with
    if FormMain.SaveDialog.Execute then begin
     Application.ProcessMessages;
     outfilename:=FormMain.SaveDialog.FileName;
     if flgmodes=0 then begin
      if not CreateBIN2XBI(True,FormMain.SaveDialog.FileName,EditMobName.text,EditDataBaseName.text,EditLGpack.text)
      then begin
       FormMain.StatusBar.Panels[PanelCmd].Text:=sSwp_Err;
       FormMain.AddLinesLog(FormMain.StatusBar.Panels[PanelCmd].Text);
       ShowMessage(sSwp_Err);
       Exit;
      end
      else begin
       FormMain.StatusBar.Panels[PanelCmd].Text:='SWPEXE файл сохранен в '+FormMain.SaveDialog.FileName;
       FormMain.AddLinesLog(FormMain.StatusBar.Panels[PanelCmd].Text);
       ProgressBar.Position:=ProgressBar.Max;
       FormMain.ProgressBar.Position:=100;
       Close; //FormBin2Swp
      end;
     end
     else begin
      // open xbz file to  XBIMemoryStream
      hXBZFile:=FileOpen(xbzfilename,fmOpenRead or fmShareCompat);
      if hXBZFile=INVALID_HANDLE_VALUE then begin
       sSwp_Err:='Не открыть файл '+xbzfilename+'!';
       SWPMemoryStream.free;
       FileClose(hXBZFile);
       Exit;
      end;
      sizexbzdata:=FileSeek(hXBZFile, 0, 2);
      if sizexbzdata<256 then begin
       sSwp_Err:='Неверный размер файла '+xbzfilename+'!';
       SWPMemoryStream.free;
       FileClose(hXBZFile);
       exit;
      end;
      FormMain.AddLinesLog('XBZSize = '+IntToStr(sizexbzdata)+' bytes.');
      FileSeek(hXBZFile, 0, 0);
      if Not ReadXBZdata(hXBZFile,sizexbzdata,114,xbzfilename) then begin
       FileClose(hXBZFile);
       Exit;
      end;
      FileClose(hXBZFile);
      F:=TFileStream.Create(outfilename,fmCreate);
      SWPblkSizeXBI(XBIMemoryStream.Seek(0,soFromCurrent));
      flgSWP:=False;
      if NOT SaveSwpBuf then begin
        XBIMemoryStream.Free;
        SWPMemoryStream.free;
        Exit;
      end;
      SWPMemoryStream.Seek(0,soFromBeginning);
      F.CopyFrom(SWPMemoryStream,SWPMemoryStream.Size);
      SWPMemoryStream.free;
      XBIMemoryStream.SetSize(XBIMemoryStream.Seek(0,soFromCurrent));
      XBIMemoryStream.Seek(0,soFromBeginning);
      F.CopyFrom(XBIMemoryStream,XBIMemoryStream.Size);
      F.Free;
      XBIMemoryStream.Free;
     end;
     IniFile.WriteString('Setup','OldSWPFile',FormMain.SaveDialog.FileName);
     result:=True;
    end // if save dialog Execute
    else begin
     sSwp_Err:='?';
    end; // if save dialog Execute
   end;
end;

procedure TFormBin2Swp.ButtonSWPClick(Sender: TObject);
var
// F:TFileStream;
 s : string;
begin
   ProgressBar.Position:=0;
   FormMain.ProgressBar.Position:=0;
   if NewSGold then begin
      ShowMessage('Эта версия ещё не поддерживает New SGold телефоны!'+#13+#10+'Ждите выхода WinSwup32 для "S" 75-ой серии.');
      exit;
   end;
   if GetSaveMask = 0 then begin
      ShowMessage('Необходимо выбрать хоть один параметр в "Include"!');
      exit;
    end;
    if CheckBoxKeys.Checked then begin
     if NOT FormMain.CreateFactoryEEPblks then begin
      ShowMessage(FormMain.StatusBar.Panels[PanelCmd].Text);
      exit;
     end;
    end;
   if CheckBoxKeys.Checked then s:=EditMobName.Text+EditLGpack.Text+'@'
   else s:=EditMobName.Text+EditLGpack.Text+'#';
   if GetSaveMask = 255 then s:=s+'Full'
   else if GetSaveMask = (255 - XMASKBCR) then s:=s+'Full-B'
   else begin
      if CheckBoxBCORE.Checked then s:=s+'B';
      if CheckBoxSW.Checked then s:=s+'S';
      if CheckBoxLG.Checked then s:=s+'L';
      if CheckBoxEEL.Checked then s:=s+'T';
      if CheckBoxEEF.Checked then s:=s+'E';
      if CheckBoxFFSA.Checked then s:=s+'a';
      if CheckBoxFFSB.Checked then s:=s+'b';
      if CheckBoxFFSC.Checked then s:=s+'c';
   end;
   SaveSwpFile(0,s+' '+EditDataBaseName.text);
end;

procedure TFormBin2Swp.CheckBoxEnKeysClick(Sender: TObject);
begin
   if (GetSaveMask and (XMASKBCR or XMASKEEL or XMASKEEF)) <> 0
   then CheckBoxKeys.Enabled:=True
   else begin
    CheckBoxKeys.Enabled:=False;
    CheckBoxKeys.Checked:=False;
   end;
end;

procedure TFormBin2Swp.CheckBoxFFSAClick(Sender: TObject);
begin
  if CheckBoxFFSA.Checked then CheckBoxClrFFA.Enabled:=True
  else CheckBoxClrFFA.Enabled:=False;
end;

procedure TFormBin2Swp.CheckBoxFFSBClick(Sender: TObject);
begin
  if CheckBoxFFSB.Checked then CheckBoxClrFFB.Enabled:=True
  else CheckBoxClrFFB.Enabled:=False;
end;

procedure TFormBin2Swp.Button1Click(Sender: TObject);
begin
   FormMain.StatusBar.Panels[PanelCmd].Text:='?';
end;

end.
