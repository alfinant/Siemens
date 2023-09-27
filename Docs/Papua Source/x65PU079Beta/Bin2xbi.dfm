object FormBin2Swp: TFormBin2Swp
  Left = 267
  Top = 86
  BorderStyle = bsDialog
  Caption = 'Параметры для блока XBI'
  ClientHeight = 247
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object ButtonSaveXBI: TButton
    Left = 8
    Top = 208
    Width = 75
    Height = 25
    Caption = 'Save XBI'
    TabOrder = 0
    OnClick = ButtonSaveXBIClick
  end
  object ProgressBar: TProgressBar
    Left = 0
    Top = 237
    Width = 281
    Height = 10
    Align = alBottom
    Min = 0
    Max = 256
    Step = 1
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 16
    Width = 89
    Height = 153
    Hint = 'Блоки входяшие в выходной файл'
    Caption = 'Include'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    object CheckBoxBCORE: TCheckBox
      Left = 8
      Top = 16
      Width = 65
      Height = 17
      Caption = 'BCORE'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = CheckBoxEnKeysClick
    end
    object CheckBoxSW: TCheckBox
      Left = 8
      Top = 32
      Width = 65
      Height = 17
      Caption = 'SW'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      State = cbChecked
      TabOrder = 1
    end
    object CheckBoxLG: TCheckBox
      Left = 8
      Top = 48
      Width = 73
      Height = 17
      Caption = 'LgPack'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      State = cbChecked
      TabOrder = 2
    end
    object CheckBoxEEL: TCheckBox
      Left = 8
      Top = 64
      Width = 73
      Height = 17
      Caption = 'EELITE'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      State = cbChecked
      TabOrder = 3
      OnClick = CheckBoxEnKeysClick
    end
    object CheckBoxEEF: TCheckBox
      Left = 8
      Top = 80
      Width = 73
      Height = 17
      Caption = 'EEFULL'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      State = cbChecked
      TabOrder = 7
      OnClick = CheckBoxEnKeysClick
    end
    object CheckBoxFFSA: TCheckBox
      Left = 8
      Top = 96
      Width = 65
      Height = 17
      Caption = 'FFS(A)'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      State = cbChecked
      TabOrder = 4
      OnClick = CheckBoxFFSAClick
    end
    object CheckBoxFFSB: TCheckBox
      Left = 8
      Top = 112
      Width = 65
      Height = 17
      Caption = 'FFS_B'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      State = cbChecked
      TabOrder = 5
      OnClick = CheckBoxFFSBClick
    end
    object CheckBoxFFSC: TCheckBox
      Left = 8
      Top = 128
      Width = 65
      Height = 17
      Caption = 'FFS_C'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      State = cbChecked
      TabOrder = 6
    end
  end
  object GroupBox2: TGroupBox
    Left = 104
    Top = 80
    Width = 169
    Height = 81
    Caption = 'XBI Info'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object Label2: TLabel
      Left = 8
      Top = 28
      Width = 93
      Height = 16
      Caption = 'Mobile Name'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 52
      Width = 58
      Height = 16
      Caption = 'LG pack'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object EditMobName: TEdit
      Left = 112
      Top = 24
      Width = 41
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = 'S65'
    end
    object EditLGpack: TEdit
      Left = 120
      Top = 48
      Width = 33
      Height = 21
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      Text = 'lg3'
    end
  end
  object ButtonSWP: TButton
    Left = 88
    Top = 208
    Width = 97
    Height = 25
    Caption = 'Save UserSwup'
    TabOrder = 4
    OnClick = ButtonSWPClick
  end
  object Button1: TButton
    Left = 192
    Top = 208
    Width = 81
    Height = 25
    Caption = 'Close'
    ModalResult = 2
    TabOrder = 5
    OnClick = Button1Click
  end
  object GroupBox3: TGroupBox
    Left = 104
    Top = 8
    Width = 169
    Height = 65
    Caption = 'DB Name'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    object EditDataBaseName: TEdit
      Left = 16
      Top = 24
      Width = 137
      Height = 24
      Hint = 'Описание (произвольное)'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      Text = 'UserBackup'
    end
  end
  object CheckBoxKeys: TCheckBox
    Left = 8
    Top = 168
    Width = 249
    Height = 17
    Hint = 
      'Пересчитать все ключи в выходном фале по данным из вкладки "Коды' +
      '"'
    Caption = 'Recalks all keys from page "Codes" for outfile. '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 7
  end
  object CheckBoxClrFFA: TCheckBox
    Left = 8
    Top = 188
    Width = 113
    Height = 17
    Hint = 'Очищать диск A (FFS) в выходном файле.'
    Caption = 'Clear FFS (Disk A)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 8
  end
  object CheckBoxClrFFB: TCheckBox
    Left = 136
    Top = 188
    Width = 129
    Height = 17
    Hint = 'Очищать диск B (FFS_B) в выходном файле.'
    Caption = 'Clear FFS_B (Disk B)'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 9
  end
end
