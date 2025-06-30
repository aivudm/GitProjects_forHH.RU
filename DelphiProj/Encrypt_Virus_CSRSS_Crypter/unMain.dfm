object formMain: TformMain
  Left = 319
  Top = 137
  Width = 745
  Height = 291
  Caption = 'formMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sbMain: TStatusBar
    Left = 0
    Top = 226
    Width = 737
    Height = 19
    Panels = <
      item
        Text = 'Key:'
        Width = 35
      end
      item
        Width = 200
      end
      item
        Text = 'CryptedBody:'
        Width = 75
      end
      item
        Width = 50
      end>
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 737
    Height = 29
    ButtonWidth = 65
    Caption = 'ToolBar1'
    TabOrder = 1
    object ToolButton1: TToolButton
      Left = 0
      Top = 2
      Hint = #1056#1072#1089#1082#1088#1080#1087#1090#1086#1074#1072#1090#1100
      Caption = #1056#1072#1089#1082#1088#1080#1087#1090#1086#1074#1072#1090#1100
      ImageIndex = 0
      OnClick = ToolButton1Click
    end
  end
  object MainMenu1: TMainMenu
    Left = 64
    Top = 8
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 88
    Top = 32
  end
end
