unit FCamera;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, jpeg, Menus;

type
  TFormCamera = class(TForm)
    Image: TImage;
    PopupMenu: TPopupMenu;
    N111: TMenuItem;
    N121: TMenuItem;
    Stop: TMenuItem;
    N320x2401: TMenuItem;
    N640x4801: TMenuItem;
    N160x1201: TMenuItem;
    Close1: TMenuItem;
    procedure N111Click(Sender: TObject);
    procedure N121Click(Sender: TObject);
    procedure N160x1201Click(Sender: TObject);
    procedure N320x2401Click(Sender: TObject);
    procedure N640x4801Click(Sender: TObject);
    procedure StopClick(Sender: TObject);
    procedure Close1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Off : boolean;
  end;

var
  FormCamera: TFormCamera;

implementation

{$R *.DFM}

procedure TFormCamera.N111Click(Sender: TObject);
begin
    ClientHeight:=Image.Picture.Height;
    ClientWidth:=Image.Picture.Width;
end;

procedure TFormCamera.N121Click(Sender: TObject);
begin
    ClientHeight:=Image.Picture.Height shl 1;
    ClientWidth:=Image.Picture.Width shl 1;
end;

procedure TFormCamera.N160x1201Click(Sender: TObject);
begin
    ClientHeight:=120;
    ClientWidth:=160;
end;

procedure TFormCamera.N320x2401Click(Sender: TObject);
begin
    ClientHeight:=240;
    ClientWidth:=320;
end;

procedure TFormCamera.N640x4801Click(Sender: TObject);
begin
    ClientHeight:=480;
    ClientWidth:=640;
end;

procedure TFormCamera.StopClick(Sender: TObject);
begin
    Off:=True;
end;

procedure TFormCamera.Close1Click(Sender: TObject);
begin
  Close;
end;

end.
