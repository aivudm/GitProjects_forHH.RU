object formEditParams_Task2: TformEditParams_Task2
  Left = 0
  Top = 0
  Caption = #1042#1093#1086#1076#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
  ClientHeight = 194
  ClientWidth = 369
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 6
    Width = 263
    Height = 13
    Caption = #1064#1072#1073#1083#1086#1085' '#1087#1086#1080#1089#1082#1072' ('#1088#1072#1079#1076#1077#1083#1080#1090#1077#1083#1100' '#1096#1072#1073#1083#1086#1085#1086#1074' - '#39';'#39' )'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 8
    Top = 49
    Width = 82
    Height = 13
    Caption = #1062#1077#1083#1077#1074#1086#1081' '#1092#1072#1081#1083
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 8
    Top = 94
    Width = 177
    Height = 13
    Caption = #1060#1072#1081#1083' '#1076#1083#1103' '#1074#1099#1074#1086#1076#1072' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object edPattern: TEdit
    Left = 8
    Top = 22
    Width = 354
    Height = 21
    Hint = #1056#1072#1079#1076#1077#1083#1080#1090#1077#1083#1100' '#1084#1072#1089#1086#1082': ";"'
    TabOrder = 0
    Text = 'resource;observe;modul;.sys'
  end
  object edTargetFile: TEdit
    Left = 8
    Top = 64
    Width = 354
    Height = 21
    TabOrder = 1
    Text = 'D:\Install\FFscriptCache.bin'
  end
  object btbRunTask: TButton
    Left = 286
    Top = 161
    Width = 75
    Height = 25
    Caption = #1047#1072#1087#1091#1089#1082
    TabOrder = 2
    OnClick = btbRunTaskClick
  end
  object edResultFile: TEdit
    Left = 8
    Top = 111
    Width = 354
    Height = 21
    TabOrder = 3
    Text = 'D:\Install\Result_Library1_Task2.txt'
  end
  object chkbTypeResultOutput: TCheckBox
    Left = 8
    Top = 169
    Width = 161
    Height = 17
    Caption = #1042#1099#1074#1086#1076' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1072' '#1074' '#1092#1072#1081#1083
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object chkbTypeCase: TCheckBox
    Left = 8
    Top = 142
    Width = 185
    Height = 17
    Caption = #1053#1077' '#1091#1095#1080#1090#1099#1074#1072#1090#1100' '#1088#1077#1075#1080#1089#1090#1088' '#1089#1080#1084#1074#1086#1083#1086#1074
    Enabled = False
    TabOrder = 5
  end
  object odTargetFile: TOpenDialog
    Filter = '*.*|*.bin'
    InitialDir = 'edTargetDirectory.Text'
    Left = 328
    Top = 48
  end
end
