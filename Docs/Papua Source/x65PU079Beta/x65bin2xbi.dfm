object FormMain: TFormMain
  Left = 439
  Top = 331
  Width = 436
  Height = 302
  Caption = 'FormMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 428
    Height = 227
    Align = alClient
    BevelOuter = bvLowered
    TabOrder = 0
    object GroupBoxOp1: TGroupBox
      Left = 16
      Top = 24
      Width = 97
      Height = 105
      Caption = 'OutBlocks'
      TabOrder = 0
      object CheckBoxBCORE: TCheckBox
        Left = 8
        Top = 24
        Width = 73
        Height = 17
        Caption = 'BCORE'
        TabOrder = 0
      end
      object CheckBoxSW: TCheckBox
        Left = 8
        Top = 40
        Width = 73
        Height = 17
        Caption = 'SWCODE'
        Checked = True
        State = cbChecked
        TabOrder = 1
      end
      object CheckBoxEEP: TCheckBox
        Left = 8
        Top = 56
        Width = 73
        Height = 17
        Caption = 'EEPROM'
        Checked = True
        State = cbChecked
        TabOrder = 2
      end
      object CheckBoxFFS: TCheckBox
        Left = 8
        Top = 72
        Width = 49
        Height = 17
        Caption = 'FFS'
        Checked = True
        State = cbChecked
        TabOrder = 3
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 237
    Width = 428
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 227
    Width = 428
    Height = 10
    Align = alBottom
    Min = 0
    Max = 100
    TabOrder = 2
  end
  object OpenDialog1: TOpenDialog
    Left = 504
    Top = 24
  end
  object SaveDialog1: TSaveDialog
    Left = 504
    Top = 56
  end
  object MainMenu1: TMainMenu
    Left = 504
    Top = 88
    object N1: TMenuItem
      Caption = 'װאיכû'
    end
  end
end
