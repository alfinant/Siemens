//Использование в коммерческих целях запрещено.
//Наказание - неминуемый кряк и распространение по всему инет.
//Business application is forbidden.
//Punishment - unavoidable crack and propagation on everything inet.
unit x65psMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, IniFiles, FileCtrl, ShellApi, Registry,
  Menus, Spin, jpeg,

  About, ComPort, BFC, BFB, HexUtils, Boots65, CRC16, MD5,
  CryptEEP, HwProject, Bcore65, Bcore75, Bcore85, EEP, SWP;

  const
  WM_ThreadDoneMsg = WM_User + 8;
type
 T_CamParamVal = packed record
   id              : Integer;
   WhiteBalance    : Integer; // E_Camera_WhiteBalance;
   Brightness      : Integer; //BYTE;
   CompressionRate : Integer; //E_Camera_CompressionRate;
   ZoomFactor      : integer;  // 1,2,3,4,5
   ColorMode       : Integer; // E_Camera_ColorMode;
   FlashCondition  : Integer; // boolean;
   Resolution      : Integer;
 end;
  TFormMain = class(TForm)
    PageControl: TPageControl;
    TabSheetSetup: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    RadioGroupComPort: TRadioGroup;
    ButtonAbout: TButton;
    CheckBoxCabelPro: TCheckBox;
    GetInfo: TButton;
    StatusBar: TStatusBar;
    ButtonOff: TButton;
    ButtonSrvMode: TButton;
    ButtonBurnIn: TButton;
    ButtonNormalMode: TButton;
    ButtonSrvToNorm: TButton;
    ButtonRccpToBFC: TButton;
    ButtonBfcToAT: TButton;
    CheckBoxLight: TCheckBox;
    ButtonDispLight: TButton;
    ButtonKbdLight: TButton;
    MemoInfo: TMemo;
    ButtonSimSim: TButton;
    Panel2: TPanel;
    ButtonBFCtoBFB: TButton;
    ButtonBFBtoBFC: TButton;
    ButtonOpenAll: TButton;
    ProgressBar: TProgressBar;
    ButtonTstDisp1: TButton;
    ButtonTstDisp2: TButton;
    ButtonKeyOn: TButton;
    SaveDialog: TSaveDialog;
    ButtonX65flasher: TButton;
    Label16: TLabel;
    TabSheet3: TTabSheet;
    Panel4: TPanel;
    Label15: TLabel;
    ButtonInvalidateInstanceFFS: TButton;
    ButtonInvalidateInstanceFFS_B: TButton;
    Label17: TLabel;
    Label18: TLabel;
    Panel5: TPanel;
    Label19: TLabel;
    ButtonInvalidateInstanceFFS_C: TButton;
    TabSheet4: TTabSheet;
    Panel6: TPanel;
    GroupBox1: TGroupBox;
    EditFreezeIMEI: TEdit;
    Label21: TLabel;
    ButtonFreeze: TButton;
    ButtonSetFreeze: TButton;
    ButtonCpySetFreeze: TButton;
    ButtonStatusOTP: TButton;
    ButtonLockOtp: TButton;
    Label22: TLabel;
    ButtonGetOtpEsn: TButton;
    ButtonGetOtpImei: TButton;
    ButtonReadBcore: TButton;
    OpenDialog: TOpenDialog;
    ButtonRdEepBkey: TButton;
    ButtonFind5122: TButton;
    TabSheet5: TTabSheet;
    Panel7: TPanel;
    Label6: TLabel;
    Timer500: TTimer;
    Label27: TLabel;
    Label28: TLabel;
    RadioGroupSpeed: TRadioGroup;
    CheckBoxPause: TCheckBox;
    CheckBoxNew5121: TCheckBox;
    CheckBoxSetVDown: TCheckBox;
    CheckBoxClrEEFULL: TCheckBox;
    CheckBoxClrEELITE: TCheckBox;
    CheckBoxClrExit: TCheckBox;
    CheckBoxClrBcor: TCheckBox;
    ButtonBootInfo: TButton;
    CheckBoxBackup: TCheckBox;
    SpinEditVerDown: TSpinEdit;
    CheckBoxSBA: TCheckBox;
    CheckBoxRdFF: TCheckBox;
    ButtonTest: TButton;
    CheckBoxFreia: TCheckBox;
    Label29: TLabel;
    CheckBoxReCalkFull: TCheckBox;
    CheckBoxNewBcore: TCheckBox;
    CheckBoxRdOTP: TCheckBox;
    CheckBoxTestBus: TCheckBox;
    CheckBoxRdCFI: TCheckBox;
    CheckSaveInfo: TCheckBox;
    CheckBoxSaveEEP: TCheckBox;
    Button1: TButton;
    CheckBoxTest: TCheckBox;
    Label10: TLabel;
    Label26: TLabel;
    ButtonFullESN: TButton;
    Buttonpx65v4: TButton;
    CheckBoxTstRam: TCheckBox;
    TabSheet1: TTabSheet;
    Panel3: TPanel;
    ButtonXBI: TButton;
    Label7: TLabel;
    Label12: TLabel;
    ButtonRecalkFF: TButton;
    TabSheet6: TTabSheet;
    Panel8: TPanel;
    GroupBox4: TGroupBox;
    CamWhiteBalance: TRadioGroup;
    CamCompressionRate: TRadioGroup;
    CamZoomFactor: TRadioGroup;
    CamColorMode: TRadioGroup;
    CamFlashCondition: TCheckBox;
    CameraPicResolution: TRadioGroup;
    GroupBox2: TGroupBox;
    ScrollBarBrigh: TScrollBar;
    LabelBrightness: TLabel;
    GroupBox3: TGroupBox;
    SpinEditTO: TSpinEdit;
    ButtonStartCamera: TButton;
    ButtonShowFormCam: TButton;
    CheckBoxAutoSaveJpeg: TCheckBox;
    GroupBox5: TGroupBox;
    IMEI: TLabel;
    EditIMEI: TEdit;
    ButtonGetCode: TButton;
    ButtonCalkESN: TButton;
    EditESN: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    EditHASH: TEdit;
    Label3: TLabel;
    EditSkey: TEdit;
    ButtonCalkSkey: TButton;
    ButtonHash: TButton;
    ButtonSendSkey: TButton;
    ButtonCloseSkey: TButton;
    EditBootKey: TEdit;
    Label4: TLabel;
    Label14: TLabel;
    SpinEditHWID: TSpinEdit;
    GroupBox6: TGroupBox;
    ButtonPVVKD: TButton;
    ButtonX65VKD1: TButton;
    ButtonX65VKD2: TButton;
    GroupBox7: TGroupBox;
    ButtonSave512x: TButton;
    ButtonFreaLog: TButton;
    All: TComboBox;
    Label5: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    ButtonClearBcore: TButton;
    Button5: TButton;
    GroupBox8: TGroupBox;
    SpinEditContrast: TSpinEdit;
    SpinEditVrefContrast: TSpinEdit;
    ButtonSetContrast: TButton;
    ButtonWrContrast: TButton;
    ButtonRdContrast: TButton;
    GroupBox9: TGroupBox;
    ButtonBlk71: TButton;
    Button5005: TButton;
    Button5008: TButton;
    ButtonCalkMkey: TButton;
    ButtonSaveAllEEP: TButton;
    ButtonExtractXBZ: TButton;
    Bevel3: TBevel;
    ButtonBPinIni: TButton;
    GroupBox10: TGroupBox;
    ButtonMicRecOn: TButton;
    ButtonSineOff: TButton;
    GroupBox11: TGroupBox;
    ButtonCrWSwup: TButton;
    CheckBoxNewS: TCheckBox;
    ButtonX75VKD: TButton;
    RadioGroupBootType: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonAboutClick(Sender: TObject);
    procedure GetInfoClick(Sender: TObject);
    procedure ButtonOffClick(Sender: TObject);
    procedure ButtonSrvModeClick(Sender: TObject);
    procedure ButtonBurnInClick(Sender: TObject);
    procedure ButtonNormalModeClick(Sender: TObject);
    procedure ButtonSrvToNormClick(Sender: TObject);
    procedure ButtonRccpToBFCClick(Sender: TObject);
    procedure ButtonBfcToATClick(Sender: TObject);
    procedure ButtonDispLightClick(Sender: TObject);
    procedure ButtonKbdLightClick(Sender: TObject);
    procedure ButtonSimSimClick(Sender: TObject);
    procedure ButtonGetCodeClick(Sender: TObject);
    procedure ButtonBFCtoBFBClick(Sender: TObject);
    procedure ButtonBFBtoBFCClick(Sender: TObject);
    procedure ButtonCloseSkeyClick(Sender: TObject);
    procedure ButtonSendSkeyClick(Sender: TObject);
    procedure ButtonCalkSkeyClick(Sender: TObject);
    procedure ButtonTstDisp1Click(Sender: TObject);
    procedure ButtonTstDisp2Click(Sender: TObject);
    procedure ButtonKeyOnClick(Sender: TObject);
    procedure ButtonOpenAllClick(Sender: TObject);
    procedure ButtonFreaLogClick(Sender: TObject);
    procedure ButtonX65flasherClick(Sender: TObject);
    procedure ButtonX65VKD1Click(Sender: TObject);
    procedure ButtonX65VKD2Click(Sender: TObject);
    procedure ButtonHashClick(Sender: TObject);
    procedure EditIMEIChange(Sender: TObject);
    procedure ButtonSaveCfgClick(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure ButtonSave512xClick(Sender: TObject);
    procedure Label16Click(Sender: TObject);
    procedure ButtonPVVKDClick(Sender: TObject);
    procedure ButtonInvalidateInstanceFFSClick(Sender: TObject);
    procedure ButtonInvalidateInstanceFFS_CClick(Sender: TObject);
    procedure ButtonInvalidateInstanceFFS_BClick(Sender: TObject);
    procedure ButtonSetFreezeClick(Sender: TObject);
    procedure ButtonCpySetFreezeClick(Sender: TObject);
    procedure ButtonFreezeClick(Sender: TObject);
    procedure ButtonStatusOTPClick(Sender: TObject);
    procedure ButtonLockOtpClick(Sender: TObject);
    procedure ButtonGetOtpEsnClick(Sender: TObject);
    procedure ButtonGetOtpImeiClick(Sender: TObject);
    procedure ButtonReadBcoreClick(Sender: TObject);
    procedure ButtonClearBcoreClick(Sender: TObject);
    procedure ButtonEEP52Click(Sender: TObject);
    procedure ButtonRdEepBkeyClick(Sender: TObject);
    procedure ButtonFind5122Click(Sender: TObject);
    procedure ButtonBootInfoClick(Sender: TObject);
    procedure CheckBoxSetVDownClick(Sender: TObject);
    procedure CheckBoxClrBcorClick(Sender: TObject);
    procedure Timer500Timer(Sender: TObject);
    procedure CheckBoxNew5121Click(Sender: TObject);
    procedure CheckBoxClrEEFULLClick(Sender: TObject);
    procedure ButtonTestClick(Sender: TObject);
    procedure CheckBoxRdFFClick(Sender: TObject);
    procedure CheckBoxFreiaClick(Sender: TObject);
    procedure CheckBoxClrEELITEClick(Sender: TObject);
    procedure ButtonRdContrastClick(Sender: TObject);
    procedure ButtonWrContrastClick(Sender: TObject);
    procedure ButtonSetContrastClick(Sender: TObject);
    procedure CheckBoxReCalkFullClick(Sender: TObject);
    procedure Button5008Click(Sender: TObject);
    procedure EditFreezeIMEIChange(Sender: TObject);
    procedure CheckBoxNewBcoreClick(Sender: TObject);
    procedure ButtonCalkESNClick(Sender: TObject);
    procedure ButtonCalkMkeyClick(Sender: TObject);
    procedure Label26Click(Sender: TObject);
    procedure ButtonBlk71Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ButtonSaveAllEEPClick(Sender: TObject);
    procedure Button5005Click(Sender: TObject);
    procedure ButtonFullESNClick(Sender: TObject);
    procedure Buttonpx65v4Click(Sender: TObject);
    procedure CheckBoxTstRamClick(Sender: TObject);
    procedure CheckBoxTestBusClick(Sender: TObject);
    procedure ButtonXBIClick(Sender: TObject);
    procedure AddLinesLog(s: string);
    function CreateFactoryEEPblks : boolean;
    procedure ReCalkKeysData(idblk : byte; var buf : array of byte);
    procedure ButtonRecalkFFClick(Sender: TObject);
    procedure ButtonGetCamClick(Sender: TObject);
    procedure ScrollBarBrighChange(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure ButtonShowFormCamClick(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure ButtonMicRecOnClick(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure ButtonExtractXBZClick(Sender: TObject);
    procedure ButtonCrWSwupClick(Sender: TObject);
    procedure ButtonBPinIniClick(Sender: TObject);
    procedure ButtonSineOffClick(Sender: TObject);
    procedure ButtonX75VKDClick(Sender: TObject);
    procedure RadioGroupBootTypeClick(Sender: TObject);
private
    { Private declarations }
    function GetMobileInfo:boolean;
    function  SrvBoot(mode:eSRV_BOOT;PhoneOff:boolean):boolean;
    function ComOpen : boolean;
    procedure ComClose;
    function RdbCom(buf : pointer; size : dword): boolean;
    function CalkSkey(xesn,xskey:dword): boolean;
    function CalkESN(xskey:dword;var xESN:dword): boolean;
    function TestSkey(flgTstBkey:boolean): boolean;
    function ReadNewImeiIni: boolean;
    procedure CalkHashAndBkey(xskey,xesn:Dword);
    function InvalidateInstance(sFFS: string): boolean;
    function  ReadESNAndHASH : dword;
    procedure TestRegKeys;
    function TpInfoBoot(comoff:boolean):boolean;
    function ReadBlkEEFULL(num,base,size: dword; var buf: array of byte; var len: integer): boolean;
    function EEBlkSearch(num,base,size: dword; var buf: array of byte; var len: integer;var addr: dword): boolean;
    function BootReadBase(var addr: dword): boolean;
    function BootReadBlkX(cmd: byte ; addr, size: dword; var buf: array of byte): boolean;
    function BootReadBlk(addr, size: dword; var buf: array of byte): boolean;
    function BootReadOTP(addr, size: dword; var buf: array of byte): boolean;
    function BootReadCFI(addr, size: dword; var buf: array of byte): boolean;
    function BootTestFFBlk(addr, size: dword; var ffok: byte): boolean;
    function BootEraseBlk(addr, size: dword): boolean;
    function BootEraseBlk_(addr: dword): boolean;
    function BootPatchBlk(addr,size: dword; var buf: array of byte): boolean;
    function BootPatchBlk_(seg,len,addr,size: dword; var buf: array of byte): boolean;
    function BootWriteFlash(addr,size: dword; var buf: array of byte): boolean;
    function BootWriteFlash_(addr,size: dword; var buf: array of byte): boolean;
    function BootWriteMem(addr,size: dword; var buf: array of byte): boolean;
    function BootGoto(addr: dword ): boolean;
    function BootRamTest(var erraddr: dword; step : integer): boolean;
    function SetComMinTime:boolean;
    function SetComMaxTime:boolean;
    procedure WatchDogOn;
    procedure WatchDogOff;
    function WrbCom(buf : pointer; size : dword): boolean;    procedure BootEnd;
    function CreateSegBackup(addr:dword; sfn : string ; var buf : array of byte):boolean;
    function WriteEepBlock(num,len,ver: dword; buf: array of byte):boolean;
    function ReadEepBlock(num,len: dword; var ver: byte; var buf: array of byte): boolean;
    function EEFULLtab(base: dword): boolean;
    function ReadAllEEPBFC : boolean;
    function StrOtpImei(var s : string) : boolean;
    function ReadCameraToMemStream : boolean;
    procedure NewCamParams;
    function CheckCameraParameters : boolean;
    function SetCameraParameters : boolean;
    function TakeCameraPicture : boolean;
    procedure ErrEndCamClick;
    function SaveJpegCamera : boolean;
    function AutoSaveJpegCamera : boolean;
    function ClearBCoreBuf(var buf : array of byte): boolean;
//    procedure AddLinesLog(s: string);
public
    { Public declarations }
    FixPage : integer;
    sDevMan,sPhoneModel,sSoftWareVer,sLgVer,sIMEI : string;
    HASH : array[0..15] of Byte;
    BootKey : array[0..15] of Byte;
    SKey : dword;
    Mkey : array[0..5] of dword;
    hffile : integer;
    CamParams : T_CamParamVal;
    CameraMemStream : TMemoryStream;
  end;
const
  PanelCom = 0;
  PanelInf = 1;
  PanelCmd = 2;
  PanelErr = 1;
var
  FormMain: TFormMain;
  IniFile : TIniFile = nil;
  IniFileX : TIniFile = nil;
  IniFileName : string = '.\x65PS.ini';
  fDebug : boolean = false;
// бут инфо флаги
  fBtHASH : boolean;// = True;
  fBtEsn  : boolean;// = True;
  fBtImei : boolean;// = True;
  fBtoImei : boolean;// = True;
  fBtClr  : boolean;// = False;
  TabBootComSpd : array[0..8] of integer =
  ( 57600,115200,230400,460800,614400,921600,1228800,1600000,1500000 );
  TabAddrEEFULL : array[0..6] of DWORD =
  ($A0220000,$A0240000,$A1FC0000,$A1FE0000,$A3FA0000,$A3FC0000,0); // S75!?
  TabAddrEELITE : array[0..3] of DWORD =
  ($A0FE0000,$A0020000,$A0040000,0);  // S75!?
  TabblkEEFULL : array[0..6] of DWORD =(
  8,9,77,121,122,123,0); // + 5000
  TabblkEELITE : array[0..1] of DWORD =(
  76,0); // + 000
  WarnKey : byte = $80;
  BootInfo : rHeadBootInfo;
  {$include ChaosBoots.pas}
  deletedeep,workeep : integer;
  xmeep : byte; // маска найденных блоков eep


implementation

uses Blk5005, Bin2xbi, FCamera;

{$R *.DFM}

var
  WatchDog: boolean = False;
  WatchDogCount : integer;

procedure TFormMain.FormCreate(Sender: TObject);
var
i : integer;
begin
   PageControl.ActivePageIndex:=0;
   FixPage:=-1;
   if IniFile = nil then IniFile := TIniFile.Create(IniFileName);
   if IniFile.ReadString('System','Version','') = '' then begin
     IniFile.WriteString('System','Version',Caption);
     IniFile.WriteInteger('System','ComBaud',iComBaud);
     IniFile.WriteInteger('Setup','ComPort',iComNum);
   end
   else begin
     IniFile.WriteString('System','Version',Caption);
   end;
   for i:=0 to 5 do Mkey[i]:=IniFile.ReadInteger('System','Mkey'+IntToStr(i),12345678);
   iComNum := IniFile.ReadInteger('Setup','ComPort',iComNum);
   iComBaud := IniFile.ReadInteger('System','ComBaud',iComBaud);
   i :=IniFile.ReadInteger('Setup','BootComBaud',RadioGroupSpeed.ItemIndex);
   if (i < 0) or (i > 8) then RadioGroupSpeed.ItemIndex:=1
   else RadioGroupSpeed.ItemIndex:=i;
   sIMEI:=IniFile.ReadString('Setup','IMEI',EditIMEI.Text);
   flgExit:=False;
   EditIMEI.Text:=sIMEI;
   CheckBoxCabelPro.Checked:=IniFile.ReadBool('Setup','CabelPro',CheckBoxCabelPro.Checked);
   CheckBoxLight.Checked:=IniFile.ReadBool('Setup','SrvLightOn',CheckBoxLight.Checked);
   fDebug := IniFile.ReadBool('System','Debug', fDebug);
   Top := IniFile.ReadInteger('Setup','Top',100);
   Left := IniFile.ReadInteger('Setup','Left',100);
   i := IniFile.ReadInteger('Setup','Width',610);
   if (i < Constraints.MinWidth) or (i > Screen.DesktopWidth) then Width:=Constraints.MinWidth
   else Width:=i;
//   Constraints.MaxHeight:=449;
//   Constraints.MinHeight:=449;
//   ClientHeight:=PageControl.Height+ProgressBar.Height+StatusBar.Height;
   if Screen.DesktopHeight <= Top then Top := Screen.DesktopHeight shr 1;
   if Screen.DesktopWidth <= Left then Left := Screen.DesktopWidth shr 1;
   RadioGroupComPort.ItemIndex:=iComNum-1;
   CheckBoxPause.Checked := IniFile.ReadBool('Setup','TPPause',True);
   CheckBoxSaveEEP.Checked := IniFile.ReadBool('Setup','SaveEEP',True);
   CheckBoxSetVDown.Checked := IniFile.ReadBool('Setup','SetDown',False);
   CheckBoxClrEEFULL.Checked := IniFile.ReadBool('Setup','ClrEEFULL',False);
   CheckBoxClrEELITE.Checked := IniFile.ReadBool('Setup','ClrEELITE',False);
   CheckBoxClrExit.Checked := IniFile.ReadBool('Setup','ClrEXIT',False);
   CheckBoxClrBcor.Checked := {IniFile.ReadBool('Setup','ClrBCORE',}False{)};
   CheckBoxSBA.Checked := IniFile.ReadBool('Setup','SBTA',False);
   CheckBoxNew5121.Checked := IniFile.ReadBool('Setup','NewMaster',False);
   CheckBoxFreia.Checked := IniFile.ReadBool('Setup','Freia',False);
   CheckBoxReCalkFull.Checked := IniFile.ReadBool('Setup','ReCalk',False);
   CheckBoxBackup.Checked := IniFile.ReadBool('Setup','BackupOn',True);
   CheckBoxNewBcore.Checked := IniFile.ReadBool('Setup','NewBCORE',False);
   i := IniFile.ReadInteger('Setup','VerDown',1);
   if (i > 0) and (i < 101) then SpinEditVerDown.Value:=i
   else SpinEditVerDown.Value:=0;
// Camera
   i := IniFile.ReadInteger('Camera','WhiteBalance',CamWhiteBalance.ItemIndex);
   if (i >= 0) and (i <= 2) then CamWhiteBalance.ItemIndex:=i
   else CamWhiteBalance.ItemIndex:=0;
   i := IniFile.ReadInteger('Camera','CompressionRate',CamCompressionRate.ItemIndex);
   if (i >= 0) and (i <= 2) then CamCompressionRate.ItemIndex:=i
   else CamCompressionRate.ItemIndex:=0;
   i := IniFile.ReadInteger('Camera','JpegResolution',CameraPicResolution.ItemIndex);
   if (i >= 0) and (i <= 3) then CameraPicResolution.ItemIndex:=i
   else CameraPicResolution.ItemIndex:=0;
   i := IniFile.ReadInteger('Camera','ColorMode',CamColorMode.ItemIndex);
   if (i >= 0) and (i <= 2) then CamColorMode.ItemIndex:=i
   else CamColorMode.ItemIndex:=0;
   i := IniFile.ReadInteger('Camera','ZoomFactor',CamZoomFactor.ItemIndex);
   if (i >= 0) and (i <= 4) then CamZoomFactor.ItemIndex:=i
   else CamZoomFactor.ItemIndex:=0;
   i := IniFile.ReadInteger('Camera','Brigh',ScrollBarBrigh.Position);
   if (i >= ScrollBarBrigh.min) and (i <= ScrollBarBrigh.max) then ScrollBarBrigh.Position:=i
   else ScrollBarBrigh.Position:=50;
   i := IniFile.ReadInteger('Camera','Pause',SpinEditTO.Value);
   if (i >= SpinEditTO.MinValue) and (i <= SpinEditTO.MaxValue) then SpinEditTO.Value:=i
   else SpinEditTO.Value:=10;
   i := IniFile.ReadInteger('Setup','PhoneType',0);
   if (i < 3) and (i > 0) then RadioGroupBootType.ItemIndex := i
   else RadioGroupBootType.ItemIndex := 0;
   CamFlashCondition.Checked:=IniFile.ReadBool('Camera','Flash',CamFlashCondition.Checked);
   CheckBoxAutoSaveJpeg.Checked:=IniFile.ReadBool('Camera','AutoSave',CheckBoxAutoSaveJpeg.Checked);
////
end;

procedure TFormMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if IniFile <> nil then begin
     IniFile.WriteInteger('Setup','ComPort',RadioGroupComPort.ItemIndex+1);
     IniFile.WriteInteger('Setup','BootComBaud',RadioGroupSpeed.ItemIndex);
// Camera
     IniFile.WriteInteger('Camera','WhiteBalance',CamWhiteBalance.ItemIndex);
     IniFile.WriteInteger('Camera','CompressionRate',CamCompressionRate.ItemIndex);
     IniFile.WriteInteger('Camera','JpegResolution',CameraPicResolution.ItemIndex);
     IniFile.WriteInteger('Camera','ColorMode',CamColorMode.ItemIndex);
     IniFile.WriteInteger('Camera','ZoomFactor',CamZoomFactor.ItemIndex);
     IniFile.WriteInteger('Camera','Brigh',ScrollBarBrigh.Position);
     IniFile.WriteInteger('Camera','Pause',SpinEditTO.Value);
     IniFile.WriteBool('Camera','Flash',CamFlashCondition.Checked);
     IniFile.WriteBool('Camera','AutoSave',CheckBoxAutoSaveJpeg.Checked);
////
//     IniFile.WriteString('Setup','IMEI',EditIMEI.Text);
     IniFile.WriteBool('Setup','CabelPro',CheckBoxCabelPro.Checked);
     IniFile.WriteBool('Setup','SrvLightOn',CheckBoxLight.Checked);
     IniFile.WriteBool('Setup','TPPause',CheckBoxPause.Checked);
     IniFile.WriteBool('Setup','SaveEEP',CheckBoxSaveEEP.Checked);
     IniFile.WriteBool('Setup','NewMaster',CheckBoxNew5121.Checked);
     IniFile.WriteBool('Setup','SetDown',CheckBoxSetVDown.Checked);
     IniFile.WriteBool('Setup','ClrEEFULL',CheckBoxClrEEFULL.Checked);
     IniFile.WriteBool('Setup','ClrEELITE',CheckBoxClrEELITE.Checked);
     IniFile.WriteBool('Setup','ClrEXIT',CheckBoxClrExit.Checked);
     IniFile.WriteBool('Setup','ReCalk',CheckBoxReCalkFull.Checked);
//     IniFile.WriteBool('Setup','ClrBCORE',CheckBoxClrBcor.Checked);
     IniFile.WriteBool('Setup','BackupOn',CheckBoxBackup.Checked);
     IniFile.WriteBool('Setup','SBTA',CheckBoxSBA.Checked);
     IniFile.WriteBool('Setup','Freia',CheckBoxFreia.Checked);
     IniFile.WriteBool('Setup','NewBCORE',CheckBoxNewBcore.Checked);
     IniFile.WriteInteger('Setup','PhoneType',RadioGroupBootType.ItemIndex);

     IniFile.WriteInteger('Setup','VerDown',SpinEditVerDown.Value);
     IniFile.WriteInteger('Setup','Top',Top);
     IniFile.WriteInteger('Setup','Left',Left);
     IniFile.WriteInteger('Setup','Width',Width);
     IniFile.UpdateFile;
     IniFile.Free;
     CloseCom;
   end;
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

procedure TFormMain.AddLinesLog(s: string);
begin
  MemoInfo.Lines.Add(s);
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

function TFormMain.ReadNewImeiIni: boolean;
var
i : integer;
begin
        if Length(sIMEI)=15 then begin
          EditESN.Text:=IniFile.ReadString(sIMEI,'ESN','?');
          EditHash.Text:=IniFile.ReadString(sIMEI,'HASH','?');
          if length(EditHash.Text)=32 then HexTopByte(@EditHash.Text[1],16,@HASH);
          SKEY:=IniFile.ReadInteger(sIMEI,'SKEY',0);
          EditSkey.Text:=IniFile.ReadString(sIMEI,'SKEY','?');
          EditBootKey.Text:=IniFile.ReadString(sIMEI,'BKEY','?');
          if length(EditBootKey.Text)=32 then HexTopByte(@EditBootKey.Text[1],16,@BootKey);
          for i:=0 to 5 do begin
           Mkey[i]:=IniFile.ReadInteger(sIMEI,'Mkey'+IntToStr(i),-1);
           if Mkey[i]>99999999 then Mkey[i]:=IniFile.ReadInteger('System','Mkey'+IntToStr(i),12345678);
          end;
          result:=True;
        end
        else  result:=False;
end;

function TFormMain.ComOpen : boolean;
begin
        result:=False;
        bSecyrMode:=0;
        bTelMode:=$FF;
        iComNum := RadioGroupComPort.ItemIndex+1;
        if OpenCom(CheckBoxSBA.Checked) then begin
         StatusBar.Panels[PanelCom].Text:='Com'+IntToStr(iComNum);
         sleep(300);
         if not CheckBoxCabelPro.Checked then begin
          WriteComStr('AT^SQWE=1'^M);
          ReadBFC;
         end;
         if BFC_InitHost($01)<>ERR_NO then begin
           if BFC_InitHost($01)<>ERR_NO then begin
             ComClose;
             StatusBar.Panels[PanelCmd].Text:='Нет ответа от телефона!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             AddLinesLog('Проверьте номер порта, кабель, телефон, mode!');
           end
           else result:=True;
         end
         else result:=True;
        end
        else begin
         StatusBar.Panels[PanelCom].Text:='Com?';
         AddLinesLog('Не открыть порт Com'+IntToStr(iComNum)+' ('+IntToStr(iComBaud)+' Baud)! ');
         StatusBar.Panels[PanelCmd].Text:='Не открыть Com'+IntToStr(iComNum)+'!';
         StatusBar.Panels[PanelInf].Text:='';
        end;
end;

procedure TFormMain.ComClose;
begin
        CloseCom; oldhost:=0;
        if flgExit and (Length(sExit)<>0) then begin
          AddLinesLog('Телефон выключился по ошибке:');
          AddLinesLog(sExit);
          sExit:='';
          flgExit:=False;
        end;
end;

function TFormMain.GetMobileInfo:boolean;
var
u : word;
begin
        result:=True;
        sDevMan:=BFC_GetDevMan;
        if BFC_Error=ERR_NO then begin
         AddLinesLog('Получение информации:');
        end;
        if not flgExit then begin
         sPhoneModel:=BFC_GetPhoneModel;
         sSoftWareVer:=BFC_GetSoftWareVer;
         sLgVer:=BFC_GetLgVer;
         if BFC_Error=ERR_NO then begin
          AddLinesLog('Model: '+sDevMan+' '+sPhoneModel+' '+sSoftWareVer+' '+sLgVer);
         end;
         AddLinesLog('Телефон находится в "'+BFC_CurentMode+'"');
         sIMEI:=BFC_GetIMEI;
         if BFC_Error=ERR_NO then begin
          IniFile.WriteString('Setup','IMEI',sIMEI);
          IniFile.WriteString(sIMEI,'Phone',sDevMan+' '+sPhoneModel+' '+sSoftWareVer+' '+sLgVer);
         end
         else begin
          sIMEI:='?';
          result:=False;
         end;
         AddLinesLog('IMEI: '+sIMEI);
         StatusBar.Panels[PanelCmd].Text:=BFC_GetSecurityMode;
         if BFC_Error=ERR_NO then AddLinesLog('SecurityStatus: '+StatusBar.Panels[PanelCmd].Text);
         SpinEditHWID.Value:=BFC_GetHardwareIdentification;
         if BFC_Error=ERR_NO then begin
          AddLinesLog('HWID: '+IntToStr(SpinEditHWID.Value));
          u:=StrToHwID(@sPhoneModel[1]);
          if u<>SpinEditHWID.Value then begin
           AddLinesLog('Внимание: Несоответствие HWID и названия телефона!');
          end;
          if result then IniFile.WriteInteger(sIMEI,'HWID',SpinEditHWID.Value);
         end
         else begin
          SpinEditHWID.Value:=HW_IDNONE;
          result:=False;
         end;
         if BFC_GetCurentUbat(u) then begin
          if u<3695 then AddLinesLog('Внимание: Зарядите аккумулятор!');
          AddLinesLog('Напряжение аккумулятора: '+ IntToStr(u)+' mV.');
          if u>4300 then AddLinesLog('Внимание: Неверные настройки аккумулятора!');
         end;
        end else result:=False;
        if not result then StatusBar.Panels[PanelErr].Text:='Ошибка получения инфо!'
        else begin
         StatusBar.Panels[PanelInf].Text:=sDevMan+' '+sPhoneModel+' '+sSoftWareVer+' '+sLgVer+' '+sIMEI;
//         if (not flagdpmenu)
//         and (bTelMode=bSecyrMode) // $12=$12 !
//         then HardLock;
        end;
        EditIMEI.Text:=sIMEI;
end;

procedure TFormMain.GetInfoClick(Sender: TObject);
const
setpgic = 7;
var
buf : array[0..15] of word;
bufd : array[0..8] of dword;
bufb : array[0..95] of byte;
i : integer;
addr, len : dword;
b,ver : byte;
ch : char;
sText : string;
Operate,TalkTime: dword;
freeb,freea,freed : dword;
begin
      ProgressBar.Position:=setpgic;
      if ComOpen then begin
        ProgressBar.StepBy(setpgic);
        if GetMobileInfo then ProgressBar.StepBy(setpgic);
        if BFC_GetSecurityInfo(Buf,SizeOf(buf)) then begin
         AddLinesLog('Дополнительная информация:');
         i:=1;
         while i<=Buf[0] do begin
          case Buf[i] of
           $04: sText:='OTP область открыта для записи';
           $05: sText:='OTP область закрыта для записи';
           $08: sText:='BootKEY неизвестен';
           $09: sText:='BootKEY записан в EEPROM';
           $0A: sText:='Запись BootKEY отсутствует в EEPROM';

           $0C: sText:='Ключи отсутствуют в BCORE (чист)';
           $0D: sText:='Ключи прописаны в BCORE';
           $0E: sText:='Отсутствие таблицы ссылок на команды';

           $10: sText:='BFC функции недоступны';
           $11: sText:='Сервисный доступ к BFC функциям';
           $12: sText:='Полный доступ к BFC функциям';
//           $13: sText:='Полный доступ к BFC функциям?'; A55="X"
           $15: sText:='Полный режим (не СЦ)';
           $16: sText:='Режим СЦ "S"';

           $18: sText:='Блок 76 пустой';
           $19: sText:='Контроль включен';
           $1A: sText:='Блок 76 доступен';
           $1B: sText:='Блок 76 не найден';

           $1C: sText:='Отсутствие блока 5123';
           $1D: sText:='Блоки 512x присутствуют';
           $1E: sText:='Отсутствие блока 5121';
           $20: break;
           else sText:='?';
          end;
          AddLinesLog('Код('+IntToHex(Buf[i],2)+'): '+sText);
          inc(i);
         end;
        end;
        if BFC_EELITE_GetBufferInfo(freeb,freea,freed) then begin
         AddLinesLog('EELITE Инфо: free buffer '+IntToStr(freeb)+' bytes, free at all '+IntToStr(freea)+' bytes, free for deleted '+IntToStr(freed)+' bytes.');
         if freeb<8192 then AddLinesLog('Внимание! Необходима дефрагментация области EELITE!');
         ProgressBar.StepBy(setpgic);
         if BFC_EEFULL_GetBufferInfo(freeb,freea,freed) then begin
          AddLinesLog('EEFULL Инфо: free buffer '+IntToStr(freeb)+' bytes, free at all '+IntToStr(freea)+' bytes, free for deleted '+IntToStr(freed)+' bytes.');
          if freeb<6666 then AddLinesLog('Внимание! Желательна дефрагментация области EEFULL!');
          ProgressBar.StepBy(setpgic);
          if BFC_EE_Get_Block_Info(5005,len,ver) then begin
           ProgressBar.StepBy(setpgic);
           if (len<sizeof(bufb)) and (ver=1) then begin
            if BFC_EE_Read_Block(5005,0,len,bufb) then begin
             ProgressBar.StepBy(setpgic);
             if (bufb[$0B]<32)
             and (bufb[$0B]<>0)
             and ((bufb[$0C] shr 4)<>0)
             and ((bufb[$0C] shr 4)<13)
             then sText:='Date: '+Int2Digs(bufb[$0B],2)+'/'+Int2Digs(bufb[$0C] shr 4,2)+'/'+Int2Digs(bufb[$0C] and $0F,2)
             else sText:='Date: ??/??/??';
             if not VariantToInt(bufb[$12],ch,dword(i))
             then sText:=sText+', Variant: ? ???' // A 370
             else sText:=sText+', Variant: '+ch+' '+Int2Digs(i,2); // A 370
             sText:=sText
             +', Std-Map/SW: '+IntToStr(bufb[$0F])+'/'+IntToStr(bufb[$0E])
             +', D-Map/Prov.: '+IntToStr(bufb[$11])+'/'+IntToStr(bufb[$10]);  // 153/148
             AddLinesLog('МАП инфо: '+sText);
            end;
           end;
          end;
         end;
        end;
        if (bSecyrMode=$12) or (bSecyrMode=$13) then begin
         ProgressBar.StepBy(setpgic);
         if StrOtpImei(sText) then begin
          AddLinesLog(sText);
          ProgressBar.StepBy(setpgic);
         end;
         if RadioGroupBootType.ItemIndex<>2 then addr:=$A0000230
         else addr:=$A003E020;
         if BFCReadMem(addr,4,bufb) then begin
           if bufb[0]<>$FF then AddLinesLog('Минимальный номер прошивки: '+IntToHex(bufb[0],2)+'.');
           ProgressBar.StepBy(setpgic);
           if RadioGroupBootType.ItemIndex<>2 then addr:=$A0000890
           else addr:=$A0000C90;
           if BFCReadMem(addr,16,bufb) then begin
            if bufb[15]=$00 then AddLinesLog('BCORE версия: "'+Pchar(@bufb[0])+'".');
            ProgressBar.StepBy(setpgic);
           end;
         end;
        end
        else begin
         AddLinesLog('Для получения расширенной инфы - введите Skey в телефон!');
        end;
        if BFC_ReadOperateAndTalkTime(Operate,TalkTime) then begin
          AddLinesLog('Телефон наработал: '+IntToStr(Operate)+' сек.');
          AddLinesLog('Общее время разговоров: '+IntToStr(TalkTime)+' сек.');
          ProgressBar.StepBy(setpgic);
        end;
        if BFC_GetFlashTypes(Bufd,SizeOf(bufd)) then begin
         i:=0;
         while i<integer(Bufd[0]) do begin
          sText:='FlashID('+IntToStr(i+1)+') - Код завода: '+IntToHex(Bufd[i*2+1],4);
          if Bufd[i*2+1]=$0089 then sText:=sText+' (Intel)'
          else if Bufd[i*2+1]=$0004 then sText:=sText+' (AMD)';
          sText:=sText+', тип: '+IntToHex(Bufd[i*2+2],4);
          inc(i);
          if i<integer(Bufd[0]) then sText:=sText+','
          else sText:=sText+'.';
          AddLinesLog(sText);
         end;
         ProgressBar.StepBy(setpgic);
        end;
        if BFC_GetDisplayCount(b) then begin
//         if b>1 then sText:='Два дисплея'
//         else sText:='Один дисплей';
         if b<>0 then begin
          if BFC_GetDisplayType(1,ver) then begin
           sText:='DisplayID(1,'+IntToStr(ver)+'): ';
           if ver>=64 then ver:=0;
           sText:=sText+sDisplayController[ver];
           if b>1 then begin
            if BFC_GetDisplayType(2,ver) then begin
             sText:=sText+', DisplayID(2,'+IntToStr(ver)+'): ';
             if ver>=64 then ver:=0;
             sText:=sText+sDisplayController[ver];
            end;
           end;
           sText:=sText+'.';
           AddLinesLog(sText);
          end;
         end;
        end;
        ComClose;
        ProgressBar.Position:=100;
      end;
end;

procedure TFormMain.ButtonOffClick(Sender: TObject);
var
y : integer;
begin
      StatusBar.Panels[PanelCmd].Text:='Выключение телефона...';
      ButtonOff.Enabled:=False;
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      ProgressBar.Position:=5;
      if ComOpen then begin
        ProgressBar.Position:=10;
        if BFC_PhoneOff then begin
          StatusBar.Panels[PanelCmd].Text:='Телефон выключается...';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          y:=10;
          while (y<90) and (ERR_NO=BFC_InitHost($01)) do begin
           inc(y);
           ProgressBar.Position:=y;
           sleep(200);
          end;
          ComClose;
          StatusBar.Panels[PanelCmd].Text:='Телефон отключен!';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          ProgressBar.Position:=100;
        end
        else begin
         ComClose;
         StatusBar.Panels[PanelCmd].Text:='Ошибка!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        end;
      end;
      ButtonOff.Enabled:=True;
end;


function TFormMain.SrvBoot(mode:eSRV_BOOT;PhoneOff:boolean):boolean;
var
x,y,z : integer;
s : string;
b : BYTE;
begin
      result:=False;
      ProgressBar.Position:=5;
      StatusBar.Panels[PanelInf].Text:='';
      z:=$54415441;
      iComNum := RadioGroupComPort.ItemIndex+1;
      if OpenCom(CheckBoxSBA.Checked) then begin
        AddLinesLog('Тыкай кнопу!');
        ProgressBar.Position:=15;
        StatusBar.Panels[PanelCom].Text:='Com'+IntToStr(iComNum);
        AddLinesLog('Автозапуск...');
        for x:=0 to 7 do begin
          if x=7 then begin
            BFC_InitHost($01);
            if BFC_InitHost($19)<>ERR_NO then break
            else begin
              if not BFC_GetCurentMode(b) then break;
              case b of
               $03: s:='Charge Mode';
               $07: s:='BurnIn Mode';
               $12: s:='Normal Mode';
               $16: s:='Service Mode';
               $FE: s:='Формат дисков?';//'Format FFS or ?';
               else s:='Неизвестный режим ('+IntToHex(b,2)+')';//'Unknown Mode ('+IntToHex(b,2)+')';
              end;
              AddLinesLog('Бут не загружен!');
              if ((mode=SERVICE_MODE) and (b=$16))
              or ((mode=NORMAL_MODE) and (b=$12))
              or ((mode=BURNIN_MODE) and (b=$07))
              then begin
                StatusBar.Panels[PanelCmd].Text:='Телефон уже в "'+s+'".';
                AddLinesLog(StatusBar.Panels[PanelCmd].Text);
                ProgressBar.Position:=80;
                GetMobileInfo;
                ProgressBar.Position:=90;
                if CheckBoxLight.Checked then begin
                 BFC_SetLight(Display,0);
                 BFC_SetLight(Keyboard,0);
                end;
                ComClose;
                ProgressBar.Position:=100;
                result:=True;
                Exit;
              end
              else begin
                if (b=$FE) then begin
                 sleep(500);
                 if BFC_GetCurentMode(b) then begin
                  case b of
                   $03: s:='Charge Mode';
                   $07: s:='BurnIn Mode';
                   $12: s:='Normal Mode';
                   $16: s:='Service Mode';
                   $FE: s:='Формат дисков?';//'Format FFS or ?';
                   else s:='Неизвестный режим ('+IntToHex(b,2)+')';//'Unknown Mode ('+IntToHex(b,2)+')';
                  end;
                 end;
                end;
                if b=$03 then begin
                 AddLinesLog('Купите шнур с автостартом или лучше работайте за него!');
                end;
                StatusBar.Panels[PanelCmd].Text:='Телефон находится в "'+s+'"!';
                AddLinesLog(StatusBar.Panels[PanelCmd].Text);
                y:=0;
                if (PhoneOff and (b<>$FE)) or (b=$03) then begin
                 if BFC_PhoneOff then begin
                  StatusBar.Panels[PanelCmd].Text:='Телефон выключается...';
                  AddLinesLog(StatusBar.Panels[PanelCmd].Text);
                  ProgressBar.Position:=0;
                  while (y<100) and (ERR_NO=BFC_InitHost($01)) do begin
                   inc(y);
                   ProgressBar.Position:=y;
                   sleep(100);
                  end;
                  if y<100 then ProgressBar.Position:=100;
                  StatusBar.Panels[PanelCmd].Text:='Пробуйте снова.';
                  AddLinesLog(StatusBar.Panels[PanelCmd].Text);
                 end;
                end;
                ComClose;
                exit;
              end;
            end;
          end;
          WriteCom(@z,2);
          ProgressBar.StepBy(1);
          while ReadCom(@b,1) do begin
           if b=$C0 then begin
            NewSGold:=True;
            AddLinesLog('Внимание: Для новых "S"75 работа только в режиме Beta!');
            b:=$B0;
           end else NewSGold:=False;
           if b=$B0 then begin
            AddLinesLog('Передача boot...');
            if not SendSrvBoot(mode) then begin
             ComClose;
             StatusBar.Panels[PanelCmd].Text:='Бут не загружен!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             Exit;
            end
            else begin
             ProgressBar.Position:=50;
             case mode of
              SERVICE_MODE: AddLinesLog('Загрузка в "Сервисный режим" Ok');
              BURNIN_MODE: AddLinesLog('Загрузка в "Режим Проверки" Ok');
              NORMAL_MODE: AddLinesLog('Загрузка в "Нормальный режим" Ok');
             end;
             AddLinesLog('Ожидание включения телефона...');
             y:=0;
             for z:=0 to 50 do begin
              sleep(100);
              if BFC_InitHost($01)=ERR_NO then begin
               inc(y);
               Break;
              end;
              if flgExit then begin
               result:=False;
               ComClose;
               exit;
              end;
             end;
             if y=0 then begin
              StatusBar.Panels[PanelCmd].Text:='Нет ответа на Ping!';
              AddLinesLog(StatusBar.Panels[PanelCmd].Text);
              ComClose;
              Exit;
             end;
             for z:=0 to 10 do begin
              if ((mode=NORMAL_MODE) and (not CheckBoxCabelPro.Checked)) then WriteComStr('AT^SQWE=1'^M);
              if BFC_InitHost($11)=ERR_NO then begin
               inc(y);
               Break;
              end;
              if flgExit then begin
                result:=False;
                ComClose;
                exit;
              end;
              ProgressBar.StepBy(1);
             end;
             if y=0 then begin
              StatusBar.Panels[PanelCmd].Text:='Нет ответа от телефона!';
              AddLinesLog(StatusBar.Panels[PanelCmd].Text);
              ComClose;
              Exit;
             end;
             if mode=NORMAL_MODE then begin
              for z:=0 to 10 do begin
               sleep(300);
               ReadBfc;
               if flgExit then begin
                result:=False;
                ComClose;
                exit;
               end;
               ProgressBar.StepBy(1);
              end;
              for z:=0 to 10 do begin
               if not CheckBoxCabelPro.Checked then WriteComStr('AT^SQWE=1'^M);
               if BFC_InitHost($11)=ERR_NO then Break;
               ReadBfc;
               if flgExit then begin
                result:=False;
                ComClose;
                exit;
               end;
              end;
             end;
             ProgressBar.Position:=80;
             if flgExit then begin
              result:=False;
              ComClose;
              exit;
             end;
             GetMobileInfo;
             ProgressBar.Position:=90;
             if CheckBoxLight.Checked then begin
               BFC_SetLight(Display,0);
               BFC_SetLight(Keyboard,0);
             end;
             ComClose;
             ProgressBar.Position:=100;
             result:=True;
             Exit;
            end; // if not SendSrvBoot
           end; // if read $B0
          end; // while ReadCom
         end; // for x:=0 to 7
        if PhoneOff then BFC_PhoneOff;
        ComClose;
        StatusBar.Panels[PanelCmd].Text:='Нет ответа на загрузку!';
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        AddLinesLog('Проверьте номер порта, кабель, телефон, mode!');
      end
      else begin
         StatusBar.Panels[PanelCom].Text:='Com?';
         StatusBar.Panels[PanelCmd].Text:='Не открыть Com'+IntToStr(iComNum)+'!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      end;
end;

procedure TFormMain.ButtonSrvModeClick(Sender: TObject);
begin
      ButtonSrvMode.Enabled:=False;
      StatusBar.Panels[PanelCmd].Text:='Загрузка в "Сервисный режим"...';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      SrvBoot(SERVICE_MODE,True);
      ButtonSrvMode.Enabled:=True;
end;

procedure TFormMain.ButtonBurnInClick(Sender: TObject);
begin
      ButtonBurnIn.Enabled:=False;
      StatusBar.Panels[PanelCmd].Text:='Загрузка в "Режим проверки"...';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      SrvBoot(BURNIN_MODE,True);
      ButtonBurnIn.Enabled:=True;
end;

procedure TFormMain.ButtonNormalModeClick(Sender: TObject);
begin
      ButtonNormalMode.Enabled:=False;
      StatusBar.Panels[PanelCmd].Text:='Загрузка в "Нормальный режим"...';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      SrvBoot(NORMAL_MODE,True);
      ButtonNormalMode.Enabled:=True;
end;

procedure TFormMain.ButtonSrvToNormClick(Sender: TObject);
begin
      ProgressBar.Position:=10;
      if ComOpen then begin
        ProgressBar.Position:=55;
        if BFC_SwitchFromServiceToNormalMode then begin
         AddLinesLog('Переключение в "Нормальный режим"...');
         StatusBar.Panels[PanelCmd].Text:='Нормальный режим';
         ComClose;
         ProgressBar.Position:=100;
        end
        else begin
         StatusBar.Panels[PanelCmd].Text:='Ошибка!';
         ComClose;
        end;
      end;
end;

procedure TFormMain.ButtonRccpToBFCClick(Sender: TObject);
begin
      ProgressBar.Position:=10;
      iComNum := RadioGroupComPort.ItemIndex+1;
      if OpenCom(CheckBoxSBA.Checked) then begin
       ProgressBar.Position:=25;
       sleep(100);
       ProgressBar.Position:=40;
       sleep(100);
       ProgressBar.Position:=55;
       sleep(100);
       ProgressBar.Position:=70;
       StatusBar.Panels[PanelCom].Text:='Com'+IntToStr(iComNum);
       WriteComStr('AT^SQWE=1'^M);
       ReadBFC;
       ProgressBar.Position:=85;
       if BFC_InitHost($01)<>ERR_NO then begin
         StatusBar.Panels[PanelCmd].Text:='Нет ответа от телефона!';
         StatusBar.Panels[PanelInf].Text:='';
         ComClose;
       end
       else begin
         AddLinesLog('Протокол переключен в режим BFC команд');
         StatusBar.Panels[PanelCmd].Text:='BFC режим';
         ComClose;
         ProgressBar.Position:=100;
       end;
      end
      else begin
         StatusBar.Panels[PanelCom].Text:='Com?';
         StatusBar.Panels[PanelCmd].Text:='Не открыть Com'+IntToStr(iComNum)+'!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      end;
end;

procedure TFormMain.ButtonBfcToATClick(Sender: TObject);
begin
      ProgressBar.Position:=10;
      if ComOpen then begin
        ProgressBar.Position:=40;
        BFC_SendAT('AT^SQWE=2'+#$0D);
        if ReadBFC=ERR_NO then begin
         ProgressBar.Position:=80;
         AddLinesLog('Протокол переключен в AT режим');
         StatusBar.Panels[PanelCmd].Text:='AT режим';
         ComClose;
         ProgressBar.Position:=100;
        end
        else begin
         StatusBar.Panels[PanelCmd].Text:='Нет ответа от телефона!';
         ComClose;
        end;
      end;
end;

var
displight : byte = $0;
procedure TFormMain.ButtonDispLightClick(Sender: TObject);
begin
      ProgressBar.Position:=10;
      if ComOpen then begin
        ProgressBar.Position:=40;
        if displight=0 then displight:=$ff
        else displight:=0;
        if BFC_SetLight(Display,displight) then begin
         ProgressBar.Position:=80;
         if displight<>0 then begin
           AddLinesLog('Дисплейная подсветка включена');
           StatusBar.Panels[PanelCmd].Text:='Вкл.подсв.дисп.';
           ButtonDispLight.Caption:='Выкл.подсв.дисп.';
         end
         else begin
           AddLinesLog('Дисплейная подсветка выключена');
           StatusBar.Panels[PanelCmd].Text:='Выкл.подсв.дисп.';
           ButtonDispLight.Caption:='Вкл.подсв.дисп.';
         end;
         ComClose;
         ProgressBar.Position:=100;
        end
        else begin
         StatusBar.Panels[PanelCmd].Text:='Ошибка!';
         ComClose;
        end;
      end;
end;

var
keybdlight : byte = $0;
procedure TFormMain.ButtonKbdLightClick(Sender: TObject);
begin
      ProgressBar.Position:=10;
      if ComOpen then begin
        ProgressBar.Position:=40;
        if keybdlight=0 then keybdlight:=$ff
        else keybdlight:=0;
        if BFC_SetLight(Keyboard,keybdlight) then begin
         ProgressBar.Position:=80;
         if keybdlight<>0 then begin
           AddLinesLog('Клавиатурная подсветка включена');
           StatusBar.Panels[PanelCmd].Text:='Вкл.подс.клав.';
           ButtonKbdLight.Caption:='Выкл.подс.Клавы';
         end
         else begin
           AddLinesLog('Клавиатурная подсветка выключена');
           StatusBar.Panels[PanelCmd].Text:='Выкл.подс.клав.';
           ButtonKbdLight.Caption:='Вкл.подс.клав.';
           ComClose;
           ProgressBar.Position:=100;
         end;
        end
        else begin
         StatusBar.Panels[PanelCmd].Text:='Ошибка!';
         ComClose;
        end;
      end;

end;

procedure TFormMain.ButtonSimSimClick(Sender: TObject);
begin
      ProgressBar.Position:=10;
      if ComOpen then begin
        ProgressBar.Position:=60;
        if BFC_SimSim then begin
         StatusBar.Panels[PanelCmd].Text:='SimSim включен';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         ComClose;
         ProgressBar.Position:=100;
        end
        else begin
         StatusBar.Panels[PanelCmd].Text:='Ошибка!';
         ComClose;
        end;
      end;
end;

function TFormMain.ReadESNAndHASH : dword;
var
xESN : Dword;
addr : Dword;
begin
//       if RadioGroupBootType.ItemIndex<>2 then addr:=$A0000238
//       else addr:=$A003E400;
//       case SpinEditHWID.Value of
//        400 : addr:=$A000023C;
//       end;
//       addr:=$A0000238;
       if (bSecyrMode = $13) or (bSecyrMode = $12) or (bSecyrMode = $11) then begin
        AddLinesLog('(Полный BFC режим)');
        if BFC_GetESN(xESN) then begin
         AddLinesLog('ESN: '+IntToHex(xESN,8));
         EditESN.Text:=IntToHex(xESN,8);
         IniFile.WriteString(sIMEI,'ESN',EditESN.Text);
         StatusBar.Panels[PanelCmd].Text:='ESN: '+EditESN.Text;
         if BFCReadMem($A0000200,4,HASH) then begin
          if ((HASH[0]=$00) and (HASH[2]=$4C) and (HASH[3]=$53)) then begin
           if (HASH[1]=$02) then addr:=$A0000238
           else addr:=$A000023C;
          end
          else addr:=$A003E400;
          if BFCReadMem(addr,16,HASH) then begin
           EditHash.Text:=BufToHexStr(@HASH,16);
           AddLinesLog('HASH: '+EditHash.Text);
           IniFile.WriteString(sIMEI,'HASH',EditHash.Text);
           ProgressBar.Position:=100;
          end
          else begin
           StatusBar.Panels[PanelCmd].Text:='Не прочитать HASH!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           EditHash.Text:='?';
          end;
         end //if BFCReadMem($A0000200
         else begin
           StatusBar.Panels[PanelCmd].Text:='Не прочитать TabID!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           EditHash.Text:='?';
         end; //if BFCReadMem($A0000200
        end
        else begin
         StatusBar.Panels[PanelCmd].Text:='Не прочитать ESN!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         EditESN.Text:='?';
        end;
       end // if BFC mode On.
       else begin
        if BFC_to_BFB then begin
         if not BFB_Ping then if not BFB_Ping then BFB_Ping;
         if BFB_Error=BFB_OK then begin
          if BFB_GetESN(xESN) then begin
           AddLinesLog('ESN: '+IntToHex(xESN,8));
           EditESN.Text:=IntToHex(xESN,8);
           IniFile.WriteString(sIMEI,'ESN',EditESN.Text);
           StatusBar.Panels[PanelCmd].Text:='ESN: '+EditESN.Text;
           if BFBReadMem($A0000200,4,HASH) then begin
            if ((HASH[0]=$00) and (HASH[2]=$4C) and (HASH[3]=$53)) then begin
             if (HASH[1]=$02) then addr:=$A0000238
             else addr:=$A000023C;
            end
            else addr:=$A003E400;
            if BFBReadMem(addr,16,HASH) then begin
             EditHash.Text:=BufToHexStr(@HASH,16);
             AddLinesLog('HASH: '+EditHash.Text);
             IniFile.WriteString(sIMEI,'HASH',EditHash.Text);
             ProgressBar.Position:=100;
            end
            else begin
             StatusBar.Panels[PanelCmd].Text:='Не прочитать HASH!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             EditHash.Text:='?';
            end;
           end
           else begin
            StatusBar.Panels[PanelCmd].Text:='Не прочитать TabID!';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            EditHash.Text:='?';
           end;
          end
          else begin
           StatusBar.Panels[PanelCmd].Text:='Не прочитать ESN!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           EditESN.Text:='?';
          end;
         end //if no BFB_Error
         else begin
          StatusBar.Panels[PanelCmd].Text:='Ошибка перехода в режим BFB!';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          if StrToInt(sSoftWareVer)>35 then begin
           StatusBar.Panels[PanelCmd].Text:='Чтение ключей поддерживается до 36-ой версии!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          end;
         end;
        end // BFC_to_BFB
        else begin
         StatusBar.Panels[PanelCmd].Text:='Невозможно перейти в режим BFB!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         if StrToInt(sSoftWareVer)>35 then begin
           StatusBar.Panels[PanelCmd].Text:='Чтение ключей поддерживается до 36-ой версии!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         end;
        end; // BFC_to_BFB
        BFB_to_BFC;
//        ChangeComSpeed(115200);
       end; // if BFB mode On.
       result:=xESN;
end;

procedure TFormMain.ButtonGetCodeClick(Sender: TObject);
begin
     ButtonGetCode.Enabled:=False;
     ProgressBar.Position:=10;
     AddLinesLog('Получение кодов из телефона...');
     Repaint;
     if ComOpen then begin
      ProgressBar.Position:=33;
      GetMobileInfo;
      ProgressBar.Position:=66;
      if BFC_Error=ERR_NO then ReadESNAndHASH;
      ComClose;
      iComBaud:=115200;
     end;
     ButtonGetCode.Enabled:=True;
end;

procedure TFormMain.ButtonBFCtoBFBClick(Sender: TObject);
begin
      ProgressBar.Position:=10;
      iComBaud:=115200;
      if ComOpen then begin
       ProgressBar.Position:=60;
       if BFC_to_BFB then begin
         AddLinesLog('Протокол переключен в BFB режим');
         StatusBar.Panels[PanelCmd].Text:='BFB режим';
         iComBaud:=57600;
       end;
       ComClose;
       ProgressBar.Position:=100;
      end;
end;

procedure TFormMain.ButtonBFBtoBFCClick(Sender: TObject);
begin
      ProgressBar.Position:=10;
      iComBaud:=57600;
      iComNum := RadioGroupComPort.ItemIndex+1;
      if OpenCom(CheckBoxSBA.Checked) then begin
       ProgressBar.Position:=60;
       if BFB_to_BFC then begin
         AddLinesLog('Протокол переключен в BFC режим');
         StatusBar.Panels[PanelCmd].Text:='BFC режим';
         iComBaud:=115200;
       end;
       ComClose;
       ProgressBar.Position:=100;
      end
      else begin
         StatusBar.Panels[PanelCmd].Text:='Не открыть Com'+IntToStr(iComNum)+'!';
         StatusBar.Panels[PanelInf].Text:='';
      end;
end;

procedure TFormMain.ButtonCloseSkeyClick(Sender: TObject);
begin
      ProgressBar.Position:=10;
      AddLinesLog('Отключение SKEY в телефоне...');
      if ComOpen then begin
       ProgressBar.Position:=60;
       if BFC_CloseSkey then begin
         AddLinesLog('SKEY отключен!');
         StatusBar.Panels[PanelCmd].Text:=BFC_GetSecurityMode;
         if BFC_Error=ERR_NO then AddLinesLog('SecurityStatus: '+StatusBar.Panels[PanelCmd].Text);
       end;
       ComClose;
       ProgressBar.Position:=100;
      end;
end;

procedure TFormMain.ButtonSendSkeyClick(Sender: TObject);
var
S : string;
b : byte;
i : integer;
xESN : dword;
begin
   ProgressBar.Position:=10;
   AddLinesLog('Проверка ввода значений...');
   if length(EditIMEI.Text)=15 then sIMEI:=EditIMEI.Text
   else begin
     StatusBar.Panels[PanelCmd].Text:='Неверный ввод IMEI';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
   end;
   IniFile.WriteString('Setup','IMEI',sIMEI);
   if (SpinEditHWID.Value<=HW_IDMIN) or (SpinEditHWID.Value>HW_IDMAX) then begin
     StatusBar.Panels[PanelCmd].Text:='Неверный ввод HWID!';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
   end;
   IniFile.WriteInteger(sIMEI,'HWID',SpinEditHWID.Value);
   if length(EditESN.Text)=8 then xESN:=StrToInt('$'+EditESN.Text)
   else begin
     StatusBar.Panels[PanelCmd].Text:='Неверный ввод ESN!';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
   end;
   IniFile.WriteString(sIMEI,'ESN',IntToHex(xESN,8));
   EditESN.Text:=IntToHex(xESN,8);

   if length(EditHash.Text)=32 then HexTopByte(@EditHash.Text[1],16,@HASH)
   else begin
     StatusBar.Panels[PanelCmd].Text:='Неверный ввод HASH!';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
   end;
   EditHash.Text:=BufToHexStr(@HASH,16);

   if length(EditBootKey.Text)=32 then HexTopByte(@EditBootKey.Text[1],16,@BootKey)
   else begin
     StatusBar.Panels[PanelCmd].Text:='Неверный ввод BootKEY';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
   end;
   EditBootKey.Text:=BufToHexStr(@BootKey,16);

   if length(EditSkey.Text)<>0 then Skey:=StrToInt(EditSkey.Text)
   else begin
     StatusBar.Panels[PanelCmd].Text:='Неверный ввод SKEY!';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
   end;
   IniFile.WriteInteger(sIMEI,'SKEY',SKey);

   AddLinesLog('Тест "Сервисного Ключа" (SKEY)...');
   if not TestSkey(False) then begin
    if MessageDlg('SKEY или ESN не совпадает с введёнными HASH!'+#10+#13+'Вводить?',
        mtConfirmation, [mbYes, mbNo], 0) <> mrYes
    then begin
     StatusBar.Panels[PanelCmd].Text:='Ввод остановлен!';
     ComClose;
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
    end;
   end;
      AddLinesLog('Ввод "Сервисного Ключа" (SKEY) в телефон...');
      S := EditSKey.Text;
      if ComOpen then begin
       ProgressBar.Position:=30;
       if BFC_SendSkey('X'+S,b) then begin
         AddLinesLog('SKEY введен!');
         if (b<33) then begin
           AddLinesLog('Пауза '+IntToStr(b)+' секунд(ы)...');
           for i:=0 to b do begin
            ProgressBar.StepBy(2);
            Sleep(1000);
           end;
         end
         else begin
           StatusBar.Panels[PanelCmd].Text:='Неверный ключ!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           ComClose;
           exit;
         end;
         ProgressBar.Position:=90;
         StatusBar.Panels[PanelCmd].Text:=BFC_GetSecurityMode;
         if BFC_Error=ERR_NO then AddLinesLog('SecurityStatus: '+StatusBar.Panels[PanelCmd].Text);
       end;
       ComClose;
       ProgressBar.Position:=100;
      end;
end;


procedure TFormMain.ButtonCalkSkeyClick(Sender: TObject);
Var
xESN : Dword;
begin
  ProgressBar.Position:=10;
  if length(EditIMEI.Text)=15 then sIMEI:=EditIMEI.Text
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод IMEI!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
  end;
  if length(EditESN.Text)=8 then xESN:=StrToInt('$'+EditESN.Text)
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод ESN!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  if length(EditHash.Text)=32 then HexTopByte(@EditHash.Text[1],16,@HASH)
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод HASH!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  ButtonCalkSkey.Enabled:=False;
  AddLinesLog('Расчет ключей...');
  StatusBar.Panels[PanelCmd].Text:='Расчет ключей...';
  Repaint;
  if CalkSkey(xESN,0) then begin
      AddLinesLog('Ключи рассчитаны успешно:');
      EditSkey.Text:=IntToStr(SKey);
      EditBootKey.Text:=BufToHexStr(@BootKey,16);
      IniFile.WriteString('Setup','IMEI',sIMEI);
      IniFile.WriteInteger(sIMEI,'SKEY',Skey);
      IniFile.WriteString(sIMEI,'BKEY',EditBootKey.Text);
      IniFile.WriteString(sIMEI,'HASH',EditHASH.Text);
      IniFile.WriteString(sIMEI,'ESN',EditESN.Text);
      AddLinesLog('BootKEY: '+BufToHexStr(@BootKey,16));
      EditBootKey.Text:=BufToHexStr(@BootKey,16);
      AddLinesLog('SKEY: '+IntToStr(SKey));
      EditSkey.Text:=IntToStr(SKey);
      StatusBar.Panels[PanelCmd].Text:='SKEY: '+IntToStr(SKey);
  end
  else begin
      StatusBar.Panels[PanelCmd].Text:='Ключ не найден!';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
  end;
  ButtonCalkSkey.Enabled:=True;
end;

function TFormMain.TestSkey(flgTstBkey:boolean): boolean;
var
i : integer;
buffer : array[0..63] of byte;
xskey,xesn : dword;
begin
    if (EditSkey.Text='?') or (Length(EditSkey.Text)=0) or (Length(EditESN.Text)<>8) then begin
     result:=False;
     exit;
    end;
    xskey:=StrToInt(EditSkey.Text);
    xesn:=StrToInt('$'+EditESN.Text);
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

procedure TFormMain.CalkHashAndBkey(xskey,xesn:Dword);
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

function TFormMain.CalkESN(xskey:dword; var xESN:dword): boolean;
var
i,sss,x : integer;
buffer : array[0..63] of byte;
begin
   ProgressBar.Position:=0;
   sss:=0;
   x:=0;
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
     Move(MD5buf,BootKey,16);
     SKey:=xskey;
     result:=True;
     ProgressBar.Position:=100;
     exit;
    end
    else begin
     dec(xESN);
     inc(sss);
     if sss>42949673 then begin
       ProgressBar.StepBy(1);
       sss:=0;
     end;
     inc(x);
     if x>700000 then begin
      x:=0;
      Application.ProcessMessages;
     end;
    end;
   end
   until (xESN=$FFFFFFFF);
   result:=False;
end;

function TFormMain.CalkSkey(xesn,xskey:dword): boolean;
var
i,sss : integer;
buffer : array[0..63] of byte;
begin
   ProgressBar.Position:=0;
   sss:=0;
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
       sss:=0;
       Application.ProcessMessages;
     end;
    end;
   end
   until (xskey=100000000) or (xskey=0);
//   until (xskey=0);
   result:=False;
end;

procedure TFormMain.ButtonTstDisp1Click(Sender: TObject);
begin
      ProgressBar.Position:=10;
      if ComOpen then begin
       ProgressBar.Position:=60;
       if BFC_GenerateDisplayPattern(1,0) then begin
         AddLinesLog('Тест экрана N1');
         StatusBar.Panels[PanelCmd].Text:='Тест экрана N1';
         ComClose;
         ProgressBar.Position:=100;
       end
       else begin
         ComClose;
         StatusBar.Panels[PanelCmd].Text:='Ошибка!';
       end;
      end;
end;

procedure TFormMain.ButtonTstDisp2Click(Sender: TObject);
begin
      ProgressBar.Position:=10;
      if ComOpen then begin
       ProgressBar.Position:=60;
       if BFC_GenerateDisplayPattern(1,1) then begin
         AddLinesLog('Тест экрана N2');
         StatusBar.Panels[PanelCmd].Text:='Тест экрана N2';
         ComClose;
         ProgressBar.Position:=100;
       end
       else begin
         ComClose;
         StatusBar.Panels[PanelCmd].Text:='Ошибка!';
       end;
      end;
end;

procedure TFormMain.ButtonKeyOnClick(Sender: TObject);
begin
      ProgressBar.Position:=10;
      if ComOpen then begin
       ProgressBar.Position:=60;
       if BFC_PressKeypad($0C) then begin
         StatusBar.Panels[PanelCmd].Text:='Кнопка Вкл/Выкл';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         ComClose;
         ProgressBar.Position:=100;
       end
       else begin
         ComClose;
         StatusBar.Panels[PanelCmd].Text:='Ошибка!';
       end;
      end;
end;

procedure TFormMain.ButtonOpenAllClick(Sender: TObject);
var
b : byte;
i : integer;
xESN : dword;
S : string;
begin
      xESN:=0;
      ButtonOpenAll.Enabled:=False;
      StatusBar.Panels[PanelCmd].Text:='Загрузка в Сервисный режим...';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      Repaint;
      if not SrvBoot(SERVICE_MODE,True) then begin
        ProgressBar.Position:=10;
        ButtonOpenAll.Enabled:=True;
        exit;
      end;
      StatusBar.Panels[PanelCmd].Text:='Чтение данных из телефона...';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      ProgressBar.Position:=10;
      Repaint;
      iComBaud:=115200;
      if ComOpen then begin
        ProgressBar.Position:=50;
        if BFC_Error=ERR_NO then xESN:=ReadESNAndHASH;
        if ProgressBar.Position<>100 then begin
         ProgressBar.Position:=10;
         BFC_PhoneOff;
         ComClose;
         AddLinesLog('Телефон выключается...');
         ButtonOpenAll.Enabled:=True;
         exit;
        end;
        ChangeComSpeed(115200);
        IniFile.WriteString('Setup','IMEI',sIMEI);
        IniFile.WriteString(sIMEI,'Phone',sDevMan+' '+sPhoneModel+' '+sSoftWareVer+' '+sLgVer);
        IniFile.WriteInteger(sIMEI,'HWID',SpinEditHWID.Value);
        IniFile.WriteString(sIMEI,'ESN',EditESN.Text);
        IniFile.WriteString(sIMEI,'HASH',EditHash.Text);
        if not TestSkey(False) then begin
         StatusBar.Panels[PanelCmd].Text:='Расчет ключей...';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         Repaint;
         if CalkSkey(xESN,0) then begin
          AddLinesLog('Ключи рассчитаны успешно: ');
          AddLinesLog('BootKEY: '+BufToHexStr(@BootKey,16));
          AddLinesLog('SKEY: '+IntToStr(SKey));
          EditSkey.Text:=IntToStr(SKey);
          EditBootKey.Text:=BufToHexStr(@BootKey,16);
          IniFile.WriteInteger(sIMEI,'SKEY',Skey);
          IniFile.WriteString(sIMEI,'BKEY',EditBootKey.Text);
         end
         else begin
          StatusBar.Panels[PanelCmd].Text:='Ключ не найден!';
          BFC_PhoneOff;
          ComClose;
          AddLinesLog('Телефон выключается...');
          ButtonOpenAll.Enabled:=True;
         end;
        end // not TestSkey
        else begin
         AddLinesLog('Ключи на этот телефон уже рассчитаны!');
         AddLinesLog('Берем старые значения');
         AddLinesLog('SKEY: '+IntToStr(SKey));
        end; // TestSkey
        ProgressBar.Position:=30;
        AddLinesLog('Ввод ключа...');
        StatusBar.Panels[PanelCmd].Text:='Ввод ключа...';
        Repaint;
        S := EditSKey.Text;
        if BFC_SendSkey('X'+S,b) then begin
         AddLinesLog('SKEY введен!');
         if (b<33) then begin
           AddLinesLog('Пауза '+IntToStr(b)+' секунд(ы)...');
           for i:=0 to b do begin
            ProgressBar.StepBy(2);
            Sleep(1000);
           end;
         end
         else begin
           StatusBar.Panels[PanelCmd].Text:='Неверный ключ!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           BFC_PhoneOff;
           AddLinesLog('Телефон выключается...');
           ComClose;
           ButtonOpenAll.Enabled:=True;
           exit;
         end;
         ProgressBar.Position:=90;
         StatusBar.Panels[PanelCmd].Text:=BFC_GetSecurityMode;
         if BFC_Error=ERR_NO then AddLinesLog('SecurityStatus: '+StatusBar.Panels[PanelCmd].Text);
        end
        else begin
         StatusBar.Panels[PanelCmd].Text:='Ошибка ввода ключа!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         BFC_PhoneOff;
         ComClose;
         AddLinesLog('Телефон выключается...');
         ButtonOpenAll.Enabled:=True;
         exit;
        end;
        BFC_PhoneOff;
        ComClose;
        AddLinesLog('Телефон выключается...');
        ProgressBar.Position:=100;
      end; // ComOpen
      ButtonOpenAll.Enabled:=True;
end;

procedure TFormMain.ButtonFreaLogClick(Sender: TObject);
var
b : byte;
xESN : dword;
s : string;
begin
  ProgressBar.Position:=10;
  AddLinesLog('Проверка ввода значений...');
  if length(EditIMEI.Text)=15 then begin
    sIMEI:=EditIMEI.Text;
    if CalkImei15(sIMEI,Char(b)) then begin
      if sIMEI[15]<>Char(b) then begin
       AddLinesLog('Внимание: IMEI некорректен!');
      end;
    end
    else begin
     StatusBar.Panels[PanelCmd].Text:='Неверный ввод IMEI!';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
    end;
  end
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод IMEI!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  if length(EditESN.Text)=8 then xESN:=StrToInt('$'+EditESN.Text)
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод ESN!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  S:='HWID: '+IntToStr(SpinEditHWID.Value)+#13+#10
    +'SKEY: '+EditSkey.text+#13+#10
    +'BKEY: '+EditBootkey.text+#13+#10
    +'[Model: Siemens A50][PhoneID: '+BufToHexStr(@xESN,4)+'][Desired IMEI: '+sIMEI+']'+#13+#10;
   with SaveDialog do begin
     FilterIndex:=1;
     FileName := IniFile.ReadString('Setup','OldLogFile',sIMEI+'.log');
     InitialDir := ExtractFilePath(FileName);
     FileName := ExtractFileName(FileName);
     if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
     if not DirectoryExists(InitialDir) then
      InitialDir := IniFile.ReadString('Setup','DirOld','.\');
     DefaultExt := 'log';
     Filter := 'Log files (*.log)|*.log|All files (*.*)|*.*';
     Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
     Title:='Сохранение лога в файл';
   end;//with
  ProgressBar.Position:=30;
  if SaveDialog.Execute then begin
    hffile:=FileCreate(SaveDialog.FileName);
    if hffile>0 then begin // Запись в файл
      if FileWrite(hffile,S[1],length(S))<>length(S) then
         ShowMessage('Ошибка записи файла:'+SaveDialog.FileName)
      else begin
         IniFile.WriteString('Setup','OldLogFile',SaveDialog.FileName);
         StatusBar.Panels[PanelCmd].Text:='Сохранен '+SaveDialog.FileName;
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         AddLinesLog(S);
      end;
    end // FileCreate > 0
    else ShowMessage('Ошибка создания:'+SaveDialog.FileName);
    FileClose(hffile);
  end // if save dialog
  else
  if MessageDlg('Записать блоки прямо в телефон?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes
  then begin
    ProgressBar.Position:=50;
    Create76(sIMEI,EEP0076,C55);
    Create5009(sIMEI,EEP5009,C55);
    Create5008(sIMEI,xESN,EEP5008,C55);
    Create5077(sIMEI,xESN,EEP5077,C55);
    ProgressBar.Position:=70;
    if ComOpen then begin
     if WriteEepBlock(76,sizeof(EEP0076),0,EEP0076)
     and WriteEepBlock(5008,sizeof(EEP5008),0,EEP5008)
     and WriteEepBlock(5009,sizeof(EEP5009),0,EEP5009)
     and WriteEepBlock(5077,sizeof(EEP5077),0,EEP5077)
     then begin
      StatusBar.Panels[PanelCmd].Text:='Блоки записаны в телефон.';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     end;
     ComClose;
    end; // if ComOpen
  end; // if MessageDlg
  ProgressBar.Position:=100;
end;

procedure TFormMain.ButtonX65flasherClick(Sender: TObject);
begin
  AddLinesLog('Проверка ввода значений...');
  if length(EditIMEI.Text)=15 then sIMEI:=EditIMEI.Text
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод IMEI';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  if length(EditBootKey.Text)=32 then HexTopByte(@EditBootKey.Text[1],16,@BootKey)
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод BootKEY';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
   with SaveDialog do begin
     FilterIndex:=1;
     FileName := IniFile.ReadString('Setup','OldIniFile','config.ini');
     InitialDir := ExtractFilePath(FileName);
     FileName := ExtractFileName(FileName);
     if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
     if not DirectoryExists(InitialDir) then
      InitialDir := IniFile.ReadString('Setup','DirOld','.\');
     DefaultExt := 'ini';
     Filter := 'ini files (*.ini)|*.ini|All files (*.*)|*.*';
     Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
     Title:='Добавить пароль в ini файл';
   end;//with
  if SaveDialog.Execute then begin
    IniFileX := TIniFile.Create(SaveDialog.FileName);
    IniFileX.WriteString('Bootkeys',sIMEI,EditBootKey.Text);
    IniFileX.UpdateFile;
    IniFileX.Free;
    IniFileX := Nil;
    IniFile.WriteString('Setup','OldIniFile',SaveDialog.FileName);
    StatusBar.Panels[PanelCmd].Text:='Сохранен '+SaveDialog.FileName;
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
  end; // if save dialog
end;

procedure TFormMain.ButtonX65VKD1Click(Sender: TObject);
begin
  AddLinesLog('Проверка ввода значений...');
  if length(EditIMEI.Text)=15 then sIMEI:=EditIMEI.Text
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод IMEI';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  if length(EditBootKey.Text)=32 then HexTopByte(@EditBootKey.Text[1],16,@BootKey)
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод BootKEY';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  Move(BootKey,ChaosBoot1[$40],16);
   with SaveDialog do begin
     FilterIndex:=1;
     FileName := IniFile.ReadString('Setup','OldVkdFile','x65_'+sIMEI+'.vkd');
     InitialDir := ExtractFilePath(FileName);
     FileName := 'x65_'+sIMEI+'.vkd';//ExtractFileName(FileName);
     if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
     if not DirectoryExists(InitialDir) then
      InitialDir := IniFile.ReadString('Setup','DirOld','.\');
     DefaultExt := 'vkd';
     Filter := 'vkd files (*.vkd)|*.vkd|All files (*.*)|*.*';
     Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
     Title:='Сохранить новый лоадер с паролем';
   end;//with
  if SaveDialog.Execute then begin
    IniFileX := TIniFile.Create(SaveDialog.FileName);
    IniFileX.WriteString('PhoneCommonInfo','Version','1.0');
    IniFileX.WriteString('PhoneCommonInfo','Comments','Driver for Siemens R65');
    IniFileX.WriteString('PhoneCommonInfo','Copyright','Chaos');
    IniFileX.WriteString('PhoneCommonInfo','Name','R65/X75');
    IniFileX.WriteString('PhoneCommonInfo','MCUMemGeometry','0');
    IniFileX.WriteString('PhoneCommonInfo','optBaudCmdCodes','57600: 0x00, 115200: 0x01, 230400: 0x02, 460800: 0x03, 614400: 0x04, 921600: 0x05, 1228800: 0x06, 1600000: 0x07,');
    IniFileX.WriteString('PhoneCommonInfo','optCmdAddrAndSizeLen','4');
    IniFileX.WriteString('PhoneCommonInfo','optWriteCmdVersion','2');
    IniFileX.WriteString('PhoneCommonInfo','optTestEmptyCmdEnable','1');
    IniFileX.WriteString('PhoneCommonInfo','optAuthorization','1');
    IniFileX.WriteString('PhoneCommonInfo','optKeepAliveCmdEnableAndSetInterval','250');
    IniFileX.WriteString('PhoneCommonInfo','Boots','Connect, GoBoot.bin, MainBoot.bin, ChaosKey1.bin, ChaosKey2.bin');
    IniFileX.WriteString('PhoneCommonInfo','Type','Password boot');
    IniFileX.WriteString('Phone01','Name','R65 '+sIMEI);
    IniFileX.WriteString('Phone01','Comments','Siemens R65 Phone (connecting, using boot password)');
    IniFileX.WriteString('Phone01','MCUMemFuBu',' fullflash, 0xA0000000, 0x02000000');
    IniFileX.WriteString('Phone01','MCUMemArea01',' BCORE,  0xA0000000, 0x00020000, bootcore');
    IniFileX.WriteString('Phone01','MCUMemArea02',' CODE1,  0xA0020000, 0x001E0000');
    IniFileX.WriteString('Phone01','MCUMemArea03',' EXIT,   0xA0200000, 0x00020000');
    IniFileX.WriteString('Phone01','MCUMemArea04',' EEFULL, 0xA0220000, 0x00040000');
    IniFileX.WriteString('Phone01','MCUMemArea05',' FFS_B,  0xA0260000, 0x00080000');
    IniFileX.WriteString('Phone01','MCUMemArea06',' FFS_C,  0xA02E0000, 0x00200000');
    IniFileX.WriteString('Phone01','MCUMemArea07',' FFS_A1, 0xA04E0000, 0x00320000');
    IniFileX.WriteString('Phone01','MCUMemArea08',' XCORE,  0xA0800000, 0x00020000');
    IniFileX.WriteString('Phone01','MCUMemArea09',' CODE2,  0xA0820000, 0x007C0000');
    IniFileX.WriteString('Phone01','MCUMemArea10',' EELITE, 0xA0FE0000, 0x00020000');
    IniFileX.WriteString('Phone01','MCUMemArea11',' CODE3,  0xA1000000, 0x00800000');
    IniFileX.WriteString('Phone01','MCUMemArea12',' FFS_A2, 0xA1800000, 0x00800000');

    IniFileX.WriteString('Phone02','Name','CX75 '+sIMEI);
    IniFileX.WriteString('Phone02','Comments','Siemens CX75 Phone (connecting, using boot password)');
    IniFileX.WriteString('Phone02','MCUMemFuBu',' fullflash, 0xA0000000, 0x02000000');
    IniFileX.WriteString('Phone02','MCUMemArea01',' BCORE,  0xA0000000, 0x00020000, bootcore');
    IniFileX.WriteString('Phone02','MCUMemArea02',' EELITE, 0xA0020000, 0x0020000');
    IniFileX.WriteString('Phone02','MCUMemArea03',' CODE1,  0xA0040000, 0x0070000');
    IniFileX.WriteString('Phone02','MCUMemArea04',' LngPck, 0xA00E0000, 0x0100000');
    IniFileX.WriteString('Phone02','MCUMemArea05',' CODE2,  0xA01E0000, 0x1220000');
    IniFileX.WriteString('Phone02','MCUMemArea06',' FFS,    0xA1400000, 0x0900000');
    IniFileX.WriteString('Phone02','MCUMemArea07',' FFS_C,  0xA1D00000, 0x0200000');
    IniFileX.WriteString('Phone02','MCUMemArea08',' FFS_B,  0xA1F00000, 0x0080000');
    IniFileX.WriteString('Phone02','MCUMemArea09',' EMPTY, 0xA1F80000, 0x0020000');
    IniFileX.WriteString('Phone02','MCUMemArea10',' EXIT,  0xA1FA0000, 0x0020000');
    IniFileX.WriteString('Phone02','MCUMemArea11',' EEFULL, 0xA1FC0000, 0x0040000');

    IniFileX.WriteString('Boot01','Name','Connect');
    IniFileX.WriteString('Boot01','UseIgnition','1');
    IniFileX.WriteString('Boot01','TryCount','-1');
    IniFileX.WriteString('Boot01','NoSendLen','1');
    IniFileX.WriteString('Boot01','Data','0sAT');
    IniFileX.WriteString('Boot01','NoSendCheckSum','1');
    IniFileX.WriteString('Boot01','Answer','B0');
    IniFileX.WriteString('Boot01','AnswerTimeout','100');

    IniFileX.WriteString('Boot02','Name','GoBoot.bin');
    IniFileX.WriteString('Boot02','NoSendLen','1');
    IniFileX.WriteString('Boot02','Data','30');
    IniFileX.WriteString('Boot02','NoSendCheckSum','1');

    IniFileX.WriteString('Boot03','Name','MainBoot.bin');
    IniFileX.WriteString('Boot03','SizeLen','2');
    IniFileX.WriteString('Boot03','Data',BufToHexStr(@ChaosBoot1,SizeOf(ChaosBoot1)));
    IniFileX.WriteString('Boot03','Answer','B1');

    IniFileX.WriteString('Boot04','Name','ChaosKey1.bin');
    IniFileX.WriteString('Boot04','DelayBefore','100');
    IniFileX.WriteString('Boot04','NoSendLen','1');
    IniFileX.WriteString('Boot04','Data',BufToHexStr(@ChaosBoot2,SizeOf(ChaosBoot2)));
    IniFileX.WriteString('Boot04','NoSendCheckSum','1');

    IniFileX.WriteString('Boot05','Name','ChaosKey2.bin');
    IniFileX.WriteString('Boot05','DelayBefore','100');
    IniFileX.WriteString('Boot05','NoSendLen','1');
    IniFileX.WriteString('Boot05','Data',BufToHexStr(@ChaosBoot3,SizeOf(ChaosBoot3)));
    IniFileX.WriteString('Boot05','NoSendCheckSum','1');
    IniFileX.WriteString('Boot05','Answer','A5');
    IniFileX.UpdateFile;
    IniFileX.Free;
    IniFileX := Nil;
    IniFile.WriteString('Setup','OldVkdFile',SaveDialog.FileName);
    StatusBar.Panels[PanelCmd].Text:='Сохранен '+SaveDialog.FileName;
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
  end; // if save dialog
end;

{$include PVBoots.pas}

procedure TFormMain.ButtonPVVKDClick(Sender: TObject);
var
i : integer;
begin
  AddLinesLog('Проверка ввода значений...');
  if length(EditIMEI.Text)=15 then sIMEI:=EditIMEI.Text
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод IMEI';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  if length(EditBootKey.Text)=32 then HexTopByte(@EditBootKey.Text[1],16,@BootKey)
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод BootKEY';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
//   flgx :=False;
   with SaveDialog do begin
     FilterIndex:=1;
     FileName := IniFile.ReadString('Setup','OldVkdFile','r65x75pv.vkd');
     InitialDir := ExtractFilePath(FileName);
     FileName := 'r65x75x85pv.vkd';//ExtractFileName(FileName);
     if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
     if not DirectoryExists(InitialDir) then
      InitialDir := IniFile.ReadString('Setup','DirOld','.\');
     DefaultExt := 'vkd';
     Filter := 'vkd files (*.vkd)|*.vkd|All files (*.*)|*.*';
     Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
     Title:='Сохранить новый лоадер для R65/X75/X85 с паролем';
   end;//with
  if SaveDialog.Execute then begin
    IniFileX := TIniFile.Create(SaveDialog.FileName);
    i:=IniFile.ReadInteger('System','Spd1M5',$1D0);
    if (Dword((@PVBootR65[BootTab[0].adrsp])^)=$1D0) then Dword((@PVBootR65[BootTab[0].adrsp])^):=dword(i);
    if (Dword((@PVBootX75[BootTab[1].adrsp])^)=$1D0) then Dword((@PVBootX75[BootTab[1].adrsp])^):=dword(i);
    if (Dword((@PVBootX85[BootTab[2].adrsp])^)=$1D0) then Dword((@PVBootX85[BootTab[2].adrsp])^):=dword(i);
    IniFileX.WriteString('PhoneCommonInfo','Version','1.0');
    IniFileX.WriteString('PhoneCommonInfo','Comments','Driver for Siemens R65/X75/X85');
    IniFileX.WriteString('PhoneCommonInfo','Copyright','Chaos & PV`');
    IniFileX.WriteString('PhoneCommonInfo','Name','R65/X75/X85');
    IniFileX.WriteString('PhoneCommonInfo','MCUMemGeometry','0');
    IniFileX.WriteString('PhoneCommonInfo','optBaudCmdCodes','57600: 0x00, 115200: 0x01, 230400: 0x02, 460800: 0x03, 614400: 0x04, 921600: 0x05, 1228800: 0x06, 1600000: 0x07, 1500000: 0x08');
    IniFileX.WriteString('PhoneCommonInfo','optCmdAddrAndSizeLen','4');
    IniFileX.WriteString('PhoneCommonInfo','optWriteCmdVersion','2');
    IniFileX.WriteString('PhoneCommonInfo','optTestEmptyCmdEnable','1');
    IniFileX.WriteString('PhoneCommonInfo','optKeepAliveCmdEnableAndSetInterval','250');
    IniFileX.WriteString('PhoneCommonInfo','optLoaderUploadTryCount',' -1');
    IniFileX.WriteString('PhoneCommonInfo','optLoaderUploadDelay','300');
    IniFileX.WriteString('PhoneCommonInfo','optLoaderUploadOkSnd','%SystemRoot%\media\tada.wav');
    IniFileX.WriteString('PhoneCommonInfo','optLoaderUploadErrorSnd','%SystemRoot%\media\chimes.wav');

    IniFileX.WriteString('Phone01','Name','R65');
    IniFileX.WriteString('Phone01','Boots','Connect, GoBoot.bin, Boot.bin, NoPause.bin');
    IniFileX.WriteString('Phone01','Type','BootKey and NewFlash');
    IniFileX.WriteString('Phone01','Comments','Siemens x65 Phone (connecting, using boot password or new/clear flash)');
    IniFileX.WriteString('Phone01','MCUMemFuBu',' fullflash, 0xA0000000, 0x02000000');
    IniFileX.WriteString('Phone01','MCUMemArea01',' BCORE,  0xA0000000, 0x00020000, bootcore');
    IniFileX.WriteString('Phone01','MCUMemArea02',' CODE1,  0xA0020000, 0x001E0000');
    IniFileX.WriteString('Phone01','MCUMemArea03',' EXIT,   0xA0200000, 0x00020000');
    IniFileX.WriteString('Phone01','MCUMemArea04',' EEFULL, 0xA0220000, 0x00040000');
    IniFileX.WriteString('Phone01','MCUMemArea05',' FFS_B,  0xA0260000, 0x00080000');
    IniFileX.WriteString('Phone01','MCUMemArea06',' FFS_C,  0xA02E0000, 0x00200000');
    IniFileX.WriteString('Phone01','MCUMemArea07',' FFS_A1, 0xA04E0000, 0x00320000');
    IniFileX.WriteString('Phone01','MCUMemArea08',' XCORE,  0xA0800000, 0x00020000');
    IniFileX.WriteString('Phone01','MCUMemArea09',' CODE2,  0xA0820000, 0x007C0000');
    IniFileX.WriteString('Phone01','MCUMemArea10',' EELITE, 0xA0FE0000, 0x00020000');
    IniFileX.WriteString('Phone01','MCUMemArea11',' CODE3,  0xA1000000, 0x00800000');
    IniFileX.WriteString('Phone01','MCUMemArea12',' FFS_A2, 0xA1800000, 0x00800000');

    IniFileX.WriteString('Phone02','Name','R65');
    IniFileX.WriteString('Phone02','Boots','Connect, GoBoot.bin, Boot.bin, Pause.bin');
    IniFileX.WriteString('Phone02','Type','Test Point + Pause 1.3s');
    IniFileX.WriteString('Phone02','Comments','Siemens x65 Phone (connecting, using boot password or new/clear flash)');
    IniFileX.WriteString('Phone02','MCUMemFuBu',' fullflash, 0xA0000000, 0x02000000');
    IniFileX.WriteString('Phone02','MCUMemArea01',' BCORE,  0xA0000000, 0x00020000, bootcore');
    IniFileX.WriteString('Phone02','MCUMemArea02',' CODE1,  0xA0020000, 0x001E0000');
    IniFileX.WriteString('Phone02','MCUMemArea03',' EXIT,   0xA0200000, 0x00020000');
    IniFileX.WriteString('Phone02','MCUMemArea04',' EEFULL, 0xA0220000, 0x00040000');
    IniFileX.WriteString('Phone02','MCUMemArea05',' FFS_B,  0xA0260000, 0x00080000');
    IniFileX.WriteString('Phone02','MCUMemArea06',' FFS_C,  0xA02E0000, 0x00200000');
    IniFileX.WriteString('Phone02','MCUMemArea07',' FFS_A1, 0xA04E0000, 0x00320000');
    IniFileX.WriteString('Phone02','MCUMemArea08',' XCORE,  0xA0800000, 0x00020000');
    IniFileX.WriteString('Phone02','MCUMemArea09',' CODE2,  0xA0820000, 0x007C0000');
    IniFileX.WriteString('Phone02','MCUMemArea10',' EELITE, 0xA0FE0000, 0x00020000');
    IniFileX.WriteString('Phone02','MCUMemArea11',' CODE3,  0xA1000000, 0x00800000');
    IniFileX.WriteString('Phone02','MCUMemArea12',' FFS_A2, 0xA1800000, 0x00800000');

    IniFileX.WriteString('Phone03','Name','X75');
    IniFileX.WriteString('Phone03','Boots','Connect75, GoBoot.bin, Boot75.bin, NoPause.bin');
    IniFileX.WriteString('Phone03','Type','BootKey and NewFlash');
    IniFileX.WriteString('Phone03','Comments','Siemens x75 Phone (connecting, using boot password or new/clear flash)');
    IniFileX.WriteString('Phone03','MCUMemFuBu',' fullflash, 0xA0000000, 0x02000000');
    IniFileX.WriteString('Phone03','MCUMemArea01',' BCORE,  0xA0000000, 0x00020000, bootcore');
    IniFileX.WriteString('Phone03','MCUMemArea02',' EELITE, 0xA0020000, 0x0020000');
    IniFileX.WriteString('Phone03','MCUMemArea03',' CODE1,  0xA0040000, 0x0070000');
    IniFileX.WriteString('Phone03','MCUMemArea04',' LngPck, 0xA00E0000, 0x0100000');
    IniFileX.WriteString('Phone03','MCUMemArea05',' CODE2,  0xA01E0000, 0x1220000');
    IniFileX.WriteString('Phone03','MCUMemArea06',' FFS,    0xA1400000, 0x0900000');
    IniFileX.WriteString('Phone03','MCUMemArea07',' FFS_C,  0xA1D00000, 0x0200000');
    IniFileX.WriteString('Phone03','MCUMemArea08',' FFS_B,  0xA1F00000, 0x0080000');
    IniFileX.WriteString('Phone03','MCUMemArea09',' EMPTY, 0xA1F80000, 0x0020000');
    IniFileX.WriteString('Phone03','MCUMemArea10',' EXIT,  0xA1FA0000, 0x0020000');
    IniFileX.WriteString('Phone03','MCUMemArea11',' EEFULL, 0xA1FC0000, 0x0040000');

    IniFileX.WriteString('Phone04','Name','X75');
    IniFileX.WriteString('Phone04','Boots','Connect75, GoBoot.bin, Boot75.bin, Pause.bin');
    IniFileX.WriteString('Phone04','Type','Test Point + Pause 1.3s');
    IniFileX.WriteString('Phone04','Comments','Siemens x75 Phone (connecting, using boot password or new/clear flash)');
    IniFileX.WriteString('Phone04','MCUMemFuBu',' fullflash, 0xA0000000, 0x02000000');
    IniFileX.WriteString('Phone04','MCUMemArea01',' BCORE,  0xA0000000, 0x00020000, bootcore');
    IniFileX.WriteString('Phone04','MCUMemArea02',' EELITE, 0xA0020000, 0x0020000');
    IniFileX.WriteString('Phone04','MCUMemArea03',' CODE1,  0xA0040000, 0x0070000');
    IniFileX.WriteString('Phone04','MCUMemArea04',' LngPck, 0xA00E0000, 0x0100000');
    IniFileX.WriteString('Phone04','MCUMemArea05',' CODE2,  0xA01E0000, 0x1220000');
    IniFileX.WriteString('Phone04','MCUMemArea06',' FFS,    0xA1400000, 0x0900000');
    IniFileX.WriteString('Phone04','MCUMemArea07',' FFS_C,  0xA1D00000, 0x0200000');
    IniFileX.WriteString('Phone04','MCUMemArea08',' FFS_B,  0xA1F00000, 0x0080000');
    IniFileX.WriteString('Phone04','MCUMemArea09',' EMPTY, 0xA1F80000, 0x0020000');
    IniFileX.WriteString('Phone04','MCUMemArea10',' EXIT,  0xA1FA0000, 0x0020000');
    IniFileX.WriteString('Phone04','MCUMemArea11',' EEFULL, 0xA1FC0000, 0x0040000');

    IniFileX.WriteString('Phone05','Name','X85');
    IniFileX.WriteString('Phone05','Boots','Connect75, GoBoot.bin, Boot85.bin, NoPause.bin');
    IniFileX.WriteString('Phone05','Type','BootKey and NewFlash');
    IniFileX.WriteString('Phone05','Comments','Siemens x85 Phone (connecting, using boot password or new/clear flash)');
    IniFileX.WriteString('Phone05','MCUMemFuBu',' fullflash, 0xA0000000, 0x04000000');
    IniFileX.WriteString('Phone05','MCUMemArea01',' BCORE,  0xA0000000, 0x00040000, bootcore');

    IniFileX.WriteString('Phone06','Name','X85');
    IniFileX.WriteString('Phone06','Boots','Connect75, GoBoot.bin, Boot85.bin, Pause.bin');
    IniFileX.WriteString('Phone06','Type','Test Point + Pause 1.3s');
    IniFileX.WriteString('Phone06','Comments','Siemens x85 Phone (connecting, using boot password or new/clear flash)');
    IniFileX.WriteString('Phone06','MCUMemFuBu',' fullflash, 0xA0000000, 0x04000000');
    IniFileX.WriteString('Phone06','MCUMemArea01',' BCORE,  0xA0000000, 0x00040000, bootcore');

    IniFileX.WriteString('Boot01','Name','Connect');
    IniFileX.WriteString('Boot01','UseIgnition','1');
    IniFileX.WriteString('Boot01','TryCount','-1');
    IniFileX.WriteString('Boot01','NoSendLen','1');
    IniFileX.WriteString('Boot01','Data','0sAT');
    IniFileX.WriteString('Boot01','NoSendCheckSum','1');
    IniFileX.WriteString('Boot01','Answer','B0');
    IniFileX.WriteString('Boot01','AnswerTimeout','100');

    IniFileX.WriteString('Boot02','Name','Boot.bin');
    IniFileX.WriteString('Boot02','SizeLen','2');
    IniFileX.WriteString('Boot02','Data01',BufToHexStr(@PVBootR65,$40));
    IniFileX.WriteString('Boot02','Data02',BufToHexStr(@BootKey,SizeOf(BootKey)));
    IniFileX.WriteString('Boot02','Data03',BufToHexStr(@PVBootR65[$50],SizeOf(PVBootR65)-$50));
    IniFileX.WriteString('Boot02','Answer','B1A5');

    IniFileX.WriteString('Boot03','Name','GoBoot.bin');
    IniFileX.WriteString('Boot03','NoSendLen','1');
    IniFileX.WriteString('Boot03','Data','30');
    IniFileX.WriteString('Boot03','NoSendCheckSum','1');

    IniFileX.WriteString('Boot04','SndBefore','%SystemRoot%\media\ding.wav');
    IniFileX.WriteString('Boot04','Name','Pause.bin');
    IniFileX.WriteString('Boot04','DelayBefore','1300');
    IniFileX.WriteString('Boot04','NoSendLen','1');
    IniFileX.WriteString('Boot04','Data','55');
    IniFileX.WriteString('Boot04','NoSendCheckSum','1');
    IniFileX.WriteString('Boot04','Answer','AA');

    IniFileX.WriteString('Boot05','Name','NoPause.bin');
    IniFileX.WriteString('Boot05','NoSendLen','1');
    IniFileX.WriteString('Boot05','Data','55');
    IniFileX.WriteString('Boot05','NoSendCheckSum','1');
    IniFileX.WriteString('Boot05','Answer','AA');

    IniFileX.WriteString('Boot06','Name','Connect75');
    IniFileX.WriteString('Boot06','UseIgnition','1');
    IniFileX.WriteString('Boot06','TryCount','-1');
    IniFileX.WriteString('Boot06','NoSendLen','1');
    IniFileX.WriteString('Boot06','Data','0sAT');
    IniFileX.WriteString('Boot06','NoSendCheckSum','1');
    IniFileX.WriteString('Boot06','Answer','C0');
    IniFileX.WriteString('Boot06','AnswerTimeout','100');

    IniFileX.WriteString('Boot07','Name','Boot75.bin');
    IniFileX.WriteString('Boot07','SizeLen','2');
    IniFileX.WriteString('Boot07','Data01',BufToHexStr(@PVBootX75,$40));
    IniFileX.WriteString('Boot07','Data02',BufToHexStr(@BootKey,SizeOf(BootKey)));
    IniFileX.WriteString('Boot07','Data03',BufToHexStr(@PVBootX75[$50],SizeOf(PVBootX75)-$50));
    IniFileX.WriteString('Boot07','Answer','C1A5');

    IniFileX.WriteString('Boot08','Name','Boot85.bin');
    IniFileX.WriteString('Boot08','SizeLen','2');
    IniFileX.WriteString('Boot08','Data01',BufToHexStr(@PVBootX85,$40));
    IniFileX.WriteString('Boot08','Data02',BufToHexStr(@BootKey,SizeOf(BootKey)));
    IniFileX.WriteString('Boot08','Data03',BufToHexStr(@PVBootX85[$50],SizeOf(PVBootX85)-$50));
    IniFileX.WriteString('Boot08','Answer','C1A5');


    IniFileX.UpdateFile;
    IniFileX.Free;
    IniFileX := Nil;
    IniFile.WriteString('Setup','OldVkdFile',SaveDialog.FileName);
    StatusBar.Panels[PanelCmd].Text:='Сохранен '+SaveDialog.FileName;
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
{    if flgx then begin
      p := @PVBoot1;
      for i:=0 to ((sizeof(PVBoot1)shr 2)-1) do begin
        dword(p^):=dword(p^) xor $50565056;
        inc(dword(p),4);
      end;
      p := @PVBoot2;
      for i:=0 to ((sizeof(PVBoot2) shr 2)-1) do begin
        dword(p^):=dword(p^) xor $50565056;
        inc(dword(p),4);
      end;
    end; }
  end; // if save dialog
end;

{$include ChaosBoot_x75.pas}
procedure TFormMain.ButtonX75VKDClick(Sender: TObject);
//var
//flgx : boolean;
//p : pointer;
//i : integer;
begin
  AddLinesLog('Проверка ввода значений...');
  if length(EditIMEI.Text)=15 then sIMEI:=EditIMEI.Text
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод IMEI';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  if length(EditBootKey.Text)=32 then HexTopByte(@EditBootKey.Text[1],16,@BootKey)
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод BootKEY';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
//   flgx :=False;
   with SaveDialog do begin
     FilterIndex:=1;
     FileName := IniFile.ReadString('Setup','OldVkdChFile','S65&75.vkd');
     InitialDir := ExtractFilePath(FileName);
     FileName := 'S65&75.vkd';//ExtractFileName(FileName);
     if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
     if not DirectoryExists(InitialDir) then
      InitialDir := IniFile.ReadString('Setup','DirOld','.\');
     DefaultExt := 'vkd';
     Filter := 'vkd files (*.vkd)|*.vkd|All files (*.*)|*.*';
     Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
     Title:='Сохранить новый лоадер для R65/X75 с паролем';
   end;//with
  if SaveDialog.Execute then begin
    IniFileX := TIniFile.Create(SaveDialog.FileName);
    IniFileX.WriteString('PhoneCommonInfo','Version','1.0');
    IniFileX.WriteString('PhoneCommonInfo','Comments','Driver for Siemens X75');
    IniFileX.WriteString('PhoneCommonInfo','Copyright','Chaos, Ported to V_Klay by ValeraVi');
    IniFileX.WriteString('PhoneCommonInfo','Name','R65/X75');
    IniFileX.WriteString('PhoneCommonInfo','MCUMemGeometry','0');
    IniFileX.WriteString('PhoneCommonInfo','optBaudCmdCodes','57600: 0x00, 115200: 0x01, 230400: 0x02, 460800: 0x03, 614400: 0x04, 921600: 0x05, 1228800: 0x06, 1600000: 0x07,');
    IniFileX.WriteString('PhoneCommonInfo','optCmdAddrAndSizeLen','4');
    IniFileX.WriteString('PhoneCommonInfo','optWriteCmdVersion','2');
    IniFileX.WriteString('PhoneCommonInfo','optTestEmptyCmdEnable','1');
    IniFileX.WriteString('PhoneCommonInfo','optKeepAliveCmdEnableAndSetInterval','250');

    IniFileX.WriteString('Phone01','Name','S75');
    IniFileX.WriteString('Phone01','Boots','ConnectX75, GoBoot.bin, BootX75.bin, Test.bin');
    IniFileX.WriteString('Phone01','Type','BootKey, Skey and NewFlash');
    IniFileX.WriteString('Phone01','Comments','Siemens  Phone S/SL75 (connecting, using boot password)');
    IniFileX.WriteString('Phone01','MCUMemFuBu',' fullflash, 0xA0000000, 0x04000000');
    IniFileX.WriteString('Phone01','MCUMemArea01',' BCORE,   0xA0000000, 0x00020000, bootcore');
    IniFileX.WriteString('Phone01','MCUMemArea02',' EELITE,  0xA0040000, 0x00020000');
    IniFileX.WriteString('Phone01','MCUMemArea03',' CODE,    0xA0080000, 0x0140A000');
    IniFileX.WriteString('Phone01','MCUMemArea04',' LngPack, 0xA1640000, 0x002D0000');
    IniFileX.WriteString('Phone01','MCUMemArea05',' GFXPack, 0xA19A0000, 0x00220000');
    IniFileX.WriteString('Phone01','MCUMemArea06',' FFS_A,   0xA1C00000, 0x01BC0000');
    IniFileX.WriteString('Phone01','MCUMemArea07',' FFS_C,   0xA37C0000, 0x00200000');
    IniFileX.WriteString('Phone01','MCUMemArea08',' FFS_B,   0xA39C0000, 0x005E0000');
    IniFileX.WriteString('Phone01','MCUMemArea09',' EEFULL,  0xA3FA0000, 0x00040000');
    IniFileX.WriteString('Phone01','MCUMemArea10',' SEXIT,   0xA3FE0000, 0x00020000');

    IniFileX.WriteString('Phone02','Name','S65');
    IniFileX.WriteString('Phone02','Boots','ConnectR65, GoBoot.bin, BootR65.bin, Test.bin');
    IniFileX.WriteString('Phone02','Type','BootKey, Skey and NewFlash');
    IniFileX.WriteString('Phone02','Comments','Siemens R65 Phone (connecting, using boot password or new/clear flash)');
    IniFileX.WriteString('Phone02','MCUMemFuBu',' fullflash, 0xA0000000, 0x02000000');
    IniFileX.WriteString('Phone02','MCUMemArea01',' BCORE,  0xA0000000, 0x00020000, bootcore');
    IniFileX.WriteString('Phone02','MCUMemArea02',' CODE1,  0xA0020000, 0x001E0000');
    IniFileX.WriteString('Phone02','MCUMemArea03',' EXIT,   0xA0200000, 0x00020000');
    IniFileX.WriteString('Phone02','MCUMemArea04',' EEFULL, 0xA0220000, 0x00040000');
    IniFileX.WriteString('Phone02','MCUMemArea05',' FFS_B,  0xA0260000, 0x00080000');
    IniFileX.WriteString('Phone02','MCUMemArea06',' FFS_C,  0xA02E0000, 0x00200000');
    IniFileX.WriteString('Phone02','MCUMemArea07',' FFS_A1, 0xA04E0000, 0x00320000');
    IniFileX.WriteString('Phone02','MCUMemArea08',' XCORE,  0xA0800000, 0x00020000');
    IniFileX.WriteString('Phone02','MCUMemArea09',' CODE2,  0xA0820000, 0x007C0000');
    IniFileX.WriteString('Phone02','MCUMemArea10',' EELITE, 0xA0FE0000, 0x00020000');
    IniFileX.WriteString('Phone02','MCUMemArea11',' CODE3,  0xA1000000, 0x00800000');
    IniFileX.WriteString('Phone02','MCUMemArea12',' FFS_A2, 0xA1800000, 0x00800000');


    IniFileX.WriteString('Boot01','Name','ConnectX75');
    IniFileX.WriteString('Boot01','UseIgnition','1');
    IniFileX.WriteString('Boot01','TryCount','-1');
    IniFileX.WriteString('Boot01','NoSendLen','1');
    IniFileX.WriteString('Boot01','Data','0sAT');
    IniFileX.WriteString('Boot01','NoSendCheckSum','1');
    IniFileX.WriteString('Boot01','Answer','C0');
    IniFileX.WriteString('Boot01','AnswerTimeout','20');

    IniFileX.WriteString('Boot03','Name','GoBoot.bin');
    IniFileX.WriteString('Boot03','NoSendLen','1');
    IniFileX.WriteString('Boot03','Data','30');
    IniFileX.WriteString('Boot03','NoSendCheckSum','1');

    IniFileX.WriteString('Boot02','Name','BootX75.bin');
    IniFileX.WriteString('Boot02','SizeLen','2');
    IniFileX.WriteString('Boot02','Data01',BufToHexStr(@ChaosBoot_x75,$40));
    IniFileX.WriteString('Boot02','Data02',BufToHexStr(@BootKey,SizeOf(BootKey)));
    IniFileX.WriteString('Boot02','Data03',BufToHexStr(@ChaosBoot_x75[$50],SizeOf(ChaosBoot_x75)-$50));
    IniFileX.WriteString('Boot02','Answer','C1A5');

    IniFileX.WriteString('Boot04','Name','Test.bin');
    IniFileX.WriteString('Boot04','DelayBefore','200');
    IniFileX.WriteString('Boot04','NoSendLen','1');
    IniFileX.WriteString('Boot04','Data','41');
    IniFileX.WriteString('Boot04','NoSendCheckSum','1');
    IniFileX.WriteString('Boot04','Answer','52');

    IniFileX.WriteString('Boot05','Name','ConnectR65');
    IniFileX.WriteString('Boot05','UseIgnition','1');
    IniFileX.WriteString('Boot05','TryCount','-1');
    IniFileX.WriteString('Boot05','NoSendLen','1');
    IniFileX.WriteString('Boot05','Data','0sAT');
    IniFileX.WriteString('Boot05','NoSendCheckSum','1');
    IniFileX.WriteString('Boot05','Answer','B0');
    IniFileX.WriteString('Boot05','AnswerTimeout','20');

    IniFileX.WriteString('Boot06','Name','BootR65.bin');
    IniFileX.WriteString('Boot06','SizeLen','2');
    IniFileX.WriteString('Boot06','Data01',BufToHexStr(@ChaosBoot_x75,$40));
    IniFileX.WriteString('Boot06','Data02',BufToHexStr(@BootKey,SizeOf(BootKey)));
    IniFileX.WriteString('Boot06','Data03',BufToHexStr(@ChaosBoot_x75[$50],SizeOf(ChaosBoot_x75)-$50));
    IniFileX.WriteString('Boot06','Answer','B1A5');



    IniFileX.UpdateFile;
    IniFileX.Free;
    IniFileX := Nil;
    IniFile.WriteString('Setup','OldVkdChFile',SaveDialog.FileName);
    StatusBar.Panels[PanelCmd].Text:='Сохранен '+SaveDialog.FileName;
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
  end; // if save dialog
end;


function SaveEepBin(txtmode: boolean; EepFileName:string; var eppbuf: Array of byte; eeplen,BlockId,xHWid,BlockVer:integer): boolean;
var
  S,EFileName,XFileName : string;
  i,z : integer;
  eepfile : THandle;
begin
    result:=False;
    if eeplen=0 then exit;
    EFileName:=ChangeFileExt(EepFileName,'')+'_'+IntToStr(BlockId);
    if txtmode then XFileName:=ChangeFileExt(EFileName, '.txt')
    else XFileName:=ChangeFileExt(EFileName, '.bin');

    eepfile:=FileCreate(XFileName);
    if eepfile<>INVALID_HANDLE_VALUE then begin // Запись в файл
     if txtmode then begin
      i:=0; z:=16;
      while eeplen>0 do begin
       if eeplen<=z then z:=eeplen;
       S:=BufToHex_Str(@eppbuf[i],z)+#13+#10;
       eeplen:=eeplen-z; i:=i+z;
       if FileWrite(eepfile,S[1],length(S))<>length(S) then begin
        FileClose(eepfile);
        ShowMessage('Ошибка записи '+XFileName+' файла!');
        exit;
       end;
      end; // while
     end // txt
     else if FileWrite(eepfile,eppbuf,eeplen)<>eeplen then begin
        FileClose(eepfile);
        ShowMessage('Ошибка записи '+XFileName+' файла!');
        exit;
     end;
     FileClose(eepfile);
    end;

    XFileName:=ChangeFileExt(EFileName, '.bid');
    eepfile:=FileCreate(XFileName);
    if eepfile<>INVALID_HANDLE_VALUE then begin // Запись в файл
     S:='EEPROM block additional file.'
     +#13+#10+'Phone HWid:'
     +#13+#10+IntToStr(xHWid)
     +#13+#10+'EEPROM BlockId:'
     +#13+#10+IntToStr(BlockId)
     +#13+#10+'EEPROM BlockVer:'
     +#13+#10+IntToStr(BlockVer)
     +#13+#10;
     if FileWrite(eepfile,S[1],length(S))=length(S) then result:=True;
     FileClose(eepfile);
    end;
    if  not result then ShowMessage('Ошибка записи '+XFileName+' файла!');
end;


procedure TFormMain.ButtonHashClick(Sender: TObject);
var
xESN : Dword;
begin
  ProgressBar.Position:=10;
  AddLinesLog('Проверка ввода значений...');
  if length(EditSkey.Text)<>0 then Skey:=StrToInt(EditSkey.Text)
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод SKEY!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  if length(EditESN.Text)=8 then xESN:=StrToInt('$'+EditESN.Text)
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод ESN!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  ProgressBar.Position:=80;
  AddLinesLog('Пересчет HASH и BootKEY из ESN и SKEY...');
  StatusBar.Panels[PanelCmd].Text:='Пересчет HASH и SKEY...';
  Repaint;
  CalkHashAndBkey(Skey,xESN);
  EditHASH.Text:=BufToHexStr(@HASH,16);
  EditBootKey.Text:=BufToHexStr(@BootKey,16);
  AddLinesLog('Новый HASH: '+EditHASH.Text);
  AddLinesLog('Новый BootKEY: '+EditBootKey.Text);
  IniFile.WriteInteger(sIMEI,'SKEY',Skey);
  IniFile.WriteString(sIMEI,'ESN',EditESN.Text);
  IniFile.WriteString(sIMEI,'BKEY',EditBootKey.Text);
  IniFile.WriteString(sIMEI,'HASH',BufToHexStr(@HASH,16));
  IniFile.WriteString(sIMEI,'BOOTKEY',BufToHexStr(@BootKey,16));
  StatusBar.Panels[PanelCmd].Text:='BootKEY: '+EditBootKey.Text;
  ProgressBar.Position:=100;
end;

procedure TFormMain.EditIMEIChange(Sender: TObject);
begin
  if Length(EditIMEI.Text)=15 then begin
     sIMEI:=EditIMEI.Text;
     ReadNewImeiIni;
     SpinEditHWID.Value:=IniFile.ReadInteger(sIMEI,'HWID',HW_IDNONE);
  end;
end;

procedure TFormMain.ButtonSaveCfgClick(Sender: TObject);
var
xESN : Dword;
begin
   if length(EditIMEI.Text)=15 then sIMEI:=EditIMEI.Text
   else begin
     StatusBar.Panels[PanelCmd].Text:='Неверный ввод IMEI';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
   end;
   IniFile.WriteString('Setup','IMEI',sIMEI);

   if (SpinEditHWID.Value<=HW_IDMIN) or (SpinEditHWID.Value>HW_IDMAX) then begin
     StatusBar.Panels[PanelCmd].Text:='Неверный ввод HWID!';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
   end;
   IniFile.WriteInteger(sIMEI,'HWID',SpinEditHWID.Value);

   if length(EditESN.Text)=8 then xESN:=StrToInt('$'+EditESN.Text)
   else begin
     StatusBar.Panels[PanelCmd].Text:='Неверный ввод ESN!';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
   end;
   IniFile.WriteString(sIMEI,'ESN',IntToHex(xESN,8));
   EditESN.Text:=IntToHex(xESN,8);

   if length(EditHash.Text)=32 then HexTopByte(@EditHash.Text[1],16,@HASH)
   else begin
     StatusBar.Panels[PanelCmd].Text:='Неверный ввод HASH!';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
   end;
   IniFile.WriteString(sIMEI,'HASH',BufToHexStr(@HASH,16));
   EditHash.Text:=BufToHexStr(@HASH,16);

   if length(EditBootKey.Text)=32 then HexTopByte(@EditBootKey.Text[1],16,@BootKey)
   else begin
     StatusBar.Panels[PanelCmd].Text:='Неверный ввод BootKEY!';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
   end;
   IniFile.WriteString(sIMEI,'BKEY',BufToHexStr(@BootKey,16));
   EditBootKey.Text:=BufToHexStr(@BootKey,16);

   if length(EditSkey.Text)<>0 then Skey:=StrToInt(EditSkey.Text)
   else begin
     StatusBar.Panels[PanelCmd].Text:='Неверный ввод SKEY!';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
   end;
   IniFile.WriteInteger(sIMEI,'SKEY',SKey);
end;

procedure TFormMain.Label10Click(Sender: TObject);
begin
   ShellExecute(Application.Handle, 'open',
               PChar('http://forum.allsiemens.com/viewtopic.php?t=8978'),
               nil, '', SW_SHOWNORMAL);
end;

procedure TFormMain.Label13Click(Sender: TObject);
begin
   ShellExecute(Application.Handle, 'open',
               PChar('http://forum.siemens-club.org/viewtopic.php?TopicID=47185'),
               nil, '', SW_SHOWNORMAL);
end;

procedure TFormMain.ButtonX65VKD2Click(Sender: TObject);
begin
  AddLinesLog('Проверка ввода значений...');
  if length(EditIMEI.Text)=15 then sIMEI:=EditIMEI.Text
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод IMEI!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  if length(EditBootKey.Text)=32 then HexTopByte(@EditBootKey.Text[1],16,@BootKey)
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод BootKEY!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  Move(BootKey,ChaosBoot1[$40],16);
   with SaveDialog do begin
     FilterIndex:=1;
     FileName := IniFile.ReadString('Setup','OldVkd32File','x65.vkd');
     InitialDir := ExtractFilePath(FileName);
     FileName := ExtractFileName(FileName);
     if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
     if not DirectoryExists(InitialDir) then
      InitialDir := IniFile.ReadString('Setup','DirOld','.\');
     DefaultExt := 'vkd';
     Filter := 'vkd files (*.vkd)|*.vkd|All files (*.*)|*.*';
     Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
     Title:='Сохранить новый пароль в бутлоадер';
   end;//with
  if SaveDialog.Execute then begin
    IniFileX := TIniFile.Create(SaveDialog.FileName);
    IniFileX.WriteString('Boot06','Data02',' '+BufToHexStr(@BootKey,16));
    IniFileX.UpdateFile;
    IniFileX.Free;
    IniFileX := Nil;
    IniFile.WriteString('Setup','OldVkd32File',SaveDialog.FileName);
    StatusBar.Panels[PanelCmd].Text:='Сохранен '+SaveDialog.FileName;
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
  end; // if save dialog
end;

procedure TFormMain.ButtonSave512xClick(Sender: TObject);
Var
 xEsn : DWord;
 txtmode : boolean;
begin
  ProgressBar.Position:=10;
  AddLinesLog('Проверка ввода значений...');
  if length(EditIMEI.Text)=15 then sIMEI:=EditIMEI.Text
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод IMEI!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  ProgressBar.Position:=15;
  if length(EditSkey.Text)<>0 then Skey:=StrToInt(EditSkey.Text)
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод SKEY!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  ProgressBar.Position:=20;
  if length(EditESN.Text)=8 then xESN:=StrToInt('$'+EditESN.Text)
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод ESN!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  ProgressBar.Position:=25;
  if (SpinEditHWID.Value<=HW_IDMIN) or (SpinEditHWID.Value>HW_IDMAX) then begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод HWID!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  ProgressBar.Position:=30;
  if length(EditHash.Text)=32 then HexTopByte(@EditHash.Text[1],16,@HASH)
  else begin
   FillChar(HASH,16,0);
  end;
  ProgressBar.Position:=35;
  if not TestSkey(False) then begin
    if MessageDlg('SKEY или ESN не совпадает с введёнными HASH!'+#10+#13+'Пересчитать HASH и BootKEY?',
        mtConfirmation, [mbYes, mbNo], 0) <> mrYes
    then begin
        CalkHashAndBkey(Skey,xESN);
        ProgressBar.Position:=40;
        EditHASH.Text:=BufToHexStr(@HASH,16);
        EditBootKey.Text:=BufToHexStr(@BootKey,16);
        AddLinesLog('Новый HASH: '+EditHASH.Text);
        AddLinesLog('Новый BootKEY: '+EditBootKey.Text);
    end
    else begin
     StatusBar.Panels[PanelCmd].Text:='Неверный ввод HASH!';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
    end;
  end;
  ProgressBar.Position:=50;

   AddLinesLog('IMEI: '+sImei);
   AddLinesLog('ESN: '+IntToHex(xEsn,8));
   AddLinesLog('SKEY: '+IntToStr(Skey));
   AddLinesLog('HWID: '+IntToStr(SpinEditHWID.Value));
   AddLinesLog('HASH: '+BufToHexStr(@HASH,16));
   AddLinesLog('BootKEY: '+BufToHexStr(@BootKey,16));

  ProgressBar.Position:=55;

   IniFile.WriteString('Setup','IMEI',sIMEI);
//    IniFile.WriteString(sIMEI,'Phone',sDevMan+' '+sPhoneModel+' '+sSoftWareVer+' '+sLgVer);
   IniFile.WriteInteger(sIMEI,'HWID',SpinEditHWID.Value);
   IniFile.WriteString(sIMEI,'ESN',IntToHex(xESN,8));
   IniFile.WriteInteger(sIMEI,'SKEY',SKey);
   IniFile.WriteString(sIMEI,'HASH',BufToHexStr(@HASH,16));
   IniFile.WriteString(sIMEI,'BKEY',BufToHexStr(@BootKey,16));
//   IniFile.WriteString(sIMEI,'MAIL',EditRemCode.Text);

   EditIMEI.Text:='?';
   EditIMEI.Text:=sImei;

   ProgressBar.Position:=60;
// Create 5121,5122,5123 blocks
   Create512x(sImei,xESN,Skey,Mkey);
   AddLinesLog('*#0000*'+Int2Digs(Mkey[0],8)+'# - Блокировка Сети?');
   AddLinesLog('*#0001*'+Int2Digs(Mkey[1],8)+'# - Блокировка Поставщика услуг?');
   AddLinesLog('*#0002*'+Int2Digs(Mkey[2],8)+'# - Персонализация Поставщика услуг?');
   AddLinesLog('*#0003*'+Int2Digs(Mkey[3],8)+'# - Телефонный Код?');
   AddLinesLog('*#0004*'+Int2Digs(Mkey[4],8)+'# - Блокировка Абонентского аппарата Сети?');
   AddLinesLog('*#0005*'+Int2Digs(Mkey[5],8)+'# - Только Сим?');

   ProgressBar.Position:=75;
   with SaveDialog do begin
     FilterIndex:=IniFile.ReadInteger('Setup','OldEepFIndex',1);
     if ((FilterIndex<=0) or (FilterIndex>2)) then FilterIndex:=1;
     FileName := IniFile.ReadString('Setup','OldEepFile','.\EEPROM\'+sImei);
     InitialDir := ExtractFilePath(FileName);
     FileName := sImei; //ChangeFileExt(ExtractFileName(FileName),'');
     if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
     if not DirectoryExists(InitialDir) then
      InitialDir := IniFile.ReadString('Setup','DirOld','.\');
     DefaultExt := 'bin';
     Filter := 'bin files (*.bin)|*.bin|txt files (*.txt)|*.txt';
     Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
     Title:='Сохранить блоки EEPROM 512x в файлы';
   end;//with
  if SaveDialog.Execute then begin
    if SaveDialog.FilterIndex=2 then txtmode:=True
    else txtmode:=False;
    if SaveEepBin(txtmode,SaveDialog.FileName,EEP5121,sizeof(EEP5121),5121,SpinEditHWID.Value,0)
       and SaveEepBin(txtmode,SaveDialog.FileName,EEP5122,sizeof(EEP5122),5122,SpinEditHWID.Value,0)
       and SaveEepBin(txtmode,SaveDialog.FileName,EEP5123,sizeof(EEP5123),5123,SpinEditHWID.Value,0) then begin
         ProgressBar.Position:=90;
         IniFile.WriteString('Setup','OldEepFile',ChangeFileExt(SaveDialog.FileName,''));
         IniFile.WriteInteger('Setup','OldEepFIndex',SaveDialog.FilterIndex);
         StatusBar.Panels[PanelCmd].Text:='Блоки сохранены в '+ChangeFileExt(SaveDialog.FileName,'')+'_512x файлы';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    end;
  end; // if save dialog
  if MessageDlg('Записать блоки 512x в телефон?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes
  then begin
   if ComOpen then begin
    if WriteEepBlock(5121,sizeof(EEP5121),0,EEP5121)
    and WriteEepBlock(5122,sizeof(EEP5122),0,EEP5122)
    and WriteEepBlock(5123,sizeof(EEP5123),0,EEP5123)
    then begin
      StatusBar.Panels[PanelCmd].Text:='Блоки 512x записаны в телефон.';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    end;
    ComClose;
   end; // if ComOpen
  end;
  ProgressBar.Position:=100;
end;

var
flagdpmenu : boolean = False;
procedure TFormMain.TestRegKeys;
begin
    if not flagdpmenu then begin
     if IniFile.ReadBool('System','TestOn',False) then begin
      CheckBoxRdOTP.Visible := True;
      CheckBoxRdCFI.Visible := True;
      CheckBoxTest.Visible:=True;
      ButtonTest.Visible:=True;
      CheckSaveInfo.Visible:=True;
     end;
     flagdpmenu := true;
    end;
end;


procedure TFormMain.Label16Click(Sender: TObject);
begin
   if fDebug then TestRegKeys;
end;


function TFormMain.InvalidateInstance(sFFS:string): boolean;
var
 u : word;
begin
   result:=False;
   ProgressBar.Position:=5;
   if MessageDlg('Вы уверены, что надо отформатировать '+sFFS+'?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes
    then begin
    ProgressBar.Position:=10;
    if ComOpen then begin
     ProgressBar.Position:=15;
     if BFC_GetCurentUbat(u) then begin
      if (u<3750)and(MessageDlg('Аккумулятор разряжен!'+#10+#13+'Всего '+IntToStr(u)+' mV.'+#10+#13+'Продолжить?',
       mtConfirmation, [mbYes, mbNo], 0) <> mrYes)
       then begin
        ComClose;
        Exit;
       end;
     end;
        ProgressBar.Position:=20;
        if BFC_Format_Instance_Ready then begin
          if BFC_Invalidate_Instance(sFFS) then begin
            while(ProgressBar.Position<85) do begin
             if BFC_Format_Instance_Ready then break;
             sleep(250);
             ProgressBar.StepBy(5);
            end;
            if ProgressBar.Position>=85 then begin
             StatusBar.Panels[PanelCmd].Text:='Нет ответа готовности к формату '+sFFS+'!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            end
            else begin
             AddLinesLog('При следующей загрузке произойдет формат '+sFFS+'!');
             AddLinesLog('Нажать кнопку Включения и ждать около 2..5 минут!');
             StatusBar.Panels[PanelCmd].Text:='Запрос формата '+sFFS+' - Ok.';
             result:=True;
            end;
          end
          else begin
            StatusBar.Panels[PanelCmd].Text:='Запрос формата '+sFFS+' - Error!';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          end;
        end
        else begin
         StatusBar.Panels[PanelCmd].Text:='Нет ответа готовности к формату'+sFFS+'!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         if BFC_Error<>ERR_NO then StatusBar.Panels[PanelCmd].Text:='Ошибка!'
         else StatusBar.Panels[PanelCmd].Text:='Уже идет формат Instance!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        end;
        ProgressBar.Position:=90;
        ComClose;
        ProgressBar.Position:=100;
    end; //ComOpen
   end;
end;

procedure TFormMain.ButtonInvalidateInstanceFFSClick(Sender: TObject);
begin
   InvalidateInstance('FFS');
end;

procedure TFormMain.ButtonInvalidateInstanceFFS_CClick(Sender: TObject);
begin
   if MessageDlg('Вы уверены, что понимаете - что делаете?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes
    then begin
     if InvalidateInstance('FFS_C') then  ShowMessage('Теперь потребуется заливка ХФС или бэкапа ФуллФлэш!');
    end;
end;

procedure TFormMain.ButtonInvalidateInstanceFFS_BClick(Sender: TObject);
begin
   InvalidateInstance('FFS_B');
end;

procedure TFormMain.ButtonSetFreezeClick(Sender: TObject);
begin
      ProgressBar.Position:=10;
      if ComOpen then begin
        ProgressBar.Position:=35;
        if GetMobileInfo then begin
          EditFreezeIMEI.Text:=sIMEI;
          ProgressBar.Position:=85;
        end;
        ComClose;
        ProgressBar.Position:=100;
      end;
end;

procedure TFormMain.ButtonCpySetFreezeClick(Sender: TObject);
begin
          EditFreezeIMEI.Text:=sIMEI;
end;

function TFormMain.ReadEepBlock(num,len: dword; var ver: byte; var buf: array of byte): boolean;
var
xlen : dword;
begin
        result:=False;
        AddLinesLog('Чтение блока '+IntToStr(num)+'...');
        if BFC_EE_Get_Block_Info(num,xlen,ver) then begin
//          AddLinesLog('Размер: '+IntToStr(xlen)+', Версия: '+IntToStr(ver));
          if (len=xlen) then begin
           if BFC_EE_Read_Block(num,0,len,buf) then begin
//            AddLinesLog('Блок '+IntToStr(num)+' прочитан.');
            result:=True;
           end
           else begin
            StatusBar.Panels[PanelCmd].Text:='Ошибка чтения блока '+IntToStr(num)+'!';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           end;
          end
          else begin
           StatusBar.Panels[PanelCmd].Text:='Неизвестная длина блока '+IntToStr(num)+'!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           AddLinesLog('Ожидалось '+IntToStr(len)+' байт! Получили '+IntToStr(xlen)+' байт.');
          end;
        end
        else begin
         if BFC_Error=ERR_EEP_NONE then StatusBar.Panels[PanelCmd].Text:='Блок '+IntToStr(num)+' не открыт либо отсутствует!'
         else StatusBar.Panels[PanelCmd].Text:='Ошибка чтения инфо по блоку '+IntToStr(num)+'!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        end;
end;

procedure TFormMain.ButtonFreezeClick(Sender: TObject);
var
err : word;
sText : string;
buf :array[0..289] of byte;
Bufw :array[0..31] of word;
OtpESN,xSkey : dword;
ver : byte;
i : integer;
begin
  ProgressBar.Position:=5;
  AddLinesLog('Проверка ввода значений и необходимых блоков...');
  i:=length(EditFreezeIMEI.Text);
  if i=15 then sText:=EditFreezeIMEI.Text
  else if i=14 then sText:=EditFreezeIMEI.Text
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод IMEI';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  if not CalkImei15(sText,Char(ver)) then begin
    StatusBar.Panels[PanelCmd].Text:='IMEI некорректен!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  setlength(sText,14);
  EditIMEI.Text:=sText+Char(ver);
  EditFreezeIMEI.Text:=sIMEI;
  //  sIMEI:=sText+Char(ver);
  AddLinesLog('IMEI: '+sIMEI);
  if ComOpen then begin
   ProgressBar.Position:=13;
   BFC_SecurityMode;
   if BFC_Error<>ERR_NO then begin
    StatusBar.Panels[PanelCmd].Text:='Нет ответа на запрос статуса режима!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    ComClose; exit;
   end;
   if Not((bSecyrMode=$12) or (bSecyrMode = $13)) then begin
    StatusBar.Panels[PanelCmd].Text:='Возможно только при "Factory" СтатусеЗащиты!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    ComClose; exit;
   end;
   if Not BFC_GetSecurityInfo(Bufw,SizeOf(bufw)) then begin
    StatusBar.Panels[PanelCmd].Text:='Невозможно получить доп.информацию!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    ComClose; exit;
   end;
   ProgressBar.Position:=16;
   err:=0;
   i:=1;
   while i<=Bufw[0] do begin
    case Bufw[i] of
     $05: begin sText:='OTP область закрыта для записи!'; err:=err or $000002; end;
     $08: begin sText:='BootKEY неизвестен!'; err:=err or $000004; end;
     $0A: begin sText:='Запись BootKEY отсутствует в EEPROM!'; err:=err or $000010; end;
     $0D: begin sText:='Ключи прописаны в BCORE!'; err:=err or $000040; end;
     $0E: begin sText:='Отсутствие таблицы ссылок на команды!'; err:=err or $000080; end;
     $10: begin sText:='BFC функции недоступны!'; err:=err or $000100; end;
     $11: begin sText:='Сервисный доступ к BFC функциям!'; err:=err or $000200; end;
     $16: begin sText:='Режим СЦ "S"!'; err:=err or $001000; end;
     $18: begin sText:='Блок 76 пустой!'; err:=err or $002000; end;
     $1B: begin sText:='Блок 76 не найден!'; err:=err or $010000; end;
     $1C: begin sText:='Отсутствие блока 5123!'; err:=err or $02000; end;
     $1E: begin sText:='Отсутствие блока 5121!'; err:=err or $100000; end;
     $20: break;
     else sText:='';
    end; // case
    if sText<>'' then AddLinesLog('Код('+IntToHex(Bufw[i],2)+'): '+sText);
    inc(i);
   end; // while
   if (err and $fffffffd)<>0  then begin
    StatusBar.Panels[PanelCmd].Text:='В данном режиме Фреза невозможна!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
{    if MessageDlg('Проверить и восстановить все блоки?',
        mtConfirmation, [mbYes, mbNo], 0) <> mrYes
    then begin
     AddLinesLog('Проверка блоков и фреза отменены!'); }
     ComClose; exit;
//    end;
   end;
   if (err and $2)<>0  then begin
    i:=8;
    if not BFC_ReadOtpBlk(0,0,i) then begin
      StatusBar.Panels[PanelCmd].Text:='Не читается OTP IMEI!';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    end
    else begin
      SetLength(sText,14);
      for i:=2 to 16 do begin
       if (i and 1)=0 then Byte(sText[i-1]):=$30+(ibfc.cd.pb[i shr 1] and $0f)
       else Byte(sText[i-1]):=$30+((ibfc.cd.pb[i shr 1] and $f0) shr 4);
      end;
      if CalkImei15(sText,Char(ver)) then begin
       sText:=sText+Char(ver);
       StatusBar.Panels[PanelCmd].Text:='OTP IMEI: '+sText;
       AddLinesLog(StatusBar.Panels[PanelCmd].Text);
       if sIMEI<>sText then begin
        EditIMEI.Text:=sText;
        StatusBar.Panels[PanelCmd].Text:='IMEI не соответствует данным OTP!';
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        AddLinesLog('Берем OTP IMEI!');
       end;
      end
      else begin
       StatusBar.Panels[PanelCmd].Text:='OTP IMEI неверен!';
       AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      end;
    end;
   end;
   ProgressBar.Position:=18;
   if not BFC_GetEsn(OtpESN) then begin
    StatusBar.Panels[PanelCmd].Text:='Нет ответа на запрос OTP ESN!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    ComClose; exit;
   end;
   AddLinesLog('OTP ESN: '+IntToHex(OtpESN,8));
   ProgressBar.Position:=20;
//EEP5122
   if not ReadEepBlock(5122,SizeOf(EEP5122),ver,EEP5122) then begin
    ComClose; exit;
   end;
   xSkey:=Dword((@EEP5122[0])^);
   if xSkey=0 then begin
    StatusBar.Panels[PanelCmd].Text:='SKEY = 0! Операция невозможна!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    ComClose; exit;
   end;
   if word((@EEP5122[4])^)<>$58 then begin
    StatusBar.Panels[PanelCmd].Text:='Модификатор SKEY не равен "X"!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    AddLinesLog('Фреза невозможна!');
    ComClose; exit;
   end;
   AddLinesLog('SKEY: X'+IntToStr(xSkey));
//EEP0052
   ProgressBar.Position:=22;
   if not ReadEepBlock(52,SizeOf(EEP0052),ver,buf) then begin
    ComClose; exit;
   end;
   Create52(OtpESN,xSkey,SpinEditVerDown.Value);
   err:=0;
   for i:=0 to 15 do
   if buf[i]<>EEP0052[i] then begin
    inc(err);
    break;
   end;
   for i:=17 to SizeOf(EEP0052)-1 do
   if buf[i]<>EEP0052[i] then begin
    inc(err);
    break;
   end;
   if err<>0 then begin
    StatusBar.Panels[PanelCmd].Text:='Блок 52 содержит неверные данные!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    AddLinesLog('Фреза невозможна!');
    ComClose; exit;
   end;
   if buf[16]=$FF then AddLinesLog('"Откат" будет установлен на текущую версию.')
   else AddLinesLog('"Откат" будет установлен на '+IntToHex(buf[16],2)+' версию.');
//EEP0076
   ProgressBar.Position:=24;
   if not ReadEepBlock(76,SizeOf(EEP0076),ver,buf) then begin
    ComClose; exit;
   end;
   Create76(sIMEI,EEP0076,C55);
   err:=0;
   for i:=0 to SizeOf(EEP0076)-1 do
   if buf[i]<>EEP0076[i] then begin
    inc(err);
    break;
   end;
   if err<>0 then begin
    StatusBar.Panels[PanelCmd].Text:='Блок 76 содержит неверные данные!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    AddLinesLog('Фреза невозможна!');
    ComClose; exit;
   end;
//EEP5009
   ProgressBar.Position:=26;
   if not ReadEepBlock(5009,SizeOf(EEP5009),ver,buf) then begin
    ComClose; exit;
   end;
   Create5009(sIMEI,EEP5009,C55);
   err:=0;
   for i:=0 to SizeOf(EEP5009)-1 do
   if buf[i]<>EEP5009[i] then begin
    inc(err);
    break;
   end;
   if err<>0 then begin
    StatusBar.Panels[PanelCmd].Text:='Блок 5009 содержит неверные данные!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    AddLinesLog('Фреза невозможна!');
    ComClose; exit;
   end;
{
//EEP5008
   if not ReadEepBlock(5008,SizeOf(EEP5008),ver,buf) then begin
    ComClose; exit;
   end;
   ProgressBar.Position:=22;
   Create5008(sIMEI,OtpESN,EEP5008,C55);
   err:=0;
   for i:=0 to SizeOf(EEP5008)-1 do
   if buf[i]<>EEP5008[i] then begin
    inc(err);
    break;
   end;
   if err<>0 then begin
    StatusBar.Panels[PanelCmd].Text:='Блок 5008 содержит неверные данные!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    AddLinesLog('Фреза невозможна!');
    ComClose; exit;
   end;
//EEP5077
   if not ReadEepBlock(5077,SizeOf(EEP5077),ver,buf) then begin
    ComClose; exit;
   end;
   ProgressBar.Position:=22;
   Create5077(sIMEI,OtpESN,EEP5077,C55);
   err:=0;
   for i:=0 to SizeOf(EEP5077)-1 do
   if buf[i]<>EEP5077[i] then begin
    inc(err);
    break;
   end;
   if err<>0 then begin
    StatusBar.Panels[PanelCmd].Text:='Блок 5077 содержит неверные данные!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    AddLinesLog('Фреза невозможна!');
    ComClose; exit;
   end;
}
//EEP5121
   ProgressBar.Position:=28;
   if not ReadEepBlock(5121,SizeOf(EEP5121),ver,buf) then begin
    ComClose; exit;
   end;
   Create512x(sIMEI,OtpESN,xSkey,Mkey);
   err:=0;
   for i:=0 to 7 do
   if buf[i]<>EEP5121[i] then begin
    inc(err);
    break;
   end;
   if err<>0 then begin
    StatusBar.Panels[PanelCmd].Text:='Блок 5121 содержит неверные данные!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    AddLinesLog('Фреза невозможна!');
    ComClose; exit;
   end;
//EEP5123
   ProgressBar.Position:=30;
   if not ReadEepBlock(5123,SizeOf(EEP5123),ver,buf) then begin
    ComClose; exit;
   end;
//   Create512x(sIMEI,OtpESN,xSkey,Mkey);
   err:=0;
   for i:=0 to SizeOf(EEP5123)-1 do
   if buf[i]<>EEP5123[i] then begin
    inc(err);
    break;
   end;
   if err<>0 then begin
    StatusBar.Panels[PanelCmd].Text:='Блок 5123 содержит неверные данные!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    AddLinesLog('Фреза невозможна!');
    ComClose; exit;
   end;
   if MessageDlg('Freeze?',
       mtConfirmation, [mbYes, mbNo], 0) <> mrYes
   then begin
    StatusBar.Panels[PanelCmd].Text:='Фреза отменена!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    ComClose; exit;
   end
   else begin
     ProgressBar.Position:=75;
     if BFC_FreezeSecurityData(sIMEI,err) then begin
      sText:='Freeze('+IntToStr(err)+'): ';
      case err of
       $00: sText:=sText+'OK!(Успешно!)';
       $01: sText:=sText+'Не поддерживается!';
       $02: sText:=sText+'Только в "Сервисном режиме"!';
       $03: sText:=sText+'Доступ запрещен!';
       $04: sText:=sText+'IMEI неверен!';
       $05: sText:=sText+'Выполнено, но запись IMEI в OTP пропушенна!';
       $06: sText:=sText+'Телефон не требует Фрезу!';
       $07: sText:=sText+'Неверный ввод данных в EEPROM!';
      else sText:=sText+'Неизвестная ошибка!';
      end;
      StatusBar.Panels[PanelCmd].Text:=sText;
      AddLinesLog(sText);
      end
      else  begin
       StatusBar.Panels[PanelCmd].Text:='Фреза = Error!';
       AddLinesLog(StatusBar.Panels[PanelCmd].Text);
       ComClose; exit;
      end;
      Skey:=xSkey;
      EditESN.Text:=IntToHex(OtpESN,8);
      EditSkey.Text:=IntToStr(SKey);
      CalkHashAndBkey(Skey,OtpESN);
      EditHASH.Text:=BufToHexStr(@HASH,16);
      EditBootKey.Text:=BufToHexStr(@BootKey,16);
      EditBootKey.Text:=BufToHexStr(@BootKey,16);
      IniFile.WriteString('Setup','IMEI',sIMEI);
      IniFile.WriteString(sIMEI,'ESN',EditESN.Text);
      IniFile.WriteInteger(sIMEI,'SKEY',Skey);
      IniFile.WriteString(sIMEI,'BKEY',EditBootKey.Text);
      IniFile.WriteString(sIMEI,'HASH',EditHASH.Text);
      AddLinesLog('Внимание: Запомните новые коды!');
      AddLinesLog('При следующем включении будут записаны ключи в BCORE (и OTP)!');
      AddLinesLog('IMEI: '+sIMEI);
      AddLinesLog('SKEY: '+IntToStr(SKey));
      AddLinesLog('BootKEY: '+BufToHexStr(@BootKey,16));
      ProgressBar.Position:=100;
   end;
  end; // if ComOpen
  ComClose;
//  end;
end;

procedure TFormMain.ButtonStatusOTPClick(Sender: TObject);
var
State:word;
begin
      ProgressBar.Position:=10;
      if ComOpen then begin
        ProgressBar.Position:=35;
        if BFC_GetOtpLockState(State) then begin
          if State<>0 then StatusBar.Panels[PanelCmd].Text:='OTP Статус: Закрыто.'
          else StatusBar.Panels[PanelCmd].Text:='OTP Статус: Открыто.';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          ProgressBar.Position:=85;
        end
        else  begin
          StatusBar.Panels[PanelCmd].Text:='Нет ответа на "OTP статус"!';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          AddLinesLog('Используй SKEY!');
        end;
        ComClose;
        ProgressBar.Position:=100;
      end;
end;

procedure TFormMain.ButtonLockOtpClick(Sender: TObject);
begin
   ProgressBar.Position:=10;
   if MessageDlg('Вы уверены что закрываем (!) запись в OTP?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes
   then begin
      if ComOpen then begin
        ProgressBar.Position:=35;
        if BFC_FlashManagerLockOtp then begin
          StatusBar.Panels[PanelCmd].Text:='OTP закрыто.';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          ProgressBar.Position:=85;
        end
        else  begin
          StatusBar.Panels[PanelCmd].Text:='Ошибка закрытия OTP!';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          AddLinesLog('Используй SKEY!');
        end;
        ComClose;
        ProgressBar.Position:=100;
      end;
   end;
end;

procedure TFormMain.ButtonGetOtpEsnClick(Sender: TObject);
var
OtpESN:dword;
begin
      ProgressBar.Position:=10;
      if ComOpen then begin
        ProgressBar.Position:=35;
        if BFC_GetEsn(OtpESN) then begin
          StatusBar.Panels[PanelCmd].Text:='OTP ESN: '+IntToHex(OtpESN,8);
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          ProgressBar.Position:=85;
        end
        else  begin
          StatusBar.Panels[PanelCmd].Text:='Нет ответа на запрос OTP ESN!';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          AddLinesLog('Используй SKEY!');
        end;
        ComClose;
        ProgressBar.Position:=100;
      end;
end;

function TFormMain.StrOtpImei(var s: string) : boolean;
var
blk_len: dword;
i : integer;
sxImei: string;
c : char;
begin
        result:=False;
        if BFC_GetOtpBlockLength(0,blk_len) then begin
          if blk_len = 8 then begin
            if BFC_ReadOtpBlk(0,0,blk_len) then begin
              SetLength(sxImei,14);
              for i:=2 to 16 do begin
                if (i and 1)=0 then Byte(sxImei[i-1]):=$30+(ibfc.cd.pb[i shr 1] and $0f)
                else Byte(sxImei[i-1]):=$30+((ibfc.cd.pb[i shr 1] and $f0) shr 4);
              end;
                if CalkImei15(sxImei,c) then sxImei:=sxImei+c;
                s:='Заводской (OTP) IMEI: '+sxImei;
                if sxImei=sImei then s:=s + ' - Соответствует данным прошивки.'
                else s:=s + ' - нет соответствия данным прошивки!';
                result:=True;
            end
            else begin
              s:='Не читается OTP IMEI!';
            end;
          end
          else begin
            s:='Неверный размер OTP IMEI!';
          end;
        end
        else  begin
          s:='Нет ответа на запрос OTP IMEI!';
        end;
end;

procedure TFormMain.ButtonGetOtpImeiClick(Sender: TObject);
var
s: string;
begin
      ProgressBar.Position:=10;
      if ComOpen then begin
        ProgressBar.Position:=40;
        StrOtpImei(s);
        ComClose;
        StatusBar.Panels[PanelCmd].Text:=s;
        AddLinesLog(s);
        ProgressBar.Position:=100;
      end;
end;

procedure TFormMain.ButtonReadBcoreClick(Sender: TObject);
var
Buf: array [0..$fff] of byte;
Addr: dword;
bfile : THandle;
begin
   StatusBar.Panels[PanelCmd].Text:='Сохранить BCORE в файл...';
   AddLinesLog(StatusBar.Panels[PanelCmd].Text);
   ProgressBar.Position:=5;
   with SaveDialog do begin
     FilterIndex:=0;
     FileName := IniFile.ReadString('Setup','OldBcoreFile','.\Bin\BCORE.bin');
     InitialDir := ExtractFilePath(FileName);
     FileName := ChangeFileExt(ExtractFileName(FileName),'');
     if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
     if not DirectoryExists(InitialDir) then
      InitialDir := IniFile.ReadString('Setup','DirOld','.\');
     DefaultExt := 'bin';
     Filter := 'bin files (*.bin)|*.bin';
     Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
     Title:='Сохранить блок BCORE в файл';
   end;//with
  if SaveDialog.Execute then begin
    Repaint;
    bfile:=FileCreate(SaveDialog.FileName);
    if bfile<>INVALID_HANDLE_VALUE then begin // Запись в файл
      ProgressBar.Position:=10;
      if ComOpen then begin
        ProgressBar.Position:=20;
        addr:=$A0000000;
//        addr:=$A0220000; //EEFULL
        SetComRxTimeOuts(100,1,500);
        while addr<$A0020000 do begin
//        while addr<$A0260000 do begin
          if BFCReadMem(addr,sizeof(Buf),Buf) then begin
            if FileWrite(bfile,Buf,sizeof(Buf))<>sizeof(Buf) then begin
              FileClose(bfile);
              ComClose;
              StatusBar.Panels[PanelCmd].Text:='Ошибка записи '+SaveDialog.FileName+' файла!';
//              ShowMessage();
              AddLinesLog(StatusBar.Panels[PanelCmd].Text);
              exit;
            end;
          end
          else begin
            StatusBar.Panels[PanelCmd].Text:='Ошибка чтения блока 0x'+IntToHex(addr,8)+'!';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            FileClose(bfile);
            ComClose;
            exit;
          end;
          ProgressBar.StepBy(2); //max +64
          addr:=addr+sizeof(Buf);
        end;
        FileClose(bfile);
        bfile:=INVALID_HANDLE_VALUE;
        ComClose;
        StatusBar.Panels[PanelCmd].Text:='BCORE сохранен в '+SaveDialog.FileName;
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        IniFile.WriteString('Setup','OldBcoreFile',SaveDialog.FileName);
        ProgressBar.Position:=100;
      end; // if ComOpen
    end
    else begin
     StatusBar.Panels[PanelCmd].Text:='Не создать '+SaveDialog.FileName;
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    end;
    if bfile<>INVALID_HANDLE_VALUE then FileClose(bfile);
  end;
end;

procedure TFormMain.ButtonClearBcoreClick(Sender: TObject);
var
 iFHandle : THandle;
 iFileSize : Integer;
 iBytesRead: Integer;
 chBuffer: array[0..$1FFFF] of Byte;
begin
   iFHandle:=INVALID_HANDLE_VALUE;
   ProgressBar.Position:=10;
   with OpenDialog do begin
    FilterIndex:=1;
    InitialDir := '.';
    DefaultExt := 'bin';
    Filter := 'Bin files (*.bin)|*.bin|All files (*.*)|*.*';
    Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
    Title:='Выбор файла c BCORE (Сегмент или FullFlash)';
   end;//with OpenDialog
   if OpenDialog.execute then begin
    iFHandle:=FileOpen(OpenDialog.FileName,fmOpenRead or fmShareCompat);
    if iFHandle<>INVALID_HANDLE_VALUE then begin
      iFileSize:=$20000;
      iBytesRead := FileRead(iFHandle, chBuffer, iFileSize);
      FileClose(iFHandle);
      iFHandle:=INVALID_HANDLE_VALUE;
      if iBytesRead=iFileSize then begin
       ProgressBar.Position:=30;
       if ClearBCoreBuf(chBuffer[0]) then begin
        // сохраняем
        with SaveDialog do begin
         FilterIndex:=0;
         FileName := ExtractFileName(OpenDialog.FileName);
         InitialDir := ExtractFilePath(OpenDialog.FileName);
         DefaultExt := 'bin';
         Filter := 'bin files (*.bin)|*.bin';
         Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
          +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
          -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
          -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
         Title:='Сохранить блок BCORE в файл';
        end;//with
        ProgressBar.Position:=40;
        if SaveDialog.Execute then begin
         ProgressBar.Position:=60;
         iFHandle:=FileCreate(SaveDialog.FileName);
         if iFHandle<>INVALID_HANDLE_VALUE then begin // Запись в файл
          ProgressBar.Position:=80;
          if FileWrite(iFHandle,chBuffer,$20000)=$20000 then begin
            FileClose(iFHandle);
            StatusBar.Panels[PanelCmd].Text:='Файл записан в '+SaveDialog.FileName;
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            ProgressBar.Position:=100;
            exit;
          end;
         end;
         StatusBar.Panels[PanelCmd].Text:='Не записать файл '+ SaveDialog.FileName+'!';
        end
        else begin
         StatusBar.Panels[PanelCmd].Text:='?'; // if SaveDialog.Execute
         if iFHandle<>INVALID_HANDLE_VALUE then FileClose(iFHandle);
         exit;
        end;
       end; // if ClearBCoreBuf(buf[0])
      end // if iBytesRead=iFileSize
      else begin
       StatusBar.Panels[PanelCmd].Text:='Ошибка чтения файла: '+OpenDialog.FileName+'!';
      end;
    end // if iFHandle>0
    else begin
     StatusBar.Panels[PanelCmd].Text:='Не открыть файл '+OpenDialog.FileName+'!';
    end;
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
   end; // if OpenDialog.execute
  if iFHandle<>INVALID_HANDLE_VALUE then FileClose(iFHandle);
end;

procedure TFormMain.ButtonEEP52Click(Sender: TObject);
var
 xEsn : DWord;
 txtmode : boolean;
// i : integer;
// c : byte;
begin
  ProgressBar.Position:=5;
  AddLinesLog('Проверка ввода значений...');
  ProgressBar.Position:=10;
  if length(EditESN.Text)=8 then xESN:=StrToInt('$'+EditESN.Text)
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод ESN!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  ProgressBar.Position:=25;
  if (SpinEditHWID.Value<=HW_IDMIN) or (SpinEditHWID.Value>HW_IDMAX) then begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод HWID!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  ProgressBar.Position:=30;
  if length(EditHash.Text)=32 then HexTopByte(@EditHash.Text[1],16,@HASH)
  else begin
   FillChar(HASH,16,0);
  end;
  ProgressBar.Position:=35;
  if not TestSkey(False) then begin
    if MessageDlg('SKEY или ESN не совпадает с введёнными HASH!'+#10+#13+'Пересчитать HASH и BootKEY?',
        mtConfirmation, [mbYes, mbNo], 0) <> mrYes
    then begin
        CalkHashAndBkey(Skey,xESN);
        ProgressBar.Position:=40;
        EditHASH.Text:=BufToHexStr(@HASH,16);
        EditBootKey.Text:=BufToHexStr(@BootKey,16);
        AddLinesLog('Новый HASH: '+EditHASH.Text);
        AddLinesLog('Новый BootKEY: '+EditBootKey.Text);
    end
    else begin
     StatusBar.Panels[PanelCmd].Text:='Неверный ввод HASH!';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
    end;
  end;
//  ProgressBar.Position:=50;
  AddLinesLog('BKey: '+BufToHexStr(@BootKey,16));
  ProgressBar.Position:=55;
  EditIMEI.Text:='?';
  EditIMEI.Text:=sImei;

  ProgressBar.Position:=60;
// Create 52 block
  Create52(xESN,Skey,byte(SpinEditVerDown.Value));
  ProgressBar.Position:=75;

//  if xESN=$FA7C9349 then begin
//  end
//  else begin
   with SaveDialog do begin
     FilterIndex:=IniFile.ReadInteger('Setup','OldEepFIndex',1);
     if ((FilterIndex<=0) or (FilterIndex>2)) then FilterIndex:=1;
     FileName := IniFile.ReadString('Setup','OldEepFile','.\EEPROM\'+sImei);
     InitialDir := ExtractFilePath(FileName);
     FileName := sImei; //ChangeFileExt(ExtractFileName(FileName),'');
     if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
     if not DirectoryExists(InitialDir) then
      InitialDir := IniFile.ReadString('Setup','DirOld','.\');
     DefaultExt := 'bin';
     Filter := 'bin files (*.bin)|*.bin|txt files (*.txt)|*.txt';
     Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
     Title:='Сохранить блок 52 EEPROM в файл';
   end;//with
   if SaveDialog.Execute then begin
    if SaveDialog.FilterIndex=2 then txtmode:=True
    else txtmode:=False;
    if SaveEepBin(txtmode,SaveDialog.FileName,EEP0052,sizeof(EEP0052),52,SpinEditHWID.Value,0) then begin
         ProgressBar.Position:=90;
         IniFile.WriteString('Setup','OldEepFile',ChangeFileExt(SaveDialog.FileName,''));
         IniFile.WriteInteger('Setup','OldEepFIndex',SaveDialog.FilterIndex);
         StatusBar.Panels[PanelCmd].Text:='Блок сохранен в '+ChangeFileExt(SaveDialog.FileName,'')+'_52 файл';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    end;
   end else // if save dialog
  if MessageDlg('Записать блок 52 прямо в телефон?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes
  then begin
   if ComOpen then begin
    WriteEepBlock(52,sizeof(EEP0052),0,EEP0052);
    ComClose;
   end; // if ComOpen
  end;
//  end;
  ProgressBar.Position:=100;
end;

function TFormMain.WriteEepBlock(num,len,ver: dword; buf: array of byte):boolean;
begin
    result:=False;
    if BFC_EE_Create_Block(num,len,ver) then begin
     if BFC_EE_Write_Block(num,0,len,buf) then begin
      if BFC_EE_Finish_Block(num) then begin
       StatusBar.Panels[PanelCmd].Text:='Блок EEP'+IntToStr(num)+' записан.';
       AddLinesLog(StatusBar.Panels[PanelCmd].Text);
       result:=True;
      end
      else begin
       StatusBar.Panels[PanelCmd].Text:='Не закрыть блок EEP'+IntToStr(num)+'!';
       AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      end;
     end // if BFC_EE_Write_Block
     else begin
      StatusBar.Panels[PanelCmd].Text:='Не записать блок EEP'+IntToStr(num)+'!';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     end;
    end // if BFC_EE_Create_Block
    else begin
     StatusBar.Panels[PanelCmd].Text:='Не создать блок EEP'+IntToStr(num)+'!';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    end; // if BFC_EE_Create_Block
end;

procedure TFormMain.ButtonRdEepBkeyClick(Sender: TObject);
var
len : dword;
ver : byte;
buf : array[0..15] of byte;
bufw : array[0..15] of word;
i : integer;
begin
      ProgressBar.Position:=10;
      if ComOpen then begin
       if BFC_GetSecurityInfo(Bufw,SizeOf(bufw)) then begin
        AddLinesLog('Чтение записи Bootkey из EEPROM...');
        i:=1;
        while i<=Bufw[0] do begin
         case Bufw[i] of
          $09: ProgressBar.Position:=30;
          $0A: AddLinesLog('Запись Bootkey отсутствует в EEPROM');
         end;
         inc(i);
        end;
        if ProgressBar.Position >=30 then begin
         if BFC_EE_Get_Block_Info(52,len,ver) then begin
//          AddLinesLog('len='+IntToStr(len)+', ver='+IntToStr(ver));
          ProgressBar.Position:=60;
          if BFC_EE_Read_Block(52,0,16,buf) then begin
           ComClose;
           StatusBar.Panels[PanelCmd].Text:='BootKEY: '+BufToHexStr(@buf,16);
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           ProgressBar.Position:=100;
           exit;
          end;
         end;
        end;
        AddLinesLog('Не прочитать BootKEY из EEPROM!');
        ComClose;
       end //if BFC_GetSecurityInfo
       else begin
         ComClose;
         StatusBar.Panels[PanelCmd].Text:='Ошибка!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
       end;
      end; //if ComOpen
end;


function TFormMain.ReadBlkEEFULL(num,base,size: dword; var buf: array of byte; var len: integer): boolean;
var
buf_TBL : rT_SegEEP_TAB;
i : integer;
d : integer;
begin
       result:=False;
       if BFCReadMem(base,6,buf_TBL.b) then begin
        if (buf_TBL.wr_flg=$55464545)and(buf_TBL.blk_num=$00004C4C) then begin
         i:=1; d:=0;
         while(i<2048) do begin
          if BFCReadMem(base+dword($20000-(i shl 4)),sizeof(buf_TBL),buf_TBL.b) then begin
           if buf_TBL.wr_flg=$FFFFFFFF then begin
            AddLinesLog('Сегмент 0x'+intToHex(base,8)+', всего блоков '+IntToStr(i-1));
            AddLinesLog('Удаленных блоков '+intToStr(d)+', рабочих блоков '+IntToStr(i-1-d));
            exit;
           end
           else begin
            if (buf_TBL.wr_flg=$FFFFFFC0) then begin
             AddLinesLog('EEP'+IntToStr(buf_TBL.blk_num+5000)+', размер: '+IntToStr(buf_TBL.blk_size-1));
             if buf_TBL.blk_num=num then begin
              if size>buf_TBL.blk_size then len:=buf_TBL.blk_size
              else len:=size;
              if buf_TBL.blk_size=0 then begin
               result:=True;
               exit;
              end;
              if BFCReadMem(base+buf_TBL.addr_off,len,buf) then begin
               result:=True;
               exit;
              end
              else begin
               StatusBar.Panels[PanelCmd].Text:='Не прочитать блок памяти!';
               AddLinesLog(StatusBar.Panels[PanelCmd].Text);
              end;
              exit;
//             end else begin
//               AddLinesLog('EEP'+IntToStr(buf_TBL.blk_num+5000)+', size: '+IntToStr(buf_TBL.blk_size-1));
             end; // if buf_TBL.blk_num=num
            end             // if buf_TBL.wr_flg=$FFFFFFC0
            else begin
             AddLinesLog('DEL'+IntToStr(buf_TBL.blk_num+5000)+', размер: '+IntToStr(buf_TBL.blk_size-1));
             inc(d);
            end;
           end; // if else buf_TBL.wr_flg=$FFFFFFFF
          end
          else begin
            StatusBar.Panels[PanelCmd].Text:='Не прочитать блок памяти!';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          end; // if BFCReadMem(base+$20000-(i shl 4),...
          if (i and $0f)=0 then ProgressBar.StepBy(1);
          inc(i);
         end; // while
//         if i>=200 then AddLinesLog('Блок 5122 не найден!');
        end
        else AddLinesLog('Неизвестный блок EEFULL!');
       end
       else begin
        AddLinesLog('Не прочитать блок памяти! Закрыта шина?');
       end;
end;

procedure TFormMain.ButtonFind5122Click(Sender: TObject);
var
buf : array[0..7] of byte;
i,len : integer;
ver,b : byte;
begin
//      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      ProgressBar.Position:=10;
      if ComOpen then begin
       BFC_SecurityMode;
       if BFC_Error<>ERR_NO then AddLinesLog('Нет ответа на запрос статуса режима!')
       else begin
        if (bSecyrMode=$12) or (bSecyrMode=$13) then begin
         StatusBar.Panels[PanelCmd].Text:='Чтение ключа SKEY из EEFULL...';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         if BFC_EE_Get_Block_Info(5122,dword(len),ver) then begin
          ProgressBar.Position:=60;
          if (len>=6) and BFC_EE_Read_Block(5122,0,6,buf) then begin
           ComClose;
           StatusBar.Panels[PanelCmd].Text:='SKEY в 5122 = "'+Char(buf[4])+'" '+IntToStr(dword((@buf[0])^));
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           ProgressBar.Position:=100;
           exit;
          end;
         end;
          AddLinesLog('Не найден блок 5122!');
          bSecyrMode:=$11;
        end;
        if (bSecyrMode=$11) then begin
         StatusBar.Panels[PanelCmd].Text:='Поиск и чтение 5122 блока из флэш...';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         if ReadBlkEEFULL(122,$A0220000,sizeof(buf),buf,len)
         or ReadBlkEEFULL(122,$A0240000,sizeof(buf),buf,len)
         or ReadBlkEEFULL(122,$A1FC0000,sizeof(buf),buf,len)
         or ReadBlkEEFULL(122,$A1FE0000,sizeof(buf),buf,len)
//         or ReadBlkEEFULL(122,$A3FA0000,sizeof(buf),buf,len) // S75!?
//         or ReadBlkEEFULL(122,$A3FC0000,sizeof(buf),buf,len) // S75!?
         then begin
          AddLinesLog('Найден 5122: '+BufToHex_Str(@buf[1],6));
          StatusBar.Panels[PanelCmd].Text:='SKEY в 5122 = "'+Char(buf[5])+'" '+IntToStr(dword((@buf[1])^));
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          if (Char(buf[5])='S') or (Char(buf[5])='D') then begin
           if MessageDlg('Ввести заново c "X"?',
            mtConfirmation, [mbYes, mbNo], 0) = mrYes
           then begin
            ProgressBar.Position:=30;
            if BFC_SendSkey('X'+IntToStr(dword((@buf[1])^)),b) then begin
             AddLinesLog('SKEY введен!');
             if (b<33) then begin
              AddLinesLog('Пауза '+IntToStr(b)+' секунд(ы)...');
              for i:=0 to b do begin
               ProgressBar.StepBy(2);
               Sleep(1000);
              end;
             end //if (b<33)
             else begin
              StatusBar.Panels[PanelCmd].Text:='Неверный ключ!';
              AddLinesLog(StatusBar.Panels[PanelCmd].Text);
              ComClose;
              exit;
             end;
            end //if BFC_SendSkey
            else begin
             StatusBar.Panels[PanelCmd].Text:='Не ввести ключ!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             ComClose;
             exit;
            end; //if BFC_SendSkey
            ProgressBar.Position:=90;
            StatusBar.Panels[PanelCmd].Text:=BFC_GetSecurityMode;
            if BFC_Error=ERR_NO then AddLinesLog('SecurityStatus: '+StatusBar.Panels[PanelCmd].Text);
           end; //if MessageDlg
           ComClose;
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           ProgressBar.Position:=100;
           exit;
          end // if Char(buf[5])='S'
         end //ir readblk5122
         else AddLinesLog('Блок 5122 не найден!');
         StatusBar.Panels[PanelCmd].Text:='Ошибка!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        end //if (bSecyrMode=$11)
        else begin
         AddLinesLog('Ключ SKEY не введен (CustomerMode)!');
         StatusBar.Panels[PanelCmd].Text:='Введите Skey!';
        end; //if (bSecyrMode=$11)
       end;
       ComClose;
      end;
end;

function SendPVBoot(var BootKey: array of byte; BootType : integer) : boolean;
type
rCmdBootStart = packed record case byte of
  0: (  cmd     : BYTE;
        size    : WORD; );
  1: (  b       : array[0..$2] of BYTE; );
end;
var
//BufSrvBoot: rBufSrvBootR65;
i : integer;
bsize : integer;
p : pointer; //array of dWord;
PVBoot : array[0..8191] of  byte;
chk : dword;
CmdBootStart : rCmdBootStart;
begin
    result := False;
    case BootType of
    0 : begin bsize := SizeOf(PVBootR65); move(PVBootR65,PVBoot,bsize); end;
    1 : begin bsize := SizeOf(PVBootX75); move(PVBootX75,PVBoot,bsize); end;
    2 : begin bsize := SizeOf(PVBootX85); move(PVBootX85,PVBoot,bsize); end;
    else exit;
    end;
    move(BootKey,PVBoot[$40],16);
    i:=IniFile.ReadInteger('System','Spd1M5',$1D0);
    if (Dword((@PVBoot[BootTab[BootType].adrsp])^)=$1D0) then Dword((@PVBoot[BootTab[BootType].adrsp])^):=dword(i);
    p := @PVBoot;
    chk := 0;//Dword((@PVBoot[0])^);
    for i:=0 to ((bsize shr 2)-1) do begin
        chk:=chk xor dword(p^);
        inc(dword(p),4);
    end;
    chk := chk xor (chk shr 16);
    chk := chk xor (chk shr 8);
    PVBoot[bsize]:= Byte(chk);
    CmdBootStart.cmd:=$30;
    CmdBootStart.size:=bsize;
    if not WriteCom(@CmdBootStart.b,SizeOf(CmdBootStart)) then exit;
    if not WriteCom(@PVBoot,bsize+1) then exit;
    i:=0;
    if not ReadCom(@i,2) then exit;
    if NewSgold then begin
     if i<>$000A5C1 then exit;
    end
    else begin
     if i<>$000A5B1 then exit;
    end;
    result := True;
end;

procedure TFormMain.WatchDogOn;
begin
     WatchDog:=False;
     Timer500.Enabled:=True;
end;

procedure TFormMain.WatchDogOff;
begin
      Timer500.Enabled:=False;
      While(WatchDog)do;
end;

function TFormMain.TpInfoBoot(comoff:boolean):boolean;
var
i,y,x,z : integer;
s : string;
b : BYTE;
xESN: dword;
begin
  fBtHASH := False;
  fBtEsn  := False;
  fBtImei := False;
  fBtoImei := False;
  fBtClr  := False;
      result:=False;
      ProgressBar.Position:=5;
      StatusBar.Panels[PanelInf].Text:='';
      z:=$54415441;
      iComNum := RadioGroupComPort.ItemIndex+1;
      WatchDog:=False;
      WatchDogOff;
      if not OpenCom(CheckBoxSBA.Checked) then begin
       StatusBar.Panels[PanelCom].Text:='Com?';
       StatusBar.Panels[PanelCmd].Text:='Не открыть Com'+IntToStr(iComNum)+'!';
       AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      end; // if OpenCom
      ProgressBar.Position:=15;
      StatusBar.Panels[PanelCom].Text:='Com'+IntToStr(iComNum);
      StatusBar.Panels[PanelCmd].Text:='Автозапуск...';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      Repaint;
      for x:=0 to 7 do begin
       WriteCom(@z,2);
       ProgressBar.StepBy(1);
       while ReadCom(@b,1) do begin
        if b=$C0 then begin
//         AddLinesLog('Внимание: Для новых S/SL75 бут ещё не адаптирован!');
         NewSGold:=True;
         if RadioGroupBootType.ItemIndex<1 then RadioGroupBootType.ItemIndex:=1;
         b:=$B0;
        end else NewSGold:=False;
        if b=$B0 then begin
         StatusBar.Panels[PanelCmd].Text:='Передача бут...';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         if not SendPVBoot(BootKey,RadioGroupBootType.ItemIndex) then begin
          b:=$51;
          WriteCom(@b,1);
          ReadCom(@b,1);
          ComClose;
          StatusBar.Panels[PanelCmd].Text:='Бут не загружен!';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          AddLinesLog('Неверный BootKEY или не замкнут ТП!');
          Exit;
         end
         else begin
          WatchDogCount:=0;
          WatchDogOn;
          StatusBar.Panels[PanelCmd].Text:='BOOT загружен...';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          ProgressBar.Position:=50;
          if CheckBoxPause.Checked then begin
           StatusBar.Panels[PanelCmd].Text:='Пауза 2 сек...';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           Repaint;
           beep;
           for i:=0 to 20 do begin
             ProgressBar.StepBy(1);
             Application.ProcessMessages;
             Sleep(100);
           end; // for
           beep;
          end; // if CheckBoxPause.Checked
          WatchDogOff;
          b:=$55;
          WriteCom(@b,1);
          ReadCom(@b,1);
          WatchDogOn;
          StatusBar.Panels[PanelCmd].Text:='Получение информации...';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          Repaint;
          WatchDogOff;
          b:=Ord('I');
          WriteCom(@b,1);
          if not RdbCom(@BootInfo.b,SizeOf(BootInfo))
          then begin
           b:=$51; WriteCom(@b,1);
//           ReadCom(@b,1);
           StatusBar.Panels[PanelCmd].Text:='Нет ответа от бута!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           ComClose;
           Exit;
          end // if not ReadInfo
          else begin
           WatchDogOn;
           ProgressBar.Position:=80;
           if comoff then begin
             b:=$51; WriteCom(@b,1);
             ReadCom(@b,1);
             ComClose;
           end;  // if comoff
           if ((BootInfo.wFlashID0=$0089)
           or (BootInfo.wFlashID0=$0001)
           or (BootInfo.wFlashID0=$0004))
           then begin
            AddLinesLog('FlashID: '+ IntToHex(BootInfo.wFlashID0,4)+','+IntToHex(BootInfo.wFlashID1,4)+' ('+IntToStr(1 shl (BootInfo.bFlashSize-20))+'Mb)') ;
           end
           else begin
            if ((BootInfo.wFlashID0=$0090) and (BootInfo.wFlashID1=$0090))
            then begin
             AddLinesLog('*Правильно отпускай ТП!');
            end
            else begin
             AddLinesLog('Неизвестная Флэш (ID:'+ IntToHex(BootInfo.wFlashID0,4)+') или:');
             AddLinesLog('1) Неправильная работа с ТП.');
             AddLinesLog('2) Нет всех контактов PMB и Флэш.');
             AddLinesLog('3) Неисправна флэш-память.');
             AddLinesLog('4) Неисправна другая аппаратура телефона.');
             AddLinesLog('5) Неисправен шнур (адаптер).');
            end;
            StatusBar.Panels[PanelCmd].Text:='Купи Мартеч! :)';
            ComClose;
            Exit;
           end;
           b:=0;
           if ((Dword((@BootInfo.b[$0])^)=$ffffffff)
           and (Dword((@BootInfo.b[$10])^)=$ffffffff)
           and (Dword((@BootInfo.b[$20])^)=$ffffffff)
           and (Dword((@BootInfo.b[$30])^)=$ffffffff))
           then begin
            if (Dword((@BootInfo.b[$78])^)=$ffffffff) then begin
             AddLinesLog('Чистая новая флэш?');
            end
            else begin
             AddLinesLog('BCORE чистый!');
            end;
            fBtClr := True;
           end // 'BCORE чистый!'
           else begin
            for i:=0 to $2f do begin
             if ((BootInfo.b[i]>$7F) or ((BootInfo.b[i]<$20) and (BootInfo.b[i]<>0)))
             then begin
              b:=1;
              AddLinesLog('Данные считаны неверно!');
              break;
             end;
            end; // for
            b := b or BootInfo.b[$2F] or BootInfo.b[$1F] or BootInfo.b[$0F];
            BootInfo.b[$0F]:=0;
            BootInfo.b[$1F]:=0;
            BootInfo.b[$2F]:=0;
            StatusBar.Panels[PanelInf].Text:=BootInfo.cTelName+' '+BootInfo.cTelSiem+' '+BootInfo.cTelImei;
            AddLinesLog(StatusBar.Panels[PanelInf].Text);
            if b<>0 then begin
             AddLinesLog('Информация неверна!');
            end
            else begin
             s:=BootInfo.cTelImei;
             if CalkImei15(s,Char(b)) then begin
              if Char(b)=s[15] then begin
               EditIMEI.Text:=s;
               fBtImei := True;
              end
              else begin
               AddLinesLog('IMEI в BCORE кривой!');
              end;
             end
             else begin
              AddLinesLog('IMEI в BCORE неверен!');
             end;
            end; // if b<>0
            y:=0;
            for i:=0 to 15 do begin
             y:=BootInfo.bTelHash[i]+y;
            end; // for
            if ((y<>255*16) or (y=0)) then begin
             Move(BootInfo.bTelHash,HASH,16);
             EditHash.Text:=BufToHexStr(@HASH,16);
             AddLinesLog('HASH: '+EditHash.Text);
             fBtHASH := True;
            end
            else begin
             AddLinesLog('HASH: не записан!');
            end;
           end; // BCORE "Чистый"
           // ESN
           xESN:=BootInfo.dFlashESN1 xor BootInfo.dFlashESN[0] xor BootInfo.dFlashESN[1] xor BootInfo.dFlashESN[2] xor $03F7E532;
           if ((xESN<>0) and (xESN<>$03F7E532)) then begin
            StatusBar.Panels[PanelCmd].Text:='OTP ESN: '+ IntToHex(xESN,8);
            fBtEsn  := True;
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            if fBtEsn then begin
             EditESN.Text:=IntToHex(xESN,8);
            end;
            eepESN:=xESN;
           end // if (xESN<>0)
           else begin
            StatusBar.Panels[PanelCmd].Text:='OTP ESN: Неверен!';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           end; // if (xESN=0)
           if ( (Dword((@BootInfo.b[$78])^)<>$ffffffff)
           or ((Dword((@BootInfo.b[$78])^) xor Dword((@BootInfo.b[$7C])^))<>0) )
           then begin
            SetLength(s,14);
            for i:=2 to 16 do begin
             if (i and 1)=0 then begin
              Byte(s[i-1]):=$30+(BootInfo.b[$77+(i shr 1)] and $0f);
             end
             else begin
              Byte(s[i-1]):=$30+((BootInfo.b[$77+(i shr 1)] and $f0) shr 4);
             end;
            end; // for
            if CalkImei15(s,Char(b)) then begin
             SetLength(s,14);
             s:=s+Char(b);
             if not fBtImei then begin
              EditIMEI.Text:=s;
              if fBtEsn then begin
               EditESN.Text:=IntToHex(xESN,8);
              end;
              if fBtHASH then begin
               Move(BootInfo.bTelHash,HASH,16);
               EditHash.Text:=BufToHexStr(@HASH,16);
              end;
              fBtImei := True;
              fBtoImei := True;
             end; // if not fBtImei
            end; // if CalkImei15(s,Char(b))
           end // if ((Dword((@BootInfo.b[$78])^)<>$ffffffff)
           else begin
            s:='Не записан или неверен!';
           end;
           AddLinesLog('OTP IMEI: '+s);
           if (fBtImei and fBtoImei and (s<>sImei))
           then begin
            AddLinesLog('Внимание: нет соответствия OTP IMEI и записи IMEI в BCORE!');
            AddLinesLog('Используем OTP IMEI:'+s+'!');
            EditIMEI.Text:=s;
            if fBtHASH then begin
             Move(BootInfo.bTelHash,HASH,16);
             EditHash.Text:=BufToHexStr(@HASH,16);
            end;
            if fBtEsn then begin
             EditESN.Text:=IntToHex(xESN,8);
            end;
           end; // нет соответствия OTP IMEI
           if (fBtImei and (SpinEditHWID.Value=HW_IDNONE))
           then begin
            if fBtClr then begin
             SpinEditHWID.Value:=HW_R65_ULYSSES_BOOTCORE;
            end
            else begin
             SpinEditHWID.Value:=StrToHwID(@BootInfo.b[0]);
             if SpinEditHWID.Value=HW_IDNONE then SpinEditHWID.Value:=HW_R65_ULYSSES_BOOTCORE;
{
             case Dword((@BootInfo.b[$00])^) of
              $35365843: SpinEditHWID.Value:=HW_R65_ULYSSES; // CX65
              $0035364D: SpinEditHWID.Value:=HW_R65_ULYSSES_X_CITE; // M65
              $30375843: SpinEditHWID.Value:=HW_R65_ULYSSES_REFRESH; // CX70
              $00353653: SpinEditHWID.Value:=HW_R65_PENELOPE; // S65
              $35364C53: SpinEditHWID.Value:=HW_R65_IRIS; // SL65
              $00353643: SpinEditHWID.Value:=HW_R65_HERA; // C65
              $35364B53: SpinEditHWID.Value:=HW_R65_NEO; // SK65
              $00363653: SpinEditHWID.Value:=HW_R65_PENELOPE_NAFTA; // S66 ?
              $35375843: SpinEditHWID.Value:=HW_CX75_CEBIT; // CX75
              $0035374D: SpinEditHWID.Value:=HW_M75_CEBIT; //M75
              $00353753: SpinEditHWID.Value:=HW_S75; // S75
              $35374C53: SpinEditHWID.Value:=HW_SL75; // SL75
              else SpinEditHWID.Value:=HW_R65_ULYSSES_BOOTCORE;
             end; // case
}
            end; // if fBtClr ..
           end; // if fBtImei ...
           ProgressBar.Position:=100;
           result:=True;
           Exit;
          end; // if not RdbCom(@BootInfo.b,SizeOf(BootInfo))
         end; // if not SendBoot
        end; // if read $B0
       end; // while ReadCom
      end; // for x:=0 to 7
      AddLinesLog('Бут не загружен!');
      BFC_InitHost($01);
      if (BFC_InitHost($19)=ERR_NO) then begin
       if BFC_GetCurentMode(b) then begin
        case b of
         $03: s:='Charge Mode';
         $07: s:='BurnIn Mode';
         $12: s:='Normal Mode';
         $16: s:='Service Mode';
         $FE: s:='Формат дисков?';//'Format FFS or ?';
         else s:='Неизвестный режим ('+IntToHex(b,2)+')';//'Unknown Mode ('+IntToHex(b,2)+')';
        end; // case
        AddLinesLog('Телефон находится в "'+s+'".');
        if (b=$03) then begin
         StatusBar.Panels[PanelCmd].Text:='Купи Мартеч! :)';
         AddLinesLog('* Требуется кабель с Автозапуском.');
         AddLinesLog('Повторите операцию!');
         BFC_PhoneOff;
        end;
       end; // if BFC_GetCurentMode(b)
      end; // if BFC_InitHost($19)=ERR_NO
      ComClose;
//       Exit;
//      end; // if OpenCom
end;

function TFormMain.WrbCom(buf : pointer; size : dword): boolean;
var
blksize : dword;
p : pointer;
begin
      result:=false;
      blksize := 8192;
      p:=buf;
      while (size<>0) do begin
       if size<blksize then blksize:=size;
       if not WriteCom(p,blksize) then exit;
       inc(dword(p),blksize);
       dec(size,blksize);
      end;
      result:=True;
end;

function TFormMain.RdbCom(buf : pointer; size : dword): boolean;
var
blksize : dword;
p : pointer;
begin
      result:=false;
      blksize := 8192;
      p:=buf;
      while (size<>0) do begin
       if size<blksize then blksize:=size;
       if not SetComRxTimeouts(75,1,50+((blksize*10700) div dcb.BaudRate)) then begin
        AddLinesLog('Невозможно изменить тайм-ауты приема!');
        exit;
       end;
       if not ReadCom(p,blksize) then exit;
       inc(dword(p),blksize);
       dec(size,blksize);
      end;
      result:=True;
end;

var
cntbterr : integer;

function TFormMain.BootReadBlkX(cmd:byte;addr, size: dword; var buf: array of byte): boolean;
type
rCmdBootRd = packed record case byte of
  0: (  cmd     : BYTE;
        addr    : DWORD;
        size    : DWORD; );
  1: (  b       : array[0..8] of BYTE; );
  2: (  ww    : word; );
end;
var
CmdBootRd : rCmdBootRd;
bchk : byte;
i : integer;
err : integer;
begin
      result:=False;
      CmdBootRd.cmd:=cmd;
      CmdBootRd.addr:=(addr shl 24) or (addr shr 24) or ((addr and $FF00) shl 8) or ((addr and $FF0000) shr 8);
      CmdBootRd.size:=(size shl 24) or (size shr 24) or ((size and $FF00) shl 8) or ((size and $FF0000) shr 8);
      WatchDogOff;
      err:=0;
      while err<3 do begin
       if err<>0 then AddLinesLog('Повтор чтения блока '+IntToHex(addr,8)+', '+IntToHex(Size,8));
       if not WriteCom(@CmdBootRd.b,sizeof(CmdBootRd.b)) then begin
        AddLinesLog('Ошибка передачи команды чтения данных '+IntToHex(addr,8));
        exit;
       end;
{       if not SetComRxTimeouts(75,0,50+((size*10700) div dcb.BaudRate)) then begin
        AddLinesLog('Невозможно изменить тайм-ауты приема!');
        exit;
       end;
       if not ReadCom(@buf,size) then }

       if not RdbCom(@buf,size) then
        AddLinesLog('Ошибка приема буфера данных '+IntToHex(addr,8)+','+IntToHex(size,8))
       else begin
        if not SetComMinTime then exit;
        if not ReadCom(@CmdBootRd.ww,4) then
         AddLinesLog('Ошибка подтверждения приема данных '+IntToHex(addr,8))
        else begin
         WatchDogOn;
         if CmdBootRd.ww <> $4b4f then
          AddLinesLog('Ошибка подтверждения приема данных '+IntToHex(addr,8))
         else begin
          bchk:=buf[0];
          for i := 1 to size-1 do bchk:=bchk xor buf[i];
          if CmdBootRd.b[2]<> bchk then begin
           AddLinesLog('Ошибка CRC принятых данных '+IntToHex(addr,8));
          end
          else begin
           result:=True;
           exit;
          end;
         end; // if CmdBootRd.ww <> $4b4f
        end; // if not ReadCom(@CmdBootRd.ww,4)
       end; // if not ReadCom(@buf,size)
       inc(err);
       inc(cntbterr);
       WatchDogOff;
       bchk:=$2E; WriteCom(@bchk,1);
       PurgeCom(PURGE_RXCLEAR or PURGE_TXCLEAR);
       Sleep(100);
       if not SetComMinTime then exit;
       if err<3 then begin
        i:=0;
        while i<15 do begin
         bchk:=$41; WriteCom(@bchk,1);
         if ReadCom(@bchk,1) and (bchk=$52) then begin
          bchk:=$41; WriteCom(@bchk,1);
          if ReadCom(@bchk,1) and (bchk=$52) then begin
           if Not ReadCom(@bchk,1) then break
           else begin
            if (bchk=$52) then AddLinesLog('Похоже на кривые драйвера COM!');
           end;
          end;
         end;
         inc(i);
         if i>=15 then begin
          AddLinesLog('Сбой процесса связи с телефоном!');
          exit;
         end;
         PurgeCom(PURGE_RXCLEAR or PURGE_TXCLEAR);
         Sleep(100);
        end;
       end;
      end; // while
end;

function TFormMain.BootReadBlk(addr, size: dword; var buf: array of byte): boolean;
begin
 if size<>0 then result:=BootReadBlkX(Ord('R'),addr, size,buf)
 else result:=False;
end;

function TFormMain.BootReadOTP(addr, size: dword; var buf: array of byte): boolean;
begin
 if (size>0) or (size<$400) then result:=BootReadBlkX(Ord('O'),addr, size,buf)
 else result:=False;
end;

function TFormMain.BootReadCFI(addr, size: dword; var buf: array of byte): boolean;
begin
 if (size>0) or (size<$400) then result:=BootReadBlkX(Ord('C'),addr, size,buf)
 else result:=False;
end;

function TFormMain.BootReadBase(var addr: dword): boolean;
var
b : byte;
begin
      result:=False;
      b:=Ord('V');
      WatchDogOff;
      if not WriteCom(@b,1) then begin
       AddLinesLog('Не передать команду GetBase!');
       exit;
      end;
      if not ReadCom(@addr,4) then begin
       AddLinesLog('Нет ответа команды GetBase!');
       exit;
      end;
      WatchDogOn;
      result:=True;
end;


function TFormMain.BootTestFFBlk(addr, size: dword; var ffok: byte): boolean;
type
rCmdBootRd = packed record case byte of
  0: (  cmd     : BYTE;
        addr    : DWORD;
        size    : DWORD; );
  1: (  b       : array[0..8] of BYTE; );
  2: (  ww    : word; );
end;
var
CmdBootRd : rCmdBootRd;

begin
      result:=False;
      CmdBootRd.cmd:=$54;
      CmdBootRd.addr:=(addr shl 24) or (addr shr 24) or ((addr and $FF00) shl 8) or ((addr and $FF0000) shr 8);
      CmdBootRd.size:=(size shl 24) or (size shr 24) or ((size and $FF00) shl 8) or ((size and $FF0000) shr 8);
      WatchDogOff;
      if not WriteCom(@CmdBootRd.b,sizeof(CmdBootRd.b)) then begin
       AddLinesLog('Не передать команду теста FF '+IntToHex(addr,8));
       exit;
      end;
      if not SetComMaxTime then exit;
      if not ReadCom(@ffok,1) then begin
       AddLinesLog('Нет ответа команды теста FF '+IntToHex(addr,8));
       exit;
      end;
      SetComMinTime;
      WatchDogOn;
      result:=True;
end;

function TFormMain.BootGoto(addr: dword ): boolean;
type
rCmdBootGoTo = packed record case byte of
  0: (  cmd     : BYTE;
        addr    : DWORD;
        addrt   : DWORD; );
  1: (  b       : array[0..8] of BYTE; );
//  2: (  ww    : word; );
end;
var
CmdBootGoTo : rCmdBootGoTo;
begin
      result:=False;
      CmdBootGoTo.cmd:=$47;
      CmdBootGoTo.addr:=(addr shl 24) or (addr shr 24) or ((addr and $FF00) shl 8) or ((addr and $FF0000) shr 8);
      CmdBootGoTo.addrt:=CmdBootGoTo.addr;
      WatchDogOff;
      if not WriteCom(@CmdBootGoTo.b,sizeof(CmdBootGoTo.b)) then begin
       AddLinesLog('Не передать команду GoTo '+IntToHex(addr,8));
       exit;
      end;
      if not SetComMinTime then exit;
      if not ReadCom(@CmdBootGoTo.addr,4) then begin
       AddLinesLog('Нет ответа команды GoTo!');
       exit;
      end;
///???      WatchDogOn;
      AddLinesLog('Код GoTo: '+IntToHex(CmdBootGoTo.addr,8));
      result:=True;
end;

function TFormMain.BootRamTest(var erraddr: dword; step : integer): boolean;
var
x : byte;
i : integer;
begin
      result:=False;
      WatchDogOff;
      x:=Ord('X');
      if not WriteCom(@x,1) then begin
       AddLinesLog('Не передать команду StartTestRam!');
       exit;
      end;
      if not SetComMaxTime then exit;
      ProgressBar.StepBy(step);
      if not ReadCom(@x,1) then begin
       AddLinesLog('Нет ответа 1 команды TestRam!');
       exit;
      end;
      if (x<>$55)then begin
       AddLinesLog('Ошибка ответа 1 команды TestRam ('+IntToHex(x,2)+')!');
       exit;
      end;
//      AddLinesLog('Ответ 1 команды TestRam ('+IntToHex(x,2)+').');
      for i:=2 to 7 do begin
       ProgressBar.StepBy(step);
       if not ReadCom(@x,1) then begin
        AddLinesLog('Нет ответа '+IntToStr(i)+' команды TestRam!');
        exit;
       end;
       if (x<>$56)then begin
        if (x=$45) then begin
         if not ReadCom(@erraddr,4) then begin
          AddLinesLog('Нет ответа адреса ошибки в TestRam!');
          exit;
         end
         else begin
          AddLinesLog('Найдена ошибка по Адресу '+IntToHex(erraddr,8)+'!');
          exit;
         end;
        end
        else begin
          AddLinesLog('Ошибка ответа '+IntToStr(i)+' команды TestRam ('+IntToHex(x,2)+')!');
          exit;
        end;
       end;
//       AddLinesLog('Ответ '+IntToStr(i)+' команды TestRam ('+IntToHex(x,2)+').');
      end;
      if not ReadCom(@x,1) then begin
        if not ReadCom(@x,1) then begin
         AddLinesLog('Нет ответа отработки команды TestRam!');
         exit;
        end;
      end;
      if not SetComMinTime then exit;
      if (x<>$AA)then begin
       if (x<>$45) then begin
        AddLinesLog('Ошибка ответа команды TestRam ('+IntToHex(x,2)+')!');
        exit;
       end
       else begin
        if not ReadCom(@erraddr,4) then begin
         AddLinesLog('Нет ответа адреса ошибки в TestRam!');
         exit;
        end
        else AddLinesLog('Найдена ошибка по Адресу '+IntToHex(erraddr,8)+'!');
       end;
      end
      else begin
       erraddr:=0;
      end;
      WatchDogOn;
      result:=True;
end;

function TFormMain.BootPatchBlk(addr,size: dword; var buf: array of byte): boolean;
var
xaddr,xnewblkseg,xsize,xseglen,xend,xsegaddr,xnewsegaddr : dword;
xcfilen,i : integer;
begin
    result:=False;
    if (size=0) or (size>$40000) then begin
     AddLinesLog('Неверная параметр размера для патча!');
     exit;
    end;
    if (addr<$A0000000) or (addr>=$A8000000) then begin
     AddLinesLog('Неверная параметр адреса для патча!');
     exit;
    end;
//    xoff:=addr-BootInfo.dFlashBase;
    xcfilen:=BootInfo.bNumRegs;
    if (xcfilen<=0) or (xcfilen>7) then begin
     AddLinesLog('Неверная информация из области CFI флэша!');
     exit;
    end;
    xnewblkseg := BootInfo.dFlashBase;
    xaddr := addr;
    xend := addr+size;
    for i:=0 to xcfilen-1 do begin
     xnewblkseg := xnewblkseg+(((BootInfo.wCFIbuf[i shl 1]+1)* BootInfo.wCFIbuf[1+(i shl 1)]) shl 8);
     xseglen := BootInfo.wCFIbuf[1+(i shl 1)] shl 8;
     while (xnewblkseg > xaddr) do begin
      // получим адрес следующего сегмента xnewsegaddr
      xsegaddr := xaddr and ((xseglen-1) xor $FFFFFFFF);
      xnewsegaddr := xseglen + xsegaddr;
      // вычислим остаток байт записи
      xsize := xend - xaddr;
      if xend > xnewsegaddr then // если блок переходит в другой сегмент
       xsize := xnewsegaddr-xaddr; // возьмем только то что влезет в этот сегмент
      if not BootPatchBlk_(xsegaddr,xseglen,xaddr-xsegaddr,xsize,buf[xaddr-addr]) then exit;
      inc(xaddr,xsize);
      if xaddr=xend then begin
       result:=True;
       exit;
      end;
     end;
    end;
    AddLinesLog('Ошибка параметров патча!');
end;

function TFormMain.BootWriteMem(addr,size: dword; var buf: array of byte): boolean;
type
rCmdBootPd = packed record case byte of
  0: (  cmd     : BYTE;
        addr    : DWORD;
        size    : DWORD; );
  1: (  b       : array[0..8] of BYTE; );
  2: (  ww    : word; );
end;
var
CmdBootRd : rCmdBootPd;
i : integer;
ww : word;
//crc2 : word;
b : byte;
//pp : pointer;
begin
      result:=False;
      if (size>$40000) or (size=0) then begin
       AddLinesLog('Неверный запрос записи памяти !');
       AddLinesLog('Запись: addr:'+IntToHex(addr,8)+',size:'+IntToHex(size,8)+', buf:'+BufToHex_Str(@buf,5));
       exit;
      end;
      CmdBootRd.cmd:=Ord('W');
      CmdBootRd.addr:=(addr shl 24) or (addr shr 24) or ((addr and $FF00) shl 8) or ((addr and $FF0000) shr 8);
      CmdBootRd.size:=(size shl 24) or (size shr 24) or ((size and $FF00) shl 8) or ((size and $FF0000) shr 8);
      WatchDogOff;
      if not WriteCom(@CmdBootRd.b,sizeof(CmdBootRd.b)) then begin
       AddLinesLog('Невозможно послать команду записи памяти '+IntToHex(addr,8)+'!');
       exit;
      end;
      if not WrbCom(@buf,size) then begin
       AddLinesLog('Невозможно послать данные записи '+IntToHex(addr,8)+'!');
       exit;
      end;
      b := buf[0];
      for i:=1 to size-1 do begin
        b:=b xor buf[i];
      end;
      if not WriteCom(@b,1) then begin
       AddLinesLog('Невозможно послать CRC блока данных '+IntToHex(addr,8)+'!');
       exit;
      end;
      if not ReadCom(@ww,2) then begin
       AddLinesLog('Нет ответа на команду приема данных '+IntToHex(addr,8)+'!');
       exit;
      end;
      if ww=$BBBB then begin
        AddLinesLog('Ошибка CRC переданных данных!');
        exit;
      end
      else
      if ww=$4B4F then begin //OK_ACK
       WatchDogOn;
       result:=True;
       exit;
      end;
      AddLinesLog('Ошибка '+IntToHex(ww,8)+' записи блока памяти!');
end;

function TFormMain.BootPatchBlk_(seg,len,addr,size: dword; var buf: array of byte): boolean;
type
rCmdBootPd = packed record case byte of
  0: (  cmd     : BYTE;
        addr    : DWORD;
        size    : DWORD; );
  1: (  b       : array[0..8] of BYTE; );
  2: (  ww    : word; );
end;
var
CmdBootRd : rCmdBootPd;
i : integer;
ww : word;
b : byte;
begin
      result:=False;
      if (size=0) or (size>$40000)
      or (len=0) or ((addr+size)>len)
      then begin
       AddLinesLog('Неверная параметр размера для патча!');
       AddLinesLog('Патч: addrseg:'+IntToHex(seg,8)+',seglen:'+IntToHex(len,8)+ ',off:'+IntToHex(addr,8)+',size:'+IntToHex(size,8)+',buf:'+BufToHex_Str(@buf,5));
       exit;
      end;
      CmdBootRd.cmd:=$50;
      CmdBootRd.addr:=(seg shl 24) or (seg shr 24) or ((seg and $FF00) shl 8) or ((seg and $FF0000) shr 8);
      CmdBootRd.size:=(len shl 24) or (len shr 24) or ((len and $FF00) shl 8) or ((len and $FF0000) shr 8);
      WatchDogOff;
      if not WriteCom(@CmdBootRd.b,sizeof(CmdBootRd.b)) then begin
       AddLinesLog('Невозможно послать команду стирания сегмента '+IntToHex(addr,8)+'!');
       exit;
      end;
      if not SetComMaxTime then exit;
      if not ReadCom(@b,1) then begin
       AddLinesLog('Нет ответа на команду патча по адресу '+IntToHex(addr,8)+'!');
       exit;
      end;
      if b<>$55 then begin
       AddLinesLog('Неверный ответ от бут!');
       exit;
      end;
      CmdBootRd.addr:=(addr shl 24) or (addr shr 24) or ((addr and $FF00) shl 8) or ((addr and $FF0000) shr 8);
      CmdBootRd.size:=(size shl 24) or (size shr 24) or ((size and $FF00) shl 8) or ((size and $FF0000) shr 8);
      if not WriteCom(@CmdBootRd.addr,8) then begin
       AddLinesLog('Невозможно послать заголовок патча '+IntToHex(addr,8)+'!');
       exit;
      end;
      if not WriteCom(@buf,size) then begin
       AddLinesLog('Невозможно послать данные патча '+IntToHex(addr,8)+'!');
       exit;
      end;
      b := buf[0];
      for i:=1 to size-1 do begin
        b:=b xor buf[i];
      end;
      if not WriteCom(@b,1) then begin
       AddLinesLog('Невозможно послать CRC блока патча '+IntToHex(addr,8)+'!');
       exit;
      end;
      if not ReadCom(@ww,2) then begin
       AddLinesLog('Нет ответа на команду приема патча '+IntToHex(addr,8)+'!');
       exit;
      end;
      if ww=$BBBB then begin
        AddLinesLog('Ошибка CRC переданного блока патча!');
        exit;
      end
      else
      if ww=$CCCC then begin
        ReadCom(@ww,2);
        AddLinesLog('Неизвестный тип флэша!');
        exit;
      end
      else
      if ww=$0101 then begin //OK_ACK
       if not SetComMaxTime then exit;
       if not ReadCom(@ww,2) then begin
         AddLinesLog('Нет ответа стирания сегмента '+IntToHex(addr,8)+'!');
         exit;
       end;
       if ww<>$0202 then begin // ERASE_ACK
         AddLinesLog('Ошибка кода подтверждения команды стирания сегмента '+IntToHex(addr,8)+'!');
       end;
       if not ReadCom(@ww,2) then begin
         AddLinesLog('Нет подтверждения команды записи сегмента '+IntToHex(addr,8)+'!');
         exit;
       end;
       if ww<>$0303 then begin // Write ACK
         AddLinesLog('Ошибка кода команды записи сегмента '+IntToHex(addr,8)+'!');
         exit
       end;
       if ReadCom(@ww,2) then begin
        if not SetComMinTime then exit;
        if ReadCom(@ww,2) then begin
          if ww=$4B4F then begin
           WatchDogOn;
           result:=True;
           exit;
          end;
        end;
       end;
       AddLinesLog('Ошибка передачи CRC сегмента '+IntToHex(addr,8)+'!');
      end;
end;

function TFormMain.BootWriteFlash(addr,size: dword; var buf: array of byte): boolean;
var
xaddr,xnewblkseg,xsize,xseglen,xend,xnewsegaddr : dword;
xcfilen,i : integer;
begin
    result:=False;
    if (size=0) or (size>$40000) then begin
     AddLinesLog('Неверный параметр размера записи!');
     exit;
    end;
    if (addr<$A0000000) or (addr>=$A8000000) then begin
     result:=BootWriteFlash_(addr,size,buf);
     exit;
    end;
//    xoff:=addr-BootInfo.dFlashBase;
    xcfilen:=BootInfo.bNumRegs;
    if (xcfilen<=0) or (xcfilen>7) then begin
     AddLinesLog('Неверная информация Флэш CFI!');
     exit;
    end;
    xnewblkseg := BootInfo.dFlashBase;
    xaddr := addr;
    xend := addr+size;
    for i:=0 to xcfilen-1 do begin
     xnewblkseg := xnewblkseg+(((BootInfo.wCFIbuf[i shl 1]+1)* BootInfo.wCFIbuf[1+(i shl 1)]) shl 8);
     xseglen := BootInfo.wCFIbuf[1+(i shl 1)] shl 8;
     while (xnewblkseg > xaddr) do begin
      // получим адрес следующего сегмента xnewsegaddr
      xnewsegaddr := xseglen + (xaddr and ((xseglen-1) xor $FFFFFFFF));
      // вычислим остаток байт записи
      xsize := xend - xaddr;
      if xend > xnewsegaddr then // если блок переходит в другой сегмент
       xsize := xnewsegaddr-xaddr; // возьмем только то что влезет в этот сегмент
      if not BootWriteFlash_(xaddr,xsize,buf[xaddr-addr]) then exit;
      inc(xaddr,xsize);
      if xaddr=xend then begin
       result:=True;
       exit;
      end;
     end;
    end;
    AddLinesLog('Ошибка параметров записи!');
end;

function TFormMain.BootWriteFlash_(addr,size: dword; var buf: array of byte): boolean;
type
rCmdBootPd = packed record case byte of
  0: (  cmd     : BYTE;
        addr    : DWORD;
        size    : DWORD; );
  1: (  b       : array[0..8] of BYTE; );
  2: (  ww    : word; );
end;
var
CmdBootRd : rCmdBootPd;
i : integer;
ww : word;
crc2 : word;
b : byte;
pp : pointer;
begin
      result:=False;
      if (size>$40000) or (size=0) then begin
       AddLinesLog('Неверный запрос записи сегмента !');
       AddLinesLog('Запись: addr:'+IntToHex(addr,8)+',size:'+IntToHex(size,8)+', buf:'+BufToHex_Str(@buf,5));
       exit;
      end;
      CmdBootRd.cmd:=$46;
      CmdBootRd.addr:=(addr shl 24) or (addr shr 24) or ((addr and $FF00) shl 8) or ((addr and $FF0000) shr 8);
      CmdBootRd.size:=(size shl 24) or (size shr 24) or ((size and $FF00) shl 8) or ((size and $FF0000) shr 8);
      WatchDogOff;
      if not WriteCom(@CmdBootRd.b,sizeof(CmdBootRd.b)) then begin
       AddLinesLog('Невозможно послать команду стирания сегмента '+IntToHex(addr,8)+'!');
       exit;
      end;
      if not WrbCom(@buf,size) then begin
       AddLinesLog('Невозможно послать данные записи '+IntToHex(addr,8)+'!');
       exit;
      end;
      b := buf[0];
      for i:=1 to size-1 do begin
        b:=b xor buf[i];
      end;
      if not WriteCom(@b,1) then begin
       AddLinesLog('Невозможно послать CRC блока данных для записи '+IntToHex(addr,8)+'!');
       exit;
      end;
      if not ReadCom(@ww,2) then begin
       AddLinesLog('Нет ответа на команду приема данных '+IntToHex(addr,8)+'!');
       exit;
      end;
      if ww=$BBBB then begin
        AddLinesLog('Ошибка CRC переданных данных!');
        exit;
      end
      else
      if ww=$CCCC then begin
        ReadCom(@ww,2);
        AddLinesLog('Неизвестный тип флэша!');
        exit;
      end
      else
      if ww=$FFFF then begin
        AddLinesLog('Приняты неверные параметры записи сегмента!');
        exit;
      end
      else
      if ww=$0101 then begin //OK_ACK
       if not SetComMaxTime then exit;
       crc2:=0;
       pp:=@buf[0];
       for i:=0 to (size shr 1)-1 do begin
        crc2:=crc2+word(pp^);
        inc(Dword(pp),2);
       end;
       if not ReadCom(@ww,2) then begin
         AddLinesLog('Нет ответа стирания сегмента '+IntToHex(addr,8)+'!');
         exit;
       end;
       if ww<>$0202 then begin // ERASE_ACK
         AddLinesLog('Ошибка кода подтверждения команды стирания сегмента '+IntToHex(addr,8)+'!');
       end;
       if not SetComMaxTime then exit;
       if not ReadCom(@ww,2) then begin
         AddLinesLog('Нет подтверждения команды записи сегмента '+IntToHex(addr,8)+'!');
         exit;
       end;
       if ww<>$0303 then begin // Write ACK
         AddLinesLog('Ошибка err:'+IntToHex(ww,4)+' команды записи сегмента '+IntToHex(addr,8)+'!');
         exit
       end;
       if ReadCom(@ww,2) then begin
        if not SetComMinTime then exit;
        if ww<>crc2 then begin
         AddLinesLog('Внимание: Ошибка CRC записи сегмента '+IntToHex(addr,8)+'! '+IntToHex(crc2,4)+'<>'+IntToHex(ww,4));
        end;
        if ReadCom(@ww,2) then begin
          if ww=$4B4F then begin
           WatchDogOn;
           result:=True;
           exit;
          end;
        end;
       end;
       AddLinesLog('Ошибка передачи CRC записи сегмента '+IntToHex(addr,8)+'!');
      end;
end;

function TFormMain.BootEraseBlk(addr,size: dword): boolean;
var
xaddr,xnewblkseg,xsize,xseglen,xend,xnewsegaddr,xsegaddr : dword;
xcfilen,i : integer;
begin
    result:=False;
    if (size=0) or (size>$40000)
    or (addr<$A0000000) or (addr>=$A8000000)
    then begin
     AddLinesLog('Неверная параметры функции стирания!');
     exit;
    end;
//    xoff:=addr-BootInfo.dFlashBase;
    xcfilen:=BootInfo.bNumRegs;
    if (xcfilen<=0) or (xcfilen>7) then begin
     AddLinesLog('Неверная информация Флэш CFI!');
     exit;
    end;
    xnewblkseg := BootInfo.dFlashBase;
    xaddr := addr;
    xend := addr+size;
    for i:=0 to xcfilen-1 do begin
     xnewblkseg := xnewblkseg+(((BootInfo.wCFIbuf[i shl 1]+1)* BootInfo.wCFIbuf[1+(i shl 1)]) shl 8);
     xseglen := BootInfo.wCFIbuf[1+(i shl 1)] shl 8;
     while (xnewblkseg > xaddr) do begin
      // получим адрес следующего сегмента xnewsegaddr
      xsegaddr := xaddr and ((xseglen-1) xor $FFFFFFFF);
      xnewsegaddr := xseglen + xsegaddr;
      // вычислим остаток байт записи
      xsize := xend - xaddr;
      if xend > xnewsegaddr then // если блок переходит в другой сегмент
       xsize := xnewsegaddr-xaddr; // возьмем только то что влезет в этот сегмент
      if not BootEraseBlk_(xsegaddr) then exit;
      inc(xaddr,xsize);
      if xaddr=xend then begin
       result:=True;
       exit;
      end;
     end;
    end;
   AddLinesLog('Ошибка параметров стирания!');
end;


function TFormMain.BootEraseBlk_(addr: dword): boolean;
type
rCmdBootErase = packed record case byte of
  0: (  cmd     : BYTE;
        addr    : DWORD; );
  1: (  b       : array[0..4] of BYTE; );
  2: (  ww    : word; );
end;
var
CmdBootRd : rCmdBootErase;
ww : word;
begin
      result:=False;
      CmdBootRd.cmd:=$45;
      CmdBootRd.addr:=(addr shl 24) or (addr shr 24) or ((addr and $FF00) shl 8) or ((addr and $FF0000) shr 8);
      WatchDogOff;
      if not WriteCom(@CmdBootRd.b,sizeof(CmdBootRd.b)) then begin
       AddLinesLog('Невозможно послать команду стирания сегмента '+IntToHex(addr,8)+'!');
       exit;
      end;
      if not ReadCom(@ww,2) then begin
       AddLinesLog('Нет ответа на команду стирания сегмента '+IntToHex(addr,8)+'!');
       exit;
      end;
      if ww=$CCCC then begin
        ReadCom(@ww,2);
        AddLinesLog('Неизвестный тип флэша!');
        exit;
      end
      else begin
       if ww=$0101 then begin //OK_ACK
//        AddLinesLog('Стирание ack: '+IntToHex(ww,4)+', '+IntToHex(addr,8));
        if not SetComMaxTime then exit;
        if not ReadCom(@ww,2) then begin
         AddLinesLog('Стирание CRC: '+IntToHex(ww,4));
         AddLinesLog('Нет ответа в конце команды стирания сегмента '+IntToHex(addr,8)+'!');
         exit;
        end;
        if (ww=$0202) or (ww=$4545) then begin // ERASE_ACK
         if not SetComMinTime then exit;
         WatchDogOn;
         result:=True; { BootTestFFBlk(addr,$20000,CmdBootRd.cmd);
         if result and (CmdBootRd.cmd=$FF) then exit
         else AddLinesLog('Ошибка проверки пустоты в сегменте '+IntToHex(addr,8)+'!'); }
         exit;
        end;
        AddLinesLog('Стирание Err_ACK: '+IntToHex(ww,4)+', '+IntToHex(addr,8));
        exit;
       end; //OK_ACK
       AddLinesLog('Стирание End_ACK: '+IntToHex(ww,4)+', '+IntToHex(addr,8));
      end;
end;

var
err_io_tst_eep : boolean;


function TFormMain.EEBlkSearch(num,base,size: dword; var buf: array of byte; var len: integer;var addr: dword): boolean;
var
buf_TBL : rT_SegEEP_TAB;
i : integer;
begin
       result:=False;
       err_io_tst_eep := False;
       if BootReadBlk(base,8,buf_TBL.b) then begin
        if (buf_TBL.wr_flg=$55464545)and(buf_TBL.blk_num=$00004C4C) then begin
         i:=1; // d:=0;
         while(i<2048) do begin
          if BootReadBlk(base+dword($20000-(i shl 4)),sizeof(buf_TBL),buf_TBL.b) then begin
           if buf_TBL.wr_flg=$FFFFFFFF then begin
//            AddLinesLog('Сегмент 0x'+intToHex(base,8)+', всего блоков '+IntToStr(i-1));
//            AddLinesLog('Удаленных блоков '+intToStr(d)+', рабочих блоков '+IntToStr(i-1-d));
            exit;
           end
           else begin
            if (buf_TBL.wr_flg=$FFFFFFC0) then begin
//             AddLinesLog('EEP'+IntToStr(buf_TBL.blk_num+5000)+', size: '+IntToStr(buf_TBL.blk_size-1));
             if buf_TBL.blk_num=num then begin
              if size>buf_TBL.blk_size then len:=buf_TBL.blk_size
              else len:=size;
              if buf_TBL.blk_size=0 then begin
               result:=True;
               exit;
              end;
              if BootReadBlk(base+buf_TBL.addr_off,len,buf) then begin
               addr:=base+buf_TBL.addr_off;
               result:=True;
               exit;
              end
              else begin
               StatusBar.Panels[PanelCmd].Text:='Не прочитать блок памяти!';
               AddLinesLog(StatusBar.Panels[PanelCmd].Text);
               err_io_tst_eep := True;
              end;
              exit;
//               AddLinesLog('EEP'+IntToStr(buf_TBL.blk_num+5000)+', size: '+IntToStr(buf_TBL.blk_size-1));
             end; // if buf_TBL.blk_num=num
            end             // if buf_TBL.wr_flg=$FFFFFFC0
            else begin
//             AddLinesLog('DEL'+IntToStr(buf_TBL.blk_num+5000)+', size: '+IntToStr(buf_TBL.blk_size-1));
//             inc(d);
            end;
           end; // if else buf_TBL.wr_flg=$FFFFFFFF
          end
          else begin
           AddLinesLog('Не прочитать блок памяти '+IntToHex(base+dword($20000-(i shl 4)),8)+'!');
           err_io_tst_eep := True;
           exit;
          end; // if BFCReadMem(base+$20000-(i shl 4),...
          if (i and $0f)=0 then ProgressBar.StepBy(1);
          inc(i);
         end; // while
         AddLinesLog('Переполнение сегмента EEFULL!');
        end;
//        else AddLinesLog('Неизвестный блок EEFULL!');
       end
       else begin
        AddLinesLog('Не прочитать блок памяти '+IntToHex(base,8)+'!');
        err_io_tst_eep := True;
       end;
end;

function TFormMain.EEFULLtab(base: dword): boolean;
var
buf_TBL : rT_SegEEP_TAB;
i : integer;
numbase : dword;
begin
       result:=False;
       err_io_tst_eep :=False;
       numbase:=0;
       if idx_eeptab>MAX_INDEX_EEPTAB then begin
         AddLinesLog('Ошибка: переполнение таблицы сохранения EEFULL блоков!');
         exit;
        end;
       if BootReadBlk(base,8,buf_TBL.b) then begin
        if ((buf_TBL.wr_flg=$55464545)and(buf_TBL.blk_num=$00004C4C))
        or ((buf_TBL.wr_flg=$494C4545)and(buf_TBL.blk_num=$00004554))
        then begin
         if (buf_TBL.wr_flg=$55464545) then begin
          if next_seg_eeful>1 then begin
           AddLinesLog('Ошибка (55464545): неверный вызов!');
           exit;
          end;
          inc(next_seg_eeful);
          numbase:=5000;
         end else next_seg_eeful:=0;
         i:=1; // d:=0;
         while(i<2048) do begin
          if BootReadBlk(base+dword($20000-(i shl 4)),sizeof(buf_TBL),buf_TBL.b) then begin
           if buf_TBL.wr_flg=$FFFFFFFF then begin
//            AddLinesLog('Сегмент 0x'+intToHex(base,8)+', всего блоков '+IntToStr(i-1));
//            AddLinesLog('Удаленных блоков '+intToStr(d)+', рабочих блоков '+IntToStr(i-1-d));
            if (next_seg_eeful=1) and (numbase=5000) then begin
             result:=EEFULLtab(base+$20000);
            end else
            if ((next_seg_eeful=0) and (numbase=0))
            or (next_seg_eeful=2) then result:=True;
            exit;
           end
           else begin
            if (buf_TBL.wr_flg=$FFFFFFC0) then begin
             EepTab[idx_eeptab].num:=buf_TBL.blk_num+numbase;
             EepTab[idx_eeptab].len:=buf_TBL.blk_size;
             EepTab[idx_eeptab].len:=buf_TBL.blk_size;
             EepTab[idx_eeptab].addr:=base+buf_TBL.addr_off;
             inc(idx_eeptab);
             if idx_eeptab>=MAX_INDEX_EEPTAB then begin
              if numbase<>0 then AddLinesLog('Переполнение таблицы сохранения EEFULL блоков!')
              else AddLinesLog('Переполнение таблицы сохранения EELITE блоков!');
              exit;
             end;
            end             // if buf_TBL.wr_flg=$FFFFFFC0
            else begin
//             AddLinesLog('DEL'+IntToStr(buf_TBL.blk_num+5000)+', size: '+IntToStr(buf_TBL.blk_size-1));
//             inc(d);
            end;
           end; // if else buf_TBL.wr_flg=$FFFFFFFF
          end
          else begin
//            StatusBar.Panels[PanelCmd].Text:='Не прочитать блок памяти!';
//            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            AddLinesLog('Не прочитать блок памяти '+IntToHex(base+dword($20000-(i shl 4)),8)+'!');
            err_io_tst_eep:=True;
            exit;
          end; // if BFCReadMem(base+$20000-(i shl 4),...
          if (i and $0f)=0 then ProgressBar.StepBy(1);
          inc(i);
         end; // while
         if numbase<>0 then AddLinesLog('Переполнение сегмента EEFULL!')
         else AddLinesLog('Переполнение сегмента EELITE!')
        end;
//        else AddLinesLog('Неизвестный блок EEFULL!');
       end
       else begin
        AddLinesLog('Не прочитать блок памяти '+IntToHex(base,8)+'!');
        err_io_tst_eep:=True;
       end;
end;

function TFormMain.SetComMinTime:boolean;
begin
       if not SetComRxTimeouts(50,1,100) then begin
         AddLinesLog('Ошибка: SetComTimeouts(50,1,100)!');
         result:=False;
         exit;
       end;
       result:=True;
end;
function TFormMain.SetComMaxTime:boolean;
begin
       if not SetComRxTimeouts(1700,1,1800) then begin
         AddLinesLog('Ошибка: SetComTimeouts(1700,1,1800)!');
         result:=False;
         exit;
       end;
       result:=True;
end;

procedure TFormMain.BootEnd;
var
b: byte;
begin
      Timer500.Enabled := False;
      b:=$51; WriteCom(@b,1);
      ReadCom(@b,1);
//      AddLinesLog('WatchDogs: '+IntToStr(WatchDogCount));
      if cntbterr<>0 then AddLinesLog('Всего ошибок I/O '+IntToStr(cntbterr)+' штук.');
      ComClose;
      ButtonBootInfo.Enabled:=True;
      PageControl.Enabled:=True;
end;

function TFormMain.CreateSegBackup(addr:dword; sfn : string ; var buf : array of byte):boolean;
var
sblkFile : string;
hblkFile : THandle;
size_segd2 : dword;
//b : byte;
begin
       result:=False;
       if RadioGroupBootType.ItemIndex=2 then size_segd2 := $20000
       else size_segd2 := $10000;
       if BootReadBlk(addr,size_segd2,buf) and BootReadBlk(addr+size_segd2,size_segd2,buf[size_segd2]) then begin
        sBlkFile := IniFile.ReadString('System','DirBackup','.\Backup');
        if not DirectoryExists(sblkFile) then begin
         sBlkFile := '.\Backup';
         if not CreateDir(sBlkFile) then sBlkFile := '.';
         IniFile.WriteString('System','DirBackup',sblkFile)
        end;
        if sblkFile[length(sblkFile)]<>'\' then sblkFile:=sblkFile+'\';
        sblkFile := sblkFile + sfn;
        hblkFile := FileCreate(sblkFile);
//        b:=$2E; WriteCom(@b,1);
        if hblkFile <> INVALID_HANDLE_VALUE then begin
         if FileWrite(hblkFile,buf,size_segd2 shl 1) = integer(size_segd2 shl 1) then begin
//          b:=$2E; WriteCom(@b,1);
          FileClose(hblkFile);
//          hblkFile := INVALID_HANDLE_VALUE;
//          AddLinesLog('EXIT сохранен в '+ ExtractFileName(sblkFile));
          result:=True;
          exit;
         end
         else AddLinesLog('Не записать бэкап в файл '+ sblkFile+'!');
        end
        else AddLinesLog('Не открыть файл бэкапа '+ sblkFile+' !');
       end  // if BootReadBlk(addr
      else AddLinesLog('Ошибка чтения сегмета '+IntToHex(addr,8)+'!');
end;

procedure TFormMain.ButtonBootInfoClick(Sender: TObject);
var
b,otk : BYTE;
i,y,z,x : integer;
errflg : boolean;
buf : array[0..$3ffff] of byte;
seg_size, addr, bbase : dword;
s : string;
sblkFile : string;
hblkFile : THandle;
begin
      if CheckBoxRdFF.Checked and (RadioGroupSpeed.ItemIndex=0) then begin
        StatusBar.Panels[PanelCmd].Text:='На такой скорости читать фулл не буду!';
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        exit;
      end;
{      if CheckBoxTest.Checked then begin
       with OpenDialog do begin
        FilterIndex:=1;
        InitialDir := '.';
        DefaultExt := 'bin';
        Filter := 'Bin files (*.bin)|*.bin|All files (*.*)|*.*';
        Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
        Title:='Выбор файла ФуллФлэш для записи в телефон';
       end;//with OpenDialog
       if OpenDialog.execute then begin
//         iFHandle:=FileOpen(OpenDialog.FileName,fmOpenRead or fmShareCompat);
       end
       else exit;
      end; // if CheckBoxTest.Checked }
      if RadioGroupBootType.ItemIndex <> 2 then seg_size:=$20000
      else seg_size:=$40000;
      WatchDogCount:=0;
      cntbterr:=0;
      eepSkey:=12345678;
      if CheckBoxReCalkFull.Checked then begin
       AddLinesLog('Проверка значения SKEY со страницы "Коды"...');
       if ((length(EditSkey.Text)<>0) and (EditSkey.Text<>'?')) then eepSkey:=StrToInt(EditSkey.Text)
       else begin
        StatusBar.Panels[PanelCmd].Text:='Неверный ввод SKEY!';
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        exit;
       end;
       if (eepSkey=0) or (eepSkey>99999999) then begin
        StatusBar.Panels[PanelCmd].Text:='Неверное значение SKEY!';
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        AddLinesLog('Skey может быть от 1 до 99999999 включительно!');
        exit;
       end;
       AddLinesLog('Используем SKEY: '+IntToStr(eepSkey));
      end;
      s:=IntToStr(SpinEditVerDown.Value);
      i:=length(s);
      if i=1 then otk:=Byte(s[1]) and $0f
      else if i=2 then otk:=(Byte(s[2]) and $0f) or ((Byte(s[1]) and $0f) shl 4)
      else otk:=$FF;
      ButtonBootInfo.Enabled:=False;
      PageControl.Enabled:=False;
      errflg:=False;
      if length(EditBootKey.Text)=32 then HexTopByte(@EditBootKey.Text[1],16,@BootKey);
      StatusBar.Panels[PanelCmd].Text:='Загрузка бута...';
      if CheckBoxNew5121.Checked
      or CheckBoxTestBus.Checked
      or CheckBoxFreia.Checked
      or CheckBoxSetVDown.Checked
      or CheckBoxClrExit.Checked
      or CheckBoxClrEEFULL.Checked
      or CheckBoxClrEELITE.Checked
      or CheckBoxClrBcor.Checked
      or CheckBoxRdFF.Checked
      or CheckBoxReCalkFull.Checked
      or CheckBoxNewBcore.Checked
      or CheckBoxRdOTP.Checked
      or CheckBoxRdCFI.Checked
      or CheckBoxTest.Checked
      or CheckSaveInfo.Checked
      or CheckBoxSaveEEP.Checked
      then begin
       ProgressBar.Position:=10;
//       Priority:=tpTimeCritical;
       if TpInfoBoot(False) then begin
        if fBtImei or fBtoImei then begin
         IniFile.WriteString('Setup','IMEI',sIMEI);
         if (SpinEditHWID.Value<>HW_R65_ULYSSES_BOOTCORE)
         and (SpinEditHWID.Value<>HW_IDNONE) then
          IniFile.WriteInteger(sIMEI,'HWID',SpinEditHWID.Value);
         if fBtHASH then
          IniFile.WriteString(sIMEI,'HASH',BufToHexStr(@HASH,16));
         if fBtEsn then
          IniFile.WriteString(sIMEI,'ESN',IntToHex(eepESN,8));
        end;
        if not fBtEsn then eepESN:=$12345678;
//        b:=$2E; WriteCom(@b,1);
        i:=RadioGroupSpeed.ItemIndex;
{        // коррекция скорости 1500000
        x:=IniFile.ReadInteger('System','Spd1M5',$1D0);
        if (i=8) and (x<>$1D0) then begin
           if not BootReadBase(bbase) then begin
             StatusBar.Panels[PanelCmd].Text:='Ошибка чтения базового адреса!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             BootEnd; exit;
           end;
           Application.ProcessMessages;
           Dword((@buf[0])^):=x;
           if not BootWriteMem(bbase+$61C,4,buf[0]) then begin
             StatusBar.Panels[PanelCmd].Text:='Ошибка задания параметра скорости 1M5!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             BootEnd; exit;
           end;
        end; }
        // установка скорости
        if i<>1 then begin
         StatusBar.Panels[PanelCmd].Text:='Установка скорости '+IntToStr(TabBootComSpd[i])+' Бод...';
         Repaint;
         Application.ProcessMessages;
         WatchDogOff;
         b:=$48; WriteCom(@b,1);
         WriteCom(@i,1);
         ReadCom(@b,1);
         if (b=$68) and ChangeComSpeed(TabBootComSpd[i]) then begin
           b:=$55; WriteCom(@b,1);
           b:=$41; WriteCom(@b,1);
           ReadCom(@b,1);
         end else b:=0;
         if b<>$48 then begin
          StatusBar.Panels[PanelCmd].Text:='Ошибка установки скорости '+IntToStr(TabBootComSpd[i])+' Бод!';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          BootEnd;
          exit;
         end;
//         else begin
         WatchDogOn;
         AddLinesLog('Установлена скорость '+IntToStr(TabBootComSpd[i])+' Бод.');
//         end;
        end;
//--------------TestBus
        if CheckBoxTestBus.Checked then begin
         StatusBar.Panels[PanelCmd].Text:='Тест шины данных D0..D15...';
         ProgressBar.Position:=10;
         Application.ProcessMessages;
         dword(i):=$FFFE0001;
         x:=0;
         addr:=$A8000000;
         while (x<16) do begin
          dword((Pointer(@buf[0]))^):=i;
          if BootWriteMem(addr,4,buf) then begin
           ProgressBar.StepBy(2);
           if BootReadBlk(addr,4,buf) then begin
            if (dword((Pointer(@buf[0]))^)<>dword(i)) then begin
             StatusBar.Panels[PanelCmd].Text:='Ошибка данных D'+IntToStr(x)+': '+IntToHex(dword((Pointer(@buf[0]))^),8)+'!='+IntToHex(i,8);
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             BootEnd; exit;
            end;
           end
           else begin
            BootEnd; exit;
           end;
          end
          else begin
           BootEnd; exit;
          end;
          i:=i shl 1;
          inc(x);
         end; // if while
         AddLinesLog(StatusBar.Panels[PanelCmd].Text+'OK.');
         StatusBar.Panels[PanelCmd].Text:='Тест шины адресов A2..A22...';
         Application.ProcessMessages;
         addr:=$A8000000;
         dword((Pointer(@buf[0]))^):=addr;
         if BootWriteMem(addr,4,buf) then begin
          i:=$4;
          x:=2;
          while (x<23) do begin
           dword((Pointer(@buf[0]))^):=addr+dword(i);
           if BootWriteMem(addr+dword(i),4,buf) then begin
            ProgressBar.StepBy(2);
            if BootReadBlk(addr,4,buf) and BootReadBlk(addr+dword(i),4,buf[4]) then begin
             if (dword((Pointer(@buf[0]))^)<>addr)
             or (dword((Pointer(@buf[4]))^)<>addr+dword(i))
             then begin
              StatusBar.Panels[PanelCmd].Text:='Ошибка в адресе A'+IntToStr(x)+': '+IntToHex(i,8);
              AddLinesLog(StatusBar.Panels[PanelCmd].Text);
              BootEnd; exit;
             end;
            end;
           end
           else begin
            BootEnd; exit;
           end;
           i:=i shl 1;
           inc(x);
          end; // if while
          AddLinesLog(StatusBar.Panels[PanelCmd].Text+'OK.');
          ProgressBar.Position:=100;
          Application.ProcessMessages;
         end
         else begin
//           StatusBar.Panels[PanelCmd].Text:='Ошибка очистки сегмента BCORE!';
//           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          BootEnd; exit;
         end;
//-----------------Test RAM---------------------------
         if CheckBoxTstRam.Checked then begin
          AddLinesLog('Тест микросхемы памяти 8Meg...');
          ProgressBar.Position:=2;
           Dword(pointer(@buf[0])^):=$CE739CE7; // 11001110011100111001110011100111b
           Dword(pointer(@buf[4])^):=$739CE739; // 01110011100111001110011100111001b
           Dword(pointer(@buf[8])^):=$9CE739CE; // 10011100111001110011100111001110b
           Dword(pointer(@buf[12])^):=$E739CE73; // 11100111001110011100111001110011b
           Dword(pointer(@buf[16])^):=$39CE739C; // 00111001110011100111001110011100b
           if not BootReadBase(bbase) then begin
             StatusBar.Panels[PanelCmd].Text:='Ошибка задания параметров теста RAM!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             BootEnd; exit;
           end;
//           AddLinesLog('Boot load at 0x'+IntToHex(bbase,8));
           for i:=1 to 7 do begin
            StatusBar.Panels[PanelCmd].Text:='Тестовая последовательность N'+IntToStr(i)+'...';
            Application.ProcessMessages;
            if not BootWriteMem(bbase+$1800,20,buf) then begin
             StatusBar.Panels[PanelCmd].Text:='Ошибка задания параметров теста RAM!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             BootEnd; exit;
            end;
//            ProgressBar.StepBy(7);
            if not BootRamTest(addr,2) then begin
             StatusBar.Panels[PanelCmd].Text:='Ошибка выполнения теста RAM!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             BootEnd; exit;
            end;
            if addr<>0 then begin
             addr:=addr-4;
             StatusBar.Panels[PanelCmd].Text:='Ошибка в dword по адресу '+IntToHex(addr,8)+'h!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             if NOT BootReadBlk(addr,4,buf[20]) then begin
              AddLinesLog('Ошибка при чтении данных!');
              BootEnd; exit;
             end;
             x:=(addr and $07FFFFFF) mod 20;
             if Dword(pointer(@buf[x])^)<>Dword(pointer(@buf[20])^) then
              AddLinesLog('Записано '+IntToHex(Dword(pointer(@buf[x])^),8)+'h, считано '+IntToHex(Dword(pointer(@buf[20])^),8)+'h!')
             else AddLinesLog('Сбои при чтении/записи значения dword = '+IntToHex(Dword(pointer(@buf[x])^),8)+'h!');
             BootEnd; exit;
            end;
            if i<5 then begin
             Dword(pointer(@buf[0])^):=(Dword(pointer(@buf[0])^) shl 1) or (Dword(pointer(@buf[16])^) shr 31);
             Dword(pointer(@buf[4])^):=(Dword(pointer(@buf[4])^) shl 1) or (Dword(pointer(@buf[0])^) shr 31);
             Dword(pointer(@buf[8])^):=(Dword(pointer(@buf[8])^) shl 1) or (Dword(pointer(@buf[4])^) shr 31);
             Dword(pointer(@buf[12])^):=(Dword(pointer(@buf[12])^) shl 1) or (Dword(pointer(@buf[8])^) shr 31);
             Dword(pointer(@buf[16])^):=(Dword(pointer(@buf[16])^) shl 1) or (Dword(pointer(@buf[12])^) shr 31);
            end
            else if i=5 then begin
             Dword(pointer(@buf[0])^):=$55AA55AA;
             Dword(pointer(@buf[4])^):=$55AA55AA;
             Dword(pointer(@buf[8])^):=$55AA55AA;
             Dword(pointer(@buf[12])^):=$55AA55AA;
             Dword(pointer(@buf[16])^):=$55AA55AA;
            end
            else begin
             Dword(pointer(@buf[0])^):=$AA55AA55;
             Dword(pointer(@buf[4])^):=$AA55AA55;
             Dword(pointer(@buf[8])^):=$AA55AA55;
             Dword(pointer(@buf[12])^):=$AA55AA55;
             Dword(pointer(@buf[16])^):=$AA55AA55;
            end;
//            ProgressBar.StepBy(7);
            AddLinesLog('Тестовая последовательность N'+IntToStr(i)+' пройдена.');
           end;
           ProgressBar.Position:=100;
           AddLinesLog('Тест памяти успешен.');
         end;
        end; // if CheckBoxTestBus.Checked
//--------------SaveEEP
        if CheckBoxSaveEEP.Checked then begin
         StatusBar.Panels[PanelCmd].Text:='Сохранение блоков EELITE...';
         Application.ProcessMessages;
         i:=0; y:=0;
         if NewSGold then i:=2;
         AddLinesLog('Поиск сегмента EELITE...');
         ProgressBar.Position:=10;
         Repaint;
         ClearEEPBufAndTab;
         while TabAddrEELITE[i]<>0 do begin
          if Not NewSGold then if i=2 then break;
          addr:=TabAddrEELITE[i];
          if BootReadBlk(addr,$10,buf) then begin
           if (Dword(Pointer(@Buf[0])^)=$494C4545) and (Dword(Pointer(@Buf[4])^)=$00004554) then begin
            if BootReadBlk(addr+$10,$10000-$10,buf[$10]) and BootReadBlk(addr+$10000,$10000,buf[$10000]) then begin
             ProgressBar.StepBy(20);
            end
            else begin
             StatusBar.Panels[PanelCmd].Text:='Ошибка при чтении сегмента EELITE!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             BootEnd; exit;
            end;
            if Not AddSegBlkEEP(addr,buf,False) then begin
             StatusBar.Panels[PanelCmd].Text:=sEep_Err;
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
//             BootEnd; exit;
            end;
            y:=1;
            break;
           end; // if (Dword((@Buf[0])^)=EELITE)
          end // if BootReadBlk
          else begin
           AddLinesLog('Не прочитать инфу блока с адреса '+IntToHex(TabAddrEELITE[i],8)+'!');
           StatusBar.Panels[PanelCmd].Text:='Ошибка чтения блоков EELITE!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           BootEnd; exit;
          end; // if BootReadBlk
          Inc(i);
         end; // while TabAddrEEFULL[i]<>0
         if y=0 then begin
           AddLinesLog('Не найден сегмент EELITE!');
           errflg:=True;
         end;
         StatusBar.Panels[PanelCmd].Text:='Чтение EEFULL...';
         Application.ProcessMessages;
         i:=0; y:=0;
         if NewSGold then i:=4;
         AddLinesLog('Поиск сегментов EEFULL...');
         Repaint;
         while TabAddrEEFULL[i]<>0 do begin
          if Not NewSGold then if i=3 then break;
          addr:=TabAddrEEFULL[i];
          if BootReadBlk(addr,$10,buf) then begin
           if (Dword((@Buf[0])^)=$55464545) and (Dword((@Buf[4])^)=$00004C4C) then begin
            if not(BootReadBlk(addr+$10,$10000-$10,buf[$10]) and BootReadBlk(addr+$10000,$10000,buf[$10000]))
            then begin
             StatusBar.Panels[PanelCmd].Text:='Ошибка при чтении сегмента EEFULL!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             BootEnd; exit;
            end;
            ProgressBar.StepBy(20);
            if Not AddSegBlkEEP(addr,buf,False) then begin
             StatusBar.Panels[PanelCmd].Text:=sEep_Err;
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
//             BootEnd; exit;
            end;
            inc(y);
            if y>1 then begin
             ProgressBar.Position:=80;
             break;
            end;
           end; // if (Dword((@Buf[0])^)=$55464545)
          end // if BootReadBlk
          else begin
           AddLinesLog('Не прочитать инфу блока с адреса '+IntToHex(TabAddrEEFULL[i],8)+'!');
           StatusBar.Panels[PanelCmd].Text:='Ошибка чтения блоков EEFULL';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           BootEnd; exit;
          end; // if BootReadBlk
          Inc(i);
         end; // while TabAddrEEFULL[i]<>0
         if y=0 then begin
           AddLinesLog('Не найдены сегменты EEFULL!');
           errflg:=True;
         end;
         if idx_eeptab<>0 then begin
          sBlkFile := IniFile.ReadString('System','DirBackup','.\Backup');
          if not DirectoryExists(sblkFile) then begin
           sBlkFile := '.\Backup';
          if not CreateDir(sBlkFile) then sBlkFile := '.';
           IniFile.WriteString('System','DirBackup',sblkFile)
          end;
          if sblkFile[length(sblkFile)]<>'\' then sblkFile:=sblkFile+'\';
          sblkFile := sblkFile + IntToHex(eepESN,8) + '_EEP_'+ FormatDateTime('yymmddhhnnss',Now) + '.eep';
          if not SaveAllEEP(sblkFile,SpinEditHWID.Value) then begin
           StatusBar.Panels[PanelCmd].Text:=sEep_Err;
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
//           BootEnd; exit;
          end
          else begin
            StatusBar.Panels[PanelCmd].Text:='Всего EEP блоков: '+IntToStr(idx_eeptab);
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            AddLinesLog('Блоки сохранены в '+sblkFile);
            ProgressBar.Position:=100;
          end;
         end // if idx_eeptab<>0
         else begin
           AddLinesLog('EEP блоков не найдено!');
         end; // if idx_eeptab<>0
        end; // if CheckBoxSaveEEP.Checked
//----------------New5121 and Freia
        if CheckBoxNew5121.Checked
        or CheckBoxFreia.Checked
        then begin
         if ((fBtImei or fBtoImei or fbtClr)
         and fBtEsn
         and (length(sImei)=15))
         then begin
          StatusBar.Panels[PanelCmd].Text:='Работа с EEPROM...';
          Repaint;
          Application.ProcessMessages;
          // Create 5121,5122,5123 blocks
          Create512x(sImei,eepESN,eepSkey,Mkey);
          if CheckBoxReCalkFull.Checked then begin
           // Create 52 block
           CalkHashAndBkey(eepSkey,eepESN);
           ProgressBar.Position:=40;
           EditHASH.Text:=BufToHexStr(@HASH,16);
           EditBootKey.Text:=BufToHexStr(@BootKey,16);
//           AddLinesLog('New HASH: '+EditHASH.Text);
//           AddLinesLog('New BKey: '+EditBootKey.Text);
           Create52(eepESN,eepSkey,byte(SpinEditVerDown.Value));
          end; // CheckBoxReCalkFull.Checked
          ProgressBar.Position:=20;
          if (not CheckBoxFreia.Checked) then begin
           if CheckBoxSaveEEP.Checked and (idx_eeptab<>0) then begin
            i:=0;
            while (i<idx_eeptab) do begin
             if EepTab[i].num=5121 then break;
             inc(i);
            end;
            if EepTab[i].num=5121 then begin
             if EepTab[i].len=56 then begin
              ProgressBar.Position:=80;
              Move(EepTab[i].buf^,buf,56);
              addr:=EepTab[i].addr;
              y:=0;
              for x:=8 to 55 do begin
               if EEP5121[x]<>buf[x] then begin
                inc(y);
                break;
               end;
              end; // for
              if y<>0 then begin
               ProgressBar.Position:=90;
               if BootPatchBlk(addr+9,sizeof(EEP5121)-8,EEP5121[8]) then begin
                AddLinesLog('Блок 5121 подменен.');
                AddLinesLog('Новые Мастер коды:');
                for i:=0 to 5 do AddLinesLog('*#000'+IntToStr(i)+'*'+Int2Digs(Mkey[i],8)+'#');
                ProgressBar.Position:=100;
               end
               else begin
                StatusBar.Panels[PanelCmd].Text:='Невозможно заменить блок 5121!';
                AddLinesLog(StatusBar.Panels[PanelCmd].Text);
                AddLinesLog('Замена неудачна - проверьте телефон!');
                BootEnd; exit;
               end;
              end
              else begin
               AddLinesLog('Мастер коды уже заменены на:');
               for i:=0 to 5 do AddLinesLog('*#000'+IntToStr(i)+'*'+Int2Digs(Mkey[i],8)+'#');
               ProgressBar.Position:=100;
              end; // замена
             end // if EepTab[i].len=56
             else begin
               AddLinesLog('Невозможно заменить кривой блок 5121!');
             end;
            end // if EepTab[i].num=5121
            else begin
              AddLinesLog('Блок 5121 не найден!');
            end;
           end // if CheckBoxSaveEEP.Checked
           else begin
            if EEBlkSearch(121,$A0220000,sizeof(buf),buf,i,addr) // x65
            or ((Not err_io_tst_eep) and EEBlkSearch(121,$A0240000,sizeof(buf),buf,i,addr)) // x65
            or ((Not err_io_tst_eep) and EEBlkSearch(121,$A1FC0000,sizeof(buf),buf,i,addr)) // CX/M75, SK65
            or ((Not err_io_tst_eep) and EEBlkSearch(121,$A1FE0000,sizeof(buf),buf,i,addr)) // CX/M75, SK65
//            or ((Not err_io_tst_eep) and EEBlkSearch(121,$A3FA0000,sizeof(buf),buf,i,addr)) // S75!?
//            or ((Not err_io_tst_eep) and EEBlkSearch(121,$A3FC0000,sizeof(buf),buf,i,addr)) // S75!?
            then begin
             if i=57 then begin
              ProgressBar.Position:=80;
              move(buf[1],EEP5121,8);
              y:=0;
              for i:=8 to 55 do begin
               if EEP5121[i]<>buf[i+1] then begin
                inc(y);
                break;
               end;
              end; // for
              if y<>0 then begin
               s := IniFile.ReadString('System','DirBackup','.\Backup');
               if not DirectoryExists(s) then begin
                s := '.\Backup';
                if not CreateDir(s) then s := '.';
                IniFile.WriteString('System','DirBackup',s)
               end;
               if s[length(s)]<>'\' then s:=s+'\';
               s := s + EditIMEI.Text +'_EEP_'+FormatDateTime('yymmddhhnnss',Now);
               if CheckBoxBackup.Checked
               and SaveEepBin(False,s,buf[1],56,5121,SpinEditHWID.Value,0) then begin
                AddLinesLog('Старый блок 5121 сохранен в '+ ExtractFileName(s)+'_5121');
               end;
               //else errflg:=True;
               ProgressBar.Position:=90;
               if BootPatchBlk(addr+1,sizeof(EEP5121),EEP5121) then begin
                AddLinesLog('Блок 5121 подменен.');
                AddLinesLog('Новые Мастер коды:');
                for i:=0 to 5 do AddLinesLog('*#000'+IntToStr(i)+'*'+Int2Digs(Mkey[i],8)+'#');
                ProgressBar.Position:=100;
               end
               else begin
                StatusBar.Panels[PanelCmd].Text:='Невозможно заменить блок 5121!';
                AddLinesLog(StatusBar.Panels[PanelCmd].Text);
                AddLinesLog('Замена неудачна - проверьте телефон!');
                BootEnd; exit;
               end;
              end
              else begin
               AddLinesLog('Мастер коды уже заменены на:');
               for i:=0 to 5 do AddLinesLog('*#000'+IntToStr(i)+'*'+Int2Digs(Mkey[i],8)+'#');
               ProgressBar.Position:=100;
              end;
             end // if size<>57
             else begin
               AddLinesLog('Невозможно заменить кривой блок 5121!');
             end;
            end
            else begin
             if err_io_tst_eep then AddLinesLog('Ошибки при поиске блока 5121!')
             else AddLinesLog('Блок 5121 не найден!');
             errflg:=True;
            end;
           end;
          end // if (not CheckBoxFreia.Checked)
          else begin
           Create76(sIMEI,EEP0076,C55);
           Create5009(sIMEI,EEP5009,C55);
           Create5008(sIMEI,eepESN,EEP5008,C55);
           Create5077(sIMEI,eepESN,EEP5077,C55);
{           if CheckBoxSaveEEP.Checked and (idx_eeptab<>0) then begin
              ProgressBar.Position:=70;
              AddLinesLog('Всего EEP блоков: '+IntToStr(idx_eeptab));
              StatusBar.Panels[PanelCmd].Text:='Замена блоков EEPROM (не сделал)...';
              AddLinesLog(StatusBar.Panels[PanelCmd].Text);
              Repaint;
              Application.ProcessMessages;
              y:=0;
           end // if CheckBoxSaveEEP.Checked and (idx_eeptab<>0)
           else begin }
            ClearEEPBufAndTab;
            ProgressBar.Position:=10;
            if EEFULLtab($A0220000)
            or ((Not err_io_tst_eep) and EEFULLtab($A1FC0000))
            then begin
             ProgressBar.Position:=50;
             if EEFULLtab($A0FE0000)
             or ((Not err_io_tst_eep) and EEFULLtab($A0020000))
             then begin
              ProgressBar.Position:=90;
              AddLinesLog('Всего EEP блоков: '+IntToStr(idx_eeptab));
              StatusBar.Panels[PanelCmd].Text:='Замена блоков EEPROM...';
              Repaint;
              Application.ProcessMessages;
              y:=0;
              for i:=0 to idx_eeptab-1 do begin
               case EepTab[i].num of
                  76 : begin y:=y or 1; EepTab[i].buf:=@EEP0076; end;
                5008 : begin y:=y or 2; EepTab[i].buf:=@EEP5008; end;
                5009 : begin y:=y or 4; EepTab[i].buf:=@EEP5009; end;
                5077 : begin y:=y or 8; EepTab[i].buf:=@EEP5077; end;
                5121 : begin y:=y or 16; EepTab[i].buf:=@EEP5121; end;
                5122 : begin y:=y or 32; EepTab[i].buf:=@EEP5122; end;
                5123 : begin y:=y or 64; EepTab[i].buf:=@EEP5123; end;
                  52 : begin y:=y or 128; EepTab[i].buf:=@EEP0052; end;
                0 : break;
               end;
               if y=255 then break;
              end;
              if ((CheckBoxReCalkFull.Checked and ((y and 255)=255))
              or ((not CheckBoxReCalkFull.Checked) and CheckBoxNew5121.Checked and ((y and 31)=31))
              or ((not CheckBoxNew5121.Checked) and ((y and 15)=15)))
              then begin
               if not CheckBoxNew5121.Checked then
                AddLinesLog('Блоки 76,5008,5009,5077 найдены.')
               else if not CheckBoxReCalkFull.Checked then
                AddLinesLog('Блоки 76,5008,5009,5077,5121 найдены.')
               else
                AddLinesLog('Блоки 52,76,5008,5009,5077,5121,5122,5123 найдены.');
                s := IniFile.ReadString('System','DirBackup','.\Backup');
               if not DirectoryExists(s) then begin
                s := '.\Backup';
               if not CreateDir(s) then s := '.';
                IniFile.WriteString('System','DirBackup',s)
               end;
               if s[length(s)]<>'\' then s:=s+'\';
               s := s + EditIMEI.Text +'_EEP_'+FormatDateTime('yymmddhhnnss',Now);
               for i:=0 to idx_eeptab-1 do begin
                y:=0;
                case EepTab[i].num of
                 76,5008,5009,5077: if CheckBoxFreia.Checked then y:=1;
                 5121: if CheckBoxReCalkFull.Checked then y:=4 else if CheckBoxNew5121.Checked then y:=2;
                 52,5122,5123: if CheckBoxReCalkFull.Checked then y:=4;
                 0 : break;
                end; // case
                if y<>0 then begin
                 if not BootReadBlk(EepTab[i].addr,EepTab[i].len,buf) then begin
                  StatusBar.Panels[PanelCmd].Text:='Не прочитать блок памяти!';
                  AddLinesLog(StatusBar.Panels[PanelCmd].Text);
                  BootEnd; exit;
                 end;
                 if (y=2) then move(buf[1],EEP5121,8);
                 y:=0;
                 Pbyte(addr):=EepTab[i].buf;
                 if (EepTab[i].num>=5000) then x:=1
                 else x:=0;
 //                  AddLinesLog(BufToHexStr(Pbyte(addr),EepTab[i].len-1));
 //                  AddLinesLog(BufToHexStr(@buf[x],EepTab[i].len-1));
                 for z:=0 to EepTab[i].len-2 do begin
                  if Byte(Pbyte(addr+dword(z))^)<>buf[z+x] then begin
                   inc(y); break;
                  end;
                 end;
                 if y<>0 then begin // Замена блока
                  if CheckBoxBackup.Checked then begin
                   if ((EepTab[i].num>=5000) and SaveEepBin(False,s,buf[1],EepTab[i].len-1,EepTab[i].num,SpinEditHWID.Value,buf[0]))
                   or ((EepTab[i].num<5000) and SaveEepBin(False,s,buf,EepTab[i].len-1,EepTab[i].num,SpinEditHWID.Value,buf[EepTab[i].len-1]))
                   then begin
                    AddLinesLog('Старый блок '+IntToStr(EepTab[i].num)+' сохранен в '+ ExtractFileName(s)+'_'+IntToStr(EepTab[i].num));
                    ProgressBar.StepBy(5);
                   end;
                  end; // if CheckBoxBackup.Checked
                  if BootPatchBlk(EepTab[i].addr+dword(x),EepTab[i].len-1,EepTab[i].buf^) then begin
                   AddLinesLog('Блок '+IntToStr(EepTab[i].num)+' подменен.');
                   if EepTab[i].num=5121 then begin
                     AddLinesLog('Новые Мастер коды:');
                     for z:=0 to 5 do AddLinesLog('*#000'+IntToStr(z)+'*'+Int2Digs(Mkey[z],8)+'#');
                   end;
                   ProgressBar.StepBy(2);
                  end
                  else begin
                   StatusBar.Panels[PanelCmd].Text:='Невозможно заменить блок '+IntToStr(EepTab[i].num)+'!';
                   AddLinesLog(StatusBar.Panels[PanelCmd].Text);
                   AddLinesLog('Замена неудачна - проверьте телефон!');
                   BootEnd; exit;
                  end;
 //                   AddLinesLog('Блок '+IntToStr(EepTab[i].num)+' подменен.');
                 end // if y<>0 блок не требует замены
                 else AddLinesLog('Блок '+IntToStr(EepTab[i].num)+' не требует замены!');
                end; // if y<>0 не надо менять этот номер блока
               end; // for
               ProgressBar.Position:=100;
              end
              else begin
               if ((y and 1) = 0) then AddLinesLog('Не найден блок 76!');
               if ((y and 2) = 0) then AddLinesLog('Не найден блок 5008!');
               if ((y and 4) = 0) then AddLinesLog('Не найден блок 5009!');
               if ((y and 8) = 0) then AddLinesLog('Не найден блок 5077!');
               if ((y and 16) = 0) then AddLinesLog('Не найден блок 5121!');
               if ((y and 32) = 0) then AddLinesLog('Не найден блок 5122!');
               if ((y and 64) = 0) then AddLinesLog('Не найден блок 5123!');
               if ((y and 128) = 0) then AddLinesLog('Не найден блок 52!');
               errflg:=True;
              end; // if ((y and 15)=15)
             end
             else begin
              if err_io_tst_eep then AddLinesLog('Ошибки I/O при анализе EELITE!')
              else AddLinesLog('Не найден сегмент EELITE!');
              errflg:=True;
             end;
            end
            else begin
             if err_io_tst_eep then AddLinesLog('Ошибки I/O при анализе EEFULL!')
             else AddLinesLog('Не найден сегмент EEFULL!');
             errflg:=True;
            end;
{           end; // if CheckBoxSaveEEP.Checked and (idx_eeptab<>0) then begin
}          end; // CheckBoxFreia.Checked
         end //if fBtImei and fBtEsn
         else begin
          AddLinesLog('Замена блока(ов) невозможна: неверные ESN и/или IMEI!');
         end; //if fBtImei and fBtEsn
        end; // if CheckBoxNew5121.Checked or CheckBoxFreia.Checked
//----------------SetVDown
//          HASH $A0000238
//          IMEI $A000065C
//----------------ReCalkKey
        if (CheckBoxSetVDown.Checked
        or CheckBoxReCalkFull.Checked)
        and (not CheckBoxNewBcore.Checked)
        and (not CheckBoxClrBcor.Checked)
        then begin
         if RadioGroupBootType.ItemIndex=2 then begin
          if CheckBoxBackup.Checked then begin
           ProgressBar.Position:=20;
           AddLinesLog('Чтение сегмента BCORE...');
           s:=IntToHex(eepESN,8)+ '_A0000000_BCORE_'+ FormatDateTime('yymmddhhnnss',Now) + '.bin';
           if CreateSegBackup($A0000000,s,buf) then begin
            AddLinesLog('Сегмент BCORE сохранен в '+ s);
           end
           else begin
           StatusBar.Panels[PanelCmd].Text:='Ошибка при бэкапе сегмента BCORE!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           BootEnd; exit;
           end; // if CreateSegBackup($A0000000,s,buf)
          end // if CheckBoxBackup.Checked
          else begin
           if Not BootReadBlk($A003E020,2,buf[$3E020]) then begin
            StatusBar.Panels[PanelCmd].Text:='Ошибка чтения по адресу A003E020!';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            BootEnd; exit;
           end;
          end;
          Application.ProcessMessages;
          b:=buf[$3E020]; buf[$3E020]:=otk;
          AddLinesLog('Прошлый номер "отката" '+IntToHex(b,2));
          Application.ProcessMessages;
          if (otk=b) then begin
           AddLinesLog('BCORE "откат" не требует смены!');
          end
          else begin
           if BootPatchBlk($A003E020,1,buf[$3E020]) then
            AddLinesLog('Откат установлен до '+IntToHex(otk,2)+' версии.')
           else begin
            StatusBar.Panels[PanelCmd].Text:='Ошибка патча сегмента BCORE!';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            BootEnd; exit;
           end; // if BootPatchBlk }
           Application.ProcessMessages;
          end;
         end //if RadioGroupBootType.ItemIndex=2
         else begin
         StatusBar.Panels[PanelCmd].Text:='Обработка BCORE...';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         Repaint;
         Application.ProcessMessages;
         x:=2;
         if CheckBoxReCalkFull.Checked then begin
          if fBtClr then begin
           StatusBar.Panels[PanelCmd].Text:='Телефон требует Фрезу!?';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           BootEnd; exit;
          end;
          x:=$0660-$0230+16;
         end;
         ProgressBar.Position:=30;
         if Not BootReadBlk($A0000200,4,buf[$00200]) then begin
          StatusBar.Panels[PanelCmd].Text:='Ошибка чтения по адресу A0000200!';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          BootEnd; exit;
         end;
         if Not BootReadBlk($A0000230,x,buf[$00230]) then begin
          StatusBar.Panels[PanelCmd].Text:='Ошибка чтения по адресу A0000230!';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          BootEnd; exit;
         end;
         y:=0;
         if CheckBoxSetVDown.Checked then begin
          b:=buf[$230];
          if (otk=b) then begin
           AddLinesLog('BCORE "откат" не требует смены!');
          end
          else begin
           AddLinesLog('Прошлый номер "отката" '+IntToHex(b,2));
           y:=1;
          end;
         end; // CheckBoxSetVDown.Checked
         if CheckBoxReCalkFull.Checked then begin
          if buf[$200]=02 then begin
           for i:=0 to 15 do begin
            if HASH[i]<>buf[$23C+i] then begin y:=y or 2; break; end;
           end;
           for i:=1 to 15 do begin
            if byte(sIMEI[i])<>buf[$660-1+i] then begin y:=y or 4; break; end;
           end;
          end else begin
           for i:=0 to 15 do begin
            if HASH[i]<>buf[$238+i] then begin y:=y or 2; break; end;
           end;
           for i:=1 to 15 do begin
            if byte(sIMEI[i])<>buf[$65C-1+i] then begin y:=y or 4; break; end;
           end;
          end;
          if (y and 2)=0 then AddLinesLog('BCORE HASH не требует смены!');
          if (y and 4)=0 then AddLinesLog('BCORE IMEI не требует смены!');
         end; // CheckBoxReCalkFull.Checked
         if (y<>0) then begin
          if CheckBoxBackup.Checked then begin
           ProgressBar.Position:=50;
           AddLinesLog('Чтение сегмента BCORE...');
           s:=IntToHex(eepESN,8)+ '_A0000000_BCORE_'+ FormatDateTime('yymmddhhnnss',Now) + '.bin';
           if CreateSegBackup($A0000000,s,buf) then begin
            AddLinesLog('Сегмент BCORE сохранен в '+ s);
           end
           else begin
           StatusBar.Panels[PanelCmd].Text:='Ошибка при бэкапе сегмента BCORE!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           BootEnd; exit;
           end; // if CreateSegBackup($A0000000,s,buf)
          end; // if CheckBoxBackup.Checked
          ProgressBar.Position:=80;
          if (y and 1)<>0 then begin buf[$230]:=otk; x:=2; end;
          if buf[$200]=02 then begin
           if (y and 2)<>0 then begin move(HASH,buf[$23C],16); x:=16+$0C; end;
           if (y and 4)<>0 then begin move(sIMEI[1],buf[$660],15);x:=$0660-$0230+16; end;
          end else begin
           if (y and 2)<>0 then begin move(HASH,buf[$238],16); x:=16+8; end;
           if (y and 4)<>0 then begin move(sIMEI[1],buf[$65C],15);x:=$065C-$0230+16; end;
          end;
          if BootPatchBlk($A0000230,x,buf[$230]) then begin
           if (y and 1)<>0 then
            AddLinesLog('Откат установлен до '+IntToHex(otk,2)+' версии.');
           if (y and 2)<>0 then begin
            AddLinesLog('Новый HASH прописан в BCORE.');
//            AddLinesLog('Проверьте новый Bkey!');
           end;
           if (y and 4)<>0 then begin
            AddLinesLog('Новый IMEI прописан в BCORE.');
           end;
           y:=0;
//   IniFile.WriteInteger(sIMEI,'SKEY',SKey);
//   IniFile.WriteString(sIMEI,'HASH',BufToHexStr(@HASH,16));
//   IniFile.WriteString(sIMEI,'BKEY',BufToHexStr(@BootKey,16));
          end
          else begin
           StatusBar.Panels[PanelCmd].Text:='Ошибка патча сегмента BCORE!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           BootEnd; exit;
          end; // if BootPatchBlk }
         end; // if (y<>0) надо патчить
         if y=0 then begin
          if CheckBoxReCalkFull.Checked then begin
            EditHASH.Text:=BufToHexStr(@HASH,16);
            IniFile.WriteString(sIMEI,'HASH',EditHASH.Text);
            EditBOOTKey.Text:=BufToHexStr(@BootKey,16);
            IniFile.WriteString(sIMEI,'BKEY',EditBOOTKey.Text);
            EditSkey.Text:=IntToStr(eepSkey);
            IniFile.WriteInteger(sIMEI,'SKEY',eepSkey);
          end;
          ProgressBar.Position:=100;
         end;
         end;
        end; // if CheckBoxSetVDown.Checked
//--------------ClrEEFULL
        if CheckBoxClrEEFULL.Checked then begin
         StatusBar.Panels[PanelCmd].Text:='Очистка EEFULL...';
         Repaint;
         Application.ProcessMessages;
         i:=0; y:=0;
         if NewSGold then i:=4;
         AddLinesLog('Поиск сегмента EEFULL...');
         while TabAddrEEFULL[i]<>0 do begin
          if Not NewSGold then if i=3 then break;
          if BootReadBlk(TabAddrEEFULL[i],16,buf) then begin
           if (Dword((@Buf[0])^)=$55464545) and (Dword((@Buf[4])^)=$00004C4C) then begin
            if CheckBoxBackup.Checked then begin
             AddLinesLog('Чтение сегмента EEFULL '+IntToHex(TabAddrEEFULL[i],8)+'...');
             s :=IntToHex(eepESN,8)+ '_'+IntToHex(TabAddrEEFULL[i],8)+'_EEFULL_'+ FormatDateTime('yymmddhhnnss',Now) + '.bin';
             if CreateSegBackup(TabAddrEEFULL[i],s,buf)
             then begin
              ProgressBar.StepBy(20);
              if y=0 then AddLinesLog('Первый сегмент EEFULL сохранен в '+ s)
              else AddLinesLog('Второй сегмент EEFULL сохранен в '+ s)
             end // if CreateSegBackup
             else begin
              StatusBar.Panels[PanelCmd].Text:='Ошибка при бэкапе сегмента EEFULL!';
              AddLinesLog(StatusBar.Panels[PanelCmd].Text);
              BootEnd; exit;
             end; // if CreateSegBackup
            end; //if CheckBoxBackup.Checked
            Dword((@Buf[0])^):=$55464545;
            Dword((@Buf[4])^):=$00004C4C;
            Dword((@Buf[8])^):=$00000000;
            Dword((@Buf[12])^):=$FFFFFFF0;
            if BootEraseBlk(TabAddrEEFULL[i],$20000) and BootPatchBlk(TabAddrEEFULL[i],16,buf)
            then begin
             ProgressBar.StepBy(20);
             if y=0 then AddLinesLog('Первый сегмент EEFULL очищен.')
             else AddLinesLog('Второй сегмент EEFULL очищен.')
            end // if BootEraseBlk and BootPatchBlk
            else begin
              StatusBar.Panels[PanelCmd].Text:='Ошибка при очистке сегмента EEFULL!';
              AddLinesLog(StatusBar.Panels[PanelCmd].Text);
              BootEnd; exit;
            end; // if BootEraseBlk and BootPatchBlk
            inc(y);
            if y>1 then begin
             ProgressBar.Position:=100;
             break;
            end;
           end; // if (Dword((@Buf[0])^)=$55464545)
          end // if BootReadBlk
          else begin
           AddLinesLog('Не прочитать инфу блока с адреса '+IntToHex(TabAddrEEFULL[i],8)+'!');
           StatusBar.Panels[PanelCmd].Text:='Ошибка очистки сегментов EEFULL';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           BootEnd; exit;
          end; // if BootReadBlk
          Inc(i);
         end; // while TabAddrEEFULL[i]<>0
         if y=0 then begin
           AddLinesLog('Не найдены сегменты EEFULL!');
           errflg:=True;
         end;
        end; // if CheckBoxClrEEFULL.Checked
//----------------ClrEELITE
        if CheckBoxClrEELITE.Checked then begin
         i:=0; y:=0;
         if NewSGold then i:=2;
         StatusBar.Panels[PanelCmd].Text:='Очистка EELITE...';
         AddLinesLog('Поиск сегмента EELITE...');
         Repaint;
         Application.ProcessMessages;
         while TabAddrEELITE[i]<>0 do begin
          if Not NewSGold then if i=2 then break;
          if BootReadBlk(TabAddrEELITE[i],16,buf) then begin
           if (Dword((@Buf[0])^)=$494C4545) and (Dword((@Buf[4])^)=$00004554) then begin
            if CheckBoxBackup.Checked then begin
//             AddLinesLog('Чтение сегмента EELITE '+IntToHex(TabAddrEEFULL[i],8)+'...');
             s :=IntToHex(eepESN,8)+ '_'+IntToHex(TabAddrEELITE[i],8)+'_EELITE_'+ FormatDateTime('yymmddhhnnss',Now) + '.bin';
             if CreateSegBackup(TabAddrEELITE[i],s,buf)
             then begin
              AddLinesLog('Сегмент EELITE сохранен в '+ s)
             end // if CreateSegBackup
             else begin
              StatusBar.Panels[PanelCmd].Text:='Ошибка при бэкапе сегмента EEFULL!';
              AddLinesLog(StatusBar.Panels[PanelCmd].Text);
              BootEnd; exit;
             end; // if CreateSegBackup
            end; //if CheckBoxBackup.Checked
            Dword((@Buf[0])^):=$494C4545;
            Dword((@Buf[4])^):=$00004554;
            Dword((@Buf[8])^):=$00000000;
            Dword((@Buf[12])^):=$FFFFFFF0;
            if BootEraseBlk(TabAddrEELITE[i],$20000) and BootPatchBlk(TabAddrEELITE[i],16,buf)
            then begin
             AddLinesLog('Сегмент EELITE очищен.')
            end // if BootEraseBlk and BootPatchBlk
            else begin
             StatusBar.Panels[PanelCmd].Text:='Ошибка при очистке сегмента EELITE!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             BootEnd; exit;
            end; // if BootEraseBlk and BootPatchBlk
            inc(y);
            break;
           end; // if (Dword((@Buf[0])^)=$55464545)
          end // if BootReadBlk
          else begin
           AddLinesLog('Не прочитать инфу блока с адреса '+IntToHex(TabAddrEELITE[i],8)+'!');
           StatusBar.Panels[PanelCmd].Text:='Ошибка очистки сегмента EELITE';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           BootEnd; exit;
          end; // if BootReadBlk
          Inc(i);
         end; // while TabAddrEEFULL[i]<>0
         if y=0 then begin
           AddLinesLog('Не найден сегмент EELITE!');
           errflg:=True;
         end;
        end; // if CheckBoxClrEELITE.Checked
//----------------ClrExit
        if CheckBoxClrExit.Checked then begin
         StatusBar.Panels[PanelCmd].Text:='Очистка EXIT...';
         Repaint;
         Application.ProcessMessages;
         Case SpinEditHWID.Value of
          320, // CX65
          321, // M65
          322, // CX70
          323, // S65
//        324, // SL65
//        325, //
//        326, //
          327, // C65
//        328, //
//        329, // SK65
//        330, //
//        331, //
//        332, //
          333..340: // S66 SP65
          addr:=$A0200000;
          5000,5001,341: // CX75,M75,C75
          addr:=$A1FA0000;
          400:           // S75
          addr:=$A3FE0000;
          else addr:=$0;
         end; // Case
         if addr<>0 then begin
          ProgressBar.Position:=10;
          AddLinesLog('Проверка сегмента EXIT...');
          if BootTestFFBlk(addr+8,$20000-8,b) then begin
           if b=$FF then begin
            AddLinesLog('Сегмент EXIT уже пуст!');
            ProgressBar.Position:=100;
           end // if b=$FF
           else begin
            ProgressBar.Position:=30;
            if BootReadBlk(addr,8,buf) then begin
             if (Dword((@Buf[0])^)=$F8010001) then begin
              if CheckBoxBackup.Checked then begin
               ProgressBar.Position:=50;
               AddLinesLog('Чтение сегмента '+IntToHex(addr,8)+' EXIT...');
               s:=IntToHex(eepESN,8)+ '_'+IntToHex(addr,8)+'_EXIT_'+ FormatDateTime('yymmddhhnnss',Now) + '.bin';
               if CreateSegBackup(addr,s,buf) then begin
                AddLinesLog('Сегмент EXIT сохранен в '+ s);
               end
               else begin
                StatusBar.Panels[PanelCmd].Text:='Ошибка при бэкапе сегмента EXIT!';
                AddLinesLog(StatusBar.Panels[PanelCmd].Text);
                BootEnd; exit;
               end; // if CreateSegBackup($A0200000,s,buf)
              end; // if CheckBoxBackup.Checked
              ProgressBar.Position:=80;
              Dword((@Buf[0])^):=$F8010001;
              Dword((@Buf[4])^):=$FFFFFF01;
              if BootEraseBlk(addr,$20000) and BootPatchBlk(addr,8,buf[0]) then begin
               AddLinesLog('Сегмент EXIT очищен.');
               ProgressBar.Position:=100;
              end // if BootEraseBlk($A0200000)
              else begin
               StatusBar.Panels[PanelCmd].Text:='Ошибка очистки сегмента EXIT!';
               AddLinesLog(StatusBar.Panels[PanelCmd].Text);
               BootEnd; exit;
              end; // if BootEraseBlk($A0200000)
             end  //if (Word((@Buf[0])^)<>$4545)
             else begin
              AddLinesLog('Неверный маркер сегмента EXIT!');
             end; //if (Word((@Buf[0])^)<>$4545)
            end // if BootReadBlk(
            else begin
             StatusBar.Panels[PanelCmd].Text:='Не прочитать блок с адреса '+IntToHex(addr,8)+'!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             BootEnd; exit;
            end; // if BootReadBlk(
           end; // if b=$FF
          end // if BootTestFFBlk($A0200000,$20000,b)
          else begin
           StatusBar.Panels[PanelCmd].Text:='Не протестить блок по адресу '+IntToHex(addr,8)+'!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           BootEnd; exit;
          end; // if BootReadBlk(
         end //if addr<>0
         else AddLinesLog('На даноой модели EXIT пока неизвестен!');
        end; // if CheckBoxClrExit.Checked
//----------------ClrBCORE
        if ( CheckBoxClrBcor.Checked
        and CheckBoxClrBcor.Visible)
        and (not CheckBoxNewBcore.Checked)
        then begin
         StatusBar.Panels[PanelCmd].Text:='Очистка BCORE...';
         AddLinesLog('Чтение сегмента A0000000 BCORE...');
         ProgressBar.Position:=10;
         Repaint;
         Application.ProcessMessages;
         s:=IntToHex(eepESN,8)+ '_A0000000_BCORE_'+ FormatDateTime('yymmddhhnnss',Now) + '.bin';
         if CreateSegBackup($A0000000,s,buf) then begin
          AddLinesLog('Сегмент BCORE сохранен в '+ s);
         end
         else begin
            StatusBar.Panels[PanelCmd].Text:='Ошибка при бэкапе сегмента BCORE!';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            BootEnd; exit;
         end;
         if (Dword((@buf[$3C])^)<>$544B4A43) then AddLinesLog('Неверный блок BCORE!')
         else begin
          if ClearBCoreBuf(buf[0]) then begin
           ProgressBar.Position:=50;
          //Очищаем 00000204...000007FF, 00000A90..00001FFF, кроме 00000654..0000065B
          // сохраняем
           if BootPatchBlk($A0000204,$002000-$204,buf[$204]) then begin
            ProgressBar.Position:=100;
            AddLinesLog('BCORE очищен.');
           end
           else begin
            StatusBar.Panels[PanelCmd].Text:='Ошибка очистки сегмента BCORE!';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            BootEnd; exit;
           end; // if BootPatchBlk
          end // if ClearBCoreBuf
          else AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         end; // if (Dword((@buf[$3C])^)<>$544B4A43)
        end; // if CheckBoxClrBCORE.Checked
//----------------NewBCORE
        if CheckBoxNewBcore.Checked then begin
         StatusBar.Panels[PanelCmd].Text:='Обновление BCORE...';
         ProgressBar.Position:=20;
         Repaint;
         Application.ProcessMessages;
         if CheckBoxBackup.Checked then begin
          AddLinesLog('Чтение сегмента A0000000 BCORE...');
          s:=IntToHex(eepESN,8)+ '_A0000000_BCORE_'+ FormatDateTime('yymmddhhnnss',Now) + '.bin';
          if CreateSegBackup($A0000000,s,buf) then AddLinesLog('Сегмент BCORE сохранен в '+ s)
          else begin
           StatusBar.Panels[PanelCmd].Text:='Ошибка при бэкапе сегмента BCORE!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           BootEnd; exit;
          end;
         end // if CheckBoxBackup.Checked
         else begin
          if RadioGroupBootType.ItemIndex <> 2 then begin
           if (NOT BootReadBlk($A0000200,4,buf[$200])) or
              (NOT BootReadBlk($A0000860,64,buf[$860])) then begin
             StatusBar.Panels[PanelCmd].Text:='Ошибка при чтении сегмента BCORE!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             BootEnd; exit;
           end;
          end // if RadioGroupBootType.ItemIndex
          else begin
           if (NOT BootReadBlk($A0000030,16,buf[$30])) or
              (NOT BootReadBlk($A0000C80,$20,buf[$0C80])) then begin
             StatusBar.Panels[PanelCmd].Text:='Ошибка при чтении сегмента BCORE!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             BootEnd; exit;
           end;
          end; // if RadioGroupBootType.ItemIndex
         end; // if CheckBoxBackup.Checked
         if RadioGroupBootType.ItemIndex <> 2 then addr:=$880 else addr:=$C80;
         if (Buf[addr]=$53) then AddLinesLog('Был BCORE версии: "'+Pchar(@Buf[addr+$10])+'"');
         ProgressBar.Position:=40;
         if RadioGroupBootType.ItemIndex <> 2 then begin
          if NewSGold then Move(NewBcore75[0],Buf[0],SizeOf(NewBcore75))
          else Move(NewBcore65[0],Buf[0],SizeOf(NewBcore65));
         end
         else Move(NewBcore85[0],Buf[0],SizeOf(NewBcore85));
          if (Dword((@buf[$10])^)=$56505650) then begin
           Pointer(addr):=@Buf[0];
           for i:=0 to (seg_size shr 2) do begin
            Dword(Pointer(addr)^):=Dword(Pointer(addr)^) xor $56505650;
            inc(addr,4);
           end;
          end;
         Dword((@buf[$3C])^):=$FFFFFFFF;//$544B4A43; // CJKT
         AddLinesLog('Запись BCORE версии: "'+Pchar(@buf[$890])+'"');
         Application.ProcessMessages;
         if BootWriteFlash($A0000000,seg_size, Buf[0]) then begin
          ProgressBar.Position:=60;
          AddLinesLog('BCORE enable...');
          Dword((@buf[0])^):=$544B4A43; // CJKT
          if BootPatchBlk($A000003C,4,buf) then begin
           ProgressBar.Position:=100;
           AddLinesLog('Новый BCORE записан.');
           AddLinesLog('Не забудьте сделать фрезу!');
          end
          else begin
           StatusBar.Panels[PanelCmd].Text:='Ошибка включения нового BCORE!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           AddLinesLog('Повторите операцию!');
           BootEnd; exit;
          end; // if BootWriteFlash
         end
         else begin
          StatusBar.Panels[PanelCmd].Text:='Ошибка записи сегмента BCORE!';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          AddLinesLog('Повторите операцию!');
          BootEnd; exit;
         end; // if BootWriteFlash
        end; // if CheckBoxNewBCORE.Checked
//-----------ReadFull
        if CheckBoxRdFF.Checked then begin
         ProgressBar.Position:=10;
         z:=33554432;
         if (BootInfo.bFlashSize>=$18) and (BootInfo.bFlashSize<=$1B) then begin
           z := 1 shl BootInfo.bFlashSize;
         end else addr:=$2000000;
         i:=(z*10) div integer(DCB.BaudRate);
         y:=i div 60;
         x:=i mod 60;
         AddLinesLog('Чтение FullFlash '+IntToStr(z shr 20)+'Mb ( '+IntToStr(y)+' мин. '+IntToStr(x)+' сек. )...');
         y:=$10000;//SizeOf(buf);
         sBlkFile := IniFile.ReadString('System','DirBackup','.\Backup');
         if not DirectoryExists(sblkFile) then begin
          sBlkFile := '.\Backup';
          if not CreateDir(sBlkFile) then sBlkFile := '.';
          IniFile.WriteString('System','DirBackup',sblkFile)
         end;
         if sblkFile[length(sblkFile)]<>'\' then sblkFile:=sblkFile+'\';
         sblkFile := sblkFile + IntToHex(eepESN,8) + '_FULLFLASH_'+ FormatDateTime('yymmddhhnnss',Now) + '.bin';
         hblkFile := FileCreate(sblkFile);
         if hblkFile <> INVALID_HANDLE_VALUE then begin
//          cntbterr:=0;
          addr:=$A0000000;
//          ProgressBar.Max:=256;
          ProgressBar.Position:=0;
//          SetComMinTime;
          while(addr<$A0000000+dword(z)) do begin
           StatusBar.Panels[PanelCmd].Text:='Чтение сегмента: '+IntToHex(addr,8);
//           StatusBar.Repaint;
           Repaint;
           Application.ProcessMessages;
           if NOT BootReadBlk(addr,y,buf) then begin
            FileClose(hblkFile);
            StatusBar.Panels[PanelCmd].Text:='Ошибка чтения в сегменте '+IntToHex(addr,8)+'!';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            BootEnd; exit;
           end;
//           b:=$2E; WriteCom(@b,1);
           if NOT FileWrite(hblkFile,buf,y) = y then begin
            FileClose(hblkFile);
            StatusBar.Panels[PanelCmd].Text:='Ошибка сохранения сегмента '+IntToHex(addr,8)+'!';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            BootEnd; exit;
           end // if NOT FileWrite
           else begin
            addr:=addr+dword(y);
            ProgressBar.Position:=(addr and $7FFFFFF)div (dword(z) div 100);
           end; // if NOT FileWrite
          end; // while(addr<$A2000000)
          FileClose(hblkFile);
//          hblkFile := INVALID_HANDLE_VALUE;
          ProgressBar.Position:=100;
          StatusBar.Panels[PanelCmd].Text:='ФуллФлэш сохранен в '+ ExtractFileName(sblkFile);
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
//          if cntbterr<>0 then AddLinesLog('Всего ошибок (перечитано!) '+IntToStr(cntbterr)+' штук.');
         end //if hblkFile <> INVALID_HANDLE_VALUE then begin
         else begin
          StatusBar.Panels[PanelCmd].Text:='Не открыть файл бэкапа '+ sblkFile+' !';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          BootEnd; exit;
         end; //if hblkFile <> INVALID_HANDLE_VALUE then begin
        end; // if CheckBoxRdFF.Checked
//------------Read OTP
        if CheckBoxRdOTP.Checked then begin
         if (BootInfo.wFlashID0=$0089)
         or (BootInfo.wFlashID0=$0001)
         or (BootInfo.wFlashID0=$0004)
         then begin
          ProgressBar.Position:=10;
          AddLinesLog('Чтение OTP блока Флэш...');
          sBlkFile := IniFile.ReadString('System','DirBackup','.\Backup');
          if not DirectoryExists(sblkFile) then begin
           sBlkFile := '.\Backup';
           if not CreateDir(sBlkFile) then sBlkFile := '.';
           IniFile.WriteString('System','DirBackup',sblkFile)
          end;
          if sblkFile[length(sblkFile)]<>'\' then sblkFile:=sblkFile+'\';
          sblkFile := sblkFile + IntToHex(eepESN,8) + '_OTP_'+ FormatDateTime('yymmddhhnnss',Now) + '.bin';
          hblkFile := FileCreate(sblkFile);
          if hblkFile <> INVALID_HANDLE_VALUE then begin
           addr:=$A0000000;
           y:=$200;
           if NOT BootReadOTP(addr,y,buf) then begin
             FileClose(hblkFile);
             StatusBar.Panels[PanelCmd].Text:='Ошибка чтения в блоке '+IntToHex(addr,8)+'!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             BootEnd; exit;
           end;
           ProgressBar.Position:=50;
 //           b:=$2E; WriteCom(@b,1);
           if NOT FileWrite(hblkFile,buf,y) = y then begin
            FileClose(hblkFile);
            StatusBar.Panels[PanelCmd].Text:='Ошибка сохранения блока '+IntToHex(addr,8)+'!';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            BootEnd; exit;
           end; // if NOT FileWrite
           FileClose(hblkFile);
 //          hblkFile := INVALID_HANDLE_VALUE;
           ProgressBar.Position:=100;
           StatusBar.Panels[PanelCmd].Text:='OTP блок сохранен в '+ ExtractFileName(sblkFile);
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          end //if hblkFile <> INVALID_HANDLE_VALUE then begin
          else begin
           StatusBar.Panels[PanelCmd].Text:='Не открыть файл бэкапа '+ sblkFile+' !';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           BootEnd; exit;
          end; //if hblkFile <> INVALID_HANDLE_VALUE then begin
         end
         else begin
          StatusBar.Panels[PanelCmd].Text:='Неизвестный тип флэш! ID: '+IntToHex(i,4);
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         end;
        end;  // if CheckBoxRdOTP.Checked
//------------Read CFI
        if CheckBoxRdCFI.Checked then begin
         if (BootInfo.wFlashID0=$0089)
         or (BootInfo.wFlashID0=$0001)
         or (BootInfo.wFlashID0=$0004)
         then begin
          ProgressBar.Position:=10;
          AddLinesLog('Чтение CFI блока Флэш...');
          sBlkFile := IniFile.ReadString('System','DirBackup','.\Backup');
          if not DirectoryExists(sblkFile) then begin
           sBlkFile := '.\Backup';
           if not CreateDir(sBlkFile) then sBlkFile := '.';
           IniFile.WriteString('System','DirBackup',sblkFile)
          end;
          if sblkFile[length(sblkFile)]<>'\' then sblkFile:=sblkFile+'\';
          sblkFile := sblkFile + IntToHex(eepESN,8) + '_CFI_'+ FormatDateTime('yymmddhhnnss',Now) + '.bin';
          hblkFile := FileCreate(sblkFile);
          if hblkFile <> INVALID_HANDLE_VALUE then begin
           addr:=$A0000000;
           y:=$200;
           if NOT BootReadCFI(addr,y,buf) then begin
             FileClose(hblkFile);
             StatusBar.Panels[PanelCmd].Text:='Ошибка чтения в блоке '+IntToHex(addr,8)+'!';
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             BootEnd; exit;
           end;
           ProgressBar.Position:=50;
 //           b:=$2E; WriteCom(@b,1);
           if NOT FileWrite(hblkFile,buf,y) = y then begin
            FileClose(hblkFile);
            StatusBar.Panels[PanelCmd].Text:='Ошибка сохранения блока '+IntToHex(addr,8)+'!';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            BootEnd; exit;
           end; // if NOT FileWrite
           FileClose(hblkFile);
 //          hblkFile := INVALID_HANDLE_VALUE;
           ProgressBar.Position:=100;
           StatusBar.Panels[PanelCmd].Text:='CFI блок сохранен в '+ ExtractFileName(sblkFile);
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          end //if hblkFile <> INVALID_HANDLE_VALUE then begin
          else begin
           StatusBar.Panels[PanelCmd].Text:='Не открыть файл бэкапа '+ sblkFile+' !';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           BootEnd; exit;
          end; //if hblkFile <> INVALID_HANDLE_VALUE then begin
         end
         else begin
          StatusBar.Panels[PanelCmd].Text:='Неизвестный тип флэш! ID: '+IntToHex(i,4);
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         end;
        end;  // if CheckBoxRdCFI.Checked
//----------Test
        if CheckBoxTest.Checked then begin
         StatusBar.Panels[PanelCmd].Text:='Очистка BCORE...';
         Repaint;
         ProgressBar.Position:=10;
         if BootEraseBlk($A0000000,seg_size) then begin
           AddLinesLog('Сегмент BCORE очищен.');
           ProgressBar.Position:=100;
         end // if BootEraseBlk($A0200000)
         else begin
           StatusBar.Panels[PanelCmd].Text:='Ошибка очистки сегмента BCORE!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           BootEnd; exit;
         end; // if BootEraseBlk($A0200000)

{           if BootGoto($21F0) then begin
            SetComMaxTime;
            if not ReadCom(@b,1) then begin
             AddLinesLog('Нет ответа старта!');
            end
            else AddLinesLog('Ответ: '+IntToHex(b,2));
//            b:=$55; WriteCom(@b,1);
            if not ReadCom(@b,1) then begin
             AddLinesLog('Нет ответа старта!');
            end
            else AddLinesLog('Ответ: '+IntToHex(b,2));
           end
           else begin
            StatusBar.Panels[PanelCmd].Text:='Ошибка запуска!';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            BootEnd; exit;
           end;
}
{
//           addr:=$00400000;
           addr:=$A8000000;
//           addr:=$FFFE0000;
           AddLinesLog('Чтение сегмента '+IntToHex(addr,8)+'...');
           s:=IntToHex(eepESN,8)+'_'+IntToHex(addr,8)+'_'+FormatDateTime('yymmddhhnnss',Now) + '.bin';
           if CreateSegBackup(addr,s,buf) then begin
            AddLinesLog('Сегмент '+IntToHex(addr,8)+' сохранен в '+ s);
           end
           else begin
            StatusBar.Panels[PanelCmd].Text:='Ошибка при бэкапе сегмента '+IntToHex(addr,8)+'!';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            BootEnd; exit;
           end;
}
        end;
//----------SaveInfo
        if CheckSaveInfo.Checked then begin
         StatusBar.Panels[PanelCmd].Text:='Сохранение блока Info...';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         ProgressBar.Position:=10;
         sBlkFile := IniFile.ReadString('System','DirBackup','.\Backup');
         if not DirectoryExists(sblkFile) then begin
          sBlkFile := '.\Backup';
          if not CreateDir(sBlkFile) then sBlkFile := '.';
          IniFile.WriteString('System','DirBackup',sblkFile)
         end;
         if sblkFile[length(sblkFile)]<>'\' then sblkFile:=sblkFile+'\';
         sblkFile := sblkFile + IntToHex(eepESN,8) + '_Info_'+ FormatDateTime('yymmddhhnnss',Now) + '.bin';
         hblkFile := FileCreate(sblkFile);
         if hblkFile <> INVALID_HANDLE_VALUE then begin
          ProgressBar.Position:=50;
 //           b:=$2E; WriteCom(@b,1);
          if NOT FileWrite(hblkFile,BootInfo.b,sizeof(BootInfo)) = sizeof(BootInfo) then begin
           FileClose(hblkFile);
           StatusBar.Panels[PanelCmd].Text:='Ошибка сохранения блока Info!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           BootEnd; exit;
          end; // if NOT FileWrite
          ProgressBar.Position:=100;
          StatusBar.Panels[PanelCmd].Text:='Блок Info сохранен в '+sblkFile;
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          FileClose(hblkFile);
         end;
        end;
//----------end
        BootEnd;
        if errflg then StatusBar.Panels[PanelCmd].Text:='Бут отключен. Есть недочеты!'
        else StatusBar.Panels[PanelCmd].Text:='Бут отключен. Всё слеплено.';
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        exit;
       end; // if TpInfoBoot(False)
      end //if Check
      else begin
       if TpInfoBoot(True) then begin
        if fBtImei or fBtoImei then begin
         IniFile.WriteString('Setup','IMEI',sIMEI);
         if (SpinEditHWID.Value<>HW_R65_ULYSSES_BOOTCORE)
         and (SpinEditHWID.Value<>HW_IDNONE) then
          IniFile.WriteInteger(sIMEI,'HWID',SpinEditHWID.Value);
         if fBtHASH then
          IniFile.WriteString(sIMEI,'HASH',BufToHexStr(@HASH,16));
         if fBtEsn then
          IniFile.WriteString(sIMEI,'ESN',IntToHex(eepESN,8));
        end;
       end;
      end; // if Check
      BootEnd;
      StatusBar.Panels[PanelCmd].Text:='Бут отключен.';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      exit;
end;

procedure TFormMain.CheckBoxNew5121Click(Sender: TObject);
begin
  if CheckBoxNew5121.Checked then CheckBoxClrEEFULL.Checked := False
  else CheckBoxReCalkFull.Checked := False;
end;

procedure TFormMain.CheckBoxClrEEFULLClick(Sender: TObject);
begin
  if CheckBoxClrEEFULL.Checked then begin
   CheckBoxNew5121.Checked := False;
   CheckBoxFreia.Checked := False;
   CheckBoxReCalkFull.Checked := False;
  end;
end;

procedure TFormMain.CheckBoxSetVDownClick(Sender: TObject);
begin
  if CheckBoxSetVDown.Checked then begin
   CheckBoxClrBcor.Checked := False;
   CheckBoxNewBcore.Checked := False;
  end;
end;

procedure TFormMain.CheckBoxClrBcorClick(Sender: TObject);
begin
  if CheckBoxClrBcor.Checked then begin
   CheckBoxSetVDown.Checked := False;
   CheckBoxReCalkFull.Checked := False;
   CheckBoxNewBcore.Checked := False;
  end
end;

procedure TFormMain.CheckBoxFreiaClick(Sender: TObject);
begin
    if CheckBoxFreia.Checked then begin
     CheckBoxClrEEFULL.Checked:=False;
     CheckBoxClrEELITE.Checked:=False;
    end
    else CheckBoxReCalkFull.Checked := False;
end;

procedure TFormMain.CheckBoxClrEELITEClick(Sender: TObject);
begin
  if CheckBoxClrEELITE.Checked then begin
   CheckBoxFreia.Checked := False;
   CheckBoxReCalkFull.Checked := False;
  end;
end;

procedure TFormMain.CheckBoxReCalkFullClick(Sender: TObject);
begin
    if CheckBoxReCalkFull.Checked then begin
     CheckBoxClrEEFULL.Checked:=False;
     CheckBoxClrEELITE.Checked:=False;
     CheckBoxFreia.Checked:=True;
     CheckBoxNew5121.Checked:=True;
     CheckBoxClrBcor.Checked:=False;
    end;
end;

procedure TFormMain.CheckBoxTestBusClick(Sender: TObject);
begin
    if not CheckBoxTestBus.Checked then begin
     CheckBoxTstRam.Checked:=False;
    end;
end;

procedure TFormMain.CheckBoxTstRamClick(Sender: TObject);
begin
    if CheckBoxTstRam.Checked then begin
     CheckBoxTestBus.Checked:=True;
    end;
end;


procedure TFormMain.CheckBoxNewBcoreClick(Sender: TObject);
begin
    if CheckBoxNewBcore.Checked then begin
     CheckBoxClrBcor.Checked:=False;
     CheckBoxSetVDown.Checked:=False;
    end;
end;

procedure TFormMain.CheckBoxRdFFClick(Sender: TObject);
begin
    if CheckBoxRdFF.Checked then begin
     if RadioGroupSpeed.ItemIndex < 5 then begin
      AddLinesLog('Внимание! С такой скоростью это не делают!');
     end;
    end;
end;

procedure TFormMain.Timer500Timer(Sender: TObject);
Var
b : byte;
begin
   if hCom<>INVALID_HANDLE_VALUE then begin
    if not WatchDog then begin
     WatchDog:=True;
     b:=$2E; WriteCom(@b,1);
     inc(WatchDogCount);
     WatchDog:=False;
    end
    else AddLinesLog('#');
    Timer500.Interval:=200;
   end
   else Timer500.Enabled:=False;
end;

procedure TFormMain.ButtonTestClick(Sender: TObject);
var
//EEP5008 : array[0..223] of byte;
//EEP5077 : array[0..231] of byte;
//EEP5009 : array[0..9] of byte;
//EEP76 : array[0..9] of byte;
len : integer;
ver : byte;
xESN : dword;
begin
      ProgressBar.Position:=10;
      IMEI2xBCD(sIMEI);
      xESN:=StrToInt('$'+EditESN.Text);
      AddLinesLog('Тестовый проcмотр блоков 76,5008,5009,5077. (Для вумных!)');
      if ComOpen then begin
       BFC_SecurityMode;
       if BFC_Error<>ERR_NO then AddLinesLog('Нет ответа на запрос статуса режима!')
       else begin
        if (bSecyrMode=$12) or (bSecyrMode=$13) then begin
         StatusBar.Panels[PanelCmd].Text:='Чтение блока 5008...';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         if BFC_EE_Get_Block_Info(5008,dword(len),ver) then begin
          AddLinesLog('Размер: '+IntToStr(len)+', Версия: '+IntToStr(ver));
          if (len=224) and BFC_EE_Read_Block(5008,0,224,EEP5008) then begin
//           AddLinesLog(BufToHexStr(@EEP5008,len));
           DeCrypt5008blk(xESN,EEP5008);
           AddLinesLog(BufToHex_Str(@EEP5008,8));
           AddLinesLog(BufToHex_Str(@EEP5008[8],24));
           AddLinesLog(BufToHex_Str(@EEP5008[32],8));
           AddLinesLog(BufToHex_Str(@EEP5008[40],176));
           AddLinesLog(BufToHex_Str(@EEP5008[216],8));
           ProgressBar.Position:=20;
          end;
         end;
         StatusBar.Panels[PanelCmd].Text:='Чтение блока 5077...';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         if BFC_EE_Get_Block_Info(5077,dword(len),ver) then begin
          AddLinesLog('Размер: '+IntToStr(len)+', Версия: '+IntToStr(ver));
          ProgressBar.Position:=75;
          if (len=232) and BFC_EE_Read_Block(5077,0,232,EEP5077) then begin
//           AddLinesLog(BufToHexStr(@EEP5077,len));
//           AddLinesLog('ESN: '+intToHex(xESN,8));
           DeCrypt5077blk(xESN,EEP5077);
           AddLinesLog(BufToHex_Str(@EEP5077,8));
           AddLinesLog(BufToHex_Str(@EEP5077[8],216));
           AddLinesLog(BufToHex_Str(@EEP5077[224],8));
           ProgressBar.Position:=30;
          end;
         end;
         StatusBar.Panels[PanelCmd].Text:='Чтение блока 5009...';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         if BFC_EE_Get_Block_Info(5009,dword(len),ver) then begin
          AddLinesLog('Размер: '+IntToStr(len)+', Версия: '+IntToStr(ver));
          if (len=10) and BFC_EE_Read_Block(5009,0,10,EEP5009) then begin
//           AddLinesLog(BufToHexStr(@EEP5009,len));
           Decode5009(EEP5009,C55);
           AddLinesLog(BufToHexStr(@EEP5009,len));
           ProgressBar.Position:=40;
          end;
         end;

         StatusBar.Panels[PanelCmd].Text:='Чтение блока 76...';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         if BFC_EE_Get_Block_Info(76,dword(len),ver) then begin
          AddLinesLog('Размер: '+IntToStr(len)+', Версия: '+IntToStr(ver));
          if (len=10) and BFC_EE_Read_Block(76,0,10,EEP0076) then begin
//           AddLinesLog(BufToHexStr(@EEP0076,len));
           Decode76(EEP0076,C55);
           AddLinesLog(BufToHexStr(@EEP0076,len));
           ProgressBar.Position:=100;
          end;
         end;
        StatusBar.Panels[PanelCmd].Text:='Блоки OK?';
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        end; // if (bSecyrMode=$12)
       end;
      end;
      ComClose;
end;

procedure TFormMain.ButtonRdContrastClick(Sender: TObject);
var
EEP5007 : array[0..3] of byte;
len : dword;
ver : byte;
begin
   ProgressBar.Position:=10;
   if ComOpen then begin
    ProgressBar.Position:=40;
    if BFC_EE_Get_Block_Info(5007,len,ver) then begin
     if (len<sizeof(EEP5007)) or (ver<>0) then begin
      ComClose;
      StatusBar.Panels[PanelCmd].Text:='Неверный блок 5007!';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      exit;
     end;
     if (len>sizeof(EEP5007)) then AddLinesLog('Неизвестный тип блока 5007 - длина '+IntToStr(len)+' байт.');
     ProgressBar.Position:=80;
     if BFC_EE_Read_Block(5007,0,sizeof(EEP5007),EEP5007) then begin
      ComClose;
      SpinEditContrast.Value:=EEP5007[0];
      SpinEditVrefContrast.Value:=EEP5007[1];
      AddLinesLog('EEP5007: '+BufToHex_Str(@EEP5007,sizeof(EEP5007)));
      StatusBar.Panels[PanelCmd].Text:='Блок "Контраста" считан успешно.';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      ProgressBar.Position:=100;
      exit;
     end
     else begin
      ComClose;
      StatusBar.Panels[PanelCmd].Text:='Ошибка чтения блока 5007!';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      exit;
     end;
    end // if BFC_EE_Get_Block_Info(
    else begin
     ComClose;
     StatusBar.Panels[PanelCmd].Text:='В телефоне нет блока 5007!';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
    end; // if BFC_EE_Get_Block_Info(
   ComClose;
   end; // if ComOpen
end;

procedure TFormMain.ButtonWrContrastClick(Sender: TObject);
var
EEP5007 : array[0..3] of byte;
//ver,len : dword;
begin
//   if SooWarning then exit;
   EEP5007[0]:=SpinEditContrast.Value;
   EEP5007[1]:=SpinEditVrefContrast.Value;
   EEP5007[2]:=$FF;
   EEP5007[3]:=$FF;
   AddLinesLog('EEP5007: '+BufToHex_Str(@EEP5007,sizeof(EEP5007)));
   if ComOpen then begin
    WriteEepBlock(5007,sizeof(EEP5007),0,EEP5007);
    ComClose;
   end; // if ComOpen
end;

procedure TFormMain.ButtonSetContrastClick(Sender: TObject);
var
b : byte;
begin
//   if SooWarning then exit;
   b := SpinEditContrast.Value;
   if ComOpen then begin
    if BFC_SetDisplayContrast(1,b) then begin
     StatusBar.Panels[PanelCmd].Text:='Контраст установлен в '+IntToStr(b)+' единиц.';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    end
    else begin
     StatusBar.Panels[PanelCmd].Text:='Ошибка установки контраста!';
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    end;
    ComClose;
   end;
end;

//     {0x8F, 0x1D, 0x74, 0xF4, 0x71, 0x8A, 0x0E, 0x35},   // A50/C55
//      $F4741D8F  $350E8A71

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


procedure TFormMain.Button5008Click(Sender: TObject);
var
//EEP5008 : array[0..223] of byte;
len : integer;
b, ver : byte;
xESN : dword;
s,op1,op2 : string;
i : integer;
xflg : integer;
begin
      ProgressBar.Position:=10;
      xflg:=0;
      if ComOpen then begin
       s:=BFC_GetIMEI;
       if BFC_Error=ERR_NO then begin
        EditIMEI.Text:=s;
        sIMEI:=s;
       end
       else begin
        StatusBar.Panels[PanelCmd].Text:='Не прочитать IMEI!';
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        ComClose; exit;
       end;
       AddLinesLog('IMEI: '+sIMEI);
       IMEI2xBCD(sIMEI);
       BFC_SecurityMode;
       ProgressBar.Position:=17;
       if BFC_Error<>ERR_NO then AddLinesLog('Нет ответа на запрос статуса режима!')
       else begin
        if (bSecyrMode=$12) or (bSecyrMode=$13) then begin
         if not BFC_GetESN(xESN) then begin
          StatusBar.Panels[PanelCmd].Text:='Не прочитать ESN!';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          ComClose; exit;
         end;
         EditESN.Text:=IntToHex(xESN,8);
         AddLinesLog('ESN: '+IntToHex(xESN,8));
         ProgressBar.Position:=24;
         StatusBar.Panels[PanelCmd].Text:='Чтение блока 5008...';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         if BFC_EE_Get_Block_Info(5008,dword(len),ver) then begin
          ProgressBar.Position:=30;
          if (len=224) then begin
           if BFC_EE_Read_Block(5008,0,224,EEP5008) then begin
            DeCrypt5008blk(xESN,EEP5008);
            if word((@EEP5008[30])^)<>tCRCBuffer(EEP5008[8],22) then begin
             StatusBar.Panels[PanelCmd].Text:='Неверный блок 5008! CRC1: '+IntToHex(tCRCBuffer(EEP5008[8],22),4)+'<>'+IntToHex(word((@EEP5008[30])^),4);
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             ComClose;
             exit;
            end;
            if word((@EEP5008[216])^)<>tCRCBuffer(EEP5008[40],176) then begin
             StatusBar.Panels[PanelCmd].Text:='Неверный блок 5008! CRC2: '+IntToHex(tCRCBuffer(EEP5008[40],176),4)+'<>'+IntToHex(word((@EEP5008[216])^),4);
             AddLinesLog(StatusBar.Panels[PanelCmd].Text);
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
             AddLinesLog('Оператор1: '+op1);
             AddLinesLog('Оператор2: '+op2);
            end;

            if (EEP5008[10]<>0) then begin // NETWORK LOCK (*#0000*)
             xflg:=xflg or 1;
             AddLinesLog('Network Lock (*#0000*):');
             if (EEP5008[43] and $0F)<>$0F then AddLinesLog('Оператор1: '+op1);
             if (EEP5008[49] and $0F)<>$0F then AddLinesLog('Оператор2: '+op2);
             Case (EEP5008[11] and 3) of
//              00: AddLinesLog('Есть три попытки ввода пароля.');
              01: AddLinesLog('Осталось две попытки ввода пароля.');
              02: AddLinesLog('Осталось одна попытка ввода пароля.');
              03: AddLinesLog('Пароль блокирован: Три неверных попытки ввода.');
             end;
             b:= EEP5008[11] shr 2;
             Case b of
              00 : AddLinesLog('Мастер код не вводили.');
              63 : AddLinesLog('Мастер код блокирован!');
              else AddLinesLog('Неверных попыток ввода мастер кода: '+IntToStr(b)+'.');
             end;
            end;

            if (EEP5008[15]<>0) then begin // Service Provider Lock (SP Lock) (*#0001*)
             xflg:=xflg or 2;
             AddLinesLog('Service Provider Lock (*#0001*):');
             if (EEP5008[43] and $0F)<>$0F then AddLinesLog('Оператор1: '+op1);
             if (EEP5008[49] and $0F)<>$0F then AddLinesLog('Оператор2: '+op2);
             Case (EEP5008[16] and 3) of
//              00: AddLinesLog('Есть три попытки ввода пароля.');
              01: AddLinesLog('Осталось две попытки ввода пароля.');
              02: AddLinesLog('Осталось одна попытка ввода пароля.');
              03: AddLinesLog('Пароль блокирован: Три неверных попытки ввода.');
             end;
             b:= EEP5008[16] shr 2;
             Case b of
              00 : AddLinesLog('Мастер код не вводили.');
              63 : AddLinesLog('Мастер код блокирован!');
              else AddLinesLog('Неверных попыток ввода мастер кода: '+IntToStr(b)+'.');
             end;
            end;

            if (EEP5008[17]<>0)  then begin // CORPORATE LOCK (*#0002*)
             xflg:=xflg or 4;
             AddLinesLog('Corporate Lock (*#0002*):');
             Case (EEP5008[18] and 3) of
//              00: AddLinesLog('Есть три попытки ввода пароля.');
              01: AddLinesLog('Осталось две попытки ввода пароля.');
              02: AddLinesLog('Осталось одна попытка ввода пароля.');
              03: AddLinesLog('Пароль блокирован: Три неверных попытки ввода.');
             end;
             b:= EEP5008[18] shr 2;
             Case b of
              00 : AddLinesLog('Мастер код не вводили.');
              63 : AddLinesLog('Мастер код блокирован!');
              else AddLinesLog('Неверных попыток ввода мастер кода: '+IntToStr(b)+'.');
             end;
            end;

            if (EEP5008[12]<>0) then begin // SUBSET LOCK (*#0004*)
             xflg:=xflg or 8;
             AddLinesLog('Subset Lock (*#0004*):');
             if (EEP5008[43] and $0F)<>$0F then AddLinesLog('Оператор1: '+op1);
             if (EEP5008[49] and $0F)<>$0F then AddLinesLog('Оператор2: '+op2);
             Case (EEP5008[13] and 3) of
//              00: AddLinesLog('Есть три попытки ввода пароля.');
              01: AddLinesLog('Осталось две попытки ввода пароля.');
              02: AddLinesLog('Осталось одна попытка ввода пароля.');
              03: AddLinesLog('Пароль блокирован: Три неверных попытки ввода.');
             end;
             b:= EEP5008[13] shr 2;
             Case b of
              00 : AddLinesLog('Мастер код не вводили.');
              63 : AddLinesLog('Мастер код блокирован!');
              else AddLinesLog('Неверных попыток ввода мастер кода: '+IntToStr(b)+'.');
             end;
            end;

            if (EEP5008[8]<>0)  then begin  // ONLY SIM (*#0005*)
             xflg:=xflg or $10;
             AddLinesLog('Only Sim Lock (*#0005*):');
             AddLinesLog('SIM CARD ID: '+BufToHexStr(@EEP5008[8+24+8],3));
             Case (EEP5008[9] and 3) of
//              00: AddLinesLog('Есть три попытки ввода пароля.');
              01: AddLinesLog('Осталось две попытки ввода пароля.');
              02: AddLinesLog('Осталось одна попытка ввода пароля.');
              03: AddLinesLog('Пароль блокирован: Три неверных попытки ввода.');
             end;
             b:= EEP5008[9] shr 2;
             Case b of
              00 : AddLinesLog('Мастер код не вводили.');
              63 : AddLinesLog('Мастер код блокирован!');
              else AddLinesLog('Неверных попыток ввода мастер кода: '+IntToStr(b)+'.');
             end;
            end;

            if (EEP5008[22] and $0F)=$0F then begin
             AddLinesLog('"Телефонный код" не введен.');
            end
            else begin
             s:='';
             for i:=22 to 25 do begin
              if (EEP5008[i] and $0F)=$0F then break;
               s:=s+Char((EEP5008[i] and $0F)+$30);
              if (EEP5008[i] and $F0)=$F0 then break;
              s:=s+Char((EEP5008[i] shr 4) +$30);
             end;
             AddLinesLog('"Телефонный код": '+s);
             xflg:=xflg or $80;
             Case (EEP5008[19] and 3) of
              00: AddLinesLog('Есть три попытки ввода "Телефонного кода".');
              01: AddLinesLog('Осталось две попытки ввода "Телефонного кода".');
              02: AddLinesLog('Осталось одна попытка ввода "Телефонного кода".');
              03: AddLinesLog('"Телефонный код" блокирован: Три неверных попытки ввода.');
             end;
            end;
            if EEP5008[19]<>0 then xflg:=xflg or $80;
            if EEP5008[20] <> $FF then begin
             xflg:=xflg or $20;
             if (EEP5008[20] and 1)=0 then AddLinesLog('Включена опция "Только эта СИМ". SIM CARD ID:'+BufToHexStr(@EEP5008[8+24+8],3));
             if (EEP5008[20] and 4)=0 then AddLinesLog('Включена опция "Только последние 10 набранных номеров"');
             if (EEP5008[20] and $FA)<>$FA then AddLinesLog('Включены неизвестные опции блокировки!');
            end;
            if (xflg<>0)
            or (Dword((@EEP5008[8])^)<>$00000300)
            or (Dword((@EEP5008[12])^)<>$00670000)
            or (Dword((@EEP5008[16])^)<>$00000000)
            or (EEP5008[20]<>$FF)
            or (Not((EEP5008[21]=$FF) or (EEP5008[21]=$00)))
            or (Word((@EEP5008[22])^)<>$FFFF)
            or (Dword((@EEP5008[24])^)<>$FFFFFFFF)
            or (Word((@EEP5008[28])^)<>$FF00)
            then begin
             if (xflg=0) then AddLinesLog('Неверные данные в блоке!');
             if MessageDlg('Сбросить пароль и локи?', mtConfirmation, [mbYes, mbNo], 0) = mrYes
             then begin
              Dword((@EEP5008[8])^):=$00000300;
              Dword((@EEP5008[12])^):=$00670000;
              Dword((@EEP5008[16])^):=$00000000;
              Dword((@EEP5008[20])^):=$FFFFFFFF;
              Dword((@EEP5008[24])^):=$FFFFFFFF;
              word((@EEP5008[28])^):=$FF00;
              CRCBuffer(EEP5008[8],22);
              Crypt5008blk(xESN,EEP5008);
              if WriteEepBlock(5008,sizeof(EEP5008),0,EEP5008) then
               ProgressBar.Position:=100;
             end
             else ProgressBar.Position:=100;
            end else begin
             AddLinesLog('Блокировок нет.');
             ProgressBar.Position:=100; // if (локи)
            end;
           end // if BFC_EE_Read_Block
           else begin
            StatusBar.Panels[PanelCmd].Text:='Не прочитать блок 5008!';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           end;
          end // if len<>224
          else begin
//          AddLinesLog('len = '+IntToStr(len));
           StatusBar.Panels[PanelCmd].Text:='('+IntToStr(len)+'<>224) Неверная длина блока 5008!';
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          end;
         end // if BFC_EE_Get_Block_Info
         else begin
          StatusBar.Panels[PanelCmd].Text:='Нет блока 5008!';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         end; // if BFC_EE_Read_Block
        end // if (bSecyrMode=$12)
        else begin
//          AddLinesLog('Тест "Open BFC mode"...');
          StatusBar.Panels[PanelCmd].Text:='Сначала введи SKEY!';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        end; // if (bSecyrMode=$12)
       end; // BFC_error
      end; // if ComOpen
      ComClose;
end;

procedure TFormMain.EditFreezeIMEIChange(Sender: TObject);
var
i : integer;
sText : string;
c : char;
begin
  sText:=EditFreezeIMEI.Text;
  i:=length(sText);
  if (i>=15) then begin
   if CalkImei15(sText,c) then begin
    setlength(sText,14);
    EditFreezeIMEI.Text:=sText+c;
   end;
  end;
end;

procedure TFormMain.ButtonCalkESNClick(Sender: TObject);
var
xESN : Dword;
begin
  ProgressBar.Position:=10;
  if length(EditIMEI.Text)=15 then sIMEI:=EditIMEI.Text
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод IMEI';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
  end;
  if length(EditSkey.Text)<>0 then Skey:=StrToInt(EditSkey.Text)
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод SKEY!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
{  if length(EditESN.Text)=8 then xESN:=StrToInt('$'+EditESN.Text)
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод ESN!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end; }
  if length(EditHash.Text)=32 then HexTopByte(@EditHash.Text[1],16,@HASH)
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод HASH!';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  ButtonCalkESN.Enabled:=False;
  StatusBar.Panels[PanelCmd].Text:='Расчет ESN из HASH и SKEY...';
  AddLinesLog(StatusBar.Panels[PanelCmd].Text);
  AddLinesLog('Полный перебор выполняется в 43 раза дольше чем Расчет SKEY!');
  Repaint;
  xESN:=$FFFFFFFF;
  if CalkESN(Skey,xESN) then begin
      AddLinesLog('ESN рассчитан успешно:');
      EditSkey.Text:=IntToStr(SKey);
      EditESN.Text:=IntToHex(xESN,8);
      EditBootKey.Text:=BufToHexStr(@BootKey,16);
      IniFile.WriteString('Setup','IMEI',sIMEI);
      IniFile.WriteInteger(sIMEI,'SKEY',Skey);
      IniFile.WriteString(sIMEI,'BKEY',EditBootKey.Text);
      IniFile.WriteString(sIMEI,'HASH',EditHASH.Text);
      IniFile.WriteString(sIMEI,'ESN',EditESN.Text);
      StatusBar.Panels[PanelCmd].Text:='ESN: '+IntToHex(xESN,8);
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
  end
  else begin
      StatusBar.Panels[PanelCmd].Text:='ESN не найден!';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
  end;
  ButtonCalkESN.Enabled:=True;
end;

procedure TFormMain.ButtonCalkMkeyClick(Sender: TObject);
var
Mkeys: array[0..5] of dword;
i,x,y : dword;
sText : string;
c : char;
label cmk_exit1;
label cmk_exit2;
//CmpBuf: array[0..] of byte;
begin
     ButtonCalkMkey.Enabled:=False;
     ProgressBar.Position:=10;
     AddLinesLog('Чтение блока 5121...');
     if ComOpen then begin
      ProgressBar.Position:=20;
      BFC_SecurityMode;
      if BFC_Error<>ERR_NO then begin
       StatusBar.Panels[PanelCmd].Text:='Нет ответа на запрос статуса режима!';
//       AddLinesLog(StatusBar.Panels[PanelCmd].Text);
       goto cmk_exit1;
      end;
      if Not((bSecyrMode=$12) or (bSecyrMode = $13)) then begin
       StatusBar.Panels[PanelCmd].Text:='Возможно только при "Factory" Статусе Защиты!';
       AddLinesLog(StatusBar.Panels[PanelCmd].Text);
       AddLinesLog('Введите SKEY в телефон!');
       goto cmk_exit2;
      end;
      ProgressBar.Position:=30;
      if not BFC_GetEsn(eepESN) then begin
       StatusBar.Panels[PanelCmd].Text:='Нет ответа на запрос OTP ESN!';
       goto cmk_exit1;
      end;
      AddLinesLog('OTP ESN: '+IntToHex(eepESN,8));
      ProgressBar.Position:=40;
      i:=8;
      if not BFC_ReadOtpBlk(0,0,i) then begin
       StatusBar.Panels[PanelCmd].Text:='Не читается OTP IMEI!';
       AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      end
      else begin
       SetLength(sText,14);
       for i:=2 to 16 do begin
        if (i and 1)=0 then Byte(sText[i-1]):=$30+(ibfc.cd.pb[i shr 1] and $0f)
        else Byte(sText[i-1]):=$30+((ibfc.cd.pb[i shr 1] and $f0) shr 4);
       end;
       if CalkImei15(sText,c) then begin
        sText:=sText+c;
        StatusBar.Panels[PanelCmd].Text:='OTP IMEI: '+sText;
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        EditIMEI.Text:=sText;
        sIMEI:=sText;
        if sIMEI<>sText then begin
//         EditIMEI.Text:=sText;
         StatusBar.Panels[PanelCmd].Text:='IMEI не соответствует данным OTP!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         AddLinesLog('Берем OTP IMEI!');
//        ComClose; exit;
        end;
       end
       else begin
        StatusBar.Panels[PanelCmd].Text:='OTP IMEI неверен!';
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
       end;
      end; // if not BFC_ReadOtpBlk
      ProgressBar.Position:=50;
//EEP5121
      if not ReadEepBlock(5121,SizeOf(EEP5121),Byte(c),EEP5121) then begin
       goto cmk_exit2;
      end;
     end // if ComOpen
     else  goto cmk_exit2;
////
     ProgressBar.Position:=0;
     AddLinesLog('Подбор "Мастер кодов".');
     AddLinesLog('Телефон можно отключить!');
//test     Create512x(sIMEI,StrToInt('$'+EditESN.Text),Skey,Mkey);
     for i:=0 to 5 do begin
      Mkeys[i]:=$FFFFFFFF;
      StartCalk5121mkeys(sIMEI,eepESN,MKey[i]);
      StepCalk5121mkeys(@EEP5121[8],Mkeys);
     end;
     StartCalk5121mkeys(sIMEI,eepESN,12345678);
     StepCalk5121mkeys(@EEP5121[8],Mkeys);
     StartCalk5121mkeys(sIMEI,eepESN,0);
     StepCalk5121mkeys(@EEP5121[8],Mkeys);
     i:=0;
     x:=0;
     y:=0;
     StatusBar.Panels[PanelCmd].Text:='Поиск: фаза до 9999999 (макс.99999999)';
     Repaint;
     while not StepCalk5121mkeys(@EEP5121[8],Mkeys) do
     begin
      inc(i);
      if i>=100000 then begin
       inc(x);
       ProgressBar.Position:=x;
       if x >=100 then begin
        x:=0;
        inc(y);
        StatusBar.Panels[PanelCmd].Text:='Поиск: до '+IntToStr(y)+'9999999 (макс.99999999)';
       end;
       Application.ProcessMessages;
       i:=0;
      end;
     end;
//      for i:=0 to 5 do Mkeys[i]:=$FFFFFFFF;
     if Mkeys[0]<>$FFFFFFFF then
      AddLinesLog('*#0000*'+Int2Digs(Mkeys[0],8)+'# - Блокировка Сети.')
     else
      AddLinesLog('*#0000*????????# - Блокировка Сети?');
     if Mkeys[1]<>$FFFFFFFF then
      AddLinesLog('*#0001*'+Int2Digs(Mkeys[1],8)+'# - Блокировка Поставщика услуг?')
     else
      AddLinesLog('*#0001*????????# - Блокировка Поставщика услуг?');
     if Mkeys[2]<>$FFFFFFFF then
      AddLinesLog('*#0002*'+Int2Digs(Mkeys[2],8)+'# - Персонализация Поставщика услуг?')
     else
      AddLinesLog('*#0002*????????# - Персонализация Поставщика услуг?');
     if Mkeys[3]<>$FFFFFFFF then
      AddLinesLog('*#0003*'+Int2Digs(Mkeys[3],8)+'# - Телефонный Код?')
     else
      AddLinesLog('*#0003*????????# - Телефонный Код?');
     if Mkeys[4]<>$FFFFFFFF then
      AddLinesLog('*#0004*'+Int2Digs(Mkeys[4],8)+'# - Блокировка Абонентского аппарата Сети?')
     else
      AddLinesLog('*#0004*????????# - Блокировка Абонентского аппарата Сети?');
     if Mkeys[5]<>$FFFFFFFF then
      AddLinesLog('*#0005*'+Int2Digs(Mkeys[5],8)+'# - Только Сим?')
     else
      AddLinesLog('*#0005*????????# - Только Сим?');
//     end;
     for i:=0 to 5 do IniFile.WriteInteger(sIMEI,'Mkey'+IntToStr(i),Mkeys[i]);
      ProgressBar.Position:=100;
      StatusBar.Panels[PanelCmd].Text:='Расчет закончен.';
cmk_exit1:
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
cmk_exit2:
      ButtonCalkMkey.Enabled:=True;
      ComClose;
end;

procedure TFormMain.Label26Click(Sender: TObject);
begin
   ShellExecute(Application.Handle, 'open',
               PChar('http://papuas.allsiemens.com'),
               nil, '', SW_SHOWNORMAL);
end;


procedure TFormMain.ButtonBlk71Click(Sender: TObject);
var
EEP0071 : array[0..255] of byte;
len : dword;
ver : byte;
s : string;
i,l,x,y,z : integer;
flgCh : boolean;
begin
      ProgressBar.Position:=10;
      flgCh:=False;
      AddLinesLog('Отключение "Подтверждения Включения" и добавление меню "Диапазон"');
      if ComOpen then begin
       ProgressBar.Position:=20;
       if BFC_EE_Get_Block_Info(71,len,ver) then begin
        ProgressBar.Position:=50;
        if (len>=200) and (len<256) and (ver=0) then begin
         if BFC_EE_Read_Block(71,0,len,EEP0071) then begin
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
//            Button0071.Enabled:=True;
//            PanelMain.Enabled:=True;
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
           EEP0071[4]:=$3F;
           x:=7;
          end;
          if ((EEP0071[x] and $01)<>0) // ¦хэ¦ "-шрярчюэ"
          then begin
           EEP0071[x]:=EEP0071[x] and $FE; // ¦хэ¦ "-шрярчюэ"
//           AddLinesLog('Band selection menu add - Ok.');
           EEP0071[x+6]:=EEP0071[x+6] xor $10; //and $EF; // "¦юфЄтхЁцфхэшх тъы¦ўхэш "
//           AddLinesLog('Disable aircraft check - Ok.');
           flgCh:=True;
          end;
          if flgCh then begin
           if WriteEepBlock(71,len,ver,EEP0071) then begin
            AddLinesLog('Меню "Диапазон" добавлено.');
            AddLinesLog('Подтверждение включения отключено.');
            StatusBar.Panels[PanelCmd].Text:='Блок 71 модифицирован.';
            ProgressBar.Position:=100;
           end;
          end
          else begin
           StatusBar.Panels[PanelCmd].Text:='Блок 71 уже модифицирован!';
          end;
         end
         else begin
          StatusBar.Panels[PanelCmd].Text:='Ошибка чтения данных блока 71!';
         end;
        end
        else begin
         StatusBar.Panels[PanelCmd].Text:='Неверный блок 71!';
        end;
       end //if BFC_EE_Get_Block_Info
       else begin
        if BFC_Error=ERR_EEP_NONE then
         StatusBar.Panels[PanelCmd].Text:='В телефоне нету блока 71!'
        else
         StatusBar.Panels[PanelCmd].Text:='Ошибка чтения инфы о блоке 71!';
       end;
       AddLinesLog(StatusBar.Panels[PanelCmd].Text);
       ComClose;
      end; //if ComOpen
end;

{
procedure TFormMain.ButtonBlk71Click(Sender: TObject);
var
EEP0071 : array[0..199] of byte;
len : dword;
ver : byte;
begin
      ProgressBar.Position:=10;
      AddLinesLog('Отключение "Подтверждения Включения" и добавление меню "Диапазон"');
      if ComOpen then begin
       ProgressBar.Position:=20;
       if BFC_EE_Get_Block_Info(71,len,ver) then begin
        ProgressBar.Position:=50;
        if (len=200) and (ver=0) then begin
         if BFC_EE_Read_Block(71,0,len,EEP0071) then begin
          if ((EEP0071[$3D] and $01)<>0)
          or ((EEP0071[$43] and $10)<>0)
          then begin
           EEP0071[$3D]:=EEP0071[$3D] and $FE;
           EEP0071[$43]:=EEP0071[$43] and $EF;
           if WriteEepBlock(71,len,ver,EEP0071) then begin
            AddLinesLog('Подтверждение включения отключено.');
            AddLinesLog('Меню "Диапазон" добавлено.');
            StatusBar.Panels[PanelCmd].Text:='Блок 71 модифицирован.';
            ProgressBar.Position:=100;
           end;
          end
          else begin
           StatusBar.Panels[PanelCmd].Text:='Блок 71 уже модифицирован!';
          end;
         end
         else begin
          StatusBar.Panels[PanelCmd].Text:='Ошибка чтения данных блока 71!';
         end;
        end
        else begin
         StatusBar.Panels[PanelCmd].Text:='Неверный блок 71!';
        end;
       end //if BFC_EE_Get_Block_Info
       else begin
         if BFC_Error=ERR_EEP_NONE then
          StatusBar.Panels[PanelCmd].Text:='В телефоне нету блока 71!'
         else
          StatusBar.Panels[PanelCmd].Text:='Ошибка чтения инфы о блоке 71!';
       end;
       AddLinesLog(StatusBar.Panels[PanelCmd].Text);
       ComClose;
      end; //if ComOpen
end;
}
procedure TFormMain.Button1Click(Sender: TObject);
const
b5121 = $00000001;
b5122 = $00000002;
b5123 = $00000004;
b5007 = $00000008;
b5008 = $00000010;
b5077 = $00000020;
b0076 = $00000040;
b0052 = $00000080;
var
HWiD : word;
//num, idx : dword;
begin
       with OpenDialog do begin
        FilterIndex:=1;
        InitialDir := '.';
        DefaultExt := 'eep';
        Filter := 'Eep (*.eep)|*.eep|All files (*.*)|*.*';
        Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
        Title:='Выбор файла epp для записи в телефон';
       end;//with OpenDialog
       if OpenDialog.execute then begin
         if not OpenEEPfile(OpenDialog.FileName,HWiD)
         then begin
          StatusBar.Panels[PanelCmd].Text:=sEep_Err;
          AddLinesLog(sEep_Err);
          exit;
         end;
         SpinEditHWID.Value:=HWiD;
         StatusBar.Panels[PanelCmd].Text:='Файл содержит '+IntToStr(idx_eeptab)+' EEP блоков.';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
//         if not GetIndexEepTab(5121, idx) then
//           AddLinesLog('Отсуствие блока 5121!');
       end
       else exit;
end;

function TFormMain.ReadAllEEPBFC : boolean;
var
eelite_max,eefull_max : dword;
i : dword;
x : integer;
freeb,freea,freed : dword;
label frm_exit;
begin
        result:=False;
        if BFC_EELITE_MaxIndexBlk(eelite_max)
        and BFC_EEFULL_MaxIndexBlk(eefull_max)
        then begin
         ProgressBar.StepBy(2);
//         AddLinesLog('Max EELITE Index: '+IntToStr(eelite_max));
//         AddLinesLog('Max EEFULL Index: '+IntToStr(eefull_max));
         if BFC_EELITE_GetBufferInfo(freeb,freea,freed) then begin
          AddLinesLog('EELITE Инфо: free buffer '+IntToStr(freeb)+' bytes, free at all '+IntToStr(freea)+' bytes, free for deleted '+IntToStr(freed)+' bytes.');
         end;
         ClearEEPBufAndTab;
         StatusBar.Panels[PanelCmd].Text:='Поиск всех EELITE блоков с 1 по '+IntToStr(eelite_max)+' ...';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         i:=1;
         x:=idx_eeptab;
         while(i<=eelite_max) do begin
          if Not AddBFCEEPBlk(i,True) then begin
           StatusBar.Panels[PanelCmd].Text:=sEep_Err;
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           exit;
          end;
          inc(i);
          if (idx_eeptab-x) > 3 then begin
            x:=idx_eeptab;
            ProgressBar.StepBy(1);
            Application.ProcessMessages;
          end;
         end;
         if BFC_EEFULL_GetBufferInfo(freeb,freea,freed) then begin
          AddLinesLog('EEFULL Инфо: free buffer '+IntToStr(freeb)+' bytes, free at all '+IntToStr(freea)+' bytes, free for deleted '+IntToStr(freed)+' bytes.');
         end;
         StatusBar.Panels[PanelCmd].Text:='Поиск всех EEFULL блоков с 5000 по '+IntToStr(eefull_max)+' ...';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         i:=5000;
         while(i<=eefull_max) do begin
          if Not AddBFCEEPBlk(i,True) then begin
           StatusBar.Panels[PanelCmd].Text:=sEep_Err;
           AddLinesLog(StatusBar.Panels[PanelCmd].Text);
           exit;
          end;
          inc(i);
          if (idx_eeptab-x)>3 then begin
            x:=idx_eeptab;
            ProgressBar.StepBy(1);
            Application.ProcessMessages;
          end;
         end;
         StatusBar.Panels[PanelCmd].Text:='Считано всего EEP блоков: '+IntToStr(idx_eeptab)+' шт.';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         result:=True;
        end
        else begin
         StatusBar.Panels[PanelCmd].Text:='Ошибка запроса параметров EEP!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        end;
end;

procedure TFormMain.ButtonSaveAllEEPClick(Sender: TObject);
var
sblkFile : string;
begin
//      sblkFile:='.\Backup\x.eep';
      ButtonSaveAllEEP.Enabled:=False;
      PageControl.Enabled:=False;
      ProgressBar.Position:=10;
      AddLinesLog('Чтение всех EEP блоков...');
      if ComOpen then begin
       if GetMobileInfo then begin
        ProgressBar.StepBy(5);
        Application.ProcessMessages;
        if Not((bSecyrMode=$12) or (bSecyrMode = $13)) then begin
         AddLinesLog('Внимание!');
         AddLinesLog('В данном режиме защиты не читаются все блоки.');
         AddLinesLog('Используйте "Ввести SKEY в телефон"!');
        end;
{        s:=BFC_GetSecurityMode;
       AddLinesLog('SecurityStatus: '+s);
       if (BFC_Error=ERR_NO)
       and (bSecyrMode=$12) //'FactoryMode'
       then begin
}
         if ReadAllEEPBFC then begin
          ComClose;
          ProgressBar.Position:=100;
          Application.ProcessMessages;
          with SaveDialog do begin
           FilterIndex:=1;
           FileName := IniFile.ReadString('Setup','OldEepFile','.\EEPROM\'+sImei);
           InitialDir := ExtractFilePath(FileName);
           FileName := sImei; //ChangeFileExt(ExtractFileName(FileName),'');
           if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
           if not DirectoryExists(InitialDir) then
           InitialDir := IniFile.ReadString('Setup','DirOld','.\');
           DefaultExt := 'eep';
           Filter := 'eep files (*.eep)|*.eep';
           Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
           +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
           -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
           -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
           Title:='Сохранить все блоки EEPROM в файл';
          end;//with
          if SaveDialog.Execute then begin
           sblkFile:=SaveDialog.FileName;
           if not SaveAllEEP(sblkFile,SpinEditHWID.Value) then begin
            StatusBar.Panels[PanelCmd].Text:=sEep_Err;
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
//           BootEnd; exit;
           end
           else begin
//            StatusBar.Panels[PanelCmd].Text:='Всего EEP блоков: '+IntToStr(idx_eeptab);
//            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
             IniFile.WriteString('Setup','OldEepFile',ChangeFileExt(SaveDialog.FileName,''));
             AddLinesLog('Блоки сохранены в '+sblkFile);
//            ProgressBar.Position:=100;
           end;
          end;
         end;
{       end // if BFC_SecurityMode
       else begin
        if BFC_Error<>ERR_NO then
         StatusBar.Panels[PanelCmd].Text:='Ошибка запроса режима защиты!'
        else begin
         AddLinesLog('В данном режиме защиты дефрагментация невозможна!');
         StatusBar.Panels[PanelCmd].Text:='Введите Skey в телефон!';
        end;
        end; }
//        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
       end;
       ComClose;
      end; //if ComOpen
      PageControl.Enabled:=True;
      ButtonSaveAllEEP.Enabled:=True;
end;


procedure TFormMain.Button5005Click(Sender: TObject);
var
EEP5005 : array[0..127] of byte;
i,y : dword;
len : dword;
ver : byte;
ch,vch : char;
b1,b2,b3,b4,b5,b6 : byte;
begin
      ProgressBar.Position:=10;
      AddLinesLog('Чтение и модификация блока 5005...');
      if ComOpen then begin
       ProgressBar.Position:=20;
       if BFC_EE_Get_Block_Info(5005,len,ver) then begin
        ProgressBar.Position:=50;
        if (len<sizeof(EEP5005)) and (ver=1) then begin
         if BFC_EE_Read_Block(5005,0,len,EEP5005) then begin
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
             if VariantToBuf(EEP5005[$12],vch,y) then begin
              EEP5005[$0F]:=b1;
              EEP5005[$0E]:=b2;
              EEP5005[$11]:=b3;
              EEP5005[$10]:=b4;
              EEP5005[$0B]:=b5;
              EEP5005[$0C]:=b6;
              ProgressBar.Position:=60;
              if WriteEepBlock(5005,len,ver,EEP5005) then begin
               AddLinesLog('Новые данные блока:');
               AddLinesLog('P.-Date: '+Int2Digs(EEP5005[$0B],2)+'/'+Int2Digs(EEP5005[$0C] shr 4,2)+'/'+Int2Digs(EEP5005[$0C] and $0F,2));
               VariantToInt(EEP5005[$12],ch,i);
               AddLinesLog('Variant: '+ch+' '+Int2Digs(i,3)); // A 370
               AddLinesLog('Std-Map/SW: '+IntToStr(EEP5005[$0F])+'/'+IntToStr(EEP5005[$0E]));
               AddLinesLog('D-Map/Prov.: '+IntToStr(EEP5005[$11])+'/'+IntToStr(EEP5005[$10]));  // 153/148
               AddLinesLog('Для правильного отображения по *#06# -');
               StatusBar.Panels[PanelCmd].Text:='Перезапустите телефон!';
               ProgressBar.Position:=100;
              end;
             end
             else begin
               StatusBar.Panels[PanelCmd].Text:='Неверные данные в "Variant"!';
               ProgressBar.Position:=100;
             end;
            end
            else begin
             StatusBar.Panels[PanelCmd].Text:='Изменений нет.';
             ProgressBar.Position:=100;
            end;
           end
           else begin
             StatusBar.Panels[PanelCmd].Text:='Редактирование блока 5005 отклонено.';
             ProgressBar.Position:=100;
           end;
         end
         else begin
          StatusBar.Panels[PanelCmd].Text:='Ошибка чтения данных блока 5005!';
         end;
        end
        else begin
         StatusBar.Panels[PanelCmd].Text:='Неверный блок 5005!';
        end;
       end //if BFC_EE_Get_Block_Info
       else begin
         if BFC_Error=ERR_EEP_NONE then
          StatusBar.Panels[PanelCmd].Text:='В телефоне нету блока 5005!'
         else
          StatusBar.Panels[PanelCmd].Text:='Ошибка чтения инфы о блоке 5005!';
       end;
       AddLinesLog(StatusBar.Panels[PanelCmd].Text);
       ComClose;
      end; //if ComOpen
end;

procedure TFormMain.ButtonFullESNClick(Sender: TObject);
begin
       with OpenDialog do begin
        FilterIndex:=1;
        InitialDir := '.';
        DefaultExt := 'bin';
        Filter := 'Bin (*.bin)|*.bin|All files (*.*)|*.*';
        Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
        Title:='Выбор файла FullFlash для преобразования';
       end;//with OpenDialog
       if OpenDialog.execute then begin
         StatusBar.Panels[PanelCmd].Text:='Файл '+OpenDialog.FileName;
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
       end //if OpenDialog.execute
       else exit;

end;

procedure TFormMain.Buttonpx65v4Click(Sender: TObject);
var
buf : array[0..37] of byte; // id[2]+imei[16]+hash[16]+esn[4]
i : integer;
flgerr : boolean;
begin
        flgerr:=False;
        bSecyrMode:=0;
        bTelMode:=$FF;
        iComNum := RadioGroupComPort.ItemIndex+1;
        ProgressBar.Position:=0;
        Buttonpx65v4.Enabled:=False;
        PageControl.Enabled:=False;
        if OpenCom(CheckBoxSBA.Checked) then begin
         StatusBar.Panels[PanelCom].Text:='Com'+IntToStr(iComNum);
         sleep(300);
         ProgressBar.Position:=10;
         StatusBar.Panels[PanelCmd].Text:='Ожидание ответа от мидлета Chaos...';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         for i:=0 to 10 do begin
          ProgressBar.Position:=i*10;
          Application.ProcessMessages;
          sleep(200);
          WriteComStr('AT');
          if ReadCom(@buf,sizeof(buf)) then begin
           if (buf[0]=$E5) {and (buf[1]=$77)} and (buf[17]=$00) then begin
//            AddLinesLog(BufToHexStr(@buf,sizeof(buf)));
            AddLinesLog('IMEI: '+Pchar(@buf[2]));
            AddLinesLog('ESN: '+IntToHex(Dword(Pointer(@buf[34])^),8));
            AddLinesLog('HASH: '+BufToHexStr(@buf[18],16));
            EditIMEI.Text:=Pchar(@buf[2]);
            EditESN.Text:=IntToHex(Dword(Pointer(@buf[34])^),8);
            EditHASH.Text:=BufToHexStr(@buf[18],16);
            StatusBar.Panels[PanelInf].Text:=Pchar(@buf[2])+', ESN: '+IntToHex(Dword(Pointer(@buf[34])^),8);
            StatusBar.Panels[PanelCmd].Text:='Далее используйте "Расчет SKEY и BootKEY"...';
            AddLinesLog(StatusBar.Panels[PanelCmd].Text);
            ProgressBar.Position:=100;
            flgerr:=True;
            break;
//            ComClose;
           end
          end // ReadCom(@buf
          else begin
           ReadBFC;
           if flgExit and (Length(sExit)<>0) then begin
            flgerr:=True;
            break;
           end;
          end; // ReadCom(@buf
         end; // for i
         if not flgerr then begin
          StatusBar.Panels[PanelCmd].Text:='Нет ответа от мидлета!';
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          AddLinesLog('1) Запустите мидлет px65v4 на телефоне...');
          AddLinesLog('2) На вопрос "Подключите аксессуар" нажмите кнопку "Px65v4" и вставьте шнур в телефон.');
          AddLinesLog('3) Дождитесь выполнения мидлета и снова нажмите кнопку "Px65v4"...');
          AddLinesLog('*Мидлет можно найти там http://chaos.allsiemens.com/');
         end;
         ComClose;
        end
        else begin
         StatusBar.Panels[PanelCom].Text:='Com?';
         AddLinesLog('Не открыть порт Com'+IntToStr(iComNum)+' ('+IntToStr(iComBaud)+' Baud)! ');
         StatusBar.Panels[PanelCmd].Text:='Не открыть Com'+IntToStr(iComNum)+'!';
         StatusBar.Panels[PanelInf].Text:='';
        end;
        PageControl.Enabled:=True;
        Buttonpx65v4.Enabled:=True;

end;

procedure TFormMain.ButtonXBIClick(Sender: TObject);
begin
   ProgressBar.Position:=0;
   StatusBar.Panels[PanelCmd].Text:='Преобразование FullFlash...';
   with OpenDialog do begin
    FilterIndex:=1;
    FileName := IniFile.ReadString('Setup','OldFFFile','FULLFLASH.bin');
    InitialDir := ExtractFilePath(FileName);
    FileName := ExtractFileName(FileName);
    if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
    if not DirectoryExists(InitialDir) then
    InitialDir := IniFile.ReadString('Setup','DirOld','.\');
    DefaultExt := 'bin';
    Filter := 'Bin files (*.bin)|*.bin|All files (*.*)|*.*';
    Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
    Title:='Выбор файла FullFlash для преобразования.';
   end;//with OpenDialog
   if OpenDialog.execute then begin
    AddLinesLog('Используем '+OpenDialog.FileName+'...');
    StatusBar.Panels[PanelCmd].Text:='Преобразование FullFlash '+ExtractFileName(OpenDialog.FileName)+' файла.';
    if FormBin2Swp.OpenUserBinFile(OpenDialog.FileName) then begin
      IniFile.WriteString('Setup','OldFFFile',OpenDialog.FileName);
      Application.ProcessMessages;
      FormBin2Swp.ShowModal;
      FormBin2Swp.CloseUserBinFile;
      exit;
    end;
    ShowMessage(sSwp_Err);
    AddLinesLog(sSwp_Err);
    StatusBar.Panels[PanelCmd].Text:=sSwp_Err;
    exit;
   end;
   StatusBar.Panels[PanelCmd].Text:='?';
end;

function TFormMain.CreateFactoryEEPblks : boolean;
begin
      result:=False;
      if length(EditIMEI.Text)=15 then sIMEI:=EditIMEI.Text
      else begin
       StatusBar.Panels[PanelCmd].Text:='Неверный ввод IMEI';
       AddLinesLog(StatusBar.Panels[PanelCmd].Text);
       exit;
      end;
      AddLinesLog('Используем ключики:');
      AddLinesLog('IMEI: '+sIMEI);
      if length(EditESN.Text)=8 then eepESN:=StrToInt('$'+EditESN.Text)
      else begin
       StatusBar.Panels[PanelCmd].Text:='Неверный ввод ESN!';
       AddLinesLog(StatusBar.Panels[PanelCmd].Text);
       exit;
      end;
      AddLinesLog('ESN: '+IntToHex(eepESN,8));
      if length(EditSkey.Text)<>0 then eepSkey:=StrToInt(EditSkey.Text)
      else begin
       StatusBar.Panels[PanelCmd].Text:='Неверный ввод SKEY!';
       AddLinesLog(StatusBar.Panels[PanelCmd].Text);
       exit;
      end;
      AddLinesLog('SKEY: '+IntToStr(eepSkey));
      if length(EditHash.Text)=32 then HexTopByte(@EditHash.Text[1],16,@HASH)
      else FillChar(HASH,16,$FF);
      AddLinesLog('HASH: '+BufToHexStr(@HASH,16));
      if length(EditBootkey.Text)=32 then HexTopByte(@EditBootkey.Text[1],16,@BootKey)
      else FillChar(Bootkey,16,$FF);
      AddLinesLog('BKEY: '+BufToHexStr(@BootKey,16));
      if not TestSkey(True) then begin
       if MessageDlg('SKEY или ESN не совпадает с введёнными HASH или BKEY!'+#10+#13+'Пересчитать новые HASH и BootKEY из ESN и SKEY?',
        mtConfirmation, [mbYes, mbNo], 0) <> mrYes
       then begin
        CalkHashAndBkey(eepSkey,eepESN);
        EditHASH.Text:=BufToHexStr(@HASH,16);
        EditBootKey.Text:=BufToHexStr(@BootKey,16);
        AddLinesLog('Новый HASH: '+EditHASH.Text);
        AddLinesLog('Новый BKEY: '+EditBootKey.Text);
       end
       else begin
        StatusBar.Panels[PanelCmd].Text:='Неверный ввод HASH или BKEY!';
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        exit;
       end;
      end;
      Create512x(sImei,eepESN,eepSkey,Mkey);
      Create52(eepESN,eepSkey,byte(SpinEditVerDown.Value));
      Create76(sIMEI,EEP0076,C55);
      Create5009(sIMEI,EEP5009,C55);
      Create5008(sIMEI,eepESN,EEP5008,C55);
      Create5077(sIMEI,eepESN,EEP5077,C55);
      result:=True;
end;

function TFormMain.ClearBCoreBuf(var buf : array of byte) : boolean;
begin
          result:=False;
          if (Dword((@buf[$00003C])^) <> $544B4A43) or
          ( Not ((Dword((@buf[$000200])^) = $534C0200)
          or (Dword((@buf[$000200])^) = $534C0202)) ) then begin
           StatusBar.Panels[PanelCmd].Text:='Не верный BCORE!';
           exit;
          end;
          AddLinesLog('BCORE версия: "'+Pchar(@Buf[$890])+'".');
          //Очищаем 00000204...000007FF, 00000A90..00001FFF, кроме 00000654..0000065B
          Dword((@buf[$000204])^):=$FFFFFFFF; // Signature_ID
          FillChar(buf[$000210],$000232-$000210,$FF); // TelName,..
          Word((@buf[$000232])^):=$0000;
          if buf[$200]=$02 then begin  //NewSgold
           Dword((@buf[$000238])^):=$FBAFFBAF;
           FillChar(buf[$00023C],$000658-$00023C,$FF); // HASH,..
           FillChar(buf[$000660],$000800-$000660,$FF);
          end
          else begin // if buf[$200]=$00 then begin  //OldSGold
           Dword((@buf[$000234])^):=$FBAFFBAF;
           FillChar(buf[$000238],$000654-$000238,$FF); // HASH,..
           FillChar(buf[$00065C],$000800-$00065C,$FF);
          end;
          FillChar(buf[$000A90],$002000-$000A90,$FF);
          result:=True;
end;

procedure TFormMain.ReCalkKeysData(idblk : byte; var buf : array of byte);
var
i,y,z : integer;
buf_TBL : rT_SegEEP_TAB;
base,blksize : dword;
pbeep : array of byte;
begin
//------ BCORE
     pbeep:=Nil;
     blksize:=0;
     if idblk = XMASKBCR then begin
      if (Dword((@buf[$000204])^)=$FFFFFFFF)
      and (Dword((@buf[$000660])^)=$FFFFFFFF)
      and (Dword((@buf[$000A90])^)=$FFFFFFFF)
      and (Dword((@buf[$000238])^)=$FFFFFFFF)
      then begin
       AddLinesLog('BCORE "чистый": После записи используте Freeze!')
      end
      else begin
       y:=0;
       if buf[$200]=$02 then begin // NewSgold
        for i:=0 to 15 do begin
         if HASH[i]<>buf[$23C+i] then begin
          Move(FormMain.HASH[0],buf[$23C],16);
          AddLinesLog('BCORE: HASH сменен на '+BufToHexStr(@HASH,16)+'.');
          y:=1;
          break;
         end;
        end;
        if y=0 then AddLinesLog('BCORE: HASH не требует смены.');
        y:=0;
        for i:=1 to 15 do begin
         if byte(sIMEI[i])<>buf[$660-1+i] then begin
          Move(FormMain.sIMEI[1],buf[$660],15);
          AddLinesLog('BCORE: IMEI сменен на '+sIMEI+'.');
          y:=1;
          break;
         end;
        end;
       end else begin
        for i:=0 to 15 do begin
         if HASH[i]<>buf[$238+i] then begin
          Move(FormMain.HASH[0],buf[$238],16);
          AddLinesLog('BCORE: HASH сменен на '+BufToHexStr(@HASH,16)+'.');
          y:=1;
          break;
         end;
        end;
        if y=0 then AddLinesLog('BCORE: HASH не требует смены.');
        y:=0;
        for i:=1 to 15 do begin
         if byte(sIMEI[i])<>buf[$65C-1+i] then begin
          Move(FormMain.sIMEI[1],buf[$65C],15);
          AddLinesLog('BCORE: IMEI сменен на '+sIMEI+'.');
          y:=1;
          break;
         end;
        end;
       end;
       if y=0 then AddLinesLog('BCORE: IMEI не требует смены.');
      end;
     end;
//------ EELITE
//------ EEFULL
     if (idblk = XMASKEEL) or (idblk = XMASKEEF) then begin
      if idblk = XMASKEEF then  base:=5000
      else base:=0;
      i:=1; y:=0;
      while(i<2048) do begin
       Move(Buf[$20000-(i shl 4)],buf_TBL.b[0],sizeof(buf_TBL));
       if buf_TBL.wr_flg=$FFFFFFFF then begin
        deletedeep:=deletedeep+y;
        workeep:=workeep+i-1-y;
//        AddLinesLog('Сегмент X , всего блоков '+IntToStr(i-1));
//        AddLinesLog('Удаленных блоков '+intToStr(y)+', рабочих блоков '+IntToStr(i-1-y));
        exit;
       end
       else begin
        if (buf_TBL.wr_flg=$FFFFFFC0) then begin
         case buf_TBL.blk_num+base of
            76 : begin xmeep:=xmeep or 1;  pbeep:=@EEP0076;blksize:=SizeOf(EEP0076);end;
          5008 : begin xmeep:=xmeep or 2;  pbeep:=@EEP5008;blksize:=SizeOf(EEP5008);end;
          5009 : begin xmeep:=xmeep or 4;  pbeep:=@EEP5009;blksize:=SizeOf(EEP5009);end;
          5077 : begin xmeep:=xmeep or 8;  pbeep:=@EEP5077;blksize:=SizeOf(EEP5077);end;
          5121 : begin xmeep:=xmeep or 16; pbeep:=@EEP5121;blksize:=SizeOf(EEP5121);end;
          5122 : begin xmeep:=xmeep or 32; pbeep:=@EEP5122;blksize:=SizeOf(EEP5122);end;
          5123 : begin xmeep:=xmeep or 64; pbeep:=@EEP5123;blksize:=SizeOf(EEP5123);end;
            52 : begin xmeep:=xmeep or 128;pbeep:=@EEP0052;blksize:=SizeOf(EEP0052);end;
         else pbeep:=Nil;
         end;
         if pbeep<>Nil then begin
//          AddLinesLog('EEP'+IntToStr(buf_TBL.blk_num+base)+', размер: '+IntToStr(buf_TBL.blk_size-1));
          if blksize=buf_TBL.blk_size-1 then begin
           if buf_TBL.addr_off+buf_TBL.blk_size < $20000 then begin
            if base<>0 then z:=1
            else z:=0;
            if CompareMem(pbeep,@buf[buf_TBL.addr_off+dword(z)],blksize) then begin
             AddLinesLog('EEPROM: Блок '+IntToStr(buf_TBL.blk_num+base)+' не требует смены.');
            end
            else begin
             Move(pbeep[0],buf[buf_TBL.addr_off+dword(z)],blksize);
             AddLinesLog('EEPROM: Блок '+IntToStr(buf_TBL.blk_num+base)+' сменен.');
            end;
           end
           else AddLinesLog('EEPROM: Кривой указатель на блок '+IntToStr(buf_TBL.blk_num+base)+' - замена невозможна!');
          end
          else AddLinesLog('EEPROM: Кривой размер блока '+IntToStr(buf_TBL.blk_num+base)+' - замена невозможна!');
         end;
        end // if buf_TBL.wr_flg=$FFFFFFC0
        else begin
//          AddLinesLog('DEL'+IntToStr(buf_TBL.blk_num+5000)+', размер: '+IntToStr(buf_TBL.blk_size-1));
          inc(y);
        end; // if else buf_TBL.wr_flg=$FFFFFFC0
       end; // if else buf_TBL.wr_flg=$FFFFFFFF
       inc(i);
      end; // while
      AddLinesLog('Бардак в EEPROM!');
     end; // if idblk = XMASKEEF then begin
end;

procedure TFormMain.ButtonRecalkFFClick(Sender: TObject);
var
startaddr, endaddr : dword;
i : integer;
hOutFile : THandle;
buf : array[0..$1FFFF] of byte;
begin
   ProgressBar.Position:=0;
//   hOutFile:=INVALID_HANDLE_VALUE;
   StatusBar.Panels[PanelCmd].Text:='Пересчет FullFlash...';
//   AddLinesLog('Используем ключики:');
   if NOT CreateFactoryEEPblks then begin
    ShowMessage(FormMain.StatusBar.Panels[PanelCmd].Text);
    exit;
   end;
   with OpenDialog do begin
    FilterIndex:=1;
    FileName := IniFile.ReadString('Setup','OldFFFile','FULLFLASH.bin');
    InitialDir := ExtractFilePath(FileName);
    FileName := ExtractFileName(FileName);
    if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
    if not DirectoryExists(InitialDir) then
    InitialDir := IniFile.ReadString('Setup','DirOld','.\');
    DefaultExt := 'bin';
    Filter := 'Bin files (*.bin)|*.bin|All files (*.*)|*.*';
    Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
    Title:='Выбор файла FULLFLASH для преобразования.';
   end;//with OpenDialog
   if OpenDialog.execute then begin
    AddLinesLog('Входной файл: '+OpenDialog.FileName+'...');
    with SaveDialog do begin
     FilterIndex:=1;
     FileName := IniFile.ReadString('Setup','NewFFFile',FormBin2Swp.EditMobName.text+FormBin2Swp.EditLGpack.text+'.bin');
     InitialDir := ExtractFilePath(FileName);
     FileName := ExtractFileName(FileName);
     if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
     if not DirectoryExists(InitialDir) then
      InitialDir := IniFile.ReadString('Setup','DirOld','.\');
     DefaultExt := 'bin';
     Filter := 'FullFlash files (*.bin)|*.bin|All files (*.*)|*.*';
     Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
     Title:='Выберите имя для нового FullFlash файла';
    end;//with
    if SaveDialog.Execute then begin
     outfilename:=SaveDialog.FileName;
     hOutFile:=FileCreate(outfilename);
     if hOutFile=INVALID_HANDLE_VALUE then begin
      StatusBar.Panels[PanelCmd].Text:='Не открыть файл '+outfilename+'!';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     end;
    // Запись в файл
     if FormBin2Swp.OpenUserBinFile(OpenDialog.FileName) then begin
//      IniFile.WriteString('Setup','OldFFFile',OpenDialog.FileName);
      ProgressBar.Max:=sizebinfile shr 17;
      Application.ProcessMessages;
      FileSeek(hBinFile,0,0);
      startaddr:=$A0000000;
      endaddr := dword(sizebinfile)-1 + $A0000000;
      i:=0;
      while startaddr < endaddr do begin
       if FileRead(hBinFile,buf[0],SizeOf(buf)) <> SizeOf(buf) then begin
        FileClose(hBinFile);
        FileClose(hOutFile);
        StatusBar.Panels[PanelCmd].Text:='Не прочитать файл '+binfilename+'!';
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        ProgressBar.Max:=100;
        ProgressBar.Position:=(ProgressBar.Position*100) div(sizebinfile shr 17);
        exit;
       end;
       if (TabSegBin[i] and (XMASKBCR or XMASKEEL or XMASKEEF)) <> 0
       then ReCalkKeysData(TabSegBin[i],buf[0]);
       if FileWrite(hOutFile,buf[0],SizeOf(buf)) <> SizeOf(buf) then begin
        FileClose(hBinFile);
        FileClose(hOutFile);
        StatusBar.Panels[PanelCmd].Text:='Не записать файл '+outfilename+'!';
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        ProgressBar.Max:=100;
        ProgressBar.Position:=(ProgressBar.Position*100) div(sizebinfile shr 17);
        exit;
       end;
       inc(i);
       startaddr := startaddr+SizeOf(buf);
       ProgressBar.Position:=i;
      end;
      FormBin2Swp.CloseUserBinFile;
      FileClose(hOutFile);
      ProgressBar.Max:=100;
      ProgressBar.Position:=100;
      IniFile.WriteString('Setup','OldFFFile',binfilename);
      IniFile.WriteString('Setup','NewFFFile',outfilename);
//      AddLinesLog('Входной файл: '+OpenDialog.FileName+'...');
      StatusBar.Panels[PanelCmd].Text:='Новый FullFlash записан в '+outfilename;
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      exit;
     end; // if FormBin2Swp.OpenUserBinFile
     ShowMessage(sSwp_Err);
     AddLinesLog(sSwp_Err);
     StatusBar.Panels[PanelCmd].Text:=sSwp_Err;
     exit;
    end; // if SaveDialog.Execute
   end; // if OpenDialog.execute
   StatusBar.Panels[PanelCmd].Text:='?';
end;

function TFormMain.ReadCameraToMemStream : boolean;
var
addr,size,len : dword;
Buf : array[0..$fff] of Byte;
begin
       result:=False;
       if CameraMemStream=nil then  CameraMemStream:=TMemoryStream.Create
       else CameraMemStream.Seek(0,soFromBeginning);
       if NOT BFC_GetCameraBuf(addr,size) then begin
        StatusBar.Panels[PanelCmd].Text:='Ошибка запроса буфера кадра!';
        exit;
       end;
//       AddLinesLog('Адрес буфера кадра: 0x'+IntToHex(addr,8));
//       AddLinesLog('Размер кадра '+IntToStr(size)+ ' байт.');
       if (size=0) or (addr=0) then begin
        StatusBar.Panels[PanelCmd].Text:='Буфера кадра равен нулю!';
        exit;
       end;
       if size>1024*1024 then begin
        StatusBar.Panels[PanelCmd].Text:='Неверный размер буфера кадра!';
        exit;
       end;
       ProgressBar.Max:=1 + (size div sizeof(buf));
       ProgressBar.Position:=1;
       Application.ProcessMessages;
//       Repaint;
       CameraMemStream.SetSize(size);
//       CameraMemStream.Seek(0,soFromBeginning);
       while size>0 do begin
        Application.ProcessMessages;
        len:=sizeof(Buf);
        if size<len then len:=size;
        if NOT BFCReadMem(addr,len,Buf[0]) then begin
         AddLinesLog('Повтор чтения блока...');
         if NOT BFCReadMem(addr,len,Buf[0]) then begin
          StatusBar.Panels[PanelCmd].Text:='Ошибка чтения блока 0x'+IntToHex(addr,8)+'!';
          CameraMemStream.Free; CameraMemStream:=nil;
          ProgressBar.Max:=100;
          exit;
         end;
        end;
        if CameraMemStream.Write(Buf,len)<>integer(len) then begin
         StatusBar.Panels[PanelCmd].Text:='MemoryStream: Ошибка записи!';
         CameraMemStream.Free; CameraMemStream:=nil;
         ProgressBar.Max:=100;
         exit;
        end;
        ProgressBar.StepBy(1); //max +64
        addr:=addr+len;
        size:=size-len;
       end; // while
{
       if NOT BFC_GetCameraBuf(addr,size) then begin
        AddLinesLog('Ошибка освобождения буфера кадра в телефоне!');
       end;
       If (size<>0) then begin
        AddLinesLog('Ошибка('+IntToStr(size)+') освобождения буфера кадра в телефоне!');
       end;
}
       CameraMemStream.Seek(0,soFromBeginning);
       ProgressBar.Max:=100;
       ProgressBar.Position:=100;
       result:=True;
end;

procedure TFormMain.NewCamParams;
begin
       CamParams.WhiteBalance:=CamWhiteBalance.ItemIndex;
       CamParams.Brightness:=ScrollBarBrigh.Position;
       CamParams.CompressionRate:=CamCompressionRate.ItemIndex;
       CamParams.ZoomFactor:= CamZoomFactor.ItemIndex+1;
       CamParams.ColorMode := CamColorMode.ItemIndex;
       CamParams.Resolution := CameraPicResolution.ItemIndex;
       if CamFlashCondition.Checked then CamParams.FlashCondition := 1
       else CamParams.FlashCondition:=0;
{
      AddLinesLog('WhiteBalance: '+IntToStr(CamParams.WhiteBalance));
      AddLinesLog('Brightness: '+IntToStr(CamParams.Brightness));
      AddLinesLog('CompressionRate: '+IntToStr(CamParams.CompressionRate));
      AddLinesLog('ZoomFactor: '+IntToStr(CamParams.ZoomFactor));
      AddLinesLog('ColorMode: '+IntToStr(CamParams.ColorMode));
      AddLinesLog('FlashCondition: '+IntToStr(CamParams.FlashCondition));
}
end;

function TFormMain.SetCameraParameters : boolean;
begin
       result:=False;
       if NOT BFC_SetCameraParameters(0,CamParams.WhiteBalance) then begin
        StatusBar.Panels[PanelCmd].Text:='Ошибка задания параметра типа управления съемкой!';
        exit;
       end;
       if NOT BFC_SetCameraParameters(1,CamParams.Brightness) then begin
        StatusBar.Panels[PanelCmd].Text:='Ошибка задания параметра яркости съемки!';
        exit;
       end;
       if NOT BFC_SetCameraParameters(2,CamParams.CompressionRate) then begin
        StatusBar.Panels[PanelCmd].Text:='Ошибка задания параметров компресии кадра съемки!';
        exit;
       end;
       if NOT BFC_SetCameraParameters(3,CamParams.ZoomFactor) then begin
        StatusBar.Panels[PanelCmd].Text:='Ошибка задания параметра "Zoom" съемки!';
        exit;
       end;
       if NOT BFC_SetCameraParameters(4,CamParams.ColorMode) then begin
        StatusBar.Panels[PanelCmd].Text:='Ошибка задания параметра цветового типа съемки!';
        exit;
       end;
       if CamParams.FlashCondition > 0 then
        if NOT BFC_SetCameraParameters(5,CamParams.FlashCondition) then begin
        StatusBar.Panels[PanelCmd].Text:='Ошибка: у данной камеры нет "вспышки"!';
        exit;
       end;
       result:=True;
end;

function TFormMain.CheckCameraParameters : boolean;
var
OldCamParams: T_CamParamVal;
begin
      result:=False;
      OldCamParams:=CamParams;
      NewCamParams;
      if OldCamParams.WhiteBalance<>CamParams.WhiteBalance then begin
       if NOT BFC_SetCameraParameters(0,CamParams.WhiteBalance) then begin
        StatusBar.Panels[PanelCmd].Text:='Ошибка задания параметра типа управления съемкой!';
        exit;
       end;
      end;
      if OldCamParams.Brightness<>CamParams.Brightness then begin
       if NOT BFC_SetCameraParameters(1,CamParams.Brightness) then begin
        StatusBar.Panels[PanelCmd].Text:='Ошибка задания параметра яркости съемки!';
        exit;
       end;
       sleep(500);
      end;
      if OldCamParams.CompressionRate<>CamParams.CompressionRate then begin
       if NOT BFC_SetCameraParameters(2,CamParams.CompressionRate) then begin
        StatusBar.Panels[PanelCmd].Text:='Ошибка задания параметров компресии кадра съемки!';
        exit;
       end;
      end;
      if OldCamParams.ZoomFactor<>CamParams.ZoomFactor then begin
       if NOT BFC_SetCameraParameters(3,CamParams.ZoomFactor) then begin
        StatusBar.Panels[PanelCmd].Text:='Ошибка задания параметра "Zoom" съемки!';
        exit;
       end;
      end;
      if OldCamParams.ColorMode<>CamParams.ColorMode then begin
       if NOT BFC_SetCameraParameters(4,CamParams.ColorMode) then begin
        StatusBar.Panels[PanelCmd].Text:='Ошибка задания параметра цветового типа съемки!';
        exit;
       end;
      end;
      if OldCamParams.FlashCondition<>CamParams.FlashCondition then begin
       if CamParams.FlashCondition > 0 then
        if NOT BFC_SetCameraParameters(5,CamParams.FlashCondition) then begin
        StatusBar.Panels[PanelCmd].Text:='Ошибка: у данной камеры нет "вспышки"!';
        exit;
       end;
//        Sleep(200);
      end;
      result:=True;
end;

function TFormMain.TakeCameraPicture : boolean;
var
size : dword;
begin
       result:=False;
       if NOT BFC_TakeCameraPicture(CamParams.Resolution,size) then begin
         StatusBar.Panels[PanelCmd].Text:='Ошибка запроса съемки!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         exit;
       end;
       if size=0 then begin
        AddLinesLog('Timeout 0.7 sec...');
        Sleep(700);
        if NOT BFC_TakeCameraPicture(CamParams.Resolution,size) then begin
         StatusBar.Panels[PanelCmd].Text:='Ошибка запроса съемки!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         exit;
        end;
        if size=0 then begin
         StatusBar.Panels[PanelCmd].Text:='Нет возможности съемки!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         AddLinesLog('Возможные причины:');
         AddLinesLog('1) Неверные параметры.');
         AddLinesLog('2) Нехватает освешения.');
         exit;
        end;
       end;
       result:=True;
end;

function TFormMain.SaveJpegCamera : boolean;
var
F : TFileStream;
begin
       result:=False;
       if (CameraMemStream=nil) or (CameraMemStream.Size=0) then exit;
       FormCamera.Show;
       StatusBar.Panels[PanelCmd].Text:='Сохранение кадра размером '+IntToStr(CameraMemStream.Size)+ ' байт в файл...';
       with SaveDialog do begin
        FilterIndex:=0;
        FileName := IniFile.ReadString('Setup','OldCamFile','.\Camera1.jpg');
        InitialDir := ExtractFilePath(FileName);
        FileName := ChangeFileExt(ExtractFileName(FileName),'');
        if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
        if not DirectoryExists(InitialDir) then
        InitialDir := IniFile.ReadString('Setup','DirOld','.\');
        DefaultExt := 'jpg';
        Filter := 'Jpeg files (*.jpg)|*.jpg';
        Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
        Title:='Сохранить кадр размером '+IntToStr(CameraMemStream.Size)+ ' байт в файл';
       end;//with
       if SaveDialog.Execute then begin
        F:=TFileStream.Create(SaveDialog.FileName,fmCreate);
        CameraMemStream.Seek(0,soFromBeginning);
        if F.CopyFrom(CameraMemStream,CameraMemStream.Size)<> CameraMemStream.Size
        then begin
         StatusBar.Panels[PanelCmd].Text:='Ошибка записи '+SaveDialog.FileName+'!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         F.Free;
         exit;
        end;
        F.Free;
        StatusBar.Panels[PanelCmd].Text:='Кадр сохранен в '+SaveDialog.FileName;
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        IniFile.WriteString('Setup','OldCamFile',SaveDialog.FileName);
        exit;
       end // if SaveDialog.Execute
       else StatusBar.Panels[PanelCmd].Text:='?';
       result:=True;
end;

function TFormMain.AutoSaveJpegCamera : boolean;
var
F : TFileStream;
sJpgFile : string;
begin
       result:=False;
       if (CameraMemStream=nil) or (CameraMemStream.Size=0) then exit;
       sJpgFile:='.\Jpegs';
       if not DirectoryExists(sJpgFile) then begin
         if not CreateDir(sJpgFile) then sJpgFile := '.';
       end;
       sJpgFile:=sJpgFile+'\'+FormatDateTime('yymmddhhnnsszzz',Now)+'.jpg';
//    try
       F:=TFileStream.Create(sJpgFile,fmCreate);
       CameraMemStream.Seek(0,soFromBeginning);
       if F.CopyFrom(CameraMemStream,CameraMemStream.Size)<> CameraMemStream.Size
       then begin
         StatusBar.Panels[PanelCmd].Text:='Ошибка записи '+SaveDialog.FileName+'!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         F.Free;
         exit;
       end;
//    finally
       F.Free;
//    end;
       result:=True;
end;

procedure TFormMain.ErrEndCamClick;
begin
      if CameraMemStream<>nil then begin
       CameraMemStream.Free; CameraMemStream:=nil;
      end;
      ButtonShowFormCam.Enabled:=False;
      ButtonStartCamera.Caption:='Start';
      ButtonStartCamera.Enabled:=True;
      FixPage:=-1;
      ComClose;
end;

procedure TFormMain.ButtonGetCamClick(Sender: TObject);
var
i,x : integer;
addr,size : dword;
begin
      if FixPage<>-1 then begin
       FormCamera.Off := True;
       ButtonStartCamera.Enabled:=False;
       AddLinesLog('Останов...');
       exit;
      end;
      PageControl.ActivePageIndex:=6;
      FormCamera.Off := False;
      FixPage:=PageControl.ActivePageIndex;
//      ButtonStartCamera.Enabled:=False;
//      PageControl.Enabled:=False;
      i:=1;
      ButtonStartCamera.Caption:='Stop';
      StatusBar.Panels[PanelCmd].Text:='Инициализация камеры...';
      AddLinesLog(StatusBar.Panels[PanelCmd].Text);
      ProgressBar.Position:=10;
      if ComOpen then begin
//       Application.ProcessMessages;
       ProgressBar.Position:=20;
       Application.ProcessMessages;
       BFC_SecurityMode;
       if BFC_Error<>ERR_NO then begin
        StatusBar.Panels[PanelCmd].Text:='Нет ответа на запрос статуса режима!';
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        ErrEndCamClick;
        exit;
       end;
       Application.ProcessMessages;
       if Not((bSecyrMode=$11) or (bSecyrMode=$12) or (bSecyrMode = $13)) then begin
        StatusBar.Panels[PanelCmd].Text:='Возможно только при введенном SKEY!';
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        ErrEndCamClick;
        exit;
       end;
       if NOT BFC_ReadCameraId(CamParams.id) then begin
        StatusBar.Panels[PanelCmd].Text:='Не прочитать тип датчика камеры!';
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        ErrEndCamClick;
        exit;
       end;
       x:=CamParams.id;
       if (x>14) or (x<0) then x:=0;
       AddLinesLog('Camera sensor ID('+IntToStr(CamParams.id)+'): '+sCameraSensor[x]);
       NewCamParams;
       Sleep(200);
       ProgressBar.Position:=30;
       Application.ProcessMessages;
       if NOT SetCameraParameters then begin
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        ErrEndCamClick;
        exit;
       end;
       Application.ProcessMessages;
       for x:=1 to 15 do begin
         ProgressBar.StepBy(4);
         Sleep(100);
         Application.ProcessMessages;
       end;
       BFC_InitHost($06);
       Sleep(100);
       ProgressBar.StepBy(4);
       Application.ProcessMessages;
       if NOT TakeCameraPicture then begin
         ErrEndCamClick;
         Exit;
       end;
       StatusBar.Panels[PanelCmd].Text:='Чтение кадра...';
       AddLinesLog(StatusBar.Panels[PanelCmd].Text);
       Application.ProcessMessages;
//       ProgressBar.Position:=95;
       Application.ProcessMessages;
       if NOT ReadCameraToMemStream then begin
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         ErrEndCamClick;
        exit;
       end;
//       ComClose;
//       FormCamera.ClientHeight:=240;
//       FormCamera.ClientWidth:=320;
       FormCamera.Image.Picture.Graphic.LoadFromStream(CameraMemStream);
       FormCamera.Caption:='Jpeg: '+IntToStr(FormCamera.Image.Picture.Width)+
       'x'+IntToStr(FormCamera.Image.Picture.Height)+
       ', '+IntToStr(CameraMemStream.Size)+' bytes';
       StatusBar.Panels[PanelCmd].Text:='Кадр '+IntToStr(i);
       FormCamera.Show;
       if CheckBoxAutoSaveJpeg.Checked then begin
        if NOT AutoSaveJpegCamera then begin
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         ErrEndCamClick;
         exit;
        end;
       end;
       ButtonShowFormCam.Enabled:=True;
       While not FormCamera.Off do begin
        Application.ProcessMessages;
        if NOT CheckCameraParameters then begin
         ErrEndCamClick;
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         Exit;
        end;
        Application.ProcessMessages;
        for x:=1 to SpinEditTO.Value do begin
         Sleep(100);
         Application.ProcessMessages;
        end;
        if NOT TakeCameraPicture then begin
         ErrEndCamClick;
         Exit;
        end;
        if NOT ReadCameraToMemStream then begin
         ErrEndCamClick;
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         exit;
        end;
        FormCamera.Image.Picture.Graphic.LoadFromStream(CameraMemStream);
        FormCamera.Caption:='Jpeg: '+IntToStr(FormCamera.Image.Picture.Width)+
        'x'+IntToStr(FormCamera.Image.Picture.Height)+
        ', '+IntToStr(CameraMemStream.Size)+' bytes';
        if CheckBoxAutoSaveJpeg.Checked then begin
         if NOT AutoSaveJpegCamera then begin
          AddLinesLog(StatusBar.Panels[PanelCmd].Text);
          ErrEndCamClick;
          exit;
         end;
        end;
        inc(i);
        StatusBar.Panels[PanelCmd].Text:='Кадр '+IntToStr(i);
       end; // While
       AddLinesLog('Shutdown Camera...');
       if NOT BFC_GetCameraBuf(addr,size) then begin
        AddLinesLog('Warning: Ошибка освобождения буфера кадра в телефоне!');
       end;
{
       If (size<>0) and (CamParams.id=7) then begin
        AddLinesLog('Warning('+IntToStr(size)+'): неудачное освобождение буфера кадра в телефоне!');
       end;
}
       if NOT BFC_ShutdownCamera then begin
        AddLinesLog('Error Shutdown Camera!');
       end else begin
        StatusBar.Panels[PanelCmd].Text:='Камера отключена.';
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        AddLinesLog('Всего считано кадров: '+IntToStr(i)+'.');
       end;
       ComClose;
       if NOT CheckBoxAutoSaveJpeg.Checked then SaveJpegCamera;
       ProgressBar.Max:=100;
      end; // if ComOpen
      ErrEndCamClick;
end;

procedure TFormMain.ScrollBarBrighChange(Sender: TObject);
begin
    LabelBrightness.Caption:=IntToStr(ScrollBarBrigh.Position);
end;

procedure TFormMain.PageControlChange(Sender: TObject);
begin
  if FixPage<>-1 then PageControl.ActivePageIndex:=FixPage;
end;

procedure TFormMain.ButtonShowFormCamClick(Sender: TObject);
begin
       FormCamera.Show;
end;

procedure TFormMain.Label5Click(Sender: TObject);
begin
   ShellExecute(Application.Handle, 'open',
               PChar('http://siemensmania.cz/forum/viewtopic.php?t=8175'),
               nil, '', SW_SHOWNORMAL);
end;

procedure TFormMain.Label8Click(Sender: TObject);
begin
   ShellExecute(Application.Handle, 'open',
               PChar('http://forum.allsiemens.com/viewtopic.php?t=16736'),
               nil, '', SW_SHOWNORMAL);
end;

procedure TFormMain.Label9Click(Sender: TObject);
begin
   ShellExecute(Application.Handle, 'open',
               PChar('http://www.mobile-files.ru/forum/forumdisplay.php?s=&forumid=680'),
               nil, '', SW_SHOWNORMAL);
end;

procedure TFormMain.ButtonMicRecOnClick(Sender: TObject);
var
RoutingRec : sRoutingRec;
begin
      ProgressBar.Position:=10;
      AddLinesLog('Test MIC+REC : Generation of Sine...');
      if ComOpen then begin
       ProgressBar.Position:=20;
       if NOT BFC_ActScalAddRouting(8192,8192) then begin
         StatusBar.Panels[PanelCmd].Text:='Error ActScalAddRouting!';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         ComClose;
         exit;
       end;
       FillChar(RoutingRec.b[0],sizeof(RoutingRec),0);
{
with RoutingRec do begin
  Wired_accessory:=0;  // NONE,CK_COMFORT,CK_PORTABLE,CK_EASY,CK_LINEFIT,CK_PROF_BT,CK_COMFORT_VOICE,HEADSET_MONO,HEADSET_STEREO,TTY_EXT,TTY,HEADSET_FMRADIO,MP3_PLAYER
  BT_accessory:=0;     // NONE,CARKIT_BT,CARKIT_BT_DSP,CARKIT_PROFESSIONAL_BT,HEADSET_BT,HEADSET_BT_R65,HEADSET_BT_STEREO
  Clip_it_accessory:=0; // NONE,CLIPIT_LED,EMO
  Mmi_option:=0;       // STANDARD_HANDSET,ALTERNATE_HANDSET,STANDARD_HANDSFREE,ALTERNATE_HANDSFREE
  Downlink_destination:=0; // NONE,SPEAKER,BT,WIRE,SPEAKER_AND_BT,SPEAKER_AND_WIRE,SPEAKER_AND_BT_AND_WIRE,BT_AND_WIRE
  Downlink_pcm0_source:=0; // NONE,MP3_AAC,TTS,FM_SYNTH_ADPCM,MP3_AAC_AND_FM_SYNTH_ADPCM
  Uplink_source:=0;   // NONE,INT_MIC,EXT_MIC,BT_MIC
  Audio_mode:=0;      // NONE,CALL,VOICE_RECOGNITION,RINGING,DTMF_ONLY,VOICE_MEMO_ONLY
  Voice_memo:=0;      // NONE,RECORD_AMR,RECORD_FR,PLAY_AMR,PLAY_FR
  Logical_analog_source:=0; // NONE,FM_RADIO,SOUND_CHIP
  Mic_mute:=0;        // ON,OFF
  Slider_mode:=0;     // OPEN,CLOSE
  Test_mode:=4;       // NONE,MICROPHONE,SPEAKER,RECEIVER,MICREC
  Volume_speech:=0;   // 0,1,2,3,4
  Volume_player:=0;   // 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14
  Sample_mode_voice:=0;  // VB08,VB16
  Sample_mode_pcm0:=0;   // P08,P11,P12,P16,P22,P24,P32,P44,P48
  Sample_channels_voice:=0; // MONO,BINAURAL
  Sample_channels_pcm0:=0; // MONO,STEREO
  Asp := 0;        // ON,OFF
end; }
       RoutingRec.Test_mode:=4; // MICREC
       if NOT BFC_AddRoutingReconfigure(RoutingRec) then begin
         StatusBar.Panels[PanelCmd].Text:='Error AddRoutingReconfigure';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         ComClose;
         exit;
       end;
//       if NOT BFC_CommandDsp(12,[$09,$00,$00,$00,$19,$00,$80,$00,$00,$20,$FF,$1F]) then begin
       if NOT BFC_CommandDsp(12,[$09,$00,$00,$00,$19,$00,$80,$00,$00,$20,$FF,$1F]) then begin
         StatusBar.Panels[PanelCmd].Text:='Error BFC_CommandDsp(Sine)';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         ComClose;
         exit;
       end
       else AddLinesLog('Generation Sine is switched On.');
{
       if NOT BFC_CommandDsp(12,[$0D,$00,$00,$00,$2B,$00,$F8,$FF,$4D,$40,$03,$00]) then begin
         StatusBar.Panels[PanelCmd].Text:='Error BFC_CommandDsp(buf2)';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         exit;
       end;
       if NOT BFC_CommandDsp(12,[$0D,$00,$00,$00,$2B,$00,$F5,$FF,$4C,$20,$15,$2B]) then begin
         StatusBar.Panels[PanelCmd].Text:='Error BFC_CommandDsp(buf3)';
         AddLinesLog(StatusBar.Panels[PanelCmd].Text);
         exit;
       end;
}
//       Sleep(3000);
//       BFC_AddRoutingOff;
       ComClose;
       ProgressBar.Position:=100;
      end;
end;

procedure TFormMain.ButtonSineOffClick(Sender: TObject);
begin
      ProgressBar.Position:=10;
      AddLinesLog('Cutting off of the Test MIC+REC...');
      if ComOpen then begin
       ProgressBar.Position:=50;
       if Not BFC_AddRoutingOff then begin
        StatusBar.Panels[PanelCmd].Text:='Error BFC_AddRoutingOff';
        AddLinesLog(StatusBar.Panels[PanelCmd].Text);
        ComClose;
        exit;
       end;
       ComClose;
       ProgressBar.Position:=100;
      end;
end;

procedure TFormMain.Label11Click(Sender: TObject);
begin
   ShellExecute(Application.Handle, 'open',
               PChar('http://forum.siemens-club.org/'),
               nil, '', SW_SHOWNORMAL);
end;

procedure TFormMain.ButtonExtractXBZClick(Sender: TObject);
begin
   with OpenDialog do begin
    FilterIndex:=1;
    FileName := IniFile.ReadString('Setup','OldSWEFile','S75_000100.xbz_service.exe');
    InitialDir := ExtractFilePath(FileName);
    FileName := ExtractFileName(FileName);
    if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
    if not DirectoryExists(InitialDir) then InitialDir := '.';
    DefaultExt := 'exe';
    Filter := 'WinSwup32 files (*.exe)|*.exe|All files (*.*)|*.*';
    Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
    Title:='Выбор файла прошивки с WinSwup32+XBZ(I)';
   end;//with OpenDialog
   if OpenDialog.execute then begin
    StatusBar.Panels[PanelCmd].Text:='Extract XBZ(I) from ServiceWinSwup32...';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    ProgressBar.Position:=20;
    AddLinesLog('Входной файл: '+OpenDialog.FileName+'...');
    if not FormBin2Swp.OpenSwpExe(OpenDialog.FileName) then begin
     StatusBar.Panels[PanelCmd].Text:=sSwp_Err;
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
    end;
    ProgressBar.Position:=60;
    IniFile.WriteString('Setup','OldSWEFile',OpenDialog.FileName);
    with SaveDialog do begin
     FilterIndex:=1;
     FileName := IniFile.ReadString('Setup','NewXBZFile','xxx.xbz');
     InitialDir := ExtractFilePath(FileName);
     FileName := ChangeFileExt(ExtractFileName(OpenDialog.FileName),'.xbz');
     if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
     if not DirectoryExists(InitialDir) then
      InitialDir := IniFile.ReadString('Setup','DirOld','.\');
     DefaultExt := 'xbz';
     Filter := 'XBZ(I/B) files (*.xb?)|*.xb?|All files (*.*)|*.*';
     Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
     Title:='Выберите имя для сохранения XBZ файла';
    end;//with
    if SaveDialog.Execute then begin
     ProgressBar.Position:=80;
     FormBin2Swp.SaveXBZfile(SaveDialog.FileName);
     IniFile.WriteString('Setup','NewXBZFile',SaveDialog.FileName);
     ProgressBar.Position:=100;
     StatusBar.Panels[PanelCmd].Text:='XBZ файл записан в '+SaveDialog.FileName;
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
    end // if SaveDialog.Execute
    else StatusBar.Panels[PanelCmd].Text:='?';
   end;  // if OpenDialog.execute
//   else StatusBar.Panels[PanelCmd].Text:='?';
end;

procedure TFormMain.ButtonCrWSwupClick(Sender: TObject);
begin
  NewSGold:=CheckBoxNewS.Checked;
   with OpenDialog do begin
    FilterIndex:=1;
    FileName := IniFile.ReadString('Setup','OldXBZFile','S75_170300.xbz_service.XBZ');
    InitialDir := ExtractFilePath(FileName);
    FileName := ExtractFileName(FileName);
    if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
    if not DirectoryExists(InitialDir) then InitialDir := '.';
    DefaultExt := 'xbz';
    Filter := 'XBZ/XBI/XFS/XBB files |*.xb?;*.xfs;*.ebb|All files (*.*)|*.*';
    Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
    Title:='Выбор файла XBZ/XBI/XBB/XFS/EEB';
   end;//with OpenDialog
   if OpenDialog.execute then begin
    StatusBar.Panels[PanelCmd].Text:='Создать базу из WinSwup32 + XBZ(I) файла...';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    ProgressBar.Position:=20;
    AddLinesLog('Входной файл: '+OpenDialog.FileName+'...');
    xbzfilename:=OpenDialog.FileName;
{
    if not FormBin2Swp.OpenSwpExe(OpenDialog.FileName) then begin
     StatusBar.Panels[PanelCmd].Text:=sSwp_Err;
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
    end;
}
    ProgressBar.Position:=60;
    IniFile.WriteString('Setup','OldXBZFile',OpenDialog.FileName);
    if Not FormBin2Swp.SaveSwpFile(1,ExtractFileName(xbzfilename)) then begin
     StatusBar.Panels[PanelCmd].Text:=sSwp_Err;
     AddLinesLog(StatusBar.Panels[PanelCmd].Text);
     exit;
    end;
    ProgressBar.Position:=100;
    StatusBar.Panels[PanelCmd].Text:='Свуп файл записан в '+outfilename;
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
   end;  // if OpenDialog.execute
end;

procedure TFormMain.ButtonBPinIniClick(Sender: TObject);
var
sxbkey : string;
i : integer;
begin
  AddLinesLog('Проверка ввода значений...');
  if length(EditIMEI.Text)=15 then sIMEI:=EditIMEI.Text
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод IMEI';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
  if length(EditBootKey.Text)=32 then HexTopByte(@EditBootKey.Text[1],16,@BootKey)
  else begin
    StatusBar.Panels[PanelCmd].Text:='Неверный ввод BootKEY';
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
    exit;
  end;
   with SaveDialog do begin
     FilterIndex:=1;
     FileName := IniFile.ReadString('Setup','OldPinFile','bootpin.ini');
     InitialDir := ExtractFilePath(FileName);
     FileName := ExtractFileName(FileName);
     if InitialDir = '' then IniFile.ReadString('Setup','DirOld','.\');
     if not DirectoryExists(InitialDir) then
      InitialDir := IniFile.ReadString('Setup','DirOld','.\');
     DefaultExt := 'ini';
     Filter := 'bootpin.ini files |*.ini|All files (*.*)|*.*';
     Options:=Options+[ofFileMustExist]-[ofHideReadOnly]
        +[ofNoChangeDir]-[ofNoLongNames]-[ofNoNetworkButton]-[ofHideReadOnly]
        -[ofOldStyleDialog]-[ofOverwritePrompt]+[ofPathMustExist]
        -[ofReadOnly]-[ofShareAware]-[ofShowHelp];
     Title:='Сохранить BootKey в bootpin.ini файл для Свупа';
   end;//with
  if SaveDialog.Execute then begin
    IniFileX := TIniFile.Create(SaveDialog.FileName);
    sxbkey:='';
    for i:=0 to 15 do begin
     sxbkey:=sxbkey+'0x'+IntToHEX(BootKey[i],2)+' ';
    end;
    IniFileX.WriteString('Default','PIN',sxbkey);
    IniFileX.WriteString(sIMEI,'PIN',sxbkey);
    IniFileX.UpdateFile;
    IniFileX.Free;
    IniFileX := Nil;
    IniFile.WriteString('Setup','OldPinFile',SaveDialog.FileName);
    StatusBar.Panels[PanelCmd].Text:='Bkey cохранен в '+SaveDialog.FileName;
    AddLinesLog(StatusBar.Panels[PanelCmd].Text);
  end; // if save dialog
end;



procedure TFormMain.RadioGroupBootTypeClick(Sender: TObject);
begin
     if RadioGroupBootType.ItemIndex = 2 then begin
      CheckBoxSaveEEP.Enabled:=False;
      CheckBoxSaveEEP.Checked:=False;
      CheckBoxFreia.Enabled:=False;
      CheckBoxFreia.Checked:=False;
      CheckBoxNew5121.Enabled:=False;
      CheckBoxNew5121.Checked:=False;
      CheckBoxClrExit.Enabled:=False;
      CheckBoxClrExit.Checked:=False;
      CheckBoxReCalkFull.Enabled:=False;
      CheckBoxReCalkFull.Checked:=False;
      CheckBoxClrEEFULL.Enabled:=False;
      CheckBoxClrEEFULL.Checked:=False;
      CheckBoxClrEELITE.Enabled:=False;
      CheckBoxClrEELITE.Checked:=False;
      CheckBoxClrBcor.Enabled:=False;
      CheckBoxClrBcor.Checked:=False;
     end
     else begin
      CheckBoxSaveEEP.Enabled:=True;
      CheckBoxFreia.Enabled:=True;
      CheckBoxNew5121.Enabled:=True;
      CheckBoxClrExit.Enabled:=True;
      CheckBoxReCalkFull.Enabled:=True;
      CheckBoxClrEEFULL.Enabled:=True;
      CheckBoxClrEELITE.Enabled:=True;
      CheckBoxClrBcor.Enabled:=True;
     end;

end;

end.
