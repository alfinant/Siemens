object FormDeleteInstance: TFormDeleteInstance
  Left = 309
  Top = 103
  Width = 233
  Height = 145
  Caption = 'Delete Instance'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 209
    Height = 73
    Caption = 'Select instances for removal '
    TabOrder = 0
    object CheckBoxIF1: TCheckBox
      Left = 8
      Top = 16
      Width = 97
      Height = 17
      Caption = 'Voice Memo'
      TabOrder = 0
    end
    object CheckBoxIF2: TCheckBox
      Left = 8
      Top = 32
      Width = 97
      Height = 17
      Caption = 'Voice Dialing'
      TabOrder = 1
    end
    object CheckBoxIF3: TCheckBox
      Left = 8
      Top = 48
      Width = 97
      Height = 17
      Caption = 'Browser Cache'
      TabOrder = 2
    end
    object CheckBoxIF4: TCheckBox
      Left = 112
      Top = 16
      Width = 89
      Height = 17
      Caption = 'File System'
      TabOrder = 3
    end
    object CheckBoxIF5: TCheckBox
      Left = 112
      Top = 32
      Width = 89
      Height = 17
      Caption = 'Tegic'
      TabOrder = 4
    end
    object CheckBoxIF6: TCheckBox
      Left = 112
      Top = 48
      Width = 89
      Height = 17
      Caption = 'Address Book'
      TabOrder = 5
    end
  end
  object BitBtn1: TBitBtn
    Left = 24
    Top = 88
    Width = 75
    Height = 25
    TabOrder = 1
    Kind = bkOK
  end
  object BitBtn2: TBitBtn
    Left = 128
    Top = 88
    Width = 75
    Height = 25
    TabOrder = 2
    Kind = bkCancel
  end
end
