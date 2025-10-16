object formEditSettings: TformEditSettings
  Left = 221
  Top = 204
  Width = 1102
  Height = 563
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1086#1074' '#1080' '#1087#1088#1086#1075#1088#1072#1084#1084#1085#1099#1093' '#1072#1083#1075#1086#1088#1080#1090#1084#1086#1074
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010002002020080000000000E80200002600000010100800000000002801
    00000E0300002800000020000000400000000100040000000000800200000000
    0000000000000000000000000000000000000000800000800000008080008000
    00008000800080800000C0C0C000808080000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF00000000000000000000000000000000000000
    00000000000000033000000000000000000000003B0000333000033000000000
    000000003B0300333000333000000000000000003B03333B0033333000000000
    0000000033B03330B033303000000000000000330B0B003B03000B0033000000
    000000333030B0B0B0B0B3033300000000000033330B0000000B0B0333000000
    000003B0B0B008078800B0B0B0000000000003333B00080788000B0000000000
    E066E060030008078800B030000000000E000E06030B0807880B0B3000000000
    00E000E030B038078803B0B0000000000600000E3B00080788000B0000000000
    000000000330088888000000000008788888880E666668000700000000000808
    88888800E0E6668888000000000008087777770E0E0666000000000000000808
    000000006000000000000000000000888888880E066000000000000000000000
    06E000E00660000000090000000000000E0E0E0E066600000099900000000000
    E0E0E0E6E066600009999900000000000E660E00066660009999999000000000
    0000006600000000999999900000000000000E66600000000999990000000000
    0000006660000000099999000000000000000000000000009999900000000000
    0000001111000009999900000000000000000000111009999900000000000000
    0000000000000000000000000000FFFFC3FFFFF9C39FFFF0C30FFFF0000FFFF0
    080FFF801041FF8208A1FF015501FF028081FF152055F002A121E443204FEBA2
    A08FF555204FF2A2202FC010819F800039FFA01403FFA00A1FFFAFD01FFFC000
    FEFFF090FC7FF228783FE544301FE888200FF0404007FF03F01FFF43F01FFF03
    E03FFF81807FFFC000FFFFF003FF280000001000000020000000010004000000
    0000C00000000000000000000000000000000000000000000000000080000080
    000000808000800000008000800080800000C0C0C000808080000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000000000
    0000003000000000003303B303B00000000B33033B0000000030B0B0B0300008
    003B00000B3080006800B80003000E60E00308003B00000E0E0B080003008000
    00800888000080000E0E60000000888800660000900000600E600009990006E6
    E0E6009999900000660E010999000000000000000000FF8F0000F8880000F800
    0000FC210000F8500000E08800000020000000A10000A8210000040900007237
    00000423000088C100000000000000010000E2030000}
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 485
    Width = 1086
    Height = 19
    Panels = <
      item
        Text = 'Idle'
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object pcontSettings: TPageControl
    Left = 0
    Top = 0
    Width = 1086
    Height = 485
    ActivePage = tabsheetRoutes
    Align = alClient
    Images = ilObjectExplorer
    TabOrder = 1
    OnChange = pcontSettingsChange
    OnResize = pcontSettingsResize
    object tabsheetCommonInfo: TTabSheet
      Caption = #1054#1073#1097#1077#1077' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077
      OnShow = tabsheetCommonInfoShow
      object Splitter1: TSplitter
        Left = 1075
        Top = 0
        Height = 456
        Align = alRight
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 0
        Width = 1075
        Height = 456
        Align = alClient
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080' '#1080' '#1075#1088#1091#1087#1087#1099'/'#1076#1086#1083#1078#1085#1086#1089#1090#1080
        TabOrder = 0
        object CoolBar1: TCoolBar
          Left = 2
          Top = 15
          Width = 1071
          Height = 41
          Bands = <
            item
              Control = toolbarDatabaseOperations
              ImageIndex = -1
              MinHeight = 33
              Width = 1067
            end>
          object toolbarDatabaseOperations: TToolBar
            Left = 9
            Top = 0
            Width = 1054
            Height = 33
            ButtonHeight = 28
            ButtonWidth = 35
            Caption = 'toolbarDatabaseOperations'
            Images = ilObjectExplorer
            TabOrder = 0
            object tbRefresh: TToolButton
              Left = 0
              Top = 2
              Caption = #1054#1073#1085#1086#1074#1080#1090#1100
              ImageIndex = 3
              OnClick = tbRefreshClick
            end
            object ToolButton18: TToolButton
              Left = 35
              Top = 2
              Width = 8
              Caption = 'ToolButton18'
              ImageIndex = 2
              Style = tbsSeparator
            end
            object tbApply: TToolButton
              Left = 43
              Top = 2
              Hint = 'Apply'
              Caption = 'Apply'
              Enabled = False
              ImageIndex = 7
              ParentShowHint = False
              ShowHint = True
            end
            object ToolButton5: TToolButton
              Left = 78
              Top = 2
              Hint = 'Open log'
              Caption = 'ToolButton5'
              ImageIndex = 2
            end
            object ToolButton1: TToolButton
              Left = 113
              Top = 2
              Width = 8
              Caption = 'ToolButton1'
              ImageIndex = 2
              Style = tbsSeparator
            end
            object ToolButton3: TToolButton
              Left = 121
              Top = 2
              Width = 8
              Caption = 'ToolButton3'
              ImageIndex = 2
              Style = tbsSeparator
            end
            object ToolButton4: TToolButton
              Left = 129
              Top = 2
              Width = 8
              Caption = 'ToolButton4'
              ImageIndex = 3
              Style = tbsSeparator
            end
            object tbExit: TToolButton
              Left = 137
              Top = 2
              Hint = 'Exit'
              Caption = 'tbExit'
              ImageIndex = 1
            end
            object ToolButton17: TToolButton
              Left = 172
              Top = 2
              Width = 29
              Caption = 'ToolButton17'
              ImageIndex = 2
              Style = tbsSeparator
            end
            object GroupBox4: TGroupBox
              Left = 201
              Top = 2
              Width = 133
              Height = 28
              TabOrder = 0
              object CheckBox1: TCheckBox
                Left = 16
                Top = 8
                Width = 114
                Height = 17
                Caption = #1057#1087#1080#1089#1086#1082' '#1087#1086' '#1060'.'#1048'.'#1054'.'
                TabOrder = 0
              end
            end
            object ToolButton20: TToolButton
              Left = 334
              Top = 2
              Width = 19
              Caption = 'ToolButton20'
              ImageIndex = 3
              Style = tbsSeparator
            end
            object tbEditOnOff: TToolButton
              Left = 353
              Top = 2
              Hint = #1042#1082#1083#1102#1095#1080#1090#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
              Caption = 'tbEditOnOff'
              ImageIndex = 2
              ParentShowHint = False
              ShowHint = True
              Style = tbsCheck
              OnClick = tbEditOnOffClick
            end
          end
        end
        object tvUserJobRole: TTreeView
          Left = 2
          Top = 56
          Width = 1071
          Height = 398
          Align = alClient
          Indent = 19
          ReadOnly = True
          TabOrder = 1
          OnDblClick = tvUserJobRoleDblClick
        end
      end
    end
    object tabsheetRoutes: TTabSheet
      Caption = #1055#1088#1086#1094#1077#1089#1089#1099
      ImageIndex = 1
      OnShow = tabsheetRoutesShow
      object Splitter6: TSplitter
        Left = 489
        Top = 209
        Height = 247
      end
      object gbRoutesDescriptions: TGroupBox
        Left = 0
        Top = 0
        Width = 1078
        Height = 209
        Align = alTop
        Caption = #1055#1077#1088#1077#1095#1077#1085#1100' '#1096#1072#1073#1083#1086#1085#1086#1074' '#1087#1088#1086#1094#1077#1089#1089#1086#1074
        TabOrder = 0
        object ToolBar1: TToolBar
          Left = 2
          Top = 15
          Width = 1074
          Height = 29
          Caption = 'ToolBar2'
          Images = ilDirectoryOperations
          TabOrder = 0
          object tbRefreshProcess: TToolButton
            Left = 0
            Top = 2
            Hint = #1054#1073#1085#1086#1074#1080#1090#1100
            Caption = 'tbRefreshProcess'
            ImageIndex = 8
            ParentShowHint = False
            ShowHint = True
            OnClick = tbRefreshProcessClick
          end
          object ToolButton2: TToolButton
            Left = 23
            Top = 2
            Width = 41
            Caption = 'ToolButton2'
            ImageIndex = 8
            Style = tbsSeparator
          end
          object tbEditProcess: TToolButton
            Left = 64
            Top = 2
            Caption = 'tbEditProcess'
            ImageIndex = 6
            ParentShowHint = False
            ShowHint = True
            OnClick = tbEditProcessClick
          end
          object tbAddProcess: TToolButton
            Left = 87
            Top = 2
            Caption = 'AddOrdersItem'
            ImageIndex = 5
            ParentShowHint = False
            ShowHint = True
            OnClick = tbAddProcessClick
          end
          object ToolButton6: TToolButton
            Left = 110
            Top = 2
            Width = 11
            Caption = 'ToolButton6'
            ImageIndex = 2
            Style = tbsSeparator
          end
          object tbDeleteProcess: TToolButton
            Left = 121
            Top = 2
            Hint = #1042#1082#1083'/'#1042#1099#1082#1083' '#1072#1082#1090#1080#1074#1085#1086#1089#1090#1080' '#1084#1072#1088#1096#1088#1091#1090#1072
            Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1084#1072#1088#1096#1088#1091#1090
            ImageIndex = 7
            ParentShowHint = False
            ShowHint = True
            OnClick = tbDeleteProcessClick
          end
          object ToolButton7: TToolButton
            Left = 144
            Top = 2
            Width = 16
            Caption = 'ToolButton7'
            ImageIndex = 8
            Style = tbsSeparator
          end
          object cbShowDeactivatedProcess: TCheckBox
            Left = 160
            Top = 2
            Width = 300
            Height = 22
            Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1085#1077#1072#1082#1090#1080#1074#1085#1099#1077' ('#1091#1076#1072#1083#1077#1085#1085#1099#1077') '#1087#1088#1086#1094#1077#1089#1089#1099
            TabOrder = 0
            OnClick = cbShowDeactivatedProcessClick
          end
        end
        object dbgProcessList: TDBGrid
          Left = 2
          Top = 44
          Width = 1074
          Height = 163
          Align = alClient
          DataSource = dmDB.dsProcessList
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          OnDrawColumnCell = dbgProcessListDrawColumnCell
          Columns = <
            item
              Expanded = False
              FieldName = 'Id'
              Title.Caption = #1053#1086#1084#1077#1088
              Width = 60
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ShortName'
              Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Width = 322
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FullName'
              Width = 255
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Notes'
              Width = 427
              Visible = True
            end>
        end
      end
      object gbJobProcessItem: TGroupBox
        Left = 492
        Top = 209
        Width = 586
        Height = 247
        Align = alClient
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1088#1072#1073#1086#1090#1099' '#1101#1090#1072#1087#1072' '#1087#1088#1086#1094#1077#1089#1089#1072
        TabOrder = 1
        object ToolBar4: TToolBar
          Left = 2
          Top = 15
          Width = 582
          Height = 29
          Caption = 'ToolBar2'
          Images = ilDirectoryOperations
          TabOrder = 0
          object tbRefreshJobItems: TToolButton
            Left = 0
            Top = 2
            Hint = #1054#1073#1085#1086#1074#1080#1090#1100
            Caption = 'ToolButton7'
            ImageIndex = 8
            ParentShowHint = False
            ShowHint = True
            OnClick = tbRefreshJobItemsClick
          end
          object ToolButton24: TToolButton
            Left = 23
            Top = 2
            Width = 41
            Caption = 'ToolButton2'
            ImageIndex = 8
            Style = tbsSeparator
          end
          object tbEditJobItem: TToolButton
            Left = 64
            Top = 2
            Caption = 'tbEditOrdersItem'
            ImageIndex = 6
            ParentShowHint = False
            ShowHint = True
            OnClick = tbEditJobItemClick
          end
          object tbAddJobItem: TToolButton
            Left = 87
            Top = 2
            Caption = 'AddOrdersItem'
            ImageIndex = 5
            ParentShowHint = False
            ShowHint = True
            OnClick = tbAddJobItemClick
          end
          object ToolButton27: TToolButton
            Left = 110
            Top = 2
            Width = 11
            Caption = 'ToolButton6'
            ImageIndex = 2
            Style = tbsSeparator
          end
          object tbDeleteJobItem: TToolButton
            Left = 121
            Top = 2
            Caption = 'DeleteOrdersItem'
            ImageIndex = 7
            ParentShowHint = False
            ShowHint = True
          end
          object ToolButton49: TToolButton
            Left = 144
            Top = 2
            Width = 18
            Caption = 'ToolButton49'
            ImageIndex = 8
            Style = tbsSeparator
          end
          object rbForDocumentItem: TRadioButton
            Left = 162
            Top = 2
            Width = 156
            Height = 22
            Caption = #1044#1083#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
            Checked = True
            TabOrder = 0
            TabStop = True
            OnClick = rbForDocumentItemClick
          end
          object rbForDocument: TRadioButton
            Left = 318
            Top = 2
            Width = 113
            Height = 22
            Caption = #1044#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
            TabOrder = 1
            OnClick = rbForDocumentClick
          end
        end
        object dbgJobItem: TDBGrid
          Left = 2
          Top = 44
          Width = 582
          Height = 201
          Align = alClient
          DataSource = dmDB.dsJobItem
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
          ReadOnly = True
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'JobItemLevel'
              Title.Caption = #1055#1086#1088#1103#1076#1082#1086#1074#1099#1081' '#8470' '#1101#1083#1077#1084#1077#1085#1090#1072' '#1088#1072#1073#1086#1090#1099
              Width = 160
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'JobItemName'
              Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1101#1083#1077#1084#1077#1085#1090#1072' '#1088#1072#1073#1086#1090#1099
              Width = 398
              Visible = True
            end>
        end
      end
      object gbJobProcess: TGroupBox
        Left = 0
        Top = 209
        Width = 489
        Height = 247
        Align = alLeft
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1101#1090#1072#1087#1086#1074' '#1087#1088#1086#1094#1077#1089#1089#1072
        TabOrder = 2
        object ToolBar8: TToolBar
          Left = 2
          Top = 15
          Width = 485
          Height = 29
          Caption = 'ToolBar2'
          Images = ilDirectoryOperations
          TabOrder = 0
          object ToolButton16: TToolButton
            Left = 0
            Top = 2
            Hint = #1054#1073#1085#1086#1074#1080#1090#1100
            Caption = 'ToolButton7'
            ImageIndex = 8
            ParentShowHint = False
            ShowHint = True
            OnClick = tbRefreshJobItemsClick
          end
          object ToolButton39: TToolButton
            Left = 23
            Top = 2
            Width = 41
            Caption = 'ToolButton2'
            ImageIndex = 8
            Style = tbsSeparator
          end
          object ToolButton40: TToolButton
            Left = 64
            Top = 2
            Caption = 'tbEditOrdersItem'
            ImageIndex = 6
            ParentShowHint = False
            ShowHint = True
            OnClick = tbEditJobItemClick
          end
          object ToolButton41: TToolButton
            Left = 87
            Top = 2
            Caption = 'AddOrdersItem'
            ImageIndex = 5
            ParentShowHint = False
            ShowHint = True
            OnClick = tbAddJobItemClick
          end
          object ToolButton47: TToolButton
            Left = 110
            Top = 2
            Width = 11
            Caption = 'ToolButton6'
            ImageIndex = 2
            Style = tbsSeparator
          end
          object ToolButton48: TToolButton
            Left = 121
            Top = 2
            Caption = 'DeleteOrdersItem'
            ImageIndex = 7
            ParentShowHint = False
            ShowHint = True
            OnClick = ToolButton48Click
          end
        end
        object Panel5: TPanel
          Left = 2
          Top = 44
          Width = 485
          Height = 201
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel5'
          TabOrder = 1
          object dbgProcessItem: TDBGrid
            Left = 0
            Top = 0
            Width = 485
            Height = 201
            Align = alClient
            DataSource = dmDB.dsProcessItem
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
            ReadOnly = True
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            Columns = <
              item
                Expanded = False
                FieldName = 'ProcessItemLevel'
                Title.Caption = #1053#1086#1084#1077#1088' '#1069#1090#1072#1087#1072
                Width = 122
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'ProcessItemName'
                Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1101#1090#1072#1087#1072
                Width = 172
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'JobRoleName'
                Title.Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' '#1086#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1086#1075#1086
                Width = 167
                Visible = True
              end>
          end
        end
      end
    end
    object tabsheetUsers: TTabSheet
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
      ImageIndex = 2
      object GroupBox5: TGroupBox
        Left = 0
        Top = 0
        Width = 1078
        Height = 233
        Align = alTop
        Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object Splitter4: TSplitter
          Left = 592
          Top = 15
          Height = 216
        end
        object Panel4: TPanel
          Left = 2
          Top = 15
          Width = 590
          Height = 216
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel4'
          TabOrder = 0
          object ToolBar5: TToolBar
            Left = 0
            Top = 0
            Width = 590
            Height = 33
            Caption = 'ToolBar2'
            Images = ilDirectoryOperations
            TabOrder = 0
            object tbRefreshUsersList: TToolButton
              Left = 0
              Top = 2
              Hint = #1054#1073#1085#1086#1074#1080#1090#1100
              Caption = 'ToolButton7'
              ImageIndex = 8
              ParentShowHint = False
              ShowHint = True
              OnClick = tbRefreshUsersListClick
            end
            object ToolButton30: TToolButton
              Left = 23
              Top = 2
              Width = 41
              Caption = 'ToolButton2'
              ImageIndex = 8
              Style = tbsSeparator
            end
            object ToolButton31: TToolButton
              Left = 64
              Top = 2
              Caption = 'tbEditOrdersItem'
              ImageIndex = 6
              ParentShowHint = False
              ShowHint = True
              OnClick = ToolButton31Click
            end
            object ToolButton32: TToolButton
              Left = 87
              Top = 2
              Caption = 'AddOrdersItem'
              ImageIndex = 5
              ParentShowHint = False
              ShowHint = True
              OnClick = ToolButton32Click
            end
            object ToolButton33: TToolButton
              Left = 110
              Top = 2
              Width = 11
              Caption = 'ToolButton6'
              ImageIndex = 2
              Style = tbsSeparator
            end
            object ToolButton34: TToolButton
              Left = 121
              Top = 2
              Caption = 'DeleteOrdersItem'
              ImageIndex = 7
              ParentShowHint = False
              ShowHint = True
              OnClick = ToolButton34Click
            end
            object ToolButton8: TToolButton
              Left = 144
              Top = 2
              Width = 17
              Caption = 'ToolButton8'
              ImageIndex = 8
              Style = tbsSeparator
            end
            object cbShowDeletedUsers: TCheckBox
              Left = 161
              Top = 2
              Width = 300
              Height = 22
              Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1085#1077#1072#1082#1090#1080#1074#1085#1099#1093' ('#1091#1076#1072#1083#1077#1085#1085#1099#1093')  '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
              TabOrder = 0
              OnClick = cbShowDeactivatedProcessClick
            end
          end
          object dbgUsersList: TDBGrid
            Left = 0
            Top = 33
            Width = 590
            Height = 183
            Align = alClient
            DataSource = dmDB.dsUserList
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
            ReadOnly = True
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            OnDrawColumnCell = dbgUsersListDrawColumnCell
            OnDblClick = dbgUsersListDblClick
            Columns = <
              item
                Expanded = False
                FieldName = 'ShortName'
                Width = 167
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'LoginName'
                Width = 68
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'JobRoleName'
                Width = 116
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'FullName'
                Width = 369
                Visible = True
              end>
          end
        end
        object GroupBox6: TGroupBox
          Left = 595
          Top = 15
          Width = 481
          Height = 216
          Align = alClient
          Caption = #1056#1086#1083#1080
          TabOrder = 1
          object ToolBar3: TToolBar
            Left = 2
            Top = 15
            Width = 477
            Height = 33
            Caption = 'ToolBar2'
            Images = ilDirectoryOperations
            TabOrder = 0
            object tbJobRole_byUser: TToolButton
              Left = 0
              Top = 2
              Hint = #1054#1073#1085#1086#1074#1080#1090#1100
              Caption = 'ToolButton7'
              ImageIndex = 8
              ParentShowHint = False
              ShowHint = True
              OnClick = tbRefreshUsersListClick
            end
            object ToolButton19: TToolButton
              Left = 23
              Top = 2
              Width = 41
              Caption = 'ToolButton2'
              ImageIndex = 8
              Style = tbsSeparator
            end
            object ToolButton21: TToolButton
              Left = 64
              Top = 2
              Caption = 'tbEditOrdersItem'
              ImageIndex = 6
              ParentShowHint = False
              ShowHint = True
              OnClick = ToolButton31Click
            end
            object ToolButton22: TToolButton
              Left = 87
              Top = 2
              Caption = 'AddOrdersItem'
              ImageIndex = 5
              ParentShowHint = False
              ShowHint = True
              OnClick = ToolButton32Click
            end
            object ToolButton23: TToolButton
              Left = 110
              Top = 2
              Width = 11
              Caption = 'ToolButton6'
              ImageIndex = 2
              Style = tbsSeparator
            end
            object ToolButton25: TToolButton
              Left = 121
              Top = 2
              Caption = 'DeleteOrdersItem'
              ImageIndex = 7
              ParentShowHint = False
              ShowHint = True
              OnClick = ToolButton34Click
            end
            object ToolButton26: TToolButton
              Left = 144
              Top = 2
              Width = 17
              Caption = 'ToolButton8'
              ImageIndex = 8
              Style = tbsSeparator
            end
            object CheckBox2: TCheckBox
              Left = 161
              Top = 2
              Width = 300
              Height = 22
              Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1085#1077#1072#1082#1090#1080#1074#1085#1099#1093' ('#1091#1076#1072#1083#1077#1085#1085#1099#1093')  '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
              TabOrder = 0
              OnClick = cbShowDeactivatedProcessClick
            end
          end
          object DBGrid3: TDBGrid
            Left = 2
            Top = 48
            Width = 477
            Height = 166
            Align = alClient
            DataSource = dmDB.dsJobRole
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
            ReadOnly = True
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            OnDrawColumnCell = dbgUsersListDrawColumnCell
            OnDblClick = dbgUsersListDblClick
            Columns = <
              item
                Expanded = False
                FieldName = 'ShortName'
                Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1088#1086#1083#1080
                Width = 167
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'LoginName'
                Title.Caption = 'Login'
                Width = 68
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'FullName'
                Title.Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1088#1086#1083#1080
                Width = 230
                Visible = True
              end>
          end
        end
      end
      object GroupBox7: TGroupBox
        Left = 0
        Top = 233
        Width = 1078
        Height = 223
        Align = alClient
        Caption = #1042#1080#1088#1090#1091#1072#1083#1100#1085#1099#1077' '#1056#1086#1083#1080
        TabOrder = 1
        object Splitter5: TSplitter
          Left = 585
          Top = 15
          Height = 206
        end
        object Panel6: TPanel
          Left = 2
          Top = 15
          Width = 583
          Height = 206
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'Panel6'
          TabOrder = 0
          object ToolBar7: TToolBar
            Left = 0
            Top = 0
            Width = 583
            Height = 29
            Caption = 'ToolBar2'
            Images = ilDirectoryOperations
            TabOrder = 0
            object tbVirtyualJobRoleList: TToolButton
              Left = 0
              Top = 2
              Hint = #1054#1073#1085#1086#1074#1080#1090#1100
              Caption = 'ToolButton7'
              ImageIndex = 8
              ParentShowHint = False
              ShowHint = True
              OnClick = tbVirtyualJobRoleListClick
            end
            object ToolButton42: TToolButton
              Left = 23
              Top = 2
              Width = 41
              Caption = 'ToolButton2'
              ImageIndex = 8
              Style = tbsSeparator
            end
            object ToolButton43: TToolButton
              Left = 64
              Top = 2
              Caption = 'tbEditOrdersItem'
              ImageIndex = 6
              ParentShowHint = False
              ShowHint = True
              OnClick = ToolButton43Click
            end
            object ToolButton44: TToolButton
              Left = 87
              Top = 2
              Caption = 'AddOrdersItem'
              ImageIndex = 5
              ParentShowHint = False
              ShowHint = True
              OnClick = ToolButton44Click
            end
            object ToolButton45: TToolButton
              Left = 110
              Top = 2
              Width = 11
              Caption = 'ToolButton6'
              ImageIndex = 2
              Style = tbsSeparator
            end
            object ToolButton46: TToolButton
              Left = 121
              Top = 2
              Caption = 'DeleteOrdersItem'
              ImageIndex = 7
              ParentShowHint = False
              ShowHint = True
            end
          end
          object dbgAliasJobRoleList: TDBGrid
            Left = 0
            Top = 29
            Width = 583
            Height = 177
            Align = alClient
            DataSource = dmDB.dsJobRoleVirtual
            Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
            ReadOnly = True
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            OnDrawColumnCell = dbgAliasJobRoleListDrawColumnCell
            Columns = <
              item
                Expanded = False
                FieldName = 'ShortName'
                Width = 194
                Visible = True
              end
              item
                Expanded = False
                FieldName = 'Notes'
                Width = 325
                Visible = True
              end>
          end
        end
        object Panel7: TPanel
          Left = 588
          Top = 15
          Width = 488
          Height = 206
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel7'
          TabOrder = 1
        end
      end
    end
    object TabSheet1: TTabSheet
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      ImageIndex = 3
      object Splitter2: TSplitter
        Left = 250
        Top = 0
        Height = 456
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 250
        Height = 456
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Panel1'
        TabOrder = 0
        object GroupBox2: TGroupBox
          Left = 0
          Top = 0
          Width = 250
          Height = 456
          Align = alClient
          Caption = #1055#1077#1088#1077#1095#1077#1085#1100' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1086#1074
          TabOrder = 0
          object DBGrid2: TDBGrid
            Left = 2
            Top = 48
            Width = 246
            Height = 406
            Align = alClient
            DataSource = dmDB.dsSpravList
            TabOrder = 0
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
            Columns = <
              item
                Expanded = False
                FieldName = 'ShortName'
                ReadOnly = True
                Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
                Width = 218
                Visible = True
              end>
          end
          object ToolBar6: TToolBar
            Left = 2
            Top = 15
            Width = 246
            Height = 33
            Caption = 'ToolBar2'
            Images = ilDirectoryOperations
            TabOrder = 1
            object tbRefreshSpravList: TToolButton
              Left = 0
              Top = 2
              Hint = #1054#1073#1085#1086#1074#1080#1090#1100
              Caption = 'ToolButton7'
              ImageIndex = 8
              ParentShowHint = False
              ShowHint = True
              OnClick = tbRefreshSpravListClick
            end
            object ToolButton28: TToolButton
              Left = 23
              Top = 2
              Width = 18
              Caption = 'ToolButton2'
              ImageIndex = 8
              Style = tbsSeparator
            end
            object ToolButton29: TToolButton
              Left = 41
              Top = 2
              Caption = 'tbEditOrdersItem'
              ImageIndex = 6
              ParentShowHint = False
              ShowHint = True
              OnClick = ToolButton31Click
            end
            object ToolButton35: TToolButton
              Left = 64
              Top = 2
              Caption = 'AddOrdersItem'
              ImageIndex = 5
              ParentShowHint = False
              ShowHint = True
              OnClick = ToolButton32Click
            end
            object ToolButton36: TToolButton
              Left = 87
              Top = 2
              Width = 11
              Caption = 'ToolButton6'
              ImageIndex = 2
              Style = tbsSeparator
            end
            object ToolButton37: TToolButton
              Left = 98
              Top = 2
              Caption = 'DeleteOrdersItem'
              ImageIndex = 7
              ParentShowHint = False
              ShowHint = True
              OnClick = ToolButton34Click
            end
            object ToolButton38: TToolButton
              Left = 121
              Top = 2
              Width = 17
              Caption = 'ToolButton8'
              ImageIndex = 8
              Style = tbsSeparator
            end
            object CheckBox3: TCheckBox
              Left = 138
              Top = 2
              Width = 300
              Height = 22
              Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1085#1077#1072#1082#1090#1080#1074#1085#1099#1093' ('#1091#1076#1072#1083#1077#1085#1085#1099#1093')  '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081
              TabOrder = 0
              OnClick = cbShowDeactivatedProcessClick
            end
          end
        end
      end
      object Panel2: TPanel
        Left = 253
        Top = 0
        Width = 825
        Height = 456
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel2'
        TabOrder = 1
        object Splitter3: TSplitter
          Left = 0
          Top = 193
          Width = 825
          Height = 3
          Cursor = crVSplit
          Align = alTop
        end
        object GroupBox3: TGroupBox
          Left = 0
          Top = 0
          Width = 825
          Height = 193
          Align = alTop
          Caption = #1057#1086#1076#1077#1088#1078#1072#1085#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1086#1074
          TabOrder = 0
          object ToolBar2: TToolBar
            Left = 2
            Top = 15
            Width = 821
            Height = 29
            Caption = 'ToolBar2'
            Images = ilDirectoryOperations
            TabOrder = 0
            object tbRefreshSpravData: TToolButton
              Left = 0
              Top = 2
              Hint = #1054#1073#1085#1086#1074#1080#1090#1100
              Caption = 'ToolButton7'
              ImageIndex = 8
              ParentShowHint = False
              ShowHint = True
              OnClick = tbRefreshSpravDataClick
            end
            object ToolButton10: TToolButton
              Left = 23
              Top = 2
              Width = 41
              Caption = 'ToolButton2'
              ImageIndex = 8
              Style = tbsSeparator
            end
            object ToolButton11: TToolButton
              Left = 64
              Top = 2
              Caption = 'tbEditOrdersItem'
              ImageIndex = 6
              ParentShowHint = False
              ShowHint = True
              OnClick = ToolButton31Click
            end
            object ToolButton12: TToolButton
              Left = 87
              Top = 2
              Caption = 'AddOrdersItem'
              ImageIndex = 5
              ParentShowHint = False
              ShowHint = True
              OnClick = ToolButton32Click
            end
            object ToolButton13: TToolButton
              Left = 110
              Top = 2
              Width = 11
              Caption = 'ToolButton6'
              ImageIndex = 2
              Style = tbsSeparator
            end
            object ToolButton14: TToolButton
              Left = 121
              Top = 2
              Caption = 'DeleteOrdersItem'
              ImageIndex = 7
              ParentShowHint = False
              ShowHint = True
              OnClick = ToolButton34Click
            end
            object ToolButton15: TToolButton
              Left = 144
              Top = 2
              Width = 17
              Caption = 'ToolButton8'
              ImageIndex = 8
              Style = tbsSeparator
            end
          end
          object DBGrid1: TDBGrid
            Left = 2
            Top = 44
            Width = 821
            Height = 147
            Align = alClient
            DataSource = dmDB.dsSpravData
            TabOrder = 1
            TitleFont.Charset = DEFAULT_CHARSET
            TitleFont.Color = clWindowText
            TitleFont.Height = -11
            TitleFont.Name = 'MS Sans Serif'
            TitleFont.Style = []
          end
        end
        object Panel3: TPanel
          Left = 0
          Top = 196
          Width = 825
          Height = 260
          Align = alClient
          BevelOuter = bvNone
          Caption = 'Panel3'
          TabOrder = 1
          object GroupBox8: TGroupBox
            Left = 0
            Top = 0
            Width = 825
            Height = 260
            Align = alClient
            Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1089#1086#1089#1090#1072#1074#1083#1103#1102#1097#1080#1077' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1086#1074
            TabOrder = 0
          end
        end
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 552
    object N1: TMenuItem
      Caption = #1060#1072#1081#1083
      object N2: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = N2Click
      end
    end
  end
  object ilDirectoryOperations: TImageList
    Left = 513
    Top = 32
    Bitmap = {
      494C010109000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000FF000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000FF0000000000000000000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000000000000000000000000000FF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF000000FF000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6844A00DE9C
      5A00DEA56B00DEA56B00DEA56B00DEA56B00DEA56B00DEA56B00DE9C6300DE9C
      6300D68C4A00D67B310000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000DE9C6300FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00D6944A0000000000000000000000000000000000E7A56300FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFFF700FFFFF700FFFFF700FFF7
      EF00FFF7EF00DE94520000000000000000000000000000000000000000000000
      0000000000001818AD000018CE000029EF000029EF000010B5006363C6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009C949C00BDBDBD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7AD7B00FFFF
      FF00FFFFFF00FFFFF700FFFFF700FFF7EF00FFF7EF00FFF7E700FFF7E700FFEF
      E700FFFFF700DEA56B0000000000000000000000000000000000E7AD6B00FFFF
      F700FFFFF700FFF7EF00FFF7EF00FFF7EF00FFF7E700FFF7E700FFEFDE00FFEF
      DE00FFEFD600DE9C520000000000000000000000000000000000000000003942
      C6003163FF000039FF000031FF000031FF000031FF000031FF000031FF000021
      DE00E7E7F7000000000000000000000000000000000000000000000000000000
      000000000000000000009C9C9C009C9C9C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7B58400FFFF
      FF00FFF7F700FFF7EF00FFF7EF00FFF7E700FFF7E700FFEFDE00FFEFDE00FFEF
      D600FFFFF700DEA5730000000000000000000000000000000000E7AD6B00FFFF
      F700FFF7EF00FFF7EF00FFF7E700FFF7E700FFEFDE00FFEFDE00FFEFDE00FFEF
      D600FFEFD600DE9C5A00000000000000000000000000000000002129C600396B
      FF001042FF001042FF000839FF003163FF00638CFF005284FF000031FF000031
      FF000031FF00E7E7F70000000000000000000000000000000000000000000000
      0000000000000000000000000000ADA5A5006B6B6B0000000000000000000000
      0000000000000000000000000000000000000000000000000000E7B58400FFFF
      FF00FFF7E700FFF7E700FFEFDE00FFEFDE00FFEFD600FFEFD600FFE7CE00FFE7
      CE00FFFFF700E7AD730000000000000000000000000000000000E7B57300FFF7
      EF00FFF7E700FFF7E700FFF7E700FFEFDE00FFEFDE00FFEFD600FFEFD600FFE7
      CE00FFE7CE00E7A56300000000000000000000000000D6D6F70073A5FF002152
      FF002152FF00394AEF00000000000000000000000000294AF7000031FF000031
      FF000031FF000021DE0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000ADADAD006363630000000000636B
      6B00000000000000000000000000000000000000000000000000EFBD8C00FFFF
      F700FFEFDE00FFEFDE00FFEFD600FFEFD600FFE7CE00FFE7CE00FFE7C600FFE7
      C600FFF7EF00E7AD7B0000000000000000000000000000000000EFB57B00FFF7
      E700FFF7E700FFEFDE00FFEFDE00FFEFD600FFEFD600FFE7D600FFE7CE00FFE7
      CE00FFE7C600E7A563000000000000000000000000002939D6007B9CFF006B8C
      FF004A63E7000000000000000000000000002942EF000842FF000839FF000031
      FF000031FF000031FF006B73D600000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BDB5B500000000000000
      000000000000CEC6BD0000000000000000000000000000000000EFBD8C001073
      08001073080010730800FFE7CE00FFE7C600FFE7C600FFDEBD00FFDEBD00FFDE
      BD00FFF7EF00E7B57B0000000000000000000000000000000000EFBD7B00FFEF
      E700FFEFDE00FFEFDE0021A5DE00FFEFD600FFE7CE00FFE7CE00FFE7C600FFE7
      C600FFDEC600E7AD6B00000000000000000000000000A5C6FF007B9CFF004A63
      EF000000000000000000000000002142E700184AFF00184AFF001042FF002942
      EF002939FF000031FF001021CE00000000000000000000000000000000000000
      000000000000B5DEE700ADE7EF00ADF7F700525A630000000000000000000000
      00000000000000000000ADA59C00000000000000000000000000EFC694000084
      0000009C000010730800FFE7C600FFDEBD00FFDEBD00FFDEB500FFDEB500FFD6
      AD00FFF7EF00E7B5840000000000000000000000000000000000EFBD8400FFEF
      DE00FFEFD600FFEFD60021ADDE006BADD60021A5D600FFE7C600FFE7C600FFDE
      BD00FFDEBD00E7AD7300000000000000000000000000ADC6FF008CA5FF001831
      D60000000000000000002139DE00295AFF00215AFF002152FF002142E7000000
      0000394AFF000839FF000831F700000000000000000000000000B5DEE700CEF7
      F700CEF7F700C6EFF700B5EFEF00ADEFF700ADB5A5009C9C8400B5CECE00FFF7
      EF00FFF7E700FFEFE700F7DEBD00000000000000000000000000EFC694000084
      000039D6520010730800FFDEB500FFDEB500FFD6AD00FFD6AD00FFD6AD00FFD6
      A500FFF7EF00E7BD840000000000000000000000000000000000EFC68C00FFEF
      D600FFEFD600FFE7CE00FFE7CE0042ADFF0000DEFF0000A5DE00FFDEBD00FFDE
      BD00FFDEB500EFB57300000000000000000000000000ADCEFF0094ADFF001829
      CE00000000002131D6007B9CFF00396BFF003163FF002139DE00000000000000
      0000425AF700104AFF001039F70000000000ADF7F700C6F7F700CEF7F700CEF7
      F700CEF7F700CEF7F700ADEFF70094DEDE00B5B5A500B5C6AD00ADA58C00CED6
      C600EFEFDE00FFEFD600F7D6BD00000000000084000000840000008400000084
      000039D6520010730800107308001073080010730800FFD6A500FFCE9C00FFCE
      9C00FFF7E700EFBD8C0000000000000000000000000000000000F7C68C00FFE7
      CE00FFE7CE00FFE7CE00FFE7C60063C6DE0000EFFF0000E7FF0000ADE700FFDE
      B500FFD6AD00EFB57B00000000000000000000000000B5CEFF009CB5FF003142
      D6002131CE008CADFF0084A5FF007B9CFF002131D60000000000000000000000
      00002152FF002152FF001839EF0000000000ADF7F700ADF7F700BDF7F700B5E7
      EF009CD6DE0094DEDE00ADEFF700ADF7FF00848C8400B5BD9C00EFEFE700DED6
      C600DED6BD00C6C6AD00BDAD9C000000000008A5080039D6520039D6520039D6
      520039D6520039D6520039D6520008A5100000840000FFCE9C00FFCE9C00FFCE
      9C00FFF7E700EFBD8C0000000000000000000000000000000000F7CE9400FFE7
      CE00FFE7C600FFE7C600FFDEBD00FFDEBD0063CEDE0000F7FF0000EFFF0000B5
      EF00FFD6AD00EFBD84000000000000000000000000007B94FF00B5CEFF009CB5
      FF009CB5FF0094B5FF0094ADFF002131CE000000000000000000000000002939
      D600295AFF00295AFF003142DE000000000094DEE7007BC6CE0042849400528C
      9400528C940052949C006BA5AD0084B5BD0073A5A500B5AD9400EFEFDE00EFEF
      E700E7DED600CECEB50073949C000000000008A5080039CE5A0031C6520031CE
      520039D65200109418001094180010941800107B1000FFFFF700FFFFF700FFFF
      F700FFF7F700EFBD840000000000000000000000000000000000F7CE9C00FFE7
      C600FFE7C600FFDEBD00FFDEBD00FFDEB500FFDEB50063CEDE0000FFFF0000EF
      FF0000BDF700F7C69400000000000000000000000000637BFF00BDD6FF00ADC6
      FF009CB5FF009CB5FF001829C6000000000000000000000000004252D600396B
      FF00396BFF003163FF000000000000000000528C940018424A004A7B7B0084B5
      BD00ADD6D600A5CEDE005AB5C6000884AD00A5CEDE0073A5A5007B8C8C009C94
      8C007B8C8C005A6B6B008CD6DE00000000000000000000000000F7D6A50039CE
      5A004AE7730010941800FFCE9C00FFCE9C00FFCE9C00FFFFF700FFFFF700FFFF
      F700EFC69400EF9C8C0000000000000000000000000000000000F7D69C00FFDE
      BD00FFDEBD00FFDEB500FFDEB500FFDEB500FFD6AD00FFD6AD0063E7FF0000FF
      FF0000F7FF00B584840000000000000000000000000000000000526BFF00BDD6
      FF00ADC6FF00A5BDFF002939CE001018BD001021C600526BE7008CADFF005A84
      FF00527BFF00526BEF0000000000000000000000000000000000B5E7EF0084BD
      C600C6F7FF00B5F7FF008CEFF7005AD6EF0018BDE70021A5CE00B5CED60073AD
      B500ADEFF700B5FFFF005A8C8C00000000000000000000000000F7D6AD0042DE
      730063FF940010941800FFCE9C00FFCE9C00FFCE9C00FFFFF700FFFFF700EFC6
      9400EF9C8C000000000000000000000000000000000000000000FFD6A500FFDE
      BD00FFDEB500FFDEB500FFD6AD00FFD6AD00FFD6A500FFD6A500FFFFFF005ACE
      D600DEC6C600C6B5D6002121AD0000000000000000000000000000000000526B
      FF00BDD6FF00BDD6FF00A5BDFF009CBDFF009CB5FF009CB5FF0094ADFF00ADC6
      FF00395AF7000000000000000000000000000000000000000000000000000000
      0000C6EFEF006BADC600DEEFEF00F7FFFF00D6FFFF009CFFFF005AFFFF006BC6
      D60084ADAD008CC6C600ADD6D600000000000000000000000000F7D6AD0008A5
      080008A5080010941800FFF7E700FFF7E700FFF7E700FFFFF700F7CE9C00F7A5
      9400000000000000000000000000000000000000000000000000FFDEAD00FFEF
      DE00FFEFD600FFEFD600FFEFD600FFEFD600FFEFD600FFFFFF00F7CE9C000000
      0000E7D6D6000829E7004A6BFF00000000000000000000000000000000000000
      00006B84FF00849CFF00BDD6FF00BDD6FF00B5CEFF00B5CEFF004263FF00DEDE
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000298C9C00108CA5002994AD00398CA500187B
      A500006B94005294A50000000000000000000000000000000000F7C69C00F7D6
      AD00F7DEB500F7DEB500F7D6AD00F7D6AD00F7D6AD00F7C68C00F7A59C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000DEDEFF00526BFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CE73AD00C65AA500B584
      A500C6CECE00CED6CE00C6CECE00BDC6C600BDBDBD00B5B5B500A5A5A500A59C
      9C008C4A730094397B00AD528C000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00848484000000FF00FFFF
      FF00C6C6C6000000000084848400000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400848484000000
      0000FFFFFF000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      840000000000000000000000000000000000CE73AD00C673A500AD528C00BD94
      AD00FFFFFF00A5849400B56B9C00E7E7E700DED6D600D6CECE00B5ADAD00A59C
      9C007B426B0094397B00A54A8C000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00848484000000FF00FFFF
      FF00C6C6C6008484840000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000848484008484
      8400848484000000000000000000000000000000000000FFFF00000000000084
      8400008484000084840000848400008484000084840000848400008484000084
      840000848400000000000000000000000000CE7BAD00C673AD00AD4A8C00BD94
      B500FFFFFF00AD94A500B573A500EFF7EF00E7E7E700DED6DE00C6B5BD00ADAD
      A500844A6B009C427B00AD528C000000000000000000C6C6C600FFFFFF008484
      8400848484008484840084848400848484008484840084848400C6C6C6008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000FFFFFF0000000000000000000000000000000000FFFFFF00848484000000
      0000008484000084840000848400008484000084840000848400008484000084
      840000848400008484000000000000000000CE7BB500C673AD00AD528C00C694
      B500FFFFFF00B58CA500BD639C00F7F7F700EFEFEF00E7E7E700CEC6C600BDBD
      B500844A6B009C427B00AD528C000000000000000000C6C6C600FFFFFF008484
      8400C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      FF000000FF000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000FFFF00848484000000
      0000008484000084840000848400008484000084840000848400008484000084
      840000848400008484000084840000000000CE7BB500C67BAD00B5529400BD9C
      B500DED6DE00BDA5B500D6BDC600F7FFFF00F7FFFF00F7F7F700DEDEDE00BDAD
      B5008C4A73009C427B00B55294000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400C6C6C600C6C6
      C600C6C6C60084848400C6C6C600000000000000000000000000FFFFFF00FFFF
      FF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000FFFFFF0084848400FFFF
      FF00000000000000000000000000000000000084840000848400008484000084
      840000848400008484000084840000000000CE84B500CE84B500BD94AD00BD8C
      AD00BD8CAD00BD8CAD00BD84A500BD84A500BD84A500BD84A500BD7B9C00BD7B
      9C00BD7B9C00BD84A500B55A94000000000000000000C6C6C600FFFFFF008484
      84008484840084848400848484008484840084848400C6C6C6000000FF00FFFF
      FF00C6C6C60000000000C6C6C600000000000000000000000000848484008484
      8400848484000000000000000000848484008484840084848400848484008484
      8400848484000000000000000000000000000000000000FFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000D68CBD00C67BAD00FFFFF700FFFF
      FF00FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFFF
      EF00FFFFEF00FFFFEF00B55A94000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C6C6C6000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF0000000000000000000084840000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000000000000FFFFFF0084848400FFFF
      FF00C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600FFFFFF00C6C6
      C60000000000000000000000000000000000D68CBD00C67BAD00EFE7E700E7E7
      DE00EFE7E700E7E7DE00E7DEDE00E7DEDE00E7DEDE00E7DEDE00E7DEDE00E7DE
      DE00E7DEDE00E7DEDE00BD5A9C000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6C600FFFFFF00FFFFFF00FFFF
      FF00C6C6C6000000000000000000000000000000000000000000000000000000
      000000000000000000000084840000FFFF000084840000848400000000000000
      0000000000000000000000000000000000000000000000FFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000000000000000000000000000D68CBD00C67BAD00FFFFF700FFFF
      FF00FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFFFEF00FFFF
      F700FFFFEF00FFFFEF00BD5A9C000000000000000000C6C6C600FFFFFF008484
      8400C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C6C6C6000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000000000FFFF0000FFFF0000848400008484000000
      0000FFFFFF00000000000000000000000000000000000000000084848400FFFF
      FF00C6C6C600C6C6C600C6C6C600C6C6C600FFFFFF00FFFFFF008484840000FF
      000000FF0000000000000000000000000000D694C600CE84B500FFFFF700FFFF
      FF00FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFFF
      EF00FFFFF700FFFFEF00CE6BAD000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C6C6C6000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000848400FFFFFF0084848400840000008400
      000000000000000000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00848484008484840000FF
      000000FF0000000000000000000000000000D694C600CE8CB500EFE7E700EFE7
      E700EFE7E700EFE7E700EFE7E700EFE7E700E7E7DE00EFE7E700E7E7DE00EFE7
      E700E7E7DE00EFE7E700CE6BAD000000000000000000C6C6C600FFFFFF008484
      84008484840084848400848484008484840084848400FFFFFF00FFFFFF00C6C6
      C600C6C6C6000000000000000000000000000000000000000000848484008484
      840084848400848484008484840000000000C6C6C600FF000000FF0000008400
      000084000000000000000000000000000000000000000000000084848400FFFF
      FF00C6C6C600C6C6C600C6C6C600C6C6C6008484840000FF000000FF000000FF
      000000FF000000FF000000FF000000000000DE9CC600CE8CB500FFFFFF00FFFF
      FF00FFFFF700FFFFFF00FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFFF
      F700FFFFF700FFFFEF00CE73AD000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6C600C6C6C600C6C6
      C600C6C6C6000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084000000C6C6C600FF000000FF00
      000084000000840000000000000000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008484840000FF000000FF000000FF
      000000FF000000FF000000FF000000000000DE9CCE00D68CBD00EFE7E700EFE7
      E700EFE7E700EFE7E700EFE7E700EFE7E700EFE7E700EFE7E700E7E7DE00EFE7
      E700EFE7E700EFE7E700CE73AD000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400FFFFFF00C6C6
      C600000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084000000C6C6C600FF00
      0000FF0000008400000084000000000000000000000000000000848484008484
      84008484840084848400848484008484840084848400848484008484840000FF
      000000FF0000000000000000000000000000AD7B9C0094527B00EFEFEF00EFEF
      EF00EFE7E700EFEFEF00EFE7E700E7E7DE00E7DEDE00E7DEDE00DED6D600DED6
      D600DED6D600DED6D600845A7B000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6C600FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084000000C6C6
      C600FF000000FF00000084000000840000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008484840000FF
      000000FF0000000000000000000000000000EFB5DE00EFADD600DEC6D600DEC6
      D600DEC6D600DEC6D600D6BDCE00D6B5C600CEB5C600CEB5C600CEADBD00CEAD
      BD00CEADBD00CEADBD00EF8CCE000000000000000000C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFBF000000000000FF1F000000000000
      FC0F000000000000F003000000000000E007000000000000E01F000000000000
      C33F000000000000C37F00000000000083FF00000000000083FF000000000000
      C1FF000000000000C01F000000000000C01F000000000000E01F000000000000
      F01F000000000000FE3F000000000000FFFFC003FFFFFFFFFFFFC003C003F81F
      F9FFC003C003E007FCFFC003C003C003FE7FC003C0038383FF2FC003C0038701
      FFBBC003C0038E01F87DC003C0038C11C001C003C003883100010003C0038071
      00010003C00380E100010003C00381C30001C003C003C003C001C007C001E007
      F001C00FC011F00FFE03C01FFFF9FFFF8003FFFFFFFFFFBF8003000F80018005
      8003000700018003800300030001800780030001000180078003000000018001
      8003000000018005800300000001800780030007000180078003000300018007
      80038003000180078003C001000180078003C000000180078001C0000001800F
      8000C0010001801F8000FFC30001803F00000000000000000000000000000000
      000000000000}
  end
  object ilObjectExplorer: TImageList
    Left = 568
    Top = 32
    Bitmap = {
      494C01010A000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000AD848400BD8C8C00C6949400C6949400BD8C8C00AD8484000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F7E7CE00DE7B2900FF9C0000FF9C0000FF9C0000FF940000CE6B1800FFF7
      F700000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000B58C
      8C00B56B6B00CE9C9C00CE9C9C00BD848400A55A5A00CE9C9C00C6949400B573
      7300BD9C9C00000000000000000000000000000000000000000000000000E7AD
      7300FF9C2100FF9C1800FFAD2100FFA51800FFA51000FF9C0800FF7B0000FF8C
      0000E7AD84000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000DEAD
      AD00BD7B7B00D6ADAD00D6ADAD00AD636300AD636300BD848400D6ADAD00BD84
      8400DEB5B500000000000000000000000000000000000000000000000000F7CE
      9400FFC65A00FFAD3900FFBD4A00FFBD4A00FFB54200FFB53900FF941800FFAD
      2900E7AD5A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000E7C6
      C600DEB5B500D6ADAD00DEB5B500B56B6B00B56B6B00DEB5B500D6A5A500DEB5
      B500E7C6C600000000000000000000000000000000000000000000000000EFC6
      8C00FFD68400FFBD4A00FFCE7300FFCE7300FFCE6B00FFC66300FFB54200FFC6
      5200DE944A000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000F7E7
      E700E7C6C600D6A5A500E7C6C600B5737300B5737300E7C6C600D6ADAD00E7C6
      C600F7E7E70000000000000000000000000000000000EFC6A500FF7B0800F7B5
      5200FFEFBD00FFE79C00FFDE9C00FFFFFF00FFFFFF00FFDE8C00FFD68400FFE7
      A500F79C2100F7730000F7DEC600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D6C6
      C600EFD6D600EFCECE00EFCECE00D6A5A500BD848400EFCECE00EFD6D600EFD6
      D600CEADAD0000000000000000000000000000000000FFBD4A00FF9C2100FFB5
      3900FFE7BD00FFEFBD009CC6EF00187BE700187BE700ADC6D600FFEFAD00F7CE
      9C00FFAD2900FF8C0800FFA51000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00F7DEDE00398CE700218CEF002184EF003184E700F7DEDE00FFFF
      FF00FFFFFF0000000000000000000000000000000000FFDE8C00FFBD4A00FFCE
      6B00FFCE6B00298CF7004AADFF004AADFF004AADFF004AADFF00187BE700FFCE
      6B00FFC65A00FFB53900FFCE6B00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000F7F7F7003194F7004AADFF004AADFF004AADFF004AADFF002184EF00EFE7
      E7000000000000000000000000000000000000000000FFF7CE00FFE79C00FFDE
      9C00BDDEFF0063BDFF0063BDFF0063BDFF0063B5FF0063B5FF0063B5FF00F7F7
      FF00FFDE8C00FFD68400F7D6A500000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000399CFF0063B5FF0063B5FF0063B5FF005AB5FF005AB5FF005AB5FF003994
      EF000000000000000000000000000000000000000000FFF7E700FFFFDE002184
      EF00319CFF007BCEFF007BC6FF007BC6FF007BC6FF007BC6FF0073C6FF00298C
      F7002184E700FFFFD600FFEFDE00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084C6FF0073C6FF0073C6FF0073C6FF0073C6FF0073C6FF0073C6FF0052A5
      F700000000000000000000000000000000000000000000000000399CF70052B5
      FF00399CFF0094D6FF0094D6FF0094D6FF0094D6FF0094D6FF0094D6FF0042A5
      FF0052ADFF00298CEF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084C6FF008CD6FF008CD6FF008CD6FF008CCEFF0084CEFF0084CEFF0073BD
      FF0000000000000000000000000000000000000000000000000073C6FF0073C6
      FF0073C6FF00C6EFFF009CDEFF009CDEFF009CDEFF009CDEFF00B5DEFF0073C6
      FF0073C6FF006BBDFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000319CFF00ADE7FF009CDEFF009CDEFF009CDEFF009CDEFF00ADE7FF003194
      FF000000000000000000000000000000000000000000000000009CD6FF008CD6
      FF008CD6FF007BC6FF0094CEFF00CEEFFF00CEEFFF0084C6FF008CD6FF008CD6
      FF008CD6FF00A5DEFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000094CEFF00CEEFFF009CDEFF009CDEFF00CEEFFF0094CEFF000000
      000000000000000000000000000000000000000000000000000073BDFF009CDE
      FF009CDEFF009CDEFF008CCEFF000000000000000000B5DEFF009CDEFF009CDE
      FF00A5DEFF0052ADFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000319CFF00A5DEFF00A5DEFF00319CFF00000000000000
      000000000000000000000000000000000000000000000000000000000000399C
      FF00A5DEFF0042A5FF000000000000000000000000000000000052ADFF00A5DE
      FF00319CFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF007B7B7B000000FF007B7B7B00FFFFFF00000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF00000000000000FF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF0000FFFF0000FFFF00000000
      0000FFFF0000FFFF000000000000FFFF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008484840000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF000000FF000000FF000000FF0000FFFF00FFFFFF0000FF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF0000000000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C6000000000000000000FFFF000000000000FFFF
      00000000000000000000FFFF0000000000008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000008484
      8400FFFFFF00C6C6C60000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF007B7B7B000000FF007B7B7B00FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000008484840000000000FFFF0000FFFF
      000084848400FFFFFF00FFFF0000000000000000000000000000000000000000
      0000000000000000000084848400000000000000000000000000000000000000
      0000FFFFFF008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF0000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000084848400FFFFFF00000000000000
      0000FFFFFF00848484000000000000000000FFFFFF0000000000FFFFFF000000
      0000FFFFFF000000000084848400000000000000000000000000000000000000
      000000000000C6C6C60000000000000000000000000000000000000000000000
      00000000000000FFFF00000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF000000FF0000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF000000000084848400FFFFFF0000000000FFFF
      FF00C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000084848400000000000000000000000000000000008484
      8400FFFFFF008484840000000000000000000000000000000000000000000084
      840000FFFF00000000000000000000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF000000FF007B7B7B0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000008484840000000000000000000000
      0000FFFFFF00C6C6C600FFFFFF000000000000000000FFFFFF0000000000FFFF
      FF00C6C6C6000000000084848400000000000000000000000000000000000000
      0000FFFFFF00C6C6C600000000000000000000000000000000000000000000FF
      FF000000000000000000000000000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF000000FF000000FF00FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000000000FFFF
      FF00C6C6C600FFFFFF0084848400000000008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000000000
      000000000000848484000000000000000000000000000000000000FFFF000000
      000000000000000000000000000000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF000000FF000000FF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000008484
      8400FFFFFF00FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000FFFFFF00C6C6C600FFFFFF00C6C6C60000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0084848400000000000000000000000000000000000000
      0000FFFFFF0000000000000000000000000000FFFF0000FFFF00000000000000
      00000000000000000000000000000000000000FFFF00FFFFFF0000FFFF00FFFF
      FF007B7B7B007B7B7B0000FFFF00FFFFFF007B7B7B000000FF000000FF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00000000000000000000000000000000008484
      8400FFFFFF00FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000C6C6C600FFFFFF0000000000000000008484840084848400848484008484
      840084848400848484008484840000000000000000000000000000000000FFFF
      FF00000000000084840000FFFF00C6C6C60000FFFF0000000000000000000000
      000000000000000000000000000000000000FFFFFF0000FFFF00FFFFFF0000FF
      FF000000FF000000FF00FFFFFF0000FFFF007B7B7B000000FF000000FF0000FF
      FF00FFFFFF0000FFFF00FFFFFF00000000000000000000000000000000008484
      8400FFFFFF00FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000000000C6C6C600FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      00000084840000FFFF000000000000FFFF00C6C6C60000FFFF00000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF000000FF000000FF007B7B7B00FFFFFF007B7B7B000000FF000000FF00FFFF
      FF0000FFFF00FFFFFF0000000000000000000000000000000000000000008484
      8400FFFFFF00FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C6C6C6000000
      000000FFFF0000000000000000000000000000FFFF0084848400000000000000
      0000000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF000000FF000000FF000000FF000000FF000000FF00FFFFFF0000FF
      FF00FFFFFF0000FFFF0000000000000000000000000000000000000000008484
      8400FFFFFF00FF000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0084848400C6C6C60000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000848400000000000000000000FFFF00C6C6C60000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF00FFFF
      FF0000FFFF00FFFFFF000000FF000000FF000000FF00FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000FFFF00C6C6C6000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF0084848400848484008484840084848400848484008484
      8400848484000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000840000008400
      0000840000008400000084000000840000008400000084000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000031319C0031319C003131
      9C000000000000000000000000000000000084000000FF000000FF0000008400
      00008400000084000000C6C6C60084000000FF00000084000000840000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF00000000000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000031319C0031319C006363FF0031319C003131
      9C0031319C00000000000000000000000000000000008400000084000000C6C6
      C600C6C6C600FFFFFF00C6C6C600848484008400000084000000840000008400
      0000840000008400000084000000000000000000000000000000FF0000000000
      0000FFFFFF00FFFFFF0084848400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000006363FF0031319C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000031319C0031319C0031319C006363FF009C9CFF009C9CFF006363FF003131
      9C0031319C000000000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF008484840000000000840000008400000084000000C6C6
      C60084000000FF0000008400000084000000000000000000000000000000FFFF
      FF00FFFFFF008484840000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000031319C006363FF009C9CFF0031319C0031319C0063630000636300006363
      00000000000000000000000000000000000000000000000000006363FF006363
      FF006363FF009C9CFF009C9CFF009C9CFF009C9CFF00000000009C9CFF006363
      FF0031319C000000000000000000000000000000000000000000000000000000
      0000FFFFFF00C6C6C600C6C6C600C6C6C600C6C6C60000000000FFFFFF00C6C6
      C600848484008400000084000000000000000000000000000000000000000000
      0000FFFFFF00C6C6C600C6C6C600C6C6C6000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006363FF006363
      FF009C9CFF009C9CFF00000000006363FF0031319C009C9C00009C9C00006363
      00000000000000000000000000000000000000000000000000006363FF009C9C
      FF009C9CFF009C9CFF009C9CFF009C9CFF009C9CFF0000000000000000009C9C
      FF006363FF000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF008484
      8400000000008400000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00C6C6C6000000FF000000FF00000084008484
      84000000840000000000000000000000000000000000000000006363FF009C9C
      FF009C9CFF009C9CFF00000000009C9CFF006363FF009C9C0000CECE31009C9C
      00000000000000000000000000000000000000000000000000006363FF009C9C
      FF009C9CFF009C9CFF009C9CFF009C9CFF00000000009C9CFF009C9CFF009C9C
      FF006363FF000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF00FFFFFF00FFFFFF00C6C6C60000000000C6C6C600C6C6
      C600C6C6C600C6C6C60000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6C600FFFFFF00FFFFFF008484
      84000000000000000000000000000000000000000000000000006363FF009C9C
      FF0031319C006363FF006363FF006363FF0000000000CECE3100000000000000
      00000000000000000000000000000000000000000000000000006363FF000000
      00009C9CFF009C9CFF006363FF006363FF006363FF006363FF009C9CFF006363
      FF00000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6C60000000000FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000006363
      FF009CCEFF009CCEFF0000000000000000009C9C000000000000CECE3100CECE
      3100000000000000000000000000000000000000000000000000000000009C9C
      FF006363FF00639CCE009CCEFF009CCEFF00639CCE0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF00FFFFFF00C6C6C600FF000000C6C6C60000000000FFFF
      FF00FFFFFF00C6C6C60000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000006363
      63009CCEFF009CCEFF00639CCE009C9C0000CECE31009C9C00009C9C0000CECE
      3100000000000000000000000000000000000000000000000000000000000000
      0000636363009CCEFF009CCEFF009CCEFF00639CCE00639CCE00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C6C6C600FFFFFF008484840000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF000000000000000000FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000006363
      63009CCEFF009CCEFF00639CCE0063636300639CCE009CCEFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000636363009CCEFF009CCEFF009CCEFF009CCEFF00639CCE00000000006363
      6300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF00C6C6C60000000000FFFF
      FF00C6C6C600FF000000C6C6C600000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00C6C6C60000000000000000000000000000000000000000000000
      00009CCEFF006363630000000000000000009CCEFF009CCEFF00639CCE000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000636363009CCEFF009CCEFF009CCEFF009CCEFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C6C6
      C600FFFFFF008484840000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000063636300000000009CCEFF009CCEFF00639CCE000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000639CCE009CCEFF0063636300CEFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00C6C6C600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF00C6C6C60000000000000000000000000000000000000000006363
      6300CEFFFF00000000000000000000000000639CCE00CEFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000063636300000000006363
      6300000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000063636300000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000636363000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000636363000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000063636300000000000000000063636300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFF00000000F81FF00F00000000
      E007E00700000000E007E00700000000E007E00700000000E007800100000000
      E007800100000000F007800100000000F00F800100000000F00F800100000000
      F00FC00300000000F00FC00300000000F00FC00300000000F81FC18300000000
      FC3FE3C700000000FFFFFFFF00000000FFFF81FFFFFFFBFFF83FC1FF0001F1FF
      E00FE0000000E1FFC007C0000000E1F98003C0000000F1E18003C0000000E1C1
      0001C0000000E1C30001C0000000F1070001E0000000E00F0001E0000001C01F
      0001E00000F7801F8003E00080CF803F8003E001C1BF803FC007E003FFBFC07F
      E00FE007FFC1E0FFF83FE007FFFBFFFFFF8F803FFFFFFFFFFE07001F80FFFCFF
      F0038001C1FFF00FC003C000C1FFC00F80438001C00782078063800380078207
      80830001800F8037900700018007C047C00F00018003E00FE01F00008003E00F
      F00F0000C003E00FF00F8001E003E00FF00FC000FC03E00FF00FE000FE01F00F
      F11FFE00FF03FF1FFC3FFF01FFFFFFFF00000000000000000000000000000000
      000000000000}
  end
end
