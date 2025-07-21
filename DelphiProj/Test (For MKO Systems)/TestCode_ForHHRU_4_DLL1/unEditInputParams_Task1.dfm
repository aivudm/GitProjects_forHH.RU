object formEditParams_Task1: TformEditParams_Task1
  Left = 0
  Top = 0
  Caption = #1042#1093#1086#1076#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
  ClientHeight = 182
  ClientWidth = 370
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 6
    Width = 238
    Height = 13
    Caption = #1052#1072#1089#1082#1072' ( '#1092#1086#1088#1084#1072#1090' - '#39'*.*'#39', '#1088#1072#1079#1076#1077#1083#1080#1090#1077#1083#1100' - '#39';'#39' )'
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
    Width = 114
    Height = 13
    Caption = #1044#1080#1088#1077#1082#1090#1086#1088#1080#1103' '#1087#1086#1080#1089#1082#1072
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
  object edMask: TEdit
    Left = 8
    Top = 22
    Width = 354
    Height = 21
    Hint = #1056#1072#1079#1076#1077#1083#1080#1090#1077#1083#1100' '#1084#1072#1089#1086#1082': ";"'
    TabOrder = 0
    Text = '*.txt'
  end
  object edTargetDirectory: TEdit
    Left = 8
    Top = 64
    Width = 354
    Height = 21
    TabOrder = 1
    Text = 'C:\Users\user\AppData\Roaming\Primer_MT_3'
  end
  object btbRunTask: TButton
    Left = 287
    Top = 144
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
    Text = 'D:\Install\ResultSearchByMask1.txt'
  end
  object chkbTypeResultOutput: TCheckBox
    Left = 8
    Top = 146
    Width = 161
    Height = 17
    Caption = #1042#1099#1074#1086#1076' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1072' '#1074' '#1092#1072#1081#1083
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
  object odTargetDirectory: TOpenDialog
    InitialDir = 'edTargetDirectory.Text'
    Left = 328
    Top = 48
  end
end
