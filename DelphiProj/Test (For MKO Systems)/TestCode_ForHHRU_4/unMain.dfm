object formMain: TformMain
  Left = 0
  Top = 0
  Caption = #1043#1083#1072#1074#1085#1086#1077' '#1086#1082#1085#1086' ('#1086#1089#1085#1086#1074#1085#1086#1081' '#1087#1086#1090#1086#1082')'
  ClientHeight = 396
  ClientWidth = 998
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 3
    Top = 8
    Width = 992
    Height = 353
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1079#1072#1076#1072#1095#1072#1093' ('#1087#1086#1090#1086#1082#1072#1093')'
    TabOrder = 0
    object Label1: TLabel
      Left = 5
      Top = 243
      Width = 151
      Height = 13
      Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1079#1072#1076#1072#1095
    end
    object Label2: TLabel
      Left = 606
      Top = 244
      Width = 146
      Height = 13
      Caption = #1046#1091#1088#1085#1072#1083' '#1088#1072#1073#1086#1090#1099' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103
    end
    object memThreadInfo_1: TMemo
      Left = 5
      Top = 259
      Width = 595
      Height = 89
      HideSelection = False
      ScrollBars = ssBoth
      TabOrder = 0
      WantReturns = False
      WordWrap = False
      OnClick = memThreadInfo_1Click
    end
    object lbThreadList: TListBox
      Left = 3
      Top = 16
      Width = 382
      Height = 63
      ItemHeight = 13
      TabOrder = 1
      OnClick = lbThreadListClick
      OnKeyPress = lbThreadListKeyPress
      OnMouseUp = lbThreadListMouseUp
    end
    object bThreadPause: TButton
      Left = 424
      Top = 23
      Width = 105
      Height = 25
      Caption = #1055#1072#1091#1079#1072
      TabOrder = 2
      OnClick = bThreadPauseClick
    end
    object bStop: TButton
      Left = 424
      Top = 54
      Width = 105
      Height = 25
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
      TabOrder = 3
      OnClick = bStopClick
    end
    object hMemoThreadInfo_Main: TRichEdit
      Left = 0
      Top = 85
      Width = 989
      Height = 156
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Lines.Strings = (
        '')
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 4
      Zoom = 100
    end
    object memLogInfo_2: TMemo
      Left = 606
      Top = 259
      Width = 383
      Height = 89
      ScrollBars = ssBoth
      TabOrder = 5
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 377
    Width = 998
    Height = 19
    Panels = <
      item
        Width = 200
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object MainMenu1: TMainMenu
    Left = 400
    Top = 65528
    object miFile: TMenuItem
      Caption = #1060#1072#1081#1083
      object miExit: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = miExitClick
      end
    end
    object miSetting: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072
      object miTools: TMenuItem
        Caption = #1048#1085#1089#1090#1088#1091#1084#1077#1085#1090#1099
        OnClick = miToolsClick
      end
      object N1: TMenuItem
        Caption = #1057#1087#1080#1089#1086#1082' '#1084#1086#1076#1091#1083#1077#1081' '#1087#1088#1086#1094#1077#1089#1089#1072
        OnClick = N1Click
      end
    end
    object miAbout: TMenuItem
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
    end
  end
end
