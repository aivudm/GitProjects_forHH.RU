object formMain: TformMain
  Left = 0
  Top = 0
  Caption = #1043#1083#1072#1074#1085#1086#1077' '#1086#1082#1085#1086' ('#1086#1089#1085#1086#1074#1085#1086#1081' '#1087#1086#1090#1086#1082')'
  ClientHeight = 396
  ClientWidth = 756
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
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 350
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object GroupBox1: TGroupBox
    Left = 3
    Top = 8
    Width = 745
    Height = 345
    Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1079#1072#1076#1072#1095#1072#1093' ('#1087#1086#1090#1086#1082#1072#1093')'
    TabOrder = 0
    object memInfoTread: TMemo
      Left = 3
      Top = 85
      Width = 739
      Height = 156
      Lines.Strings = (
        '')
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object memInfo_2: TMemo
      Left = 0
      Top = 247
      Width = 385
      Height = 89
      TabOrder = 1
    end
    object lbThreadList: TListBox
      Left = 3
      Top = 16
      Width = 382
      Height = 63
      ItemHeight = 13
      TabOrder = 2
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
      TabOrder = 3
      OnClick = bThreadPauseClick
    end
    object bStop: TButton
      Left = 424
      Top = 54
      Width = 105
      Height = 25
      Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100
      TabOrder = 4
    end
  end
  object sbMain: TStatusBar
    Left = 0
    Top = 377
    Width = 756
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
  object Button1: TButton
    Left = 312
    Top = 350
    Width = 113
    Height = 25
    Caption = #1058#1077#1089#1090' ('#1086#1090#1088#1072#1073#1086#1090#1082#1072') 1'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 448
    Top = 346
    Width = 131
    Height = 25
    Caption = #1058#1077#1089#1090' '#1087#1086#1076#1082#1083'. '#1073#1080#1073#1083#1080#1086#1090#1077#1082
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 592
    Top = 346
    Width = 156
    Height = 25
    Caption = #1058#1077#1089#1090' '#1079#1072#1087#1091#1089#1082#1072' '#1079#1072#1076#1072#1095' '#1074' '#1073#1080#1073#1083'.'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 231
    Top = 350
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 5
    OnClick = Button4Click
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
