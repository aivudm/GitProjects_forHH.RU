object formEditUser: TformEditUser
  Left = 388
  Top = 58
  Width = 518
  Height = 364
  Caption = 'formEditUser'
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
  object pnlBotton: TPanel
    Left = 0
    Top = 284
    Width = 502
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
    Width = 502
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103
    TabOrder = 1
  end
  object pcontUserInfo: TPageControl
    Left = 0
    Top = 41
    Width = 502
    Height = 243
    ActivePage = tsheetUserCommonInfo
    Align = alClient
    TabOrder = 2
    object tsheetUserCommonInfo: TTabSheet
      Caption = #1054#1073#1097#1072#1103' '#1080#1085#1092#1086#1088#1084#1072#1094#1080#1103
      object gbUserInfo: TGroupBox
        Left = 0
        Top = 0
        Width = 494
        Height = 215
        Align = alClient
        Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077
        TabOrder = 0
        object lbFIO: TLabel
          Left = 8
          Top = 32
          Width = 43
          Height = 13
          Caption = #1060'.'#1048'.'#1054'.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lbLogin: TLabel
          Left = 17
          Top = 62
          Width = 32
          Height = 13
          Caption = 'Login'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lbJobPosition: TLabel
          Left = 18
          Top = 96
          Width = 30
          Height = 13
          Caption = #1056#1086#1083#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object lbNotes: TLabel
          Left = 5
          Top = 136
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
        object edFIO: TEdit
          Left = 84
          Top = 30
          Width = 408
          Height = 21
          ReadOnly = True
          TabOrder = 0
          OnClick = DefaultOnChangeActions
        end
        object edLogin: TEdit
          Left = 84
          Top = 59
          Width = 121
          Height = 21
          ReadOnly = True
          TabOrder = 1
          OnClick = DefaultOnChangeActions
        end
        object cbJobRole: TComboBox
          Left = 84
          Top = 93
          Width = 207
          Height = 21
          ItemHeight = 13
          TabOrder = 2
          Text = 'cbJobRole'
          OnClick = DefaultOnChangeActions
        end
        object edNotes: TEdit
          Left = 83
          Top = 132
          Width = 409
          Height = 21
          TabOrder = 3
          Text = 'edNotes'
          OnClick = DefaultOnChangeActions
        end
      end
    end
    object tsheetUserRightInfo: TTabSheet
      Caption = #1055#1088#1072#1074#1072' '#1074' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      ImageIndex = 1
      object cbAdminRight: TCheckBox
        Left = 8
        Top = 16
        Width = 169
        Height = 17
        Caption = #1071#1074#1083#1103#1077#1090#1089#1103' '#1072#1076#1084#1080#1085#1080#1089#1090#1088#1072#1090#1086#1088#1084
        TabOrder = 0
        OnClick = DefaultOnChangeActions
      end
    end
  end
end
