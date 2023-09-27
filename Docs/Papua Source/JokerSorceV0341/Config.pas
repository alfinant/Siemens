unit Config;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Spin, HexUtils, Buttons;

type
  TConfigDlg = class(TForm)
    CheckBoxLog: TCheckBox;
    GroupBoxDef: TGroupBox;
    SpinEditSkey: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    SpinEditM0: TSpinEdit;
    Label3: TLabel;
    SpinEditM1: TSpinEdit;
    Label4: TLabel;
    SpinEditM2: TSpinEdit;
    Label5: TLabel;
    SpinEditM3: TSpinEdit;
    Label6: TLabel;
    SpinEditM4: TSpinEdit;
    Label7: TLabel;
    SpinEditM5: TSpinEdit;
    EditBkey: TEdit;
    Label8: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConfigDlg: TConfigDlg;

implementation

{$R *.DFM}

end.
