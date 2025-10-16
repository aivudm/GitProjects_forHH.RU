object formSelectObjectManufacture: TformSelectObjectManufacture
  Left = 313
  Top = 115
  Width = 708
  Height = 420
  Caption = 'formSelectObjectManufacture'
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
  object Panel1: TPanel
    Left = 0
    Top = 323
    Width = 692
    Height = 58
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object bbSave: TBitBtn
      Left = 208
      Top = 16
      Width = 97
      Height = 25
      Caption = #1042#1099#1073#1088#1072#1090#1100
      TabOrder = 0
      OnClick = bbSaveClick
      Kind = bkOK
    end
    object bbCancel: TBitBtn
      Left = 392
      Top = 16
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object dbgrObjectManufactureList: TDBGrid
    Left = 0
    Top = 0
    Width = 692
    Height = 323
    Align = alClient
    DataSource = dmDB.dsCommon
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'ShortName'
        Title.Caption = #1054#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077
        Width = 130
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'FullName'
        Title.Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        Width = 277
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MeasurmentUnit'
        Title.Caption = #1045#1076'. '#1080#1079#1084'.'
        Width = 48
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Notes'
        Title.Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        Width = 376
        Visible = True
      end>
  end
end
