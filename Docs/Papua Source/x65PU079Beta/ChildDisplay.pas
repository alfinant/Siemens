unit ChildDisplay;

interface

uses Windows, Messages, ShellAPI, Graphics, Controls, Forms,

 BFC;

type
  PChildDisp = ^TChildDisp;

  TChildDisp = class(TForm)
    Form: PControl;
    TBar: PControl;
    DispShow: PControl;
    procedure TBarTBShotClick(Sender: PControl; BtnID: Integer);
    procedure TBarTBSaveClick(Sender: PControl; BtnID: Integer);
    procedure TBarTBInfoClick(Sender: PControl; BtnID: Integer);
    procedure DispShowPaint(Sender: PControl; DC: HDC);
    procedure DispShowClick(Sender: PObj);
    procedure ChildFormClose(Sender: PObj; var Accept: Boolean);

  private
    { Private declarations }
    DispInfo: T_DisplayInfo;
    ClientInfo: T_DisplayBufferInfo;
    DispNumber: Byte;
    RealPic: PBitmap;
  public
    procedure SetDispNumber(Value: Byte);
    { Public declarations }
  end;

procedure NewChildDisp( var Result: PChildDisp; AParent: PControl );

implementation


const TBShot = 0;
const TBSave = 1;
const TBInfo = 2;


procedure NewChildDisp( var Result: PChildDisp; AParent: PControl );
begin

  New(Result,Create);
  with Result^ do begin
    Form := NewMdiChild( AParent, 'Dummy' ); //.SetClientSize( 132, 150 );
      Form.OnClose := ChildFormClose;
//    Windows.GetWindowRect(Result.Form.GetWindowHandle,R);

//  Result.Form.Add2AutoFree( Result );
    DeleteMenu( GetSystemMenu( Form.GetWindowHandle, False ), SC_CLOSE, MF_BYCOMMAND );
    DeleteMenu( GetSystemMenu( Form.GetWindowHandle, False ), SC_NEXTWINDOW, MF_BYCOMMAND );
    // Result.TBar.TabOrder = 0
    TBar := NewToolbar( Form, caTop, [tboNoDivider], THandle( -1 ), [ '', '', '' ], [ 1, 8, 12 ] ).SetAlign ( caTop );
      TBar.TBSetTooltips( TBar.TBIndex2Item( 0 ), [ 'Shot Display', 'Save file', 'Display Information' ] );
      TBar.TBAssignEvents( 0, [ TBarTBShotClick,TBarTBSaveClick,TBarTBInfoClick ] );
    // Result.DispShow.TabOrder = 1
    DispShow := NewPaintBox( Form ).SetAlign ( caClient );
      DispShow.OnPaint := DispShowPaint;
//      DispShow.OnClick := DispShowClick;
     Form.SetClientSize(132,176+TBar.Height);
    Form.Hide;
   end;
end;


procedure TChildDisp.SetDispNumber(Value: Byte);

begin
  DispNumber:=Value;
  Form.Caption:=Format('%d Display',[Value]);
  if not GetDisplayInformation(Value, DispInfo) then begin
    ShowMsg(Format('No information for display %d',[Value]), MB_OK or MB_ICONERROR);
    Exit;
  end;

  if not GetDisplayBufferInfo(DispInfo.ClientId, ClientInfo) then begin
    ShowMsg(Format('Client information obtaining error',[Value]), MB_OK or MB_ICONERROR);
    Exit;
  end;
//  Form.SetClientSize(DispInfo.Width,DispInfo.Height+TBar.Height);
  Form.SetClientSize(DispInfo.Width+4,DispInfo.Height+4+TBar.Height);
  if RealPic<>nil then RealPic.Free;
//  RealPic:=NewBitmap(DispInfo.Width,DispInfo.Height);
  RealPic:=NewBitmap(DispInfo.Width,DispInfo.Height);
  Form.Show;
end;


procedure TChildDisp.DispShowPaint(Sender: PControl; DC: HDC);
var
 R: TRect;
begin
  R:=DispShow.ClientRect;
  if RealPic<>nil then begin
    RealPic.StretchDraw(DC,R);
  end else begin
    Windows.FillRect(DC,R,0);
    Windows.SetTextColor(DC,clRed);
    Windows.TextOut(DC,0,0,'No image',8);
  end;
end;

procedure TChildDisp.TBarTBShotClick(Sender: PControl; BtnID: Integer);

var
 Buf: array [0..4095] of word;
 Buf2: array [0..8191] of byte;
 X,Y, LineSize, CopySize: Integer;
begin
//  if TestComSpy then exit;
  RealPic.PixelFormat:=pf24bit;
  case ClientInfo.DataType of
    E_DISP_1BIT : begin
                    LineSize:=ClientInfo.Width shr 3;
                    RealPic.PixelFormat:=pf1bit;
                  end;
    E_DISP_8BIT_RGB332 :    LineSize:=ClientInfo.Width;
    E_DISP_12BIT_RGB444 :   LineSize:=ClientInfo.Width+ClientInfo.Width shr 1 + ClientInfo.Width and 1;
    E_DISP_16BIT_RGB565 :   LineSize:=ClientInfo.Width shl 1;
//    E_DISP_18BIT_RGB666 :   SizeDisplayBuffer := SizeDisplayBuffer shl 1 + (SizeDisplayBuffer shr 2) + (SizeDisplayBuffer and 3);
//    E_DISP_24BIT_RGB888 :   SizeDisplayBuffer := SizeDisplayBuffer + (SizeDisplayBuffer shl 1);
  else
    LineSize:=ClientInfo.Width;
  end;

//  PhoneImage.Clear;
  if RealPic.ScanlineSize>LineSize then CopySize:=LineSize else CopySize:=RealPic.ScanlineSize;
  for Y:=0 to ClientInfo.Height-1 do begin
   if not BFCReadMem(ClientInfo.BufferAddress+Y*LineSize,LineSize,Buf2) then begin
    ShowMsg('Cannot read memory', MB_OK or MB_ICONERROR);
    Exit;
   end;
   Move(Buf2,Buf,SizeOf(Buf));
   case ClientInfo.DataType of
     E_DISP_16BIT_RGB565: for X:=0 to ClientInfo.Width-1 do begin
         //BBBBBGGGGGGRRRRR
         //1111 1000 0000 0000
         realPic.Pixels[x,y]:= (Buf[X] and $1F shl (3+16)) or (Buf[X] and $7E0 shl 5) or (Buf[X] and $F800 shr 8);
     end;
   else
     Move(Buf,RealPic.ScanLine[Y]^,CopySize);
   end;
   DispShow.Invalidate;
   Form.ProcessPendingMessages;
  end;
end;

procedure TChildDisp.TBarTBSaveClick(Sender: PControl; BtnID: Integer);
var
 P: POpenSaveDialog;
begin
 if RealPic=Nil then Exit;
 P:=NewOpenSaveDialog('Save ScreenShot to ...','',[ OSCreatePrompt, OSHideReadonly, OSOverwritePrompt, OSPathMustExist ]);
 P.Filter := 'BMP files|*.bmp|All files|*.*';
 P.OpenDialog := FALSE;
 P.DefExtension := 'BMP';

 if P.Execute then begin
  RealPic.SaveToFile(P.Filename);
 end;
 P.Free;
end;

procedure TChildDisp.TBarTBInfoClick(Sender: PControl; BtnID: Integer);
begin
 with ClientInfo do ShowMsg(Format('Display %d information:'^J'Client %d, Size %dx%d, Mode %d'^J^J'When screenshot is garbaged,'^J'email this info and screenshot to author.',[DispNumber,ClientId,Width,Height, Ord(DataType)]),MB_OK or MB_ICONINFORMATION);
end;

procedure TChildDisp.DispShowClick(Sender: PObj);
begin
 //
end;

procedure TChildDisp.ChildFormClose(Sender: PObj; var Accept: Boolean);
begin
 if RealPic<>Nil then RealPic.Free;
end;

end.