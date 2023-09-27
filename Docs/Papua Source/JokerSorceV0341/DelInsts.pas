unit DelInsts;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TFormDeleteInstance = class(TForm)
    GroupBox1: TGroupBox;
    CheckBoxIF1: TCheckBox;
    CheckBoxIF2: TCheckBox;
    CheckBoxIF3: TCheckBox;
    CheckBoxIF4: TCheckBox;
    CheckBoxIF5: TCheckBox;
    CheckBoxIF6: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDeleteInstance: TFormDeleteInstance;

implementation

{$R *.DFM}

end.
