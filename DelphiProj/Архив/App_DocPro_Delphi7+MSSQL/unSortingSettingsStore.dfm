object formFilterSettingsStore: TformFilterSettingsStore
  Left = 466
  Top = 58
  Width = 302
  Height = 345
  Caption = 'formFilterSettingsStore'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 265
    Width = 286
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object bbSaveSettingsStore: TBitBtn
      Left = 96
      Top = 8
      Width = 75
      Height = 25
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      TabOrder = 0
      OnClick = bbSaveSettingsStoreClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 286
    Height = 265
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
    object GroupBox15: TGroupBox
      Left = 0
      Top = 0
      Width = 286
      Height = 265
      Align = alClient
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1092#1080#1083#1100#1090#1088#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object rbFilterStoreON: TRadioButton
        Left = 8
        Top = 16
        Width = 89
        Height = 17
        Caption = #1042#1082#1083'. '#1092#1080#1083#1100#1090#1088
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
      end
      object rbFilterStoreOFF: TRadioButton
        Left = 112
        Top = 16
        Width = 113
        Height = 17
        Caption = #1042#1099#1082#1083'. '#1092#1080#1083#1100#1090#1088
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        TabStop = True
      end
      object cbOrderCreatorOwner: TComboBox
        Left = 5
        Top = 52
        Width = 277
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 2
        Text = 'cbCreatorOwner'
      end
      object ckbStoreCreatorOwner: TCheckBox
        Left = 6
        Top = 34
        Width = 115
        Height = 17
        Caption = #1048#1085#1080#1094#1080#1072#1090#1086#1088' '#1079#1072#1082#1072#1079#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
      end
      object ckbObjectsGroups: TCheckBox
        Left = 5
        Top = 75
        Width = 97
        Height = 17
        Caption = #1043#1088#1091#1087#1087#1072' '#1052#1058#1057
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
      end
      object cbObjectGroup: TComboBox
        Left = 4
        Top = 95
        Width = 278
        Height = 21
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 5
        Text = 'cbObjectGroup'
      end
      object gbPeriodSelect: TGroupBox
        Left = 3
        Top = 119
        Width = 278
        Height = 122
        Caption = #1042#1099#1073#1086#1088' '#1087#1077#1088#1080#1086#1076#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 6
        object Label1: TLabel
          Left = 4
          Top = 35
          Width = 35
          Height = 13
          Caption = #1085#1072#1095#1072#1083#1086
        end
        object Label2: TLabel
          Left = 131
          Top = 36
          Width = 30
          Height = 13
          Caption = #1082#1086#1085#1077#1094
        end
        object Label3: TLabel
          Left = 4
          Top = 81
          Width = 35
          Height = 13
          Caption = #1085#1072#1095#1072#1083#1086
        end
        object Label4: TLabel
          Left = 131
          Top = 82
          Width = 30
          Height = 13
          Caption = #1082#1086#1085#1077#1094
        end
        object dtpPeriodBegin: TDateTimePicker
          Left = 42
          Top = 32
          Width = 87
          Height = 21
          Date = 41084.477712511570000000
          Time = 41084.477712511570000000
          TabOrder = 0
        end
        object dtpPeriodEnd: TDateTimePicker
          Left = 167
          Top = 32
          Width = 105
          Height = 21
          Date = 41084.477931145830000000
          Time = 41084.477931145830000000
          TabOrder = 1
        end
        object ckbPeriod: TCheckBox
          Left = 3
          Top = 13
          Width = 156
          Height = 17
          Caption = #1057#1086#1079#1076#1072#1085#1080#1103' '#1079#1072#1103#1074#1082#1080
          TabOrder = 2
        end
        object CheckBox1: TCheckBox
          Left = 3
          Top = 59
          Width = 156
          Height = 17
          Caption = #1055#1088#1080#1093#1086#1076#1086#1074#1072#1085#1080#1103' '#1085#1072' '#1089#1082#1083#1072#1076
          TabOrder = 3
        end
        object DateTimePicker1: TDateTimePicker
          Left = 42
          Top = 78
          Width = 87
          Height = 21
          Date = 41084.477712511570000000
          Time = 41084.477712511570000000
          TabOrder = 4
        end
        object DateTimePicker2: TDateTimePicker
          Left = 165
          Top = 78
          Width = 105
          Height = 21
          Date = 41084.477931145830000000
          Time = 41084.477931145830000000
          TabOrder = 5
        end
      end
    end
  end
end
