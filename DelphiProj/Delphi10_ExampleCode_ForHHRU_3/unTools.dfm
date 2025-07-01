object formTools: TformTools
  Left = 0
  Top = 0
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072
  ClientHeight = 390
  ClientWidth = 286
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gbThread: TGroupBox
    Left = 8
    Top = 64
    Width = 273
    Height = 155
    Caption = #1055#1077#1088#1077#1095#1077#1085#1100' '#1079#1072#1076#1072#1095
    TabOrder = 0
    object btnNewThread: TButton
      Left = 147
      Top = 125
      Width = 123
      Height = 25
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086#1090#1086#1082
      TabOrder = 0
      OnClick = btnNewThreadClick
    end
    object lbTaskList: TListBox
      Left = 0
      Top = 22
      Width = 270
      Height = 97
      ItemHeight = 13
      TabOrder = 1
    end
  end
  object gbRxchangeType: TGroupBox
    Left = 8
    Top = 0
    Width = 270
    Height = 57
    Caption = #1058#1080#1087' '#1086#1073#1084#1077#1085#1072' '#1089' '#1082#1086#1084#1087#1086#1085#1077#1085#1090#1086#1084'  "'#1087#1088#1086#1089#1084#1086#1090#1088#1072'"'
    TabOrder = 1
    object rbSynchronize: TRadioButton
      Left = 3
      Top = 16
      Width = 246
      Height = 17
      Caption = #1052#1077#1090#1086#1076' Synchronize (TThread)'
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbSynchronizeClick
    end
    object rbClientServer_http: TRadioButton
      Left = 3
      Top = 39
      Width = 264
      Height = 17
      Caption = #1050#1083#1080#1077#1085#1090'-'#1057#1077#1088#1074#1077#1088' (UDP)'
      TabOrder = 1
      OnClick = rbSynchronizeClick
    end
  end
  object MainMenu1: TMainMenu
    Left = 256
    Top = 216
    object mFile: TMenuItem
      Caption = #1060#1072#1081#1083
      object miExit: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = miExitClick
      end
    end
  end
  object tmCheckThreadReport: TTimer
    Enabled = False
    OnTimer = tmCheckThreadReportTimer
    Left = 184
    Top = 216
  end
end
