object formEditJobItem: TformEditJobItem
  Left = 396
  Top = 162
  Width = 700
  Height = 418
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1101#1083#1077#1084#1077#1085#1090#1072' '#1088#1072#1073#1086#1090#1099' ('#1044#1077#1081#1089#1090#1074#1080#1103')'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 684
    Height = 57
    Align = alTop
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1044#1077#1081#1089#1090#1074#1080#1103
    TabOrder = 0
    object Edit1: TEdit
      Left = 8
      Top = 24
      Width = 665
      Height = 21
      TabOrder = 0
      Text = 'Edit1'
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 57
    Width = 684
    Height = 302
    Align = alClient
    Caption = 'GroupBox2'
    TabOrder = 1
  end
  object MainMenu1: TMainMenu
    Left = 384
    Top = 16
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N3: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = N3Click
      end
    end
    object N2: TMenuItem
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
    end
  end
end
