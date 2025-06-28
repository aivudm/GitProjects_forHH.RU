object formEditJobPosition: TformEditJobPosition
  Left = 462
  Top = 234
  Width = 549
  Height = 391
  Caption = 'formEditJobPosition'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBotton: TPanel
    Left = 0
    Top = 313
    Width = 516
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object bbSave: TBitBtn
      Left = 168
      Top = 8
      Width = 97
      Height = 25
      Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100
      Enabled = False
      TabOrder = 0
      OnClick = bbSaveClick
      Kind = bkOK
    end
    object bbCancel: TBitBtn
      Left = 336
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object pnlCaption: TPanel
    Left = 0
    Top = 0
    Width = 516
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1088#1086#1083#1080' ('#1076#1086#1083#1078#1085#1086#1089#1090#1080')'
    TabOrder = 1
  end
  object gbUserInfo: TGroupBox
    Left = 0
    Top = 41
    Width = 516
    Height = 144
    Align = alTop
    Caption = #1058#1077#1082#1091#1097#1080#1077' '#1079#1085#1072#1095#1077#1085#1080#1103
    TabOrder = 2
    object lbShortJobPosition: TLabel
      Left = 8
      Top = 32
      Width = 172
      Height = 13
      Caption = #1058#1077#1082#1091#1097#1077#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' ('#1082#1088#1072#1090#1082#1086#1077')'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbedFullNameJobPosition: TLabel
      Left = 14
      Top = 62
      Width = 166
      Height = 13
      Caption = #1058#1077#1082#1091#1097#1077#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' ('#1087#1086#1083#1085#1086#1077')'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbNotes: TLabel
      Left = 8
      Top = 120
      Width = 74
      Height = 13
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label3: TLabel
      Left = 158
      Top = 93
      Width = 23
      Height = 13
      Caption = #1050#1086#1076
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edShortNameJobPosition: TEdit
      Left = 189
      Top = 28
      Width = 193
      Height = 21
      Enabled = False
      ReadOnly = True
      TabOrder = 0
    end
    object edFullNameJobPosition: TEdit
      Left = 189
      Top = 59
      Width = 193
      Height = 21
      TabOrder = 1
    end
    object edNotes: TEdit
      Left = 89
      Top = 116
      Width = 400
      Height = 21
      TabOrder = 2
      Text = 'edNotes'
    end
    object edCode: TEdit
      Left = 189
      Top = 88
      Width = 36
      Height = 21
      TabOrder = 3
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 185
    Width = 516
    Height = 128
    Align = alTop
    Caption = #1053#1086#1074#1099#1077' '#1079#1085#1072#1095#1077#1085#1080#1103
    TabOrder = 3
    object Label1: TLabel
      Left = 8
      Top = 32
      Width = 140
      Height = 13
      Caption = #1050#1088#1072#1090#1082#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 12
      Top = 62
      Width = 135
      Height = 13
      Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbNotesNew: TLabel
      Left = 8
      Top = 93
      Width = 74
      Height = 13
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Edit1: TEdit
      Left = 158
      Top = 28
      Width = 193
      Height = 21
      Enabled = False
      ReadOnly = True
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 158
      Top = 59
      Width = 193
      Height = 21
      TabOrder = 1
    end
    object Edit3: TEdit
      Left = 89
      Top = 89
      Width = 400
      Height = 21
      TabOrder = 2
      Text = 'edNotes'
    end
  end
end
