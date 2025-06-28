object formMain: TformMain
  Left = 357
  Top = 156
  Width = 1213
  Height = 714
  Caption = #1057#1080#1089#1090#1077#1084#1072' '#1086#1073#1088#1072#1073#1086#1090#1082#1080' '#1079#1072#1082#1072#1079#1086#1074
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010002002020100000000000E80200002600000010101000000000002801
    00000E0300002800000020000000400000000100040000000000000200000000
    0000000000000000000000000000000000000000800000800000008080008000
    00008000800080800000C0C0C000808080000000FF0000FF000000FFFF00FF00
    0000FF00FF00FFFF0000FFFFFF00000000000000000000000000000000008777
    77777777777777777777700000008FFFFFFFFFFFFFFFFFFFFFFF700000008FFF
    FFFFFFFFFFFFFFFFFFFF700000008FFFF00FFFFFFFFFFFFFFFFF700000008FFF
    F00FFFFFFFFFFFFFFFFF700000008FFFF00FFFFFFFFFFFFFFFFF700000008FFF
    F0000FFFFF000FFFFFFF700000008FFFF00F000F0000FFFFFFFF700000008FFF
    F00FFF0000FFFFFFFFFF700000008FFFF00F000000FFFFFFFFFF700000008FFF
    F00000FFF300FFFFFFFF700000008FFFF000FFFFFF3F00FFFFFF700000008FFF
    FFFFFFFFFFF3BF800000700000008FFFFFFFFFFFFFFF3FBF7333000000008FFF
    FFFFFFFFFFFFF3FBF733300000008FFFFFFFFFFFFFFFFF3BBF73334000008FFF
    FFFFFFFFFFFFFFF3FBB7330000008FFFFFFFFFFFFFFFFFFF3FBF700000008FFF
    FFFFFFFFFFFFFFFFF3FB000004008FFFFFFFFFFFFFFFFFFFFF30000044408FFF
    FFFFFFFFFFFFFFFFFF00F004CC448FFFFFFFFFFFFFFFFFFFFFF00F4C4CC48FFF
    FFFFFFFFFFFFFFFFFFFF00CCC4CC8FFFFFFFFFFFFFFFFFFFFFFF44CBCC4C8FFF
    FFFFFFFFFFFFFFF8000004CCFCC48FFFFFFFFFFFFFFFFFF8FF78004CCFCC8FFF
    FFFFFFFFFFFFFFF8F7800004CCBC8FFFFFFFFFFFFFFFFFF8780000004CCF8FFF
    FFFFFFFFFFFFFFF88000000004CC8FFFFFFFFFFFFFFFFFF800000000004C8888
    88888888888888880000000000040000003F0000003F0000003F0000003F0000
    003F0000003F0000003F0000003F0000003F0000003F0000003F0000003F0000
    003F0000003F0000003F0000001F0000000F0000000700000003000000010000
    0000000000000000000000000000000000000000000000000040000000E00000
    01F0000003F8000007FC00000FFE280000001000000020000000010004000000
    0000800000000000000000000000000000000000000000000000000080000080
    000000808000800000008000800080800000C0C0C000808080000000FF0000FF
    000000FFFF00FF000000FF00FF00FFFF0000FFFFFF0000000000000000008777
    7777777700008FF0FFFFFFF700008FF0FFF0FFF700008FF00700FFF700008FF0
    F0F3000000008FF00FFF3BF300008FFFFFFFF3BF38008FFFFFFFFF3B30008FFF
    FFFFFFF300048FFFFFFFFFF700C48FFFFFFFFFF704FC8FFFFFFFF00004CF8FFF
    FFFFF7F8004C8FFFFFFFF7800004888888888800000000079E00000775690007
    2025000700680007ED000007310000034D0000019C000000343500004D000000
    4D500000000000000000000C9C00001E3436003F4D00}
  Menu = mainMenu
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 280
    Top = 0
    Width = 8
    Height = 499
    AutoSnap = False
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 636
    Width = 1197
    Height = 19
    Panels = <
      item
        Text = 'Idle'
        Width = 50
      end
      item
        Text = 'user:'
        Width = 600
      end
      item
        Text = #1042#1089#1077#1075#1086' '#1074#1093#1086#1076#1103#1097#1080#1093':'
        Width = 200
      end
      item
        Text = 'Doc:   Item:     (P:    PI: )'
        Width = 100
      end>
  end
  object pnlBase_LeftSide: TPanel
    Left = 0
    Top = 0
    Width = 280
    Height = 499
    Align = alLeft
    Caption = 'pnlBase_LeftSide'
    TabOrder = 1
    object Panel4: TPanel
      Left = 1
      Top = 1
      Width = 278
      Height = 497
      Align = alClient
      Caption = 'Panel4'
      TabOrder = 0
      object pcontStatusList: TPageControl
        Left = 1
        Top = 1
        Width = 276
        Height = 495
        ActivePage = tsheetTreeList
        Align = alClient
        TabOrder = 0
        object tsheetTreeList: TTabSheet
          Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1079#1072#1103#1074#1086#1095#1085#1086#1075#1086' '#1087#1088#1086#1094#1077#1089#1089#1072
          object Splitter5: TSplitter
            Left = 0
            Top = 110
            Width = 268
            Height = 3
            Cursor = crVSplit
            Align = alTop
          end
          object ToolBar4: TToolBar
            Left = 0
            Top = 0
            Width = 268
            Height = 37
            ButtonHeight = 48
            ButtonWidth = 35
            Caption = 'ToolBar1'
            Images = ilObjectExplorer
            TabOrder = 0
            object tbRefresh: TToolButton
              Left = 0
              Top = 2
              Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1087#1080#1089#1086#1082
              Caption = 'tbRefresh'
              ImageIndex = 12
              ParentShowHint = False
              ShowHint = True
              OnClick = tbRefreshClick
            end
            object tbFilterSettings: TToolButton
              Left = 35
              Top = 2
              Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1092#1080#1083#1100#1090#1088#1072#1094#1080#1080'...'
              Caption = 'C'#1086#1088#1090#1080#1088#1086#1074#1082#1072
              Enabled = False
              ImageIndex = 11
              ParentShowHint = False
              PopupMenu = popMSearch
              ShowHint = True
              Style = tbsCheck
              OnClick = tbFilterSettingsClick
              OnMouseDown = tbFilterSettingsMouseDown
            end
          end
          object Panel5: TPanel
            Left = 0
            Top = 113
            Width = 268
            Height = 161
            Align = alClient
            TabOrder = 1
            object tvHierarchicalTotal: TTreeView
              Left = 1
              Top = 30
              Width = 266
              Height = 130
              Align = alClient
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              Indent = 19
              ParentFont = False
              ReadOnly = True
              RowSelect = True
              TabOrder = 0
              OnChange = tvHierarchicalTotalChange
              OnClick = tvHierarchicalTotalClick
              Items.Data = {
                01000000390000000000000000000000FFFFFFFFFFFFFFFF0000000004000000
                20CFEEEBEDFBE920EFE5F0E5F7E5EDFC20E4EEF1F2F3EFEDFBF520E7E0FFE2EE
                EA250000000000000000000000FFFFFFFFFFFFFFFF00000000000000000CD4EE
                F0ECE8F0EEE2E0EDE8E5250000000000000000000000FFFFFFFFFFFFFFFF0000
                0000000000000CD1EEE3EBE0F1EEE2E0EDE8E5240000000000000000000000FF
                FFFFFFFFFFFFFF00000000000000000BD3F2E2E5F0E6E4E5EDE8E52300000000
                00000000000000FFFFFFFFFFFFFFFF00000000000000000AC8F1EFEEEBEDE5ED
                E8E5}
            end
            object ToolBar5: TToolBar
              Left = 1
              Top = 1
              Width = 266
              Height = 29
              Caption = 'ToolBar5'
              TabOrder = 1
              object ToolButton2: TToolButton
                Left = 0
                Top = 2
                Width = 15
                Caption = 'ToolButton2'
                Style = tbsSeparator
              end
              object cbFullOrderListStates: TCheckBox
                Left = 15
                Top = 2
                Width = 208
                Height = 22
                Caption = #1055#1086#1083#1085#1099#1081' '#1087#1077#1088#1077#1095#1077#1085#1100' '#1076#1086#1089#1090#1091#1087#1085#1099#1093' '#1079#1072#1103#1074#1086#1082
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 0
                OnClick = cbFullOrderListStatesClick
              end
            end
          end
          object Panel6: TPanel
            Left = 0
            Top = 37
            Width = 268
            Height = 73
            Align = alTop
            Caption = 'Panel6'
            TabOrder = 2
            object tvHierarchicalInput: TTreeView
              Left = 1
              Top = 1
              Width = 266
              Height = 71
              Align = alClient
              Font.Charset = RUSSIAN_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              Indent = 19
              ParentFont = False
              ReadOnly = True
              RowSelect = True
              TabOrder = 0
              OnChange = tvHierarchicalInputChange
              OnClick = tvHierarchicalInputClick
              Items.Data = {
                01000000210000000000000000000000FFFFFFFFFFFFFFFF0000000003000000
                08C2F5EEE4FFF9E8E5250000000000000000000000FFFFFFFFFFFFFFFF000000
                00000000000CD1EEE3EBE0F1EEE2E0EDE8E5240000000000000000000000FFFF
                FFFFFFFFFFFF00000000000000000BD3F2E2E5F0E6E4E5EDE8E5230000000000
                000000000000FFFFFFFFFFFFFFFF00000000000000000AC8F1EFEEEBEDE5EDE8
                E5}
            end
          end
          object pnlCurrentOrdersRoute: TPanel
            Left = 0
            Top = 274
            Width = 268
            Height = 193
            Align = alBottom
            Caption = 'pnlCurrentOrdersRoute'
            TabOrder = 3
            object Splitter2: TSplitter
              Left = 1
              Top = 1
              Width = 266
              Height = 3
              Cursor = crVSplit
              Align = alTop
            end
            object gbCurrentOrdersRoute: TGroupBox
              Left = 1
              Top = 4
              Width = 266
              Height = 188
              Align = alClient
              Caption = #1069#1090#1072#1087#1099' '#1087#1088#1086#1094#1077#1089#1089#1072' '#1086#1073#1088#1072#1073#1086#1090#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
              object clbProcessItemList: TCheckListBox
                Left = 2
                Top = 15
                Width = 262
                Height = 171
                Align = alClient
                Enabled = False
                Font.Charset = RUSSIAN_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'Tahoma'
                Font.Style = []
                ItemHeight = 13
                Items.Strings = (
                  '')
                ParentFont = False
                Style = lbOwnerDrawFixed
                TabOrder = 0
                OnDrawItem = clbProcessItemListDrawItem
              end
            end
          end
        end
        object tsheetStoreMTR: TTabSheet
          Caption = #1057#1082#1083#1072#1076' '#1052#1058#1056
          ImageIndex = 1
          object GroupBox2: TGroupBox
            Left = 0
            Top = 0
            Width = 268
            Height = 467
            Align = alClient
            Caption = #1055#1086#1080#1089#1082
            TabOrder = 0
            object gbSearchCondition: TGroupBox
              Left = 2
              Top = 76
              Width = 274
              Height = 36
              TabOrder = 0
              object RadioButton1: TRadioButton
                Left = 5
                Top = 15
                Width = 113
                Height = 14
                Caption = #1053#1072#1095#1080#1085#1072#1077#1090#1089#1103' '#1089'...'
                Checked = True
                TabOrder = 0
                TabStop = True
                OnClick = RadioButton1Click
              end
              object RadioButton2: TRadioButton
                Left = 137
                Top = 13
                Width = 118
                Height = 17
                Caption = #1057#1086#1076#1077#1088#1078#1080#1090' ...'
                TabOrder = 1
                OnClick = RadioButton2Click
              end
            end
            object ToolBar7: TToolBar
              Left = 2
              Top = 15
              Width = 264
              Height = 37
              ButtonHeight = 32
              ButtonWidth = 35
              Caption = 'ToolBar1'
              Images = ilObjectExplorer
              TabOrder = 1
              object tbRefreshStoreObject: TToolButton
                Left = 0
                Top = 2
                Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1089#1087#1080#1089#1086#1082
                Caption = 'tbRefresh'
                ImageIndex = 12
                ParentShowHint = False
                ShowHint = True
                OnClick = tbRefreshStoreObjectClick
              end
              object tbFilterSettingsStore: TToolButton
                Left = 35
                Top = 2
                Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1092#1080#1083#1100#1090#1088#1072#1094#1080#1080'...'
                Caption = 'C'#1086#1088#1090#1080#1088#1086#1074#1082#1072
                ImageIndex = 11
                ParentShowHint = False
                ShowHint = True
                OnClick = tbFilterSettingsStoreClick
                OnMouseDown = tbFilterSettingsMouseDown
              end
              object ToolButton18: TToolButton
                Left = 0
                Top = 2
                Width = 13
                Caption = 'ToolButton1'
                ImageIndex = 2
                Wrap = True
                Style = tbsSeparator
              end
              object ToolBar8: TToolBar
                Left = 0
                Top = 42
                Width = 150
                Height = 29
                Caption = 'ToolBar1'
                TabOrder = 1
              end
              object CoolBar1: TCoolBar
                Left = 150
                Top = 42
                Width = 196
                Height = 32
                Bands = <
                  item
                    Control = Edit1
                    ImageIndex = -1
                    MinHeight = 24
                    Width = 192
                  end>
                object Edit1: TEdit
                  Left = 9
                  Top = 0
                  Width = 179
                  Height = 24
                  AutoSize = False
                  TabOrder = 0
                  Text = #1042#1074#1077#1076#1080#1090#1077' '#1089#1090#1088#1086#1082#1091' '#1087#1086#1080#1089#1082#1072'...'
                  OnKeyUp = edSearchKeyUp
                end
              end
            end
            object edSearchStore: TEdit
              Left = 3
              Top = 55
              Width = 270
              Height = 21
              TabOrder = 2
              Text = #1042#1074#1077#1076#1080#1090#1077' '#1089#1090#1088#1086#1082#1091' '#1087#1086#1080#1089#1082#1072'...'
              OnEnter = edSearchStoreEnter
              OnExit = edSearchStoreExit
              OnKeyUp = edSearchStoreKeyUp
            end
            object GroupBox15: TGroupBox
              Left = 2
              Top = 114
              Width = 274
              Height = 255
              Align = alCustom
              Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1092#1080#1083#1100#1090#1088#1072
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 3
              object rbFilterON: TRadioButton
                Left = 8
                Top = 16
                Width = 89
                Height = 17
                Caption = #1042#1082#1083'. '#1092#1080#1083#1100#1090#1088
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 0
                Visible = False
                OnClick = rbFilterONClick
              end
              object rbFilterOFF: TRadioButton
                Left = 112
                Top = 16
                Width = 113
                Height = 17
                Caption = #1042#1099#1082#1083'. '#1092#1080#1083#1100#1090#1088
                Checked = True
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 1
                TabStop = True
                Visible = False
                OnClick = rbFilterOFFClick
              end
              object cbObjectInitiatorOwner: TComboBox
                Left = 5
                Top = 52
                Width = 260
                Height = 21
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ItemHeight = 0
                ParentFont = False
                TabOrder = 2
                OnChange = cbObjectInitiatorOwnerChange
              end
              object ckbOrdersCreatorOwner: TCheckBox
                Left = 6
                Top = 34
                Width = 115
                Height = 17
                Caption = #1048#1085#1080#1094#1080#1072#1090#1086#1088' '#1079#1072#1082#1072#1079#1072
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 3
                OnClick = ckbOrdersCreatorOwnerClick
              end
              object ckbObjectsGroups: TCheckBox
                Left = 5
                Top = 75
                Width = 97
                Height = 17
                Caption = #1043#1088#1091#1087#1087#1072' '#1052#1058#1057
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 4
                OnClick = ckbObjectsGroupsClick
              end
              object cbObjectGroup: TComboBox
                Left = 4
                Top = 95
                Width = 261
                Height = 21
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ItemHeight = 0
                ParentFont = False
                TabOrder = 5
                Text = 'cbObjectGroup'
                OnChange = cbObjectGroupChange
              end
              object gbPeriodOrderCreatingSelect: TGroupBox
                Left = 3
                Top = 120
                Width = 268
                Height = 58
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 6
                object Label1: TLabel
                  Left = 4
                  Top = 35
                  Width = 35
                  Height = 13
                  Caption = #1085#1072#1095#1072#1083#1086
                end
                object Label2: TLabel
                  Left = 131
                  Top = 36
                  Width = 30
                  Height = 13
                  Caption = #1082#1086#1085#1077#1094
                end
                object dtpPeriodBeginLinkedOrderCreation: TDateTimePicker
                  Left = 42
                  Top = 32
                  Width = 87
                  Height = 21
                  Date = 41084.477712511570000000
                  Time = 41084.477712511570000000
                  TabOrder = 0
                  OnChange = dtpPeriodBeginLinkedOrderCreationChange
                end
                object dtpPeriodEndLinkedOrderCreation: TDateTimePicker
                  Left = 167
                  Top = 32
                  Width = 95
                  Height = 21
                  Date = 41084.477931145830000000
                  Time = 41084.477931145830000000
                  TabOrder = 1
                  OnChange = dtpPeriodEndLinkedOrderCreationChange
                end
                object ckbPeriodOrderCreating: TCheckBox
                  Left = 3
                  Top = 12
                  Width = 257
                  Height = 17
                  Caption = #1047#1072#1076#1072#1090#1100' '#1087#1077#1088#1080#1086#1076' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1079#1072#1103#1074#1082#1080
                  TabOrder = 2
                  OnClick = ckbPeriodOrderCreatingClick
                end
              end
              object gbPeriodStoreObjectCreatingSelect: TGroupBox
                Left = 3
                Top = 181
                Width = 268
                Height = 58
                Font.Charset = DEFAULT_CHARSET
                Font.Color = clWindowText
                Font.Height = -11
                Font.Name = 'MS Sans Serif'
                Font.Style = []
                ParentFont = False
                TabOrder = 7
                object Label3: TLabel
                  Left = 4
                  Top = 35
                  Width = 35
                  Height = 13
                  Caption = #1085#1072#1095#1072#1083#1086
                end
                object Label4: TLabel
                  Left = 131
                  Top = 36
                  Width = 30
                  Height = 13
                  Caption = #1082#1086#1085#1077#1094
                end
                object dtpPeriodBeginPutOnStock: TDateTimePicker
                  Left = 42
                  Top = 32
                  Width = 87
                  Height = 21
                  Date = 41084.477712511570000000
                  Time = 41084.477712511570000000
                  TabOrder = 0
                  OnChange = dtpPeriodBeginPutOnStockChange
                end
                object dtpPeriodEndPutOnStock: TDateTimePicker
                  Left = 167
                  Top = 32
                  Width = 95
                  Height = 21
                  Date = 41084.477931145830000000
                  Time = 41084.477931145830000000
                  TabOrder = 1
                  OnChange = dtpPeriodEndPutOnStockChange
                end
                object ckbPeriodStoreObjectCreating: TCheckBox
                  Left = 4
                  Top = 10
                  Width = 259
                  Height = 18
                  Caption = #1047#1072#1076#1072#1090#1100' '#1087#1077#1088#1080#1086#1076' '#1087#1088#1080#1093#1086#1076#1086#1074#1072#1085#1080#1103' '#1085#1072' '#1089#1082#1083#1072#1076
                  TabOrder = 2
                  OnClick = ckbPeriodStoreObjectCreatingClick
                end
              end
            end
          end
        end
      end
    end
  end
  object pcontCommonInfo: TPageControl
    Left = 288
    Top = 0
    Width = 909
    Height = 499
    ActivePage = tsheetOrderInfo
    Align = alClient
    TabOrder = 2
    OnChange = pcontCommonInfoChange
    OnResize = pcontCommonInfoResize
    object tsheetOrderInfo: TTabSheet
      Caption = #1047#1072#1082#1072#1079#1099
      ImageIndex = 2
      object Splitter4: TSplitter
        Left = 0
        Top = 185
        Width = 901
        Height = 2
        Cursor = crVSplit
        Align = alBottom
      end
      object gbDocItem: TGroupBox
        Left = 0
        Top = 187
        Width = 901
        Height = 284
        Align = alBottom
        Caption = #1057#1086#1076#1077#1088#1078#1072#1085#1080#1077': '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object pcontDocumentItem: TPageControl
          Left = 2
          Top = 15
          Width = 897
          Height = 267
          ActivePage = tsheetMTR
          Align = alClient
          TabOrder = 0
          OnChange = pcontDocumentItemChange
          object tsheetMTR: TTabSheet
            Caption = #1052#1058#1056
            object ToolBar2: TToolBar
              Left = 0
              Top = 0
              Width = 889
              Height = 29
              ButtonWidth = 24
              Caption = 'ToolBar2'
              Images = ilOrderItemOperations
              TabOrder = 0
              object tbEditDocumentItem: TToolButton
                Left = 0
                Top = 2
                Caption = 'tbEditDocumentItem'
                ImageIndex = 6
                ParentShowHint = False
                ShowHint = True
                OnClick = tbEditDocumentItemClick
              end
              object tbAddDocumentItem: TToolButton
                Left = 24
                Top = 2
                Caption = 'AddOrdersItem'
                ImageIndex = 5
                ParentShowHint = False
                ShowHint = True
                OnClick = tbAddDocumentItemClick
              end
              object ToolButton6: TToolButton
                Left = 48
                Top = 2
                Width = 11
                Caption = 'ToolButton6'
                ImageIndex = 2
                Style = tbsSeparator
              end
              object tbDeleteDocumentItem: TToolButton
                Left = 59
                Top = 2
                Caption = 'DeleteOrdersItem'
                ImageIndex = 7
                ParentShowHint = False
                ShowHint = True
                OnClick = tbDeleteDocumentItemClick
              end
              object ToolButton1: TToolButton
                Left = 83
                Top = 2
                Width = 48
                Caption = 'ToolButton1'
                ImageIndex = 8
                Style = tbsSeparator
              end
              object sbJobDocumentItem_MTR: TSpeedButton
                Left = 131
                Top = 2
                Width = 83
                Height = 22
                Caption = #1044#1077#1081#1089#1090#1074#1080#1077
                Enabled = False
                OnClick = sbJobDocumentItem_MTRClick
              end
              object ToolButton3: TToolButton
                Left = 214
                Top = 2
                Width = 48
                Caption = 'ToolButton3'
                ImageIndex = 10
                Style = tbsSeparator
              end
              object tbItemToStore: TToolButton
                Left = 262
                Top = 2
                Caption = 'tbItemToStore'
                ImageIndex = 11
                OnClick = tbItemToStoreClick
              end
              object ToolButton4: TToolButton
                Left = 286
                Top = 2
                Width = 21
                Caption = 'ToolButton4'
                ImageIndex = 12
                Style = tbsSeparator
              end
            end
            object dbgrDocumentItem: TDBGrid
              Left = 0
              Top = 29
              Width = 889
              Height = 210
              Align = alClient
              DataSource = dmDB.dsDocumentItem
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
              ParentFont = False
              TabOrder = 1
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'MS Sans Serif'
              TitleFont.Style = [fsBold]
              OnCellClick = dbgrDocumentItemCellClick
              OnDrawColumnCell = dbgrDocumentItemDrawColumnCell
              OnDblClick = dbgrDocumentItemDblClick
              OnEnter = dbgrDocumentItemEnter
              OnKeyUp = dbgrDocumentItemKeyUp
              OnMouseUp = dbgrDocumentItemMouseUp
              Columns = <
                item
                  Expanded = False
                  FieldName = 'ObjectGroupName'
                  Title.Caption = #1043#1088#1091#1087#1087#1072
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 135
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'ShortName'
                  Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 258
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'FullName'
                  Title.Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 187
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'MeasurmentUnitName'
                  Title.Caption = #1045#1076'. '#1080#1079#1084'.'
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 46
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'Volume'
                  Title.Caption = #1050#1086#1083'-'#1074#1086
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 60
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'Notes'
                  Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 153
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'JobResult'
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Visible = False
                end>
            end
          end
          object tsheetManufacturing_Tree: TTabSheet
            Caption = #1053#1072' '#1080#1079#1075#1086#1090#1086#1074#1083#1077#1085#1080#1077' ('#1048#1077#1088#1072#1088#1093#1080#1095#1077#1089#1082#1086#1077' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077')'
            ImageIndex = 1
            object tvManufacturingItem: TTreeView
              Left = 0
              Top = 29
              Width = 889
              Height = 210
              Align = alClient
              Indent = 19
              TabOrder = 0
              OnChange = tvManufacturingItemChange
              OnExpanding = tvManufacturingItemExpanding
              OnMouseMove = tvManufacturingItemMouseMove
            end
            object ToolBar9: TToolBar
              Left = 0
              Top = 0
              Width = 889
              Height = 29
              ButtonWidth = 29
              Caption = 'ToolBar2'
              Images = ilOrderItemOperations
              TabOrder = 1
              object tbEditProductManufacturingItem: TToolButton
                Left = 0
                Top = 2
                Caption = 'tbEditOrdersItem'
                ImageIndex = 6
                ParentShowHint = False
                ShowHint = True
              end
              object tbAddProductManufacturingItem: TToolButton
                Left = 29
                Top = 2
                Caption = 'AddOrdersItem'
                ImageIndex = 5
                ParentShowHint = False
                ShowHint = True
                OnClick = tbAddProductManufacturingItemClick
              end
              object ToolButton16: TToolButton
                Left = 58
                Top = 2
                Width = 11
                Caption = 'ToolButton6'
                ImageIndex = 2
                Style = tbsSeparator
              end
              object tbDeleteProductManufacturingItem: TToolButton
                Left = 69
                Top = 2
                Caption = 'DeleteOrdersItem'
                ImageIndex = 7
                ParentShowHint = False
                ShowHint = True
              end
              object ToolButton19: TToolButton
                Left = 98
                Top = 2
                Width = 48
                Caption = 'ToolButton1'
                ImageIndex = 8
                Style = tbsSeparator
              end
              object sbOrderItemJob_Manufacturing: TSpeedButton
                Left = 146
                Top = 2
                Width = 83
                Height = 22
                Caption = #1044#1077#1081#1089#1090#1074#1080#1077
              end
              object ToolButton23: TToolButton
                Left = 229
                Top = 2
                Width = 48
                Caption = 'ToolButton3'
                ImageIndex = 10
                Style = tbsSeparator
              end
              object ToolButton24: TToolButton
                Left = 277
                Top = 2
                Caption = 'tbItemToStore'
                ImageIndex = 11
              end
              object ToolButton25: TToolButton
                Left = 306
                Top = 2
                Width = 21
                Caption = 'ToolButton4'
                ImageIndex = 12
                Style = tbsSeparator
              end
            end
          end
          object tsheetManufacturing_Linear: TTabSheet
            Caption = #1053#1072' '#1080#1079#1075#1086#1090#1086#1074#1083#1077#1085#1080#1077' ('#1083#1080#1085#1077#1081#1085#1086#1077' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077')'
            ImageIndex = 2
            object ToolBar11: TToolBar
              Left = 0
              Top = 0
              Width = 897
              Height = 29
              Caption = 'ToolBar2'
              Images = ilOrderItemOperations
              TabOrder = 0
              object tbResizeOrderItem: TToolButton
                Left = 0
                Top = 2
                Caption = 'tbResizeOrderItem'
                ImageIndex = 13
                OnClick = tbResizeOrderItemClick
              end
              object ToolButton45: TToolButton
                Left = 23
                Top = 2
                Width = 26
                Caption = 'ToolButton45'
                ImageIndex = 5
                Style = tbsSeparator
              end
              object ToolButton33: TToolButton
                Left = 49
                Top = 2
                Caption = 'tbEditOrdersItem'
                ImageIndex = 6
                ParentShowHint = False
                ShowHint = True
              end
              object ToolButton34: TToolButton
                Left = 72
                Top = 2
                Caption = 'AddOrdersItem'
                ImageIndex = 5
                ParentShowHint = False
                ShowHint = True
                OnClick = tbAddProductManufacturingItemClick
              end
              object ToolButton35: TToolButton
                Left = 95
                Top = 2
                Width = 11
                Caption = 'ToolButton6'
                ImageIndex = 2
                Style = tbsSeparator
              end
              object ToolButton36: TToolButton
                Left = 106
                Top = 2
                Caption = 'DeleteOrdersItem'
                ImageIndex = 7
                ParentShowHint = False
                ShowHint = True
              end
              object ToolButton37: TToolButton
                Left = 129
                Top = 2
                Width = 48
                Caption = 'ToolButton1'
                ImageIndex = 8
                Style = tbsSeparator
              end
              object ToolButton41: TToolButton
                Left = 177
                Top = 2
                Width = 48
                Caption = 'ToolButton3'
                ImageIndex = 10
                Style = tbsSeparator
              end
              object ToolButton42: TToolButton
                Left = 225
                Top = 2
                Caption = 'tbItemToStore'
                ImageIndex = 11
              end
            end
            object dbgrOrdersItems_Manufacturing: TDBGrid
              Left = 0
              Top = 29
              Width = 897
              Height = 210
              Align = alClient
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
              ParentFont = False
              TabOrder = 1
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'MS Sans Serif'
              TitleFont.Style = [fsBold]
              OnDrawColumnCell = dbgrOrdersItems_ManufacturingDrawColumnCell
              OnMouseUp = dbgrDocumentItemMouseUp
              Columns = <
                item
                  Expanded = False
                  FieldName = 'FullName'
                  Title.Caption = #1054#1073#1086#1079#1085#1072#1095#1077#1085#1080#1077
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 109
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'ShortName'
                  Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 169
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'FullName'
                  Title.Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 264
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'MeasurmentUnitName'
                  Title.Caption = #1045#1076'. '#1080#1079#1084'.'
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 46
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'Volume'
                  Title.Caption = #1050#1086#1083'-'#1074#1086
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 60
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'Notes'
                  Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 153
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'ActionsCode'
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Visible = True
                end>
            end
          end
          object tsheetRepairing_Tree: TTabSheet
            Caption = #1053#1072' '#1088#1077#1084#1086#1085#1090' ('#1048#1077#1088#1072#1088#1093#1080#1095#1077#1089#1082#1086#1077' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077')'
            Enabled = False
            ImageIndex = 3
          end
          object tsheetRepairing_Linear: TTabSheet
            Caption = #1053#1072' '#1088#1077#1084#1086#1085#1090' ('#1051#1080#1085#1077#1081#1085#1086#1077' '#1087#1088#1077#1076#1089#1090#1072#1074#1083#1077#1085#1080#1077')'
            Enabled = False
            ImageIndex = 4
          end
        end
      end
      object pcontDocumentType: TPageControl
        Left = 0
        Top = 0
        Width = 901
        Height = 185
        ActivePage = tsheetOrderInfo_MTR
        Align = alClient
        TabOrder = 1
        OnChange = pcontDocumentTypeChange
        object tsheetOrderInfo_MTR: TTabSheet
          Caption = #1047#1072#1103#1074#1082#1080' '#1085#1072' '#1087#1088#1080#1086#1073#1088#1077#1090#1077#1085#1080#1077
          object gbDocList: TGroupBox
            Left = 0
            Top = 0
            Width = 893
            Height = 157
            Align = alClient
            Caption = #1055#1077#1088#1077#1095#1077#1085#1100': '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            object ToolBar3: TToolBar
              Left = 2
              Top = 15
              Width = 889
              Height = 29
              Caption = 'ToolBar2'
              Images = ilOrderOperations
              TabOrder = 0
              object tbEditDocument: TToolButton
                Left = 0
                Top = 2
                Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1079#1072#1103#1074#1082#1080
                Caption = 'tbEditOrderPosition'
                ImageIndex = 6
                ParentShowHint = False
                ShowHint = True
                OnClick = tbEditDocumentClick
              end
              object tbAddDocument: TToolButton
                Left = 23
                Top = 2
                Hint = #1057#1086#1079#1076#1072#1085#1080#1077' '#1079#1072#1103#1074#1082#1080
                Caption = 'ToolButton4'
                ImageIndex = 5
                ParentShowHint = False
                ShowHint = True
                OnClick = tbAddDocumentClick
              end
              object ToolButton9: TToolButton
                Left = 46
                Top = 2
                Width = 11
                Caption = 'ToolButton6'
                ImageIndex = 2
                Style = tbsSeparator
              end
              object tbDeleteDocument: TToolButton
                Left = 57
                Top = 2
                Hint = #1059#1076#1072#1083#1077#1085#1080#1077' '#1079#1072#1103#1074#1082#1080
                Caption = 'ToolButton7'
                ImageIndex = 7
                ParentShowHint = False
                ShowHint = True
                OnClick = tbDeleteDocumentClick
              end
              object ToolButton5: TToolButton
                Left = 80
                Top = 2
                Width = 49
                Caption = 'ToolButton5'
                ImageIndex = 8
                Style = tbsSeparator
              end
              object sbJobDocument_MTR: TSpeedButton
                Left = 129
                Top = 2
                Width = 83
                Height = 22
                Caption = #1044#1077#1081#1089#1090#1074#1080#1077
                Enabled = False
                OnClick = sbJobDocument_MTRClick
              end
              object ToolButton26: TToolButton
                Left = 212
                Top = 2
                Width = 19
                Caption = 'ToolButton26'
                ImageIndex = 10
                Style = tbsSeparator
              end
            end
            object dbgrDocument_MTR: TDBGrid
              Left = 2
              Top = 44
              Width = 889
              Height = 111
              Align = alClient
              DataSource = dmDB.dsDocument
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit]
              ParentFont = False
              TabOrder = 1
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'MS Sans Serif'
              TitleFont.Style = [fsBold]
              OnCellClick = dbgrDocument_MTRCellClick
              OnDrawColumnCell = dbgrDocument_MTRDrawColumnCell
              OnDblClick = dbgrehDocumentDblClick
              OnKeyUp = dbgrDocument_MTRKeyUp
              OnMouseUp = dbgrDocument_MTRMouseUp
              Columns = <
                item
                  Expanded = False
                  FieldName = 'DocumentNum'
                  ReadOnly = True
                  Title.Caption = #8470' '#1079#1072#1103#1074#1082#1080
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 60
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'shortname'
                  Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 252
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'CreationDate'
                  Title.Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 100
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'CreatorOwnerFullViewing'
                  Title.Caption = #1048#1085#1080#1094#1080#1072#1090#1086#1088
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 200
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'ExecutionDate'
                  Title.Caption = #1057#1088#1086#1082' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1103
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 100
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'Notes'
                  Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 162
                  Visible = True
                end>
            end
          end
        end
        object tsheetOrderInfo_Manufactoring: TTabSheet
          Caption = #1047#1072#1082#1072#1079#1099' '#1085#1072' '#1080#1079#1075#1086#1090#1086#1074#1083#1077#1085#1080#1077
          Enabled = False
          ImageIndex = 1
          object GroupBox3: TGroupBox
            Left = 0
            Top = 0
            Width = 893
            Height = 157
            Align = alClient
            Caption = #1055#1077#1088#1077#1095#1077#1085#1100' '#1079#1072#1103#1074#1086#1082': '
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = [fsBold]
            ParentFont = False
            TabOrder = 0
            object ToolBar10: TToolBar
              Left = 2
              Top = 15
              Width = 889
              Height = 29
              Caption = 'ToolBar2'
              Images = ilOrderOperations
              TabOrder = 0
              object tbResizeOrderList: TToolButton
                Left = 0
                Top = 2
                Caption = 'tbResizeOrderList'
                ImageIndex = 11
                OnClick = tbResizeOrderListClick
              end
              object ToolButton32: TToolButton
                Left = 23
                Top = 2
                Width = 27
                Caption = 'ToolButton26'
                ImageIndex = 10
                Style = tbsSeparator
              end
              object ToolButton14: TToolButton
                Left = 50
                Top = 2
                Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1079#1072#1103#1074#1082#1080
                Caption = 'tbEditOrderPosition'
                ImageIndex = 6
                ParentShowHint = False
                ShowHint = True
                OnClick = tbEditDocumentClick
              end
              object ToolButton15: TToolButton
                Left = 73
                Top = 2
                Hint = #1057#1086#1079#1076#1072#1085#1080#1077' '#1079#1072#1103#1074#1082#1080
                Caption = 'ToolButton4'
                ImageIndex = 5
                ParentShowHint = False
                ShowHint = True
                OnClick = tbAddDocumentClick
              end
              object ToolButton17: TToolButton
                Left = 96
                Top = 2
                Width = 11
                Caption = 'ToolButton6'
                ImageIndex = 2
                Style = tbsSeparator
              end
              object ToolButton27: TToolButton
                Left = 107
                Top = 2
                Hint = #1059#1076#1072#1083#1077#1085#1080#1077' '#1079#1072#1103#1074#1082#1080
                Caption = 'ToolButton7'
                ImageIndex = 7
                ParentShowHint = False
                ShowHint = True
                OnClick = tbDeleteDocumentClick
              end
              object ToolButton28: TToolButton
                Left = 130
                Top = 2
                Width = 49
                Caption = 'ToolButton5'
                ImageIndex = 8
                Style = tbsSeparator
              end
              object SpeedButton1: TSpeedButton
                Left = 179
                Top = 2
                Width = 83
                Height = 22
                Caption = #1044#1077#1081#1089#1090#1074#1080#1077
                Enabled = False
                OnClick = sbJobDocument_MTRClick
              end
              object ToolButton29: TToolButton
                Left = 262
                Top = 2
                Hint = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1077' '#1079#1072#1103#1074#1082#1080
                Caption = 'tbConfirmOrder'
                ImageIndex = 10
                ParentShowHint = False
                ShowHint = True
              end
              object ToolButton30: TToolButton
                Left = 285
                Top = 2
                Hint = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1079#1072#1103#1074#1082#1080
                Caption = 'tbDenyOrder'
                ImageIndex = 8
                ParentShowHint = False
                ShowHint = True
                OnClick = tbDenyOrderClick
              end
              object ToolButton31: TToolButton
                Left = 308
                Top = 2
                Hint = #1042#1086#1079#1074#1088#1072#1090' '#1085#1072' '#1087#1077#1088#1077#1088#1072#1073#1086#1090#1082#1091
                Caption = 'tbToAlterationOrder'
                ImageIndex = 9
                ParentShowHint = False
                ShowHint = True
                OnClick = tbToAlterationOrderClick
              end
            end
            object dbgrDocument_Manufactoring: TDBGrid
              Left = 2
              Top = 44
              Width = 889
              Height = 111
              Align = alClient
              DataSource = dmDB.dsDocument
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'MS Sans Serif'
              Font.Style = []
              Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
              ParentFont = False
              TabOrder = 1
              TitleFont.Charset = DEFAULT_CHARSET
              TitleFont.Color = clWindowText
              TitleFont.Height = -11
              TitleFont.Name = 'MS Sans Serif'
              TitleFont.Style = [fsBold]
              OnDrawColumnCell = dbgrDocument_ManufactoringDrawColumnCell
              OnDblClick = dbgrehDocumentDblClick
              OnMouseUp = dbgrDocument_MTRMouseUp
              Columns = <
                item
                  Expanded = False
                  FieldName = 'DocumentNum'
                  ReadOnly = True
                  Title.Caption = #8470' '#1047#1072#1082#1072#1079#1072
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 65
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'Notes'
                  Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 400
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'CreationDate'
                  Title.Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 100
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'CreatorOwnerFullViewing'
                  Title.Caption = #1048#1085#1080#1094#1080#1072#1090#1086#1088
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 200
                  Visible = True
                end
                item
                  Expanded = False
                  FieldName = 'ExecutionDate'
                  Title.Caption = #1057#1088#1086#1082' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1103
                  Title.Font.Charset = DEFAULT_CHARSET
                  Title.Font.Color = clWindowText
                  Title.Font.Height = -11
                  Title.Font.Name = 'MS Sans Serif'
                  Title.Font.Style = []
                  Width = 100
                  Visible = True
                end>
            end
          end
        end
        object tsheetOrderInfo_Repairing: TTabSheet
          Caption = #1047#1072#1082#1072#1079#1099' '#1085#1072' '#1088#1077#1084#1086#1085#1090
          Enabled = False
          ImageIndex = 2
        end
      end
    end
    object tsheetStoreInfo_MTR: TTabSheet
      Caption = #1057#1082#1083#1072#1076' '#1052#1058#1057
      ImageIndex = 2
      object GroupBox4: TGroupBox
        Left = 0
        Top = 0
        Width = 901
        Height = 471
        Align = alClient
        Caption = #1055#1077#1088#1077#1095#1077#1085#1100' '#1052#1058#1056' '#1085#1072' '#1089#1082#1083#1072#1076#1077': '
        TabOrder = 0
        object ToolBar6: TToolBar
          Left = 2
          Top = 15
          Width = 897
          Height = 29
          Caption = 'ToolBar2'
          Images = ilOrderOperations
          TabOrder = 0
          object ToolButton8: TToolButton
            Left = 0
            Top = 2
            Hint = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1079#1072#1103#1074#1082#1080
            Caption = 'tbEditOrderPosition'
            ImageIndex = 6
            ParentShowHint = False
            ShowHint = True
          end
          object ToolButton10: TToolButton
            Left = 23
            Top = 2
            Hint = #1057#1086#1079#1076#1072#1085#1080#1077' '#1079#1072#1103#1074#1082#1080
            Caption = 'ToolButton4'
            ImageIndex = 5
            ParentShowHint = False
            ShowHint = True
          end
          object ToolButton11: TToolButton
            Left = 46
            Top = 2
            Width = 11
            Caption = 'ToolButton6'
            ImageIndex = 2
            Style = tbsSeparator
          end
          object ToolButton12: TToolButton
            Left = 57
            Top = 2
            Hint = #1059#1076#1072#1083#1077#1085#1080#1077' '#1079#1072#1103#1074#1082#1080
            Caption = 'ToolButton7'
            ImageIndex = 7
            ParentShowHint = False
            ShowHint = True
          end
          object ToolButton13: TToolButton
            Left = 80
            Top = 2
            Width = 49
            Caption = 'ToolButton5'
            ImageIndex = 8
            Style = tbsSeparator
          end
        end
        object dbgrStoreMTR: TDBGrid
          Left = 2
          Top = 44
          Width = 897
          Height = 425
          Align = alClient
          DataSource = dmDB.dsStoreObjectList
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgMultiSelect]
          ParentFont = False
          TabOrder = 1
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'MS Sans Serif'
          TitleFont.Style = [fsBold]
          Columns = <
            item
              Expanded = False
              FieldName = 'ObjectGroupName'
              Title.Caption = #1043#1088#1091#1087#1087#1072
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = []
              Width = 96
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'ShortName'
              Title.Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = []
              Width = 192
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'FullName'
              Title.Caption = #1055#1086#1083#1085#1086#1077' '#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = []
              Width = 205
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'MeasurmentUnitName'
              Title.Caption = #1045#1076'. '#1080#1079#1084'.'
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = []
              Width = 46
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Volume'
              Title.Caption = #1050#1086#1083'-'#1074#1086
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = []
              Width = 60
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'CreationDate'
              Title.Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076#1086#1074#1072#1085#1080#1103
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = []
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'OrderCreationDate'
              Title.Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = []
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'Notes'
              Title.Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103
              Title.Font.Charset = DEFAULT_CHARSET
              Title.Font.Color = clWindowText
              Title.Font.Height = -11
              Title.Font.Name = 'MS Sans Serif'
              Title.Font.Style = []
              Width = 153
              Visible = True
            end>
        end
      end
    end
    object tsheetStoreInfo_GotProd: TTabSheet
      Caption = #1057#1082#1083#1072#1076' '#1043#1055
      ImageIndex = 2
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 499
    Width = 1197
    Height = 137
    Align = alBottom
    Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1080'...'
    TabOrder = 3
    object pcontComments: TPageControl
      Left = 2
      Top = 15
      Width = 1193
      Height = 120
      ActivePage = tsheetDocumentComment
      Align = alClient
      TabOrder = 0
      object tsheetDocumentComment: TTabSheet
        Caption = #1055#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1091' ('#1074#1094#1077#1083#1086#1084')'
        object tvDocumentComment: TTreeView
          Left = 0
          Top = 0
          Width = 1185
          Height = 92
          Align = alClient
          Indent = 19
          ReadOnly = True
          TabOrder = 0
        end
      end
      object tsheetDocumentItemComment: TTabSheet
        Caption = #1055#1086' '#1089#1090#1088#1086#1082#1072#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
        ImageIndex = 1
        object tvDocumentItemComment: TTreeView
          Left = 0
          Top = 0
          Width = 1185
          Height = 92
          Align = alClient
          Indent = 19
          ReadOnly = True
          TabOrder = 0
        end
      end
    end
  end
  object mainMenu: TMainMenu
    Left = 920
    Top = 96
    object miFile: TMenuItem
      Caption = #1060#1072#1081#1083
      object Connect1: TMenuItem
        Caption = 'Connect'
        OnClick = miConnectClick
      end
      object Close1: TMenuItem
        Caption = 'Close'
        OnClick = Close1Click
      end
    end
    object miView: TMenuItem
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088
      object miView_Sorting: TMenuItem
        Caption = 'C'#1086#1088#1090#1080#1088#1086#1074#1082#1072
      end
    end
    object N1: TMenuItem
      Caption = #1056#1072#1073#1086#1090#1072' '#1089' '#1079#1072#1103#1074#1082#1072#1084#1080
      object N2: TMenuItem
        Caption = #1057#1086#1079#1076#1072#1090#1100' '#1079#1072#1103#1074#1082#1091
      end
      object N12: TMenuItem
        Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1079#1072#1103#1074#1082#1080
      end
      object N11: TMenuItem
        Caption = #1059#1076#1072#1083#1077#1085#1080#1077' '#1079#1072#1103#1074#1082#1080
        OnClick = N11Click
      end
      object N10: TMenuItem
        Caption = '-------- '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1077' ------------'
        Enabled = False
      end
      object N7: TMenuItem
        Caption = #1055#1088#1080#1085#1103#1090#1100' ('#1089#1086#1075#1083#1072#1089#1086#1074#1072#1090#1100')'
      end
      object N17: TMenuItem
        Caption = #1054#1090#1082#1072#1079#1072#1090#1100' ('#1079#1072#1087#1088#1077#1090#1080#1090#1100')'
      end
      object N18: TMenuItem
        Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1085#1072' '#1076#1086#1088#1072#1073#1086#1090#1082#1091
      end
      object N19: TMenuItem
        Caption = '-------- '#1048#1089#1087#1086#1083#1085#1077#1085#1080#1077' ------------'
        Enabled = False
      end
      object mnPutToStore: TMenuItem
        Caption = #1055#1088#1080#1093#1086#1076#1086#1074#1072#1085#1080#1077' '#1085#1072' '#1089#1082#1083#1072#1076
        OnClick = mnPutToStoreClick
      end
    end
    object miTools: TMenuItem
      Caption = #1057#1077#1088#1074#1080#1089
      object N8: TMenuItem
        Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1078#1091#1088#1085#1072#1083#1072' '#1089#1086#1073#1099#1090#1080#1081
        OnClick = N8Click
      end
      object N9: TMenuItem
        Caption = #1054#1090#1095#1077#1090#1099
        object N16: TMenuItem
          Caption = #1044#1083#1103' '#1080#1089#1087#1086#1083#1085#1077#1085#1080#1103
          OnClick = N16Click
        end
      end
      object N20: TMenuItem
        Caption = '--------------------------------'
        Enabled = False
      end
      object N21: TMenuItem
        Caption = #1055#1086#1083#1091#1095#1077#1085#1080#1077' '#1090#1077#1082#1089#1090#1072' SP_F '#1041#1044
        OnClick = N21Click
      end
      object P1: TMenuItem
        Caption = #1047#1072#1087#1080#1089#1100' '#1090#1077#1082#1089#1090#1072' SP_F '#1074' '#1041#1044
        OnClick = P1Click
      end
      object N22: TMenuItem
        Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1082#1072#1090#1072#1083#1086#1075#1072
        OnClick = N22Click
      end
      object SPX1: TMenuItem
        Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' SP_X'
      end
    end
    object miReferenceBook: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082#1080
      object N101: TMenuItem
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072'...'
        OnClick = N101Click
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
        Caption = #1043#1088#1091#1087#1087' '#1086#1073#1098#1077#1082#1090#1086#1074' '#1079#1072#1082#1072#1079#1072
      end
      object N5: TMenuItem
        Caption = #1045#1076#1080#1085#1080#1094' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
      end
      object N6: TMenuItem
        Caption = #1058#1080#1087#1099' '#1079#1072#1082#1072#1079#1086#1074
      end
    end
    object miAbout: TMenuItem
      Caption = #1057#1087#1088#1072#1074#1082#1072
      OnClick = miAboutClick
    end
  end
  object ilCollBarMainForm: TImageList
    Left = 953
    Top = 96
    Bitmap = {
      494C010110001300040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000009CE7F7009CE7FF008CE7
      F7008CE7F70084DEEF007BCEDE006BADA5006B9C8400528C7B0063B5BD007BD6
      EF007BBDD60094D6EF008CBDD600000000008CC6D6007BBDD6007BBDD60073BD
      D60073BDD60073B5D600638C940084A563006B9442004A6B390073B5CE006BAD
      C600ADC6DE000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DE946B00EFBD9400DE947300DE63
      6B00EF429C00F729C600FF10E700000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A5EFFF009CE7FF0073BD
      C60084AD730094B56300B5BD9400ADCE8400B5D68C008CB55A006B8C3900B5A5
      5A00CEB55200B58C2900A56308000000000084C6DE008CDEF7008CE7F7007BDE
      F70094BD630084AD4A00A5CE7B00ADD68400A5CE7B007BA54A00424A3900C6B5
      4A00BDA54200AD7B21008C39000000000000000000004A4A52005A5A5A005A5A
      5A005A5A5A005A5A5A005A5A5A005A5A5A005A5A5A00635A5A0063635A006363
      5A00636363006B6363005A5A5A0000000000EFCEA500FFFFFF00FFFFFF00FFFF
      FF00F7E7CE00EFCEAD00E7B58400DE946B00DE5A7300E7429C00F718CE00FF08
      F7000000000000000000000000000000000000000000A5EFFF009CE7FF008CD6
      BD00A5CE7B009CBD7B00D6CEBD00A5CE8400BDDE9C009CC66B007B944A00D6BD
      6B00C6B55A00C6B55A00B58C29000000000084C6DE008CE7EF007BE7F70084DE
      DE00A5CE7B009CB58C00CEDEAD00B5D68C00BDDEA5009CC66B008C7B6B00C6B5
      4A00CEBD7300C6B55A00A57310000000000000000000FFFFEF00FFFFF700FFFF
      F700FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFFF
      F700FFFFF700FFFFF700424A4A0000000000EFCEA500FFFFFF00F7EFDE00EFB5
      8400E7A55A00E7B58C00FFEFE700FFFFFF00FFFFFF00F7DECE00EFC6A500E7AD
      7B00DE846B00DE526B00E7399400FF08E70000000000A5EFFF009CEFFF008CE7
      F70094D6B500B5CE94006B849C007B9C7B00B5CE8400A5BD7300AD9C5A00CEC6
      AD00C6B55A00CEBD7300CEB552000000000084C6DE009CEFFF008CE7F7008CE7
      F700BDDEA500A5BD94004A6B9400ADCE8400ADCE84009CBD7300A5A59C00CEBD
      7300CEBD7300CEBD7300BDA542000000000000000000FFFFE700FFFFEF00BDBD
      AD008C947300ADD67B009CC66300739C4200848C7B00FFFFF700D6CECE00BDB5
      AD00E7E7D600FFFFF700424A4A0000000000EFCEA500FFFFFF00EFB57B00FF9C
      1800FFAD2100FFA51800E7841800EFBD9400FFFFFF00FFEFD600FFF7DE00FFF7
      EF00FFFFF700FFF7EF00F7DEC600DE8C5A0000000000ADEFFF009CEFFF0094EF
      F7008CE7F70094BD8C005273940042637B008CAD6B00B5AD6B00CEBD7300426B
      94007B847300CEBD6300C6B56300000000008CCEE7009CEFFF009CEFFF008CE7
      F7008CE7EF008CC68C00425A73004A6B7B007BA57B00D6C68400738CA5004263
      8400C6AD5200CEB56300000000000000000000000000FFF7DE00ADD67300A5CE
      6B00C6BDAD009CCE7B00BDD69C009CBD6B005A6B3100DEC65A00CEBD5A00BD9C
      4200AD5A0800DED6D60042424A0000000000EFC6A500FFFFFF00F7CE9C00FFC6
      5A00FFC66300FFCE6B00FFAD3900F7A53900F7E7D600FFE7B500FFD6A500FFD6
      9C00FFD69C00FFDEAD00FFE7C600E7BD8C0000000000ADF7FF00A5EFFF0094EF
      F70094EFF7006394BD00638CB500395A7B00639CA5007BDEF70073B5BD003163
      8C0029527300A5E7F700ADE7F700000000008CCEE700ADF7FF008CE7F7008CE7
      F7008CE7F7005A94B5004273A50029425A007BDEF7007BDEF700396B94002952
      7B006B6B5A0073B5D600000000000000000000000000FFF7DE009CC67300ADD6
      8C00D6CEC600A5CE7B00BDDE9C00ADD67B008C8C5A00E7D68C00CEBD6B00D6C6
      7B00BD9C2900FFFFF7004242420000000000EFC69C00FFFFFF00FFEFD600FFDE
      9C00C6D6CE00D6E7EF00FFD68400F7C67B00FFE7D600FFEFD600FFE7CE00FFE7
      C600FFDEAD00FFD6A500FFDEAD00E7B58C0000000000B5F7FF00A5EFFF00A5EF
      FF009CEFFF0094B5D6008CADCE00527BA5003131310084DEEF00639CC6005284
      AD0039638C008CCEE70084C6DE000000000094D6EF00ADF7FF009CEFFF009CEF
      FF008CE7F70094B5D600739CC6005284AD00394242007BC6DE00739CBD00527B
      A5002931310073B5D600000000000000000000000000FFFFEF00F7F7DE00BDDE
      84004A6B9400315A8400B5D67B00ADBD7B00B5AD7B007B94AD00CEB55200CEBD
      6B00BDA55A00FFFFF7004242420000000000EFC69C00FFFFF700FFFFFF005AA5
      EF00429CFF00399CF70073ADD600F7D6AD00FFFFF700FFD6A500FFD69C00FFD6
      A500FFDEB500FFE7C600FFE7CE00E7B5840000000000B5F7FF00ADEFFF00A5EF
      FF00A5EFFF00C6DEEF00B5CEE7005A8CB500394A630084BDCE00BDD6EF008CAD
      CE006394BD00424A5200000000000000000094D6EF00A5EFF700ADF7FF009CEF
      FF009CEFFF00C6D6E70094B5D6005284AD003939390094C6DE00A5BDD600739C
      C60042739C007B7B7B00000000000000000000000000FFFFE700FFFFE700EFE7
      D600396B9C00214A7B00FFFFEF00F7EFDE00B5AD7B00315A8400636B5A00CEBD
      8400FFFFF700FFFFF7004242420000000000EFC69C00FFFFF700FFFFFF0052AD
      FF0073C6FF0073C6FF0063B5FF00ADD6FF00FFFFF700FFD6AD00FFCE9400FFCE
      8C00FFC68C00FFC68C00FFD6AD00EFB5840000000000BDF7FF00ADEFFF00ADF7
      FF00A5EFFF009CBDD6008CA5BD004A5A6B00393939008CC6D600CEE7F7009CBD
      DE006394BD0039393900000000000000000094D6EF00ADF7FF00ADF7FF009CEF
      FF0084DEEF0094B5D600526B7B0042393900423939009CCEE700BDD6E70084AD
      CE00395A7B0039393900000000000000000000000000FFFFE700FFFFE70084AD
      CE007BA5C600528CB5004A393100FFFFE7004A84B5004A7BA5004A5A7300FFFF
      F700FFFFF700FFFFF7003942420000000000F7C69400FFFFF700FFFFFF0063B5
      FF0094D6FF0094D6FF0094D6FF0094CEFF00FFFFF700FFD6AD00FFD6A500FFDE
      B500FFD6AD00FFDEB500FFDEB500EFB5840000000000BDF7FF00B5F7FF00B5FF
      FF00ADF7FF008CA5A5007B8C8C00738C940084C6CE007B949C00525A63005A5A
      5A005A5A5A006B848C000000000000000000A5DEEF00B5FFFF00ADF7FF00ADF7
      FF00ADF7FF0084848400636363005A5A52009CEFFF0039393900423939005252
      4A005A5A520084848400000000000000000000000000FFFFE700FFFFE700BDD6
      E700A5C6DE006B94BD00314A6300D6D6D600A5BDDE0084ADCE004A739C00948C
      8400FFFFF700FFFFF7003939420000000000F7C69400FFEFDE00FFF7EF00B5D6
      F70073BDFF008CD6FF006BBDFF00E7F7FF00FFF7EF00FFC68C00FFBD7B00FFBD
      7B00FFBD7B00FFBD7B00FFCE9C00EFB57B0000000000BDF7FF00B5F7FF00B5FF
      FF00ADF7FF00A5EFFF00A5E7EF00A5EFF700A5EFFF009CE7EF0084A5AD00737B
      7B00738C8C008CCEE7000000000000000000A5DEF700B5EFFF00ADF7FF00ADF7
      FF00ADF7FF00ADF7FF009CEFFF00ADF7FF009CEFFF009CEFFF007B8C94007B7B
      7B000000000000000000000000000000000000000000FFF7DE00FFFFE700A5C6
      DE0094B5CE004A637B0031292100CECECE00D6E7F700A5BDDE004A84B5003131
      2900FFFFF700FFFFF70052525A0000000000F7B56B00FFCE9400FFCE8C00FFD6
      9C00E7D6BD00CECEC600E7D6C600FFE7C600FFE7CE00FFD6AD00FFD6A500FFCE
      9C00FFCE9400FFC69400FFCE9400EFB57B0000000000C6FFFF00B5F7FF00B5FF
      FF00B5FFFF00B5FFFF00ADF7FF00ADF7FF00ADF7FF00A5EFFF00A5EFFF00A5EF
      FF00A5EFFF008CCEE7000000000000000000A5DEF700B5FFFF00B5FFFF00B5FF
      FF00ADF7FF00ADF7FF00ADF7FF00ADF7FF009CEFFF00ADF7FF009CEFFF009CEF
      FF000000000000000000000000000000000000000000FFF7DE00FFF7DE007373
      7300736B6B006B6B630094948C00BDB5AD00637B9400424A4A00524A4A004A4A
      5200FFFFF700FFFFF70052525A0000000000F7AD5200FFAD2900FFA51800FFA5
      0800FF9C0000FF9C0000FFAD2900FFAD2900FFB54200FFBD5200FFBD5200FFC6
      8400FFC68400FFCE9400FFD6AD00EFB57B0000000000C6FFFF00BDF7FF00BDFF
      FF00B5FFFF00B5FFFF00B5FFFF00ADF7FF00ADF7FF00ADF7FF00ADF7FF00ADF7
      FF00A5EFFF009CDEEF000000000000000000A5EFF700C6FFFF00B5FFFF00ADF7
      FF00B5FFFF00ADF7FF00ADF7FF00ADF7FF00ADF7FF00ADF7FF00ADF7FF009CEF
      FF000000000000000000000000000000000000000000FFF7DE00FFF7DE00FFF7
      DE00FFF7DE00FFF7DE00FFF7DE00FFFFE700A59C9C0073737300A5A5A500FFFF
      EF00FFFFEF00FFFFF7005A5A5A0000000000F7B55A00FFB54200FFB53100FFAD
      2100FFA51000FF9C0800FF9C0000F79C3100EF9C2900F79C2900F79C1000F79C
      1000FF9C1000FF9C0000FF9C0000EF94290000000000C6FFFF00BDF7FF00C6FF
      FF00C6FFFF00BDFFFF00BDFFFF00BDFFFF00B5FFFF00B5FFFF00B5FFFF00B5FF
      FF00B5F7FF009CDEEF000000000000000000A5EFF700C6FFFF00B5FFFF00B5FF
      FF00B5FFFF00B5FFFF00B5FFFF00ADF7FF00ADF7FF009CEFFF009CEFFF00ADF7
      FF000000000000000000000000000000000000000000FFF7DE00FFF7DE00FFF7
      DE00FFF7DE00FFF7DE00FFF7DE00FFF7DE00FFFFE700FFFFE700FFFFE700FFFF
      E700FFFFEF00FFFFF70052525A0000000000EFB56B00FFBD5200FFBD4200FFB5
      3900FFAD2900FFA51800FFA51000E7848400F729D600F729D600F739C600EF4A
      AD00EF4AAD00EF5A9400E7737B00EF529C0000000000C6FFFF00BDF7FF00C6FF
      FF00C6FFFF00C6FFFF00C6FFFF00C6FFFF00C6FFFF00BDFFFF00BDFFFF00B5FF
      FF00BDFFFF009CDEEF000000000000000000A5EFF700C6FFFF00C6FFFF00C6FF
      FF00C6FFFF00B5FFFF00C6FFFF00B5FFFF00B5FFFF00B5FFFF00ADF7FF00B5FF
      FF0000000000000000000000000000000000B5B5B500FFFFF700FFFFF700FFFF
      F700FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFFFF700FFFF
      F700FFFFF700FFFFF70063635A0000000000FF39D600EF849C00EF849400EF84
      8C00EFAD6300EFAD5A00EFAD4A00EF5AAD000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6844A00DE9C
      5A00DEA56B00DEA56B00DEA56B00DEA56B00DEA56B00DEA56B00DE9C6300DE9C
      6300D68C4A00D67B31000000000000000000000000000000000000000000FF08
      F700D639BD00C6639400B5848400BD848400BD848400B5848400C6639400D639
      BD00FF08F7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000AD21AD00007B00000084000000840000007B0000AD21AD000000
      0000000000000000000000000000000000000000000000000000DE9C6300FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00D6944A0000000000000000000000000000000000F718EF00B573
      8400AD6B6B00CE8C8C00D6949400BD7B7B00AD5A5A00CE949400C6848400AD6B
      6B00B5738400EF10E70000000000000000000000000000000000E7A56300FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFF700FFFFF700FFFFF700FFFFF700FFF7
      EF00FFF7EF00DE94520000000000000000000000000000000000000000000000
      0000000000008431840008A5100008A5100008A50800009C08007B317B000000
      0000000000000000000000000000000000000000000000000000E7AD7B00FFFF
      FF00FFFFFF00FFFFF700FFFFF700FFF7EF00FFF7EF00FFF7E700FFF7E700FFEF
      E700FFFFF700DEA56B0000000000000000000000000000000000C68C9C00CE8C
      8C00BD737300D6A5A500C6848400A5525200A5525200B56B6B00DEA5A500BD73
      7300CE8C8C00B573840000000000000000000000000000000000E7AD6B00FFFF
      F700FFFFF700FFF7EF00FFF7EF00FFF7EF00FFF7E700FFF7E700FFEFDE00FFEF
      DE00FFEFD600DE9C520000000000000000000000000000000000000000000000
      0000000000008439840010AD210010AD180008AD100008A510007B317B000000
      0000000000000000000000000000000000000000000000000000E7B58400FFFF
      FF00FFF7F700FFF7EF00FFF7EF00FFF7E700FFF7E700FFEFDE00FFEFDE00FFEF
      D600FFFFF700DEA5730000000000000000000000000000000000D6ADAD00DEAD
      AD00C6848400DEADAD00CE949400AD5A5A00AD5A5A00C67B7B00DEA5A500C684
      8400DEADAD00CE9C9C0000000000000000000000000000000000E7AD6B00FFFF
      F700FFF7EF00FFF7EF00FFF7E700FFF7E700FFEFDE00FFEFDE00FFEFDE00FFEF
      D600FFEFD600DE9C5A0000000000000000000000000000000000000000000000
      00000000000084398C0018B5290018B5210010AD210010AD1800843184000000
      0000000000000000000000000000000000000000000000000000E7B58400FFFF
      FF00FFF7E700FFF7E700FFEFDE00FFEFDE00FFEFD600FFEFD600FFE7CE00FFE7
      CE00FFFFF700E7AD730000000000000000000000000000000000D6BDBD00E7BD
      BD00DEADAD00DEB5B500E7B5B500B5636300B5636300D6A5A500DEADAD00DEAD
      AD00E7BDBD00CEADAD0000000000000000000000000000000000E7B57300FFF7
      EF00FFF7E700FFF7E700FFF7E700FFEFDE00FFEFDE00FFEFD600FFEFD600FFE7
      CE00FFE7CE00E7A5630000000000000000000000000000000000000000000000
      00000000000084428C0021BD310021BD310018B5290018B52100843984000000
      0000000000000000000000000000000000000000000000000000EFBD8C00FFFF
      F700FFEFDE00FFEFDE00FFEFD600FFEFD600FFE7CE00FFE7CE00FFE7C600FFE7
      C600FFF7EF00E7AD7B0000000000000000000000000000000000DE94C600F7D6
      D600EFC6C600E7BDBD00EFCECE00C67B7B00BD737300EFCECE00E7BDBD00EFCE
      CE00F7D6D600CE8CAD0000000000000000000000000000000000EFB57B00FFF7
      E700FFF7E700FFEFDE00FFEFDE00FFEFD600FFEFD600FFE7D600FFE7CE00FFE7
      CE00FFE7C600E7A563000000000000000000BD31C6008C529C008C4A9C008C4A
      94008C4A94004A6B5A0029C6420021C6390021BD310021BD3100425A4A008439
      8400843984008439840084318400AD21B5000000000000000000EFBD8C001073
      08001073080010730800FFE7CE00FFE7C600FFE7C600FFDEBD00FFDEBD00FFDE
      BD00FFF7EF00E7B57B0000000000000000000000000000000000EF52E700F7E7
      E700F7D6D600F7D6D600F7D6D600CE949400C6848400F7D6D600F7D6D600F7D6
      D600F7DEDE00E752D60000000000000000000000000000000000EFBD7B00FFEF
      E700FFEFDE00FFEFDE0021A5DE00FFEFD600FFE7CE00FFE7CE00FFE7C600FFE7
      C600FFDEC600E7AD6B00000000000000000031C6520042DE6B0042DE630042DE
      630039D65A0039D6520031CE4A0029CE420029C6420021C6390021BD310021BD
      310018B5290018B5210010AD1800088408000000000000000000EFC694000084
      0000009C000010730800FFE7C600FFDEBD00FFDEBD00FFDEB500FFDEB500FFD6
      AD00FFF7EF00E7B584000000000000000000000000000000000000000000EFAD
      DE00FFFFFF008CB5E700298CEF001084FF001084F7002184EF00ADC6E700FFF7
      F700DEA5C600FF08FF0000000000000000000000000000000000EFBD8400FFEF
      DE00FFEFD600FFEFD60021ADDE006BADD60021A5D600FFE7C600FFE7C600FFDE
      BD00FFDEBD00E7AD7300000000000000000042D6630052EF7B004AE773004AE7
      6B0042DE630042DE630039D65A0039D6520031CE4A0029CE420029C6420021C6
      390021BD310021BD310018B52900109418000000000000000000EFC694000084
      000039D6520010730800FFDEB500FFDEB500FFD6AD00FFD6AD00FFD6AD00FFD6
      A500FFF7EF00E7BD84000000000000000000000000000000000000000000FF29
      F700739CEF002994FF0039A5FF0039A5FF0039A5FF0039A5FF001884F7007394
      DE00FF21F7000000000000000000000000000000000000000000EFC68C00FFEF
      D600FFEFD600FFE7CE00FFE7CE0042ADFF0000DEFF0000A5DE00FFDEBD00FFDE
      BD00FFDEB500EFB57300000000000000000042E773005AF78C0052EF840052EF
      7B004AE773004AE76B0042DE630042DE630039D65A0039D6520031CE4A0029CE
      420029C6420021C6390021BD3100109C21000084000000840000008400000084
      000039D6520010730800107308001073080010730800FFD6A500FFCE9C00FFCE
      9C00FFF7E700EFBD8C000000000000000000000000000000000000000000E710
      FF002994FF0052B5FF0052B5FF0052B5FF004AB5FF004AB5FF004AB5FF00188C
      F700E708FF000000000000000000000000000000000000000000F7C68C00FFE7
      CE00FFE7CE00FFE7CE00FFE7C60063C6DE0000EFFF0000E7FF0000ADE700FFDE
      B500FFD6AD00EFB57B00000000000000000042E7730063FF940063FF94005AF7
      8C0052EF840052EF7B004AE773004AE76B0042DE630042DE630039D65A0039D6
      520031CE4A0029CE420029C639001094210008A5080039D6520039D6520039D6
      520039D6520039D6520039D6520008A5100000840000FFCE9C00FFCE9C00FFCE
      9C00FFF7E700EFBD8C0000000000000000000000000000000000000000008C4A
      FF0052B5FF0063C6FF0063C6FF0063C6FF0063C6FF0063BDFF0063BDFF0042AD
      FF009439FF000000000000000000000000000000000000000000F7CE9400FFE7
      CE00FFE7C600FFE7C600FFDEBD00FFDEBD0063CEDE0000F7FF0000EFFF0000B5
      EF00FFD6AD00EFBD84000000000000000000C642D6009C6BB5009C6BAD009C63
      AD009463AD0063947B0052EF840052EF7B004AE773004AE76B00527B6B008C4A
      9C008C4A94008C4A94008C4A9400B529BD0008A5080039CE5A0031C6520031CE
      520039D65200109418001094180010941800107B1000FFFFF700FFFFF700FFFF
      F700FFF7F700EFBD840000000000000000000000000000000000000000008C4A
      FF0094DEFF007BCEFF007BCEFF007BCEFF007BCEFF0073CEFF0073CEFF0063BD
      FF008C42FF000000000000000000000000000000000000000000F7CE9C00FFE7
      C600FFE7C600FFDEBD00FFDEBD00FFDEB500FFDEB50063CEDE0000FFFF0000EF
      FF0000BDF700F7C6940000000000000000000000000000000000000000000000
      0000000000009C63AD0063FF94005AF78C0052EF840052EF7B00945AA5000000
      0000000000000000000000000000000000000000000000000000F7D6A50039CE
      5A004AE7730010941800FFCE9C00FFCE9C00FFCE9C00FFFFF700FFFFF700FFFF
      F700EFC69400EF9C8C0000000000000000000000000000000000000000008C4A
      FF008CD6FF008CDEFF008CDEFF008CDEFF008CDEFF008CDEFF008CDEFF007BCE
      FF009C39FF000000000000000000000000000000000000000000F7D69C00FFDE
      BD00FFDEBD00FFDEB500FFDEB500FFDEB500FFD6AD00FFD6AD0063E7FF0000FF
      FF0000F7FF00B584840000000000000000000000000000000000000000000000
      0000000000009C6BB50063FF9C0063FF940063FF94005AF78C00945AA5000000
      0000000000000000000000000000000000000000000000000000F7D6AD0042DE
      730063FF940010941800FFCE9C00FFCE9C00FFCE9C00FFFFF700FFFFF700EFC6
      9400EF9C8C00000000000000000000000000000000000000000000000000E710
      FF0052B5FF00ADEFFF009CE7FF009CE7FF009CE7FF009CE7FF00ADEFFF004AAD
      FF00E710FF000000000000000000000000000000000000000000FFD6A500FFDE
      BD00FFDEB500FFDEB500FFD6AD00FFD6AD00FFD6A500FFD6A500FFFFFF005ACE
      D600DEC6C600C6B5D6002121AD00000000000000000000000000000000000000
      0000000000009C73BD0063FF9C0063FF9C0063FF9C0063FF94009C63AD000000
      0000000000000000000000000000000000000000000000000000F7D6AD0008A5
      080008A5080010941800FFF7E700FFF7E700FFF7E700FFFFF700F7CE9C00F7A5
      9400000000000000000000000000000000000000000000000000000000000000
      00008452FF007BC6FF00BDEFFF00B5EFFF00B5EFFF00BDEFFF0063BDFF008C4A
      FF00000000000000000000000000000000000000000000000000FFDEAD00FFEF
      DE00FFEFD600FFEFD600FFEFD600FFEFD600FFEFD600FFFFFF00F7CE9C000000
      0000E7D6D6000829E7004A6BFF00000000000000000000000000000000000000
      0000000000009C73BD0063FF940063FF9C0063FF9C0063FF94009C6BB5000000
      0000000000000000000000000000000000000000000000000000F7C69C00F7D6
      AD00F7DEB500F7DEB500F7D6AD00F7D6AD00F7D6AD00F7C68C00F7A59C000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000009C42FF00528CFF006BBDFF006BBDFF00528CFF00BD29FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000DEDEFF00526BFF00000000000000000000000000000000000000
      000000000000C64AD6004AEF840052F7840052F784004AEF7B00C642D6000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000008400C6C6C600848484008484
      8400848484008484840084848400848484008484840084848400848484008484
      840084848400000000000000000000000000000000000000000000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008484000084
      8400008484000084840000848400008484000084840000848400008484000084
      8400000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0084848400848484008484
      8400FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000009C949C00BDBDBD00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000084
      8400008484000084840000848400008484000084840000848400008484000084
      840000848400000000000000000000000000000000000000FF0000000000C6C6
      C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6C600000000000000FF000000
      8400C6C6C6000000000000000000000000000000000000000000000000000000
      000000000000000000009C9C9C009C9C9C000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00848484000000
      0000008484000084840000848400008484000084840000848400008484000084
      840000848400008484000000000000000000848484000000FF000000FF000000
      0000C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000FFFFFF000000
      FF00C6C6C6000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000ADA5A5006B6B6B0000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00848484000000
      0000008484000084840000848400008484000084840000848400008484000084
      840000848400008484000084840000000000000000000000FF000000FF000000
      FF00C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00C6C6C600C6C6
      C600C6C6C6000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000ADADAD006363630000000000636B
      6B000000000000000000000000000000000000000000FFFFFF0084848400FFFF
      FF00000000000000000000000000000000000084840000848400008484000084
      840000848400008484000084840000000000000000000000FF000000FF000000
      FF00C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600FFFF
      FF00FFFFFF00000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000008400000084
      0000C6C6C6000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000BDB5B500000000000000
      000000000000CEC6BD0000000000000000000000000000FFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000848484000000FF000000FF000000
      FF00C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600FFFF
      FF00000000000000FF000000FF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000000000FF00000084
      0000C6C6C6000000000000000000000000000000000000000000000000000000
      000000000000B5DEE700ADE7EF00ADF7F700525A630000000000000000000000
      00000000000000000000ADA59C000000000000000000FFFFFF0084848400FFFF
      FF00C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600C6C6C600FFFFFF00C6C6
      C60000000000000000000000000000000000000000000000FF000000FF000000
      FF00C6C6C600000000000000000000000000FFFFFF00FFFFFF00FFFFFF000000
      0000C6C6C600000000000000FF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF0000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000B5DEE700CEF7
      F700CEF7F700C6EFF700B5EFEF00ADEFF700ADB5A5009C9C8400B5CECE00FFF7
      EF00FFF7E700FFEFE700F7DEBD00000000000000000000FFFF0084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF00C6C6C600C6C6C600000000000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000FF0000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000ADF7F700C6F7F700CEF7F700CEF7
      F700CEF7F700CEF7F700ADEFF70094DEDE00B5B5A500B5C6AD00ADA58C00CED6
      C600EFEFDE00FFEFD600F7D6BD0000000000000000000000000084848400FFFF
      FF00C6C6C600C6C6C600C6C6C600C6C6C600FFFFFF00FFFFFF008484840000FF
      000000FF0000000000000000000000000000848484000000FF000000FF000000
      FF00C6C6C600C6C6C600000000000000000000000000C6C6C600FFFFFF00FFFF
      FF00FFFFFF00FFFFFF000000FF0000000000000000000000000000000000FFFF
      FF00C6C6C600C6C6C600FFFFFF0000FFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000ADF7F700ADF7F700BDF7F700B5E7
      EF009CD6DE0094DEDE00ADEFF700ADF7FF00848C8400B5BD9C00EFEFE700DED6
      C600DED6BD00C6C6AD00BDAD9C0000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00848484008484840000FF
      000000FF000000000000000000000000000000000000000000000000FF000000
      FF00000000000000000000000000FFFFFF000000000000000000FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00C6C6C600FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000000000000000000094DEE7007BC6CE0042849400528C
      9400528C940052949C006BA5AD0084B5BD0073A5A500B5AD9400EFEFDE00EFEF
      E700E7DED600CECEB50073949C0000000000000000000000000084848400FFFF
      FF00C6C6C600C6C6C600C6C6C600C6C6C6008484840000FF000000FF000000FF
      000000FF000000FF000000FF0000000000000000000000000000000000000000
      FF0000000000000000000000000000000000FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00C6C6
      C600C6C6C600C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00000000000000000000000000528C940018424A004A7B7B0084B5
      BD00ADD6D600A5CEDE005AB5C6000884AD00A5CEDE0073A5A5007B8C8C009C94
      8C007B8C8C005A6B6B008CD6DE0000000000000000000000000084848400FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008484840000FF000000FF000000FF
      000000FF000000FF000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000B5E7EF0084BD
      C600C6F7FF00B5F7FF008CEFF7005AD6EF0018BDE70021A5CE00B5CED60073AD
      B500ADEFF700B5FFFF005A8C8C00000000000000000000000000848484008484
      84008484840084848400848484008484840084848400848484008484840000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000FFFFFF00C6C6C6000000FF000000FF000000FF000000FF000000FF000000
      FF000000FF000000000000000000000000000000000000000000000000000000
      0000C6EFEF006BADC600DEEFEF00F7FFFF00D6FFFF009CFFFF005AFFFF006BC6
      D60084ADAD008CC6C600ADD6D600000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008484840000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000298C9C00108CA5002994AD00398CA500187B
      A500006B94005294A50000000000000000000000000000000000000000000000
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
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000084000000FFFF
      0000FF0000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000848484000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084000000FFFF0000FF00
      0000FF0000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000FF000000FF000000FF000000FF000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400C6C6C600C6C6C600C6C6C600C6C6C60084000000FFFF0000FF000000FF00
      0000C6C6C600C6C6C600000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848484000000000000000000000000000000000000000000000000000000
      000084848400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF0084000000FFFF0000FF000000FF000000C6C6
      C600FFFFFF00C6C6C600000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF000000FF00000000
      0000000000000000000000000000000000000000000084848400000000000000
      0000848484008484840000000000000000008484840084848400000000000000
      FF00000000008484840000000000000000000000000000000000000000000000
      0000848484008400000084000000840000008400000084000000840000000000
      0000000000000000000000000000000000000000000000000000000000008484
      8400000000000000000084848400C6C6C600FF000000FF000000C6C6C600FFFF
      FF00FFFFFF00C6C6C6000000000000000000000000000000000000FF000000FF
      000000FF000000FF0000000000000000000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000000084848400000000000000000000000000000000000000
      0000848484008484840084848400848484008484840084848400848484008484
      840000000000000000000000000000000000000000000000000084848400C6C6
      C600FFFF0000C6C6C600000000008484840084848400C6C6C600FFFFFF00FFFF
      FF00FFFFFF00C6C6C6000000000000000000000000000000000000FF000000FF
      000000FF000000000000000000000000000000FF000000000000000000000000
      0000000000000000000000000000000000000000840000000000000000000000
      00000000FF000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000848484000000000000000000000000000000
      0000000000000000000000000000848484000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      0000C6C6C600FFFF0000C6C6C60000000000C6C6C600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C6C6C60000000000000000000000000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000000000000000000000
      00000000FF000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000FF000000FF00000000000000000000000000000000008484
      8400848484008484840084848400848484008484840084848400848484008484
      8400000000000000000000000000000000000000000084848400FFFF0000FFFF
      FF00FFFF0000C6C6C600FFFF000000000000C6C6C600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C6C6C60000000000000000000000000000FF000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000000000000000000000
      00000000FF000000000000000000000000000000FF000000FF000000FF000000
      FF000000FF000000FF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000084848400FFFFFF00FFFF
      0000FFFFFF00FFFF0000C6C6C60000000000C6C6C600FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C6C6C6000000000000000000000000000000000000FF000000FF
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000840000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000000000008484840084848400848484008484
      8400848484008484840084848400000000008484840084848400848484008484
      840084848400848484008484840000000000000000000000000084848400FFFF
      FF00FFFF0000FFFFFF0000000000C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C6C6C6000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF0000000000000000000000000000000000C6C6C6008484840084848400FFFF
      FF008484840084848400848484000000000084848400FFFFFF00848484008484
      84008484840084848400FFFFFF00000000000000000000000000000000008484
      84008484840000000000C6C6C600FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C6C6C6000000000000000000000000000000000000FF000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C6008484840084848400FFFF
      FF008484840084848400848484000000000084848400FFFFFF00848484008484
      84008484840084848400FFFFFF00000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      00000000000000000000000000000000000000000000000000000000000000FF
      000000FF000000FF000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C6008484840084848400FFFF
      FF008484840084848400848484000000000084848400FFFFFF00848484008484
      84008484840084848400FFFFFF00000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600FFFFFF008484840000000000000000000000000000000000000000000000
      000000FF000000FF000000FF000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C60084848400848484008484
      8400848484008484840084848400000000008484840084848400848484008484
      8400848484008484840084848400000000000000000000000000000000008484
      8400FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C6C6
      C600848484000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF000000FF000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C6C6C600C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600848484000000000084848400C6C6C600C6C6C600C6C6
      C600C6C6C600C6C6C600C6C6C600000000000000000000000000000000008484
      8400848484008484840084848400848484008484840084848400848484008484
      840000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFF80010007FFFF01FF800100018001
      000F800100018001000080010001800100008001000380010000800100038001
      0000800100038001000080030003800100008003000380010000800300038001
      00008003000F800100008003000F800100008003000F800100008003000F8001
      00008003000F000100FFFFFFFFFFFFFFC003E007FFFFF81FC003C003C003F81F
      C003C003C003F81FC003C003C003F81FC003C003C003F81FC003C003C0030000
      C003C003C0030000C003E003C0030000C003E007C00300000003E007C0030000
      0003E007C00300000003E007C003F81FC003E007C003F81FC007E007C001F81F
      C00FF00FC011F81FC01FF81FFFF9F81FFFFFFFFFFFFFFFFF000F0007C003FFFF
      00070003C003F9FF00030003C003FCFF00010003C003FE7F00000003C003FF2F
      00000003C003FFBB00000001C003F87D00070000C003C00100030000C0030001
      80030000C0030001C0018007C0030001C000CF0FC0030001C000EFCFC003C001
      C001FFE7C003F001FFC3FFF3C003FE03FFBFFFFFF00FFFE7FF1FFFFFF00FFFC3
      FC0FFFDFF00FE001F003FFCFF00FE001E007FFC7F00FE001E01FB303F00FE001
      C33F2201F00FC001C37F2200FEFF800183FF2200E00F800183FF2201EFEF8001
      C1FF22030100C001C01FFFC70100E001C01FFFCF0100E001E01FFFDF0100E003
      F01FFFFF0100E007FE3FFFFF0100E00F00000000000000000000000000000000
      000000000000}
  end
  object popMSearch: TPopupMenu
    Left = 833
    Top = 88
    object popMSearch_byBeginingAs: TMenuItem
      Caption = #1048#1089#1082#1072#1090#1100' '#1085#1072#1095#1080#1085#1072#1102#1097#1080#1077#1089#1103' '#1089' ...'
      Checked = True
      SubMenuImages = ilCollBarMainForm
      OnClick = popMSearch_byBeginingAsClick
    end
    object popMSearch_byIncludingAs: TMenuItem
      Caption = #1048#1089#1082#1072#1090#1100' '#1087#1086' '#1074#1093#1086#1078#1076#1077#1085#1080#1102'...'
      OnClick = popMSearch_byIncludingAsClick
    end
  end
  object ilObjectExplorer: TImageList
    Left = 96
    Top = 32
    Bitmap = {
      494C01010D000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
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
      00000000000017811EFF11AA19FF429345FF0000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000018982AFF26BF38FF20B930FF399741FFC1DEC3FF00000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000030C1
      50FF3ED75DFF37D053FF31CA4AFF2BC440FF25BE37FF1FB82FFF13991EFFEFF6
      F0FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000005EF7
      8DFF52EB7BFF4BE470FF44DD66FF3DD65CFF37D052FF30C948FF2AC33FFF24BD
      36FFC3E1C6FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000086EC
      A5FF66FF99FF60F990FF58F185FF4AE177FF4CE178FF61FA92FF3CD55AFF36CF
      51FF2DC344FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000EFF7
      F0FFDAFAE4FF66FF99FF66FF99FF6BE490FF000000000000000095DFA7FF60F9
      90FF42DB63FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001493
      24FF000000000000000057F68BFF7BED9FFF0000000000000000000000000000
      00005AF387FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001CB5
      2AFF70C37FFF0000000000000000000000004AA353FF11AA19FF37933DFF0000
      000056E884FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000002CC5
      42FF29C23EFF23B03DFFB8E3C0FF0000000051B160FF1FB82EFF1DB62BFF1D8C
      28FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000044DF
      72FF3BD458FF38D154FF36CF51FF34CD4DFF31CA4AFF2FC846FF2DC643FF2AC3
      3FFF179628FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000054F287FF4BE470FF48E16CFF46DF68FF43DC65FF41DA61FF3ED75DFF3CD5
      59FF39D256FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000006FEC96FF57F68BFF66FF99FF66FF99FF54ED7EFF51EA7AFF53EC
      7CFF50C56CFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006FEC96FF66FF99FF65FE98FF82E6
      9FFF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006FEC96FF64FD97FFDAFAE4FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000AFE1F4FF009DE3FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000E9FFFF00DDFFFF00A3
      E8FFFFFDFBFFFFFCFAFFFFFBF8FFFFFBF6FFFFFAF4FFFFF9F2FFFFF8F1FFFFF7
      EFFFFFF6EDFFDA9651FF00000000000000000000000000000000000000000000
      00000000000017811EFF11AA19FF429345FF0000000000000000000000000000
      0000000000000000000000000000000000000000000070CFF0FF00CAFFFF00BB
      FFFF7FCCEBFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFE7E7FFE9D5
      D5FFF1E0E0FFAE8282FF00000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000AFEBFBFF00EFFFFF00E2
      FFFF20B0E3FFFFF7EFFFFFF5EBFFFFF3E8FFFFF2E4FFFFF0E1FFFFEEDDFFFFEC
      DAFFFFEAD6FFDC9A56FF00000000000000000000000000000000000000000000
      000018982AFF26BF38FF20B930FF399741FFC1DEC3FF00000000000000000000
      0000000000000000000000000000000000000000000010BCF0FF00EAFFFF00DF
      FFFF00B0FDFF0000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CCB1
      B1FFF4E1E1FFEDD4D4FFAE8282FF000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000056BDC5FF00F4
      FFFF00E2FFFFCFE7E9FFFFF2E6FFFFF1E2FFFFEFDFFFFFEDDBFFFFEBD8FFFFE9
      D4FFFFE8D0FFDE9E5BFF000000000000000000000000000000000000000030C1
      50FF3ED75DFF37D053FF31CA4AFF2BC440FF25BE37FF1FB82FFF13991EFFEFF6
      F0FF00000000000000000000000000000000000000000000000000BEF3FF00ED
      FFFF00E2FFFF00ABE8FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000CCB1B1FFEDD4D4FFEDD4D4FF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E7B073FF10D1
      FEFFCEB0B0FFB28888FFC39393FFBB8C8CFFD6B7ADFFFFEAD6FFFFE8D2FFFFE7
      CEFFFFE5CBFFE0A261FF00000000000000000000000000000000000000005EF7
      8DFF52EB7BFF4BE470FF44DD66FF3DD65CFF37D052FF30C948FF2AC33FFF24BD
      36FFC3E1C6FF00000000000000000000000000000000000000000000000000CF
      F9FF00F1FFFF00E6FFFF20B8EAFF000000000000000000000000000000000000
      00000000000000000000000000000000000000000000E1CACAFF000000000000
      0000B89191FFEDD5D5FFE8CCCCFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000E9B479FFFFF2
      E5FFC5A2A2FFE4C4C4FFE1BEBEFFEEDCDCFFCF9F9FFFB88C8CFFFFE6CCFFFFE4
      C9FFFFE2C5FFE2A666FF000000000000000000000000000000000000000086EC
      A5FF66FF99FF60F990FF58F185FF4AE177FF4CE178FF61FA92FF3CD55AFF36CF
      51FF2DC344FF0000000000000000000000000000000000000000000000000000
      000000EBFEFF95EBECFFBA9292FFDBC8C8FFC2A1A1FFD6C0C0FF000000000000
      00000000000000000000000000000000000000000000FFF5F5FFD6B6B6FFF5F0
      F0FFF5E3E3FFEDD6D6FFE9CECEFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EBB87EFFE5CE
      C6FFDBB4B4FFFFB032FFFFB339FFFFB43AFFE3C3C3FFD5A8A8FFBA9393FFFFE1
      C3FFFFDFC0FFE4AB6CFF0000000000000000000000000000000000000000EFF7
      F0FFDAFAE4FF66FF99FF66FF99FF6BE490FF000000000000000095DFA7FF60F9
      90FF42DB63FF0000000000000000000000000000000000000000000000000000
      0000EFFBFFFFD6BEBEFFB78F8FFFDBB4B4FFD1A3A3FFCD9B9BFFCA9898FFC3A2
      A2FF0000000000000000000000000000000000000000E0CACAFFFFF5F5FFFCF0
      F0FFF5E3E3FFEED6D6FFE7C9C9FF2925A3FF0615BCFF00000000000000000000
      0000000000000000000000000000000000000000000000000000EDBD84FFE5CE
      C5FFCC9999FFFFC157FFFFC45EFFFFC55FFFFFC35BFFF2E3E3FFDAB2B2FFFFDE
      BEFFFFDDBAFFE6AF71FF00000000000000000000000000000000000000001493
      24FF000000000000000057F68BFF7BED9FFF0000000000000000000000000000
      00005AF387FF0000000000000000000000000000000000000000000000000000
      000000000000D6B6B6FFE7C4BBFFF8AC43FFEBB88DFFDFBBBBFFD6ABABFFCF9F
      9FFFB89292FF0000000000000000000000000000000000000000E4D0D0FFFDF1
      F1FFF5E4E4FFDBBFBFFF7C72C1FF0018C9FF0027E7FF022DF0FFE0E1F5FF0000
      0000000000000000000000000000000000000000000000000000EFC189FFFFEA
      D5FFDCB6B6FFFFBF5DFFFFD37FFFFFD480FFFFD27CFFF7D09DFFE2C0C0FFE7C6
      B2FFFFDAB4FFE8B377FF00000000000000000000000000000000000000001CB5
      2AFF70C37FFF0000000000000000000000004AA353FF11AA19FF37933DFF0000
      000056E884FF0000000000000000000000000000000000000000000000000000
      0000DDCBCBFFE9CDCDFFFFAF30FFFFB237FFFFB43BFFFFB43BFFE2C1C1FFE5CA
      CAFFD4A7A7FFE0CFCFFF00000000000000000000000000000000000000000000
      000000000000000000000A31ECFF6A77DEFF5C6BDCFF0220D5FF0535FBFFA5A9
      E5FF000000000000000000000000000000000000000000000000F1C58EFFFFE7
      CFFFE3D0D0FFCF9B95FFFFCA73FFFFE29EFFFFDF99FFFFDA8DFFF4E6E6FFF3D1
      B4FFFFD7AFFFEAB77CFF00000000000000000000000000000000000000002CC5
      42FF29C23EFF23B03DFFB8E3C0FF0000000051B160FF1FB82EFF1DB62BFF1D8C
      28FF000000000000000000000000000000000000000000000000000000000000
      0000D8C2C2FFCC9999FFFFBC4DFFFFC054FFFFC258FFFFC259FFFFC055FFE5C7
      C7FFDAB2B2FFCCA6A6FF00000000000000000000000000000000000000000000
      000000000000000000001A36E1FF475BDEFF384FDDFF2A43DDFF0525DBFF1243
      FFFF6E77DAFF0000000000000000000000000000000000000000F3C993FFFFE4
      C9FFFFE2C6FFF1E4E4FFD1A2A2FFFFBE5CFFFFD68AFFFDE4C9FFE0CDCDFFFFD6
      ADFFFFD4A9FFECBB81FF000000000000000000000000000000000000000044DF
      72FF3BD458FF38D154FF36CF51FF34CD4DFF31CA4AFF2FC846FF2DC643FF2AC3
      3FFF179628FF0000000000000000000000000000000000000000000000000000
      0000EDE3E3FFDBB4B4FFFFB34AFFFFCC6FFFFFCE74FFFFCF74FFFFCD70FFFFC9
      69FFFCF9F9FFDEBABAFF00000000000000000000000000000000000000000000
      00000000000000000000000000003253EFFF1535E1FF072AE1FF0025E3FF0026
      E5FF2A58FFFF5562DAFF00000000000000000000000000000000F5CD99FFFFE1
      C4FFFFE0C0FFFFDEBCFFE7D3CFFFFAF2F2FFFFF8F8FFE5D5D5FFFFD5ABFFFFD3
      A7FFFFEEDDFFF0C796FF00000000000000000000000000000000000000000000
      000054F287FF4BE470FF48E16CFF46DF68FF43DC65FF41DA61FF3ED75DFF3CD5
      59FF39D256FF0000000000000000000000000000000000000000000000000000
      000000000000FAEFEFFFD69E8BFFFFCE78FFFFDA8CFFFFDA8DFFFFD889FFFFD4
      81FFEFD8D8FFE4C4C4FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000004C6AF3FF0029EBFF002AEDFF002B
      EFFF002CF2FF3A66FFFF4C5BDFFF000000000000000000000000F7D19EFFFFDF
      BEFFFFDDBAFFFFDBB7FFFFD9B3FFFFD8B0FFFFD6ACFFFFD4A9FFFFFFFFFFFFFF
      FFFFF1C58EFF0000000000000000000000000000000000000000000000000000
      0000000000006FEC96FF57F68BFF66FF99FF66FF99FF54ED7EFF51EA7AFF53EC
      7CFF50C56CFF0000000000000000000000000000000000000000000000000000
      000000000000ECE1E1FFE9CDCDFFF5B566FFFFCE7BFFFFE4A3FFFFE29FFFFFDE
      97FFF5E2E2FFEACFCFFF00000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007892FBFF002FF8FF0031
      FAFF0032FCFF2F58FEFF2C56F8FF000000000000000000000000F9D5A3FFFFDC
      B8FFFFDAB5FFFFD8B1FFFFD6AEFFFFD5AAFFFFD3A7FFFFD1A3FFFFFFFFFFF4CA
      95FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006FEC96FF66FF99FF65FE98FF82E6
      9FFF000000000000000000000000000000000000000000000000000000000000
      00000000000000000000E4D4D4FFEBD0D0FFE0AB8DFFFFBE5CFFFFD385FFFFD5
      89FFFCF4F4FFDDC8C8FF00000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F2F4FEFF94A9FEFF0033
      FFFF0033FFFFD3DDFFFF314EF2FF000000000000000000000000FBD9A8FFFFEC
      D9FFFFEBD7FFFFEAD6FFFFEAD4FFFFE9D2FFFFE8D0FFFFFCF9FFF6CF9CFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000006FEC96FF64FD97FFDAFAE4FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000EFE5E5FFF8EFEFFFF1DCDCFFF4E0E0FFFFF8
      F8FFE7D9D9FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F2F4FFFFB1C1
      FFFFE2E9FFFF3F69FFFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      000000000000000000000000FFFFFF00FFFF000000000000F8FF000000000000
      F07F000000000000E00F000000000000E007000000000000E007000000000000
      E0C7000000000000ECF7000000000000E717000000000000E10F000000000000
      E007000000000000F007000000000000F807000000000000FF0F000000000000
      FF1F000000000000FFFF0000000000009FFFFFFFFFFFFFFF8003F8FF87FFC3FF
      8003F07F87FFE1FFC003E00FC3FFF1FFC003E007E1FFB1FFC003E007F03F81FF
      C003E0C7F00F807FC003ECF7F807C01FC003E717F003FC0FC003E10FF003FC07
      C003E007F003FE03C003F007F803FF01C007F807F803FF81C00FFF0FFC03FF81
      C01FFF1FFE07FFC3FFFFFFFFFFFFFFFFFFFF81FFFFFFFBFFF83FC1FF0001F1FF
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
  object popMOrderPositionOperations: TPopupMenu
    Left = 822
    Top = 318
  end
  object popMDocumentOperation: TPopupMenu
    Left = 697
    Top = 80
    object N13: TMenuItem
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1085#1086#1074#1091#1102' '#1082#1072#1088#1090#1091
      ImageIndex = 5
    end
    object N14: TMenuItem
      Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1082#1072#1088#1090#1091
      ImageIndex = 6
    end
    object N15: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1090#1077#1082#1091#1097#1091#1102' '#1082#1072#1088#1090#1091
      ImageIndex = 7
    end
  end
  object ilOrderOperations: TImageList
    Left = 729
    Top = 80
    Bitmap = {
      494C01010C000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
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
      0000848CD6000818CE000031FF000031FF000031FF000031FF000018C6008484
      D600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084BD8C00088C100008A5100008A5100008A5100008A510000084080084B5
      8400000000000000000000000000000000000000000070CFF0FF00CAFFFF00BB
      FFFF7FCCEBFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000001018
      B5001042FF000839FF000039FF000031FF000031FF000031FF000031FF000031
      FF000808AD000000000000000000000000000000000000000000000000000000
      000000000000217B2100006B0000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000108C
      180010AD180010AD180010AD180010AD180008AD100008AD100008A5100008A5
      1000007308000000000000000000000000000000000010BCF0FF00EAFFFF00DF
      FFFF00B0FDFF0000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001021BD002152
      FF00184AFF00104AFF001042FF000839FF000039FF000031FF000031FF000031
      FF000031FF000810AD0000000000000000000000000000000000000000000000
      0000087B100010AD180008AD1000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001094210010B5
      210010AD210010AD210010AD210010AD180010AD180010AD180010AD180010AD
      180010AD1800007308000000000000000000000000000000000000BEF3FF00ED
      FFFF00E2FFFF00ABE8FF00000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000008C94E700527BFF00527B
      FF00396BFF005A7BFF00184AFF00104AFF001042FF000839FF00426BFF000031
      FF000031FF000031FF00848CDE0000000000000000000000000000000000108C
      210021BD310018B5290018B52100000000000000000000000000000000000000
      000000000000000000000000000000000000000000008CCE940039C64A004AC6
      520031BD420018B5290018B5210018B5210018B5210018B5210018B5210010B5
      210010AD210010AD210084BD84000000000000000000000000000000000000CF
      F9FF00F1FFFF00E6FFFF20B8EAFF000000000000000000000000000000000000
      000000000000000000000000000000000000000000004A63E7007B9CFF007394
      FF0094ADFF00FFFFFF00FFFFFF002152FF00184AFF00FFFFFF00FFFFFF00426B
      FF000031FF000031FF000821D60000000000000000000000000021B5420031CE
      4A0029C6420029C6390021BD390021BD310018AD2100088C1800218C29000000
      000000000000000000000000000000000000000000004AC663006BD6730063CE
      6B005ACE6B005ACE6300D6F7DE00FFFFFF004AC6520018B5290018B5290018B5
      290018B5290018B5290010941800000000000000000000000000000000000000
      000000EBFEFF95EBECFFBA9292FFDBC8C8FFC2A1A1FFD6C0C0FF000000000000
      00000000000000000000000000000000000000000000ADC6FF008CA5FF00849C
      FF007B9CFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF001042
      FF000842FF000839FF000031FF00000000000000000039D6630042DE6B0042DE
      630039D65A0031D6520031CE4A0029C6420029C6390021BD310021BD310018B5
      290039944200000000000000000000000000000000009CFFBD0073D684006BD6
      7B006BD67300E7F7E700FFFFFF00FFFFFF00FFFFFF004ACE5A0021BD310021BD
      310021BD310021BD310018BD2900000000000000000000000000000000000000
      0000EFFBFFFFD6BEBEFFB78F8FFFDBB4B4FFD1A3A3FFCD9B9BFFCA9898FFC3A2
      A2FF0000000000000000000000000000000000000000A5C6FF0094ADFF008CAD
      FF0084A5FF007B9CFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF002152FF001852
      FF00184AFF001042FF000842FF00000000000000000063FF9C0052EF7B0052EF
      73004AE76B0042DE6B0042DE630039D65A0031CE520031CE4A0029C6420029C6
      390021BD3100188C29000000000000000000000000009CF7B5007BDE8C007BDE
      8C00E7FFEF00FFFFFF00FFFFFF009CE7A500FFFFFF00FFFFFF0052CE630021C6
      390021BD390021BD390021BD3100000000000000000000000000000000000000
      000000000000D6B6B6FFE7C4BBFFF8AC43FFEBB88DFFDFBBBBFFD6ABABFFCF9F
      9FFFB89292FF00000000000000000000000000000000B5CEFF0094B5FF0094AD
      FF008CADFF008CADFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00295AFF00295A
      FF002152FF00184AFF00184AFF0000000000000000005AE7840063FF9C005AFF
      8C005AF7840052EF7B0063FF940063FF9C005AF78C004AE76B0039D6520031CE
      520031CE4A0029C64200C6E7CE000000000000000000ADFFC6008CE79C0084E7
      9400FFFFFF00FFFFFF0073DE840073DE8400B5EFBD00FFFFFF00FFFFFF0052D6
      630029C6420029C6420029C64200000000000000000000000000000000000000
      0000DDCBCBFFE9CDCDFFFFAF30FFFFB237FFFFB43BFFFFB43BFFE2C1C1FFE5CA
      CAFFD4A7A7FFE0CFCFFF000000000000000000000000B5CEFF009CB5FF009CB5
      FF0094B5FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF003163
      FF00295AFF00295AFF003163FF000000000000000000000000009CF7BD0063FF
      9C0063FF9C0063FF940063FF940000000000D6F7DE006BD6840031C6520063FF
      940039D65A0039D6520021A539000000000000000000ADFFCE0094E7A5008CE7
      9C00F7FFF70084E7940084E794007BE78C005ADE73008CE79C00FFFFFF00FFFF
      FF005AD66B0031CE4A0039D65200000000000000000000000000000000000000
      0000D8C2C2FFCC9999FFFFBC4DFFFFC054FFFFC258FFFFC259FFFFC055FFE5C7
      C7FFDAB2B2FFCCA6A6FF0000000000000000000000005A7BF700A5BDFF009CBD
      FF00B5C6FF00FFFFFF00FFFFFF0094ADFF008CADFF00FFFFFF00FFFFFF006B94
      FF003963FF003163FF004263EF0000000000000000000000000000000000DEFF
      E7005AFF940063FF9C0063FF9C0000000000000000000000000000000000D6F7
      DE0052EF7B004AE76B0039D65A00000000000000000052DE7B009CEFAD009CEF
      AD0094EFA50094EFA5008CE79C0084E79C0084E7940039D65A0084E79400FFFF
      FF00FFFFFF0031D6520031BD5200000000000000000000000000000000000000
      0000EDE3E3FFDBB4B4FFFFB34AFFFFCC6FFFFFCE74FFFFCF74FFFFCD70FFFFC9
      69FFFCF9F9FFDEBABAFF0000000000000000000000009CA5FF00BDD6FF00A5BD
      FF00A5BDFF00B5CEFF009CB5FF0094B5FF0094ADFF008CADFF0094B5FF004A73
      FF004273FF004A7BFF00949CF700000000000000000000000000000000000000
      0000000000004AEF840063FF9C00000000000000000000000000000000000000
      00000000000052F784004AE77300000000000000000094E7AD00B5FFCE00A5EF
      B5009CEFB5009CEFAD0094EFAD0094EFA5008CEFA5008CEF9C005ADE7B0039DE
      5A0039D65A004AE76B008CCE9C00000000000000000000000000000000000000
      000000000000FAEFEFFFD69E8BFFFFCE78FFFFDA8CFFFFDA8DFFFFD889FFFFD4
      81FFEFD8D8FFE4C4C4FF000000000000000000000000000000003152FF00BDD6
      FF00ADBDFF00A5BDFF00A5BDFF009CB5FF009CB5FF0094B5FF0094ADFF008CAD
      FF0094ADFF00294AEF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B5F7CE0039DE6B0000000000000000000000000031CE5A00BDFF
      D600ADF7BD00A5F7B5009CF7B5009CEFAD0094EFAD0094EFAD008CEFA5008CEF
      A5008CEFA50021AD390000000000000000000000000000000000000000000000
      000000000000ECE1E1FFE9CDCDFFF5B566FFFFCE7BFFFFE4A3FFFFE29FFFFFDE
      97FFF5E2E2FFEACFCFFF0000000000000000000000000000000000000000395A
      FF00C6D6FF00B5CEFF00A5BDFF00A5BDFF009CBDFF009CB5FF009CB5FF00ADCE
      FF003152F7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000CEFFDE000000000000000000000000000000000031D6
      6300BDFFD600B5FFC600ADF7BD00A5F7BD00A5F7B5009CF7B5009CF7AD00A5FF
      C60021B542000000000000000000000000000000000000000000000000000000
      00000000000000000000E4D4D4FFEBD0D0FFE0AB8DFFFFBE5CFFFFD385FFFFD5
      89FFFCF4F4FFDDC8C8FF00000000000000000000000000000000000000000000
      00009CADFF006B84FF00BDD6FF00BDD6FF00BDD6FF00B5CEFF006384FF009CAD
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009CEFB5006BE78C00BDFFD600B5FFCE00B5FFCE00ADFFCE005ADE7B0094DE
      A500000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000EFE5E5FFF8EFEFFFF1DCDCFFF4E0E0FFFFF8
      F8FFE7D9D9FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      00000000000000000000000000000000FFFFFFFFFFFFFFFFF00FFFFFF00F87FF
      E007F9FFE00787FFC003F1FFC003C3FF8001E1FF8001E1FF8001C01F8001F03F
      800180078001F00F800180038001F807800180018001F0038001C1018001F003
      8001E1E18001F0038001F9F98001F803C003FFF9C003F803E007FFFDE007FC03
      F00FFFFFF00FFE07FFFFFFFFFFFFFFFFFFFFC003FFFFFFFFFFFFC003C003F81F
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
  object ilOrderItemOperations: TImageList
    Left = 857
    Top = 320
    Bitmap = {
      494C01010E001300040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D3D3D300D2D2D200D2D2
      D200D2D2D200D2D2D200D2D2D200D2D2D200D2D2D200D2D2D200D2D2D200D2D2
      D200D2D2D200D2D2D200D2D2D200C4C4C4000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D2D2D200F0F0F000E5E5E500E5E5
      E500E4E4E300E2E3E100E2E3E100E1E2E000E0E1DF00DEDFDD00DEDFDD00DDDE
      DC00DDDCDB00DDDAD900E5E3E2004D4D4B000000000070CFF0FF00CAFFFF00BB
      FFFF7FCCEBFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D1D1D100FDFDFD00F1F1F100F1F1
      F100F0F0EF00EFF0EE00EEEFED00EDEEEC00ECEDEB00EAEBEA00EAEBE900E9EA
      E800E7E9E700E9E7E600F2F0EF004A4A4A000000000010BCF0FF00EAFFFF00DF
      FFFF00B0FDFF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D1D1D100FFFFFF00F3F3F300F3F3
      F300F2F2F200F1F2F000F0F1EF00EFF0EE00EEEFED00EDEEEC00ECEDEB00EBEC
      EA00EAEBE900E9EAE800F3F3F1004A4A4A00000000000000000000BEF3FF00ED
      FFFF00E2FFFF00ABE8FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D1D1D100FFFFFF00F6F6F600F4F4
      F400F3F3F300F2F3F200F1F1F100F1F1F000F4F2F300EAEAE700F0F1F000ECED
      EB00ECEDEB00EAEBE900F4F5F3004949490000000000000000000000000000CF
      F9FF00F1FFFF00E6FFFF20B8EAFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D1D1D100FFFFFF00F6F6F600F6F6
      F600F5F5F500F4F4F400F2F3F200F0ECE500BB9C7400C1A17500B4997200E3E1
      DF00EEEDEC00ECEDEB00F6F7F500494949000000000000000000000000000000
      000000EBFEFF95EBECFFBA9292FFDBC8C8FFC2A1A1FFD6C0C0FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D1D1D100FFFFFF00F8F8F800F7F7
      F700F6F6F600F5F5F500F6F8F600C6AA8500EAE2D700F2F3F400EDE2D000B59F
      7F00F3F3F100EEEFEC00F8F9F7004A4A4A000000000000000000000000000000
      0000EFFBFFFFD6BEBEFFB78F8FFFDBB4B4FFD1A3A3FFCD9B9BFFCA9898FFC3A2
      A2FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D1D1D100FFFFFF00F9F9F900F8F8
      F800F8F8F800F7F7F700F8FAF900C3A57E00F3F2F100E1DBD700F8F5F200B99D
      7600F4F4F400F0F1F000FAFBFA00494949000000000000000000000000000000
      000000000000D6B6B6FFE7C4BBFFF8AC43FFEBB88DFFDFBBBBFFD6ABABFFCF9F
      9FFFB89292FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D1D1D100FFFFFF00FAFAFA00FDFD
      FD00F9F9F900F8F8F800FAFBFA00C5A98500F9F7F700BD9E7800FAF9F500BA9F
      7A00F6F6F700F1F2F000FCFBFC00494949000000000000000000000000000000
      0000DDCBCBFFE9CDCDFFFFAF30FFFFB237FFFFB43BFFFFB43BFFE2C1C1FFE5CA
      CAFFD4A7A7FFE0CFCFFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D1D1D100FFFFFF00FFFFFF00FFFF
      FF00FAFAFA00F9F9F900FCFDFC00C9AB8800F9F8F800C1A17E00FBFBF800BDA2
      7F00F7F7F800F3F3F300FEFDFE00494949000000000000000000000000000000
      0000D8C2C2FFCC9999FFFFBC4DFFFFC054FFFFC258FFFFC259FFFFC055FFE5C7
      C7FFDAB2B2FFCCA6A6FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D1D1D100FFFFFF00FFFFFF00FEFE
      FE00FBFBFB00FBFBFB00FDFEFD00CBB09000F9F8F800C2A58200FDFAF700BCA4
      8300F9F9FA00F4F4F400FEFFFF004A4A4A000000000000000000000000000000
      0000EDE3E3FFDBB4B4FFFFB34AFFFFCC6FFFFFCE74FFFFCF74FFFFCD70FFFFC9
      69FFFCF9F9FFDEBABAFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D1D1D100FFFFFF00FFFFFF00FFFF
      FF00FCFCFC00FCFCFC00FEFEFF00CDB59600FAFBFA00C6AA8A00F2EEE900C0A8
      8A00F9FAFA00F5F6F600FFFFFF00494949000000000000000000000000000000
      000000000000FAEFEFFFD69E8BFFFFCE78FFFFDA8CFFFFDA8DFFFFD889FFFFD4
      81FFEFD8D8FFE4C4C4FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000D0D0D000FFFFFF00FDFDFD00FDFD
      FD00FBFBFB00FBFBFB00FCFEFD00D1B99E00F4F4F400E4D5C400CCB29300E5E0
      D500F9FAFA00F5F5F500FFFFFF00494949000000000000000000000000000000
      000000000000ECE1E1FFE9CDCDFFF5B566FFFFCE7BFFFFE4A3FFFFE29FFFFFDE
      97FFF5E2E2FFEACFCFFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C9C9C9009E9E9E00989898009898
      9800989898009898980098989900CEBBA40084807B009293920095969700908B
      8700B4A99900989898009B9B9B003A3A3A000000000000000000000000000000
      00000000000000000000E4D4D4FFEBD0D0FFE0AB8DFFFFBE5CFFFFD385FFFFD5
      89FFFCF4F4FFDDC8C8FF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C0C0C00000000000000000000000
      00000000000000000000010101003F3A3400EBD2BB007A7166007A716500E5CB
      AC0056504B000000000000000000101010000000000000000000000000000000
      0000000000000000000000000000EFE5E5FFF8EFEFFFF1DCDCFFF4E0E0FFFFF8
      F8FFE7D9D9FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C3C3C300101010000F0F0F000F0F
      0F000F0F0F000F0F0F000F0F0F0010101000312C290095897B00938878003A38
      36000D0D0D000F0F0F0010100F001C1C1C000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000848CD6000818CE000031FF000031FF000031FF000031FF000018C6008484
      D600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000084BD8C00088C100008A5100008A5100008A5100008A510000084080084B5
      8400000000000000000000000000000000000000000000000000E1A463FFFFFE
      FDFFFFFDFBFFFFFCFAFFFFFBF8FFFFFBF6FFFFFAF4FFFFF9F2FFFFF8F1FFFFF7
      EFFFFFF6EDFFDA9651FF00000000000000000000000000000000000000001018
      B5001042FF000839FF000039FF000031FF000031FF000031FF000031FF000031
      FF000808AD000000000000000000000000000000000000000000000000000000
      000000000000217B2100006B0000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000108C
      180010AD180010AD180010AD180010AD180008AD100008AD100008A5100008A5
      1000007308000000000000000000000000000000000000000000E3A868FFFFFB
      F6FFFFF9F3FFFFF7EFFFFFF5EBFFFFF3E8FFFFF2E4FFFFF0E1FFFFEEDDFFFFEC
      DAFFFFEAD6FFDC9A56FF000000000000000000000000000000001021BD002152
      FF00184AFF00104AFF001042FF000839FF000039FF000031FF000031FF000031
      FF000031FF000810AD0000000000000000000000000000000000000000000000
      0000087B100010AD180008AD1000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000001094210010B5
      210010AD210010AD210010AD210010AD180010AD180010AD180010AD180010AD
      180010AD18000073080000000000000000000000000000000000E5AC6EFFFFF8
      F0FFFFF6EDFFFFF4E9FFFFF2E6FFFFF1E2FFFFEFDFFFFFEDDBFFFFEBD8FFFFE9
      D4FFFFE8D0FFDE9E5BFF0000000000000000000000008C94E700527BFF00527B
      FF00396BFF005A7BFF00184AFF00104AFF001042FF000839FF00426BFF000031
      FF000031FF000031FF00848CDE0000000000000000000000000000000000108C
      210021BD310018B5290018B52100000000000000000000000000000000000000
      000000000000000000000000000000000000000000008CCE940039C64A004AC6
      520031BD420018B5290018B5210018B5210018B5210018B5210018B5210010B5
      210010AD210010AD210084BD8400000000000000000000000000E7B073FFFFF5
      EBFFFFF3E7FFFFF1E4FFFFF0E0FFFFEEDDFFFFECD9FFFFEAD6FFFFE8D2FFFFE7
      CEFFFFE5CBFFE0A261FF0000000000000000000000004A63E7007B9CFF007394
      FF0094ADFF00FFFFFF00FFFFFF002152FF00184AFF00FFFFFF00FFFFFF00426B
      FF000031FF000031FF000821D60000000000000000000000000021B5420031CE
      4A0029C6420029C6390021BD390021BD310018AD2100088C1800218C29000000
      000000000000000000000000000000000000000000004AC663006BD6730063CE
      6B005ACE6B005ACE6300D6F7DE00FFFFFF004AC6520018B5290018B5290018B5
      290018B5290018B5290010941800000000000000000000000000E9B479FFFFF2
      E5FFFFF0E2FFFFEFDEFFFFEDDBFFFFEBD7FFFFE9D4FFFFE7D0FFFFE6CCFFFFE4
      C9FFFFE2C5FFE2A666FF000000000000000000000000ADC6FF008CA5FF00849C
      FF007B9CFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF001042
      FF000842FF000839FF000031FF00000000000000000039D6630042DE6B0042DE
      630039D65A0031D6520031CE4A0029C6420029C6390021BD310021BD310018B5
      290039944200000000000000000000000000000000009CFFBD0073D684006BD6
      7B006BD67300E7F7E700FFFFFF00FFFFFF00FFFFFF004ACE5A0021BD310021BD
      310021BD310021BD310018BD2900000000000000000000000000EBB87EFFFFEF
      E0FFFFEEDCFFFFECD9FFFFEAD5FFFFE8D2FFFFE6CEFFFFE5CAFFFFE3C7FFFFE1
      C3FFFFDFC0FFE4AB6CFF000000000000000000000000A5C6FF0094ADFF008CAD
      FF0084A5FF007B9CFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF002152FF001852
      FF00184AFF001042FF000842FF00000000000000000063FF9C0052EF7B0052EF
      73004AE76B0042DE6B0042DE630039D65A0031CE520031CE4A0029C6420029C6
      390021BD3100188C29000000000000000000000000009CF7B5007BDE8C007BDE
      8C00E7FFEF00FFFFFF00FFFFFF009CE7A500FFFFFF00FFFFFF0052CE630021C6
      390021BD390021BD390021BD3100000000000000000000000000EDBD84FFF0E6
      CDFF06790BFFFFE9D3FFFFE7CFFFFFE5CCFFFFE4C8FFFFE2C5FFFFE0C1FFFFDE
      BEFFFFDDBAFFE6AF71FF000000000000000000000000B5CEFF0094B5FF0094AD
      FF008CADFF008CADFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00295AFF00295A
      FF002152FF00184AFF00184AFF0000000000000000005AE7840063FF9C005AFF
      8C005AF7840052EF7B0063FF940063FF9C005AF78C004AE76B0039D6520031CE
      520031CE4A0029C64200C6E7CE000000000000000000ADFFC6008CE79C0084E7
      9400FFFFFF00FFFFFF0073DE840073DE8400B5EFBD00FFFFFF00FFFFFF0052D6
      630029C6420029C6420029C64200000000000000000000000000E1BE83FF1DB6
      2CFF16AF22FF0E9715FFFFE5CAFFFFE3C6FFFFE1C3FFFFDFBFFFFFDDBCFFFFDC
      B8FFFFDAB4FFE8B377FF000000000000000000000000B5CEFF009CB5FF009CB5
      FF0094B5FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF003163
      FF00295AFF00295AFF003163FF000000000000000000000000009CF7BD0063FF
      9C0063FF9C0063FF940063FF940000000000D6F7DE006BD6840031C6520063FF
      940039D65A0039D6520021A539000000000000000000ADFFCE0094E7A5008CE7
      9C00F7FFF70084E7940084E794007BE78C005ADE73008CE79C00FFFFFF00FFFF
      FF005AD66B0031CE4A0039D652000000000000000000F1F9F2FF36CF51FF2EC7
      45FF20B032FF1FB82EFF149F1FFFFFE0C1FFFFDEBDFFFFDCBAFFFFDBB6FFFFD9
      B2FFFFD7AFFFEAB77CFF0000000000000000000000005A7BF700A5BDFF009CBD
      FF00B5C6FF00FFFFFF00FFFFFF0094ADFF008CADFF00FFFFFF00FFFFFF006B94
      FF003963FF003163FF004263EF0000000000000000000000000000000000DEFF
      E7005AFF940063FF9C0063FF9C0000000000000000000000000000000000D6F7
      DE0052EF7B004AE76B0039D65A00000000000000000052DE7B009CEFAD009CEF
      AD0094EFA50094EFA5008CE79C0084E79C0084E7940039D65A0084E79400FFFF
      FF00FFFFFF0031D6520031BD5200000000000000000052EB7AFF49E26DFF22AB
      3DFFFFE2C6FF26B63CFF27C03BFF1AA729FFFFDBB7FFFFDAB4FFFFD8B1FFFFD6
      ADFFFFD4A9FFECBB81FF0000000000000000000000009CA5FF00BDD6FF00A5BD
      FF00A5BDFF00B5CEFF009CB5FF0094B5FF0094ADFF008CADFF0094B5FF004A73
      FF004273FF004A7BFF00949CF700000000000000000000000000000000000000
      0000000000004AEF840063FF9C00000000000000000000000000000000000000
      00000000000052F784004AE77300000000000000000094E7AD00B5FFCE00A5EF
      B5009CEFB5009CEFAD0094EFAD0094EFA5008CEFA5008CEF9C005ADE7B0039DE
      5A0039D65A004AE76B008CCE9C00000000000000000065FE98FF31C657FFFFE1
      C4FFFFE0C0FFFFDEBCFF33C94FFF31CA49FF21AF35FFFFD7AEFFFFD5ABFFFFD3
      A7FFFFEEDDFFF0C796FF000000000000000000000000000000003152FF00BDD6
      FF00ADBDFF00A5BDFF00A5BDFF009CB5FF009CB5FF0094B5FF0094ADFF008CAD
      FF0094ADFF00294AEF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B5F7CE0039DE6B0000000000000000000000000031CE5A00BDFF
      D600ADF7BD00A5F7B5009CF7B5009CEFAD0094EFAD0094EFAD008CEFA5008CEF
      A5008CEFA50021AD390000000000000000000000000000000000F7D19EFFFFDF
      BEFFFFDDBAFFFFDBB7FFFFD9B3FF36C955FF3AD358FF1C9F31FFFFFFFFFFFFFF
      FFFFF1C58EFF000000000000000000000000000000000000000000000000395A
      FF00C6D6FF00B5CEFF00A5BDFF00A5BDFF009CBDFF009CB5FF009CB5FF00ADCE
      FF003152F7000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000CEFFDE000000000000000000000000000000000031D6
      6300BDFFD600B5FFC600ADF7BD00A5F7BD00A5F7B5009CF7B5009CF7AD00A5FF
      C60021B542000000000000000000000000000000000000000000F9D5A3FFFFDC
      B8FFFFDAB5FFFFD8B1FFFFD6AEFFFFD5AAFF2AB94BFFF1CE9DFFFFFFFFFFF4CA
      95FF000000000000000000000000000000000000000000000000000000000000
      00009CADFF006B84FF00BDD6FF00BDD6FF00BDD6FF00B5CEFF006384FF009CAD
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00009CEFB5006BE78C00BDFFD600B5FFCE00B5FFCE00ADFFCE005ADE7B0094DE
      A500000000000000000000000000000000000000000000000000FBD9A8FFFFEC
      D9FFFFEBD7FFFFEAD6FFFFEAD4FFFFE9D2FFFFE8D0FFFFFCF9FFF6CF9CFF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
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
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000008000FFFF00000000000087FF00000000
      000087FF000000000000C3FF000000000000E1FF000000000000F03F00000000
      0000F00F000000000000F807000000000000F003000000000000F00300000000
      0000F003000000000000F803000000000000F803000000000000FC0300000000
      0000FE07000000000000FFFF00000000FFFFFFFFFFFFFFFFF00FFFFFF00FC003
      E007F9FFE007C003C003F1FFC003C0038001E1FF8001C0038001C01F8001C003
      800180078001C003800180038001C003800180018001C0038001C10180018003
      8001E1E1800180038001F9F980018003C003FFF9C003C007E007FFFDE007C00F
      F00FFFFFF00FC01FFFFFFFFFFFFFFFFFFFFFC003FFFFFFFFFFFFC003C003F81F
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
end
