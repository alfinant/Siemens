object FormNewSkey: TFormNewSkey
  Left = 651
  Top = 172
  BorderStyle = bsDialog
  Caption = 'Send Skey'
  ClientHeight = 105
  ClientWidth = 195
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = False
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 44
    Width = 66
    Height = 13
    Caption = 'Input SKEY'
  end
  object LabelImei: TLabel
    Left = 24
    Top = 8
    Width = 147
    Height = 13
    Caption = 'IMEI: 1234567890123456'
  end
  object LabelSecMode: TLabel
    Left = 32
    Top = 24
    Width = 128
    Height = 13
    Caption = 'SecurityMode: Factory'
  end
  object SpinEditSkey: TSpinEdit
    Left = 96
    Top = 40
    Width = 89
    Height = 22
    MaxValue = 99999999
    MinValue = 1
    TabOrder = 0
    Value = 12345678
  end
  object BitBtn1: TBitBtn
    Left = 16
    Top = 72
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 104
    Top = 72
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
