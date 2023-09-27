unit NewSkey;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Spin;

type
  TFormNewSkey = class(TForm)
    Label1: TLabel;
    SpinEditSkey: TSpinEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    LabelImei: TLabel;
    LabelSecMode: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormNewSkey: TFormNewSkey;

implementation

{$R *.DFM}

end.
