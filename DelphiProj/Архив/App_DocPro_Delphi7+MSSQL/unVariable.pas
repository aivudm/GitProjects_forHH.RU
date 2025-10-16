unit unVariable;
interface
uses SysUtils, Controls, IniFiles, Forms, DB, ADOdb, ComCtrls,
     Variants, Classes,
     unConstant, unMain;


type
    TRecordsetEvent = procedure(DataSet: TCustomADODataSet; const Error: Error; var EventStatus: TEventStatus) of object;
    TConfirmResult = (YesResult = 1, NoResult = 2, CancelResult = 3);
    TMessageType = (InfoMessage = 1, ErrorMessage = 2, EditMessage = 3);
    TOperationType = (doAdd = 1, doEdit = 2, doView = 3);
    TJobType = (jtJob = 0, jtJobItem = 1);
    TJobRoleType = (jrtReal = 0, jrtVirtual = 1);
    TJobResult = (jrNone = 0, jrAgree = 1, jrDeny = 2, jrAlter = 3); // ---- Надо переделать - заполнять при старте из базы данных sprJobResult
    TJobExistsStatus = (jesJobNotExists = 0, jesJobExists = 1);
    TCanChangeStatus = (ccsCanNot = 0, ccsCan = 1);
    TJobDocumentItem = record
      ResolutionText: string;
    end;
    TDataType = (dtTemplate = 0, dtInstance = 1);

    TFormatText=(txFormatLeft, txFormatCenter, txFormatRight);
    TFilterState = (fsOff = 0, fsOn = 1);
    TFilterStateSearch = (fsBeginingAs = 0, fsIncludingAs = 1);
    TResolutionType = (rtNothing = 0, rtDeny = 1, {rtConfirm = 2, - лишено смысла при многодолжностном согласовании} rtAlteration = 3, rtAcceptedOnStock = 4);
    TDocumentItemState = (disNotAvailable = 0, disAgreed = 1, disDenied = 2, disAltered = 3, disAcceptedOnStock = 4);
    TTargetHierarchivalView = (hvInput = 0, hvTotal = 1);
    TCurrentActiveObject = (aoDocument = 0, aoDocumentItem = 1, aoStoreObject = 3, aoStoreObjectItem = 4);

    TVariantArray = array [0..10] of Variant;
    TObjectShowStatus = (ossActiveOnly = 0, ossActiveAndDeleted = 1, ossDeletedOnly = 2);
    TProcessItemStatus = (PassedPoint = 0, CurrentPoint = 1, FuturePoint = 3, CanceledPoint = 4);
    TProcessItemCheckData = array[0..maxProcessItemArrayValues] of TProcessItemStatus;

    TSQLServerError = integer;
    DBError = string;
//    TOrderProcessStatus = (psUndeclared = 0, psInitiate = 1, psAgreements = 2, psApproves = 3, psExecuting = 4, psExecuted = 99, psDenied = 6, psAltering = 7, psAcceptingOnStock = 8);
    TDocumentViewType = (dhtTotal = 0, dhtInput = 1);
    TDocumentType = (dtAll = 0, dtMTR = 1, dtManufacturing = 2, dtRepairing = 3);
    TDocumentStatus = (dsUndeclared = 0, dsActive = 1, dsArchive = 2, dsDeleted = 3);
    TOrdersSort = (byProcessStatus = 0, byOrderNum = 1, byCreationDate = 2, CreatorOwner = 3, byCreationDate_CreatorOwner = 4);
    TLogViewType =  (byDateAll = 1, byDateBetweenDate = 2);
    TProgramRole = (prInitiate = 1, prAgreements = 2, prApproves = 3, prExecuter = 4, prAdmin = 99);
    TProgramRoles = set of TProgramRole;
    TProgramJobPosition = Integer;

    TIdDSPositionSaver = integer;


    TId = longint;
    TIdDocument = longint;
    TIdDocumentItem = longint;
    TIdJobRole = TId;
    TIdUser = word;
    TIdSpravObject = word;
    TIdObjectGroup = word;
    TIdMeasurementUnit = longint;
    TIdStoreObject = longint;
    TIdStoreObjectGroup = word;
    TidStoreObjectParentLink = word;
    TIdAttachment = longint;
    TAttachmentList = array [1..10] of string;
    TAttachmentIdList = array [1..10] of TIdAttachment;
    TAttachmentState = (asIs = 0, asNew = 1, asRenamed = 2, asDeleted = 3);
    TAttachmentStateList = array [1..10] of TAttachmentState;

    TIdJob = word;
    TJobPositionsName = string;
    THierarchivalJobStatus = string;

    TIdProcess = longint;
    TProcessName = string;
    TDocumentNum = string;
    TRouteType = word;
    TRoutesPositionLevel = word;
    TRoutesPointsName = string;
    TIdRouteItem = longint;
    TRouteItemCode = word;

    TCodeSpravObject = word;
    TRouteCode = word;
    TAdminRightState = boolean;
    TInitiatorState = boolean;
//    TRoutesCode = integer;

{
 TProcessStatusArray = class
   psName: string;
   psCode: TIdProcessStatus;
   psId: TIdProcessStatus;
   published
    constructor Create();
   private
    FieldNameForIdOrder: string;
   public
    function GetProcessStatusSFromDB(Sender: TProcessStatusArray): boolean;
   end;
}
{
 THierarchicalJobView = class(TObject)
   Code: TJobCode;
   Name: string;
   TargetHierarchivalView: TTargetHierarchivalView;
   published
    constructor Create();
   private
    { Private declarations }
{
    FieldNameForIdOrder: string;
   public
    { Public declarations }
{    function SetCurrent(Sender: THierarchicalJobView; inputJobName: string): boolean;
  end;
}


//-------- Сложные типы --------------------------------------------------------------

  TDocument = class(TObject)
   IdDocument: TIdDocument;
   DocumentType: TDocumentType;
   ProcessInstance: TId;
   ProcessItemInstance: TId;
   CurrentProcessItem: TId;
   DocumentNum: TDocumentNum;
   Notes, ShortName, CreatorOwner: string;
   CreationDate, ExecutionDate: TDatetime;
   ExecutionDateAsString: string;
   IdSelectedItem: TIdDocument;
   published
    constructor Create();  //--- В конструкторе задается имя поля для IdOrder в Query
   private
    { Private declarations }
    FieldNameForIdDocument: string;
    DocumentStatus: TDocumentStatus;
    JobId: TIdJob;
   public
    { Public declarations }
    property GetDocumentNum: TDocumentNum read DocumentNum;
    property GetDocumentShortName: string read ShortName;
    property GetDocumentStatus: TDocumentStatus read DocumentStatus;
    property GetQueryFieldNameForIdDocument: string read FieldNameForIdDocument;
    property GetCurrentJobId: TIdJob read JobId;
    function SetCurrent(inputDocument, inputDocumentItem: TDataset): boolean;
    function SetCurrentByIDDocument(IDDocument: TIdDocument): boolean;
  end;

 TAttachment = class(TObject)
   published
    constructor Create();  //--- В конструкторе задается имя поля для IdRoutesItem в Query
   private
    { Private declarations }
    AttachmentId: TAttachmentIdList;
    AttachmentState: TAttachmentStateList;
    AttachmentName: TAttachmentList;
    AttachmentUNCFileName: TAttachmentList;

   public
    { Public declarations }
    function ClearAttachment: boolean;
    function GetAttachmentId(inputAttachmentNumber: integer): TIdAttachment;
    function SetAttachmentId(inputAttachmentNumber: integer; inputAttachmentId: TIdAttachment): boolean;
    function GetAttachmentName(inputAttachmentNumber: integer): string;
    function SetAttachmentName(inputAttachmentNumber: integer; inputAttachmentName: string): boolean;
    function GetAttachmentUNCFileName(inputAttachmentNumber: integer): string;
    function SetAttachmentUNCFileName(inputAttachmentNumber: integer; inputAttachmentUNCFileName: string): boolean;
    function GetAttachmentState(inputAttachmentNumber: integer): TAttachmentState;
    function SetAttachmentState(inputAttachmentNumber: integer; inputAttachmentState: TAttachmentState): boolean;
  end;


  TDocumentItem = class(TObject)
   Id: TIdDocumentItem;
   IdDocumentOwner: TIdDocument;
   Process, ProcessItem: TIdProcess;
   CurrentProcessItem: integer;
   ObjectsGroup, ShortName, FullName, MeasurementUnit, Notes, CreatorOwner: string;
   Volume: integer;
   CreationDate, ExpirationDate: TDatetime;
   ExecutionDateAsString: string;
   ItemState: TDocumentItemState;
   Attachments: TAttachment;
   AttachmentsCount: word;

   published
    constructor Create();  //--- В конструкторе задается имя поля для IdOrderItem в Query
   private
    { Private declarations }
    FieldNameForIdOrderItem: string;
   public
    { Public declarations }
    function SetCurrent(inputDocumentItemId: TId): boolean; virtual;
    function SetCurrentByIDDocumentItem(IDDocumentItem: TIdDocumentItem): boolean; virtual;
    property GetAttachmentsCount: word read AttachmentsCount;
    property SetAttachmentsCount: word write AttachmentsCount;
  end;

  TDocumentItem_Tree = class(TObject)
   Id: TIdDocumentItem;
   IdParent: TIdDocumentItem;
   IdDocumentOwner: TIdDocument;
   ShortName, FullName, MeasurementUnit, Notes, CreatorOwner: string;
   Volume: integer;
   CreationDate, ExpirationDate: TDatetime;
   ExecutionDateAsString: string;
   ItemState: TDocumentItemState;
   Attachments: TAttachment;
   AttachmentsCount: word;

   published
    constructor Create();  //--- В конструкторе задается имя поля для IdOrderItem в Query
   private
    { Private declarations }
    FieldNameForIdOrderItem: string;
   public
    { Public declarations }
    function SetCurrent(inputTreeItem: TTreeNode): boolean;
    function SetCurrentByIDDocumentItem(IDDocumentItem: TIdDocumentItem): boolean;
    property GetAttachmentsCount: word read AttachmentsCount;
    property SetAttachmentsCount: word write AttachmentsCount;
  end;

  TUser = class(TObject)
   published
    constructor Create();
   private
    { Private declarations }
    IdUser: TIdUser;
    ShortName, FullName, Notes: string;
    IdJobRole: TIdUser;
    JobRoleName: string;
    ProgramRoles: set of TProgramRole;
    IsAdminRight: Boolean;
    DefaultRoute: TIdProcess;
   public
    { Public declarations }
    property GetIdUser: TIDUser read IdUser;
    property GetUIdUser: TIDUser read IdUser;
    property GetLoginName: string read ShortName;
    property GetFullName: string read FullName;
    property GetNotes: string read Notes;
    property GetMainJobPosition: TIDUser read IdUser;
    property GetJobRoleName: string read JobRoleName;
    property GetAdminRightState: TAdminRightState read IsAdminRight;
    property GetDefaultRoute: TIdProcess read DefaultRoute;

    function SetCurrent(inputLoginName: String): boolean;
    function GetProgramRoles: TProgramRoles;
    function SetProgramRoles: boolean;
  end;

  TSprav = class(TObject)
   published
    constructor Create();
   private
    { Private declarations }
    ShortName, FullName: string;
   public
    { Public declarations }
    property GetShortName: string read ShortName;
    property GetFullName: string read FullName;

    function SetCurrent(inputSpravTableName: string): boolean;
  end;


  TSpravObject = class(TObject)
   published
    constructor Create();   //--- В конструкторе задается имя поля для Id в Query
   private
    { Private declarations }
    IdSprav: TIdSpravObject;
    Code: TCodeSpravObject;
    ShortName, FullName, Notes: string;
    DocumentType: TDocumentType;
    MeasurmentUnitShortName: string;
   public
    { Public declarations }
    property GetId: TIdSpravObject read IdSprav;
    property GetCode: TCodeSpravObject read Code;
    property GetShortName: string read ShortName;
    property GetFullName: string read FullName;
    property GetNotes: string read Notes;
    property GetOrderType: TDocumentType read DocumentType;
    property GetMeasurmentUnitShortName: string read MeasurmentUnitShortName;

    function SetCurrent(inputSpravTableName: string; inputId: TId): boolean;
  end;


  TProcess = class(TObject)
   published
    constructor Create();
   private
    { Private declarations }
    ProcessId: TId;
    ShortName, FullName, Notes: string;
   public
    { Public declarations }
    property GetId: TId read ProcessId;
//    property GetCode: TCodeRoute read Code;
//    property GetShortName: string read ShortName;
//    property GetFullName: string read FullName;
//    property GetNotes: string read Notes;

    function SetCurrent(inputProcessId: TId): boolean;
  end;

  TProcessItem = class(TObject)
   published
    constructor Create();
   private
    { Private declarations }
    ProcessItemId: TId;
    ProcessItemLevel: integer;
    ProcessItemName: string;
   public
//    { Public declarations }
    property GetId: TId read ProcessItemId;
    property GetItemLevel: integer read ProcessItemLevel;
    property GetName: string read ProcessItemName;
    function SetCurrent(inputProcessItemId: TId): boolean;
  end;


 TJobItem = class(TObject)
   published
    constructor Create();
   private
    { Private declarations }
    Id: TId;
    ProcessItem: TId;
    ItemLevel: integer;
    JobItemIdSprav: TId;
    JobItemIdName: string;
    ActiveStatus: boolean;
    DoneStatus: boolean;
    Resolution: TId;
    ConditionDependence: TId;
    DeletedStatus: boolean;
    EntireDocumentStatus: boolean;
    EDDStatus: boolean;

   public
//    { Public declarations }
    property GetId: TId read Id;
    property GetProcessItem: TId read ProcessItem;
    property GetItemLevel: TId read ItemLevel;
    property GetJobItemIdSprav: TId read JobItemIdSprav;
    property GetActiveStatus: boolean read ActiveStatus;
    property GetDoneStatus: boolean read DoneStatus;
    property GetResolution: TId read Resolution;
    property GetConditionDependence: TId read ConditionDependence;
    property GetDeletedStatus: boolean read DeletedStatus;
    property GetEntireDocumentStatus: boolean read EntireDocumentStatus;
    property GetEDDStatus: boolean read EDDStatus;

    function SetCurrent(inputJobItemId: TId; inputDataType: TDataType): boolean;
  end;


  TStoreObject = class(TObject)
   IdStoreObject: TIdStoreObject;
   IdParentDocument: TIdDocument;
   IdParentDocumentItem: TIdDocumentItem;
   Notes, OrderNum, CreatorOwner: string;
   CreationDate: TDatetime;
   published
    constructor Create();  //--- В конструкторе задается имя поля для IdOrder в Query
   private
    { Private declarations }
   public
    { Public declarations }
    property GetId: TIdStoreObject read IdStoreObject;
    property GetIdParentOrder: TIdDocument read IdParentDocument;
    property GetIdParentOrderItem: TIdDocumentItem read IdParentDocumentItem;
    function SetCurrent(inputStoreObject: TDataset): boolean;
  end;


TFilterForObjects = class(TObject)
  published
   constructor Create();  //--- В конструкторе задается начальное значение "Выкл"
  private
    { Private declarations }
    State: TFilterState;
    fInitiatorOwnerState, fObjectsGroupState, fPeriodCreatingState, fPeriodParentObjectCreatingState: TFilterState;
    fSearchSubstringForNameState: TFilterStateSearch;
    fInitiatorOwner, fInitiatorOwnerParent: string;
    fObjectsGroup: string;
    fPeriodCreatingBegin, fPeriodCreatingEnd: TDatetime;
    fPeriodCreatingBeginParentObject, fPeriodCreatingEndParentObject: TDatetime;
    fSearchSubstringForName: string;
    fFullOrderListStates: TFilterState;
    fSectionForINIFile: string;
  public
    { Public declarations }
   property GetState: TFilterState read State;
   property SetState: TFilterState write State;
   property GetStateSearchSubstringForName: TFilterStateSearch read fSearchSubstringForNameState;
   property SetStateSearchSubstringForName: TFilterStateSearch write fSearchSubstringForNameState;
   property GetStateInitiatorOwner: TFilterState read fInitiatorOwnerState;
   property SetStateInitiatorOwner: TFilterState write fInitiatorOwnerState;
   property GetStateObjectsGroup: TFilterState read fObjectsGroupState;
   property GetStatePeriodCreating: TFilterState read fPeriodCreatingState;
   property GetStatePeriodParentObjectCreating: TFilterState read fPeriodParentObjectCreatingState;
   property SetStateObjectsGroup: TFilterState write fObjectsGroupState;
   property SetStatePeriodCreating: TFilterState write fPeriodCreatingState;
   property SetStatePeriodParentObjectCreating: TFilterState write fPeriodParentObjectCreatingState;
   property SetValueSearchSubstringForName: string write fSearchSubstringForName;

   property GetValueInitiatorOwner: string read fInitiatorOwner;
   property GetValueInitiatorOwnerParent: string read fInitiatorOwnerParent;
   property GetValueObjectsGroup: string read fObjectsGroup;
   property GetValuePeriodBeginCreating: TDatetime read fPeriodCreatingBegin;
   property GetValuePeriodEndCreating: TDatetime read fPeriodCreatingEnd;
   property GetValuePeriodBeginParentObjectCreating: TDatetime read fPeriodCreatingBeginParentObject;
   property GetValuePeriodEndParentObjectCreating: TDatetime read fPeriodCreatingEndParentObject;
   property GetValueFullOrderListStates: TFilterState read fFullOrderListStates;
   property GetValueSearchSubstringForName: string read fSearchSubstringForName;

   property SetValueInitiatorOwner: string write fInitiatorOwner;
   property SetValueInitiatorOwnerParent: string write fInitiatorOwnerParent;
   property SetValueObjectsGroup: string write fObjectsGroup;
   property SetValuePeriodBeginCreating: TDatetime write fPeriodCreatingBegin;
   property SetValuePeriodEndCreating: TDatetime write fPeriodCreatingEnd;
   property SetValuePeriodBeginParentObjectCreating: TDatetime write fPeriodCreatingBeginParentObject;
   property SetValuePeriodEndParentObjectCreating: TDatetime write fPeriodCreatingEndParentObject;

   property SetValueFullOrderListStates: TFilterState write fFullOrderListStates;

   property GetSectionForINIFile: string read fSectionForINIFile;
   property SetSectionForINIFile: string write fSectionForINIFile;

   procedure ReadValuesFromIniFile(Sender: TObject); virtual;
   procedure WriteValuesToIniFile(Sender: TObject); virtual;

  end;

  TFilterForStoreObjects = class (TFilterForObjects)
  published
   constructor Create();  //--- В конструкторе задается начальное значение "Выкл"
  private
    { Private declarations }
  public
    { Public declarations }
   procedure ReadValuesFromIniFile(Sender: TObject); override;
   procedure WriteValuesToIniFile(Sender: TObject); override;

  end;

  TTreeItem = record
   IdObjectItem: TIdDocumentItem;
   IdTopNode: TIdDocumentItem;
   IdParent: TIdDocumentItem;
   TreeItemIndex: integer;
  end;

  TTreeItemArray = array[1..maxObjectItemsCount_Manufacturing] of TTreeItem;


  TDSPositionSaver = class
  published
   constructor Create();  //--- В конструкторе задается начальное значение iArrayNum
  private
   iArrayNum: integer;
   ArraySavingPosition: array[1..maxSavingArrayValues] of integer;
   ArraySavingDS: array[1..maxSavingArrayValues] of string;
  public
   function SavePosition(TargetDS: TDataset): TIdDSPositionSaver;
   procedure RestorePosition(TargetDS: TDataset; TargetArrayIndex: integer);
  end;

  TJobItemParameter = class
  published
   constructor Create();  //--- В конструкторе задаются начальные значения TJobItemParameterEnumerate из базы данных
  private
    JobItemName: string;
    IsDoneCondition: boolean;
    DoneConditionResult: boolean;
    IsDoneResolution: boolean;
    DoneResolution: array[1..maxResolutionValues] of string;
    IsActive: boolean;
    ConditionDependenceResult: boolean;
    IsDone: boolean;
  public
   procedure GetJobItem(Target: TDataset; TargetArrayIndex: integer);
  end;

var
  E: Exception;
  RecordsetEvent: TRecordsetEvent;
  bIsAuthenticationDone: boolean = false;
  bUseDefaultRouteForCurrentInitiator:  boolean = true;

  bCtrlWasPressed: boolean = false;
  mainServerName: string;
  mainDataBaseName: string;
  mainUserName: string;
  mainAuthentication: string;

  iniFile: TIniFile;
  logFile: TextFile;
  SP_Text, F_Text: TextFile;
  formMain_Handle: THandle;
  formCurrentActive: string = 'formEditOrder';

  MessageBox_ResultText: string;

var
  lastCursor: TCursor;
  xposMouse, yposMouse: integer;
  ProcessItemCheckData: TProcessItemCheckData;

  ObjectTypeForShow: string = 'all';

  CurrentHierarchicalView: TTargetHierarchivalView;
  CurrentHierarchicalJobStatus: THierarchivalJobStatus;
  CurrentDocument: TDocument;
  CurrentDocumentItem: TDocumentItem;
  CurrentDocumentItem_Tree: TDocumentItem_Tree;
  CurrentTemplateProcess: TProcess;
  CurrentTemplateProcessItem: TProcessItem;
  CurrentJobItemTemplate: TJobItem;

  CurrentUser: TUser;
  CurrentSprav: TSprav;
  CurrentSpravObject: TSpravObject;
  CurrentStoreObject: TStoreObject;

  FilterForOrders: TFilterForObjects;
  FilterForStoreObjects: TFilterForStoreObjects;
//  CurrentActiveTreeView: TTreeView;  //--- Показывает активное на данный момент окно Входящие или Исходящие
  CurrentActiveQueryDocumentItem: TADOQuery;  //--- Показывает активный на данный момент Item's Dataset - MTR или Manufacturing/Repairing
  CurrentActiveObject: TCurrentActiveObject;//--- Показывает какое "окно" активно на данный момент - сам Object или ObjectItem
  TargetDocumentType: TDocumentType;
  DocumentTypeList: TVariantArray; // --- Значения заливаются из базы в InitializeVariables;

  CodeOfProcessStatus: TVariantArray;      //--- Заполняется из таблицы sprProcessStatus в InitializeVariables
  CurrentTreeItems: TTreeItemArray;

  DSPositionSaver: TDSPositionSaver;

  bCanEditData: boolean = false;     //--- Используется в формах, где предполагается редактирование
{
  bConfirmDocument_Action: boolean = false;     //--- Используется в формах, где предполагается выполнение "Действия"
  bDenyDocument_Action: boolean = false;     //--- Используется в формах, где предполагается выполнение "Действия"
  bAlteringDocument_Action: boolean = false;     //--- Используется в формах, где предполагается выполнение "Действия"
  bConfirmOrderItem_Action: boolean = false;     //--- Используется в формах, где предполагается выполнение "Действия"
  bDenyOrderItem_Action: boolean = false;     //--- Используется в формах, где предполагается выполнение "Действия"
  bAlteringOrderItem_Action: boolean = false;     //--- Используется в формах, где предполагается выполнение "Действия"
}
  ShowProcessFilter: TObjectShowStatus = ossActiveOnly; {будут отображаться только активные маршруты, если 0 - активные и удаленные}
  InitialDirForAttachingFile: string;


  CurrentFileName_SP_Text, CurrentFileName_F_Text: string;

  JobDocumentItem: TJobDocumentItem;
  JobItemParameter: TJobItemParameter;

procedure InitializeVariables;
procedure DeinitializeVariables;
procedure InitializeVariablesAfterDBConnections;


implementation
uses unDM, unDBUtil, unUtilCommon;

procedure InitializeVariables;
var
  strTmp: string;
  i: integer;
begin
try
 try
  strTmp:= Copy(ExtractFileName(Application.ExeName), 1, Pos('.', ExtractFileName(Application.ExeName)) - 1);
  CreateDir(GetEnvironmentVariable('APPDATA') + '\' + strTmp);
  strTmp:= GetEnvironmentVariable('APPDATA') + '\' + strTmp;
  AssignFile(logFile, strTmp + '\' + ExtractFileName(ChangeFileExt(Application.ExeName, '.log' )));
  if FileExists(strTmp) then Append(logFile) else Rewrite(logFile);

  CurrentFileName_SP_Text:= strTmp + '\' + FileName_SP_Text;
  AssignFile(SP_Text, strTmp + '\' + 'SP_Text.sql');
  CurrentFileName_F_Text:= strTmp + '\' + FileName_F_Text;
  AssignFile(F_Text, strTmp + '\' + 'F_Text.sql');

 finally
 end;
 iniFile:= TIniFile.Create(strTmp + '\' + ExtractFileName(ChangeFileExt(Application.ExeName, '.ini' )));
// ProcessStatusArray:= TProcessStatusArray.Create();
// CurrentHierarchicalJobView:= THierarchicalJobView.Create();
 CurrentDocument:= TDocument.Create();
 CurrentDocumentItem:= TDocumentItem.Create();
 CurrentDocumentItem_Tree:= TDocumentItem_Tree.Create();
 CurrentDocumentItem.Attachments:= TAttachment.Create();
 CurrentTemplateProcessItem:= TProcessItem.Create();

 CurrentUser:= TUser.Create();
 CurrentSprav:= TSprav.Create();
 CurrentSpravObject:= TSpravObject.Create();
 CurrentTemplateProcess:= TProcess.Create();
 CurrentTemplateProcessItem:= TProcessItem.Create();
 FilterForOrders:= TFilterForObjects.Create();
 FilterForOrders.SetSectionForINIFile:= INISectionForOrderFilterState;
 FilterForStoreObjects:= TFilterForStoreObjects.Create();
 FilterForStoreObjects.SetSectionForINIFile:= INISectionForObjectFilterState;
 CurrentStoreObject:= TStoreObject.Create();
 DSPositionSaver:= TDSPositionSaver.Create();

 InitialDirForAttachingFile:= iniFile.ReadString('MainForm Settings', 'Miscellaneous', 'D:\');
except
end;
end;

procedure InitializeVariablesAfterDBConnections;
begin
try
 FillArrayFromQuery(DocumentTypeList,  'exec sp_GetSpravDocumentType', queryFieldName_SpravCode);
// FillArrayFromQuery(CodeOfProcessStatus, 'exec sp_GetSpravProcessStatus', queryFieldName_SpravCode);
// FillArrayFromQuery(NameOfProcessStatus, 'exec sp_GetSpravProcessStatus', queryFieldName_SpravShortName);
except
end;
end;

procedure DeinitializeVariables;
begin
 if Assigned(iniFile) then iniFile.Free;
// if Assigned(CurrentHierarchicalJobView) then CurrentHierarchicalJobView.Free;
 if Assigned(CurrentDocument) then CurrentDocument.Free;
 if Assigned(CurrentDocumentItem) then CurrentDocumentItem.Free;
 if Assigned(CurrentDocumentItem_Tree) then CurrentDocumentItem_Tree.Free;
 if Assigned(CurrentUser) then CurrentUser.Free;
 if Assigned(CurrentSprav) then CurrentSprav.Free;
 if Assigned(CurrentSpravObject) then CurrentSpravObject.Free;
 if Assigned(CurrentTemplateProcess) then CurrentTemplateProcess.Free;
 if Assigned(CurrentTemplateProcessItem) then CurrentTemplateProcessItem.Free;
 if Assigned(FilterForOrders) then FilterForOrders.Free;
 if Assigned(CurrentStoreObject) then CurrentStoreObject.Free;
 if Assigned(FilterForStoreObjects) then FilterForStoreObjects.Free;

 try
  CloseFile(logFile);
 finally
 end;
end;

{
constructor TProcessStatusArray.Create();
begin
 inherited;
end;
}
{
constructor THierarchicalJobView.Create();
begin
 inherited;
end;
}
constructor TDocument.Create();
begin
 inherited;
 FieldNameForIdDocument:= queryFieldName_DocumentId;
end;

constructor TDocumentItem.Create();
begin
 inherited;
 FieldNameForIdOrderItem:= queryFieldName_DocumentItemId;
end;

constructor TDocumentItem_Tree.Create();
begin
 inherited;
// FieldNameForIdOrderItem:= queryFieldNameForIdOrderItem;
end;

constructor TAttachment.Create();
begin
 inherited;
end;

constructor TUser.Create();
begin
end;

constructor TSprav.Create();
begin
end;

constructor TSpravObject.Create();
begin
end;

constructor TProcess.Create();
begin
end;

constructor TProcessItem.Create();
begin
end;

constructor TJobItem.Create();
begin
end;

constructor TStoreObject.Create();
begin
 inherited;
end;

constructor TFilterForObjects.Create();
begin
 inherited;
 State:= fsOff;
end;

constructor TFilterForStoreObjects.Create();
begin
 inherited;
 State:= fsOff;
end;

constructor TDSPositionSaver.Create();
var
  i: integer;
begin
 for i:= 1 to maxSavingArrayValues do
 begin
  ArraySavingPosition[i]:= 0;
  ArraySavingDS[i]:= '';
 end;
 iArrayNum:= 0;
end;

constructor TJobItemParameter.Create();
begin
end;

procedure TFilterForObjects.ReadValuesFromIniFile(Sender: TObject);
var
  TargetFilterObj: TFilterForObjects;
  TargetINISection: string;
begin
 TargetFilterObj:= (Sender as TFilterForObjects);
 TargetINISection:= TargetFilterObj.GetSectionForINIFile;
 if iniFile.ReadBool(TargetINISection, 'FilterState', false) then
  TargetFilterObj.SetState:= fsOn
 else TargetFilterObj.SetState:= fsOff;

 if iniFile.ReadBool(TargetINISection, 'FilterState_InitiatorOwner', false) then
  TargetFilterObj.SetStateInitiatorOwner:= fsOn
 else TargetFilterObj.SetStateInitiatorOwner:= fsOff;

 TargetFilterObj.SetValueInitiatorOwner:= iniFile.ReadString(TargetINISection, 'Filter_InitiatorOwnerText', '');


 if iniFile.ReadBool(TargetINISection, 'FilterState_ObjectGroup', false) then
  TargetFilterObj.SetStateObjectsGroup:= fsOn
 else TargetFilterObj.SetStateObjectsGroup:= fsOff;

 TargetFilterObj.SetValueObjectsGroup:= iniFile.ReadString(TargetINISection, 'Filter_ObjectGroupText', '');

 if iniFile.ReadBool(TargetINISection, 'FilterState_Period', false) then
  TargetFilterObj.SetStatePeriodCreating:= fsOn
 else TargetFilterObj.SetStatePeriodCreating:= fsOff;

 TargetFilterObj.SetValuePeriodBeginParentObjectCreating:= iniFile.ReadDate(TargetINISection, 'Filter_PeriodBeginParentObject_Creating', Date());
 TargetFilterObj.SetValuePeriodEndParentObjectCreating:= iniFile.ReadDate(TargetINISection, 'Filter_PeriodEndParentObject_Creating', Date());

 TargetFilterObj.SetValuePeriodBeginCreating:= iniFile.ReadDate(TargetINISection, 'Filter_PeriodBegin_Creating', Date());
 TargetFilterObj.SetValuePeriodEndCreating:= iniFile.ReadDate(TargetINISection, 'Filter_PeriodEnd_Creating', Date());

// bUseDefaultRouteForCurrentInitiator:= iniFile.ReadBool('MainForm Settings', 'UseDefaultRouteForNewOrder', true);

 if iniFile.ReadBool(TargetINISection, 'Filter_cbFullOrderListStates', true) then
  TargetFilterObj.SetValueFullOrderListStates:= fsOn
 else TargetFilterObj.SetValueFullOrderListStates:= fsOff;

end;

procedure TFilterForObjects.WriteValuesToIniFile(Sender: TObject);
var
  TargetFilterObj: TFilterForObjects;
  TargetINISection: string;
begin
 TargetFilterObj:= (Sender as TFilterForObjects);
 TargetINISection:= TargetFilterObj.GetSectionForINIFile;
 if TargetFilterObj.GetState = fsOn then
  begin
   iniFile.WriteBool(TargetINISection, 'FilterState', true);
  end
 else iniFile.WriteBool(TargetINISection, 'FilterState', false);

 if TargetFilterObj.GetStateInitiatorOwner = fsOn then
  begin
   iniFile.WriteBool(TargetINISection, 'FilterState_InitiatorOwner', true);
  end
 else iniFile.WriteBool(TargetINISection, 'FilterState_InitiatorOwner', false);
 iniFile.WriteString(TargetINISection, 'Filter_InitiatorOwnerText', TargetFilterObj.GetValueInitiatorOwner);

 if TargetFilterObj.GetStateObjectsGroup = fsOn then
  begin
   iniFile.WriteBool(TargetINISection, 'FilterState_ObjectGroup', true);
  end
 else    iniFile.WriteBool(TargetINISection, 'FilterState_ObjectGroup', false);
 iniFile.WriteString(TargetINISection, 'Filter_ObjectGroupText', TargetFilterObj.GetValueObjectsGroup);

 if TargetFilterObj.GetStatePeriodCreating = fsOn then
  begin
   iniFile.WriteBool(TargetINISection, 'FilterState_Period', true);
  end
 else iniFile.WriteBool(TargetINISection, 'FilterState_Period', false);

 iniFile.WriteDate(TargetINISection, 'Filter_PeriodBegin_Creating', TargetFilterObj.GetValuePeriodBeginCreating);
 iniFile.WriteDate(TargetINISection, 'Filter_PeriodEnd_Creating', TargetFilterObj.GetValuePeriodEndCreating);

end;


procedure TFilterForStoreObjects.ReadValuesFromIniFile(Sender: TObject);
var
  TargetFilterObj: TFilterForObjects;
  TargetINISection: string;
begin
 inherited;
 TargetFilterObj:= (Sender as TFilterForObjects);
 TargetINISection:= TargetFilterObj.GetSectionForINIFile;

 TargetFilterObj.SetValuePeriodBeginParentObjectCreating:= iniFile.ReadDate(TargetINISection, 'Filter_PeriodBeginParentObject_Creating', Date());
 TargetFilterObj.SetValuePeriodEndParentObjectCreating:= iniFile.ReadDate(TargetINISection, 'Filter_PeriodEndParentObject_Creating', Date());
end;


procedure TFilterForStoreObjects.WriteValuesToIniFile(Sender: TObject);
var
  TargetFilterObj: TFilterForObjects;
  TargetINISection: string;
begin
 inherited;
 TargetFilterObj:= (Sender as TFilterForObjects);
 TargetINISection:= TargetFilterObj.GetSectionForINIFile;
 iniFile.WriteDate(TargetINISection, 'Filter_PeriodBeginParentObject_Creating', TargetFilterObj.GetValuePeriodBeginParentObjectCreating);
 iniFile.WriteDate(TargetINISection, 'Filter_PeriodEndParentObject_Creating', TargetFilterObj.GetValuePeriodEndParentObjectCreating);
end;

function TDSPositionSaver.SavePosition(TargetDS: TDataset): integer;
var
  curRecordPos: integer;
begin
result:= -1;
try
 curRecordPos:= TargetDS.RecNo;
 if iArrayNum < maxSavingArrayValues then iArrayNum:= iArrayNum + 1
                                    else exit;
 ArraySavingPosition[iArrayNum]:= curRecordPos;
 ArraySavingDS[iArrayNum]:= TargetDS.GetNamePath;
 result:= iArrayNum;
except
 result:= -1;
end;
end;

procedure TDSPositionSaver.RestorePosition(TargetDS: TDataset; TargetArrayIndex: integer);
var
  curRecordPos: integer;
begin
 if TargetDS.GetNamePath <> ArraySavingDS[TargetArrayIndex] then exit;
  curRecordPos:= ArraySavingPosition[TargetArrayIndex];
  if curRecordPos > 0 then
   if curRecordPos <= TargetDS.RecordCount then TargetDS.RecNo:= curRecordPos;

 ArraySavingPosition[TargetArrayIndex]:= 0;
 ArraySavingDS[TargetArrayIndex]:= '';
 if iArrayNum = TargetArrayIndex then iArrayNum:= iArrayNum - 1;
end;


{
function TProcessStatusArray.GetProcessStatusSFromDB(Sender: TProcessStatusArray): boolean;
var
  tmpQuery: TADOQuery;
  i: word;
begin
 try
  result:= false;
  1
  for i:= 1 to ProcessStatusCount do InputArray[i]:= '';
  tmpQuery:= MakeQueryWithParam1AsString(InputSQLText, inputParam1);
  with tmpQuery do
  begin
   Open();
   i:= 0;
   while not EOF do
   begin
    i:= i + 1;
    InputArray[i]:= FieldByName(InputField).AsString;
    next;
   end;
  end;



  (Sender as TProcessStatusArray).Name:= inputNameProcessStatus;
  (Sender as TProcessStatusArray).Code:= GetProcessStatusCode(inputNameProcessStatus);
  result:= true;
 except
  result:= false;
 end;
end;
}

{
function THierarchicalJobView.SetCurrent(Sender: THierarchicalJobView; inputJobName: string): boolean;
var
  tmpInt: integer;
begin
 try
  result:= false;
  (Sender as THierarchicalJobView).Name:= inputJobName;
  (Sender as THierarchicalJobView).Code:= GetJobCode_byName(inputJobName, TargetDocumentType);
  result:= true;
 except
  result:= false;
 end;
end;
}

function TDocument.SetCurrent(inputDocument, inputDocumentItem: TDataset): boolean;
var
  tmpInt: integer;
begin
 try
  result:= false;
  if not VarIsNull(inputDocument.FieldByName(queryFieldName_DocumentId).Value) then
    CurrentDocument.IdDocument:= inputDocument.FieldByName(queryFieldName_DocumentId).Value
   else
   begin
    CurrentDocument.IdDocument:= -1;
    CurrentDocument.IdSelectedItem:= -1;
//    CurrentDocument.DocumentType:= dtAll;
    CurrentDocument.DocumentNum:= '';
    CurrentDocument.Notes:= '';
    CurrentDocument.CreatorOwner:= '';
    CurrentDocument.ExecutionDate:= 0;
    CurrentDocument.CreationDate:= 0;
    CurrentDocument.ExecutionDateAsString:= '';
    CurrentDocument.DocumentStatus:= dsUndeclared;
    CurrentDocument.ShortName:= '';
    exit;
   end;
  if not VarIsNull(inputDocument.FieldByName(queryFieldName_DocumentType).Value) then
   CurrentDocument.DocumentType:= inputDocument.FieldByName(queryFieldName_DocumentType).Value;
  CurrentDocument.DocumentNum:= inputDocument.FieldByName(queryFieldName_DocumentNum).AsString;
  CurrentDocument.Notes:= inputDocument.FieldByName(queryFieldName_DocumentNote).AsString;
  CurrentDocument.ShortName:= inputDocument.FieldByName(queryFieldName_DocumentShortName).AsString;
  CurrentDocument.CreatorOwner:= inputDocument.FieldByName(queryFieldName_DocumentCreator).AsString;
  CurrentDocument.ExecutionDate:= inputDocument.FieldByName(queryFieldName_DocumentExecutionDate).AsDatetime;
  CurrentDocument.CreationDate:= inputDocument.FieldByName(queryFieldName_DocumentCreationDate).AsDatetime;
  CurrentDocument.ExecutionDateAsString:= FormatDateTime('dd.mm.yyyy', CurrentDocument.ExecutionDate);
  CurrentDocument.DocumentStatus:= inputDocument.FieldByName(queryFieldName_DocumentStatus).Value;
  CurrentDocument.CurrentProcessItem:= GetMinProcessItem_Document(CurrentDocument.IdDocument);

{
  tmpInt:= inputDocument.FieldByName(queryFieldName_JobCode).AsInteger;
  if tmpInt <> 0 then
   if not VarIsNull(inputDocument.FieldByName(queryFieldName_JobCode).Value) then CurrentDocument.JobId:= inputDocument.FieldByName(queryFieldName_JobId).Value;
}
  if inputDocumentItem.Active then
  begin
   CurrentDocument.IdSelectedItem:= GetFirstDocumentItem(CurrentDocument.IdDocument); //--- inputDocumentItem.FieldByName(queryFieldName_DocumentItemId).AsInteger
//   CurrentDocumentItem.SetCurrent(inputDocumentItem);
  end
  else CurrentDocument.IdSelectedItem:= -1;

  result:= true;
 except
  result:= false;
 end;
end;

function TDocument.SetCurrentByIdDocument(IdDocument: TIdDocument): boolean;
begin
  result:=false;
  dmDB.dsDocument.DataSet.RecNo:= FindPositionInDatasetBy(dmDB.dsDocument.DataSet, CurrentDocument.GetQueryFieldNameForIdDocument, IdDocument);
  result:= true;
end;

function TDocumentItem.SetCurrent(inputDocumentItemId: TId): boolean;
begin
 try
  result:= false;
  Execute_SP('sp_GetDocumentItemInfo_MTR', dmDB.QCommon, inputDocumentItemId);
  with dmDB.QCommon do
  begin
   CurrentDocumentItem.Id:= FieldByName(queryFieldName_DocumentItemId).AsInteger;
   CurrentDocument.IdSelectedItem:= CurrentDocumentItem.Id;

   CurrentDocumentItem.Process:= FieldByName(queryFieldName_ProcessId).AsInteger;
   CurrentDocumentItem.ProcessItem:= FieldByName(queryFieldName_ProcessItemId).AsInteger;
   CurrentDocumentItem.CurrentProcessItem:= FieldByName(queryFieldName_ProcessItemLevel).AsInteger;
   CurrentDocumentItem.IdDocumentOwner:= FieldByName(queryFieldName_DocumentId).AsInteger; //CurrentOrder.IdDocument;
   CurrentDocumentItem.ObjectsGroup:= FieldByName(queryFieldName_SpravObjectGroupName).AsString;
   CurrentDocumentItem.ShortName:= FieldByName(queryFieldName_SpravShortName).AsString;
   CurrentDocumentItem.FullName:= FieldByName(queryFieldName_SpravFullName).AsString;
   CurrentDocumentItem.MeasurementUnit:= FieldByName(queryFieldName_MeasurmentUnitNameObjectManufacture).AsString;
   CurrentDocumentItem.Notes:= FieldByName('Notes').AsString;
   CurrentDocumentItem.CreatorOwner:= FieldByName(queryFieldName_DocumentCreator).AsString;
   CurrentDocumentItem.Volume:= FieldByName('Volume').AsInteger;
   CurrentDocumentItem.CreationDate:= FieldByName(queryFieldName_DocumentCreationDate).AsDatetime;
//  CurrentOrdersItem.ExpirationDate:= inputOrderItem.FieldByName('ExpirationDate').AsDatetime;
//  if inputDocumentItem.FieldByName(queryFieldName_ItemActionCode).Value <> Null then
//   CurrentDocumentItem.ItemState:= inputDocumentItem.FieldByName(queryFieldName_ItemActionCode).Value
//  else
//   CurrentDocumentItem.ItemState:= oisNormal;
   if Active then CurrentDocument.IdSelectedItem:= FieldByName(queryFieldName_DocumentItemId).AsInteger
                            else CurrentDocument.IdSelectedItem:= 1;
   Attachments.ClearAttachment;
   CurrentDocumentItem.SetAttachmentsCount:= GetAttachmentForDocumentItem(CurrentDocumentItem.Id, CurrentDocumentItem.Attachments);
   result:= true;
   formMain.StatusBar1.Panels[3].Text:= 'Doc: ' + IntToStr(CurrentDocumentItem.IdDocumentOwner) + '; Item: ' + IntToStr(CurrentDocumentItem.Id)
                                        + '; (P: ' + IntToStr(CurrentDocumentItem.Process)+ '; PI: ' + IntToStr(CurrentDocumentItem.ProcessItem) + ';)';
  end;
 except
  result:= false;
 end;
end;

function TDocumentItem.SetCurrentByIdDocumentItem(IdDocumentItem: TIdDocumentItem): boolean;
var
  iRecPosition: integer;
begin
 try
  result:=false;
  if IdDocumentItem < 1 then exit;
  iRecPosition:= FindPositionInDatasetBy(dmDB.dsDocumentItem.DataSet, queryFieldName_DocumentItemId, IdDocumentItem);
  if iRecPosition <> -1 then
  begin
   dmDB.dsDocumentItem.DataSet.RecNo:= iRecPosition;
   result:= true;
  end;
 except
  result:= false;
 end;
end;

procedure TJobItemParameter.GetJobItem(Target: TDataset; TargetArrayIndex: integer);
begin
 try
 except
 end;
end;


function TDocumentItem_Tree.SetCurrent(inputTreeItem: TTreeNode): boolean;
begin
 try
  result:= false;
  CurrentDocument.IdSelectedItem:= ConvertPointerToIdObjectItem(inputTreeItem.Data);
  ExecuteObjectItemInfoQuery_Manufacturing(CurrentDocument.IdSelectedItem);
  CurrentDocumentItem_Tree.Id:= dmDB.QCommon.FieldByName('IdDocumentItem').AsInteger;
  CurrentDocument.IdSelectedItem:= CurrentDocumentItem_Tree.Id;
  CurrentDocumentItem_Tree.IdDocumentOwner:= dmDB.QCommon.FieldByName('IdDocument').AsInteger; //CurrentOrder.IdDocument;
  if dmDB.QCommon.FieldByName(queryFieldName_ParentIdObjectManufacture).Value <> Null then
   CurrentDocumentItem_Tree.IdParent:= dmDB.QCommon.FieldByName('IdParent').AsInteger
  else
   CurrentDocumentItem_Tree.IdParent:= 0;
  CurrentDocumentItem_Tree.ShortName:= dmDB.QCommon.FieldByName('ShortName').AsString;
  CurrentDocumentItem_Tree.FullName:= dmDB.QCommon.FieldByName('FullName').AsString;
  CurrentDocumentItem_Tree.MeasurementUnit:= dmDB.QCommon.FieldByName('MeasurmentUnitName').AsString;
  CurrentDocumentItem_Tree.Notes:= dmDB.QCommon.FieldByName('Notes').AsString;
  CurrentDocumentItem_Tree.CreatorOwner:= dmDB.QCommon.FieldByName('CreatorOwnerName').AsString;
  CurrentDocumentItem_Tree.Volume:= dmDB.QCommon.FieldByName('Volume').AsInteger;
  CurrentDocumentItem_Tree.CreationDate:= dmDB.QCommon.FieldByName('CreationDate').AsDatetime;
//  CurrentOrdersItem.ExpirationDate:= inputOrderItem.FieldByName('ExpirationDate').AsDatetime;
{
  if dmDB.QOrdersItems.FieldByName(queryFieldNameForItemActionCode).Value <> Null then
   CurrentOrdersItem.ItemState:= inputOrderItem.FieldByName(queryFieldNameForItemActionCode).Value
  else
   CurrentOrdersItem.ItemState:= oisNormal;
  Attachments.ClearAttachment;
  CurrentOrdersItem.SetAttachmentsCount:= GetAttachmentsForOrderItem(CurrentOrdersItem.Id, CurrentOrdersItem.Attachments);
  if inputOrderItem.Active then CurrentOrder.IdSelectedItem:= inputOrderItem.FieldByName(queryFieldNameForIdDocumentItem).AsInteger
                           else CurrentOrder.IdSelectedItem:= 1;
}

  result:= true;
  formMain.StatusBar1.Panels[3].Text:= 'Doc: ' + IntToStr(CurrentDocument.IdDocument) + '; Item: ' + IntToStr(CurrentDocument.IdSelectedItem)
                                       + '; (P: ' + IntToStr(CurrentDocumentItem.Process)+ '; PI: ' + IntToStr(CurrentDocumentItem.ProcessItem) + ';)';
 except
  result:= false;
 end;
end;

function TDocumentItem_Tree.SetCurrentByIdDocumentItem(IdDocumentItem: TIdDocumentItem): boolean;
begin
 try
  result:=false;
  dmDB.dsDocumentItem.DataSet.RecNo:= FindPositionInDatasetBy(dmDB.dsDocumentItem.DataSet, queryFieldName_DocumentItemId, IdDocumentItem);
 except
  result:= true;
 end;
end;

function TUser.SetCurrent(inputLoginName: String): boolean;
var
  i: integer;
  tmpProgramRoles: TProgramRoles;
begin
 try
  result:= false;
  GetUserInfo(inputLoginName);
  IdUser:= dmDB.QCommon.FieldByName(queryFieldName_UserId).AsInteger;
  ShortName:= dmDB.QCommon.FieldByName(queryFieldName_SpravShortName).AsString;
  FullName:= dmDB.QCommon.FieldByName(queryFieldName_SpravFullName).AsString;
  Notes:= dmDB.QCommon.FieldByName(queryFieldName_SpravNotes).AsString;
  IdJobRole:= dmDB.QCommon.FieldByName(queryFieldName_JobRoleId).AsInteger;
  JobRoleName:= dmDB.QCommon.FieldByName(queryFieldName_JobRoleName).AsString;
  result:= true;
 except
  result:= false;
 end;
end;

function TUser.GetProgramRoles(): TProgramRoles;
begin
 result:= CurrentUser.ProgramRoles;
end;

function TUser.SetProgramRoles(): boolean;
begin
try
 ProgramRoles:= GetProgramRolesForCurrent(CurrentUser.GetLoginName, CurrentDocument.IdDocument);
 result:= true;
except
 result:= false;
end;
end;

function TSprav.SetCurrent(inputSpravTableName: string): boolean;
begin
 try
  result:= false;
{
  GetSpravFullName(inputSpravTableName, dmDB.QCommon);
  if dmDB.QCommon.FieldByName(queryFieldName_FullName).Value <> Null then
   FullName:= dmDB.QCommon.FieldByName(queryFieldName_SpravFullName).AsString;
  else
   FullName:= '';
}
  ShortName:= inputSpravTableName;
 except
  result:= false;
 end;
end;

function TSpravObject.SetCurrent(inputSpravTableName: string; inputId: TId): boolean;
var
  i: integer;
begin
 try
  result:= false;
{
  if inputSpravTableName = spravProductManufacturing then
   ExecQueryWithoutParam(dmDB.QCommon, 'exec sp_GetSpravProductManufacturing')
  else
   sQuery:= 'select * from ' + inputSpravTableName + ' Where id = ' + IntToStr(inputId);
}
  GetSpravData_byId(inputSpravTableName, inputId, dmDB.QCommon);

  if dmDB.QCommon.FieldByName(queryFieldName_SpravId).Value <> Null then
   IdSprav:= dmDB.QCommon.FieldByName(queryFieldName_SpravId).Value
  else
   IdSprav:= 0;
  if dmDB.QCommon.FieldByName(queryFieldName_SpravCode).Value <> Null then
   Code:= dmDB.QCommon.FieldByName(queryFieldName_SpravCode).Value
  else
   Code:= 0;
  ShortName:= dmDB.QCommon.FieldByName(queryFieldName_SpravShortName).AsString;
  FullName:= dmDB.QCommon.FieldByName(queryFieldName_SpravFullName).AsString;
  Notes:= dmDB.QCommon.FieldByName(queryFieldName_SpravNotes).AsString;
  result:= true;
  if inputSpravTableName = spravProcessList then
  begin
   DocumentType:= dmDB.QCommon.FieldByName(queryFieldName_SpravOrderType).Value;
  end;

  if inputSpravTableName = spravProductManufacturing then
  begin
   Execute_SP('sp_GetSpravMeasurementUnitById', dmDB.QCommon, dmDB.QCommon.FieldByName('MeasurementUnit').AsInteger);
   MeasurmentUnitShortName:= dmDB.QCommon.FieldByName('ShortName').AsString;
  end;
 except
  result:= false;
 end;
end;

function TProcess.SetCurrent(inputProcessId: TId): boolean;
begin
 try
  result:= false;
  ProcessId:= dmDB.dsProcessList.Dataset.FieldByName(queryFieldName_TemplateProcessId).AsInteger;
{
  if VarIsNull(inputRouteItem.FieldByName(queryFieldNameForRouteName).Value)  then CurrentRouteItem.RoutesName:= ''
            else CurrentRouteItem.RoutesName:= inputRouteItem.FieldByName(queryFieldNameForRouteName).Value;
  CurrentRouteItem.RoutesPositionLevel:= inputRouteItem.FieldByName(queryFieldNameForRoutePositionLevel).AsInteger;
  CurrentRouteItem.JobRoleCode:= inputRouteItem.FieldByName(queryFieldName_JobRoleCode).AsInteger;
  if VarIsNull(inputRouteItem.FieldByName(queryFieldNameForRoutePointName).Value) then CurrentRouteItem.RoutesPointsName:= ''
            else CurrentRouteItem.RoutesPointsName:= inputRouteItem.FieldByName(queryFieldNameForRoutePointName).Value;
  if VarIsNull(inputRouteItem.FieldByName(queryFieldName_JobRoleName).Value)  then CurrentRouteItem.JobPositionsName:= ''
            else CurrentRouteItem.JobPositionsName:= inputRouteItem.FieldByName(queryFieldName_JobRoleName).Value;

  if inputRouteItem.Active then CurrentRouteItem.IdSelectedItem:= inputRouteItem.FieldByName(queryFieldNameForIdRouteItem).AsInteger
                           else CurrentRouteItem.IdSelectedItem:= 1;
}

  result:= true;
 except
  result:= false;
 end;
end;

function TProcessItem.SetCurrent(inputProcessItemId: TId): boolean;
begin
 try
  result:= false;
  GetTemplateProcessItem_Info(inputProcessItemId);
  ProcessItemId:= dmDB.dsCommon.Dataset.FieldByName(queryFieldName_TemplateProcessItemId).AsInteger;
  ProcessItemLevel:= dmDB.dsCommon.Dataset.FieldByName(queryFieldName_ProcessItemLevel).AsInteger;
  ProcessItemName:= dmDB.dsCommon.Dataset.FieldByName(queryFieldName_ProcessItemName).AsString;
  result:= true;
 except
  result:= false;
 end;
end;

function TJobItem.SetCurrent(inputJobItemId: TId; inputDataType: TDataType): boolean;
begin
 try
  result:= false;
  case inputDataType of
   dtTemplate:
    GetTemplateJobItem(inputJobItemId);
   dtInstance:
    GetInstanceJobItem(inputJobItemId);
  end;
  Id:= dmDB.dsCommon.Dataset.FieldByName(queryFieldName_JobItemId).AsInteger;
  ProcessItem:= dmDB.dsCommon.Dataset.FieldByName(queryFieldName_TemplateProcessItemId).AsInteger;
  ItemLevel:= dmDB.dsCommon.Dataset.FieldByName(queryFieldName_JobItemLevel).AsInteger;

  if VarIsNull(EntireDocumentStatus) then
   EntireDocumentStatus:= dmDB.dsCommon.Dataset.FieldByName(queryFieldName_JobIsEntireDocument).AsBoolean
  else
   EntireDocumentStatus:= false;

  if VarIsNull(EDDStatus) then
   EDDStatus:= dmDB.dsCommon.Dataset.FieldByName(queryFieldName_JobIsEDD).AsBoolean
  else
   EDDStatus:= false;

  JobItemIdSprav:= dmDB.dsCommon.Dataset.FieldByName(queryFieldName_SpravJobItemId).AsInteger;
  JobItemIdName:= dmDB.dsCommon.Dataset.FieldByName(queryFieldName_SpravJobItemName).AsString;

  if VarIsNull(ActiveStatus) then
   ActiveStatus:= dmDB.dsCommon.Dataset.FieldByName(queryFieldName_JobIsActive).AsBoolean
  else
   ActiveStatus:= false;

  if VarIsNull(DoneStatus) then
   DoneStatus:= dmDB.dsCommon.Dataset.FieldByName(queryFieldName_JobIsDone).AsBoolean
  else
   DoneStatus:= false;

//  Resolution:= dmDB.dsCommon.Dataset.FieldByName(queryFieldName_JobDoneResolution).AsInteger;
//  ConditionDependence:= dmDB.dsCommon.Dataset.FieldByName(queryFieldName_JobConditionDependence).AsInteger;
  result:= true;
 except
  result:= false;
 end;
end;


function TAttachment.ClearAttachment: boolean;
var
  i: integer;
begin
 try
  result:= false;
//--- Обнуление всех массивов данных по Attachment ------
 for i:= 0 to maxAttachments do
 begin
  AttachmentId[i]:= 0;
  AttachmentName[i]:= '';
  AttachmentState[i]:= asIs;
 end;
//-------------------------------------------------------
  result:= true;
 except
  result:= false;
 end;
end;

function TAttachment.GetAttachmentId(inputAttachmentNumber: integer): TIdAttachment;
begin
 try
  result:= AttachmentId[inputAttachmentNumber];
 except
  result:= -1;
 end;
end;

function TAttachment.SetAttachmentId(inputAttachmentNumber: integer; inputAttachmentId: TIdAttachment): boolean;
begin
 try
  result:= false;
  AttachmentId[inputAttachmentNumber]:= inputAttachmentId;
 except
  result:= false;
 end;
end;

function TAttachment.GetAttachmentName(inputAttachmentNumber: integer): string;
begin
 try
  result:= AttachmentName[inputAttachmentNumber];
 except
  result:= '';
 end;
end;

function TAttachment.SetAttachmentName(inputAttachmentNumber: integer; inputAttachmentName: string): boolean;
begin
 try
  result:= false;
  AttachmentName[inputAttachmentNumber]:= inputAttachmentName;
 except
  result:= false;
 end;
end;

function TAttachment.GetAttachmentUNCFileName(inputAttachmentNumber: integer): string;
begin
 try
  result:= AttachmentUNCFileName[inputAttachmentNumber];
 except
  result:= '';
 end;
end;

function TAttachment.SetAttachmentUNCFileName(inputAttachmentNumber: integer; inputAttachmentUNCFileName: string): boolean;
begin
 try
  result:= false;
  AttachmentName[inputAttachmentNumber]:= inputAttachmentUNCFileName;
 except
  result:= false;
 end;
end;

function TAttachment.SetAttachmentState(inputAttachmentNumber: integer; inputAttachmentState: TAttachmentState): boolean;
begin
 try
  result:= false;
  AttachmentState[inputAttachmentNumber]:= inputAttachmentState;
 except
  result:= false;
 end;
end;

function TAttachment.GetAttachmentState(inputAttachmentNumber: integer): TAttachmentState;
begin
 try
  result:= AttachmentState[inputAttachmentNumber];
 except
  result:= asIs;
 end;
end;

function TStoreObject.SetCurrent(inputStoreObject: TDataset): boolean;
var
  tmpInt: integer;
begin
 try
  result:= false;
  IdStoreObject:= inputStoreObject.FieldByName(queryFieldName_IdStoreObject).AsInteger;
  if not VarIsNull(inputStoreObject.FieldByName(queryFieldName_IdParentOrderForStoreObject).Value) then
   IdParentDocument:= inputStoreObject.FieldByName(queryFieldName_IdParentOrderForStoreObject).Value;
  if not VarIsNull(inputStoreObject.FieldByName(queryFieldName_IdParentOrderItemForStoreObject).Value) then
   IdParentDocumentItem:= inputStoreObject.FieldByName(queryFieldName_IdParentOrderItemForStoreObject).Value;
 except
  result:= false;
 end;
end;

end.




