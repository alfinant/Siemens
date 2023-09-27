program JokerA70;

uses
  Forms,
  JMain in 'JMain.pas' {FormMain},
  BFB in 'BFB.pas',
  ComPort in 'ComPort.pas',
  Crc16 in 'Crc16.pas',
  CryptEEP in 'CryptEEP.pas',
  HexUtils in 'HexUtils.pas',
  l55boots in 'L55Boots.pas',
  MD5 in 'MD5.pas',
  EEP in 'EEP.pas',
  Blk5005 in 'Blk5005.pas' {Dlg5005},
  About in 'ABOUT.PAS' {AboutBox},
  HWID_EGOLD in 'HWID_EGold.pas',
  Config in 'Config.pas' {ConfigDlg},
  DelInsts in 'DelInsts.pas' {FormDeleteInstance},
  NewSkey in 'NewSkey.pas' {FormNewSkey},
  SWPio in 'SWPio.pas',
  ChName in 'ChName.pas' {FormMobileName};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Joker EGOLD series';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TDlg5005, Dlg5005);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TConfigDlg, ConfigDlg);
  Application.CreateForm(TFormDeleteInstance, FormDeleteInstance);
  Application.CreateForm(TFormNewSkey, FormNewSkey);
  Application.CreateForm(TFormMobileName, FormMobileName);
  Application.Run;
end.
