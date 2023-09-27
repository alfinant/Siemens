object FormMain: TFormMain
  Left = 284
  Top = 149
  Width = 695
  Height = 486
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Joker Siemens EGOLD Phone Version 0.3.4.1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MemoInfo: TMemo
    Left = 409
    Top = 0
    Width = 278
    Height = 449
    Align = alClient
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object ProgressBar: TProgressBar
    Left = 0
    Top = 449
    Width = 687
    Height = 10
    Align = alBottom
    Min = 0
    Max = 100
    Step = 2
    TabOrder = 1
  end
  object PanelMain: TPanel
    Left = 0
    Top = 0
    Width = 409
    Height = 449
    Align = alLeft
    TabOrder = 2
    object PageControl1: TPageControl
      Left = 136
      Top = 182
      Width = 265
      Height = 259
      ActivePage = TabSheet1
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = 'Flash'
        object Panel1: TPanel
          Left = 0
          Top = 0
          Width = 257
          Height = 231
          Align = alClient
          BevelOuter = bvLowered
          TabOrder = 0
          object RadioGroupFlash: TRadioGroup
            Left = 8
            Top = 8
            Width = 105
            Height = 177
            Caption = 'Flash'
            ItemIndex = 8
            Items.Strings = (
              'FullFlash'
              'BCORE'
              'EEPROM'
              'LangPack'
              'T9'
              'EE_FS'
              'FFS(A)'
              'FFS_B'
              'FFS_C'
              'Manual')
            TabOrder = 0
            OnClick = RadioGroupFlashClick
          end
          object ButtonRead: TButton
            Left = 16
            Top = 192
            Width = 89
            Height = 25
            Hint = 'Чтение выбранного участка флэш'
            Caption = 'Read'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = ButtonReadClick
          end
          object GroupBoxFManual: TGroupBox
            Left = 120
            Top = 8
            Width = 129
            Height = 73
            Caption = 'Manual'
            TabOrder = 2
            object Label1: TLabel
              Left = 12
              Top = 22
              Width = 28
              Height = 13
              Caption = 'Start'
            end
            object Label2: TLabel
              Left = 12
              Top = 46
              Width = 25
              Height = 13
              Caption = 'Size'
            end
            object MaskEditAddr: TMaskEdit
              Left = 56
              Top = 18
              Width = 57
              Height = 21
              Hint = 'Базовый адрес блока флэш  (HEX)'
              EditMask = '>A>A:\0\0\0\0;0;_'
              MaxLength = 7
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnChange = MaskEditAddrChange
            end
            object MaskEditSize: TMaskEdit
              Left = 50
              Top = 42
              Width = 63
              Height = 21
              Hint = 'Размер блока флэш (HEX)'
              EditMask = '>0>A>A:\0\0\0\0;0;_'
              MaxLength = 8
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnChange = MaskEditSizeChange
            end
          end
          object GroupBox1: TGroupBox
            Left = 120
            Top = 88
            Width = 129
            Height = 137
            Caption = 'Write Flash'
            TabOrder = 3
            object CheckBoxBcorePr: TCheckBox
              Left = 8
              Top = 16
              Width = 105
              Height = 17
              Hint = 'Запрет записи в облать BCORE'
              Caption = 'Protect BCore'
              Checked = True
              Enabled = False
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 0
              OnClick = CheckBoxBcorePrClick
            end
            object CheckBoxReCalcKeys: TCheckBox
              Left = 8
              Top = 32
              Width = 97
              Height = 17
              Hint = 'Пересчет ключей при записи флэш'
              Caption = 'ReCalc Keys'
              Checked = True
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 1
            end
            object CheckBoxBkEEP: TCheckBox
              Left = 8
              Top = 48
              Width = 113
              Height = 17
              Hint = 
                'Сохранить заводские  и секретные блоки 67, 76, 5005, 5007, 5008,' +
                ' 5009, 5012, 5077, 5093, 5121, 5122, 5123 перед записью'
              Caption = 'Backup F.S.EEP'
              Checked = True
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 2
              OnClick = CheckBoxBkEEPClick
            end
            object CheckBoxPrFacEEP: TCheckBox
              Left = 8
              Top = 64
              Width = 113
              Height = 17
              Hint = 
                'Не менять заводские блоки 67, 5005, 5007, 5012, 5093 при записи ' +
                'EEPROM области.'
              Caption = 'Protect Fac.EEP'
              Checked = True
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 3
              OnClick = CheckBoxPrFacEEPClick
            end
            object ButtonWrite: TButton
              Left = 32
              Top = 104
              Width = 65
              Height = 25
              Hint = 'Зпись выбранного участка флэш. Test Only!'
              Caption = 'Write'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 4
              OnClick = ButtonWriteClick
            end
            object CheckBoxClrBC: TCheckBox
              Left = 8
              Top = 80
              Width = 113
              Height = 17
              Hint = 'Подготовка BCORE для Freeze'
              Caption = 'Prepared BCore'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 5
              OnClick = CheckBoxClrBCClick
            end
          end
        end
      end
      object TabSheet2: TTabSheet
        Caption = 'Skey'
        ImageIndex = 1
        object Panel2: TPanel
          Left = 0
          Top = 0
          Width = 257
          Height = 231
          Align = alClient
          BevelOuter = bvLowered
          TabOrder = 0
          object GroupBox3: TGroupBox
            Left = 20
            Top = 4
            Width = 209
            Height = 89
            Caption = 'Skey'
            TabOrder = 0
            object ButtonSendSkey: TButton
              Left = 112
              Top = 16
              Width = 89
              Height = 25
              Hint = 
                'Ввод Skey в телефон, для открытия всех функций. Повторный ввод о' +
                'тключает Skey.'
              Caption = 'Send Skey'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = ButtonSendSkeyClick
            end
            object CheckBoxSaveSecBlkOTP: TCheckBox
              Left = 8
              Top = 48
              Width = 185
              Height = 17
              Hint = 
                'Создать файл c блоками 76,5008,5009,5077,5121,5122,5123  по данн' +
                'ым из OTP для записи в Siemens EEPROM Tool.'
              Caption = 'Create file SecBlocks (OTP IMEI)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              OnClick = CheckBoxSaveSecBlkOTPClick
            end
            object CheckBoxSaveSecBlkEEP: TCheckBox
              Left = 8
              Top = 64
              Width = 185
              Height = 17
              Hint = 
                'Создать файл c блоками 76,5008,5009,5077,5121,5122,5123  по данн' +
                'ым из EEPROM для записи в Siemens EEPROM Tool.'
              Caption = 'Create file SecBlocks (EEP IMEI)'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              OnClick = CheckBoxSaveSecBlkEEPClick
            end
            object ButtonSkey: TButton
              Left = 8
              Top = 16
              Width = 89
              Height = 25
              Hint = 'Чтение ключей через бутлоадер и расчет Skey'
              Caption = 'Calc Skey'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = ButtonSkeyClick
            end
          end
          object GroupBox2: TGroupBox
            Left = 20
            Top = 96
            Width = 209
            Height = 97
            Caption = 'Joker'
            Color = clBtnFace
            ParentColor = False
            ParentShowHint = False
            ShowHint = False
            TabOrder = 1
            object Image1: TImage
              Left = 152
              Top = 16
              Width = 49
              Height = 49
              Picture.Data = {
                055449636F6E0000010001003030000000000000A80E00001600000028000000
                30000000600000000100080000000000800A0000000000000000000000000000
                0000000000000000000080000080000000808000800000008000800080800000
                C0C0C000C0DCC000F0CAA60004040400080808000C0C0C001111110016161600
                1C1C1C002222220029292900555555004D4D4D004242420039393900807CFF00
                5050FF009300D600FFECCC00C6D6EF00D6E7E70090A9AD000000330000006600
                000099000000CC00003300000033330000336600003399000033CC000033FF00
                006600000066330000666600006699000066CC000066FF000099000000993300
                00996600009999000099CC000099FF0000CC000000CC330000CC660000CC9900
                00CCCC0000CCFF0000FF660000FF990000FFCC00330000003300330033006600
                330099003300CC003300FF00333300003333330033336600333399003333CC00
                3333FF00336600003366330033666600336699003366CC003366FF0033990000
                3399330033996600339999003399CC003399FF0033CC000033CC330033CC6600
                33CC990033CCCC0033CCFF0033FF330033FF660033FF990033FFCC0033FFFF00
                660000006600330066006600660099006600CC006600FF006633000066333300
                66336600663399006633CC006633FF0066660000666633006666660066669900
                6666CC00669900006699330066996600669999006699CC006699FF0066CC0000
                66CC330066CC990066CCCC0066CCFF0066FF000066FF330066FF990066FFCC00
                CC00FF00FF00CC009999000099339900990099009900CC009900000099333300
                990066009933CC009900FF00996600009966330099336600996699009966CC00
                9933FF009999330099996600999999009999CC009999FF0099CC000099CC3300
                66CC660099CC990099CCCC0099CCFF0099FF000099FF330099CC660099FF9900
                99FFCC0099FFFF00CC00000099003300CC006600CC009900CC00CC0099330000
                CC333300CC336600CC339900CC33CC00CC33FF00CC660000CC66330099666600
                CC669900CC66CC009966FF00CC990000CC993300CC996600CC999900CC99CC00
                CC99FF00CCCC0000CCCC3300CCCC6600CCCC9900CCCCCC00CCCCFF00CCFF0000
                CCFF330099FF6600CCFF9900CCFFCC00CCFFFF00CC003300FF006600FF009900
                CC330000FF333300FF336600FF339900FF33CC00FF33FF00FF660000FF663300
                CC666600FF669900FF66CC00CC66FF00FF990000FF993300FF996600FF999900
                FF99CC00FF99FF00FFCC0000FFCC3300FFCC6600FFCC9900FFCCCC00FFCCFF00
                FFFF3300CCFF6600FFFF9900FFFFCC006666FF0066FF660066FFFF00FF666600
                FF66FF00FFFF66002100A5005F5F5F00777777008686860096969600CBCBCB00
                B2B2B200D7D7D700DDDDDD00E3E3E300EAEAEA00F1F1F100F8F8F800F0FBFF00
                A4A0A000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
                FFFFFF000A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0C4314141414141414
                1414141414141414141414141414141414141414141414141414141414141410
                0A0A0A0A0A0A43BCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4EC0C0A0A0A10F2FFFFFFFFFFFFFFFFBC
                F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF307F7ECEFFFFFFFFFFFFFFFFFFFFFFF
                FFEC0A0A0AECFFFFFFFFFFFFFFFFFFF407ECF7F0F4FFFFFFFFFFF4F3F0EFECEC
                ED07F2FFFFFFFFFFFFFFFFFFFFFFFFFFFFF4100A0AEFFFFFFFFFFFFFFFFFFFFF
                FFFFF2F714F814141415430E0A0A0CF4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFF120A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFEBED0C0A0A0A0A0A0A0A0EFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFF0713100A0A0A0A0A0A0A0EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFF415430A0A0A0A0A0A0A0CFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFF920C0A0A0A0A0A0A0A0CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF30C0A0A0A0A0A0A0A0EF4
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFEA0A0A0A0A0A0A0A0CBCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEB0A0A0A0A0A0A0A0AEC
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFEB0A0A0A0A0A0A0A0A11F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6D0A0A0A0A0A0A0A0A0A
                EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFF6D0A0A0A0A0A0A0A0A0A6DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF120A0A0A0A0A0A0A0A0A
                43FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFF120A0A0A0A0A0A0A0A0A10F4FFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF140A0A0A0A0A0A0A0A0A
                10F2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFF150A0A0A0A0A0A0A0A0A10F2FFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF100A0A0A0A0A0A0A0A0A
                10F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFF110A0A0A0A0A0A0A0A0A10F4FFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF150A0A0A0A0A0A0A0A0A
                11FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFEA0A0A0A0A0A0A0A0A0A43FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF920A0A0A0A0A0A0A0A0A
                14FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFF2100A0A0A0A0A0A0A0A6DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEC0A0A0A0A0A0A0A0A
                F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFF3100A0A0A0A0A0A0AF8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEC0A0A0A0A0A0A0A
                12FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFF00A0A0A0A0A0A0A0CF7FFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEF0A0A0A0A0A0C6D
                F70EEDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFF6D0A0A0A0A0E07FFFFBC116DF4FFFFFFFFFFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF130A0A0A0A0ABCFF
                FFFFF11412F3FFFFFFFFFFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFEC0A0A0A0A0A07FFFFFFFFF46D1107FFFFFFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00A0A0A0A0CF0FF
                FFFFFFFFF2110FEFFFFFFFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFF130A0A0A10F3FFFFFFFFBC430A0A0C07FFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF070C0A0A13FFFF
                FFFFEC0C0A0A0C6D11F2FFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFF6D0A0CEFFFFFF2120A0A0A0CF8FFF1FFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF26DECFFFFEF
                100A0A0A0AF8FFFFFFFFFFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFF07130A0A0A0A0CECFFFFFFFFFFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4BC6D0E0A0A
                0A0A0FEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEA0A0A07FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFF3F7140C0A0A0A0A0AEAF1FFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFFEA0A0A07FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF392120C0A0A0A0A0A0CEA
                BCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEA0A0A92FFFFFFFFFFFFFFFFFFFF
                FFFFFFFFF49243110F101011EAEDF0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                FFFF150A0A12FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4F2F2F3F4FFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBC0C0A0A0AECFFFFFFFFFFFFFFFFFF
                FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
                F2430A0A0A0A0A12920707070707070707070707070707070707070707070707
                0707070707070707070707070707EFEC100A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A0A
                0A0A0A0AC0000000000300008000000000010000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                0000000000000000000000000000000000000000000000000000000000000000
                00000000000000000000000000000000000000008000000000010000C0000000
                00030000}
            end
            object CheckBoxExtIMEI: TCheckBox
              Left = 8
              Top = 70
              Width = 68
              Height = 17
              Hint = 'Использовать ручной ввод IMEI.'
              Caption = 'Use IMEI:'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = CheckBoxExtIMEIClick
            end
            object EditJImei: TEdit
              Left = 80
              Top = 68
              Width = 121
              Height = 21
              TabOrder = 1
              Text = '123456789012347'
              OnChange = EditJImeiChange
            end
            object CheckBoxUseOTPImei: TCheckBox
              Left = 8
              Top = 48
              Width = 97
              Height = 17
              Hint = 'Использовать OTP данные.'
              Caption = 'Use OTP IMEI'
              Checked = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              ParentFont = False
              ParentShowHint = False
              ShowHint = True
              State = cbChecked
              TabOrder = 2
              OnClick = CheckBoxUseOTPImeiClick
            end
            object ButtonReCalcKey: TButton
              Left = 8
              Top = 16
              Width = 129
              Height = 25
              Hint = 'Пересчет всех ключей и секретных блоков'
              Caption = 'ReCalc All Keys'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 3
              OnClick = ButtonReCalcKeyClick
            end
          end
          object ButtonBFEEP: TButton
            Left = 24
            Top = 200
            Width = 89
            Height = 25
            Hint = 
              'Считать и сохранить заводские  и секретные блоки 67, 76, 5005, 5' +
              '007, 5008, 5009, 5012, 5077, 5093, 5121, 5122, 5123.'
            Caption = 'Read F.EEP'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = ButtonBFEEPClick
          end
          object ButtonNameCh: TButton
            Left = 128
            Top = 200
            Width = 97
            Height = 25
            Caption = 'Name change'
            TabOrder = 3
            OnClick = ButtonNameChClick
          end
        end
      end
      object TabSheet3: TTabSheet
        Caption = 'Service'
        ImageIndex = 2
        object Panel5: TPanel
          Left = 0
          Top = 0
          Width = 257
          Height = 231
          Align = alClient
          BevelOuter = bvLowered
          TabOrder = 0
          object ButtonSimSim: TButton
            Left = 16
            Top = 200
            Width = 113
            Height = 25
            Hint = 'Эмуляция СИМ карты'
            Caption = 'Simulate SIM'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = ButtonSimSimClick
          end
          object ButtonPhoneOff: TButton
            Left = 152
            Top = 8
            Width = 89
            Height = 25
            Hint = 'Отключить телефон'
            Caption = 'Phone Off'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = ButtonPhoneOffClick
          end
          object ButtonSrvm: TButton
            Left = 16
            Top = 8
            Width = 113
            Height = 25
            Hint = 'Загрузить телефон в Service Mode'
            Caption = 'Service Mode'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = ButtonSrvmClick
          end
          object ButtonMasterKeys: TButton
            Left = 16
            Top = 136
            Width = 113
            Height = 25
            Hint = 'Рассчитать Мастер ключи'
            Caption = '5121 Master Keys'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnClick = ButtonMasterKeysClick
          end
          object ButtonPhoneCode: TButton
            Left = 16
            Top = 104
            Width = 113
            Height = 25
            Hint = 'Просмотр блокировок телефона'
            Caption = '5008 Phone Code'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            OnClick = ButtonPhoneCodeClick
          end
          object ButtonDelInst: TButton
            Left = 152
            Top = 200
            Width = 89
            Height = 25
            Hint = 'Формат (очистка) разделов телефона'
            Caption = 'Del Instances'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            OnClick = ButtonDelInstClick
          end
          object Button5005: TButton
            Left = 16
            Top = 168
            Width = 113
            Height = 25
            Hint = 'Чтение и модификация версий MAP и даты изготовления телефона'
            Caption = '5005 Map Info'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 6
            OnClick = Button5005Click
          end
          object ButtonBackupEEP: TButton
            Left = 152
            Top = 104
            Width = 89
            Height = 25
            Hint = 'Сохранение всех блоков EEPROM'
            Caption = 'Backup EEP'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 7
            OnClick = ButtonBackupEEPClick
          end
          object ButtonRdKeys: TButton
            Left = 8
            Top = 72
            Width = 129
            Height = 25
            Hint = 'Считать данные в режиме Service Mode и рассчитать ключ Skey.'
            Caption = 'Read and Calc Keys'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 8
            OnClick = ButtonRdKeysClick
          end
          object CheckBoxSrvCreateBlk: TCheckBox
            Left = 144
            Top = 76
            Width = 105
            Height = 17
            Hint = 
              'Пересчитать блоки 76,5008,5009,5077,5121,5122,5123 и записать в ' +
              'файл или в телефон.'
            Caption = 'Create Blocks'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 9
          end
          object ButtonDefragEEP: TButton
            Left = 152
            Top = 136
            Width = 89
            Height = 25
            Hint = 'Дефрагментация областей EEPROM'
            Caption = 'Defrag EEP'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 10
            OnClick = ButtonDefragEEPClick
          end
          object ButtonInfoBFB: TButton
            Left = 152
            Top = 40
            Width = 89
            Height = 25
            Hint = 'Чтение информации в Нормальном и Сервисном режиме'
            Caption = 'Info'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 11
            OnClick = ButtonInfoBFBClick
          end
          object ButtonNormMode: TButton
            Left = 16
            Top = 40
            Width = 113
            Height = 25
            Caption = 'Normal Mode'
            TabOrder = 12
            OnClick = ButtonNormModeClick
          end
          object ButtonRdEepFile: TButton
            Left = 152
            Top = 168
            Width = 89
            Height = 25
            Hint = 'Запись блоков EEPROM из файла в телефон.'
            Caption = 'Write EEP'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 13
            OnClick = ButtonRdEepFileClick
          end
        end
      end
      object TabSheet4: TTabSheet
        Caption = 'Contrast'
        ImageIndex = 3
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 257
          Height = 231
          Align = alClient
          BevelOuter = bvLowered
          TabOrder = 0
          object LabelContrast: TLabel
            Left = 152
            Top = 158
            Width = 55
            Height = 13
            Caption = '45,45 0,0'
          end
          object ButtonSetContrast: TButton
            Left = 16
            Top = 152
            Width = 105
            Height = 25
            Hint = 'Проверить уровень конраста'
            Caption = 'Test Contrast1'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = ButtonSetContrastClick
          end
          object ScrollBarContrast1: TScrollBar
            Left = 8
            Top = 100
            Width = 241
            Height = 10
            Hint = 'Контраст для Display1'
            LargeChange = 10
            Max = 255
            PageSize = 0
            ParentShowHint = False
            Position = 45
            ShowHint = True
            TabOrder = 1
            OnChange = ScrollBarContrast1Change
          end
          object ButtonRead5007: TButton
            Left = 16
            Top = 192
            Width = 97
            Height = 25
            Hint = 'Прочитать установки контрастов дисплеев'
            Caption = '5007 Read'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = ButtonRead5007Click
          end
          object ButtonWrite5007: TButton
            Left = 144
            Top = 192
            Width = 97
            Height = 25
            Hint = 'Записать установки контрастов дисплеев'
            Caption = '5007 Write'
            Enabled = False
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnClick = ButtonWrite5007Click
          end
          object ButtonLightOff: TButton
            Left = 40
            Top = 56
            Width = 75
            Height = 25
            Hint = 'Отключить подсветку'
            Caption = 'Light Off'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            OnClick = ButtonLightOffClick
          end
          object ButtonLightOn: TButton
            Left = 152
            Top = 56
            Width = 75
            Height = 25
            Hint = 'Включить подсветку'
            Caption = 'Light On'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 5
            OnClick = ButtonLightOnClick
          end
          object ButtonSrvm1: TButton
            Left = 16
            Top = 20
            Width = 113
            Height = 25
            Hint = 'Загрузить телефон в Service Mode'
            Caption = 'Service Mode'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 6
            OnClick = ButtonSrvmClick
          end
          object ButtonPhoneOff1: TButton
            Left = 152
            Top = 20
            Width = 89
            Height = 25
            Hint = 'Отключить телефон'
            Caption = 'Phone Off'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 7
            OnClick = ButtonPhoneOffClick
          end
          object ScrollBarContrast2: TScrollBar
            Left = 8
            Top = 124
            Width = 241
            Height = 10
            Hint = 'Контраст для Display2'
            LargeChange = 10
            Max = 255
            PageSize = 0
            ParentShowHint = False
            ShowHint = True
            TabOrder = 8
            OnChange = ScrollBarContrast2Change
          end
        end
      end
      object TabSheet5: TTabSheet
        Caption = '?'
        ImageIndex = 4
        object Panel4: TPanel
          Left = 0
          Top = 0
          Width = 257
          Height = 231
          Align = alClient
          BevelOuter = bvLowered
          TabOrder = 0
          object ButtonSrvm2: TButton
            Left = 16
            Top = 24
            Width = 113
            Height = 25
            Hint = 'Загрузить телефон в Service Mode'
            Caption = 'Service Mode'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = ButtonSrvmClick
          end
          object ButtonPhoneOff2: TButton
            Left = 152
            Top = 24
            Width = 89
            Height = 25
            Hint = 'Отключить телефон'
            Caption = 'Phone Off'
            ParentShowHint = False
            ShowHint = True
            TabOrder = 1
            OnClick = ButtonPhoneOffClick
          end
          object GroupBox4: TGroupBox
            Left = 40
            Top = 56
            Width = 185
            Height = 73
            Caption = 'Freeze'
            TabOrder = 2
            object Label3: TLabel
              Left = 16
              Top = 16
              Width = 27
              Height = 13
              Caption = 'IMEI'
            end
            object ButtonFreeze: TButton
              Left = 104
              Top = 40
              Width = 75
              Height = 25
              Hint = 'Write XBB+XBZ+XFS+AllEEP before use Freeze...'
              Caption = 'Freeze'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = ButtonFreezeClick
            end
            object EditFImei: TEdit
              Left = 56
              Top = 12
              Width = 121
              Height = 21
              TabOrder = 1
              Text = '123456789012347'
              OnChange = EditFImeiChange
            end
            object ButtonGetImei: TButton
              Left = 14
              Top = 40
              Width = 75
              Height = 25
              Hint = 'Чтение IMEI с телефона'
              Caption = 'Get IMEI'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
              OnClick = ButtonGetImeiClick
            end
          end
          object ButtonPhoneOn: TButton
            Left = 104
            Top = 24
            Width = 75
            Height = 25
            Caption = 'Phone On'
            TabOrder = 3
            Visible = False
            OnClick = ButtonPhoneOnClick
          end
          object GroupBox5: TGroupBox
            Left = 56
            Top = 144
            Width = 145
            Height = 81
            Caption = 'Options'
            TabOrder = 4
            object Button0071: TButton
              Left = 24
              Top = 16
              Width = 97
              Height = 25
              Hint = 
                'Исправление блока EEP0071 для отключения "Подтверждения Включени' +
                'я" и добавления меню "Диапазон".'
              Caption = '0071 EEP'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 0
              OnClick = Button0071Click
            end
            object Button0280: TButton
              Left = 24
              Top = 48
              Width = 97
              Height = 25
              Hint = 'Исправление блока EEP0280 для включения "Developer Menu".'
              Caption = '0280 EEP'
              ParentShowHint = False
              ShowHint = True
              TabOrder = 1
              OnClick = Button0280Click
            end
          end
          object Button1: TButton
            Left = 216
            Top = 184
            Width = 75
            Height = 25
            Caption = 'Button1'
            TabOrder = 5
            Visible = False
            OnClick = Button1Click
          end
        end
      end
    end
    object ButtonAbout: TButton
      Left = 8
      Top = 416
      Width = 49
      Height = 25
      Caption = 'About'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = ButtonAboutClick
    end
    object RadioGroupTelType: TRadioGroup
      Left = 8
      Top = 4
      Width = 121
      Height = 405
      Caption = 'Mobile Type'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemIndex = 0
      Items.Strings = (
        'A50'
        'A51/52'
        'A55/56/57'
        'C55/56,CT56'
        'M55/56'
        'S55/56/57'
        'SL55'
        'A60/62'
        'A65/C60'
        'MC60'
        'A70'
        'A75'
        'AX72/75,C110'
        'CF62'
        'SX1')
      ParentFont = False
      TabOrder = 2
      OnClick = RadioGroupTelTypeClick
    end
    object RadioGroupComPort: TRadioGroup
      Left = 136
      Top = 4
      Width = 161
      Height = 173
      Caption = 'Com Port'
      Columns = 2
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemIndex = 1
      Items.Strings = (
        'Com1'
        'Com2'
        'Com3'
        'Com4'
        'Com5'
        'Com6'
        'Com7'
        'Com8'
        'Com9'
        'Com10'
        'Com11'
        'Com12'
        'Com13'
        'Com14'
        'Com15'
        'Com16'
        'Com17'
        'Com18'
        'Com19'
        'Com20')
      ParentFont = False
      TabOrder = 3
    end
    object RadioGroupBaud: TRadioGroup
      Left = 304
      Top = 4
      Width = 97
      Height = 81
      Caption = 'Baud'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemIndex = 0
      Items.Strings = (
        '57600'
        '115200'
        '460800'
        '921600')
      ParentFont = False
      TabOrder = 4
    end
    object RadioGroupBootType: TRadioGroup
      Left = 304
      Top = 88
      Width = 97
      Height = 70
      Caption = 'Boot Type'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ItemIndex = 1
      Items.Strings = (
        'Normal'
        'BCoreBug'
        'BootKey')
      ParentFont = False
      TabOrder = 5
    end
    object CheckBoxIgnitionMode: TCheckBox
      Left = 312
      Top = 160
      Width = 90
      Height = 17
      Hint = 'Варианты автозапуска'
      Caption = 'Ignition type'
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 6
    end
    object ButtonClearMemo: TButton
      Left = 104
      Top = 416
      Width = 25
      Height = 25
      Hint = 'Clear Memo'
      Caption = '#'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = ButtonClearMemoClick
    end
    object ButtonConfig: TButton
      Left = 64
      Top = 416
      Width = 33
      Height = 25
      Caption = 'Cfg'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
      OnClick = ButtonConfigClick
    end
  end
  object OpenDialog: TOpenDialog
    Left = 464
    Top = 16
  end
  object SaveDialog: TSaveDialog
    Left = 448
    Top = 56
  end
end
