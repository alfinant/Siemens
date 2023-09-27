object FormMobileName: TFormMobileName
  Left = 259
  Top = 111
  BorderStyle = bsDialog
  Caption = 'Name change'
  ClientHeight = 82
  ClientWidth = 259
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 20
    Width = 74
    Height = 13
    Caption = 'Mobile Name'
  end
  object EditName: TEdit
    Left = 104
    Top = 16
    Width = 129
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    Text = '?'
  end
  object BitBtn1: TBitBtn
    Left = 48
    Top = 48
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 144
    Top = 48
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
