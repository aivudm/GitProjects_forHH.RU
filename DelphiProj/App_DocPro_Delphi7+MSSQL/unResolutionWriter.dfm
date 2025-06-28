object formResolutionWriter: TformResolutionWriter
  Left = 350
  Top = 58
  Width = 621
  Height = 563
  Caption = #1053#1072#1087#1080#1089#1072#1090#1100' '#1088#1077#1079#1086#1083#1102#1094#1080#1102'...'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 201
    Width = 605
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object Splitter2: TSplitter
    Left = 0
    Top = 217
    Width = 605
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object Splitter3: TSplitter
    Left = 0
    Top = 445
    Width = 605
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object gbRoutesInfo: TGroupBox
    Left = 0
    Top = 220
    Width = 605
    Height = 225
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
      Width = 601
      Height = 205
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnChange = DefaultOnChangeActions
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 605
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
    Width = 605
    Height = 184
    Align = alTop
    Caption = #1054#1073#1097#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1079#1072#1103#1074#1082#1077
    TabOrder = 2
    object lbFIO: TLabel
      Left = 8
      Top = 61
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
    object lbOrderOpen: TLabel
      Left = 5
      Top = 92
      Width = 141
      Height = 13
      Caption = #1044#1072#1090#1072' '#1086#1090#1082#1088#1099#1090#1080#1103' '#1079#1072#1103#1074#1082#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label6: TLabel
      Left = 247
      Top = 93
      Width = 159
      Height = 13
      Caption = #1044#1072#1090#1072' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1103' '#1079#1072#1103#1074#1082#1080': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 5
      Top = 133
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
    object Label1: TLabel
      Left = 8
      Top = 152
      Width = 76
      Height = 13
      Caption = '('#1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080')'
    end
    object Label3: TLabel
      Left = 37
      Top = 29
      Width = 90
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1079#1072#1103#1074#1082#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edFIO: TEdit
      Left = 130
      Top = 59
      Width = 359
      Height = 21
      Enabled = False
      ReadOnly = True
      TabOrder = 0
    end
    object dtpOrderCreationDate: TDateTimePicker
      Left = 153
      Top = 90
      Width = 81
      Height = 21
      Date = 40218.904512812500000000
      Time = 40218.904512812500000000
      Enabled = False
      TabOrder = 1
    end
    object dtpOrderExecutionDate: TDateTimePicker
      Left = 410
      Top = 90
      Width = 82
      Height = 21
      Date = 40218.904512812500000000
      Time = 40218.904512812500000000
      Enabled = False
      MinDate = 2.000000000000000000
      TabOrder = 2
    end
    object memNotes: TMemo
      Left = 96
      Top = 124
      Width = 505
      Height = 49
      Enabled = False
      TabOrder = 3
    end
    object edOrderNum: TEdit
      Left = 130
      Top = 27
      Width = 78
      Height = 21
      Enabled = False
      ReadOnly = True
      TabOrder = 4
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 204
    Width = 605
    Height = 13
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
  end
  object Panel3: TPanel
    Left = 0
    Top = 448
    Width = 605
    Height = 76
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
