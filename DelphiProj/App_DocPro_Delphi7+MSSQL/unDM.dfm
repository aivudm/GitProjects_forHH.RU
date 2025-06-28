object dmDB: TdmDB
  OldCreateOrder = False
  OnDestroy = DataModuleDestroy
  Left = 272
  Top = 39
  Height = 692
  Width = 1121
  object dbConnection: TADOConnection
    ConnectionString = 
      'Provider=SQLNCLI11.1;Persist Security Info=False;User ID=user5;I' +
      'nitial Catalog=DocPro;Data Source=PC480211\SQLExpress;Use Proced' +
      'ure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstati' +
      'on ID=PC480211;Initial File Name="";Use Encryption for Data=Fals' +
      'e;Tag with column collation when possible=False;MARS Connection=' +
      'False;DataTypeCompatibility=0;Trust Server Certificate=False;Ser' +
      'ver SPN="";Application Intent=READWRITE;'
    ConnectionTimeout = 5
    ConnectOptions = coAsyncConnect
    CursorLocation = clUseServer
    IsolationLevel = ilReadCommitted
    LoginPrompt = False
    Provider = 'SQLNCLI11.1'
    OnDisconnect = dbConnectionDisconnect
    OnInfoMessage = dbConnectionInfoMessage
    OnConnectComplete = dbConnectionConnectComplete
    Left = 24
    Top = 16
  end
  object QCommon: TADOQuery
    Connection = dbConnection
    CursorType = ctStatic
    Parameters = <>
    Prepared = True
    Left = 24
    Top = 72
  end
  object QDocument: TADOQuery
    Connection = dbConnection
    CursorType = ctStatic
    Parameters = <>
    Prepared = True
    Left = 32
    Top = 208
  end
  object QDocumentItem: TADOQuery
    Connection = dbConnection
    CursorType = ctStatic
    Parameters = <>
    Left = 32
    Top = 256
  end
  object dsDocument: TDataSource
    DataSet = QDocument
    OnDataChange = dsDocumentDataChange
    Left = 112
    Top = 208
  end
  object QEditOrder: TADOQuery
    Connection = dbConnection
    CursorType = ctStatic
    Parameters = <
      item
        Name = 'p_IdOrderAsInteger'
        Attributes = [paSigned, paNullable]
        DataType = ftInteger
        Precision = 10
        Size = 4
        Value = 0
      end
      item
        Name = 'p_ExecutionDate'
        Attributes = [paNullable]
        DataType = ftDateTime
        NumericScale = 255
        Precision = 255
        Size = 20
        Value = Null
      end
      item
        Name = 'p_Notes'
        Attributes = [paNullable]
        DataType = ftString
        NumericScale = 3
        Precision = 23
        Size = 16
        Value = Null
      end>
    Prepared = True
    SQL.Strings = (
      
        'EXEC sp_UpdateClientCommonInfo :p_IdCard, :p_AreaNumber, :p_Card' +
        'OpenedDate,'
      
        ':p_Firstname, :p_Name, :p_FatherName, :p_Sex, :p_LivingType, :p_' +
        'Birthday, :p_Adress, :p_CodeOKATO, :p_PaymentType,'
      
        ':p_InsuranceCompanyName, :p_SNILS, :p_InsurancePolicySeries, :p_' +
        'InsurancePolicyNumber, :p_JobOrStudyPlace, :p_JobPosition, :p_Ho' +
        'lderOfPower,'
      
        ':p_DiseaseBeginDate, :p_CompulsoryExaminationDate, :p_CardClosed' +
        'Date, :p_ReasonStoppingObservation, :p_DeathDate, :p_DeathCause,' +
        ' :p_BrainAbility, '
      
        ':p_Guardianship, :p_FIOGuardian, :p_AdressGuardian, :p_AIDSObser' +
        'ving, :p_DateAIDSRevelation'#39)
    Left = 208
    Top = 212
  end
  object dsObjectsTree: TDataSource
    Left = 104
    Top = 136
  end
  object spAddDiagnosis: TADOStoredProc
    Connection = dbConnection
    ProcedureName = 'sp_AddDiagnosisRecord'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@input_IdCard'
        Attributes = [paNullable]
        DataType = ftLargeint
        Precision = 19
        Value = Null
      end
      item
        Name = '@input_DateDiseaseSet'
        Attributes = [paNullable]
        DataType = ftDateTime
        Value = Null
      end
      item
        Name = '@input_DiseaseCode'
        Attributes = [paNullable]
        DataType = ftString
        Size = 10
        Value = Null
      end
      item
        Name = '@input_DiseaseCodeBasic'
        Attributes = [paNullable]
        DataType = ftString
        Size = 10
        Value = Null
      end>
    Left = 584
    Top = 8
  end
  object QErrorLog: TADOQuery
    Connection = dbConnection
    Parameters = <>
    SQL.Strings = (
      '')
    Left = 608
    Top = 420
  end
  object dsErrorLog: TDataSource
    DataSet = QErrorLog
    Left = 680
    Top = 428
  end
  object QEventLog: TADOQuery
    Connection = dbConnection
    Parameters = <>
    SQL.Strings = (
      '')
    Left = 608
    Top = 484
  end
  object dsEventLog: TDataSource
    DataSet = QEventLog
    Left = 680
    Top = 508
  end
  object dsDocumentItem: TDataSource
    DataSet = QDocumentItem
    OnDataChange = dsDocumentItemDataChange
    Left = 112
    Top = 256
  end
  object QComboBox1: TADOQuery
    Connection = dbConnection
    Parameters = <>
    Left = 200
    Top = 8
  end
  object dsComboBox1: TDataSource
    DataSet = QProcessList
    Left = 280
    Top = 8
  end
  object QProcessList: TADOQuery
    Connection = dbConnection
    CursorType = ctStatic
    LockType = ltBatchOptimistic
    Parameters = <>
    Left = 24
    Top = 312
  end
  object dsProcessList: TDataSource
    DataSet = QProcessList
    OnDataChange = dsProcessListDataChange
    Left = 104
    Top = 312
  end
  object QComboBox2: TADOQuery
    Connection = dbConnection
    Parameters = <>
    Left = 200
    Top = 48
  end
  object dsComboBox2: TDataSource
    Left = 280
    Top = 48
  end
  object QReport1: TADOQuery
    Connection = dbConnection
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'exec sp_Report_MTR_ForBuying'
      '')
    Left = 904
    Top = 64
  end
  object dsUserList: TDataSource
    DataSet = adsUserList
    OnDataChange = dsUserListDataChange
    Left = 304
    Top = 272
  end
  object QProgramRoleList: TADOQuery
    Connection = dbConnection
    CursorType = ctStatic
    Parameters = <>
    Prepared = True
    SQL.Strings = (
      'EXEC sp_GetOrdersList 0, 1, 0')
    Left = 216
    Top = 328
  end
  object dsProgramRoleList: TDataSource
    DataSet = QProgramRoleList
    Left = 312
    Top = 328
  end
  object dsProcessItem: TDataSource
    DataSet = QProcessItem
    OnDataChange = dsProcessItemDataChange
    Left = 96
    Top = 376
  end
  object QProcessItem: TADOQuery
    Connection = dbConnection
    Parameters = <>
    Left = 16
    Top = 368
  end
  object QObjectsTree: TADOQuery
    Connection = dbConnection
    Parameters = <>
    Left = 24
    Top = 136
  end
  object QStoreObjectList: TADOQuery
    Connection = dbConnection
    CursorType = ctStatic
    Parameters = <>
    Prepared = True
    Left = 392
    Top = 72
  end
  object dsStoreObjectList: TDataSource
    DataSet = QStoreObjectList
    OnDataChange = dsStoreObjectListDataChange
    Left = 480
    Top = 72
  end
  object QSPText: TADOQuery
    Connection = dbConnection
    CursorType = ctStatic
    LockType = ltBatchOptimistic
    Parameters = <>
    Left = 456
    Top = 168
  end
  object dsCommon: TDataSource
    DataSet = QCommon
    Left = 80
    Top = 72
  end
  object dbConnectionAsSA: TADOConnection
    ConnectionString = 
      'Provider=SQLNCLI11.1;Integrated Security="";Persist Security Inf' +
      'o=False;User ID=sa;Initial Catalog=OrdersProcessing;Data Source=' +
      'PC480211\SQLExpress;Initial File Name="";Server SPN="";'
    Provider = 'SQLNCLI11.1'
    Left = 544
    Top = 168
  end
  object dbCommandAsSA: TADOCommand
    Connection = dbConnectionAsSA
    Parameters = <>
    Left = 456
    Top = 216
  end
  object QDocumentItem_Manufacturing: TADOQuery
    Connection = dbConnection
    Parameters = <>
    Left = 224
    Top = 152
  end
  object dsDocumentItem_Manufacturing: TDataSource
    DataSet = QDocumentItem_Manufacturing
    Left = 336
    Top = 152
  end
  object QJob: TADOQuery
    Connection = dbConnection
    Parameters = <>
    Left = 16
    Top = 424
  end
  object dsJob: TDataSource
    DataSet = QJob
    Left = 96
    Top = 432
  end
  object QJobRole: TADOQuery
    Connection = dbConnection
    Parameters = <>
    Left = 216
    Top = 392
  end
  object dsJobRole: TDataSource
    DataSet = QJobRole
    Left = 296
    Top = 392
  end
  object dsJobRoleVirtual: TDataSource
    DataSet = QJobRoleVirtual
    Left = 304
    Top = 456
  end
  object QJobRoleVirtual: TADOQuery
    Parameters = <>
    Left = 216
    Top = 456
  end
  object sp_GetJobRoleVirtual_byUser: TADOStoredProc
    Connection = dbConnection
    CursorType = ctStatic
    DataSource = dsJobRoleVirtual
    ProcedureName = 'sp_GetJobRoleVirtual_byUser'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = 0
      end
      item
        Name = '@input_UserId'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = Null
      end>
    Left = 440
    Top = 424
  end
  object QUserList: TADOQuery
    Connection = dbConnection
    Parameters = <>
    Left = 216
    Top = 272
  end
  object adsUserList: TADODataSet
    Connection = dbConnection
    CursorType = ctStatic
    CommandType = cmdStoredProc
    Parameters = <>
    Left = 288
    Top = 216
  end
  object dsSpravList: TDataSource
    DataSet = QSpravList
    OnDataChange = dsSpravListDataChange
    Left = 328
    Top = 512
  end
  object adsSpravList: TADODataSet
    Connection = dbConnection
    CommandText = 'sp_adm_GetSpravList'
    CommandType = cmdStoredProc
    Parameters = <>
    Left = 272
    Top = 504
  end
  object QSpravList: TADOQuery
    Connection = dbConnection
    Parameters = <>
    Left = 216
    Top = 504
  end
  object QSpravData: TADOQuery
    Connection = dbConnection
    Parameters = <>
    Left = 416
    Top = 536
  end
  object dsSpravData: TDataSource
    DataSet = QSpravData
    Left = 488
    Top = 528
  end
  object dsJobItem: TDataSource
    DataSet = QJobItem
    OnDataChange = dsJobItemDataChange
    Left = 88
    Top = 480
  end
  object QJobItem: TADOQuery
    Connection = dbConnection
    Parameters = <>
    Left = 16
    Top = 480
  end
  object QComboBox3: TADOQuery
    Connection = dbConnection
    Parameters = <>
    Left = 200
    Top = 96
  end
  object dsComboBox3: TDataSource
    Left = 280
    Top = 96
  end
  object frxReport_MTR_ForBuying: TfrxReport
    Version = '4.11.14'
    DataSetName = 'frxDBDataset2'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 40316.467897025500000000
    ReportOptions.LastChange = 42827.388800034700000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'procedure MasterData1OnMasterDetail(Sender: TfrxComponent);'
      'begin'
      'end;'
      ''
      'begin'
      ''
      'end.')
    Left = 824
    Top = 16
    Datasets = <
      item
        DataSet = frxDBDataset1
        DataSetName = 'frxDBDataset1'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -7
      Font.Name = 'Arial'
      Font.Style = []
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
      object Memo15: TfrxMemoView
        Left = 12.000000000000000000
        Top = 32.000000000000000000
        Width = 80.000000000000000000
        Height = 16.000000000000000000
        ShowHint = False
        Wysiwyg = False
      end
      object Memo16: TfrxMemoView
        Left = 76.000000000000000000
        Top = 52.000000000000000000
        Width = 80.000000000000000000
        Height = 16.000000000000000000
        ShowHint = False
        Wysiwyg = False
      end
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      object ReportTitle1: TfrxReportTitle
        Height = 30.236240000000000000
        Top = 18.897650000000000000
        Width = 718.110700000000000000
        object Memo2: TfrxMemoView
          Left = 7.559060000000000000
          Top = 7.559060000000000000
          Width = 219.212740000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8 = (
            #1056#1119#1056#181#1057#1026#1056#181#1057#8225#1056#181#1056#1029#1057#1034' '#1056#1114#1056#1118#1056#160' '#1056#1169#1056#187#1057#1039' '#1056#1111#1057#1026#1056#1105#1056#1109#1056#177#1057#1026#1056#181#1057#8218#1056#181#1056#1029#1056#1105#1057#1039)
        end
        object Memo31: TfrxMemoView
          Left = 612.283860000000000000
          Width = 60.472480000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          HAlign = haRight
          Memo.UTF8 = (
            '[<Date>]')
          ParentFont = False
        end
        object Memo32: TfrxMemoView
          Left = 672.756340000000000000
          Width = 68.031540000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            '[Time]')
          ParentFont = False
        end
      end
      object ReportSummary1: TfrxReportSummary
        Height = 18.897650000000000000
        Top = 347.716760000000000000
        Width = 718.110700000000000000
        Stretched = True
      end
      object PageFooter1: TfrxPageFooter
        Height = 22.677180000000000000
        Top = 389.291590000000000000
        Width = 718.110700000000000000
        object Memo4: TfrxMemoView
          Left = 623.622450000000000000
          Top = 3.779530000000020000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8 = (
            '[Page#]')
        end
      end
      object PageHeader1: TfrxPageHeader
        Height = 68.031540000000000000
        Top = 71.811070000000000000
        Width = 718.110700000000000000
        object Memo33: TfrxMemoView
          Left = 6.118120000000000000
          Top = 22.677180000000000000
          Width = 30.236220470000000000
          Height = 37.795300000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1074#8222#8211
            #1056#1111'/'#1056#1111)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo49: TfrxMemoView
          Left = 380.629887090000000000
          Top = 22.677180000000000000
          Width = 229.795358580000000000
          Height = 37.795300000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%g'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1119#1057#1026#1056#1105#1056#1112#1056#181#1057#8225#1056#176#1056#1029#1056#1105#1057#1039)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo65: TfrxMemoView
          Left = 36.354360000000000000
          Top = 22.677180000000000000
          Width = 71.811050470000000000
          Height = 37.795300000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1074#8222#8211' '#1056#183#1056#176#1057#1039#1056#1030#1056#1108#1056#1105)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo1: TfrxMemoView
          Left = 108.165430000000000000
          Top = 22.677180000000000000
          Width = 196.535560000000000000
          Height = 37.795300000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1116#1056#176#1056#1105#1056#1112#1056#181#1056#1029#1056#1109#1056#1030#1056#176#1056#1029#1056#1105#1056#181' '#1056#1114#1056#1118#1056#160)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo6: TfrxMemoView
          Left = 287.244280000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8 = (
            #1056#1116#1056#176#1056#1105#1056#1112#1056#181#1056#1029#1056#1109#1056#1030#1056#176#1056#1029#1056#1105#1056#181' '#1056#1114#1056#1118#1056#160'_1')
        end
        object Memo10: TfrxMemoView
          Left = 304.921460000000000000
          Top = 22.677180000000000000
          Width = 37.795280470000000000
          Height = 37.795300000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#1113#1056#1109#1056#187'-'#1056#1030#1056#1109)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo11: TfrxMemoView
          Left = 342.937230000000000000
          Top = 22.677180000000000000
          Width = 37.795280470000000000
          Height = 37.795300000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#8226#1056#1169'. '#1056#1105#1056#183#1056#1112)
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo3: TfrxMemoView
          Left = 609.504330000000000000
          Top = 22.677180000000000000
          Width = 108.850398580000000000
          Height = 37.795300000000000000
          ShowHint = False
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%g'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Times New Roman'
          Font.Style = [fsBold]
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            #1056#164#1056#176#1056#1108#1057#8218' '#1056#1111#1057#1026#1056#1105#1056#1109#1056#177#1057#1026#1056#1105#1057#8218#1056#181#1056#1029#1056#1105#1057#1039)
          ParentFont = False
          VAlign = vaCenter
        end
      end
      object GroupHeader1: TfrxGroupHeader
        Height = 22.677180000000000000
        Top = 200.315090000000000000
        Width = 718.110700000000000000
        Condition = 'frxDBDataset1."CodeGroup"'
        object Memo14: TfrxMemoView
          Left = 7.559060000000000000
          Top = 3.779530000000000000
          Width = 264.567100000000000000
          Height = 18.897650000000000000
          ShowHint = False
          Memo.UTF8 = (
            '[frxDBDataset1."ObjectsGroupName"]')
        end
      end
      object MasterData1: TfrxMasterData
        Height = 41.574830000000000000
        Top = 245.669450000000000000
        Width = 718.110700000000000000
        DataSet = frxDBDataset1
        DataSetName = 'frxDBDataset1'
        RowCount = 0
        object Memo5: TfrxMemoView
          Top = 3.779530000000000000
          Width = 34.015750470000000000
          Height = 37.795300000000000000
          ShowHint = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[Line#]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo7: TfrxMemoView
          Left = 376.173177090000000000
          Top = 3.779530000000000000
          Width = 233.574888580000000000
          Height = 37.795300000000000000
          ShowHint = False
          DataField = 'DocumentItemNotes'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = '%g'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[frxDBDataset1."DocumentItemNotes"]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo8: TfrxMemoView
          Left = 34.015770000000000000
          Top = 3.779530000000000000
          Width = 71.811050470000000000
          Height = 37.795300000000000000
          ShowHint = False
          DataField = 'DocumentId'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[frxDBDataset1."DocumentId"]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo9: TfrxMemoView
          Left = 105.826840000000000000
          Top = 3.779530000000000000
          Width = 200.315090000000000000
          Height = 37.795300000000000000
          ShowHint = False
          DataField = 'ObjectName'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[frxDBDataset1."ObjectName"]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo12: TfrxMemoView
          Left = 304.582870000000000000
          Top = 3.779530000000000000
          Width = 34.015750470000000000
          Height = 37.795300000000000000
          ShowHint = False
          DataField = 'Volume'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[frxDBDataset1."Volume"]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo13: TfrxMemoView
          Left = 338.598640000000000000
          Top = 3.779530000000000000
          Width = 37.795280470000000000
          Height = 37.795300000000000000
          ShowHint = False
          DataField = 'MeasurementsUnit'
          DataSet = frxDBDataset1
          DataSetName = 'frxDBDataset1'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Times New Roman'
          Font.Style = []
          Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
          HAlign = haCenter
          Memo.UTF8 = (
            '[frxDBDataset1."MeasurementsUnit"]')
          ParentFont = False
          VAlign = vaCenter
        end
        object Memo17: TfrxMemoView
          Left = 612.283860000000000000
          Top = 7.559060000000000000
          Width = 105.826840000000000000
          Height = 34.015770000000000000
          ShowHint = False
          Memo.UTF8 = (
            ' ')
        end
      end
    end
  end
  object frxDBDataset1: TfrxDBDataset
    UserName = 'frxDBDataset1'
    CloseDataSource = False
    DataSet = QReport1
    BCDToCurrency = False
    Left = 896
    Top = 8
  end
end
