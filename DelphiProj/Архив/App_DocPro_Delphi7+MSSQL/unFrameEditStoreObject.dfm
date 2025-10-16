object Frame1: TFrame1
  Left = 0
  Top = 0
  Width = 710
  Height = 386
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 0
    Top = 0
    Width = 710
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 49
    Width = 331
    Height = 286
    Align = alLeft
    Caption = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1079#1072#1103#1074#1082#1080
    TabOrder = 0
    object Label1: TLabel
      Left = 14
      Top = 53
      Width = 72
      Height = 13
      Caption = #1043#1088#1091#1087#1087#1072' '#1052#1058#1057
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 5
      Top = 92
      Width = 93
      Height = 13
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 23
      Top = 123
      Width = 78
      Height = 13
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lb: TLabel
      Left = 4
      Top = 155
      Width = 97
      Height = 13
      Caption = #1045#1076'. '#1080#1079#1084#1077#1088#1077#1085#1080#1103': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 7
      Top = 208
      Width = 86
      Height = 13
      Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 4
      Top = 18
      Width = 69
      Height = 13
      Caption = #1048#1085#1080#1094#1080#1072#1090#1086#1088':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cbObjectGroup: TComboBox
      Left = 101
      Top = 51
      Width = 225
      Height = 21
      Enabled = False
      ItemHeight = 13
      TabOrder = 0
      Text = 'cbObjectGroup'
    end
    object edObjectName: TEdit
      Left = 101
      Top = 89
      Width = 225
      Height = 21
      Enabled = False
      TabOrder = 1
      Text = 'edObjectName'
    end
    object edObjectVolume: TEdit
      Left = 102
      Top = 121
      Width = 73
      Height = 21
      Enabled = False
      TabOrder = 2
      Text = 'edObjectVolume'
    end
    object cbMeasurementUnit: TComboBox
      Left = 102
      Top = 154
      Width = 101
      Height = 21
      Enabled = False
      ItemHeight = 13
      TabOrder = 3
      Text = 'cbMeasurementUnit'
    end
    object memNotes: TMemo
      Left = 100
      Top = 182
      Width = 227
      Height = 47
      Enabled = False
      Lines.Strings = (
        #1042#1072#1096#1080' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080)
      TabOrder = 4
    end
    object edFIO: TEdit
      Left = 101
      Top = 15
      Width = 224
      Height = 21
      Enabled = False
      TabOrder = 5
      Text = 'edFIO'
    end
  end
  object pnlBottomForm: TPanel
    Left = 0
    Top = 335
    Width = 710
    Height = 51
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object bbSave: TBitBtn
      Left = 234
      Top = 10
      Width = 97
      Height = 32
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      Enabled = False
      TabOrder = 0
      Kind = bkOK
    end
    object bbCancel: TBitBtn
      Left = 402
      Top = 10
      Width = 75
      Height = 32
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 3
    Width = 710
    Height = 46
    Align = alTop
    Caption = #1055#1088#1080#1074#1103#1079#1082#1072' '#1082' '#1079#1072#1082#1072#1079#1091
    TabOrder = 2
    object lbOrderOpen: TLabel
      Left = 190
      Top = 20
      Width = 129
      Height = 13
      Caption = #1044#1072#1090#1072' '#1086#1087#1088#1080#1093#1086#1076#1086#1074#1072#1085#1080#1103':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cbStoreObjectParentLink: TComboBox
      Left = 6
      Top = 17
      Width = 177
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = 'cbStoreObjectParentLink'
    end
    object dtpStoreObjectCreationDate: TDateTimePicker
      Left = 320
      Top = 17
      Width = 81
      Height = 21
      Date = 40218.904512812500000000
      Time = 40218.904512812500000000
      Enabled = False
      TabOrder = 1
    end
  end
  object GroupBox3: TGroupBox
    Left = 387
    Top = 49
    Width = 323
    Height = 286
    Align = alClient
    Caption = #1044#1072#1085#1085#1099#1077' '#1087#1086' '#1092#1072#1082#1090#1091' '#1087#1086#1089#1090#1072#1074#1082#1080' '#1085#1072' '#1089#1082#1083#1072#1076':'
    TabOrder = 3
    object Label5: TLabel
      Left = 19
      Top = 22
      Width = 76
      Height = 13
      Caption = #1043#1088#1091#1087#1087#1072' '#1052#1058#1057':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 5
      Top = 45
      Width = 93
      Height = 13
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label7: TLabel
      Left = 23
      Top = 123
      Width = 78
      Height = 13
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label8: TLabel
      Left = 4
      Top = 155
      Width = 97
      Height = 13
      Caption = #1045#1076'. '#1080#1079#1084#1077#1088#1077#1085#1080#1103': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label9: TLabel
      Left = 7
      Top = 208
      Width = 86
      Height = 13
      Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label11: TLabel
      Left = 41
      Top = 66
      Width = 54
      Height = 13
      Caption = #1050#1088#1072#1090#1082#1086#1077':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label12: TLabel
      Left = 47
      Top = 94
      Width = 49
      Height = 13
      Caption = #1055#1086#1083#1085#1086#1077':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cbStoreObjectGroup: TComboBox
      Left = 101
      Top = 18
      Width = 219
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = 'cbObjectsGroups'
    end
    object edStoreObjectShortName: TEdit
      Left = 101
      Top = 62
      Width = 220
      Height = 21
      TabOrder = 1
      Text = 'edObjectName'
    end
    object edStoreObjectVolume: TEdit
      Left = 102
      Top = 121
      Width = 73
      Height = 21
      TabOrder = 2
      Text = 'edObjectVolume'
    end
    object cbStoreMeasurementUnit: TComboBox
      Left = 102
      Top = 154
      Width = 101
      Height = 21
      ItemHeight = 13
      TabOrder = 3
      Text = 'cbMeasurementsUnits'
    end
    object memStoreNotes: TMemo
      Left = 100
      Top = 190
      Width = 219
      Height = 38
      Lines.Strings = (
        #1042#1072#1096#1080' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080)
      TabOrder = 4
    end
    object edStoreObjectFullName: TEdit
      Left = 102
      Top = 90
      Width = 219
      Height = 21
      TabOrder = 5
      Text = 'edObjectName'
    end
  end
  object Panel1: TPanel
    Left = 331
    Top = 49
    Width = 56
    Height = 286
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 4
    object sbCopyOrderDataToStoreData: TSpeedButton
      Left = 1
      Top = 76
      Width = 54
      Height = 73
      Hint = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1079#1072#1103#1074#1082#1080
      Glyph.Data = {
        42020000424D4202000000000000420000002800000010000000100000000100
        1000030000000002000000000000000000000000000000000000007C0000E003
        00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C10421F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C000010421F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C000000001042
        1F7C1F7C1F7C1F7C10421F7C1F7C104210421F7C1F7C104210420000007C0000
        10421F7C1F7C004000001F7C0000000000001F7C0000000000000000007C007C
        000010421F7C004000001F7C0000007C00001F7C0000007C007C007C007C007C
        007C00001042004000001F7C0000007C00001F7C0000007C007C007C007C007C
        007C007C0000004000001F7C0000007C00001F7C0000007C007C007C007C007C
        007C00001F7C004000001F7C0000000000001F7C0000000000000000007C007C
        00001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000007C0000
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C000000001F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
        1F7C1F7C1F7C}
    end
  end
end
