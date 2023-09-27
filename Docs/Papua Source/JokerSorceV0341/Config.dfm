object ConfigDlg: TConfigDlg
  Left = 203
  Top = 135
  BorderStyle = bsDialog
  Caption = 'Config options'
  ClientHeight = 183
  ClientWidth = 324
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
  object CheckBoxLog: TCheckBox
    Left = 8
    Top = 156
    Width = 105
    Height = 17
    Caption = 'Save LogFiles'
    TabOrder = 0
  end
  object GroupBoxDef: TGroupBox
    Left = 8
    Top = 0
    Width = 313
    Height = 145
    Caption = 'Default keys'
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 20
      Width = 33
      Height = 13
      Caption = 'SKEY'
    end
    object Label2: TLabel
      Left = 8
      Top = 44
      Width = 47
      Height = 13
      Caption = '*#0000*'
    end
    object Label3: TLabel
      Left = 8
      Top = 68
      Width = 47
      Height = 13
      Caption = '*#0001*'
    end
    object Label4: TLabel
      Left = 8
      Top = 92
      Width = 47
      Height = 13
      Caption = '*#0002*'
    end
    object Label5: TLabel
      Left = 168
      Top = 44
      Width = 47
      Height = 13
      Caption = '*#0003*'
    end
    object Label6: TLabel
      Left = 168
      Top = 68
      Width = 47
      Height = 13
      Caption = '*#0004*'
    end
    object Label7: TLabel
      Left = 168
      Top = 92
      Width = 47
      Height = 13
      Caption = '*#0005*'
    end
    object Label8: TLabel
      Left = 16
      Top = 120
      Width = 33
      Height = 13
      Caption = 'BKEY'
    end
    object SpinEditSkey: TSpinEdit
      Left = 64
      Top = 16
      Width = 81
      Height = 22
      MaxValue = 99999999
      MinValue = 1
      TabOrder = 0
      Value = 12345678
    end
    object SpinEditM0: TSpinEdit
      Left = 64
      Top = 40
      Width = 81
      Height = 22
      MaxValue = 99999999
      MinValue = 1
      TabOrder = 1
      Value = 12345678
    end
    object SpinEditM1: TSpinEdit
      Left = 64
      Top = 64
      Width = 81
      Height = 22
      MaxValue = 99999999
      MinValue = 1
      TabOrder = 2
      Value = 12345678
    end
    object SpinEditM2: TSpinEdit
      Left = 64
      Top = 88
      Width = 81
      Height = 22
      MaxValue = 99999999
      MinValue = 1
      TabOrder = 3
      Value = 12345678
    end
    object SpinEditM3: TSpinEdit
      Left = 224
      Top = 40
      Width = 81
      Height = 22
      MaxValue = 99999999
      MinValue = 1
      TabOrder = 4
      Value = 12345678
    end
    object SpinEditM4: TSpinEdit
      Left = 224
      Top = 64
      Width = 81
      Height = 22
      MaxValue = 99999999
      MinValue = 1
      TabOrder = 5
      Value = 12345678
    end
    object SpinEditM5: TSpinEdit
      Left = 224
      Top = 88
      Width = 81
      Height = 22
      MaxValue = 99999999
      MinValue = 1
      TabOrder = 6
      Value = 12345678
    end
    object EditBkey: TEdit
      Left = 64
      Top = 116
      Width = 241
      Height = 21
      BiDiMode = bdLeftToRight
      CharCase = ecUpperCase
      ParentBiDiMode = False
      TabOrder = 7
      Text = '6E75747A6F6973746865626573740000'
    end
  end
  object BitBtn1: TBitBtn
    Left = 144
    Top = 152
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 240
    Top = 152
    Width = 75
    Height = 25
    TabOrder = 3
    Kind = bkCancel
  end
end
