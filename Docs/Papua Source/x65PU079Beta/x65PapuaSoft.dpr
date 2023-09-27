program x65PapuaSoft;

uses
  Forms,
  x65psMain in 'x65psMain.pas' {FormMain},
  ComPort in 'ComPort.pas',
  HexUtils in 'HexUtils.pas',
  About in 'ABOUT.PAS' {AboutBox},
  BFC in 'BFC.pas',
  Crc16 in 'Crc16.pas',
  Boots65 in 'Boots65.pas',
  BFB in 'BFB.pas',
  MD5 in 'MD5.pas',
  HwProject in 'HwProject.pas',
  CryptEEP in 'CryptEEP.pas',
  EEP in 'EEP.pas',
  Blk5005 in 'Blk5005.pas' {Dlg5005},
  Bin2xbi in 'Bin2xbi.pas' {FormBin2Swp},
  SWP in 'SWP.pas',
  FCamera in 'FCamera.pas' {FormCamera},
  Bcore85 in 'Bcore85.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'PapuaUtils';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TDlg5005, Dlg5005);
  Application.CreateForm(TFormBin2Swp, FormBin2Swp);
  Application.CreateForm(TFormCamera, FormCamera);
  Application.Run;
end.
