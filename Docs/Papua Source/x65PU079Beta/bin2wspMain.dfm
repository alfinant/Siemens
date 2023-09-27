object FormMain: TFormMain
  Left = 251
  Top = 108
  Width = 468
  Height = 338
  Caption = 'FormMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 176
    Top = 128
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 0
    OnClick = Button1Click
  end
  object RadioGroupBCORE: TRadioGroup
    Left = 56
    Top = 16
    Width = 97
    Height = 49
    Caption = 'BCORE'
    ItemIndex = 0
    Items.Strings = (
      'пропустить'
      'включить')
    TabOrder = 1
  end
  object RadioGroupEEP: TRadioGroup
    Left = 56
    Top = 72
    Width = 97
    Height = 49
    Caption = 'EEPROM'
    ItemIndex = 1
    Items.Strings = (
      'пропустить'
      'включить')
    TabOrder = 2
  end
  object RadioGroupLG: TRadioGroup
    Left = 56
    Top = 128
    Width = 97
    Height = 49
    Caption = 'LG'
    ItemIndex = 1
    Items.Strings = (
      'пропустить'
      'включить')
    TabOrder = 3
  end
  object RadioGroupFFS: TRadioGroup
    Left = 48
    Top = 168
    Width = 97
    Height = 49
    Caption = 'FFS'
    ItemIndex = 1
    Items.Strings = (
      'пропустить'
      'включить')
    TabOrder = 4
  end
  object RadioGroupSW: TRadioGroup
    Left = 48
    Top = 216
    Width = 97
    Height = 49
    Caption = 'SW'
    ItemIndex = 1
    Items.Strings = (
      'пропустить'
      'включить')
    TabOrder = 5
  end
end
