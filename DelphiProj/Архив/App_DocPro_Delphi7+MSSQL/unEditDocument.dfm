object formEditDocument: TformEditDocument
  Left = 457
  Top = 207
  Width = 554
  Height = 477
  Caption = #1057#1086#1079#1076#1072#1085#1080#1077'/'#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1085#1086#1074#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000F00200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    00000000BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    0000000000000000000000000000000000000000000000000000000000000000
    0BB333333333333333333333000000000B000000000000000000000300000000
    0B8FF6FFFFFFFFFFFFFFFF03000000000B8FF6FFFFFFFFFFFFFFFF0300000000
    0B8666666666666666666603000000000B8FF6FFFFFFFFFFFFFFFF0300000000
    0B8FF6FFFFFFFFFFFFFFFF03000000000B866600066006606000660300000000
    0B8FF0FF0F0FF0F0F0FF0F03000000000B8FF0F00F0FF0F0F0FF0F0300000000
    0B8660666606606060660603000000000B8FF6000F0FF0F0F000FF0300000000
    0B8FF6FFFFFFFFFFFFFFFF03000000000B866066060006606066660300000000
    0B8FF0FF0F0FFFF0F0FFFF03000000000B8FF0F00F00FF0F0F0FFF0300000000
    0B8660060606660606066603000000000B8FF0FF0F000F0FFF0FFF0300000000
    0B8FF6FFFFFFFFFFFFFFFF03000000000B866666666666666666660300000000
    0B8FF6FFFFFFFFFFFFFFFF03000000000B8FF6FFFFFFFFFFFFFFFF0300000000
    0B8FF6FF77777777777FFF03000000000B8FF6F000000000007FFF0300000000
    0B888880FF7777788088880B000000000BBBBBBB0FF777880BBBBBBB00000000
    0000000000FF77800000000000000000000000000FF777780000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    FFFFF800000FF0000007F0000007F0000007F0000007F0000007F0000007F000
    0007F0000007F0000007F0000007F0000007F0000007F0000007F0000007F000
    0007F0000007F0000007F0000007F0000007F0000007F0000007F0000007F000
    0007F0000007F0000007F0000007F800000FFFF007FFFFF007FFFFFFFFFF0000
    000000000000}
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 0
    Top = 217
    Width = 538
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object Splitter2: TSplitter
    Left = 0
    Top = 249
    Width = 538
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object Splitter3: TSplitter
    Left = 0
    Top = 389
    Width = 538
    Height = 3
    Cursor = crVSplit
    Align = alTop
  end
  object gbRoutesInfo: TGroupBox
    Left = 0
    Top = 252
    Width = 538
    Height = 137
    Align = alTop
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1084#1072#1088#1096#1088#1091#1090#1077' '#1087#1088#1086#1093#1086#1078#1076#1077#1085#1080#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    TabOrder = 0
    Visible = False
    object gbRoutesList: TGroupBox
      Left = 5
      Top = 16
      Width = 209
      Height = 121
      Align = alCustom
      Caption = #1069#1090#1072#1087#1099' '#1087#1088#1086#1094#1077#1089#1089#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object dbgRoutesList: TDBGrid
        Left = 2
        Top = 15
        Width = 205
        Height = 104
        Align = alClient
        DataSource = dmDB.dsComboBox1
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Options = [dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'MS Sans Serif'
        TitleFont.Style = [fsBold]
        Columns = <
          item
            Expanded = False
            FieldName = 'RouteName'
            Visible = True
          end>
      end
    end
    object gbRoutesItems: TGroupBox
      Left = 217
      Top = 16
      Width = 327
      Height = 121
      Align = alCustom
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1076#1077#1081#1089#1090#1074#1080#1081' '#1087#1088#1086#1094#1077#1089#1089#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object lbRoutesItems: TListBox
        Left = 2
        Top = 15
        Width = 323
        Height = 104
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ItemHeight = 13
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object pnlCaption: TPanel
    Left = 0
    Top = 0
    Width = 538
    Height = 25
    Align = alTop
    AutoSize = True
    BevelOuter = bvNone
    Caption = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1087#1088#1080#1086#1073#1088#1077#1090#1077#1085#1080#1077' '#1052#1058#1056' ('#1091#1089#1083#1091#1075')'
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
    Top = 25
    Width = 538
    Height = 192
    Align = alTop
    Caption = #1054#1073#1097#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
    TabOrder = 2
    object lbFIO: TLabel
      Left = 30
      Top = 45
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
    object Label6: TLabel
      Left = 189
      Top = 77
      Width = 5
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 11
      Top = 118
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
      Left = 24
      Top = 159
      Width = 76
      Height = 13
      Caption = '('#1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080')'
    end
    object Label3: TLabel
      Left = 3
      Top = 20
      Width = 148
      Height = 13
      Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' ('#1079#1072#1103#1074#1082#1080'):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edFIO: TEdit
      Left = 152
      Top = 43
      Width = 257
      Height = 21
      Enabled = False
      ReadOnly = True
      TabOrder = 0
    end
    object dtpDocumentCreationDate: TDateTimePicker
      Left = 103
      Top = 73
      Width = 81
      Height = 21
      Date = 40218.904512812500000000
      Time = 40218.904512812500000000
      Enabled = False
      TabOrder = 1
      OnChange = dtpDocumentCreationDateChange
    end
    object dtpDocumentExecutionDate: TDateTimePicker
      Left = 327
      Top = 74
      Width = 82
      Height = 21
      Date = 40218.904512812500000000
      Time = 40218.904512812500000000
      MinDate = 2.000000000000000000
      TabOrder = 2
      OnChange = DefaultOnChangeActions
    end
    object memNotes: TMemo
      Left = 104
      Top = 147
      Width = 438
      Height = 40
      MaxLength = 1024
      TabOrder = 3
    end
    object cbDocumentType: TComboBox
      Left = 153
      Top = 17
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 4
    end
    object StaticText1: TStaticText
      Left = 6
      Top = 69
      Width = 97
      Height = 26
      AutoSize = False
      Caption = #1044#1072#1090#1072' '#1086#1090#1082#1088#1099#1090#1080#1103' '#1079#1072#1103#1074#1082#1080':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
    end
    object StaticText2: TStaticText
      Left = 206
      Top = 71
      Width = 107
      Height = 26
      AutoSize = False
      Caption = #1044#1072#1090#1072' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1103' '#1079#1072#1103#1074#1082#1080': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
    end
    object edDocumentShortName: TEdit
      Left = 104
      Top = 116
      Width = 305
      Height = 21
      MaxLength = 64
      TabOrder = 7
      OnChange = edDocumentShortNameChange
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 220
    Width = 538
    Height = 29
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    Visible = False
    object cbUseDefaultRoute: TCheckBox
      Left = 8
      Top = 8
      Width = 217
      Height = 17
      Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1087#1088#1086#1094#1077#1089#1089' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
      TabOrder = 0
      OnClick = cbUseDefaultRouteClick
    end
  end
  object pnlBotton: TPanel
    Left = 0
    Top = 392
    Width = 538
    Height = 46
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 4
    object bbSave: TBitBtn
      Left = 144
      Top = 16
      Width = 97
      Height = 25
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      Enabled = False
      TabOrder = 0
      OnClick = bbSaveClick
      Kind = bkOK
    end
    object bbCancel: TBitBtn
      Left = 328
      Top = 16
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      Kind = bkCancel
    end
  end
end
