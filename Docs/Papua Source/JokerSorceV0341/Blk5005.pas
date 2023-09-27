//Использование в коммерческих целях запрещено.
//Наказание - неминуемый кряк и распространение по всему инет.
//Business application is forbidden.
//Punishment - unavoidable crack and propagation on everything inet.
unit Blk5005;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Mask, Spin;

type
  TDlg5005 = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpinEditDm: TSpinEdit;
    SpinEditPr: TSpinEdit;
    SpinEditSW: TSpinEdit;
    SpinEditStd: TSpinEdit;
    SpinEditVar: TSpinEdit;
    MaskEditVarA: TMaskEdit;
    MaskEditDate: TMaskEdit;
    Label4: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Date_dd,Date_mm,Date_hh : integer;
  end;

var
  Dlg5005: TDlg5005;

implementation

{$R *.DFM}

procedure TDlg5005.ButtonOKClick(Sender: TObject);
var
s: string;
flg_err : boolean;
begin
      s:=MaskEditDate.Text;
      flg_err:=False;
      Date_dd:=(byte(s[2])-$30)+(byte(s[1])-$30)*10;
      if (Date_dd=0) or (Date_dd>31) then begin
       s[1]:='_';
       s[2]:='_';
       flg_err:=True;
      end;
      Date_mm:=(byte(s[5])-$30)+(byte(s[4])-$30)*10;
      if (Date_mm=0) or (Date_mm>12) then begin
       s[4]:='_';
       s[5]:='_';
       flg_err:=True;
      end;
      Date_hh:=(byte(s[8])-$30)+(byte(s[7])-$30)*10;
      if (Date_hh>15) then begin
       s[7]:='_';
       s[8]:='_';
       flg_err:=True;
      end;
      if flg_err then begin
       ModalResult:=mrNone;
       MaskEditDate.Text:=s;
       MaskEditDate.Setfocus;
       exit;
      end;
      ModalResult:=mrOk;
end;


end.
