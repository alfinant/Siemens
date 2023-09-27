unit About;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, SysUtils, ShellApi;

type
  TAboutBox = class(TForm)
    CopyrightAboutLabel: TImage;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    PhysMem: TLabel;
    Label4: TLabel;
    FreeRes: TLabel;
    Bevel2: TBevel;
    Label11: TLabel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Label10: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label26: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject);
    procedure Label10Click(Sender: TObject);
//    procedure Label13Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label26Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.DFM}

procedure TAboutBox.FormCreate(Sender: TObject);
var
  MS: TMemoryStatus;
begin
  GlobalMemoryStatus(MS);
  PhysMem.Caption := FormatFloat('#,###" KB"', MS.dwTotalPhys / 1024);
  FreeRes.Caption := Format('%d %%', [MS.dwMemoryLoad]);
end;

procedure TAboutBox.FormClose(Sender: TObject);
begin
    Close;
end;


procedure TAboutBox.Label10Click(Sender: TObject);
begin
   ShellExecute(Application.Handle, 'open',
               PChar('http://forum.allsiemens.com/viewtopic.php?t=17681'),
               nil, '', SW_SHOWNORMAL);
end;

{procedure TAboutBox.Label13Click(Sender: TObject);
begin
   ShellExecute(Application.Handle, 'open',
               PChar('http://forum.siemens-club.org'),
               nil, '', SW_SHOWNORMAL);
end;}

procedure TAboutBox.Label5Click(Sender: TObject);
begin
   ShellExecute(Application.Handle, 'open',
               PChar('http://siemensmania.cz'),
               nil, '', SW_SHOWNORMAL);
end;

procedure TAboutBox.Label1Click(Sender: TObject);
begin
   ShellExecute(Application.Handle, 'open',
               PChar('http://forum.siemens-club.org/viewtopic.php?TopicID=57595'),
               nil, '', SW_SHOWNORMAL);
end;

procedure TAboutBox.Label26Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open',
               PChar('http://papuas.allsiemens.com'),
               nil, '', SW_SHOWNORMAL);
end;

procedure TAboutBox.Label6Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, 'open',
               PChar('http://www.mobile-files.ru/forum/showthread.php?t=70711'),
               nil, '', SW_SHOWNORMAL);
end;

end.

