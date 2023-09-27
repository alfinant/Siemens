unit x65bin2xbi;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, Menus, StdCtrls;

type
  TFormMain = class(TForm)
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    GroupBoxOp1: TGroupBox;
    CheckBoxBCORE: TCheckBox;
    CheckBoxSW: TCheckBox;
    CheckBoxEEP: TCheckBox;
    CheckBoxFFS: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.DFM}

end.
