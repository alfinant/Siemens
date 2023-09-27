unit bin2wspMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,

  Swp, StdCtrls, ExtCtrls;

type
  TFormMain = class(TForm)
    Button1: TButton;
    RadioGroupBCORE: TRadioGroup;
    RadioGroupEEP: TRadioGroup;
    RadioGroupLG: TRadioGroup;
    RadioGroupFFS: TRadioGroup;
    RadioGroupSW: TRadioGroup;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses Bin2xbi;

{$R *.DFM}

procedure TFormMain.Button1Click(Sender: TObject);
begin
 FormBin2Swp.ShowModal;
end;

end.
