object formEditProcessItem: TformEditProcessItem
  Left = 758
  Top = 286
  Width = 370
  Height = 282
  Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1069#1090#1072#1087#1072' '#1055#1088#1086#1094#1077#1089#1089#1072
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
    Top = 202
    Width = 354
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object bbSave: TBitBtn
      Left = 48
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
      Left = 216
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 354
    Height = 202
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #1069#1090#1072#1087' '#1087#1088#1086#1094#1077#1089#1089#1072
      object lbProcessItemLevel: TLabel
        Left = 7
        Top = 19
        Width = 201
        Height = 13
        Caption = #1053#1086#1084#1077#1088' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1069#1090#1072#1087#1072' '#1055#1088#1086#1094#1077#1089#1089#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbRoutePointType: TLabel
        Left = 10
        Top = 103
        Width = 144
        Height = 13
        Caption = #1056#1072#1073#1086#1090#1072' '#1069#1090#1072#1087#1072' '#1055#1088#1086#1094#1077#1089#1089#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbJobPosition: TLabel
        Left = 48
        Top = 137
        Width = 108
        Height = 13
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1088#1086#1083#1100')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edProcessItemLevel: TEdit
        Left = 212
        Top = 17
        Width = 39
        Height = 21
        Enabled = False
        ReadOnly = True
        TabOrder = 0
        Text = '1'
        OnChange = DefaultOnChangeActions
      end
      object updnProcessItemLevel: TUpDown
        Left = 251
        Top = 17
        Width = 15
        Height = 21
        Associate = edProcessItemLevel
        Min = 1
        Max = 10
        Position = 1
        TabOrder = 1
      end
      object gbHowPositioningProcessItemLevel: TGroupBox
        Left = 2
        Top = 41
        Width = 333
        Height = 57
        Caption = #1055#1086#1083#1086#1078#1077#1085#1080#1077' '#1086#1090#1085#1086#1089#1080#1090#1077#1083#1100#1085#1086' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1069#1090#1072#1087#1072' '#1055#1088#1086#1094#1077#1089#1089#1072
        TabOrder = 2
        object rbInsertInsteedCurrent: TRadioButton
          Left = 8
          Top = 15
          Width = 161
          Height = 17
          Caption = #1042#1089#1090#1072#1074#1080#1090#1100' '#1074#1084#1077#1089#1090#1086' '#1090#1077#1082#1091#1097#1077#1081
          TabOrder = 0
        end
        object rbAddToEnd: TRadioButton
          Left = 8
          Top = 36
          Width = 113
          Height = 17
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074' '#1082#1086#1085#1077#1094
          Checked = True
          TabOrder = 1
          TabStop = True
        end
      end
      object cbProcessItemName: TComboBox
        Left = 167
        Top = 102
        Width = 171
        Height = 21
        ItemHeight = 13
        TabOrder = 3
        Text = 'cbProcessItemName'
        OnChange = DefaultOnChangeActions
      end
      object cbProcessItemJob: TComboBox
        Left = 167
        Top = 134
        Width = 171
        Height = 21
        ItemHeight = 13
        TabOrder = 4
        Text = 'cbProcessItemJob'
        OnChange = DefaultOnChangeActions
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1056#1072#1073#1086#1090#1072
      ImageIndex = 1
      object gbJob: TGroupBox
        Left = 0
        Top = 37
        Width = 411
        Height = 137
        Align = alClient
        Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1085#1099#1077' '#1088#1072#1073#1086#1090#1099
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 411
        Height = 37
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel1'
        TabOrder = 1
        object cbStandardJob: TCheckBox
          Left = 8
          Top = 8
          Width = 17
          Height = 17
          Caption = ' '
          Checked = True
          State = cbChecked
          TabOrder = 0
        end
        object stStandardJob: TStaticText
          Left = 24
          Top = 6
          Width = 163
          Height = 17
          Caption = #1058#1086#1083#1100#1082#1086' '#1089#1090#1072#1085#1076#1072#1088#1090#1085#1099#1077' '#1076#1077#1081#1089#1090#1074#1080#1103' '
          TabOrder = 1
        end
      end
    end
  end
end
