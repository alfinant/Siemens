UNIT JMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls, IniFiles, FileCtrl,

  ComPort, HexUtils, Crc16, BFB, CryptEEP, l55boots, MD5, EEP, Mask, HWID_EGOLD, SWPio;
const
 BitEEP0067 =1;
 BitEEP0076 =2;
 BitEEP5005 =4;
 BitEEP5007 =8;
 BitEEP5008 =16;
 BitEEP5009 =32;
 BitEEP5077 =64;
 BitEEP5121 =128;
 BitEEP5122 =256;
 BitEEP5123 =512;
 BitHASH    =1024;
 BitBKey    =2048;
 BitEEPROM  =4096;
 BitBCORE   =8192;
 BitClrBC   =16384;
 BitEEP5012 =32768;
 BitEEP5093 =65536;
type
  tBootsMode=(BootsMode,BFBMode);

  TFormMain = class(TForm)
    MemoInfo: TMemo;
    ProgressBar: TProgressBar;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PanelMain: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    RadioGroupFlash: TRadioGroup;
    ButtonRead: TButton;
    GroupBoxFManual: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    MaskEditAddr: TMaskEdit;
    MaskEditSize: TMaskEdit;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Panel2: TPanel;
    GroupBox3: TGroupBox;
    ButtonSendSkey: TButton;
    ButtonSkey: TButton;
    CheckBoxSaveSecBlkOTP: TCheckBox;
    CheckBoxSaveSecBlkEEP: TCheckBox;
    GroupBox2: TGroupBox;
    CheckBoxExtIMEI: TCheckBox;
    EditJImei: TEdit;
    CheckBoxUseOTPImei: TCheckBox;
    Panel5: TPanel;
    ButtonSimSim: TButton;
    ButtonPhoneOff: TButton;
    ButtonSrvm: TButton;
    ButtonMasterKeys: TButton;
    ButtonPhoneCode: TButton;
    ButtonDelInst: TButton;
    Button5005: TButton;
    TabSheet4: TTabSheet;
    Panel3: TPanel;
    ButtonSetContrast: TButton;
    ScrollBarContrast1: TScrollBar;
    LabelContrast: TLabel;
    ButtonRead5007: TButton;
    ButtonWrite5007: TButton;
    ButtonLightOff: TButton;
    ButtonLightOn: TButton;
    ButtonSrvm1: TButton;
    ButtonPhoneOff1: TButton;
    Image1: TImage;
    ScrollBarContrast2: TScrollBar;
    ButtonBackupEEP: TButton;
    ButtonRdKeys: TButton;
    CheckBoxSrvCreateBlk: TCheckBox;
    ButtonDefragEEP: TButton;
    ButtonAbout: TButton;
    GroupBox1: TGroupBox;
    CheckBoxBcorePr: TCheckBox;
    CheckBoxBkEEP: TCheckBox;
    CheckBoxPrFacEEP: TCheckBox;
    ButtonWrite: TButton;
    ButtonInfoBFB: TButton;
    ButtonNormMode: TButton;
    TabSheet5: TTabSheet;
    Panel4: TPanel;
    ButtonSrvm2: TButton;
    ButtonPhoneOff2: TButton;
    GroupBox4: TGroupBox;
    ButtonFreeze: TButton;
    EditFImei: TEdit;
    ButtonGetImei: TButton;
    Label3: TLabel;
    ButtonRdEepFile: TButton;
    ButtonPhoneOn: TButton;
    RadioGroupTelType: TRadioGroup;
    RadioGroupComPort: TRadioGroup;
    RadioGroupBaud: TRadioGroup;
    RadioGroupBootType: TRadioGroup;
    CheckBoxIgnitionMode: TCheckBox;
    ButtonClearMemo: TButton;
    GroupBox5: TGroupBox;
    Button0071: TButton;
    Button0280: TButton;
    CheckBoxClrBC: TCheckBox;
    ButtonConfig: TButton;
    ButtonBFEEP: TButton;
    ButtonReCalcKey: TButton;
    CheckBoxReCalcKeys: TCheckBox;
    Button1: TButton;
    ButtonNameCh: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonSkeyClick(Sender: TObject);
    procedure ButtonSendSkeyClick(Sender: TObject);
//    procedure ButtonBootClick(Sender: TObject);
    procedure MaskEditAddrChange(Sender: TObject);
    procedure MaskEditSizeChange(Sender: TObject);
    procedure ButtonReadClick(Sender: TObject);
    procedure ButtonWriteClick(Sender: TObject);
    procedure CheckBoxExtIMEIClick(Sender: TObject);
    procedure EditJImeiChange(Sender: TObject);
    procedure RadioGroupFlashClick(Sender: TObject);
    procedure RadioGroupTelTypeClick(Sender: TObject);
    procedure CheckBoxUseOTPImeiClick(Sender: TObject);
    procedure CheckBoxSaveSecBlkOTPClick(Sender: TObject);
    procedure CheckBoxSaveSecBlkEEPClick(Sender: TObject);
    procedure ButtonSimSimClick(Sender: TObject);
    procedure ButtonPhoneOffClick(Sender: TObject);
    procedure ButtonPhoneOnClick(Sender: TObject);
    procedure ButtonSrvmClick(Sender: TObject);
    procedure ButtonRdKeysClick(Sender: TObject);
    procedure ButtonMasterKeysClick(Sender: TObject);
    procedure ButtonPhoneCodeClick(Sender: TObject);
    procedure ButtonDelInstClick(Sender: TObject);
    procedure Button5005Click(Sender: TObject);
    procedure ButtonSetContrastClick(Sender: TObject);
    procedure ScrollBarContrast1Change(Sender: TObject);
    procedure ButtonRead5007Click(Sender: TObject);
    procedure ButtonLightOffClick(Sender: TObject);
    procedure ButtonLightOnClick(Sender: TObject);
    procedure ButtonWrite5007Click(Sender: TObject);
    procedure ScrollBarContrast2Change(Sender: TObject);
    procedure ButtonDefragEEPClick(Sender: TObject);
    procedure ButtonBackupEEPClick(Sender: TObject);
    procedure CheckBoxReCalcKeysClick(Sender: TObject);
    procedure CheckBoxBcorePrClick(Sender: TObject);
    procedure ButtonAboutClick(Sender: TObject);
    procedure CheckBoxPrFacEEPClick(Sender: TObject);
    procedure CheckBoxBkEEPClick(Sender: TObject);
    procedure Button0071Click(Sender: TObject);
    procedure ButtonInfoBFBClick(Sender: TObject);
    procedure ButtonNormModeClick(Sender: TObject);
    procedure ButtonReCalcKeyClick(Sender: TObject);
    procedure ButtonGetImeiClick(Sender: TObject);
    procedure EditFImeiChange(Sender: TObject);
    procedure ButtonFreezeClick(Sender: TObject);
    procedure ButtonRdEepFileClick(Sender: TObject);
    procedure ButtonClearMemoClick(Sender: TObject);
    procedure Button0280Click(Sender: TObject);
    procedure CheckBoxClrBCClick(Sender: TObject);
    procedure ButtonConfigClick(Sender: TObject);
    procedure ButtonBFEEPClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ButtonNameChClick(Sender: TObject);
//    procedure ButtonReadClick(Sender: TObject);
  private
    { Private declarations }
    procedure ReadIniImeiKeys;
    procedure WriteIniImeiKeys(flgBkey : boolean);
    function SendAllBoot : boolean;
    function ComOpen : boolean;
    procedure ComClose;
    procedure Terminate;
    procedure Stop;
    procedure AllKeyDisable;
    function CalcSkey(xesn,xskey:dword): boolean;
    procedure CalcHashAndBkey(xskey,xesn:Dword);
    function TestSkey(xskey,xesn: dword; flgTstBkey:boolean): boolean;
    function TestAndCalcSkey : boolean;
    function StartServiceMode(mode : byte) : boolean;
    function Ignition : boolean;
    function InfoBFB : boolean;
    function StartBoot( mode : tBootsMode) : boolean;
    function GetFlashInfo : boolean;
    function ReadFlashSeg(addr, size: dword; stepx : integer): boolean ;
    function StartBootAndInfo : boolean;
    function SendSwpBoot : boolean;
    procedure ShowTabFlash;
    function PingBFB : boolean;
    function CalcMasterKeys : boolean;
    function TestSecurityMode : boolean;
    function BFB_Write_EEP_block(flgok : boolean; num,ver,len : dword ; var buf : array of byte): boolean;
    function BootBackupEEP : boolean;
    function ReadAllEepBlocks : boolean;
    function Write_BFB_EELITE_blks : boolean;
    function Write_BFB_EEFULL_blks : boolean;
    function EepInfo(ShowWarn : boolean) : boolean;
    function CreateFileMobileName : boolean;
    function ReCalcEEPSeg(addr: dword; xb: integer; var buf: array of byte): dword;
    function RestoreEEPSeg(addr: dword; xb: integer; var buf: array of byte): dword;
    function GreateFileNameBackup(s : string) : string;
    function SaveNewSecBlocks : boolean;
    procedure ChangeInfo(flgrec : dword; s : string);
    procedure Test5008;
    function ReadHWID : boolean;
  public
    { Public declarations }
    procedure AddLinesLog(s: string);
  end;

var
  FormMain: TFormMain;
  BinMemoryStream : TMemoryStream;
  IniFile : TIniFile = nil;
  IniFileX : TIniFile = nil;
  IniFileName : string = '.\Joker.ini';
  PhoneName : string;
  debug : boolean;
  flgalready : boolean = False;
  flgBootLoad : boolean = False;
  flgHASH : boolean = False;
  FSN : dword;
  FlashID : array[0..7] of byte;
  HASH : array[0..15] of byte;
  BootKey : array[0..15] of byte;
  IMEI : string;
  OTPIMEI : string;
  SKEY : dword;
  HWID : word;
  SecMode : byte;
  Mkey : array[0..5] of dword;// = (12345678,12345678,12345678,12345678,12345678,12345678);
  tabnnbin : array[0..nManual] of pchar = ('FF','BC','EE','LG','T9','ES','FS','FB','FC','MN');
  FlashInfo : tFlashInfo;
  EEP0067 : array[0..19] of byte;
  EEP5005 : array[0..127] of byte; // 64 bytes!!!
  EEP5007 : array[0..31] of byte; // 10 bytes!!!
  Len5007 : dword = 12;
  Ver5007 : byte;
  EEP5012 : array[0..13] of byte; // 12 or 14 байт Ver 0 Battery Display Level
  EEP5093 : array[0..75] of byte; // A55-A57,C55,M55/56,S55 32 байт Ver 0,
  // SL65 64 байт Ver 1
  // A60... 76 байт Ver 1, Battery Ri-measurement
//  FlgReadEEP5009 : boolean;
  LogFile : THandle = 0;
  LogFileName : string = '';
  FlgBkEEP : dword;
  CryptModel : integer = C55;
//  SpeedBFB : integer = 115200;

 sDisplayController : array[0..63] of pchar =
 ('Unknown or misses',
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
  ErrChFileName: string ='\/:*?"<>|.';

implementation

uses Blk5005, About, Config, DelInsts, NewSkey, ChName;

{$R *.DFM}

function RepairFileName(var FileName : string) : boolean;
var
b : Byte;
i,x : integer;
begin
   result:=False;
   for i:=1 to Length(FileName) do begin
    b:=byte(FileName[i]);
    if (b>=Ord(' ')) then begin
     for x:=1 to Length(ErrChFileName) do
     if Char(b) = ErrChFileName[x] then begin
      FileName[i]:='_';
      result:=True;
      break;
     end;
    end
    else begin
      FileName[i]:='#';
      result:=True;
    end;
   end;
end;

procedure TFormMain.ButtonConfigClick(Sender: TObject);
var
i : integer;
buf : array[0..15] of byte;
begin
   with ConfigDlg do begin
    CheckBoxLog.Checked:=IniFile.ReadBool('System','LogFileOn',True);
    SpinEditSkey.Value:=IniFile.ReadInteger('System','SKEY',12345678);
    SpinEditM0.Value:=IniFile.ReadInteger('System','Mkey0',12345678);
    SpinEditM1.Value:=IniFile.ReadInteger('System','Mkey1',12345678);
    SpinEditM2.Value:=IniFile.ReadInteger('System','Mkey2',12345678);
    SpinEditM3.Value:=IniFile.ReadInteger('System','Mkey3',12345678);
    SpinEditM4.Value:=IniFile.ReadInteger('System','Mkey4',12345678);
    SpinEditM5.Value:=IniFile.ReadInteger('System','Mkey5',12345678);
    EditBkey.Text:=IniFile.ReadString('System','BKEY','6E75747A6F6973746865626573740000');
   end;
   ConfigDlg.Top := Top+120;
   ConfigDlg.Left := Left+60;
   ConfigDlg.ShowModal;
   if ConfigDlg.ModalResult=mrOk then begin
    with ConfigDlg do begin
     IniFile.WriteBool('System','LogFileOn',CheckBoxLog.Checked);
     IniFile.WriteInteger('System','SKEY',SpinEditSkey.Value);
     IniFile.WriteInteger('System','Mkey0',SpinEditM0.Value);
     IniFile.WriteInteger('System','Mkey1',SpinEditM1.Value);
     IniFile.WriteInteger('System','Mkey2',SpinEditM2.Value);
     IniFile.WriteInteger('System','Mkey3',SpinEditM3.Value);
     IniFile.WriteInteger('System','Mkey4',SpinEditM4.Value);
     IniFile.WriteInteger('System','Mkey5',SpinEditM5.Value);
     i:=Length(EditBkey.Text);
     if i>=32 then begin
      HexTopByte(@EditBkey.Text[1],16,@buf[0]);
      IniFile.WriteString('System','BKEY',BufToHexStr(@buf[0],16));
     end
     else
      IniFile.WriteString('System','BKEY','6E75747A6F6973746865626573740000');
    end;
    IniFile.UpdateFile;
    ReadIniImeiKeys;
   end;
end;

procedure TFormMain.ReadIniImeiKeys;
var
i : integer;
begin
   for i:=0 to 5 do Mkey[i]:=IniFile.ReadInteger(IMEI,'Mkey'+IntToStr(i),IniFile.ReadInteger('System','Mkey'+IntToStr(i),12345678));
   HexTopByte(@IniFile.ReadString(IMEI,'BKEY',IniFile.ReadString('System','BKEY','6E75747A6F6973746865626573740000'))[1],16,@BootKey);
   SKEY:=IniFile.ReadInteger(IMEI,'SKEY',IniFile.ReadInteger('System','Skey',12345678));
   if (SKEY=0) or (SKEY>99999999) then SKEY:=12345678;
end;

procedure TFormMain.WriteIniImeiKeys( flgBkey : boolean);
begin
   IniFile.WriteString(IMEI,'FSN',IntToHex(FSN,8));
   IniFile.WriteString(IMEI,'HASH',BufToHexStr(@HASH[0],16));
   if flgBkey then IniFile.WriteString(IMEI,'BKEY',BufToHexStr(@BootKey[0],16));
   IniFile.WriteInteger(IMEI,'SKEY',SKey);
end;

procedure TFormMain.FormCreate(Sender: TObject);
var
i : integer;
s : string;
begin
   iComBaud:=57600;
   if IniFile = nil then IniFile := TIniFile.Create(IniFileName);
   if IniFile.ReadString('System','Version','') = '' then begin
     IniFile.WriteString('System','Version',Caption);
//     IniFile.WriteInteger('System','SpeedBFB',115200);
     IniFile.WriteInteger('Setup','ComPort',iComNum);
     IniFile.WriteString('System','DirLogs','.\Logs');
     IniFile.WriteString('System','DirBackup','.\Backup');
     IniFile.WriteBool('System','LogFileOn',True);
     IniFile.WriteInteger('System','SKEY',12345678);
     for i:=0 to 5 do IniFile.WriteInteger('System','Mkey'+IntToStr(i),12345678);
     IniFile.WriteString('System','BKEY','6E75747A6F6973746865626573740000');
   end
   else begin
     IniFile.WriteString('System','Version',Caption);
   end;
   Top := IniFile.ReadInteger('Setup','Top',100);
   Left := IniFile.ReadInteger('Setup','Left',100);
//   SpeedBFB := IniFile.ReadInteger('System','SpeedBFB',115200);
   if Screen.DesktopHeight <= Top then Top := Screen.DesktopHeight shr 1;
   if Screen.DesktopWidth <= Left then Left := Screen.DesktopWidth shr 1;
   CheckBoxIgnitionMode.Checked:=IniFile.ReadBool('Setup','IType',CheckBoxIgnitionMode.Checked);
   iComNum := IniFile.ReadInteger('Setup','ComPort',iComNum);
   debug := IniFile.ReadBool('System','Debug',False);
   RadioGroupComPort.ItemIndex:=iComNum-1;
   RadioGroupBaud.ItemIndex := IniFile.ReadInteger('Setup','Baud',0);
   RadioGroupTelType.ItemIndex := IniFile.ReadInteger('Setup','Mobile',1);
   Model:=RadioGroupTelType.ItemIndex;
   CheckBoxSaveSecBlkEEP.Checked := IniFile.ReadBool('Setup','SBlkEEP',False);
   CheckBoxSaveSecBlkOTP.Checked := IniFile.ReadBool('Setup','SBlkOTP',False);
   CheckBoxBcorePr.Checked := IniFile.ReadBool('Setup','BCProt',True);
   CheckBoxReCalcKeys.Checked := IniFile.ReadBool('Setup','ReCalc',False);
   CheckBoxSrvCreateBlk.Checked := IniFile.ReadBool('Setup','SrvCrBlk',True);
   CheckBoxBkEEP.Checked := IniFile.ReadBool('Setup','BkEEP',True);
   CheckBoxPrFacEEP.Checked := IniFile.ReadBool('Setup','PrFEEP',True);
   CheckBoxClrBC.Checked := IniFile.ReadBool('Setup','ClrBC',False);
   MaskEditAddr.Text:=IntToHex(IniFile.ReadInteger('Setup','Addr',$A0),2);
   MaskEditSize.Text:=IntToHex(IniFile.ReadInteger('Setup','Size',$004),3);
//   for i:=0 to 5 do Mkey[i]:=IniFile.ReadInteger('System','Mkey'+IntToStr(i),12345678);
   IMEI:=IniFile.ReadString('Setup','Imei','123456789012347');
   ReadIniImeiKeys;
   EditJImei.Text:=IniFile.ReadString('Setup','EImei','123456789012347');
   EditJImei.Enabled:=CheckBoxExtIMEI.Checked;
   RadioGroupBootType.ItemIndex := IniFile.ReadInteger('Setup','BootType',0);
   RadioGroupFlash.ItemIndex := IniFile.ReadInteger('Setup','FlashBlk',nManual);
   if IniFile.ReadBool('System','LogFileOn',True) then begin
    LogFileName:=IniFile.ReadString('System','DirLogs','.\Logs');
//    if RepairFileName(LogFileName) then LogFileName:='.\Logs';
    if not DirectoryExists(LogFileName) then begin
     LogFileName:='.\Logs';
     if not CreateDir(LogFileName) then begin
      LogFileName:='.\';
      IniFile.WriteString('System','DirLogs',LogFileName);
     end;
    end;
    if LogFileName[Length(LogFileName)]<>'\' then LogFileName:=LogFileName+'\';
    LogFileName:=LogFileName+'Joker'+FormatDateTime('yymmddhhnnss',Now)+'.log';
    LogFile:=FileCreate(LogFileName);
   end;
   if LogFile>0 then begin
    FileSeek(LogFile,0,2);
    s:='****** '+Caption +' opened. ******'+#13+#10+'****** '+FormatDateTime('dddd, mmmm d, yyyy, " at " hh:mm:ss',Now)+' ******'+#13+#10;
    FileWrite(LogFile, s[1],Length(s));
   end;
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
s : string;
begin
   if IniFile <> nil then begin
     IniFile.WriteBool('Setup','IType',CheckBoxIgnitionMode.Checked);
     IniFile.WriteInteger('Setup','Top',Top);
     IniFile.WriteInteger('Setup','Left',Left);
     IniFile.WriteInteger('Setup','ComPort',RadioGroupComPort.ItemIndex+1);
     IniFile.WriteInteger('Setup','Baud',RadioGroupBaud.ItemIndex);
     IniFile.WriteInteger('Setup','BootType',RadioGroupBootType.ItemIndex);
     IniFile.WriteInteger('Setup','Mobile',RadioGroupTelType.ItemIndex);
     IniFile.WriteBool('Setup','SBlkEEP',CheckBoxSaveSecBlkEEP.Checked);
     IniFile.WriteBool('Setup','SBlkOTP',CheckBoxSaveSecBlkOTP.Checked);
     IniFile.WriteBool('Setup','BCProt',CheckBoxBcorePr.Checked);
     IniFile.WriteBool('Setup','ReCalc',CheckBoxReCalcKeys.Checked);
     IniFile.WriteBool('Setup','BkEEP',CheckBoxBkEEP.Checked);
     IniFile.WriteBool('Setup','PrFEEP',CheckBoxPrFacEEP.Checked);
     IniFile.WriteBool('Setup','SrvCrBlk',CheckBoxSrvCreateBlk.Checked);
     IniFile.WriteBool('Setup','ClrBC',CheckBoxClrBC.Checked);
     IniFile.WriteInteger('Setup','Addr',StrToIntDef('$'+MaskEditAddr.Text,$A0));
     IniFile.WriteInteger('Setup','Size',StrToIntDef('$'+MaskEditSize.Text,$004));
     IniFile.WriteInteger('Setup','FlashBlk',RadioGroupFlash.ItemIndex);
     IniFile.WriteString('Setup','Imei',IMEI);
     IniFile.WriteString('Setup','EImei',EditJImei.Text);
     IniFile.UpdateFile;
     IniFile.Free;
     if LogFile>0 then begin
      FileSeek(LogFile,0,2);
      s:='****** '+Caption +' closed. ******'+#13+#10+'****** '+FormatDateTime('dddd, mmmm d, yyyy, " at " hh:mm:ss',Now)+' ******'+#13+#10;
      FileWrite(LogFile, s[1],Length(s));
      FileClose(LogFile);
     end;
     ComClose;
   end;
end;

procedure TFormMain.AddLinesLog(s: string);
begin
  MemoInfo.Lines.Add(s);
  if LogFile>0 then begin
   s:=s+#13+#10;
   FileWrite(LogFile, s[1],Length(s));
  end;
end;

function TFormMain.Ignition : boolean;
begin
       result:=False;
        Application.ProcessMessages;
        if (Not flgBootLoad) or flgBFBExit then exit;
        if Terminatel55Boot then AddLinesLog('Boots terminated!');
        ComClose;
        Application.ProcessMessages;
        if (Not flgBootLoad) or flgBFBExit then exit;
        Sleep(75);
        Application.ProcessMessages;
        if (Not flgBootLoad) or flgBFBExit then exit;
        Sleep(75);
        Application.ProcessMessages;
        if (Not flgBootLoad) or flgBFBExit then exit;
        if not ComOpen then begin
         AddLinesLog('No open Com'+IntToStr(iComNum)+'!');
         exit;
        end;
        Application.ProcessMessages;
       result:=True;
end;

function TFormMain.ComOpen : boolean;
begin
  flgBFBExit:=False;
  sBFBExit:='';
  result:=OpenCom(CheckBoxIgnitionMode.Checked);
end;

procedure TFormMain.ComClose;
begin
  if flgBFBExit then begin
   AddLinesLog('The phone was switched off on an error:');
   AddLinesLog(sBFBExit);
   flgBFBExit:=False;
   sBFBExit:='';
  end;
  CloseCom;
end;


function TFormMain.ReadHWID : boolean;
begin
    result:=False;
    if Not BFB_GetHWID(HWID) then begin
     HWID:=0;
    end
    else begin
     AddLinesLog('HWID: '+IntToStr(HWID)+' ('+HwIDToStr(HWID)+')');
     result:=True;
    end;
    if HWID=HW_A50 then CryptModel:=A50
    else CryptModel:=C55;
end;

function TFormMain.InfoBFB : boolean;
var
b : byte;
w : word;
s : string;
i : integer;
buf : array[0..15] of byte;
begin
    result:=False;
    if BFB_GetMobileMode(w) then begin
     case w of
      $03: s:='Charge';
      $80: s:='Normal';
      $07: s:='Service';
//      $07: s:='BurnIn';
//      $FE: s:='Format FFS?';
     else s:='Unknown (0x'+IntToHex(w,4)+')';
     end;
     AddLinesLog('MobileMode: '+s);
    end;
    ReadHWID;
    s:=BFB_PhoneModel;
    s:=s+' '+BFB_GetLg;
    b:=BFB_PhoneFW;
    if b<>$FF then s:=s+' Sw'+IntToHex(b,2);
    if CmdBFB($0E,[$08],1)=BFB_OK then begin
     b:=ibfb.code.datab[8];
     ibfb.code.datab[8]:=0;
     s:=s+' '+pchar(@ibfb.code.datab[0]);
     ibfb.code.datab[8]:=b;
     ibfb.code.datab[16]:=0;
     s:=s+' '+pchar(@ibfb.code.datab[8]);
    end;
    AddLinesLog(s);
//    if BFB_ReadSensors(dword(i)) then begin
//     AddLinesLog('Sensors: '+IntToStr(i shr 16)+', '+IntToStr(i and $FFFF));
//    end;
    IMEI:=BFB_GetImei;
    AddLinesLog('IMEI: '+IMEI);
 //   if BFB_Error=BFB_OK then
    ReadIniImeiKeys;
//    EditJImei.Text:=IMEI;
//    AddLinesLog('FlagStatus: '+IntToStr(BFB_FlagStatus));
    if BFB_GetDisplayType(b) then begin
     if b<=63 then i:=b
     else i:=0;
     AddLinesLog('DisplayID: '+IntToStr(b)+', '+sDisplayController[i]);
    end;
    if BFB_GetSecurityMode(SecMode) and ((SecMode<=2) or (SecMode=$FE)) then begin
     BFB_GetESN(FSN);
     AddLinesLog('FSN: '+IntToHex(FSN,8));
     if BFBReadMem($87FE26,16,buf[0])
     and (dword((@buf[0])^)<>$FFFFFFFF) then begin
       s:='SW FlashID: '+IntToHex(word((@buf[0])^),4)+'/'+IntToHex(word((@buf[2])^),4);
       if (dword((@buf[12])^)<>$FFFFFFFF)
       and (dword((@buf[12])^)<>$00000000) then
        s:=s+' ('+IntToHex(word((@buf[12])^),4)+'/'+IntToHex(word((@buf[14])^),4)+')';
       AddLinesLog(s);
     end;
    end;
    s:='';
    if (CmdBFB($0E,[$0B,$08],2)=BFB_OK)
    and(ibfb.code.cmdb = $0B)
    then begin
     i:=0;
     while i<ibfb.code.datab[0] do begin
      case ibfb.code.datam[i] of
      $04: s:='OTP open';
      $05: s:='OTP closed';
      $08: s:='BootKEY is unknown';
      $09: s:='BootKEY is written in EEPROM';
      $0A: s:='BootKEY misses in EEPROM';
      $0C: s:='Keys miss in BCORE (CleanBCORE)';
      $0D: s:='Keys are registered in BCORE ';
      $0E: s:='Absence of the reference table on commands';

      $10: s:='Minimal access to BFB';
      $11: s:='Service access to BFB';
      $12: s:='Complete access to BFB';
      $13: s:='Complete access to BFB'; //A55="X"
      $15: s:='Complete condition';
      $16: s:='Partial access to BFB';

      $18: s:='Block 76 empty';
      $19: s:='Monitoring is switched on';
      $1A: s:='Block 76 is accessible';
      $1B: s:='Block 76 is not found';
      $1C: s:='Block 5123 is not found';
      $1D: s:='Blocks 5121,5122,5123 are present';
      $1E: s:='Block 5121 is not found';
      $20,$21 : break;
      else s:='?';
      end;
      AddLinesLog('Code('+IntToHex(ibfb.code.datam[i],2)+'): '+s);
      inc(i);
     end;
    end;
    if not BFB_GetBatteryVoltage(w) then AddLinesLog('Error Get Battery Voltage!')
    else begin
     if w < 3700 then begin
      AddLinesLog('Battery Voltage very low! '+IntToStr(w)+' mV!');
      beep;
     end
     else if w > 4275 then begin
      AddLinesLog('Incorrect Battery Voltage! '+IntToStr(w)+' mV!');
     end
     else AddLinesLog('Battery Voltage '+IntToStr(w)+' mV.');
    end;
    Case SecMode of
     00: s:='Repair';
     01: s:='Developer';
     02: s:='Factory';
     03: s:='Customer';
     $FE: s:='Not Read!';
     $FF: s:='Error!';
     else
      s:='Unknown('+IntToHex(SecMode,2)+')';
    end;
    AddLinesLog('SecurityMode: '+s);
    if (BFB_Error=BFB_OK) and (SecMode<>$FF) then result:=True;
end;

var
FlgOTPImeiErr : boolean = True;

function TFormMain.GetFlashInfo : boolean;
begin
       result:=False;
       FlgOTPImeiErr:=True;
       if GetFlashInfol55Boot(FlashInfo) then begin
        ProgressBar.StepIt;
        AddLinesLog(sBootErr);
        FSN := FlashInfo.FSN;
        BCD2IMEI(FlashInfo.BCDIMEI[0],OTPIMEI); // 8 байт
        SetLength(OTPIMEI,15);
        if CalcImei15(OTPIMEI,OTPIMEI[15]) then begin
         FlgOTPImeiErr:=False;
         AddLinesLog('OTP IMEI: '+OTPIMEI)
        end
        else AddLinesLog('Error IMEI in OTP!');
        result:=True;
        exit;
       end;
       AddLinesLog(sBootErr);
end;

function TFormMain.StartBoot( mode : tBootsMode) : boolean;
var
b : byte;
i : integer;
begin
      result:=False;
      flgalready := False;
      flgBootLoad := True;
      HWID:=0;
      i := 115200;
      if mode=BootsMode then begin
       i := 57600;
       case RadioGroupBaud.ItemIndex of
        1 : i := 115200;
        2 : i := 460800;
        3 : i := 921600;
       end;
       case Model of
        MA70,MA75,MAX75 : if i>460800 then i:=460800;
       end;
      end;
      iComBaud:=i;
      ProgressBar.Position:=0;
      iComNum := RadioGroupComPort.ItemIndex+1;
      if not ComOpen then begin
       AddLinesLog('No open Com'+IntToStr(iComNum)+' Baud Rate '+IntToStr(i)+'!');
       exit;
      end;
      AddLinesLog('Start...');
      SetComRxTimeouts(50,1,50);
      Application.ProcessMessages;
      if (Not flgBootLoad) or flgBFBExit then exit;
      Sleep(50);
      PurgeCom(PURGE_TXCLEAR or PURGE_RXCLEAR);
//      if (i<>57600) then begin
      if Ackl55Boot and Ackl55Boot then begin
       if mode=BootsMode then begin
        SetComRxTimeouts(20,1,200);
        AddLinesLog('Boots Already loaded!');
        flgalready := True;
        result:=True;
        exit;
       end
       else begin
        if Terminatel55Boot then begin
         AddLinesLog('Boots terminated!');
         exit;
        end
       end;
      end;
      ChangeComSpeed(115200);
      if BFB_Ping then begin
       if mode=BootsMode then begin
        if BFB_PhoneOff then begin
         AddLinesLog('Phone off!');
//         exit;
        end;
       end
       else begin
        SetComRxTimeouts(20,1,200);
        AddLinesLog('Already BFB mode!');
        flgalready := True;
        result:=True;
        exit;
        end;
      end;
      iComBaud:=57600;
      ChangeComSpeed(iComBaud);
      Application.ProcessMessages;
      if (Not flgBootLoad) or flgBFBExit then exit;
//      while ReadCom(@b,1) do;
      SetComRxTimeouts(50,1,75);
      While (flgBootLoad and (not flgBFBExit)) do begin
       if ProgressBar.Position>=ProgressBar.Max then begin
        ProgressBar.Position:=0;
        if not Ignition then exit;
        SetComRxTimeouts(50,1,75);
       end;
       ProgressBar.StepIt;
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then exit;
       b:=$55;
       if not WriteCom(@b,1) then begin
        AddLinesLog('Not write Com'+IntToStr(iComNum)+'!');
        ComClose;
        exit;
       end;
       ProgressBar.StepIt;
       while ReadCom(@b,1) do begin
        if(Not flgBootLoad) or flgBFBExit then exit;
        if b=$A0 then begin
         SetComRxTimeouts(20,1,200);
         flgalready := False;
         result:=True;
         exit;
        end;
       end;
      end;
end;

function TFormMain.StartServiceMode(mode : byte) : boolean;
var
//b : byte;
i,x : integer;
begin
 //     result:=False;
{      if flgBootLoad then begin
       flgBootLoad:=False;
       Sleep(250);
       ComClose;
       result:=True;
       exit;
      end; }
      result:=StartBoot(BFBMode);
      if result and (Not flgalready) then begin
       result:=False;
       AddLinesLog('Loading ServiceBoot...');
       ProgressBar.Position:=0;
       if Not Sendl55ServiceBoot(mode) then begin
        AddLinesLog(sBootErr);
        ComClose;
        exit;
       end;
       AddLinesLog(sBootErr);
       for x:=0 to 17 do begin
        ProgressBar.StepBy(2);
        Application.ProcessMessages;
        if (Not flgBootLoad) or flgBFBExit then exit;
        Sleep(50);
       end;
       for x:=0 to 33 do begin
        if BFB_Ping then begin
         for i:=0 to 4 do begin
          ProgressBar.StepBy(1);
          Application.ProcessMessages;
          if (Not flgBootLoad) or flgBFBExit then exit;
          Sleep(50);
         end;
         if (Not flgBootLoad) or flgBFBExit then exit;
         if mode=$02 then begin
          for i:=0 to 33 do begin
           ProgressBar.StepBy(1);
           Application.ProcessMessages;
           if (Not flgBootLoad) or flgBFBExit then exit;
           Sleep(50);
          end;
         end;
         if RadioGroupBaud.ItemIndex<>0 then begin
          if SetSpeedBFB(115200) then begin
           AddLinesLog('BFB Speed 115200 Baud - Ok.');
           iComBaud:=115200;
          end;
         end;
         Application.ProcessMessages;
         if (Not flgBootLoad) or flgBFBExit then exit;
         if BFB_Ping or BFB_Ping or BFB_Ping then begin
           result:=True;
           exit;
         end;
         if GetComDCB then iComBaud:=dcb.BaudRate;
         CloseCom;
         if Not OpenCom(CheckBoxIgnitionMode.Checked) then begin
          AddLinesLog('No reopen Com'+IntToStr(iComNum)+'!');
          exit;
         end;
         SetComRxTimeouts(100,2,200);
        end
        else if x=30 then begin
         if GetComDCB then iComBaud:=dcb.BaudRate;
         CloseCom;
         if Not OpenCom(CheckBoxIgnitionMode.Checked) then begin
          AddLinesLog('No reopen Com'+IntToStr(iComNum)+'!');
          exit;
         end;
         SetComRxTimeouts(100,2,200);
        end;
        ProgressBar.StepBy(1);
        Application.ProcessMessages;
        if (Not flgBootLoad) or flgBFBExit then exit;
        Sleep(50);
        if mode=$02 then begin
         ProgressBar.StepBy(1);
         Application.ProcessMessages;
         if (Not flgBootLoad) or flgBFBExit then exit;
         Sleep(75);
        end;
       end;
       AddLinesLog('No Ping Mobile!');
      end;
end;

function TFormMain.SendAllBoot : boolean;
var
i : integer;
begin
      if flgBootLoad then begin
       flgBootLoad:=False;
       Sleep(200);
       ComClose;
       result:=True;
       exit;
      end;
{
      result:=StartBoot;

      AddLinesLog('Loading ParamBoot...');
//       ProgressBar.Position:=0;
      if result and (Not flgalready) then begin
       result:=False;
       if Not SendSBPl55Boot($88,nil) then begin
        AddLinesLog(sBootErr);
        ComClose;
        exit;
       end;
      end;
      ComClose;
      Sleep(200);
}
      ProgressBar.Position:=0;
      result:=StartBoot(BootsMode);
      if result and (Not flgalready) then begin
       result:=False;
       i:=RadioGroupBootType.ItemIndex;
//       AddLinesLog('Loading PapameterBoot...');
       if TBootType(i)=Boot_BootKey then begin
        AddLinesLog('BootKey: '+BufToHexStr(@BootKey,16));
        if Not SendSBPl55Boot($01,@BootKey[0]) then begin
//       if Not SendSBPl55Boot($88,Nil) then begin
         AddLinesLog(sBootErr);
         ComClose;
         exit;
        end;
        AddLinesLog(sBootErr);
        ProgressBar.StepBy(10);
       end;
       AddLinesLog('Loading BootsModel('+sBootModel[Model]+')...');
       if Not SendStartl55Boot(TBootType(i)) then begin
        AddLinesLog(sBootErr);
        ComClose;
        exit;
       end;
       AddLinesLog(sBootErr);
       ProgressBar.StepBy(10);
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then exit;
{       if Not Sendl55Boot2 then begin
        AddLinesLog(sBootErr);
        ComClose;
        exit;
       end;
       AddLinesLog(sBootErr);
       ProgressBar.StepBy(10);
       Application.ProcessMessages;
       if Not flgBootLoad then exit;
       if Not Sendl55Boot3 then begin
        AddLinesLog(sBootErr);
        ComClose;
        exit;
       end;
       AddLinesLog(sBootErr); }
       ProgressBar.StepBy(10);
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then exit;
       if Not SendMainl55Boot then begin
        AddLinesLog(sBootErr);
        ComClose;
        exit;
       end;
       AddLinesLog(sBootErr);
       ProgressBar.StepBy(10);
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then exit;
//         AddLinesLog('Load all Boots - Ok.');
       result:=True;
       exit;
      end;
end;

procedure TFormMain.AllKeyDisable;
begin
       ButtonSendSkey.Enabled:=False;
       ButtonBFEEP.Enabled:=False;
       ButtonSkey.Enabled:=False;
//       ButtonBoot.Enabled:=False;
       ButtonRead.Enabled:=False;
       ButtonWrite.Enabled:=False;
       ButtonSrvm.Enabled:=False;
       ButtonSrvm1.Enabled:=False;
       ButtonSrvm2.Enabled:=False;
       ButtonNormMode.Enabled:=False;
       ButtonReCalcKey.Enabled:=False;
       ButtonNameCh.Enabled:=False;
end;

procedure TFormMain.Terminate;
begin
       ComClose;
       ButtonSendSkey.Caption :='Send Skey';
//       ButtonUnlock.Caption :='Joker';
       ButtonSkey.Caption := 'Calc Skey';
//       ButtonBoot.Caption := 'Boot';
       ButtonRead.Caption := 'Read';
       ButtonWrite.Caption := 'Write';
       ButtonSrvm.Caption :='Service Mode';
       ButtonSrvm1.Caption :='Service Mode';
       ButtonSrvm2.Caption :='Service Mode';
       ButtonNormMode.Caption :='Normal Mode';
       ButtonReCalcKey.Caption :='ReCalc All Keys';
       ButtonBFEEP.Caption :='Read F.EEP';
       ButtonNameCh.Caption :='Name change';
       ButtonSrvm.Enabled:=True;
       ButtonSrvm1.Enabled:=True;
       ButtonSrvm2.Enabled:=True;
       ButtonSendSkey.Enabled:=True;
//       ButtonUnlock.Enabled:=True;
       ButtonSkey.Enabled:=True;
//       ButtonBoot.Enabled:=True;
       ButtonRead.Enabled:=True;
       ButtonWrite.Enabled:=True;
       ButtonNormMode.Enabled:=True;
       ButtonReCalcKey.Enabled:=True;
       ButtonDefragEEP.Enabled:=True;
       ButtonBFEEP.Enabled:=True;
       PanelMain.Enabled:=True;
       ButtonNameCh.Enabled:=True;
       flgBootLoad := False;
end;

procedure TFormMain.Stop;
begin
       Terminatel55Boot;
       Terminate;
end;

function TFormMain.TestSecurityMode : boolean;
var
s : string;
begin
       result:=False;
       if not BFB_GetSecurityMode(SecMode) then AddLinesLog('Error GetSecurityMode!');
       if SecMode>2 then begin
        Case SecMode of
//         00: s:='Repair';
//         01: s:='Developer';
//         02: s:='Factory';
         03: s:='Customer';
         $FE: s:='Not Read!';
         $FF: s:='Error!';
        else
         s:='Unknown('+IntToHex(SecMode,2)+')';
        end;
        AddLinesLog('SecurityMode: '+s);
        AddLinesLog('Work only in FactoryMode! Use Skey!');
        if SecMode<>$FE then exit;
       end;
       result:=True;
end;

function TFormMain.GreateFileNameBackup(s : string) : string;
begin
    result := IniFile.ReadString('System','DirBackup','.\Backup');
//    if RepairFileName(result) then result:='.\Backup';
    if not DirectoryExists(result) then begin
     result := '.\Backup';
     if not CreateDir(result) then begin
      result := '.\';
      IniFile.WriteString('System','DirBackup',result);
     end;
    end;
    if result[length(result)]<>'\' then result:=result+'\';
    result := result+PhoneName + '_' + s + FormatDateTime('yymmddhhnnss',Now);
end;

function TFormMain.BootBackupEEP : boolean;
var
ver : byte;
//i : integer;
sBlkFile : string;
begin
    result:=False;
    FlgBkEEP:=0;
    ClearEEPBufAndTab;
    if ReadEEPl55Boot(0067,SizeOf(EEP0067),ver,EEP0067[0]) then begin
     AddEEPBlk(0067,ver,SizeOf(EEP0067),EEP0067[0]);
     AddLinesLog(sBootErr);
     FlgBkEEP:=BitEEP0067;
    end else AddLinesLog(sBootErr);
    ProgressBar.StepIt;
    if ReadEEPl55Boot(0076,SizeOf(EEP0076),ver,EEP0076[0]) then begin
     AddEEPBlk(0076,ver,SizeOf(EEP0076),EEP0076[0]);
     AddLinesLog(sBootErr);
     FlgBkEEP:=FlgBkEEP or BitEEP0076;
    end else AddLinesLog(sBootErr);
    ProgressBar.StepIt;
    if ReadEEPl55Boot(5005,64,ver,EEP5005[0]) then begin
     AddEEPBlk(5005,ver,64,EEP5005[0]);
     AddLinesLog(sBootErr);
     ver:=0;
     if (EEP5005[$0B]=$FF) or (EEP5005[$0C]=$FF) then ver:=1;
     if (EEP5005[$12]=$FF) then ver:=ver or 2;
     case ver of
      0 : FlgBkEEP:=FlgBkEEP or BitEEP5005;
      1 : AddLinesLog('EEP5005 uses incorrect date!');
      2 : AddLinesLog('EEP5005 uses incorrect wariant!');
      3 : AddLinesLog('EEP5005 uses incorrect wariant and date!');
     end;
    end else AddLinesLog(sBootErr);
    ProgressBar.StepIt;
    if ReadEEPl55Boot(5007,10,ver,EEP5007[0]) then begin
     AddEEPBlk(5007,ver,10,EEP5007[0]);
     AddLinesLog(sBootErr);
     FlgBkEEP:=FlgBkEEP or BitEEP5007;
    end else
    if ReadEEPl55Boot(5007,4,ver,EEP5007[0]) then begin
     AddEEPBlk(5007,ver,4,EEP5007[0]);
     AddLinesLog(sBootErr);
     FlgBkEEP:=FlgBkEEP or BitEEP5007;
    end else
    if ReadEEPl55Boot(5007,12,ver,EEP5007[0]) then begin
     AddEEPBlk(5007,ver,12,EEP5007[0]);
     AddLinesLog(sBootErr);
     FlgBkEEP:=FlgBkEEP or BitEEP5007;
    end else AddLinesLog(sBootErr);
    ProgressBar.StepIt;
    if ReadEEPl55Boot(5008,SizeOf(EEP5008),ver,EEP5008[0]) then begin
     AddEEPBlk(5008,ver,SizeOf(EEP5008),EEP5008[0]);
     AddLinesLog(sBootErr);
     FlgBkEEP:=FlgBkEEP or BitEEP5008;
    end else AddLinesLog(sBootErr);
    ProgressBar.StepIt;
    if ReadEEPl55Boot(5009,SizeOf(EEP5009),ver,EEP5009[0]) then begin
     AddEEPBlk(5009,ver,SizeOf(EEP5009),EEP5009[0]);
     AddLinesLog(sBootErr);
     FlgBkEEP:=FlgBkEEP or BitEEP5009;
    end else AddLinesLog(sBootErr);
    ProgressBar.StepIt;
    if ReadEEPl55Boot(5012,12,ver,EEP5012[0]) then begin
     AddEEPBlk(5012,ver,12,EEP5012[0]);
     AddLinesLog(sBootErr);
     FlgBkEEP:=FlgBkEEP or BitEEP5012;
    end else
    if ReadEEPl55Boot(5012,SizeOf(EEP5012),ver,EEP5012[0]) then begin
     AddEEPBlk(5012,ver,SizeOf(EEP5012),EEP5012[0]);
     AddLinesLog(sBootErr);
     FlgBkEEP:=FlgBkEEP or BitEEP5012;
    end else AddLinesLog(sBootErr);
    ProgressBar.StepIt;
    if ReadEEPl55Boot(5077,SizeOf(EEP5077),ver,EEP5077[0]) then begin
     AddEEPBlk(5077,ver,SizeOf(EEP5077),EEP5077[0]);
     AddLinesLog(sBootErr);
     FlgBkEEP:=FlgBkEEP or BitEEP5077;
    end else AddLinesLog(sBootErr);
    ProgressBar.StepIt;
    if ReadEEPl55Boot(5093,SizeOf(EEP5093),ver,EEP5093[0]) then begin
     AddEEPBlk(5093,ver,SizeOf(EEP5093),EEP5093[0]);
     AddLinesLog(sBootErr);
     FlgBkEEP:=FlgBkEEP or BitEEP5093;
    end else
    if ReadEEPl55Boot(5093,32,ver,EEP5093[0]) then begin
     AddEEPBlk(5093,ver,32,EEP5093[0]);
     AddLinesLog(sBootErr);
     FlgBkEEP:=FlgBkEEP or BitEEP5093;
    end else
    if ReadEEPl55Boot(5093,64,ver,EEP5093[0]) then begin
     AddEEPBlk(5093,ver,64,EEP5093[0]);
     AddLinesLog(sBootErr);
     FlgBkEEP:=FlgBkEEP or BitEEP5093;
    end else AddLinesLog(sBootErr);
    ProgressBar.StepIt;
    if ReadEEPl55Boot(5121,SizeOf(EEP5121),ver,EEP5121[0]) then begin
     AddEEPBlk(5121,ver,SizeOf(EEP5121),EEP5121[0]);
     AddLinesLog(sBootErr);
     FlgBkEEP:=FlgBkEEP or BitEEP5121;
    end else AddLinesLog(sBootErr);
    ProgressBar.StepIt;
    if ReadEEPl55Boot(5122,SizeOf(EEP5122),ver,EEP5122[0]) then begin
     AddEEPBlk(5122,ver,SizeOf(EEP5122),EEP5122[0]);
     AddLinesLog(sBootErr);
     FlgBkEEP:=FlgBkEEP or BitEEP5122;
    end else AddLinesLog(sBootErr);
    ProgressBar.StepIt;
    if ReadEEPl55Boot(5123,12,ver,EEP5123[0]) then begin
     AddEEPBlk(5123,ver,12,EEP5123[0]);
     AddLinesLog(sBootErr);
     FlgBkEEP:=FlgBkEEP or BitEEP5123;
    end else
    if ReadEEPl55Boot(5123,14,ver,EEP5123[0]) then begin
     AddEEPBlk(5123,ver,14,EEP5123[0]);
     AddLinesLog(sBootErr);
     FlgBkEEP:=FlgBkEEP or BitEEP5123;
    end else AddLinesLog(sBootErr);
    ProgressBar.StepIt;
    if idx_eeptab<>0 then begin
     sBlkFile:=GreateFileNameBackup('Backup')+'.eep';
     if SaveAllEEP(sBlkFile,HWID) then begin
      AddLinesLog('EEPROM blocks is written in "'+sblkFile+ '" file.');
      result:=True;
     end
     else AddLinesLog(sEep_Err);
    end
    else result:=True;
    ProgressBar.StepIt;
end;


function TFormMain.TestSkey(xskey,xesn: dword; flgTstBkey:boolean): boolean;
var
i : integer;
buffer : array[0..63] of byte;
begin
    buffer[16]:=$80;
    FillChar(buffer[17], 64-17, 0);
    buffer[56]:=$80;
    Dword((@buffer[0])^):=xesn;
    Dword((@buffer[4])^):=xskey;
    for i:=0 to 7 do buffer[i+8]:=buffer[i] xor buffer[i+3];
    MD5Init;
    MD5Transform(@buffer);
    if flgTstBkey then
     if not((Dword((@BootKey[0])^)=MD5buf[0])
     and (Dword((@BootKey[4])^)=MD5buf[1])
     and (Dword((@BootKey[8])^)=MD5buf[2])
     and (Dword((@BootKey[12])^)=MD5buf[3])) then begin
      result:=False;
      exit;
    end;
    Dword((@buffer[0])^):=MD5buf[0];
    Dword((@buffer[4])^):=MD5buf[1];
    Dword((@buffer[8])^):=MD5buf[2];
    Dword((@buffer[12])^):=MD5buf[3];
    MD5Init;
    MD5Transform(@buffer);
    if ((Dword((@HASH[0])^)=MD5buf[0])
    and (Dword((@HASH[4])^)=MD5buf[1])
    and (Dword((@HASH[8])^)=MD5buf[2])
    and (Dword((@HASH[12])^)=MD5buf[3])) then result:=True
    else result:=False;
end;

function TFormMain.CalcSkey(xesn,xskey:dword): boolean;
var
i,sss : integer;
buffer : array[0..63] of byte;
begin
   ProgressBar.Position:=0;
   sss:=0;
   result:=False;
   repeat begin
    buffer[16]:=$80;
    FillChar(buffer[17], 64-17, 0);
    buffer[56]:=$80;
    Dword((@buffer[0])^):=xesn;
    Dword((@buffer[4])^):=xskey;
    for i:=0 to 7 do buffer[i+8]:=buffer[i] xor buffer[i+3];
    MD5Init;
    MD5Transform(@buffer);
    Dword((@buffer[0])^):=MD5buf[0];
    Dword((@buffer[4])^):=MD5buf[1];
    Dword((@buffer[8])^):=MD5buf[2];
    Dword((@buffer[12])^):=MD5buf[3];
    MD5Init;
    MD5Transform(@buffer);
    if ((Dword((@HASH[0])^)=MD5buf[0])
    and (Dword((@HASH[4])^)=MD5buf[1])
    and (Dword((@HASH[8])^)=MD5buf[2])
    and (Dword((@HASH[12])^)=MD5buf[3])) then begin
     Dword((@buffer[0])^):=xesn;
     Dword((@buffer[4])^):=xskey;
     for i:=0 to 7 do buffer[i+8]:=buffer[i] xor buffer[i+3];
     MD5Init;
     MD5Transform(@buffer);
//     AddLinesLog('BOOTKEY: '+BufToHexStr(@MD5buf,16));
     Move(MD5buf,BootKey,16);
//     AddLinesLog('SKEY: '+IntToStr(xskey));
//     EditSkey.Text:=IntToStr(xskey);
     SKey:=xskey;
     result:=True;
     ProgressBar.Position:=100;
     exit;
    end
    else begin
     inc(xskey);
     inc(sss);
     if sss>1000000 then begin
       ProgressBar.StepBy(1);
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then exit;
       sss:=0;
     end;
    end;
   end
   until (xskey>=100000000) or (xskey=0);
//   until (xskey=0);
end;

procedure TFormMain.CalcHashAndBkey(xskey,xesn:Dword);
var
i : integer;
buffer : array[0..63] of byte;
begin
    buffer[16]:=$80;
    FillChar(buffer[17], 64-17, 0);
    buffer[56]:=$80;
    Dword((@buffer[0])^):=xesn;
    Dword((@buffer[4])^):=xskey;
    for i:=0 to 7 do buffer[i+8]:=buffer[i] xor buffer[i+3];
    MD5Init;
    MD5Transform(@buffer);
    Dword((@buffer[0])^):=MD5buf[0];
    Dword((@buffer[4])^):=MD5buf[1];
    Dword((@buffer[8])^):=MD5buf[2];
    Dword((@buffer[12])^):=MD5buf[3];
    Move(MD5buf,BootKey,16);
    MD5Init;
    MD5Transform(@buffer);
    Move(MD5buf,HASH,16);
end;

function TFormMain.TestAndCalcSkey : boolean;
var
xBkey : array[0..15] of byte;
begin
        result:=False;
        AddLinesLog('Test and Calc Skey...');
        ReadIniImeiKeys;
        if Not TestSkey(SKEY,FSN,True) then begin
         if TestSkey(SKEY,FSN,False) then begin
          CalcHashAndBkey(SKEY,FSN);
          HexTopByte(@IniFile.ReadString(IMEI,'BKEY','00000000000000000000000000000000')[1],16,@xBKey);
          if ((Dword((@xBkey[0])^)=Dword((@BootKey[0])^))
          and (Dword((@xBkey[4])^)=Dword((@BootKey[4])^))
          and (Dword((@xBkey[8])^)=Dword((@BootKey[8])^))
          and (Dword((@xBkey[12])^)=Dword((@BootKey[12])^))) then begin
           AddLinesLog('BOOTKEY: '+BufToHexStr(@BootKey[0],16));
           WriteIniImeiKeys(True);
          end
          else begin
           if (Dword((@xBkey[0])^) or Dword((@xBkey[4])^) or Dword((@xBkey[8])^) or Dword((@xBkey[12])^)) = 0 then begin
            AddLinesLog('BOOTKEY: '+BufToHexStr(@BootKey[0],16));
            WriteIniImeiKeys(True);
           end
           else begin
            AddLinesLog('Warning: BOOTKEY not valid in Joker.ini!');
            AddLinesLog('Real BOOTKEY: '+BufToHexStr(@BootKey[0],16)+'! Write correct BOOTKEY?');
            if MessageDlg('Warning: BOOTKEY not valid in Joker.ini!'#13#10
            +'Real BOOTKEY: '+BufToHexStr(@BootKey[0],16)+'!'#13#10
            +'Write correct BOOTKEY?'
            ,mtConfirmation, [mbYes, mbNo], 0) = mrYes
            then begin
             AddLinesLog('BOOTKEY: '+BufToHexStr(@BootKey[0],16));
             WriteIniImeiKeys(True);
            end
            else begin
             AddLinesLog('Cancel.');
             WriteIniImeiKeys(False);
            end;
          end;
          end;
         end
         else if CalcSkey(FSN,0) then begin
          WriteIniImeiKeys(True);
          AddLinesLog('BOOTKEY: '+BufToHexStr(@BootKey[0],16));
         end
         else begin
          AddLinesLog('Skey not found! BCORE HASH incorrect for this phone FSN!');
          AddLinesLog('Use ReCalc Keys in BCORE!');
          Exit;
         end;
        end else begin
         AddLinesLog('BOOTKEY: '+BufToHexStr(@BootKey[0],16));
         WriteIniImeiKeys(True);
        end;
        AddLinesLog('SKEY: '+IntToStr(SKEY));
        result:=True;
end;

function TFormMain.StartBootAndInfo : boolean;
var
buf : array[0..$3F] of byte;
s : string;
addr : dword;
begin
      result:=False;
      if Model=MA50 then CryptModel:=A50
      else CryptModel:=C55;
      if SendAllBoot then begin
       if RadioGroupBaud.ItemIndex<>0 then begin
        if Not SetBaudl55Boot(RadioGroupBaud.ItemIndex) then begin
         AddLinesLog(sBootErr);
         Stop;
         exit;
        end;
        AddLinesLog(sBootErr);
       end;
       ProgressBar.StepBy(10);
       Application.ProcessMessages;
       flgHASH:=False;
       if Not ReadFlashl55Boot($800800,4,buf[0]) then begin
        AddLinesLog(sBootErr);
        Stop;
        exit;
       end;
       if Not ReadFlashl55Boot($800300,4,buf[4]) then begin
        AddLinesLog(sBootErr);
        Stop;
        exit;
       end;
       addr:=$800330;
       if Model=MA50 then addr:=$80032E;
       if Not ReadFlashl55Boot(addr,16,HASH) then begin
        AddLinesLog(sBootErr);
        Stop;
        exit;
       end;
       if (dword((@HASH[0])^)+dword((@HASH[4])^)<>$FFFFFFFE)
       and (dword((@buf[0])^)<>$A5A55AA5)
       and (dword((@buf[4])^)=$534C0100)
       then flgHASH:=True
       else begin
        AddLinesLog('Warning: HASH data error!');
        beep;
       end;
       ProgressBar.StepIt;
       Application.ProcessMessages;
       if Not ReadFlashl55Boot($87FF50,$40,buf[0]) then begin
        AddLinesLog(sBootErr);
        Stop;
        exit;
       end;
       buf[$1f]:=0; // lgXX
       buf[$2f]:=0; // X55
       buf[$3f]:=0; // SIEMENS
       if buf[$30]<>$FF // SIEMENS
       then s:=pchar(@buf[$30])
       else s:='';
       ProgressBar.StepIt;
       Application.ProcessMessages;
       if buf[$20]<>$FF then begin // S55
        s:=s+' '+pchar(@buf[$20]);
        PhoneName:=pchar(@buf[$20]);
       end
       else begin
        s:=s+' ?';
        PhoneName:=sBootModel[Model]+'!';
       end;
       ProgressBar.StepIt;
       if buf[$10]<>$FF then begin // LgXX
        s:=s+' '+pchar(@buf[$10]);
        PhoneName:=PhoneName+pchar(@buf[$10]);
       end;
       ProgressBar.StepIt;
       Application.ProcessMessages;
       if buf[$00]<>$FF then begin  // SW num
        s:=s+' Sw'+IntToHex(buf[$00],2);
        PhoneName:=PhoneName+'Sw'+IntToHex(buf[$00],2);
       end
       else s:=s+' ?';
       AddLinesLog(s);
       if Not ReadFlashl55Boot($87FE26,16,buf[0]) then begin
        AddLinesLog(sBootErr);
        Stop;
        exit;
       end;
       if (dword((@buf[0])^)<>$FFFFFFFF) then begin
        s:='Soft FlashID: '+IntToHex(word((@buf[0])^),4)+'/'+IntToHex(word((@buf[2])^),4);
        if (dword((@buf[12])^)<>$FFFFFFFF)
        and (dword((@buf[12])^)<>$00000000) then begin
         s:=s+' ('+IntToHex(word((@buf[12])^),4)+'/'+IntToHex(word((@buf[14])^),4)+')';
        end;
        AddLinesLog(s);
       end;
       RepairFileName(PhoneName);
       ProgressBar.StepIt;
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then begin Stop; exit; end;
       if Not GetFlashInfo then begin  Stop; exit; end;
       if (dword((@buf[0])^)<>$FFFFFFFF) then begin
        if (FlashInfo.Flash1IM<>word((@buf[0])^))
        and ((Not( (FlashInfo.Flash1IM=1) and (FlashInfo.Flash2ID=word((@buf[2])^)) ))
          or (Not( (FlashInfo.Flash1IM<>1) and (FlashInfo.Flash1ID=word((@buf[2])^)) )))
        then begin
         AddLinesLog('Warning: The software of the telephone does not correspond to FlashID!');
         beep;
        end;
       end;
       AddLinesLog('HASH: '+BufToHexStr(@HASH[0],16));
       result:=True;
      end; // if SendAllBoot
end;


procedure TFormMain.ButtonSkeyClick(Sender: TObject);
var
ch : char;
//ver : byte;
err : boolean;
//i : integer;
//s : string;
begin
      if flgBootLoad then begin
       flgBootLoad := False;
       Sleep(200);
       Stop;
       AddLinesLog('Cancel.');
       exit;
      end;
      AllKeyDisable;
      ButtonSkey.Caption :='Cancel';
      ButtonSkey.Enabled:=True;
      Model:=RadioGroupTelType.ItemIndex;
      err := False;
      if StartBootAndInfo then begin
       if Not flgHASH then begin
        AddLinesLog('Calc Skey Error: HASH data error!');
        Stop;
        exit;
       end;
       if CheckBoxSaveSecBlkEEP.Checked then begin
        if Not ReadEEPl55Boot(5009,SizeOf(EEP5009),byte(ch),EEP5009[0]) then begin
         AddLinesLog(sBootErr);
//         AddLinesLog('EEP5009 not found!');
         err:=True;
        end
        else begin
         AddLinesLog(sBootErr);
         ProgressBar.StepIt;
         Application.ProcessMessages;
         if (Not flgBootLoad) or flgBFBExit then begin Stop; exit; end;
         Decode5009(EEP5009,CryptModel);
         BCD2IMEI(EEP5009,IMEI);
         if Length(IMEI)>=16 then IMEI[15]:=IMEI[16];
         SetLength(IMEI,15);
         AddLinesLog('EEP IMEI: ' + IMEI);
         if Not CalcImei15(IMEI,ch) then begin
          AddLinesLog('Error IMEI in EEP5009!');
          err:=True;
         end
         else begin
          if ch<>IMEI[15] then begin
           AddLinesLog('Error('+ch+','+Char(IMEI[15])+') CRC IMEI!');
           err:=True;
          end;
//          else EditJImei.Text:=IMEI;
//          AddLinesLog(sBootErr); // FSN=...
          if debug then begin
           IMEI2xBCD(IMEI);
           AddLinesLog('EEP5008:');
           DeCrypt5008blk(FSN,EEP5008);
           AddLinesLog(BufToHex_Str(@EEP5008,8));
           AddLinesLog(BufToHex_Str(@EEP5008[8],24));
           AddLinesLog(BufToHex_Str(@EEP5008[32],8));
           AddLinesLog(BufToHex_Str(@EEP5008[40],176));
           AddLinesLog(BufToHex_Str(@EEP5008[216],8));
           DeCrypt5077blk(FSN,EEP5077);
           AddLinesLog('EEP5077:');
           AddLinesLog(BufToHex_Str(@EEP5077,8));
           AddLinesLog(BufToHex_Str(@EEP5077[8],216));
           AddLinesLog(BufToHex_Str(@EEP5077[224],8));
          end;
         end;
        end; // if ReadEEPl55Boot(FSN)
       end; // if CheckBoxSaveSecBlkEEP.Checked
       ProgressBar.StepIt;
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then begin Stop; exit; end;
       Terminatel55Boot;
       AddLinesLog(sBootErr);
///////////////////
       ProgressBar.StepIt;
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then begin Stop; exit; end;
       if Not CheckBoxSaveSecBlkEEP.Checked and FlgOTPImeiErr then err:=True;
       if err then begin
        AddLinesLog('Data Error!');
        Beep;
       end
       else begin
        if Not CheckBoxSaveSecBlkEEP.Checked then  IMEI:=OTPIMEI;
        if TestAndCalcSkey then begin
         if CheckBoxSaveSecBlkEEP.Checked or CheckBoxSaveSecBlkOTP.Checked then SaveNewSecBlocks;
         ProgressBar.Position:=100;
        end;
       end;
       Terminate;
       exit;
      end; // if StartBootAndInfo
      Stop;
end;

procedure TFormMain.ButtonSendSkeyClick(Sender: TObject);
var
i : integer;
err : boolean;
oldSecMode : byte;
s : string;
begin
    if flgBootLoad then begin
       Sleep(200);
       ChangeComSpeed(115200);
       if BFB_PhoneOff then AddLinesLog('Phone Off.');
       Stop;
       AddLinesLog('Cancel.');
       exit;
    end;
    err:=True;
    oldSecMode:=$FF;
    AllKeyDisable;
    ButtonSendSkey.Caption :='Cancel';
    ButtonSendSkey.Enabled:=True;
    if StartServiceMode($07) then begin
     if InfoBFB then begin
      SKey:=IniFile.ReadInteger(IMEI,'SKEY',0);
      oldSecMode:=SecMode;
      if SKey=0 then begin
       AddLinesLog('Skey not found in Joker.ini!')
      end
      else FormNewSkey.SpinEditSkey.Value:=SKey;
      Case SecMode of
       00: s:='Repair';
       01: s:='Developer';
       02: s:='Factory';
       03: s:='Customer';
      else  s:='Unknown('+IntToHex(SecMode,2)+')';
      end;
      FormNewSkey.Top:=Top+240;
      FormNewSkey.Left:=Left+200;
      FormNewSkey.LabelImei.Caption:='IMEI: '+IMEI;
      FormNewSkey.LabelSecMode.Caption:='SecurityMode: '+s;
      if FormNewSkey.ShowModal <> mrOk then begin
//       AddLinesLog('Use "Calc Skey"!');
       AddLinesLog('Cancel.');
//       beep;
       err:=True;
      end
      else begin
       SKey:=FormNewSkey.SpinEditSkey.Value;
       AddLinesLog('Send SKey('+Int2Digs(SKEY,8)+')...');
       ibfb.code.cmdb:=0;
       ibfb.code.datab[1]:=1;
//       if NOT BFB_SendSkey(SKEY) then
       BFB_SendSkey(SKEY);
//       EditJImei.Text:=IMEI;
       i:=15;
       if ibfb.code.cmdb=$57 then begin
        i:=ibfb.code.datab[0]*10;
//        if i>100 then i:=100;
       end;
       while i>0 do begin
        if ProgressBar.Position>=100 then ProgressBar.Position:=1
        else ProgressBar.StepBy(2);
        Application.ProcessMessages;
        if (Not flgBootLoad) or flgBFBExit then exit;
        Sleep(100);
        dec(i);
       end;
       if BFB_GetSecurityMode(SecMode) then err:=False;
      end;
     end
     else err:=True;
     if BFB_Phoneoff then AddLinesLog('Phone Off.');
     ComClose;
     if err then AddLinesLog('Send SKey: Error!')
     else begin
      if (SecMode=2) then begin
       if (oldSecMode<>2) then begin
        AddLinesLog('SKey Send: Ok! All Open.');
        IniFile.WriteInteger(IMEI,'SKEY',SKey);
       end
       else AddLinesLog('SKey Send: Ok! All Close.');
      end
      else AddLinesLog('SKey Send: Ok! - Please Check up!');
     end;
    end;
    Stop;
    ProgressBar.Position:=100;
end;
{
procedure TFormMain.ButtonReadClick(Sender: TObject);
var
addr,size : dword;
buf : array[0..65535] of byte;
begin
    with SaveDialog do begin
     FilterIndex:=1;
     FileName := IniFile.ReadString('Setup','NewBinFile','xxx.bin');
     InitialDir := ExtractFilePath(FileName);
     FileName := ChangeFileExt(ExtractFileName(OpenDialog.FileName),'.bin');
     if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
     if not DirectoryExists(InitialDir) then
      InitialDir := IniFile.ReadString('Setup','DirOld','.\');
     DefaultExt := 'bin';
     Filter := 'Bin files (*.bin)|*.bin|All files (*.*)|*.*';
     Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
     Title:='Выбирите имя для сохранения BIN файла';
    end;//with
    if SaveDialog.Execute then begin
     ProgressBar.Position:=80;
     addr:=$400000;
     size:=$80000;
     while size<>0 do begin
       if Not ReadFlashl55Boot(addr,SizeOf(buf),buf[0]) then begin
        exit;
       end;
       addr:=addr+SizeOf(buf);
       size:=size-SizeOf(buf);
     end;
     IniFile.WriteString('Setup','NewBinFile',SaveDialog.FileName);
     ProgressBar.Position:=100;
     AddLinesLog('Bin файл записан в '+SaveDialog.FileName);
     exit;
    end // if SaveDialog.Execute
    else AddLinesLog('Отмена.');
end;
}
{
procedure TFormMain.ButtonBootClick(Sender: TObject);
//var
//err : boolean;
begin
      if flgBootLoad then begin
       flgBootLoad := False;
       Sleep(200);
       Stop;
       AddLinesLog('Cancel.');
       exit;
      end;
      AllKeyDisable;
      ButtonBoot.Caption := 'Cancel';
      ButtonBoot.Enabled:=True;
      Model:=RadioGroupTelType.ItemIndex;
//      err := False;
      if SendAllBoot then begin
       if RadioGroupBaud.ItemIndex<>0 then begin
        if Not SetBaudl55Boot(RadioGroupBaud.ItemIndex) then begin
         AddLinesLog(sBootErr);
         Stop;
         exit;
        end;
        AddLinesLog(sBootErr);
       end;
       ProgressBar.StepIt;
       if Not GetFlashIDl55Boot(FlashID) then begin
        AddLinesLog(sBootErr);
        Stop;
        exit;
       end;
//       if Model = A55 then AddLinesLog('FlashID: '+BufToHexStr(@FlashID[0],4)+'\'+BufToHexStr(@FlashID[4],4))
       AddLinesLog(sBootErr);
       ProgressBar.StepIt;
       Terminate;
       ProgressBar.Position:=100;
       AddLinesLog('Start another flasher!');
       exit;
      end;
      Stop;

end;
}
procedure TFormMain.MaskEditAddrChange(Sender: TObject);
var
s : string;
begin
 s := MaskEditAddr.Text;
 If s[1]>'F' then begin
    s[1]:=Char(' ');
    MaskEditAddr.Text:=s;
    beep;
    exit;
 end;
 If s[2]>'F' then begin
    s[2]:=Char(' ');
    MaskEditAddr.Text:=s;
    beep;
    exit;
 end;
end;

procedure TFormMain.MaskEditSizeChange(Sender: TObject);
var
s : string;
defHex : string;
i : integer;
begin
 s := MaskEditSize.Text;
 If s[1]>'1' then begin
    s[1]:=Char(' ');
    MaskEditSize.Text:=s;
    beep;
    exit;
 end;
 If s[2]>'F' then begin
    s[2]:=Char(' ');
    MaskEditSize.Text:=s;
    beep;
    exit;
 end;
 If s[3]>'F' then begin
    s[3]:=Char(' ');
    MaskEditSize.Text:=s;
    beep;
    exit;
 end;
 if (s[1]<>' ') and (s[2]<>' ') and (s[3]<>' ') then begin
  defHex := '$PVV';
  defHex[2] := s[1];
  defHex[3] := s[2];
  defHex[4] := s[3];
  i:=StrToIntDef(defHex,0);
  if i = 0 then begin
    s[3]:=Char(' ');
    MaskEditSize.Text:=s;
    beep;
    exit;
  end;
  if i > $100 then begin
    MaskEditSize.Text:='1  ';
    beep;
    exit;
  end;
 end;
end;

procedure TFormMain.ButtonBFEEPClick(Sender: TObject);
begin
      if flgBootLoad then begin
       flgBootLoad := False;
       Sleep(200);
       Stop;
       AddLinesLog('Cancel.');
       exit;
      end;
      AllKeyDisable;
      ButtonBFEEP.Caption := 'Cancel';
      ButtonBFEEP.Enabled:=True;
      Model:=RadioGroupTelType.ItemIndex;
      if StartBootAndInfo then begin //SendAllBoot
       ProgressBar.Position:=100;
       if (Not flgBootLoad) or flgBFBExit then begin
         Stop;
         exit;
       end;
       ProgressBar.Position:=10;
       if FlashInfo.SegEELITE=0 then begin
        AddLinesLog('Error: The segments EEPROM are not found!');
        Stop; exit;
       end;
       if Not BootBackupEEP then begin Stop; exit; end;
//       AddLinesLog('Boot terminated...');
//       if Not Terminatel55Boot then AddLinesLog(sBootErr);
       AddLinesLog(IntToStr(idx_eeptab)+' factory EEP blocks are read out and are saved.');
       ProgressBar.Position:=100;
      end;
      Stop;
end;

procedure TFormMain.ButtonReadClick(Sender: TObject);
var
addr,size : dword;
F : TFileStream;
begin
      if flgBootLoad then begin
       flgBootLoad := False;
       Sleep(200);
       Stop;
       AddLinesLog('Cancel.');
       exit;
      end;
      addr:=StrToIntDef('$'+MaskEditAddr.Text,$100);
      size:=StrToIntDef('$'+MaskEditSize.Text,$200);
      if addr>=$100 then begin
       AddLinesLog('Error Block Addres!');
       exit;
      end;
      if (size>$100) and (size=0) then begin
       AddLinesLog('Error Block Size!');
       exit;
      end;
      addr:=addr shl 16;
      size:=size shl 16;
      AllKeyDisable;
      ButtonRead.Caption := 'Cancel';
      ButtonRead.Enabled:=True;
      Model:=RadioGroupTelType.ItemIndex;
//      err := False;
      if StartBootAndInfo then begin //SendAllBoot
       ProgressBar.Position:=100;
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then begin
         Stop;
         exit;
       end;
       BinMemoryStream := TMemoryStream.Create;
       BinMemoryStream.SetSize(size);
       ProgressBar.Position:=0;
       ProgressBar.Max:=size;
//GetFlashInfo;
//       addr:=$800000;
//       size:=$20000;
       if Not ReadFlashSeg(addr,size,16384) then begin
        BinMemoryStream.Free;
        ProgressBar.Max:=100;
        Stop;
        exit;
       end;
       Stop;
       ProgressBar.Max:=100;
       ProgressBar.Position:=100;
       AddLinesLog('Read Flash addr: 0x'+IntToHex(addr,6)+' size: 0x'+IntToHex(size,6)+' - Ok.');
    with SaveDialog do begin
     Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
     FilterIndex:=1;
     FileName := IniFile.ReadString('Setup','NewBinFile','.\xxxf.bin');
     InitialDir := ExtractFilePath(FileName);
     FileName:=PhoneName+'_'+IntToHex(addr shr 16,2)+'-'+IntToHex(size shr 16,2)+'_'+tabnnbin[RadioGroupFlash.ItemIndex]+'.bin';
//     FileName := ChangeFileExt(ExtractFileName(FileName),'.bin');
     if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
     if not DirectoryExists(InitialDir) then
      InitialDir := IniFile.ReadString('Setup','DirOld','.\');
     DefaultExt := 'bin';
     Filter := 'Bin files (*.bin)|*.bin|All files (*.*)|*.*';
     Title:='Select name for saving BIN file';
    end;//with
    if SaveDialog.Execute then begin
     F:=TFileStream.Create(SaveDialog.FileName,fmCreate);
     BinMemoryStream.Seek(0,soFromBeginning);
     F.CopyFrom(BinMemoryStream,BinMemoryStream.Size);
     F.Free;
     BinMemoryStream.Free;
     IniFile.WriteString('Setup','NewBinFile',SaveDialog.FileName);
     AddLinesLog('Data is written in "'+SaveDialog.FileName+'" file.');
     exit;
    end // if SaveDialog.Execute
    else AddLinesLog('Cancel.');
    BinMemoryStream.Free;
    exit;
   end;
   Stop;
end;

function TFormMain.ReCalcEEPSeg(addr: dword; xb: integer; var buf: array of byte): dword;
var
i : integer;
offaddr : dword;
size : word;
eepptr : pointer;
b : dword;
begin
  result:=0;
  b:=0;
  if addr=TabFlash[Model][tEEBase] then begin
   if ((dword((@buf[$10])^)=$4545FEFE) and (dword((@buf[$14])^)=$4554494C))
   or ((dword((@buf[$80])^)=$4545FEFE) and (dword((@buf[$84])^)=$4554494C))
   then begin
     move(BootKey[0],buf[0],16);
     b:=b or BitBkey;
     result:=result or b;
   end;
  end;
  eepptr:=Nil;
  i:=xb-2;
  while i>10 do begin
   if (word((@buf[i])^)=$FC00)
   and (buf[i-10]=$FC) then begin
//    Dec(i,2);
    size := 0;
    case word((@buf[i-2])^) of
     5123 : begin
             size:=12;
             eepptr:=@EEP5123[0];
             b := b or BitEEP5123;
             if (word((@buf[i-2-4-2])^)=14) then begin
              size:=14;
              move(EEP5121[0],EEP5123[5],8);
              EEP5123[13]:=0;
             end;
            end;
     5122 : begin size:=SizeOf(EEP5122); eepptr:=@EEP5122[0]; b:=b or BitEEP5122; end;
     5121 : begin size:=SizeOf(EEP5121); eepptr:=@EEP5121[0]; b:=b or BitEEP5121; end;
     5077 : begin size:=SizeOf(EEP5077); eepptr:=@EEP5077[0]; b:=b or BitEEP5077; end;
     5009 : begin size:=SizeOf(EEP5009); eepptr:=@EEP5009[0]; b:=b or BitEEP5009; end;
     5008 : begin size:=SizeOf(EEP5008); eepptr:=@EEP5008[0]; b:=b or BitEEP5008; end;
     0076 : begin size:=SizeOf(EEP0076); eepptr:=@EEP0076[0]; b:=b or BitEEP0076; end;
     0067 : begin
      if CheckBoxPrFacEEP.Checked and ((FlgBkEEP and BitEEP0067)<>0) then begin
       size:=SizeOf(EEP0067); eepptr:=@EEP0067[0]; b:=b or BitEEP0067;
      end;
     end;
     5005 : begin
      if CheckBoxPrFacEEP.Checked and ((FlgBkEEP and BitEEP5005)<>0) then begin
       size:=64; eepptr:=@EEP5005[0]; b:=b or BitEEP5005;
      end;
     end;
     5007 : begin
      if CheckBoxPrFacEEP.Checked and ((FlgBkEEP and BitEEP5007)<>0) then begin
       size:=word((@buf[i-2-4-2])^);
       if (size<4) or (size>SizeOf(EEP5007)) then size:=0;
       eepptr:=@EEP5007[0]; b:=b or BitEEP5007;
      end;
     end;
     5012 : begin
      if CheckBoxPrFacEEP.Checked and ((FlgBkEEP and BitEEP5012)<>0) then begin
       size:=word((@buf[i-2-4-2])^);
       if (size<12) or (size>SizeOf(EEP5012)) then size:=0;
       eepptr:=@EEP5012[0]; b:=b or BitEEP5012;
      end;
     end;
     5093 : begin
      if CheckBoxPrFacEEP.Checked and ((FlgBkEEP and BitEEP5093)<>0) then begin
       size:=word((@buf[i-2-4-2])^);
       if (size<32) or (size>SizeOf(EEP5093)) then size:=0;
       eepptr:=@EEP5093[0]; b:=b or BitEEP5093;
      end;
     end;
    end;
    if (size<>0) and (word((@buf[i-2-4-2])^)=size)
    then begin
     offaddr:=(dword((@buf[i-2-4])^) - addr) and $3FFFFF; //or (addr and $C00000))-addr;
     if (offaddr<dword(xb)) and (offaddr+size<dword(xb)) then begin
      move(eepptr^,buf[offaddr],size);
      result:=result or b;
//      AddLinesLog(IntToStr(word((@buf[i])^))+':');
//      AddLinesLog(BufToHexStr(@buf[offaddr],size));
//      AddLinesLog(BufToHexStr(eepptr,size));
     end;
    end;
   end;
   Dec(i,4);
  end;
end;

function TFormMain.RestoreEEPSeg(addr: dword; xb: integer; var buf: array of byte): dword;
var
i : integer;
offaddr : dword;
size : word;
eepptr : pointer;
b : dword;
begin
  result:=0;
  eepptr:=Nil;
  b:=0;
  i:=xb-2;
  while i>10 do begin
   if (word((@buf[i])^)=$FC00)
   and (buf[i-10]=$FC) then begin
    size := 0;
    case word((@buf[i-2])^) of
     0067 : begin
      if ((FlgBkEEP and BitEEP0067)<>0) then begin
       size:=SizeOf(EEP0067); eepptr:=@EEP0067[0]; b:=b or BitEEP0067;
      end;
     end;
     5005 : begin
      if ((FlgBkEEP and BitEEP5005)<>0) then begin
       size:=64; eepptr:=@EEP5005[0]; b:=b or BitEEP5005;
      end;
     end;
     5007 : begin
      if ((FlgBkEEP and BitEEP5007)<>0) then begin
       size:=word((@buf[i-2-4-2])^);
       if (size<4) or (size>SizeOf(EEP5007)) then size:=0;
       eepptr:=@EEP5007[0]; b:=b or BitEEP5007;
      end;
     end;
     5012 : begin
      if ((FlgBkEEP and BitEEP5012)<>0) then begin
       size:=word((@buf[i-2-4-2])^);
       if (size<12) or (size>SizeOf(EEP5012)) then size:=0;
       eepptr:=@EEP5012[0]; b:=b or BitEEP5012;
      end;
     end;
     5093 : begin
      if ((FlgBkEEP and BitEEP5093)<>0) then begin
       size:=word((@buf[i-2-4-2])^);
       if (size<>SizeOf(EEP5093)) or (size<>32) or (size<>64) then size:=0;
       eepptr:=@EEP5093[0]; b:=b or BitEEP5093;
      end;
     end;
    end;
    if (size<>0) and (word((@buf[i-2-4-2])^)=size)
    then begin
     offaddr:=(dword((@buf[i-2-4])^) - addr) and $3FFFFF; //or (addr and $C00000))-addr;
     if (offaddr<dword(xb)) and (offaddr+size<dword(xb)) then begin
      move(eepptr^,buf[offaddr],size);
      result:=result or b;
     end;
    end;
   end;
   Dec(i,4);
  end;
end;

procedure TFormMain.ChangeInfo(flgrec : dword; s : string);
begin
  if (flgrec and BitHASH)<>0 then AddLinesLog('Change BCORE HASH - '+s);
  if (flgrec and BitBkey)<>0 then AddLinesLog('Change BOOTKEY - '+s);
  if (flgrec and BitEEP0076)<>0 then AddLinesLog('Change EEP0076 - '+s);
  if (flgrec and BitEEP5008)<>0 then AddLinesLog('Change EEP5008 - '+s);
  if (flgrec and BitEEP5009)<>0 then AddLinesLog('Change EEP5009 - '+s);
  if (flgrec and BitEEP5077)<>0 then AddLinesLog('Change EEP5077 - '+s);
  if (flgrec and BitEEP5121)<>0 then AddLinesLog('Change EEP5121 - '+s);
  if (flgrec and BitEEP5122)<>0 then AddLinesLog('Change EEP5122 - '+s);
  if (flgrec and BitEEP5123)<>0 then AddLinesLog('Change EEP5123 - '+s);
  if (flgrec and BitEEP0067)<>0 then AddLinesLog('Restore EEP0067 - '+s);
  if (flgrec and BitEEP5005)<>0 then AddLinesLog('Restore EEP5005 - '+s);
  if (flgrec and BitEEP5007)<>0 then AddLinesLog('Restore EEP5007 - '+s);
  if (flgrec and BitEEP5012)<>0 then AddLinesLog('Restore EEP5012 - '+s);
  if (flgrec and BitEEP5093)<>0 then AddLinesLog('Restore EEP5093 - '+s);
  if (flgrec and BitClrBC)<>0 then AddLinesLog('BCORE prepared for Freeze - '+s);
end;

procedure TFormMain.ButtonWriteClick(Sender: TObject);
var
HashAddr,off_base,addr,size,xa,xo,xb : dword;
F : TFileStream;
buf : array[0..$1FFFF] of byte;
flgrec, x : dword;
ffflashid : dword;
flgFullFlashFile : boolean;
ch : char;
begin
      if flgBootLoad then begin
       flgBootLoad := False;
       Sleep(200);
       Stop;
       AddLinesLog('Cancel.');
       exit;
      end;
      ProgressBar.Position:=0;
      addr:=StrToIntDef('$'+MaskEditAddr.Text,$100);
      size:=StrToIntDef('$'+MaskEditSize.Text,$200);
      if addr>=$100 then begin
       AddLinesLog('Error Block Addres!');
       exit;
      end;
      if (size>$100) and (size=0) then begin
       AddLinesLog('Error Block Size!');
       exit;
      end;
      addr:=addr shl 16;
      size:=size shl 16;
      off_base:=0;
      ffflashid:=0;
      flgFullFlashFile:=False;
      with OpenDialog do begin
       FilterIndex:=1;
       FileName := IniFile.ReadString('Setup','BinFile','x.bin');
       InitialDir := ExtractFilePath(FileName);
       FileName := ExtractFileName(FileName);
       if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
       if not DirectoryExists(InitialDir) then InitialDir := '.\';
       DefaultExt := 'bin';
       Filter := 'Bin files (*.bin)|*.bin|All files (*.*)|*.*';
       Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
       Title:='Select the file for write in Flash';
      end;//with OpenDialog
      if not OpenDialog.execute then exit;
      flgrec := 0;
      AddLinesLog('Open file "'+OpenDialog.FileName+'" for write in Flash.');
      F:=TFileStream.Create(OpenDialog.FileName,fmOpenRead+fmShareCompat);
      if ((F.size and $FFFF)<>0)
      or (F.size > $1000000)
      or (F.size = 0)
      then begin
       AddLinesLog('Not valid file size! (size='+inttostr(F.size)+').');
       F.free;
       exit;
      end;
      if integer(size) <> F.size then begin
       if (RadioGroupFlash.ItemIndex <> nFullFlash) and (dword(F.size) = TabFlash[Model][tFFSize]) then begin
        if ((addr-TabFlash[Model][tFFBase]) and $80000000)<>0 then begin
          AddLinesLog('Not valid file of set addres writes Flash!');
          F.free;
          exit;
        end;
        if MessageDlg('Extract block from FullFlash file?',mtConfirmation, [mbYes, mbNo], 0) = mrYes
        then begin
//          size:=F.size;
//          RadioGroupFlash.ItemIndex:=nManual;
//          MaskEditSize.Text:=IntToHex(size shr 16,3);
           flgFullFlashFile:=True;
           off_base:=addr-TabFlash[Model][tFFBase];
           AddLinesLog('Use file FullFlash (offset block in file = 0x'+IntToHex(off_base,6)+').');
        end
        else begin
          AddLinesLog('Not valid file size! (size='+inttostr(F.size)+').');
          F.free;
          exit;
        end;
       end
       else if MessageDlg('The file size is not equivalent to a size of area! To record?',mtConfirmation, [mbYes, mbNo], 0) = mrYes
       then begin
        size:=F.size;
        RadioGroupFlash.ItemIndex:=nManual;
        MaskEditSize.Text:=IntToHex(size shr 16,3);
       end
       else begin
        AddLinesLog('Not valid file size! (size='+inttostr(F.size)+').');
        F.free;
        exit;
       end;
      end;
      IniFile.WriteString('Setup','BinFile',OpenDialog.FileName);
      if (RadioGroupFlash.ItemIndex = nFullFlash)
      or (dword(F.size) = TabFlash[Model][tFFSize])
      then flgFullFlashFile:=True;
      if flgFullFlashFile then begin
       xo:=$87FDC0-TabFlash[Model][tFFBase];
       if xo+$87FFA0-$87FDC0 < dword(F.size) then begin
        F.Seek(xo,soFromBeginning);
        if (F.Read(buf[0],$87FFA0-$87FDC0) <> $87FFA0-$87FDC0)
        or (dword((@buf[0])^)<>$534C0100) then begin
         ffflashid:=0;
         AddLinesLog('FullFlash file info not valid!');
         beep;
        end
        else begin
         ffflashid:=dword((@buf[$87FE26-$87FDC0])^);
         if ((ffflashid and $FF00) <> 0) then begin
          AddLinesLog('FullFlash file info not valid!');
          if ffflashid<>$FFFFFFFFF then AddLinesLog('Not valid FlashID('+IntToHex(ffflashid and $FFFF,4)+'/'+IntToHex(ffflashid shr 16,4)+') in FullFlash file!')
          else ffflashid:=0;
          beep;
         end
         else begin
//          AddLinesLog('FullFlash file used FlashID: '+IntToHex(ffflashid and $FFFF,4)+'/'+IntToHex(ffflashid shr 16,4));
          buf[$87FF6F-$87FDC0]:=0;
          buf[$87FF7F-$87FDC0]:=0;
          buf[$87FF8F-$87FDC0]:=0;
          AddLinesLog('FullFlash file info:');
          AddLinesLog(' FlashID: '+IntToHex(ffflashid and $FFFF,4)+'/'+IntToHex(ffflashid shr 16,4));
          AddLinesLog(' '+pchar(@buf[$87FF80-$87FDC0])
          +' '+pchar(@buf[$87FF70-$87FDC0])
          +' Sw'+IntToHex(buf[$87FF50-$87FDC0],2)
          +' '+pchar(@buf[$87FF60-$87FDC0]));
          if TabFlash[Model][tLGBase]<>0 then begin
           xo:=TabFlash[Model][tLGBase]-TabFlash[Model][tFFBase];
           if xo+$20 < dword(F.size) then begin
            F.Seek(xo,soFromBeginning);
            if (F.Read(buf[0],$20)=$20)
            or (dword((@buf[0])^)=$0000BBBB) then begin
             buf[$1A]:=0;
             AddLinesLog(' RealLgPack: '+pchar(@buf[$16]));
            end
            else AddLinesLog(' RealLgPack: not valid!');
           end;
          end; // if TabFlash[Model][tLGBase]<>0
         end; // if ((ffflashid and $FF00) <> 0)
        end; // if (F.Read(buf
       end; // if xo+$87FFA0-$87FDC0 < dword(F.size)
      end;
      AllKeyDisable;
      ButtonWrite.Caption := 'Cancel';
      ButtonWrite.Enabled:=True;
      Model:=RadioGroupTelType.ItemIndex;
//      if SendAllBoot then begin
/////////// Load Boots
      if StartBootAndInfo then begin
       ProgressBar.Position:=100;
       if FlashInfo.CFI.FlashSizeN=0 then begin
        AddLinesLog('Warning: Unknown flash size in settings phone model!');
       end
       else if ffflashid<>0 then begin
        if FlashInfo.Flash1IM <> (ffflashid and $FFFF) then
        if MessageDlg('FullFlashID('+IntToHex(ffflashid and $FFFF,4)+'/'+IntToHex(ffflashid shr 16,4)+') not FlashID! Write?',mtConfirmation, [mbYes, mbNo], 0) <> mrYes
        then begin
          F.free;
          AddLinesLog('Not valid use FlashID! Cancel.');
          Stop;
          exit;
        end;
       end;
       if CheckBoxBkEEP.Enabled and CheckBoxBkEEP.Checked then begin
         if Not BootBackupEEP then begin Stop; Exit; end;
       end;
//       if FlashInfo.SegEELITE<>0 then begin
//       end;
{       if FlashInfo.CFI.FlashSizeN<>0 then begin
        if (FlashInfo.CFI.FlashSizeN shr 8)<>TabFlash[Model][tFFSize] then
         AddLinesLog('Warning: Not valid addres EELITE in set phone model!');
       end; }
       if CheckBoxReCalcKeys.Enabled and CheckBoxReCalcKeys.Checked then begin
        if FlgOTPImeiErr then begin
         AddLinesLog('OTP IMEI is Bad! Will be used EXT IMEI: ' + EditJImei.Text +'?');
         if (Not CalcImei15(EditJImei.Text,ch)) or (EditJImei.Text[15]<>ch) then begin
          AddLinesLog('External IMEI is not correctly entered!');
          F.free;
          Stop;
          exit;
         end;
         if MessageDlg('OTP IMEI is Bad! Will be used EXT IMEI: ' + EditJImei.Text +'?',mtConfirmation, [mbYes, mbNo], 0) <> mrYes
         then begin
          F.free;
          Stop;
          AddLinesLog('Cancel.');
          exit;
         end;
         OTPIMEI:=EditJImei.Text;
        end;
        IMEI:=OTPIMEI;
        ReadIniImeiKeys;
        if (Not TestSkey(SKEY,FSN,False)) then CalcHashAndBkey(SKEY,FSN);
        AddLinesLog('USE SKEY: '+Int2Digs(SKEY,8));
        if (RadioGroupFlash.ItemIndex=nFullFlash)
        or (RadioGroupFlash.ItemIndex=nEEPROM)
        or (RadioGroupFlash.ItemIndex=nManual)then begin
         AddLinesLog('*#0000*'+Int2Digs(Mkey[0],8)+'# - Network Lock');
         AddLinesLog('*#0001*'+Int2Digs(Mkey[1],8)+'# - Service Provider Lock');
         AddLinesLog('*#0002*'+Int2Digs(Mkey[2],8)+'# - Corporate Code');
         AddLinesLog('*#0003*'+Int2Digs(Mkey[3],8)+'# - Phone Code');
         AddLinesLog('*#0004*'+Int2Digs(Mkey[4],8)+'# - Network Subset Lock');
         AddLinesLog('*#0005*'+Int2Digs(Mkey[5],8)+'# - Only Sim');
        end;
//        AddLinesLog('USE HASH='+BufToHexStr(@HASH[0],16));
        Create76(IMEI,EEP0076,CryptModel);
        Create5008(IMEI,FSN,EEP5008,CryptModel);
        Create5009(IMEI,EEP5009,CryptModel);
        Create5077(IMEI,FSN,EEP5077,CryptModel);
        Create512x(IMEI,FSN,Skey,Mkey);
       end;
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then begin
         F.free;
         Stop;
         exit;
       end;
////////////
       ProgressBar.Position:=0;
       ProgressBar.Max:=size;
       xa:=addr and $FF0000;
       xo:=0;
       while xo<size do begin
        Application.ProcessMessages;
        if (Not flgBootLoad) or flgBFBExit then begin
         F.Free;
         ProgressBar.Max:=100;
         Stop;
         exit;
        end;
        xb:=SizeOf(buf);
        if xb>size-xo then xb:=size-xo;
        F.Seek(xo+off_base,soFromBeginning);
        if F.Read(buf[0],xb)<>integer(xb) then begin
         AddLinesLog('Error read block from file!');
         F.Free;
         ProgressBar.Max:=100;
         Stop;
         exit;
        end;
//        xc:=xa-TabFlash[Model][tBCBase];
        if CheckBoxBcorePr.Enabled and CheckBoxBcorePr.Checked
        and (xa-TabFlash[Model][tBCBase]<TabFlash[Model][tBCSize]) then begin
          segsize:=TabFlash[Model][tBCSize];
        end
        else begin // write
         if CheckBoxReCalcKeys.Enabled and CheckBoxReCalcKeys.Checked then begin
          if Not (CheckBoxClrBC.Enabled and CheckBoxClrBC.Checked) then begin
           if (xa-TabFlash[Model][tBCBase]<TabFlash[Model][tBCSize]) then begin
            if (dword((@buf[$300])^)=$534C0100)
            and (dword((@buf[$31C])^)=$4D454953)
            and (dword((@buf[$320])^)=$00534E45) then begin
             HashAddr:=$330;
             if Model=MA50 then HashAddr:=$32E;
             Move(HASH,buf[HashAddr],16);
             flgrec:=flgrec or BitHASH;
            end;
            flgrec:=flgrec or BitBCORE;
           end;
          end;
          if (xa-TabFlash[Model][tEEBase]<TabFlash[Model][tEESize]) then begin
           flgrec := flgrec or BitEEPROM or ReCalcEEPSeg(xa,xb,buf);
          end;
         end else if CheckBoxPrFacEEP.Enabled and CheckBoxPrFacEEP.Checked
         and (xa-TabFlash[Model][tEEBase]<TabFlash[Model][tEESize]) then begin
           flgrec := flgrec or BitEEPROM or RestoreEEPSeg(xa,xb,buf);
         end;
         if (Model<>MA50) and CheckBoxClrBC.Enabled and CheckBoxClrBC.Checked
         and (xa-TabFlash[Model][tBCBase]<TabFlash[Model][tBCSize]) then begin
          if (dword((@buf[$300])^)=$534C0100)
          and (dword((@buf[$31C])^)=$4D454953)
          and (dword((@buf[$320])^)=$00534E45) then begin
           FillChar(buf[$304],4,$FF);
           FillChar(buf[$30C],$23A,$FF);
           buf[$32E]:=$AF;
           buf[$32F]:=$FB;
           flgrec:=flgrec or BitClrBC;
          end;
          flgrec:=flgrec or BitBCORE;
         end;
//{
         if Not WriteSegFlashl55Boot(xa,xb,buf[0]) then begin
          F.Free;
          AddLinesLog(sBootErr);
          ProgressBar.Max:=100;
          Stop;
          exit;
         end;
//} segsize:=$20000;
        end;
        xa:=xa+segsize;
        xo:=xo+segsize;
        ProgressBar.Position:=xo;
       end;
       Stop;
       ProgressBar.Max:=100;
       ProgressBar.Position:=100;
       F.Free;
       if CheckBoxReCalcKeys.Enabled and CheckBoxReCalcKeys.Checked then begin
        ChangeInfo(flgrec and (BitClrBC or BitHASH or BitEEP0076 or BitEEP5009 or BitEEP5009 or BitEEP5077 or BitEEP5121 or BitEEP5122 or BitEEP5123 or BitBkey),'Ok.');
        case RadioGroupFlash.ItemIndex of
         nFullFlash : if CheckBoxClrBC.Enabled and CheckBoxClrBC.Checked then x := BitClrBC or BitEEP0076 or BitEEP5009 or BitEEP5009 or BitEEP5077 or BitEEP5121 or BitEEP5122 or BitEEP5123 or BitEEPROM or BitBkey
                      else x := BitHASH or BitEEP0076 or BitEEP5009 or BitEEP5009 or BitEEP5077 or BitEEP5121 or BitEEP5122 or BitEEP5123 or BitEEPROM or BitBkey;
         nBootCore  : if CheckBoxClrBC.Enabled and CheckBoxClrBC.Checked then x := BitClrBC or BitBCORE
                      else x := BitHASH or BitBCORE;
         nEEPROM    : x := BitEEP0076 or BitEEP5009 or BitEEP5009 or BitEEP5077 or BitEEP5121 or BitEEP5122 or BitEEP5123 or BitEEPROM or BitBkey;
        else x:=0;
        end;
        if ((flgrec and x)<> x) then ChangeInfo((flgrec and x) xor x,'Error!');
        WriteIniImeiKeys(True);
       end;
       if CheckBoxPrFacEEP.Enabled and CheckBoxPrFacEEP.Checked then begin
        if (flgrec and BitEEPROM) <> 0 then begin
         ChangeInfo(flgrec and (BitEEP0067 or BitEEP5005 or BitEEP5007 or BitEEP5012 or BitEEP5093),'Ok.');
         ChangeInfo((flgrec and (BitEEP0067 or BitEEP5005 or BitEEP5007 or BitEEP5012 or BitEEP5093)) xor (BitEEP0067 or BitEEP5005 or BitEEP5007 or BitEEP5012 or BitEEP5093),'Error!');
        end;
       end;
       AddLinesLog('Data file "'+OpenDialog.FileName+'".');
       AddLinesLog('Write Flash addr: 0x'+IntToHex(addr,6)+' size: 0x'+IntToHex(size,6)+' - Ok.');
       if ((flgrec and (BitClrBC or BitBCORE))=(BitClrBC or BitBCORE)) then AddLinesLog('Use Freeze!');
       exit;
      end;
      F.Free;
      Stop;
end;

procedure TFormMain.CheckBoxExtIMEIClick(Sender: TObject);
begin
  EditJImei.Enabled:=CheckBoxExtIMEI.Checked;
  if CheckBoxExtIMEI.Checked then CheckBoxUseOTPImei.Checked:=False;
end;

procedure TFormMain.EditJImeiChange(Sender: TObject);
var
i : integer;
sText : string;
c : char;
begin
  sText:=EditJImei.Text;
  i:=length(sText);
  if (i>=15) then begin
   if CalcImei15(sText,c) then begin
    setlength(sText,14);
    EditJImei.Text:=sText+c;
   end;
  end;
end;

procedure TFormMain.ShowTabFlash;
begin
 Case RadioGroupFlash.ItemIndex of
   nFullFlash: begin
    CheckBoxBcorePr.Enabled:=True;
    MaskEditAddr.Enabled:=False;
    MaskEditSize.Enabled:=False;
    CheckBoxReCalcKeys.Enabled:=True;
    CheckBoxBkEEP.Enabled:=True;
    CheckBoxPrFacEEP.Enabled:=True;
    if Model=MA50 then CheckBoxClrBC.Enabled:=False
    else CheckBoxClrBC.Enabled:=True;
   end;
   nBootCore: begin
    CheckBoxBcorePr.Enabled:=False;
    MaskEditAddr.Enabled:=False;
    MaskEditSize.Enabled:=False;
    CheckBoxBkEEP.Enabled:=False;
    CheckBoxPrFacEEP.Enabled:=False;
    if Model=MA50 then CheckBoxClrBC.Enabled:=False
    else CheckBoxClrBC.Enabled:=True;
    if CheckBoxClrBC.Checked and CheckBoxClrBC.Enabled then CheckBoxReCalcKeys.Enabled:=False
    else CheckBoxReCalcKeys.Enabled:=True;
   end;
   nEEPROM: begin
    CheckBoxBcorePr.Enabled:=False;
    MaskEditAddr.Enabled:=False;
    MaskEditSize.Enabled:=False;
    CheckBoxReCalcKeys.Enabled:=True;
    CheckBoxBkEEP.Enabled:=True;
    CheckBoxPrFacEEP.Enabled:=True;
    CheckBoxClrBC.Enabled:=False;
   end;
   nLGPack, nT9, nEE_FS, nFFS, nFFS_B, nFFS_C: begin
    CheckBoxBcorePr.Enabled:=False;
    MaskEditAddr.Enabled:=False;
    MaskEditSize.Enabled:=False;
    CheckBoxReCalcKeys.Enabled:=False;
    CheckBoxBkEEP.Enabled:=False;
    CheckBoxPrFacEEP.Enabled:=False;
    CheckBoxClrBC.Enabled:=False;
   end;
   nManual: begin
    CheckBoxBcorePr.Enabled:=True;
    MaskEditAddr.Enabled:=True;
    MaskEditSize.Enabled:=True;
    CheckBoxReCalcKeys.Enabled:=True;
    CheckBoxBkEEP.Enabled:=True;
    CheckBoxPrFacEEP.Enabled:=True;
    if Model=MA50 then CheckBoxClrBC.Enabled:=False
    else CheckBoxClrBC.Enabled:=True;
//    CheckBoxClrBC.Enabled:=True;
   end;
 end;
 GroupBoxFManual.Caption:=RadioGroupFlash.Items.Strings[RadioGroupFlash.ItemIndex];
 if RadioGroupFlash.ItemIndex < nManual then begin
  if TabFlash[Model][(RadioGroupFlash.ItemIndex shl 1)+1] <> 0 then begin
   MaskEditAddr.Text:= IntToHex(TabFlash[Model][RadioGroupFlash.ItemIndex shl 1] shr 16,2);
   MaskEditSize.Text:= IntToHex(TabFlash[Model][(RadioGroupFlash.ItemIndex shl 1)+1] shr 16,3);
  end
  else begin
   MaskEditAddr.Text:= '  ';
   MaskEditSize.Text:= '   ';
  end;
 end;
end;

procedure TFormMain.RadioGroupFlashClick(Sender: TObject);
begin
 ShowTabFlash;
end;

procedure TFormMain.RadioGroupTelTypeClick(Sender: TObject);
begin
 Model:=RadioGroupTelType.ItemIndex;
 ShowTabFlash;
end;

procedure TFormMain.CheckBoxUseOTPImeiClick(Sender: TObject);
begin
  if CheckBoxUseOTPImei.Checked then CheckBoxExtIMEI.Checked:=False;
end;

procedure TFormMain.CheckBoxSaveSecBlkOTPClick(Sender: TObject);
begin
  if CheckBoxSaveSecBlkOTP.Checked then  CheckBoxSaveSecBlkEEP.Checked:=False;
end;

procedure TFormMain.CheckBoxSaveSecBlkEEPClick(Sender: TObject);
begin
  if CheckBoxSaveSecBlkEEP.Checked then  CheckBoxSaveSecBlkOTP.Checked:=False;
end;

function TFormMain.PingBFB : boolean;
var
i : integer;
b : byte;
begin
      result:=False;
      i:=0;
      FSN:=0;
      iComBaud:=115200;
      if RadioGroupBaud.ItemIndex=0 then iComBaud:=57600;
      ProgressBar.Position:=0;
      iComNum := RadioGroupComPort.ItemIndex+1;
      if ComOpen then begin
       Sleep(100);
       SetComRxTimeouts(50,2,200);
       ProgressBar.StepBy(10);
       while(i<2) do begin
//        SetComRxTimeouts(200,2,200);
        if not BFB_Ping then begin
         ProgressBar.StepBy(10);
         BFB_SendAT('AT^SBFB=1'+#13);
         SetComRxTimeouts(200,2,200);
         while ReadCom(@b,1) do;
         SetComRxTimeouts(50,2,200);
         ProgressBar.StepBy(10);
         if BFB_Ping or BFB_Ping then begin
          SetComRxTimeouts(200,2,200);
          if RadioGroupBaud.ItemIndex<>0 then begin
           if dcb.BaudRate<>115200 then
            if SetSpeedBFB(115200) then iComBaud:=115200;
          end
          else if dcb.BaudRate<>57600 then
            if SetSpeedBFB(57600) then iComBaud:=57600;
          result:=True;
          exit;
         end;
        end // if not BFB_Ping
        else begin
         SetComRxTimeouts(200,2,200);
         if RadioGroupBaud.ItemIndex<>0 then begin
          if dcb.BaudRate<>115200 then
           if SetSpeedBFB(115200) then iComBaud:=115200;
         end;
         result:=True;
         exit;
        end;
        if i=0 then if RadioGroupBaud.ItemIndex<>0 then ChangeComSpeed(57600)
        else ChangeComSpeed(115200);
        inc(i);
       end;
       AddLinesLog('No Ping mobile');
       ComClose;
      end
      else AddLinesLog('No open Com'+IntToStr(iComNum)+'!');
end;

function TFormMain.BFB_Write_EEP_block(flgok : boolean; num,ver,len : dword ; var buf : array of byte): boolean;
begin
        result:=False;
        SetComRxTimeouts(700,2,700);
        if Not BFB_EE_Create_Block(num,len,ver) then begin
         if BFB_Error=ERR_BFB_EEPFREE then begin
          AddLinesLog('Not create block '+Int2Digs(num,4)+'!');
          AddLinesLog('Buffer EEPROM full! Use Defrag EEPROM!');
          exit;
         end;
         AddLinesLog('Not create block '+Int2Digs(num,4)+'! Retry...');
         if Not BFB_EE_Del_block(num) then begin
          AddLinesLog('Not delete block '+Int2Digs(num,4)+'!');
         end;
         if Not BFB_EE_Create_Block(num,len,ver) then begin
          AddLinesLog('Not create block '+Int2Digs(num,4)+'!');
          if BFB_Error=ERR_BFB_EEPFREE then begin
           AddLinesLog('Buffer EEPROM full! Use Defrag EEPROM!');
          end;
          exit;
         end;
        end;
        if Not BFB_EE_Write_Block(num,0,len,buf[0]) then begin
         if Not BFB_EE_Write_Block(num,0,len,buf[0]) then begin
          AddLinesLog('Not write block '+Int2Digs(num,4)+'!');
          if BFB_Error=ERR_BFB_EEPFREE then begin
           AddLinesLog('Buffer EEPROM full! Use Defrag EEPROM!');
          end;
          exit;
         end;
        end;
        if Not BFB_EE_Finish_Block(num) then begin
         if Not BFB_EE_Finish_Block(num) then begin
          AddLinesLog('Not terminate block '+Int2Digs(num,4)+'!');
          if BFB_Error=ERR_BFB_EEPFREE then begin
           AddLinesLog('Buffer EEPROM full! Use Defrag EEPROM!');
          end;
          exit;
         end;
        end;
        if flgok then AddLinesLog('Write block '+Int2Digs(num,4)+' - Ok.');
        result:=True;
end;
procedure TFormMain.ButtonSimSimClick(Sender: TObject);
//var
//a,b,c : dword;
begin
      ButtonSimSim.Enabled:=False;
      PanelMain.Enabled:=False;
      if PingBFB then begin
{
       BFB_EELITE_GetBufferInfo(a,b,c);
       AddLinesLog(IntToStr(a)+', '+IntToStr(b)+', '+IntToStr(c));
       BFB_EEFULL_GetBufferInfo(a,b,c);
       AddLinesLog(IntToStr(a)+', '+IntToStr(b)+', '+IntToStr(c));
       BFB_EELITE_MaxIndexBlk(a);
       AddLinesLog(IntToStr(a));
       BFB_EEFULL_MaxIndexBlk(a);
       AddLinesLog(IntToStr(a));
       if Not BFB_EE_Read_Block(5121,0,SizeOf(EEP5121),EEP5121[0]) then begin
         AddLinesLog('Not read block 5121!');
         ComClose;
       end else begin
        if Not BFB_EE_Create_Block(5121,SizeOf(EEP5121),0) then begin
         AddLinesLog('Not create block 5121!');
        end;
        if Not BFB_EE_Write_Block(5121,0,SizeOf(EEP5121),EEP5121[0]) then begin
         AddLinesLog('Not write block 5121!');
        end;
        if Not BFB_EE_Finish_Block(5121) then begin
         AddLinesLog('Not terminate block 5121!');
        end;
       end;
}
       if BFB_SimulateChipCard then AddLinesLog('Simulate Chip Card - Ok!')
       else AddLinesLog('Error SimulateChipCard command!');

       ProgressBar.Position:=100;
       ComClose;
      end;
      PanelMain.Enabled:=True;
      ButtonSimSim.Enabled:=True;
end;

procedure TFormMain.ButtonPhoneOffClick(Sender: TObject);
begin
      ButtonPhoneOff.Enabled:=False;
      ButtonPhoneOff1.Enabled:=False;
      ButtonPhoneOff2.Enabled:=False;
      PanelMain.Enabled:=False;
      if PingBFB then begin
       if BFB_PhoneOff then AddLinesLog('Phone off...')
       else AddLinesLog('Error Phone off command!');
       ProgressBar.Position:=100;
       ComClose;
      end;
      PanelMain.Enabled:=True;
      ButtonPhoneOff.Enabled:=True;
      ButtonPhoneOff1.Enabled:=True;
      ButtonPhoneOff2.Enabled:=True;
end;

procedure TFormMain.ButtonPhoneOnClick(Sender: TObject);
begin
      iComBaud:=57600;
      ProgressBar.Position:=0;
      iComNum := RadioGroupComPort.ItemIndex+1;
      if ComOpen then begin
       ProgressBar.StepBy(10);
       sleep(500);
       if CmdBFB($05,[$06,$0C],2)=BFB_OK then AddLinesLog('Phone On...')
       else AddLinesLog('Error PhoneOn command!');
       ComClose;
      end
      else AddLinesLog('No open Com'+IntToStr(iComNum)+'!');
end;

procedure TFormMain.ButtonSrvmClick(Sender: TObject);
begin
    if flgBootLoad then begin
       AddLinesLog('Cancel.');
       Sleep(200);
       if not BFB_PhoneOff then begin
        if dcb.BaudRate=57600 then ChangeComSpeed(115200)
        else if dcb.BaudRate=115200 then ChangeComSpeed(57600);
        if BFB_PhoneOff then AddLinesLog('Phone Off.');
       end
       else AddLinesLog('Phone Off.');
       Stop;
       exit;
    end;
    AllKeyDisable;
    ButtonSrvm.Caption :='Cancel';
    ButtonSrvm1.Caption :='Cancel';
    ButtonSrvm2.Caption :='Cancel';
    ButtonSrvm.Enabled:=True;
    ButtonSrvm1.Enabled:=True;
    ButtonSrvm2.Enabled:=True;
    if StartServiceMode($07) then InfoBFB;
    Terminate;
    ProgressBar.Position:=100;
end;

function TFormMain.SaveNewSecBlocks: boolean;
var
s : string;
i : integer;
begin
           result:=False;
           for i:=0 to 5 do Mkey[i]:=IniFile.ReadInteger(IMEI,'Mkey'+IntToStr(i),IniFile.ReadInteger('System','Mkey'+IntToStr(i),12345678));
           Create5077(IMEI,FSN,EEP5077,CryptModel);
           Create5008(IMEI,FSN,EEP5008,CryptModel);
           Create5009(IMEI,EEP5009,CryptModel);
           Create76(IMEI,EEP0076,CryptModel);
           Create512x(IMEI,FSN,Skey,Mkey);
           ClearEEPBufAndTab;
           AddEEPBlk(0076,0,SizeOf(EEP0076),EEP0076[0]);
           AddEEPBlk(5008,0,SizeOf(EEP5008),EEP5008[0]);
           AddEEPBlk(5009,0,SizeOf(EEP5009),EEP5009[0]);
           AddEEPBlk(5077,0,SizeOf(EEP5077),EEP5077[0]);
           AddEEPBlk(5121,0,SizeOf(EEP5121),EEP5121[0]);
           AddEEPBlk(5122,0,SizeOf(EEP5122),EEP5122[0]);
           AddEEPBlk(5123,0,12,EEP5123[0]);
           s:=GreateFileNameBackup('NewSec')+'.eep';
           if SaveAllEEP(s,HWID) then begin
            AddLinesLog('Use Master keys in New Security blocks:');
            AddLinesLog('*#0000*'+Int2Digs(Mkey[0],8)+'# - Network Lock');
            AddLinesLog('*#0001*'+Int2Digs(Mkey[1],8)+'# - Service Provider Lock');
            AddLinesLog('*#0002*'+Int2Digs(Mkey[2],8)+'# - Corporate Code');
            AddLinesLog('*#0003*'+Int2Digs(Mkey[3],8)+'# - Phone Code');
            AddLinesLog('*#0004*'+Int2Digs(Mkey[4],8)+'# - Network Subset Lock');
            AddLinesLog('*#0005*'+Int2Digs(Mkey[5],8)+'# - Only Sim');
            AddLinesLog('New Security Blocks saved in "'+s+'" file.');
            result:=True;
           end
           else AddLinesLog(sEep_Err);
end;

procedure TFormMain.ButtonRdKeysClick(Sender: TObject);
var
HashAddr : dword;
begin
      if flgBootLoad then begin
       PanelMain.Enabled:=True;
       ButtonRdKeys.Enabled:=True;
       ButtonRdKeys.Caption:='Read and Calc Keys';
       AddLinesLog('Cancel.');
       flgBootLoad:=False;
       exit;
      end;
      ButtonRdKeys.Enabled:=False;
      PanelMain.Enabled:=False;
      AddLinesLog('Read Keys...');
      if PingBFB and BFB_GetHWID(HWID) then begin
       HashAddr:=$800330;
       CryptModel:=C55;
       if (HWID=HW_A50) then begin
        HashAddr:=$80032E;
        CryptModel:=A50;
       end;
       if TestSecurityMode then
       if not BFBReadMem(HashAddr,16,HASH[0]) then begin
        AddLinesLog('Not read HASH!');
//        ComClose;
//        exit;
       end else
       if not BFB_GetESN(FSN) then begin
        AddLinesLog('Not read FSN!');
//        ComClose;
//        exit;
       end else begin
        if CheckBoxSrvCreateBlk.Checked then ReadHWID;
        IMEI:=BFB_GetImei;
        if BFB_Error<>BFB_OK then begin
         AddLinesLog('Not read IMEI!');
//         ComClose;
//         exit;
        end
        else begin
         if not CheckBoxSrvCreateBlk.Checked then ComClose;
         AddLinesLog('IMEI: '+IMEI);
//         EditJImei.Text:=IMEI;
         AddLinesLog('FSN: '+IntToHex(FSN,8));
         AddLinesLog('HASH: '+BufToHexStr(@HASH[0],16));
//         ReadIniImeiKeys;
         ButtonRdKeys.Caption:='Cancel';
         PanelMain.Enabled:=True;
         ButtonRdKeys.Enabled:=True;
         flgBootLoad:=True;
         if TestAndCalcSkey then begin
          if CheckBoxSrvCreateBlk.Checked then SaveNewSecBlocks;
//          AddLinesLog('BOOTKEY: '+BufToHexStr(@BootKey[0],16));
//          AddLinesLog('SKEY: '+IntToStr(SKEY));
          if CheckBoxSrvCreateBlk.Checked then begin
           if MessageDlg('To write EEPROM blocks 76,5008,5009,5077,5121,5122,5123 in the phone?',mtConfirmation, [mbYes, mbNo], 0) = mrYes
           then begin
            if BFB_Write_EEP_block(True,0076,0,SizeOf(EEP0076),EEP0076[0])
            and BFB_Write_EEP_block(True,5008,0,SizeOf(EEP5008),EEP5008[0])
            and BFB_Write_EEP_block(True,5009,0,SizeOf(EEP5009),EEP5009[0])
            and BFB_Write_EEP_block(True,5077,0,SizeOf(EEP5077),EEP5077[0])
            and BFB_Write_EEP_block(True,5121,0,SizeOf(EEP5121),EEP5121[0])
            and BFB_Write_EEP_block(True,5122,0,SizeOf(EEP5122),EEP5122[0])
            and BFB_Write_EEP_block(True,5123,0,12,EEP5123[0]) then
            AddLinesLog('Blocks write - Ok.')
            else beep;
           end;
          end;
          ComClose;
          ProgressBar.Position:=100;
         end
         else AddLinesLog('Skey not found! HASH incorrect for this phone!');
//         else AddLinesLog('Skey not found!');
         PanelMain.Enabled:=False;
         ButtonRdKeys.Enabled:=False;
         ButtonRdKeys.Caption:='Read and Calc Keys';
         flgBootLoad:=False;
        end;
       end; // if BFB_GetESN(FSN)
//       ProgressBar.Position:=100;
       ComClose;
      end;
      PanelMain.Enabled:=True;
      ButtonRdKeys.Enabled:=True;
end;

function TFormMain.CalcMasterKeys : boolean;
var
i,x,y : integer;
Mkeys: array[0..5] of dword;
begin
     result:=False;
     ProgressBar.Position:=0;
     AddLinesLog('Compare default and saved MasterKeys...');
     for i:=0 to 5 do Mkey[i]:=IniFile.ReadInteger(IMEI,'Mkey'+IntToStr(i),IniFile.ReadInteger('System','Mkey'+IntToStr(i),12345678));
     for i:=0 to 5 do begin
      Mkeys[i]:=$FFFFFFFF;
      StartCalc5121mkeys(IMEI,FSN,MKey[i]);
      StepCalc5121mkeys(@EEP5121[8],Mkeys);
     end;
     StartCalc5121mkeys(IMEI,FSN,12345678);
     StepCalc5121mkeys(@EEP5121[8],Mkeys);
     StartCalc5121mkeys(IMEI,FSN,0);
     StepCalc5121mkeys(@EEP5121[8],Mkeys);
     i:=99999;
     x:=99;
     y:=0;
     Application.ProcessMessages;
     if (Not flgBootLoad) or flgBFBExit then exit;
//     AddLinesLog('Calculation from 00000001 up to 0999999...');
     while not StepCalc5121mkeys(@EEP5121[8],Mkeys) do begin
      inc(i);
      if i>=100000 then begin
       inc(x);
       ProgressBar.Position:=x;
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then exit;
       if x >=100 then begin
        x:=0;
        AddLinesLog('Calculation from '+IntToStr(y)+'0000000 up to '+IntToStr(y)+'9999999...');
        inc(y);
        if y>10 then break;
       end;
       i:=0;
      end;
     end;
     if Mkeys[0]<>$FFFFFFFF then
      AddLinesLog('*#0000*'+Int2Digs(Mkeys[0],8)+'# - Network Lock')
     else
      AddLinesLog('*#0000*????????# - Network Lock');
     if Mkeys[1]<>$FFFFFFFF then
      AddLinesLog('*#0001*'+Int2Digs(Mkeys[1],8)+'# - Service Provider Lock')
     else
      AddLinesLog('*#0001*????????# - Service Provider Lock');
     if Mkeys[2]<>$FFFFFFFF then
      AddLinesLog('*#0002*'+Int2Digs(Mkeys[2],8)+'# - Corporate Code')
     else
      AddLinesLog('*#0002*????????# - Corporate Code');
     if Mkeys[3]<>$FFFFFFFF then
      AddLinesLog('*#0003*'+Int2Digs(Mkeys[3],8)+'# - Phone Code')
     else
      AddLinesLog('*#0003*????????# - Phone Code');
     if Mkeys[4]<>$FFFFFFFF then
      AddLinesLog('*#0004*'+Int2Digs(Mkeys[4],8)+'# - Network Subset Lock')
     else
      AddLinesLog('*#0004*????????# - Network Subset Lock');
     if Mkeys[5]<>$FFFFFFFF then
      AddLinesLog('*#0005*'+Int2Digs(Mkeys[5],8)+'# - Only Sim')
     else
      AddLinesLog('*#0005*????????# - Only Sim');
//     end;
     for i:=0 to 5 do IniFile.WriteInteger(IMEI,'Mkey'+IntToStr(i),Mkeys[i]);
     ProgressBar.Position:=100;
     result:=True;
end;

procedure TFormMain.ButtonMasterKeysClick(Sender: TObject);
//var
//buf : array[0..55] of byte;
//ver : byte;
//len : dword;
begin
      if flgBootLoad then begin
       ButtonMasterKeys.Caption:='5121 Master Keys';
       PanelMain.Enabled:=True;
       ButtonMasterKeys.Enabled:=True;
       AddLinesLog('Cancel.');
       flgBootLoad:=False;
       exit;
      end;
      ButtonMasterKeys.Enabled:=False;
      PanelMain.Enabled:=False;
      AddLinesLog('Read Keys...');
      if PingBFB then begin
       if TestSecurityMode then begin
        if not BFB_GetESN(FSN) then begin
         AddLinesLog('Not read HASH!');
         ComClose;
        end else begin
         IMEI:=BFB_GetImei;
         if BFB_Error<>BFB_OK then begin
          AddLinesLog('Not read IMEI!');
          ComClose;
         end else
         if Not BFB_EE_Read_Block(5121,0,SizeOf(EEP5121),EEP5121[0]) then begin
          AddLinesLog('Not Read block 5121!');
          ComClose;
         end
         else begin
          ComClose;
          AddLinesLog('IMEI: '+IMEI);
//          EditJImei.Text:=IMEI;
          AddLinesLog('FSN: '+IntToHex(FSN,8));
          ButtonMasterKeys.Caption:='Cancel';
          PanelMain.Enabled:=True;
          ButtonMasterKeys.Enabled:=True;
          flgBootLoad:=True;
          CalcMasterKeys;
          flgBootLoad:=False;
         end;
        end;
       end;
       ComClose;
      end;
      ButtonMasterKeys.Caption:='5121 Master Keys';
      PanelMain.Enabled:=True;
      ButtonMasterKeys.Enabled:=True;
end;

function tCRCBuffer(var Block : array of byte; BlockSize : integer): word;
var
   i : integer;
   c1, c2 : byte;
begin
   c1 := 0; c2 := 0;
   for i := 0 to BlockSize - 1 do begin
      c1 := c1 + Block[i];
      c2 := c2 xor Block[i];
   end; { for }
   result:= c1 or (c2 shl 8);
//   Block[BlockSize] := c1;
//   Block[BlockSize + 1] := c2;
end;

procedure TFormMain.Test5008;
var
len : integer;
b, ver : byte;
s,op1,op2 : string;
i : integer;
xflg : integer;
begin
         xflg:=0;
         IMEI2xBCD(IMEI);
         if BFB_EE_Get_Block_Info(5008,dword(len),ver) then begin
          ProgressBar.StepBy(5);
          if (len=224) then begin
           if BFB_EE_Read_Block(5008,0,224,EEP5008) then begin
            ProgressBar.StepBy(5);
            DeCrypt5008blk(FSN,EEP5008);
            if debug then begin
             AddLinesLog('EEP5008:');
             AddLinesLog(BufToHex_Str(@EEP5008,8));
             AddLinesLog(BufToHex_Str(@EEP5008[8],24));
             AddLinesLog(BufToHex_Str(@EEP5008[32],8));
             AddLinesLog(BufToHex_Str(@EEP5008[40],176));
             AddLinesLog(BufToHex_Str(@EEP5008[216],8));
            end;
            if word((@EEP5008[30])^)<>tCRCBuffer(EEP5008[8],22) then begin
             AddLinesLog('Incorrect block 5008! CRC1: '+IntToHex(tCRCBuffer(EEP5008[8],22),4)+'<>'+IntToHex(word((@EEP5008[30])^),4));
             ComClose;
             exit;
            end;
            if word((@EEP5008[216])^)<>tCRCBuffer(EEP5008[40],176) then begin
             AddLinesLog('Incorrect block 5008! CRC2: '+IntToHex(tCRCBuffer(EEP5008[40],176),4)+'<>'+IntToHex(word((@EEP5008[216])^),4));
             ComClose;
             exit;
            end;
            if (EEP5008[10]<>0) // NETWORK LOCK (*#0000*)
            or (EEP5008[15]<>0) // Service Provider Lock (SP Lock) (*#0001*)
//            or (EEP5008[17]<>0) // CORPORATE LOCK (*#0002*)
            or (EEP5008[12]<>0) // SUBSET LOCK (*#0004*)
//            or (EEP5008[8]<>0)  // ONLY SIM (*#0005*)
            then begin
             op1:='';
             i:=43;
             while(i<45) do begin
              if (EEP5008[i] and $0F)=$0F then break;
               op1:=op1+Char((EEP5008[i] and $0F)+$30);
              if (EEP5008[i] and $F0)=$F0 then break;
               op1:=op1+Char((EEP5008[i] shr 4) +$30);
              inc(i);
             end;
             if (EEP5008[45] and $0F)<>$0F then begin
              op1:=op1+'-'+Char((EEP5008[45] and $0F)+$30);
              if (EEP5008[45] and $F0)<>$F0 then op1:=op1+Char((EEP5008[45] shr 4) +$30);
              op2:=op2+', SPI:'+IntToStr(EEP5008[47])+', IMSI[12]:'+IntToHex(EEP5008[46],2);
             end;
             op2:='';
             i:=49;
             while(i<51) do begin
              if (EEP5008[i] and $0F)=$0F then break;
               op2:=op2+Char((EEP5008[i] and $0F)+$30);
              if (EEP5008[i] and $F0)=$F0 then break;
               op2:=op2+Char((EEP5008[i] shr 4) +$30);
              inc(i);
             end;
             if (EEP5008[51] and $0F)<>$0F then begin
              op2:=op2+'-'+Char((EEP5008[51] and $0F)+$30);
              if (EEP5008[51] and $F0)<>$F0 then op2:=op2+Char((EEP5008[51] shr 4) +$30);
              op2:=op2+', SPI:'+IntToStr(EEP5008[53])+', IMSI[12]:'+IntToHex(EEP5008[52],2);
             end;
             AddLinesLog('Operator1: '+op1);
             AddLinesLog('Operator2: '+op2);
            end;

            if (EEP5008[10]<>0) then begin // NETWORK LOCK (*#0000*)
             xflg:=xflg or 1;
             AddLinesLog('Network Lock (*#0000*):');
             if (EEP5008[43] and $0F)<>$0F then AddLinesLog('Operator1: '+op1);
             if (EEP5008[49] and $0F)<>$0F then AddLinesLog('Operator2: '+op2);
             Case (EEP5008[11] and 3) of
//              00: AddLinesLog('Есть три попытки ввода пароля.');
              01: AddLinesLog('There are two attempts to enter this key.');
              02: AddLinesLog('There is one attempt to enter this key.');
              03: AddLinesLog('This key is blocked: three attempts of enter of an incorrect key.');
             end;
             b:= EEP5008[11] shr 2;
             Case b of
              00 : AddLinesLog('This "Master Code" is not entered.');
              63 : AddLinesLog('This "Master Code" is locked!');
              else AddLinesLog('Incorrects entered the "Master Code": '+IntToStr(b)+'times.');
             end;
            end;

            if (EEP5008[15]<>0) then begin // Service Provider Lock (SP Lock) (*#0001*)
             xflg:=xflg or 2;
             AddLinesLog('Service Provider Lock (*#0001*):');
             if (EEP5008[43] and $0F)<>$0F then AddLinesLog('Operator1: '+op1);
             if (EEP5008[49] and $0F)<>$0F then AddLinesLog('Operator2: '+op2);
             Case (EEP5008[16] and 3) of
//              00: AddLinesLog('Есть три попытки ввода пароля.');
              01: AddLinesLog('There are two attempts to enter this key.');
              02: AddLinesLog('There is one attempt to enter this key.');
              03: AddLinesLog('This key is blocked: three attempts of enter of an incorrect key.');
             end;
             b:= EEP5008[16] shr 2;
             Case b of
              00 : AddLinesLog('This "Master Code" is not entered.');
              63 : AddLinesLog('This "Master Code" is locked!');
              else AddLinesLog('Incorrects entered the "Master Code": '+IntToStr(b)+'times.');
             end;
            end;

            if (EEP5008[17]<>0)  then begin // CORPORATE LOCK (*#0002*)
             xflg:=xflg or 4;
             AddLinesLog('Corporate Lock (*#0002*):');
             Case (EEP5008[18] and 3) of
//              00: AddLinesLog('Есть три попытки ввода пароля.');
              01: AddLinesLog('There are two attempts to enter this key.');
              02: AddLinesLog('There is one attempt to enter this key.');
              03: AddLinesLog('This key is blocked: three attempts of enter of an incorrect key.');
             end;
             b:= EEP5008[18] shr 2;
             Case b of
              00 : AddLinesLog('This "Master Code" is not entered.');
              63 : AddLinesLog('This "Master Code" is locked!');
              else AddLinesLog('Incorrects entered the "Master Code": '+IntToStr(b)+'times.');
             end;
            end;

            if (EEP5008[12]<>0) then begin // SUBSET LOCK (*#0004*)
             xflg:=xflg or 8;
             AddLinesLog('Subset Lock (*#0004*):');
             if (EEP5008[43] and $0F)<>$0F then AddLinesLog('Оператор1: '+op1);
             if (EEP5008[49] and $0F)<>$0F then AddLinesLog('Оператор2: '+op2);
             Case (EEP5008[13] and 3) of
//              00: AddLinesLog('Есть три попытки ввода пароля.');
              01: AddLinesLog('There are two attempts to enter this key.');
              02: AddLinesLog('There is one attempt to enter this key.');
              03: AddLinesLog('This key is blocked: three attempts of enter of an incorrect key.');
             end;
             b:= EEP5008[13] shr 2;
             Case b of
              00 : AddLinesLog('This "Master Code" is not entered.');
              63 : AddLinesLog('This "Master Code" is locked!');
              else AddLinesLog('Incorrects entered the "Master Code": '+IntToStr(b)+'times.');
             end;
            end;

            if (EEP5008[8]<>0)  then begin  // ONLY SIM (*#0005*)
             xflg:=xflg or $10;
             AddLinesLog('Only Sim Lock (*#0005*):');
             AddLinesLog('SIM CARD ID: '+BufToHexStr(@EEP5008[8+24+8],3));
             Case (EEP5008[9] and 3) of
//              00: AddLinesLog('Есть три попытки ввода пароля.');
//              00: AddLinesLog('There are three attempts attempts to enter key.');
              01: AddLinesLog('There are two attempts to enter this key.');
              02: AddLinesLog('There is one attempt to enter this key.');
              03: AddLinesLog('This key is blocked: three attempts of enter of an incorrect key.');
             end;
             b:= EEP5008[9] shr 2;
             Case b of
              00 : AddLinesLog('This "Master Code" is not entered.');
              63 : AddLinesLog('This "Master Code" is locked!');
              else AddLinesLog('Incorrects entered the "Master Code": '+IntToStr(b)+'times.');
             end;
            end;

            if (EEP5008[22] and $0F)=$0F then begin
             AddLinesLog('"Phone code" is not entered.');
            end
            else begin
             s:='';
             for i:=22 to 25 do begin
              if (EEP5008[i] and $0F)=$0F then break;
               s:=s+Char((EEP5008[i] and $0F)+$30);
              if (EEP5008[i] and $F0)=$F0 then break;
              s:=s+Char((EEP5008[i] shr 4) +$30);
             end;
             AddLinesLog('"Phone code": '+s);
             xflg:=xflg or $80;
             Case (EEP5008[19] and 3) of
              00: AddLinesLog('There are three attempts to enter "PhoneCode".');
              01: AddLinesLog('There are two attempts to enter "PhoneCode".');
              02: AddLinesLog('There is one attempt to enter "PhoneCode".');
              03: AddLinesLog('"PhoneCode" is blocked: three attempts of enter incorrect "PhoneCode".');
             end;
            end;
            if EEP5008[19]<>0 then xflg:=xflg or $80;
            if EEP5008[20] <> $FF then begin
             xflg:=xflg or $20;
             if (EEP5008[20] and 1)=0 then AddLinesLog('The option "Only this SIM" is switched on. SIM CARD ID:'+BufToHexStr(@EEP5008[8+24+8],3));
             if (EEP5008[20] and 4)=0 then AddLinesLog('The option "Only last 10 collected numbers" is switched on');
             if (EEP5008[20] and $FA)<>$FA then AddLinesLog('The unknowns of an option of locking are switched on!');
            end;
            if (xflg<>0)
            or (Dword((@EEP5008[8])^)<>$00000300)
            or (Dword((@EEP5008[12])^)<>$00670000)
            or (Dword((@EEP5008[16])^)<>$00000000)
            or (EEP5008[20]<>$FF)
            or (Not((EEP5008[21]=$FF) or (EEP5008[21]=$00)))
            or (word((@EEP5008[22])^)<>$FFFF)
            or (Dword((@EEP5008[24])^)<>$FFFFFFFF)
            or (word((@EEP5008[28])^)<>$FF00)
            then begin
             if (xflg=0) then AddLinesLog('Incorrect data in block!');
             if MessageDlg('Reset the password and locks?', mtConfirmation, [mbYes, mbNo], 0) = mrYes
             then begin
              ClearEEPBufAndTab;
              AddEEPBlk(5008,ver,len,EEP5008[0]);
              s:=GreateFileNameBackup('_5008_')+'.eep';
              if SaveAllEEP(s,HWID) then begin
               AddLinesLog('EEP5008 block is written in "'+s+ '" file.');
              end
              else AddLinesLog(sEep_Err);
              ProgressBar.StepBy(15);
              Dword((@EEP5008[8])^):=$00000300;
              Dword((@EEP5008[12])^):=$00670000;
              Dword((@EEP5008[16])^):=$00000000;
              Dword((@EEP5008[20])^):=$FFFFFFFF;
              Dword((@EEP5008[24])^):=$FFFFFFFF;
              word((@EEP5008[28])^):=$FF00;
              CRCBuffer(EEP5008[8],22);
              Crypt5008blk(FSN,EEP5008);
              if BFB_Write_EEP_block(True,5008,0,sizeof(EEP5008),EEP5008) then
               ProgressBar.Position:=100
              else beep;
             end
             else ProgressBar.Position:=100;
            end else begin
             AddLinesLog('No lockings.');
             ProgressBar.Position:=100; // if (локи)
            end;
           end // if BFC_EE_Read_Block
           else begin
            AddLinesLog('Not read block 5008!');
           end;
          end // if len<>224
          else begin
//          AddLinesLog('len = '+IntToStr(len));
           AddLinesLog('('+IntToStr(len)+'<>224) Incorrect block length 5008!');
          end;
         end // if BFC_EE_Get_Block_Info
         else begin
          AddLinesLog('The block 5008 misses!');
         end; // if BFC_EE_Read_Block
end;

procedure TFormMain.ButtonPhoneCodeClick(Sender: TObject);
begin
      ButtonPhoneCode.Enabled:=False;
      PanelMain.Enabled:=False;
      AddLinesLog('Read Info...');
      if PingBFB then begin
       ProgressBar.Position:=10;
       CreateFileMobileName;
       ProgressBar.StepBy(15);
       if TestSecurityMode then begin
        ProgressBar.StepBy(15);
        if not BFB_GetESN(FSN) then begin
         AddLinesLog('Not read FSN!');
        end else begin
         IMEI:=BFB_GetImei;
         ProgressBar.StepBy(15);
         if BFB_Error<>BFB_OK then begin
          AddLinesLog('Not read IMEI!');
         end
         else begin
          AddLinesLog('IMEI: '+IMEI);
//          EditJImei.Text:=IMEI;
          AddLinesLog('FSN: '+IntToHex(FSN,8));
          Test5008;
         end;
        end;
       end;
       ComClose;
      end;
      PanelMain.Enabled:=True;
      ButtonPhoneCode.Enabled:=True;
end;

procedure TFormMain.ButtonDelInstClick(Sender: TObject);
var
num : byte;
CfgInst : integer;
begin
      ButtonDelInst.Enabled:=False;
      PanelMain.Enabled:=False;
      AddLinesLog('Instance Format...');
      CfgInst := IniFile.ReadInteger('Setup','DelInstance',$3f);
      with FormDeleteInstance do begin
       CheckBoxIF1.Checked:=(CfgInst and 1)<>0;
       CheckBoxIF2.Checked:=(CfgInst and 2)<>0;
       CheckBoxIF3.Checked:=(CfgInst and 4)<>0;
       CheckBoxIF4.Checked:=(CfgInst and 8)<>0;
       CheckBoxIF5.Checked:=(CfgInst and 16)<>0;
       CheckBoxIF6.Checked:=(CfgInst and 32)<>0;
      end;
      if PingBFB then begin
       ProgressBar.Position:=10;
       FormDeleteInstance.Top := Top+260;
       FormDeleteInstance.Left := Left+180;
       if FormDeleteInstance.ShowModal=mrOK then begin
        CfgInst:=0;
        with FormDeleteInstance do begin
         if CheckBoxIF1.Checked then CfgInst:=CfgInst or 1;
         if CheckBoxIF2.Checked then CfgInst:=CfgInst or 2;
         if CheckBoxIF3.Checked then CfgInst:=CfgInst or 4;
         if CheckBoxIF4.Checked then CfgInst:=CfgInst or 8;
         if CheckBoxIF5.Checked then CfgInst:=CfgInst or 16;
         if CheckBoxIF6.Checked then CfgInst:=CfgInst or 32;
        end;
        IniFile.WriteInteger('Setup','DelInstance',CfgInst);
        if CfgInst<>0 then begin
         num:=0;
         while CfgInst<>0 do begin
          if (CfgInst and 1)<>0 then begin
           if BFB_DeleteInstance(num) then begin
            AddLinesLog('Delete Instance "'+sInstanceNames[num]+'" - Ok.');
           end
           else AddLinesLog('Delete Instance "'+sInstanceNames[num]+'" - None.');
          end;
          CfgInst:=CfgInst shr 1;
          num:=num+1;
          ProgressBar.StepBy(15);
         end;
         AddLinesLog('ReStart Phone!');
        end
        else AddLinesLog('Not selected Delete Instances.');
        ProgressBar.Position:=100;
       end
       else AddLinesLog('Cancel.');
      end;
      ComClose;
      PanelMain.Enabled:=True;
      ButtonDelInst.Enabled:=True;
end;

function VariantToInt(var buf: array of byte; var ch: char; var num : dword): boolean;
var
b : byte;
begin
        ch:='?';
        num:=0;
        result:=False;
        if (buf[0]>25) then exit
        else begin
         ch:=Char(buf[0]+$40);
         b := buf[1] shr 4;
         if b>$09 then exit
         else num:=b;
         b := buf[1] and $0F;
         if b>$09 then exit
         else num:=b+num*10;
         b := buf[2] shr 4;
         if b>$09 then exit
         else num:=b+num*10;
         result:=True;
        end;
end;

function VariantToBuf(var buf: array of byte; ch: char; num : integer): boolean;
var
x : integer;
b : byte;
begin
        buf[0]:=$FF;
        buf[1]:=$FF;
        buf[2]:=$FF;
        result:=False;
        if (Byte(ch)<$41) or (Byte(ch)>$5A) then exit
        else begin
         buf[0]:=Byte(ch)-$40;
         x:=num;
         if x>999 then exit;
         b := x mod 10;
         x := x div 10;
         buf[2]:=(b shl 4) or $0F;
         b := x mod 10;
         x := x div 10;
         buf[1]:=b or (byte(x) shl 4);
         result:=True;
        end;
end;

procedure TFormMain.Button5005Click(Sender: TObject);
var
i,y : dword;
len : dword;
ver : byte;
ch,vch : char;
b1,b2,b3,b4,b5,b6 : byte;
s : string;
begin
      Button5005.Enabled:=False;
      PanelMain.Enabled:=False;
      AddLinesLog('Read and edit block 5005...');
      if PingBFB then begin
       ProgressBar.Position:=10;
       CreateFileMobileName;
       ProgressBar.StepBy(15);
       if BFB_EE_Get_Block_Info(5005,len,ver) then begin
        ProgressBar.Position:=50;
        if (len<sizeof(EEP5005)) and (ver=1) then begin
         ReadHWID;
         if BFB_EE_Read_Block(5005,0,len,EEP5005) then begin
           AddLinesLog('Date: '+Int2Digs(EEP5005[$0B],2)+'/'+Int2Digs(EEP5005[$0C] shr 4,2)+'/'+Int2Digs(EEP5005[$0C] and $0F,2));
           if not VariantToInt(EEP5005[$12],ch,i)
           then AddLinesLog('Variant: ? ???') // A 370
           else AddLinesLog('Variant: '+ch+' '+Int2Digs(i,3)); // A 370
           AddLinesLog('Std-Map/SW: '+IntToStr(EEP5005[$0F])+'/'+IntToStr(EEP5005[$0E]));
           AddLinesLog('D-Map/Prov.: '+IntToStr(EEP5005[$11])+'/'+IntToStr(EEP5005[$10]));  // 153/148
           with Dlg5005 do begin
            MaskEditVarA.Text:=ch;
            SpinEditVar.Value:=i;
            SpinEditStd.Value:=EEP5005[$0F];
            SpinEditSW.Value:=EEP5005[$0E];
            SpinEditDm.Value:=EEP5005[$11];
            SpinEditPr.Value:=EEP5005[$10];
            MaskEditDate.Text:=Int2Digs(EEP5005[$0B],2)+'.'+Int2Digs(EEP5005[$0C] shr 4,2)+'.'+Int2Digs(EEP5005[$0C] and $0F,2);
           end;
           if Dlg5005.ShowModal=mrOK then begin
            with Dlg5005 do begin
              vch:=MaskEditVarA.Text[1];
              y:=SpinEditVar.Value;
//              VariantToBuf(EEP5005[$12],vch,y);
              b1:=Byte(SpinEditStd.Value);
              b2:=Byte(SpinEditSW.Value);
              b3:=Byte(SpinEditDm.Value);
              b4:=Byte(SpinEditPr.Value);
              b5:=Byte(Date_dd);
              b6:=(Date_mm shl 4) or Date_hh;
            end;
            if (vch<>ch)
            or (y<>i)
            or (b5<>EEP5005[$0B])
            or (b6<>EEP5005[$0C])
            or (b1<>EEP5005[$0F])
            or (b2<>EEP5005[$0E])
            or (b3<>EEP5005[$11])
            or (b4<>EEP5005[$10])
            then begin
             ProgressBar.Position:=60;
             if VariantToBuf(EEP5005[$12],vch,y) then begin
              ClearEEPBufAndTab;
              AddEEPBlk(5005,ver,len,EEP5005[0]);
              s:=GreateFileNameBackup('5005_')+'.eep';
              if SaveAllEEP(s,HWID) then begin
               AddLinesLog('EEP5005 block is written in "'+s+ '" file.');
              end
              else AddLinesLog(sEep_Err);
              ProgressBar.StepBy(15);
              EEP5005[$0F]:=b1;
              EEP5005[$0E]:=b2;
              EEP5005[$11]:=b3;
              EEP5005[$10]:=b4;
              EEP5005[$0B]:=b5;
              EEP5005[$0C]:=b6;
              if BFB_Write_EEP_block(True,5005,ver,len,EEP5005) then begin
               AddLinesLog('New data block:');
               AddLinesLog('P.-Date: '+Int2Digs(EEP5005[$0B],2)+'/'+Int2Digs(EEP5005[$0C] shr 4,2)+'/'+Int2Digs(EEP5005[$0C] and $0F,2));
               VariantToInt(EEP5005[$12],ch,i);
               AddLinesLog('Variant: '+ch+' '+Int2Digs(i,3)); // A 370
               AddLinesLog('Std-Map/SW: '+IntToStr(EEP5005[$0F])+'/'+IntToStr(EEP5005[$0E]));
               AddLinesLog('D-Map/Prov.: '+IntToStr(EEP5005[$11])+'/'+IntToStr(EEP5005[$10]));  // 153/148
               AddLinesLog('For exact map of data on menu *#06# -');
               AddLinesLog('ReStart Phone!');
               ProgressBar.Position:=100;
              end
              else beep;
             end
             else begin
               AddLinesLog('Insecure data in "Variant"!');
               ProgressBar.Position:=100;
             end;
            end
            else begin
             AddLinesLog('No changes of data.');
             ProgressBar.Position:=100;
            end;
           end
           else begin
             AddLinesLog('The editing of the block 5005 is cancelled.');
             ProgressBar.Position:=100;
           end;
         end
         else begin
          AddLinesLog('Read error of data of the block 5005!');
         end;
        end
        else begin
         AddLinesLog('The bad block 5005!');
        end;
       end //if BFC_EE_Get_Block_Info
       else begin
         if BFB_Error=ERR_BFB_EEPBLKNONE then
          AddLinesLog('The block 5005 misses!')
         else
          AddLinesLog('Read error of the information about the block 5005!');
       end;
//       AddLinesLog(StatusBar.Panels[PanelCmd].Text);
       ComClose;
//       ProgressBar.Position:=100;
      end;
      PanelMain.Enabled:=True;
      Button5005.Enabled:=True;
end;

procedure TFormMain.ButtonSetContrastClick(Sender: TObject);
begin
      PanelMain.Enabled:=False;
      AddLinesLog('Test Contrast '+IntToStr(ScrollBarContrast1.Position)+'...');
      if PingBFB then begin
       if not BFB_SetDisplayContrast(ScrollBarContrast1.Position) then AddLinesLog('Error!');
       ComClose;
       ProgressBar.Position:=100;
      end;
      PanelMain.Enabled:=True;
end;

procedure TFormMain.ScrollBarContrast1Change(Sender: TObject);
begin
  EEP5007[0]:=Byte(ScrollBarContrast1.Position);
//  EEP5007[1]:=EEP5007[0];
//  EEP5007[4]:=Byte(ScrollBarContrast2.Position);
//  EEP5007[6]:=EEP5007[4];
  if Len5007>=7 then LabelContrast.Caption:=IntToStr(EEP5007[0])+','+IntToStr(EEP5007[1])+' '+IntToStr(EEP5007[4])+','+IntToStr(EEP5007[6])
  else LabelContrast.Caption:=IntToStr(EEP5007[0])+','+IntToStr(EEP5007[1]);
  if hCom=INVALID_HANDLE_VALUE then begin
   OpenCom(False);
   BFB_SetDisplayContrast(ScrollBarContrast1.Position);
   CloseCom;
  end;
end;

procedure TFormMain.ScrollBarContrast2Change(Sender: TObject);
begin
//  EEP5007[0]:=Byte(ScrollBarContrast1.Position);
//  EEP5007[1]:=EEP5007[0];
  EEP5007[4]:=Byte(ScrollBarContrast2.Position);
//  EEP5007[6]:=EEP5007[4];
  if Len5007>=7 then LabelContrast.Caption:=IntToStr(EEP5007[0])+','+IntToStr(EEP5007[1])+' '+IntToStr(EEP5007[4])+','+IntToStr(EEP5007[6])
  else LabelContrast.Caption:=IntToStr(EEP5007[0])+','+IntToStr(EEP5007[1]);
end;

procedure TFormMain.ButtonRead5007Click(Sender: TObject);
//var
//b : byte;
begin
      PanelMain.Enabled:=False;
      AddLinesLog('Read Contrast...');
      if PingBFB then begin
       if Not BFB_EE_Get_Block_Info(5007,Len5007,Ver5007) then begin
         if BFB_Error=ERR_BFB_EEPBLKNONE then
          AddLinesLog('The block 5007 misses!')
         else
          AddLinesLog('Read error of the information about the block 5007!');
       end
       else begin
        if (Len5007 < SizeOf(EEP5007)) and (Len5007 >= 2) then begin
         if not BFB_EE_Read_Block(5007,0,Len5007,EEP5007) then AddLinesLog('Read error of data of the block 5007!')
         else begin
          ComClose;
          if Debug then AddLinesLog(BufToHex_Str(@EEP5007,Len5007));
          ScrollBarContrast1.Position:=EEP5007[0];
          if Len5007>=7 then ScrollBarContrast2.Position:=EEP5007[4];
          ButtonWrite5007.Enabled:=True;
          AddLinesLog('Display1 contrast: '+IntToStr(EEP5007[0])+', '+IntToStr(EEP5007[1]));
          if Len5007>=7 then begin
           AddLinesLog('Display2 contrast: '+IntToStr(EEP5007[4])+', '+IntToStr(EEP5007[6]));
           LabelContrast.Caption:=IntToStr(EEP5007[0])+','+IntToStr(EEP5007[1])+' '+IntToStr(EEP5007[4])+','+IntToStr(EEP5007[6]);
          end
          else LabelContrast.Caption:=IntToStr(EEP5007[0])+','+IntToStr(EEP5007[1]);
         end; //if BFB_EE_Read_Block(5007
        end // if (Len5007
        else AddLinesLog('Error of a size for the block 5007!');
       end;
       ComClose;
       ProgressBar.Position:=100;
      end;
      PanelMain.Enabled:=True;
end;

procedure TFormMain.ButtonWrite5007Click(Sender: TObject);
begin
      PanelMain.Enabled:=False;
      AddLinesLog('Write contrast ('+IntToStr(ScrollBarContrast1.Position)+', '+IntToStr(ScrollBarContrast2.Position)+') in block 5007...');
      if PingBFB then begin
       EEP5007[0]:=Byte(ScrollBarContrast1.Position);
       EEP5007[1]:=EEP5007[0];
       if Len5007>=7 then begin
        EEP5007[4]:=Byte(ScrollBarContrast2.Position);
        EEP5007[6]:=EEP5007[4];
       end;
       if Len5007>=7 then LabelContrast.Caption:=IntToStr(EEP5007[0])+','+IntToStr(EEP5007[1])+' '+IntToStr(EEP5007[4])+','+IntToStr(EEP5007[6])
       else LabelContrast.Caption:=IntToStr(EEP5007[0])+','+IntToStr(EEP5007[1]);
       if BFB_Write_EEP_block(True,5007,Ver5007,Len5007,EEP5007) then begin
        AddLinesLog('Display1 contrast: '+IntToStr(EEP5007[0])+', '+IntToStr(EEP5007[1]));
        if Len5007>=7 then AddLinesLog('Display2 contrast: '+IntToStr(EEP5007[4])+', '+IntToStr(EEP5007[6]));
       end
       else beep;
       ComClose;
       ProgressBar.Position:=100;
      end;
      PanelMain.Enabled:=True;
end;

procedure TFormMain.ButtonLightOffClick(Sender: TObject);
begin
      PanelMain.Enabled:=False;
      AddLinesLog('Light Off...');
      if PingBFB then begin
       TestSecurityMode;
       if not BFB_ControlLight(02) then AddLinesLog('Error!');
       ComClose;
       ProgressBar.Position:=100;
      end;
      PanelMain.Enabled:=True;
end;

procedure TFormMain.ButtonLightOnClick(Sender: TObject);
begin
      PanelMain.Enabled:=False;
      AddLinesLog('Light On...');
      if PingBFB then begin
       TestSecurityMode;
       if not BFB_ControlLight(01) then AddLinesLog('Error!');
       ComClose;
       ProgressBar.Position:=100;
      end;
      PanelMain.Enabled:=True;
end;

function TFormMain.Write_BFB_EELITE_blks : boolean;
var
i,x : integer;
begin
        result:=False;
        x:=0;
        for i:=0 to idx_eeptab-1 do if EepTab[i].num<5000 then inc(x);
        if x=0 then begin
         AddLinesLog('Absence EELITE of blocks!');
         result:=True;
//         sEep_Err:='Отсутствие EELITE блоков!';
         exit;
        end;
        AddLinesLog('Write '+IntToStr(x)+' EELITE blocks...');
        SetComRxTimeouts(500,2,500);
        x:=0;
        for i:=0 to idx_eeptab-1 do begin
         if EepTab[i].num<5000 then begin
          if not BFB_Write_EEP_block(False,EepTab[i].num,EepTab[i].ver,EepTab[i].len,EepTab[i].buf^)then begin
           beep;
           if MessageDlg('Not write EEP'+Int2Digs(EepTab[i].num,4)+'! Ckip?',mtConfirmation, [mbYes, mbNo], 0) <> mrYes then begin
             AddLinesLog('Cancel.');
             ComClose;
             exit;
           end;
          end;
          inc(x);
          if x>=4 then begin
           ProgressBar.StepBy(1);
           x:=0;
          end;
          Application.ProcessMessages;
         end;
        end;
        result:=True;
end;

function TFormMain.Write_BFB_EEFULL_blks : boolean;
var
i,x : integer;
begin
        result:=False;
        x:=0;
        for i:=0 to idx_eeptab-1 do if EepTab[i].num>=5000 then inc(x);
        if x=0 then begin
         AddLinesLog('Absence EEFULL of blocks!');
//         sEep_Err:='Отсутствие EELITE блоков!';
         result:=True;
         exit;
        end;
        AddLinesLog('Write '+IntToStr(x)+' EEFULL blocks...');
        SetComRxTimeouts(1500,2,1500);
        x:=0;
        for i:=0 to idx_eeptab-1 do begin
         if EepTab[i].num>=5000 then begin
          if not BFB_Write_EEP_block(False,EepTab[i].num,EepTab[i].ver,EepTab[i].len,EepTab[i].buf^)then begin
           beep;
           if MessageDlg('Not write EEP'+Int2Digs(EepTab[i].num,4)+'! Ckip?',mtConfirmation, [mbYes, mbNo], 0) <> mrYes then begin
             AddLinesLog('Cancel.');
             ComClose;
             exit;
           end;
          end;
          inc(x);
          if x>=4 then begin
           ProgressBar.StepBy(1);
           x:=0;
          end;
          Application.ProcessMessages;
         end;
        end;
        result:=True;
end;

var
FreeEELITEBuffer : dword;
function TFormMain.EepInfo(ShowWarn : boolean) : boolean;
var
freeb,freea,freed : dword;
begin
        result:=False;
        if not BFB_EELITE_GetBufferInfo(FreeEELITEBuffer,freea,freed) then begin
         AddLinesLog('Not read EELITE Info!');
         exit;
        end;
        AddLinesLog('EELITE Info: free buffer '+IntToStr(FreeEELITEBuffer)+' bytes, free at all '+IntToStr(freea)+' bytes, free for deleted '+IntToStr(freed)+' bytes.');
        if ShowWarn then begin
         freeb:=10000;
         case HWID of
          HW_A70, HW_A50 : freeb:=3000;
          HW_A75 :  freeb:=30000;
          HW_A60, HW_MC60, HW_SL55, HW_S55, HW_SX1, HW_A62, HW_C60, HW_A65, HW_CF62 : freeb:=40000;
          HW_A52 :  freeb:=60000;
          HW_AX75 : freeb:=80000;
          HW_A55, HW_M55, HW_C110 :  freeb:=90000;
         end;
         if FreeEELITEBuffer<freeb then begin
          AddLinesLog('Warning: Use Defrag EEP! Small free EELITE buffer!');
          beep;
         end;
        end;
        if not BFB_EEFULL_GetBufferInfo(freeb,freea,freed) then begin
         AddLinesLog('Not read EEFULL Info!');
         exit;
        end;
        AddLinesLog('EEFULL Info: free buffer '+IntToStr(freeb)+' bytes, free at all '+IntToStr(freea)+' bytes, free for deleted '+IntToStr(freed)+' bytes.');
        result:=True;
end;


function TFormMain.ReadAllEepBlocks : boolean;
var
eelite_max,eefull_max : dword;
i : dword;
x : integer;
begin
        result:=False;
        ClearEEPBufAndTab;
        SetComRxTimeouts(200,2,300);
        ProgressBar.Position:=0;
        if not EepInfo(True) then exit;
        if not BFB_EELITE_MaxIndexBlk(eelite_max)  then begin
         AddLinesLog('Not read Max index EELITE blocks!');
         exit;
        end;
        if not BFB_EEFULL_MaxIndexBlk(eefull_max)  then begin
         AddLinesLog('Not read Max index EEFULL blocks!');
         exit;
        end;
        AddLinesLog('Read All EELITE blocks from 1 to '+IntToStr(eelite_max)+' ...');
        i:=1;
        x:=idx_eeptab;
        while(i<=eelite_max) do begin
         if Not AddBFBEEPBlk(i,True) then begin
          AddLinesLog(sEep_Err);
          exit;
         end;
         inc(i);
         if (idx_eeptab-x) > 3 then begin
           x:=idx_eeptab;
           ProgressBar.StepBy(1);
         end;
         Application.ProcessMessages;
        end;
        AddLinesLog('Read All EEFULL blocks from 5000 to '+IntToStr(eefull_max)+' ...');
        i:=5000;
        while(i<=eefull_max) do begin
         if Not AddBFBEEPBlk(i,True) then begin
          AddLinesLog(sEep_Err);
          exit;
         end;
         inc(i);
         if (idx_eeptab-x) > 3 then begin
          x:=idx_eeptab;
          ProgressBar.StepBy(1);
          Application.ProcessMessages;
         end;
        end;
        AddLinesLog('Считано всего EEP блоков: '+IntToStr(idx_eeptab)+' шт.');
        ProgressBar.Position:=100;
////        AddLinesLog('ProgressBarPosition='+IntToStr(ProgressBar.Position)) ;
        result:=True;
end;

procedure TFormMain.ButtonDefragEEPClick(Sender: TObject);
var
freeb,freea,freed : dword;
s : string;
begin
      ButtonDefragEEP.Enabled:=False;
      PanelMain.Enabled:=False;
      AddLinesLog('Backup EEPROM blocks...');
      if PingBFB then begin
       if Not TestSecurityMode then begin
        if MessageDlg('Work only in FactoryMode! Format?',mtConfirmation, [mbYes, mbNo], 0) <> mrYes then begin
         AddLinesLog('Cancel.');
         Terminate;
         exit;
        end;
       end;
       Application.ProcessMessages;
       ReadHWID;
       IMEI:=BFB_GetImei;
       if BFB_Error<>BFB_OK then AddLinesLog('Not read IMEI!');
       Application.ProcessMessages;
       if ReadAllEepBlocks then begin
        Application.ProcessMessages;
        CreateFileMobileName;
        Application.ProcessMessages;
        s:=GreateFileNameBackup('Backup')+'.eep';
        if idx_eeptab<>0 then begin
         if not SaveAllEEP(s,HWID) then begin
          AddLinesLog(sEep_Err);
          Terminate;
          exit;
         end
         else AddLinesLog('Backup Blocks saved in "'+s+'" file.');
        end;
        ProgressBar.Position:=0;
        AddLinesLog('Format EELITE...');
        Application.ProcessMessages;
        if Not BFB_EELITE_Format then begin
         AddLinesLog('Error format EELITE!');
         AddLinesLog('(Error:'+IntToStr(BFB_Error)+', buf: '+BufToHex_Str(@ibfb.b[0],16)+')');
//         if idx_eeptab<>0 then begin Terminate; exit; end;
         Terminate; exit;
        end;
        if idx_eeptab<>0 then begin
         if BFB_EELITE_GetBufferInfo(FreeEELITEBuffer,freea,freed) then AddLinesLog('EELITE Info: free buffer '+IntToStr(FreeEELITEBuffer)+' bytes, free at all '+IntToStr(freea)+' bytes, free for deleted '+IntToStr(freed)+' bytes.');
         if Not Write_BFB_EELITE_blks then begin Terminate; exit; end;
        end;
        AddLinesLog('Format EEFULL...');
        Application.ProcessMessages;
        if Not BFB_EEFULL_Format then begin
         AddLinesLog('Error format EEFULL!');
         AddLinesLog('(Error:'+IntToStr(BFB_Error)+', buf: '+BufToHex_Str(@ibfb.b[0],16)+')');
         Terminate; exit;
        end;
        if idx_eeptab<>0 then begin
         if BFB_EEFULL_GetBufferInfo(freeb,freea,freed) then AddLinesLog('EEFULL Info: free buffer '+IntToStr(freeb)+' bytes, free at all '+IntToStr(freea)+' bytes, free for deleted '+IntToStr(freed)+' bytes.');
         if Not Write_BFB_EEFULL_blks then begin Terminate; exit; end;
        end;
        Application.ProcessMessages;
        EepInfo(False);
//        AddLinesLog('Please phone off!');
        AddLinesLog('Defrag EEPROM blocks - Ok.');
        ProgressBar.Position:=100;
       end; // if ReadAllEepBlocks
      end; // if PingBFB
      Terminate;
end;

function TFormMain.CreateFileMobileName : boolean;
var
b : byte;
begin
//    result:=False;
    PhoneName:=BFB_PhoneModel;
    PhoneName:=PhoneName+BFB_GetLg;
    b:=BFB_PhoneFW;
    if b<>$FF then PhoneName:=PhoneName+'Sw'+IntToHex(b,2);
    RepairFileName(PhoneName);
    result:=True;
end;

procedure TFormMain.ButtonBackupEEPClick(Sender: TObject);
begin
      ButtonBackupEEP.Enabled:=False;
      PanelMain.Enabled:=False;
      AddLinesLog('Backup EEPROM blocks...');
      if PingBFB then begin
        TestSecurityMode;// then begin
        ReadHWID;
        IMEI:=BFB_GetImei;
        if BFB_Error<>BFB_OK then begin
         AddLinesLog('Not read IMEI!');
        end
        else begin
          CreateFileMobileName;
//          EditJImei.Text:=IMEI;
          if ReadAllEepBlocks then begin
           ComClose;
           with SaveDialog do begin
            Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
            +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
            -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
            -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
            FilterIndex:=1;
            FileName := IniFile.ReadString('Setup','EEPFile','.\xxx.eep');
            InitialDir := ExtractFilePath(FileName);
            FileName := PhoneName + '_All_'+ FormatDateTime('yymmddhhnnss',Now) + '.eep';
            if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
            if not DirectoryExists(InitialDir) then
             InitialDir := IniFile.ReadString('Setup','DirOld','.\');
            DefaultExt := 'eep';
            Filter := 'EEPROM files (*.eep)|*.eep|All files (*.*)|*.*';
            Title:='Select name for saving eep file ('+IntToStr(idx_eeptab)+' blocks).';
           end;//with
           if SaveDialog.Execute then begin
            if not SaveAllEEP(SaveDialog.FileName,HWID) then AddLinesLog(sEep_Err)
            else begin
             IniFile.WriteString('Setup','EEPFile',SaveDialog.FileName);
             AddLinesLog('EEPROM is written in "'+SaveDialog.FileName+'" file.');
            end;
           end // if SaveDialog.Execute
           else AddLinesLog('Cancel.');
           ProgressBar.Position:=100;
         end;
       end;
       ComClose;
      end;
      PanelMain.Enabled:=True;
      ButtonBackupEEP.Enabled:=True;
end;

procedure TFormMain.CheckBoxReCalcKeysClick(Sender: TObject);
begin
  if CheckBoxReCalcKeys.Checked then CheckBoxBcorePr.Checked:=False;
end;

procedure TFormMain.CheckBoxBcorePrClick(Sender: TObject);
begin
  if CheckBoxBcorePr.Checked then begin
   CheckBoxReCalcKeys.Checked:=False;
   CheckBoxClrBC.Checked:=False;
  end;
end;

procedure TFormMain.CheckBoxClrBCClick(Sender: TObject);
begin
 if CheckBoxClrBC.Checked then begin
  CheckBoxBcorePr.Checked:=False;
  if RadioGroupFlash.ItemIndex=nBootCore then CheckBoxReCalcKeys.Enabled:=False;
 end
 else if RadioGroupFlash.ItemIndex=nBootCore then CheckBoxReCalcKeys.Enabled:=True;
end;

procedure TFormMain.ButtonAboutClick(Sender: TObject);
begin
 if not AboutBox.Visible then begin
  AboutBox.Top:=FormMain.Top+(FormMain.Height shr 1)-(AboutBox.Height shr 1);
  AboutBox.Left := FormMain.Left+(FormMain.Width shr 1)-(AboutBox.Width shr 1);
  AboutBox.ShowModal;
 end
 else begin
  AboutBox.Close;
 end;
end;

procedure TFormMain.CheckBoxPrFacEEPClick(Sender: TObject);
begin
   if  CheckBoxPrFacEEP.Checked then CheckBoxBkEEP.Checked:=True;
end;

procedure TFormMain.CheckBoxBkEEPClick(Sender: TObject);
begin
   if Not CheckBoxBkEEP.Checked then CheckBoxPrFacEEP.Checked:=False;
end;

procedure TFormMain.Button0071Click(Sender: TObject);
var
EEP0071 : array[0..255] of byte;
len : dword;
ver : byte;
s : string;
i,l,x,y,z : integer;
flgCh : boolean;
begin
      Button0071.Enabled:=False;
      PanelMain.Enabled:=False;
      flgCh:=False;
//      AddLinesLog('Test and edit block 0071...');
      AddLinesLog('Reparation of the block EEP0071 for disable "aircraft check" and adding of the "Band selection" menu...');
      if PingBFB then begin
       ProgressBar.Position:=10;
       CreateFileMobileName;
       ProgressBar.StepBy(15);
       if BFB_EE_Get_Block_Info(0071,len,ver) then begin
        ProgressBar.StepBy(15);
        ReadHWID;
        ProgressBar.StepBy(15);
        if (len>=200) or (len<=250) then begin
         if BFB_EE_Read_Block(0071,0,len,EEP0071[0]) then begin
          ClearEEPBufAndTab;
          AddEEPBlk(0071,ver,len,EEP0071[0]);
//Test          EEP0071[1]:=$00;
          z:=4;
          y:=0;
          x:=1+(EEP0071[0]*6);
          if x+8 < integer(len) then begin
           for i:=1 to EEP0071[0] do begin
            l:=(EEP0071[z] shr 3);
            if (EEP0071[z] and 7)<>0 then inc(y);
            l:=l+EEP0071[z+1]+(EEP0071[z+2] shr 8);
            if y<l then y:=l;
            z:=z+6;
           end;
          end;
          if (x+9>=integer(len)) or (x+y>=integer(len)) or
          (Not((EEP0071[1]=$FF)
          and (EEP0071[2]=$FF)
          and (EEP0071[3]=$FF)
          and (EEP0071[4]>51))) then begin
           if (x+13>=integer(len)) or (x+y>=integer(len)) then s:='The data in the block EEP0071 are incorrect!'
           else s:='The block EEP071 has not customizations for "Any operator"!';
           AddLinesLog(s);
           if MessageDlg(s+#13+#10+'To create new record?',mtConfirmation, [mbYes, mbNo], 0) <> mrYes then begin
            AddLinesLog('Cancel.');
            ComClose;
            Button0071.Enabled:=True;
            PanelMain.Enabled:=True;
            exit;
           end;
           AddLinesLog('Add record for "Any operator"...');
//           if EEP0071[4]< 52 then begin
            flgCh:=True;
            EEP0071[0]:=$01;
            EEP0071[1]:=$FF;
            EEP0071[2]:=$FF;
            EEP0071[3]:=$FF;
            EEP0071[5]:=0;
            EEP0071[6]:=0;
            FillChar(EEP0071[7],len-8,$ff);
            Case HWID of
             HW_A51, HW_A52, HW_A55, HW_A56: // A57=A55
             begin EEP0071[4]:=$3F; EEP0071[11]:=$FB; EEP0071[13]:=$6C; EEP0071[14]:=$FD; end;
             HW_A60, HW_A70: begin EEP0071[4]:=$31; EEP0071[13]:=$7f; end;
             HW_A62: begin EEP0071[4]:=$3F; end;
             HW_A65, HW_A75: begin EEP0071[4]:=$3A; EEP0071[14]:=$BF; end;
             HW_C55: begin EEP0071[4]:=$3F; EEP0071[11]:=$FB; EEP0071[13]:=$6C; EEP0071[14]:=$FD; end;
//             HW_C56: begin EEP0071[4]:=$3F; EEP0071[7]:=$7F; EEP0071[11]:=$FB; EEP0071[13]:=$7C; EEP0071[14]:=$FD; end;
//             HW_С60: begin EEP0071[4]:=$31; EEP0071[13]:=$7F; end;
//             HW_СF62: begin EEP0071[4]:=$3C; EEP0071[13]:=$7F; end;
//             HW_M55: begin EEP0071[4]:=$3B; EEP0071[13]:=$7F; EEP0071[14]:=$DF; end;
             HW_S55: begin EEP0071[4]:=$34; EEP0071[13]:=$EF; end;
             HW_AX72,HW_AX75,HW_C110: begin EEP0071[4]:=$3C; EEP0071[14]:=$AF; end;
            else EEP0071[4]:=$3F;
            end;
            x:=7;
          end;
          if ((EEP0071[x] and $01)<>0) // Меню "Диапазон"
          then begin
           flgCh:=True;
           EEP0071[x]:=EEP0071[x] and $FE; // Меню "Диапазон"
           AddLinesLog('Band selection menu add - Ok.');
           EEP0071[x+6]:=EEP0071[x+6] xor $10; //and $EF; // "Подтверждение включения"
           AddLinesLog('Disable aircraft check - Ok.');
          end;
          if ((HWID=HW_C55) and ((EEP0071[x+4] and $08)<>0))
          then begin
           flgCh:=True;
           EEP0071[x+4]:=EEP0071[x+4] and $F7; // Enable DES support
           AddLinesLog('C55 enable DES support - Ok.');
          end;
          if flgCh then begin
           ProgressBar.StepBy(15);
           s:=GreateFileNameBackup('0071_')+'.eep';
           if SaveAllEEP(s,HWID) then begin
            AddLinesLog('EEP0071 block is written in "'+s+ '" file.');
           end
           else AddLinesLog(sEep_Err);
           ProgressBar.StepBy(15);
           if BFB_Write_EEP_block(True,0071,ver,len,EEP0071[0]) then begin
            AddLinesLog('The block EEP0071 is updated.');
            ProgressBar.Position:=100;
           end
           else beep;
          end
          else begin
           AddLinesLog('The block EEP0071 is already updated!');
           ProgressBar.Position:=100;
          end;
         end
         else begin
          AddLinesLog('Read error of data of the block EEP0071!');
         end;
        end
        else begin
         AddLinesLog('The bad length of block EEP0071!');
        end;
       end //if BFC_EE_Get_Block_Info
       else begin
         if BFB_Error=ERR_BFB_EEPBLKNONE then
          AddLinesLog('In the phone there is no block EEP0071!')
         else
          AddLinesLog('Error read Info about the block EEP0071!');
       end;
       ComClose;
      end; //if ComOpen
      Button0071.Enabled:=True;
      PanelMain.Enabled:=True;
end;

procedure TFormMain.ButtonInfoBFBClick(Sender: TObject);
var
d : dword;
w1,w2 : word;
len : dword;
ver,b : byte;
i : integer;
buf : array[0..255] of byte;
s : string;
begin
      PanelMain.Enabled:=False;
      AddLinesLog('Get Info...');
      if PingBFB
      and InfoBFB
      and BFB_ReadDSPFirmwareVersion(w1)
      and BFB_ReadPowerAsicProject(ver)
      and BFB_GetHardwareInf(1,b) then begin
       AddLinesLog('DSP Firmware Version '+Int2Digs(w1,2)+', Power Asic Project ID: '+IntToHex(ver,2)+', RF Chipset ID: '+IntToHex(b,2));
       ProgressBar.StepBy(10);
       if EepInfo(True) then begin
//       BFB_ReadSensors(d);
        if BFB_EEFULL_MaxIndexBlk(d)
        and (d >=5093) then begin
         if BFB_EE_Get_Block_Info(5093,len,ver) then begin
          ProgressBar.StepBy(5);
          if (len=32) or (len=76) then begin
           if BFB_EE_Read_Block(5093,0,len,EEP5093[0]) then begin
            ProgressBar.StepBy(5);
            s:='Battery Ri measurement: ';
            ver:=1; i:=28;
            if len=76 then begin
             i:=56; ver:=4;
            end;
            while ver<>0 do begin
             w1:=word((@EEP5093[i])^);
             Inc(i,2);
             w2:=word((@EEP5093[i])^);
             Inc(i,2);
             dec(ver);
             s:=s + 'CutOff Idle: '+IntToStr(w2)+'mV, CutOff Talk: '+IntToStr(w1)+'mV';
             if ver<>0 then s:=s+', '
             else s:=s+'.';
            end;
           AddLinesLog(s);
           end;
          end;
         end;
         if BFB_EE_Get_Block_Info(5011,len,ver) then begin
          ProgressBar.StepBy(5);
          if (len>=30) and (len<=SizeOf(buf)) then begin
           if BFB_EE_Read_Block(5011,0,len,buf[0]) then begin
            ProgressBar.StepBy(5);
            AddLinesLog('Operating time: Total '+IntToStr(dword((@buf[0])^))+' sec, Current SW '+IntToStr(dword((@buf[16])^))+' sec.');
            AddLinesLog('Talk time: Total '+IntToStr(dword((@buf[4])^))+' sec, Current SW '+IntToStr(dword((@buf[20])^))+' sec.');
            AddLinesLog('CSD: Total '+IntToStr(dword((@buf[8])^))+' bytes, Current SW '+IntToStr(dword((@buf[24])^))+' bytes.');
            AddLinesLog('GPRS: Total '+IntToStr(dword((@buf[12])^))+' bytes, Current SW '+IntToStr(dword((@buf[28])^))+' bytes.');
           end;
          end;
         end;
        end; // if BFB_EEFULL_MaxIndexBlk
       end; // if EepInfo
       ProgressBar.Position:=100;
      end; // if PingBFB and InfoBFB ...
      ComClose;
      PanelMain.Enabled:=True;
end;

procedure TFormMain.ButtonNormModeClick(Sender: TObject);
begin
    if flgBootLoad then begin
       AddLinesLog('Cancel.');
       Sleep(200);
{       if not BFB_PhoneOff then begin
        if dcb.BaudRate=57600 then ChangeComSpeed(115200)
        else if dcb.BaudRate=115200 then ChangeComSpeed(57600);
        if BFB_PhoneOff then AddLinesLog('Phone Off.');
       end
       else AddLinesLog('Phone Off.'); }
       Stop;
       exit;
    end;
    AllKeyDisable;
    ButtonNormMode.Caption :='Cancel';
    ButtonNormMode.Enabled:=True;
    if StartServiceMode($02) then InfoBFB;
    Terminate;
    ProgressBar.Position:=100;
end;


function TFormMain.ReadFlashSeg(addr, size: dword; stepx : integer): boolean ;
var
buf : array[0..16383] of byte;
begin
       result:=False;
       size:=size and $1FF0000;
       addr:=addr and $FF0000;
       while size<>0 do begin
        Application.ProcessMessages;
        if (Not flgBootLoad) or flgBFBExit then begin
         exit;
        end;
        if Not ReadFlashl55Boot(addr,SizeOf(buf),buf[0]) then begin
         AddLinesLog(sBootErr);
         exit;
        end;
        if BinMemoryStream.Write(Buf[0],SizeOf(buf)) <> SizeOf(buf) then begin
         AddLinesLog('Error of saving of the block in MemoryStream!');
         exit;
        end;
        addr:=addr+SizeOf(buf);
        size:=size-SizeOf(buf);
        ProgressBar.StepBy(stepx);
       end;
       result:=True;
end;

procedure TFormMain.ButtonReCalcKeyClick(Sender: TObject);
var
HashAddr,addr,size,xa,xo,xb,flgrec : dword;
ch : char;
sBlkFile : string;
F : TFileStream;
buf : array[0..$1FFFF] of byte;
//flgrec, x : dword;
begin
      if flgBootLoad then begin
       flgBootLoad := False;
       Sleep(200);
       Stop;
       AddLinesLog('Cancel.');
       exit;
      end;
      ProgressBar.Position:=0;
      AllKeyDisable;
      ButtonReCalcKey.Caption := 'Cancel';
      ButtonReCalcKey.Enabled:=True;
      Model:=RadioGroupTelType.ItemIndex;
/////////// Load Boots
      if StartBootAndInfo then begin
       ProgressBar.Position:=100;
       if FlashInfo.CFI.FlashSizeN=0 then AddLinesLog('Warning: Unknown flash size in settings phone model!');
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then begin Stop; exit; end;
       if CheckBoxUseOTPImei.Checked then begin
        if FlgOTPImeiErr then begin Stop; exit; end
        else begin
         IMEI:=OTPIMEI;
         AddLinesLog('Use OTP IMEI: ' + IMEI);
        end;
       end;
       if (FlashInfo.SegEELITE shl 14)<>TabFlash[Model][tEEBase] then begin
        AddLinesLog('Error: Not valid addres EELITE in set phone model!');
        Stop;
        exit;
       end;
       if CheckBoxExtIMEI.Checked then begin
        if (Not CalcImei15(EditJImei.Text,ch)) or (EditJImei.Text[15]<>ch) then begin
         AddLinesLog('IMEI is not correctly entered!');
         Stop;
         exit;
        end;
        IMEI:=EditJImei.Text;
        AddLinesLog('Use EXT IMEI: ' + IMEI);
       end;
       if Not (CheckBoxUseOTPImei.Checked or CheckBoxExtIMEI.Checked) then begin
        if Not ReadEEPl55Boot(5009,10,Byte(ch),EEP5009) then begin
         AddLinesLog(sBootErr);
         Stop;
         exit;
        end;
        ProgressBar.StepIt;
        Application.ProcessMessages;
        if (Not flgBootLoad) or flgBFBExit then begin Stop; exit; end;
        Decode5009(EEP5009,C55);
        BCD2IMEI(EEP5009,sBlkFile);
        if Length(sBlkFile)>=16 then sBlkFile[15]:=sBlkFile[16];
        SetLength(sBlkFile,15);
        if Not CalcImei15(sBlkFile,ch) then begin
         AddLinesLog('Error IMEI in EEP5009!');
         Stop;
         exit;
        end
        else begin
         if ch<>sBlkFile[15] then begin
          AddLinesLog('Error('+ch+','+Char(sBlkFile[15])+') CRC IMEI in EEP5009!');
          Stop;
          exit;
         end
         else begin
          IMEI:=sBlkFile;
          AddLinesLog('Use EEP IMEI: ' + IMEI);
         end;
        end;
       end; // if Not (CheckBoxUseOTPImei.Checked or CheckBoxExtIMEI.Checked)
       Move(HASH[0],buf[0],16);
       ReadIniImeiKeys;
//       HexTopByte(@IniFile.ReadString(IMEI,'BKEY','00000000000000000000000000000000')[1],16,@BootKey);
       HexTopByte(@IniFile.ReadString(IMEI,'HASH','00000000000000000000000000000000')[1],16,@HASH);
//       if (SKEY=0) or (SKEY>99999999) then SKEY:=IniFile.ReadInteger('System','Skey',12345678);
       if (Not TestSkey(SKEY,FSN,False)) then CalcHashAndBkey(SKEY,FSN);
       AddLinesLog('USE SKEY: '+Int2Digs(SKEY,8));
       AddLinesLog('*#0000*'+Int2Digs(Mkey[0],8)+'# - Network Lock');
       AddLinesLog('*#0001*'+Int2Digs(Mkey[1],8)+'# - Service Provider Lock');
       AddLinesLog('*#0002*'+Int2Digs(Mkey[2],8)+'# - Corporate Code');
       AddLinesLog('*#0003*'+Int2Digs(Mkey[3],8)+'# - Phone Code');
       AddLinesLog('*#0004*'+Int2Digs(Mkey[4],8)+'# - Network Subset Lock');
       AddLinesLog('*#0005*'+Int2Digs(Mkey[5],8)+'# - Only Sim');
       Create76(IMEI,EEP0076,CryptModel);
       Create5008(IMEI,FSN,EEP5008,CryptModel);
       Create5009(IMEI,EEP5009,CryptModel);
       Create5077(IMEI,FSN,EEP5077,CryptModel);
       Create512x(IMEI,FSN,Skey,Mkey);
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then begin Stop; exit; end;
////////////
       ProgressBar.Position:=0;
       if (not flgHASH)
       or (dword((@buf[0])^)<>dword((@HASH[0])^))
       or (dword((@buf[4])^)<>dword((@HASH[4])^))
       or (dword((@buf[8])^)<>dword((@HASH[8])^))
       or (dword((@buf[12])^)<>dword((@HASH[12])^)) then begin
        addr:=TabFlash[Model][tBCBase];
        size:=TabFlash[Model][tBCSize];
        AddLinesLog('Read BCORE addr: 0x'+IntToHex(addr,6)+' size: 0x'+IntToHex(size,6)+'...');
        ProgressBar.Max:=size;
        BinMemoryStream := TMemoryStream.Create;
        BinMemoryStream.SetSize(size);
        if Not ReadFlashSeg(addr,size,16384) then begin
         BinMemoryStream.Free;
         ProgressBar.Max:=100;
         Stop;
         exit;
        end;
        ProgressBar.Max:=100;
        Application.ProcessMessages;
        if (Not flgBootLoad) or flgBFBExit then begin
         BinMemoryStream.Free;
         Stop;
         exit;
        end;
        BinMemoryStream.Seek(0,soFromBeginning);
        if dword(BinMemoryStream.Read(buf[0],size)) <> size then begin
         AddLinesLog('MemoryStream read error!');
         BinMemoryStream.Free;
         Stop;
         exit;
        end;
        Application.ProcessMessages;
        if (Not flgBootLoad) or flgBFBExit then begin
         Stop;
         exit;
        end;
        HashAddr:=$330;
        if Model=MA50 then HashAddr:=$32E;
        if (dword((@buf[$300])^)=$534C0100) then begin
         if (dword((@buf[HashAddr+0])^)<>$FFFFFFFF)
         and (dword((@buf[HashAddr+4])^)<>$FFFFFFFF)
         and (dword((@buf[HashAddr+8])^)<>$FFFFFFFF)
         and (dword((@buf[HashAddr+12])^)<>$FFFFFFFF) then begin
          sBlkFile:=GreateFileNameBackup('BCORE_')+'.bin';
          F:=TFileStream.Create(sBlkFile,fmCreate);
          BinMemoryStream.Seek(0,soFromBeginning);
          F.CopyFrom(BinMemoryStream,BinMemoryStream.Size);
          F.Free;
          AddLinesLog('BCORE backup in "'+sblkFile+ '" file.');
          ProgressBar.Position:=0;
          Application.ProcessMessages;
          if (Not flgBootLoad) or flgBFBExit then begin
           Stop;
           exit;
          end;
          Move(HASH,buf[HashAddr],16);
          AddLinesLog('Write BCORE at addr: 0x'+IntToHex(addr,6)+'...');
          if Not WriteSegFlashl55Boot(addr,size,buf[0]) then begin
           AddLinesLog(sBootErr);
           Stop;
           exit;
          end;
          WriteIniImeiKeys(True);
          ProgressBar.Position:=100;
          AddLinesLog('Change BCORE HASH - Ok.');
         end
         else begin
          if Model=MA50 then begin
           if (dword((@buf[$304])^)=$FFFFFFFF)
           and (word((@buf[$380])^)=$FFFF) then AddLinesLog('BCORE Clean! Use Freeze!')
           else AddLinesLog('BCORE HASH Error!');
          end
          else begin
           if (dword((@buf[$304])^)=$FFFFFFFF)
           and (word((@buf[$32E])^)=$FBAF) then AddLinesLog('BCORE Clean! Use Freeze!')
           else AddLinesLog('BCORE HASH Error!');
          end;
         end;
        end
        else AddLinesLog('BCORE Table Error!');
        BinMemoryStream.Free;
       end
       else begin
        WriteIniImeiKeys(True);
        AddLinesLog('BCORE HASH is equivalent - not change.');
       end;
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then begin
        Stop;
        exit;
       end;
///////////
       ProgressBar.Position:=0;
       addr:=TabFlash[Model][tEEBase];
       size:=TabFlash[Model][tEESize];
       AddLinesLog('Read EEPROM addr: 0x'+IntToHex(addr,6)+' size: 0x'+IntToHex(size,6)+'...');
       ProgressBar.Max:=size;
       BinMemoryStream := TMemoryStream.Create;
       BinMemoryStream.SetSize(size);
       if Not ReadFlashSeg(addr,size,16384) then begin
        BinMemoryStream.Free;
        ProgressBar.Max:=100;
        Stop;
        exit;
       end;
       ProgressBar.Max:=100;
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then begin
        BinMemoryStream.Free;
        Stop;
        exit;
       end;
       sBlkFile:=GreateFileNameBackup('EEPROM_')+'.bin';
       F:=TFileStream.Create(sBlkFile,fmCreate);
       BinMemoryStream.Seek(0,soFromBeginning);
       F.CopyFrom(BinMemoryStream,BinMemoryStream.Size);
       F.Free;
       AddLinesLog('EEPROM backup in "'+sblkFile+ '" file.');
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then begin
        BinMemoryStream.Free;
        Stop;
        exit;
       end;
       AddLinesLog('Write EEPROM addr: 0x'+IntToHex(addr,6)+' size: 0x'+IntToHex(size,6)+'...');
       ProgressBar.Position:=0;
       ProgressBar.Max:=size;
       FlgBkEEP:=0;
       flgrec:=0;
       xa:=addr and $FF0000;
       xo:=0;
       while xo<size do begin
        Application.ProcessMessages;
        if (Not flgBootLoad) or flgBFBExit then begin
         BinMemoryStream.Free;
         ProgressBar.Max:=100;
         Stop;
         exit;
        end;
        xb:=SizeOf(buf);
        if xb>size-xo then xb:=size-xo;
        BinMemoryStream.Seek(xo,soFromBeginning);
        if BinMemoryStream.Read(buf[0],xb)<>integer(xb) then begin
         AddLinesLog('Error read block from file!');
         F.Free;
         ProgressBar.Max:=100;
         Stop;
         exit;
        end;
        flgrec := flgrec or ReCalcEEPSeg(xa,xb,buf);
//{
        if Not WriteSegFlashl55Boot(xa,xb,buf[0]) then begin
         BinMemoryStream.Free;
         AddLinesLog(sBootErr);
         ProgressBar.Max:=100;
         Stop;
         exit;
        end;
//} segsize:=$10000;
        xa:=xa+segsize;
        xo:=xo+segsize;
        ProgressBar.Position:=xo;
       end; // while xo<size
       Stop;
       ProgressBar.Max:=100;
       ProgressBar.Position:=100;
       BinMemoryStream.Free;
       xa := BitEEP0076 or BitEEP5009 or BitEEP5009 or BitEEP5077 or BitEEP5121 or BitEEP5122 or BitEEP5123 or BitBkey;
       ChangeInfo(flgrec and xa,'Ok.');
       ChangeInfo((flgrec and xa) xor xa,'Error!');
       WriteIniImeiKeys(True);
      end; // if StartBootAndInfo
      Stop;
end;

procedure TFormMain.ButtonGetImeiClick(Sender: TObject);
begin
      PanelMain.Enabled:=False;
      AddLinesLog('Get IMEI...');
      if PingBFB then begin
       EditFImei.Text:=BFB_GetImei;
       AddLinesLog('IMEI: '+EditFImei.Text);
       ComClose;
       ProgressBar.Position:=100;
      end;
      PanelMain.Enabled:=True;
end;

procedure TFormMain.EditFImeiChange(Sender: TObject);
var
i : integer;
sText : string;
c : char;
begin
  sText:=EditFImei.Text;
  i:=length(sText);
  if (i>=15) then begin
   if CalcImei15(sText,c) then begin
    setlength(sText,14);
    EditFImei.Text:=sText+c;
   end;
  end;
end;

procedure TFormMain.ButtonFreezeClick(Sender: TObject);
var
i : integer;
sText : string;
c : char;
x : word;
begin
      AddLinesLog('Freeze...');
      sText:=EditFImei.Text;
      i:=length(sText);
      CalcImei15(sText,c);
      if (i=15)
      and CalcImei15(sText,c)
      and (c=sText[15])
      then begin
       PanelMain.Enabled:=False;
       if PingBFB then begin
//       EditFImei.Text:=BFB_GetImei;
        AddLinesLog('Use IMEI: '+sText);
        x:=0;
        if BFB_Freeze(sText,x) then begin
         case x of
         0: sText:='Done';
         1: sText:='Not Supported!';
         2: sText:='No ServiceMode!';
         3: sText:='Access Denied!';
         4: sText:='IMEI Not Valid!';
         5: sText:='IMEI Freeze Failed or OTP IMEI is already written!';
         6: sText:='Boot Freeze Failed!';
         7: sText:='No Freeze Data!';
         else sText:='Unknown Error 0x'+IntToHex(x,4)+'!';
         end;
         AddLinesLog('Freeze: '+sText);
         if x=5 then AddLinesLog('Freeze BCORE data - Ok.');
         if x=6 then AddLinesLog('Prepare BCORE and EEPROM blocks!');
        end
        else begin
         if BFB_Error=ERR_BFB_RD_CMD then AddLinesLog('Error Read result Freeze!')
         else if BFB_Error=ERR_BFB_IO_RS then AddLinesLog('Error Send Freeze!')
         else AddLinesLog('Error Freeze command!')
        end;
        ComClose;
        ProgressBar.Position:=100;
       end;
      end
      else AddLinesLog('Input error IMEI "'+sText+'"!');
      PanelMain.Enabled:=True;
end;

procedure TFormMain.ButtonRdEepFileClick(Sender: TObject);
var
fileHWID : word;
i,x : integer;
s : string;
begin
       ProgressBar.Position:=0;
       with OpenDialog do begin
        FilterIndex:=1;
        FileName := IniFile.ReadString('Setup','EepFileWrite','x.eep');
        InitialDir := ExtractFilePath(FileName);
        FileName := ExtractFileName(FileName);
        if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
        if not DirectoryExists(InitialDir) then InitialDir := '.\';
        DefaultExt := 'eep';
        Filter := 'Eep (*.eep)|*.eep|All files (*.*)|*.*';
        Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
        Title:='Select *.epp file for record to the phone.';
       end;//with OpenDialog
       if OpenDialog.execute then begin
        AddLinesLog('Open "'+OpenDialog.FileName+'" file...');
        if not OpenEEPfile(OpenDialog.FileName,FileHWiD)
        then begin
         AddLinesLog(sEep_Err);
         exit;
        end;
        IniFile.WriteString('Setup','EepFileWrite',SaveDialog.FileName);
        if FileHWID<>0 then AddLinesLog('File used HWID: '+IntToStr(FileHWID)+' ('+HwIDToStr(FileHWID)+')')
        else AddLinesLog('File not use HWID info.');
        s:='The file contains '+IntToStr(idx_eeptab)+' EEP of blocks';
        if idx_eeptab = 0 then begin
         AddLinesLog(s+'!');
         exit;
        end
        else begin
         if idx_eeptab<=20 then begin
          s:=s+': ';
{          while i<idx_eeptab do begin
           x:=idx_eeptab-i;
           if x>10 then x:=10;
           for y:=0 to x-2 do s:=s+Int2Digs(EepTab[i+y].num,4)+',';
           inc(i,x);
           if i=idx_eeptab then s:=s+Int2Digs(EepTab[i-1].num,4)
           else s:=s+Int2Digs(EepTab[i-1].num,4)+',';
          end; }
          x:=idx_eeptab;
          if x>10 then x:=10;
          for i:=0 to idx_eeptab-2 do s:=s+Int2Digs(EepTab[i].num,4)+',';
          if idx_eeptab=10 then s:=s+Int2Digs(EepTab[x-1].num,4)+',...'
          else s:=s+Int2Digs(EepTab[x-1].num,4)+'.';
         end
         else s:=s+'.';
         AddLinesLog(s);
         if (Not PingBFB) or (Not EepInfo(True)) then begin
          ComClose;
          exit;
         end;
         if MessageDlg(s +#13+#10+'Write?',mtConfirmation, [mbYes, mbNo], 0) <> mrYes
         then begin
          AddLinesLog('Cancel.');
          ComClose;
          exit;
         end;
         if FileHWID<>0 then begin
          if BFB_GetHWID(HWID)then begin
           AddLinesLog('Phone HWID: '+IntToStr(HWID)+' ('+HwIDToStr(HWID)+')');
           if HWID<>FileHWID then
            if MessageDlg('File used HWID: '+IntToStr(FileHWID)+'!'+#13+#10+
            'Phone HWID: '+IntToStr(HWID)+'!'+#13+#10+'Write?',mtConfirmation, [mbYes, mbNo], 0) <> mrYes
            then begin
             AddLinesLog('Cancel.');
             ComClose;
             exit;
            end;
          end
          else HWID:=0;
         end;
         x:=0;
         for i:=0 to idx_eeptab-1 do if EepTab[i].num<5000 then x:=x+integer(EepTab[i].len)+1;
         if dword(x)>=FreeEELITEBuffer then begin
          s:='Records of these blocks in area EELITE need '+IntToStr(x)+' bytes. There are only '+IntToStr(FreeEELITEBuffer)+' bytes.';
          AddLinesLog('Warning: '+s);
          if MessageDlg(s+#13#10'Write?',mtConfirmation, [mbYes, mbNo], 0) <> mrYes then begin
           AddLinesLog('Cancel.');
           ComClose;
           exit;
          end;
         end;
         ProgressBar.Position:=0;
         if Write_BFB_EELITE_blks then
          if Write_BFB_EEFULL_blks then begin
           EepInfo(True);
           AddLinesLog('Write '+IntToStr(idx_eeptab)+' EEPROM blocks - Ok.');
           ProgressBar.Position:=100;
         end;
         ComClose;
        end; // if idx_eeptab <> 0
       end; // if OpenDialog.execute
//       else exit;
end;

procedure TFormMain.ButtonClearMemoClick(Sender: TObject);
begin
    MemoInfo.Clear;
end;

procedure TFormMain.Button0280Click(Sender: TObject);
var
EEP0280 : array[0..8] of byte;
len : dword;
ver : byte;
s : string;
begin
     Button0280.Enabled:=False;
     PanelMain.Enabled:=False;
//      AddLinesLog('Test and edit block 0280...');
     AddLinesLog('Reparation of the block EEP0280 for enable "Developer Menu"...');
     if PingBFB then begin
      ProgressBar.Position:=10;
      ReadHWID;
      ProgressBar.StepBy(10);
      CreateFileMobileName;
      ProgressBar.StepBy(10);
      if not BFB_EELITE_MaxIndexBlk(len)  then begin
       AddLinesLog('Not read Max index EELITE blocks!');
      end
      else
      if len>=280 then begin
       ProgressBar.StepBy(10);
       if BFB_EE_Get_Block_Info(280,len,ver) then begin
        ProgressBar.StepBy(15);
        if (len=2) then begin
         if BFB_EE_Read_Block(280,0,len,EEP0280[0]) then begin
          ProgressBar.StepBy(15);
          if (EEP0280[$0]<>0) and (EEP0280[$1]<>0) then begin
           ClearEEPBufAndTab;
           AddEEPBlk(280,ver,len,EEP0280[0]);
           s:=GreateFileNameBackup('0280_')+'.eep';
           if SaveAllEEP(s,HWID) then begin
            AddLinesLog('EEP0280 block is written in "'+s+ '" file.');
           end
           else AddLinesLog(sEep_Err);
           ProgressBar.StepBy(15);
           EEP0280[$0]:=0;
           EEP0280[$1]:=0;
           if BFB_Write_EEP_block(True,0280,ver,len,EEP0280[0]) then begin
            AddLinesLog('"Developer Menu" enabled. Вставьте SIM со спец номером.');
            AddLinesLog('The block EEP0280 is updated.');
            ProgressBar.Position:=100;
           end;
          end
          else begin
           AddLinesLog('The block EEP0280 is already updated!');
           ProgressBar.Position:=100;
          end;
         end
         else begin
          AddLinesLog('Read error of data of the block EEP0280!');
         end;
        end
        else begin
         AddLinesLog('The bad length of block EEP0280!');
        end;
       end //if BFC_EE_Get_Block_Info
       else begin
        if BFB_Error=ERR_BFB_EEPBLKNONE then
          AddLinesLog('In the phone there is no block EEP0280!')
         else
          AddLinesLog('Error read Info about the block EEP0280!');
       end;
      end
      else begin
       AddLinesLog('Max index ELLITE block '+IntToStr(len)+'.');
       AddLinesLog('In the phone there is no block EEP0280! (S55,M55,...)')
      end;
     end; //if ComOpen
     ComClose;
     Button0280.Enabled:=True;
     PanelMain.Enabled:=True;
end;

function TFormMain.SendSwpBoot : boolean;
begin
      result:=False;
      if flgBootLoad then begin
       flgBootLoad:=False;
       Sleep(200);
       ComClose;
       result:=False;
       exit;
      end;
      ProgressBar.Position:=0;
{      result:=StartBoot(BootsMode);
      if result and (Not flgalready) then begin
       result:=False;
       if SendSBPl55Boot($02,@iComBaud) then begin
        AddLinesLog(sBootErr);
        result:=True;
        exit;
       end;
       AddLinesLog(sBootErr); }
       if StartServiceMode($07)
       and BFB_GetHWID(HWID) and BFB_GoSwup(iComBaud) then result:=True;
//      end;
end;


procedure TFormMain.Button1Click(Sender: TObject);
var
//oldtb : integer;
b : byte;
begin
    if flgBootLoad then begin
       AddLinesLog('Cancel.');
       Sleep(200);
       if not BFB_PhoneOff then begin
        if dcb.BaudRate=57600 then ChangeComSpeed(115200)
        else if dcb.BaudRate=115200 then ChangeComSpeed(57600);
        if BFB_PhoneOff then AddLinesLog('Phone Off.');
       end
       else AddLinesLog('Phone Off.');
       Stop;
    end else begin
//     oldtb:=RadioGroupBaud.ItemIndex;
     AllKeyDisable;
//     RadioGroupBaud.ItemIndex:=0;
{    ButtonSrvm.Caption :='Cancel';
    ButtonSrvm1.Caption :='Cancel';
    ButtonSrvm2.Caption :='Cancel';
    ButtonSrvm.Enabled:=True;
    ButtonSrvm1.Enabled:=True;
    ButtonSrvm2.Enabled:=True; }
     if SendSwpBoot then begin
      SetComRxTimeouts(2000,1,2000);
      if ReadSWP=ERR_NO then SendSWPok;
      if SendSWPcmd($94,2,[$0E,$00])
      and SendSWPcmd($95,$0E,[$02,$01,Byte(HWID),Byte(HWID shr 8),$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF])
      and SendSWPcmd($96,0,[0]) then begin
       if SendSWPcmd($32,1,[0]) and ReadSWPcmd
       and SendSWPcmd($21,0,[0]) and ReadSWPcmd
//       and SendSWPcmd($35,0,[0]) and ReadSWPcmd
       and SendSWPcmd($47,15,[00,$00,$80,$00,$81,$00,$82,$00,$83,$00,$84,$00,$85,$06,$87,$08]) and ReadSWPcmd
       and SendSWPcmd($47,13,[01,$04,$FE,$00,$83,$04,$FE,$00,$82,$00,$00,$00]) and ReadSWPcmd
//       and SendSWPcmd($57,16,[$80,$00,$81,$00,$82,$00,$83,$00,$84,$00,$85,$00,$87,$00,$88,$00])
//       and SendSWPcmd($58,16,[$80,$00,$81,$00,$82,$00,$83,$00,$84,$00,$85,$00,$87,$00,$88,$00])
//       and SendSWPcmd($CC,12,[02,$BA,$B0,$00,$00,$00,$01,$80,$00,$BA,$00,$80,$00,1,2,3,4]) and ReadSWPcmd
       and SendSWPcmd($B8,08,[$00,$80,$00,$80,$00,$80,$01,$80]) and ReadSWPcmd
//>> 06 FF FF FF 0E 47 03 80 80 80 80 80 80 80 80 80 80 80 80 B5                                       ВЂВЂВЂВµ
//<< 06 FF FF FF 0C 48 00 80 80 80 80 00 00 00 00 00 00 BB

        then begin
//         SendSWPcmd($04,0,[0]);
         while ReadCom(@b,1) do;
//         while ReadCom(@b,1) do;
//         while ReadCom(@b,1) do;
       end;
       ProgressBar.Position:=100;
      end;
     end;
    end;
//    RadioGroupBaud.ItemIndex:=oldtb;
    Stop;
end;

procedure TFormMain.ButtonNameChClick(Sender: TObject);
var
addr, size : dword;
buf : array[0..$1FFFF] of byte;
i : integer;
sBlkFile : string;
F : TFileStream;
begin
      if flgBootLoad then begin
       flgBootLoad := False;
       Sleep(200);
       Stop;
       AddLinesLog('Cancel.');
       exit;
      end;
      AllKeyDisable;
      ButtonNameCh.Caption := 'Cancel';
      ButtonNameCh.Enabled:=True;
      PanelMain.Enabled:=False;
      Model:=RadioGroupTelType.ItemIndex;
      if StartBootAndInfo then begin //SendAllBoot
       ProgressBar.Position:=10;
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then begin Stop;  exit;  end;
       if Not GetSeg55Boot($87FF70, addr, size, FlashInfo) then begin
        AddLinesLog(sBootErr);
        Stop; exit;
       end;
//       AddLinesLog(sBootErr);
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then begin Stop;  exit;  end;
       if size>SizeOf(buf) then begin
        AddLinesLog('Error: Size segment Flash.');
        Stop; exit;
       end;
       if not ReadFlashl55Boot($87FF70,16,buf[0]) then begin
        AddLinesLog(sBootErr);
        Stop; exit;
       end;
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then begin Stop;  exit;  end;
       buf[15]:=0;
       FormMobileName.EditName.Text:=Pchar(@buf[0]);
       FormMobileName.Top := Top+300;
       FormMobileName.Left := Left+140;
       ProgressBar.Position:=20;
       if FormMobileName.ShowModal <> mrOk then begin
        AddLinesLog('Cancel.');
        Stop; exit;
       end;
       ProgressBar.Position:=30;
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then begin Stop;  exit;  end;
       AddLinesLog('Read Flash seg: 0x'+IntToHex(addr,6)+' size: 0x'+IntToHex(size,6)+'...');
       if not ReadFlashl55Boot(addr,size,buf[0]) then begin
        AddLinesLog(sBootErr);
        Stop; exit;
       end;
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then begin Stop;  exit;  end;
       ProgressBar.Position:=50;
       sBlkFile:=GreateFileNameBackup(IntToHex(addr shr 16,2)+'-'+IntToHex(size shr 16,2)+'_')+'.bin';
       F:=TFileStream.Create(sBlkFile,fmCreate);
       F.Write(buf[0],size);
       F.Free;
       AddLinesLog('Segment backup in "'+sblkFile+ '" file.');
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then begin Stop;  exit;  end;

       FillChar(buf[$87FF70-addr],16,0);
       i:=Length(FormMobileName.EditName.Text);
       while(i>=1) do begin
         buf[$87FF6F-addr+dword(i)]:=Byte(FormMobileName.EditName.Text[i]);
         dec(i);
       end;
       ProgressBar.Position:=55;
       AddLinesLog('Write Flash seg: 0x'+IntToHex(addr,6)+' size: 0x'+IntToHex(size,6)+'...');
       Application.ProcessMessages;
       if (Not flgBootLoad) or flgBFBExit then begin Stop;  exit;  end;
       if not WriteSegFlashl55Boot(addr,size,buf[0]) then begin
        AddLinesLog(sBootErr);
        Stop; exit;
       end;
       AddLinesLog('Write New Name "'+pchar(@buf[$87FF70-addr])+'" - Ok.');
       ProgressBar.Position:=100;
      end;
      Stop;
end;

end.
