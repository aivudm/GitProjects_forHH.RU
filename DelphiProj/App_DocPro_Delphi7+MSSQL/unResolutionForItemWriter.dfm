object formResolutionForItemWriter: TformResolutionForItemWriter
  Left = 388
  Top = 58
  Width = 515
  Height = 563
  Caption = #1053#1072#1087#1080#1089#1072#1090#1100' '#1088#1077#1079#1086#1083#1102#1094#1080#1102'...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 265
    Width = 499
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object Splitter2: TSplitter
    Left = 0
    Top = 281
    Width = 499
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object Splitter3: TSplitter
    Left = 0
    Top = 465
    Width = 499
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object gbRoutesInfo: TGroupBox
    Left = 0
    Top = 284
    Width = 499
    Height = 181
    Align = alTop
    Caption = #1056#1077#1079#1086#1083#1102#1094#1080#1103
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object Memo1: TMemo
      Left = 2
      Top = 18
      Width = 495
      Height = 161
      Align = alClient
      TabOrder = 0
      OnChange = DefaultOnChangeActions
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 499
    Height = 17
    Align = alTop
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
  end
  object gbCommonOrderInfo: TGroupBox
    Left = 0
    Top = 17
    Width = 499
    Height = 248
    Align = alTop
    Caption = #1054#1073#1097#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1079#1072#1103#1074#1082#1077
    TabOrder = 2
    object Label1: TLabel
      Left = 26
      Top = 88
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
    object lbOrderOpen: TLabel
      Left = 15
      Top = 54
      Width = 141
      Height = 13
      Caption = #1044#1072#1090#1072' '#1086#1090#1082#1088#1099#1090#1080#1103' '#1079#1072#1082#1072#1079#1072':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbFIO: TLabel
      Left = 18
      Top = 23
      Width = 120
      Height = 13
      Caption = #1060'.'#1048'.'#1054'. '#1080#1085#1080#1094#1080#1072#1090#1086#1088#1072':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lb: TLabel
      Left = 183
      Top = 159
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
    object Label6: TLabel
      Left = 253
      Top = 55
      Width = 159
      Height = 13
      Caption = #1044#1072#1090#1072' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1103' '#1079#1072#1082#1072#1079#1072': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 24
      Top = 159
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
    object Label2: TLabel
      Left = 16
      Top = 186
      Width = 82
      Height = 13
      Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 8
      Top = 127
      Width = 89
      Height = 13
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object cbObjectsGroups: TComboBox
      Left = 104
      Top = 86
      Width = 171
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      Text = 'cbObjectsGroups'
    end
    object dtpOrderItemCreationDate: TDateTimePicker
      Left = 165
      Top = 52
      Width = 83
      Height = 21
      Date = 40218.904512812500000000
      Time = 40218.904512812500000000
      Enabled = False
      TabOrder = 1
    end
    object cbMeasurementsUnits: TComboBox
      Left = 279
      Top = 157
      Width = 101
      Height = 21
      ItemHeight = 13
      TabOrder = 2
      Text = 'cbMeasurementsUnits'
    end
    object dtpOrderItemsExecutionDate: TDateTimePicker
      Left = 413
      Top = 52
      Width = 86
      Height = 21
      Date = 40218.904512812500000000
      Time = 40218.904512812500000000
      Enabled = False
      MinDate = 2.000000000000000000
      TabOrder = 3
    end
    object edFIO: TEdit
      Left = 140
      Top = 21
      Width = 358
      Height = 21
      Enabled = False
      ReadOnly = True
      TabOrder = 4
    end
    object edObjectVolume: TEdit
      Left = 105
      Top = 157
      Width = 73
      Height = 21
      ReadOnly = True
      TabOrder = 5
      Text = 'edObjectVolume'
    end
    object memNotes: TMemo
      Left = 104
      Top = 190
      Width = 398
      Height = 49
      Lines.Strings = (
        #1042#1072#1096#1080' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080)
      ReadOnly = True
      TabOrder = 6
    end
    object edObjectName: TEdit
      Left = 105
      Top = 124
      Width = 395
      Height = 21
      ReadOnly = True
      TabOrder = 7
      Text = 'edObjectName'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 268
    Width = 499
    Height = 13
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
  end
  object Panel3: TPanel
    Left = 0
    Top = 468
    Width = 499
    Height = 56
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 4
    object bbApply: TBitBtn
      Left = 168
      Top = 8
      Width = 97
      Height = 25
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      Enabled = False
      TabOrder = 0
      OnClick = bbApplyClick
      Kind = bkOK
    end
    object bbCancel: TBitBtn
      Left = 336
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      OnClick = bbCancelClick
      Kind = bkCancel
    end
  end
end
