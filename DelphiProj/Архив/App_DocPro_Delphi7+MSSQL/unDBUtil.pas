unit unDBUtil;

interface
uses ComCtrls, Variants, DB, ADOdb, StdCtrls,
     Controls, SysUtils, Comobj {Для EOleException}, DateUtils,
     DBGrids, DBTables, Classes, Windows, Dialogs, ADOX_TLB,
     unVariable;

function isDBError(DBErrorNumber: DBError): boolean;
function IsAuthenticationDone(): boolean;

function FindPositionInDatasetBy(InputDataset: TDataset; findingFieldName: string; neededValue: Variant): integer;

function ExecuteObjectItemInfoQuery_Manufacturing(inpuTIdDocumentItem: TIdDocumentItem): TADOQuery;

function GetLogError(inputViewType: TLogViewType; inputBeginDate, inputEndDate: TDateTime): boolean;
function GetLogEvent(inputViewType: TLogViewType; inputBeginDate, inputEndDate: TDateTime): boolean;

function GetDocument_Input_byJob(inputJobName: string; inputSortingType: TOrdersSort; inputDocumentType: TDocumentType): boolean;
function GetDocument_Total_byJob(inputJobName: string; inputSortingType: TOrdersSort; inputDocumentType: TDocumentType): boolean;

function GetDocumentItem_MTR(inputDocumentId: TIdDocument): boolean;
function GetOrderItems_ObjectManufacturing(inpuTIdDocument: TIdDocument): boolean;
function GetObjectItems_Manufacturing(inputCurrentUser: string; inpuTIdDocumentItem: TIdDocumentItem): boolean;
function GetOrderItems_ObjectManufacturing_ForTreeView(inpuTIdDocument: TIdDocument): boolean;
//function GetObjectItems_Manufacturing(inputCurrentUser: string; inputOrderItemShortName: string): boolean;

function GetMinProcessItem_Document(inputDocumentId: TIdDocument): integer;

function GetJobNameProcessItem(inputDocumentId: integer): boolean;
function GetJobNameProcessItem_DocumentItem(inputDocumentItemId: integer): boolean;
function GetTemplateProcessList(): boolean;

function GetStoreObject_MTR({Все параметры задаются в фильтре}): boolean;
function ExecuteStoreObjectQuery_SearchByName(inputSearchTarget: string): boolean;

//------- functions ExecuteTrees...(inputCurrentUser: string): boolean;
function GetDocumentHierarchical_Input(inputDocumentType: TDocumentType): boolean;
function GetDocumentHierarchical_Total(inputDocumentType: TDocumentType): boolean;

function ExecQueryWithParam1AsString(InputSQLText: string = ''; inputParam1: string = ''): TADOQuery;

//function ExecuteRoutesListQuery(ShowDeletedRoutes: boolean = false): TADOQuery;
//function ExecuteRoutesListQuery_OnlyValid(inputParam1: integer = 0): TADOQuery;
//function ExecuteOrderRouteQuery(inputUser: string; inpuTIdDocument: TIdDocument): TADOQuery;


function ExecuteProgramRoleListQuery(): TADOQuery;
function ExecuteCommentsForOrderQuery(inputCurrentUser: string; inputDocumentId: TIdDocument): boolean;
function GetCommentForDocument(inputDocumentId: TIdDocument): boolean;
function GetCommentForDocumentItem(inputDocumentItemId: TId): boolean;

function CreateTemplateProcess(inputProcessName: TProcessName; inputProcessFullName: TProcessName; inputNotes: string): TIdProcess;
function EditTemplateProcess(inputProcessId: TIdProcess; inputProcessName: TProcessName; inputProcessFullName: TProcessName; inputNotes: string; inputActiveStatus: TObjectShowStatus): boolean;
function DeleteTemplateProcess(inputProcessId: TIdProcess): boolean;

function CreateTemplateJobItem(inputProcessItemTemplate, inputJobItemLevel, inputJobItem: TId; inputActiveStatus, inputEntireDocumentStatus, inputEDDStatus: boolean; inputDoneCondition, inputDoneResolution, inputConditionDependence: TId; inputDoneResolutionText, inputNotes: string; inputDoneStatus: boolean): TIdProcess;
function EditTemplateJobItem(inputJobItemTemplateId, inputProcessItemTemplate, inputJobItemLevel, inputJobItem: TId; inputActiveStatus, inputEntireDocumentStatus, inputEDDStatus: boolean; inputDoneCondition, inputDoneResolution, inputConditionDependence: TId; inputDoneResolutionText, inputNotes: string;  inputDoneStatus: boolean): TIdProcess;

function GetTemplateProcessItem(inputTemplateProcessId: TId): boolean;
function GetTemplateProcessItem_Count(inputTemplateProcessId: TId): integer;
function GetTemplateProcessItem_Info(inputTemplateProcessItemId: TId): boolean;

function GetJobCode_byName(inputJobName: string; inputDocumentType: TDocumentType): TIdJob;
function GetJobItem_TemplateProcessItem_Document(inputTemplateProcessItemId: TId): boolean;
function GetJobItem_TemplateProcessItem_DocumentItem(inputTemplateProcessItemId: TId): boolean;
function GetJobProcessItem_MTR(inputDocumentItemId: TIdDocument): boolean;
function GetJobExistsStatus_Document(inputDocumentId: TIdDocument): TJobExistsStatus;
function GetJobExistsStatus_DocumentItem(inputDocumentItemId: TIdDocument): TJobExistsStatus;
function GetInstanceJobItem(inputJobItemId: TId): boolean;
function GetTemplateJobItem(inputTemplateJobItemId: TId): boolean;
function GetJobItemExtendExistsStatus_DocumentItem(inputDocumentItemId: TIdDocument): TJobExistsStatus;


function CreateDocument(inputDocumentTypeCode: TDocumentType; inputExecutionDate: TDateTime; inputShortName, inputNotes: string): boolean;
function EditDocument(inputDocumentId: TIdDocument; inputExecutionDate: TDateTime; inputNotes, inputDocumentShortName: string; inputDocumentNum: TDocumentNum): boolean;
function DeleteDocument(targetDocumentId: TIdDocument): boolean;

function CreateSpravItem(inputCurrentUser: string; inputSpravName: string; inputCode: word; inputShortName: string; inputFullName: string; inputNotes: string): boolean;
//function EditJobPosition(inpuTIdDocument: integer; inputExecutionDate: TDateTime; inputNotes: string; inputRoutesCode: integer = 0): boolean;
//function DeleteJobPosition(neededIdOrder: integer; inputCallerUserAsString: string): boolean;

function CreateDocumentItem_MTR(inputDocumentId: TIdDocument; inputObjectGroupId: TId; inputObjectName, inputObjectVolumeAsString: string; inputMeasurementUnitId: TId; inputNotes: string): longint;
function EditDocumentItem_MTR(inputDocumentItemId: TIdDocumentItem; inputObjectGroupId: integer; inputObjectName, inputObjectVolumeAsString: string; inputMeasurementUnitId: TId; inputNotes: string): boolean;
function DeleteOrdersItem_MTR(neededIdOrderItem: integer; inputCreatorOwner: string): boolean;
function GetFirstDocumentItem(inputDocumentId: TIdDocument): TIdDocumentItem;

//---------- В стадии разработки - пока только болванки скопированные с ...OrderItem ----------------------------------------------------
function CreateOrdersItem_ProductManufacturing(inpuTIdDocument: integer; inputCreatorOwner: string; inputIdSravProductManufacturing: TIdSpravObject; inputObjectVolumeAsInteger: integer; inputNotes: string; inputExecutionDate: TDateTime): longint;
//function EditOrdersItem_ProductManufacturing(inpuTIdDocument: integer; inpuTIdDocumentsItem: integer; inputCreatorOwner: string; inputObjectsGroups: integer; inputObjectName, inputObjectVolumeAsString: string; inputMeasurementsUnits: integer; inputNotes: string; inputExperationDate: TDateTime): boolean;
//function DeleteOrdersItem_ProductManufacturing(neededIdOrderItem: integer; inputCreatorOwner: string): boolean;
//---------------------------------------------------------------------------------------------------------------------------------------

//---------- В стадии разработки - пока только болванки скопированные с ...OrderItem ----------------------------------------------------
function CreateStoreObject(inputDocumentId: TIdDocument; inputDocumentItemId: TIdDocumentItem; inputObjectGroupId: integer; inputObjectShortName, inputObjectFullName, inputObjectVolumeAsString: string; inputMeasurementUnitId: integer; inputNotes: string; inputCreationDate: TDateTime): boolean;
//function EditStoreObject(inpuTIdDocument: integer; inpuTIdDocumentsItem: integer; inputCreatorOwner: string; inputObjectsGroups: integer; inputObjectName, inputObjectVolumeAsString: string; inputMeasurementsUnits: integer; inputNotes: string; inputExperationDate: TDateTime): boolean;
//function DeleteStoreObject(neededIdOrderItem: integer; inputCreatorOwner: string): boolean;
//---------------------------------------------------------------------------------------------------------------------------------------

//---------- В стадии разработки - пока только болванки скопированные с ...Order --------------------------------------------------------
function DocumentItem_AddAttachment(inputDocumentItemId: TIDDocument; inputCurrentUser: string; inputUNCFileName: string): boolean;
function RenameAttachmentForOrderItem(inpuTIdDocument: integer; inpuTIdDocumentsItem: integer; inputCurrentUser: string; inputAttachmentName: string; inputIdAttachment: TIdAttachment): boolean;
function DeleteAttachmentForOrderItem(inpuTIdDocument: integer; inpuTIdDocumentsItem: integer; inputCurrentUser: string; inputAttachmentName: string; inputIdAttachment: TIdAttachment): boolean;
function GetAttachment(inputDocumentItem: TId; inputAttachmentName: string; inputIdAttachment: TIdAttachment): boolean;
//---------------------------------------------------------------------------------------------------------------------------------------

//---------- Создание, редактирование, удаление  шаблонов Этапов Процессов --------------------------------------------------------------
function CreateTemplateProcessItem(inputProcessId: TId; inputItemLevel: integer; inputJob: TIdJob; inputJobRole: TIdJobRole; inputJobRoleType: TJobRoleType): boolean;
function DeleteTemplateProcessItem(inputProcessItemTemplateId: TId): boolean;
//---------------------------------------------------------------------------------------------------------------------------------------

//---------- Создание, редактирование, удаление пользователей --------------------------------------------------------
function EditUser(inputUserLogin: string; inputUserFIO: string; inputUserJobRoleCode: TIdJobRole; inputUserNotes: string): boolean;
function DeleteUser(inputCallerUser: string; inputUserLogin: string): boolean;
//---------------------------------------------------------------------------------------------------------------------------------------

function Document_ExecJob(inputDocumentId: TId; inputJobResult: TJobResult; inputNote: string = ''): boolean;
function DocumentItem_ExecJob(inputDocumentItemId: TId; inputJobResult: TJobResult; inputNote: string = ''): boolean;
function ExecuteDenyToOrdersItem(inputCurrentUser: string; inpuTIdDocument, inpuTIdDocumentsItem: TIdDocument; inputResolutionText: string): boolean;
function ExecuteAlterToOrdersItem(inputCurrentUser: string; inpuTIdDocument, inpuTIdDocumentsItem: TIdDocument; inputResolutionText: string): boolean;

function GetUserProgramRoleName(inputUser: string): String;
function GetUserFullNameByLogin(inputUser: string): String;

function GetTemplateProcessInvolvedStatus(inputTemplateProcessId: TIdProcess): boolean;//function Execute_SP(inputSPName: string; var outputADOQuery: TADOQuery; inputParam: variant): boolean;
function GetSpravData(inputSpravTableName: string; var outputADOQuery: TADOQuery): boolean;
function GetSpravData_byId(inputSpravName: string; inputId: TId; var outputADOQuery: TADOQuery): boolean;

function GetDataReport_MTR_ForBuying(inputObjectGroupCode: TIdSpravObject = 0): boolean;

function GetRoutePointForOrder(inputUser: string; inpuTIdDocument: integer): Integer;
function SwitchOnOffRoute(inputRouteCode: TRouteCode; inputCurrentUser: string): Boolean;

function GetServerStorageProcedures(): boolean;
function GetServerFunctiones(): boolean;
//function PutSP_Fn(inputUNCFileName: string): boolean;
function PutSP_FnToServer(var inputTextPointer: PChar): TSQLServerError;

function IsSP_FnExists(inputTargetSPName: string): boolean;

function GetUserInfo(inputUserLogin: string): boolean;
function GetUserList(): boolean;
function GetJobRole(inputUserId: TIdUser): boolean;
function GetJobRoleVirtual(inputUserId: TIdUser): boolean;

function GetSpravList(): boolean;

function GetTemplateJobItemLevelNext(inputProcessItemId: TId):TId;
function GetJobParameter(inputJobItemId: TId):boolean;

function GetEditStatus_Document(inputDocumentId: TId):boolean;
function GetEditStatus_DocumentItem(inputDocumentItemId: TId):boolean;

function GetCanChangeState_DocumentItem(inputDocumentItemId: TIdDocument): TCanChangeStatus;

{???????????????}function ExecuteUserInfoQuery(inputUserShortName: String): TADOQuery;
{???????????????}function ExecuteProgramRoleQuery(inputUserShortName: String; idOrder: TIdDocument): TADOQuery;

//------------------------------ Функции обертки -------------------------------------------------------
function Execute_SP(inputSPName: string; var outputADOQuery: TADOQuery; inputId: integer = 0): boolean;
//------------------------------------------------------------------------------------------------------


implementation
uses unDM, unConstant, unUtilCommon, unUtilFiles, unDMResources, unEditDocument;



function isDBError(DBErrorNumber: DBError): boolean;
begin
 Result:= false;
 isDBError:= (AllTrim(DBErrorNumber) = 'NDE-0000') or (AllTrim(DBErrorNumber) = '0');
end;

function IsAuthenticationDone(): boolean;
begin
try
 result:= bIsAuthenticationDone;
except
 Result:= false;
end;
end;



function GetDocumentHierarchical_Input(inputDocumentType: TDocumentType): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetDocumentHierarchical_Input(...)';
 Result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_GetProcessJob_Input';
  SQL.Text:= 'exec sp_GetProcessJob_Input :p_DocumentTypeAsInteger';
  Parameters.Clear;
//--------- Create parameter :p_OrderTypeAsInteger-----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_DocumentTypeAsInteger';
  Parameters[Parameters.Count-1].DataType:= ftInteger;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= ord(inputDocumentType);
//----------------------------------------------------------------------------------

  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;
end;

function GetDocumentHierarchical_Total(inputDocumentType: TDocumentType): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetDocumentHierarchical_Total(...)';
 Result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_GetProcessJob_Total';
  SQL.Clear;
  SQL.Text:= 'exec sp_GetProcessJob_Total :p_DocumentTypeAsInteger';
  Parameters.Clear;
//--------- Create parameter :p_DocumentTypeAsInteger-----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_DocumentTypeAsInteger';
  Parameters[Parameters.Count-1].DataType:= ftInteger;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= ord(inputDocumentType);
//----------------------------------------------------------------------------------


  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;
end;

function GetLogError(inputViewType: TLogViewType; inputBeginDate, inputEndDate: TDateTime): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetLogError(...)';
 Result:= false;
try
 with dmDB.QErrorLog do
 begin
  Close; //----- Параметры не обнулять!!!
  case inputViewType of
   byDateAll:
             begin
              SQL.Text:= 'exec sp_GetErrorLog_ByDate_All :p_ErrorBeginDate, :p_ErrorEndDate';
              strCurrentStoredProcName:= 'sp_GetErrorLog_ByDate_All';
             end;
  else
     begin
      SQL.Text:= 'exec sp_GetErrorLog_ByDate_All :p_ErrorBeginDate, :p_ErrorEndDate';
      strCurrentStoredProcName:= 'sp_GetErrorLog_ByDate_All';
     end;
  end;

  Parameters.Clear;
//--------- Create parameter :p_EventBeginDate-----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_ErrorBeginDate';
  Parameters[Parameters.Count-1].DataType:= ftString;//ftDateTime;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= FormatDateTime('yyyy-mm-dd', inputBeginDate);
//----------------------------------------------------------------------------------
//--------- Create parameter :p_EventEndDate-----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_ErrorEndDate';
  Parameters[Parameters.Count-1].DataType:= ftString;// ftDateTime;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= FormatDateTime('yyyy-mm-dd', inputEndDate);
//----------------------------------------------------------------------------------
  Open();
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

function GetLogEvent(inputViewType: TLogViewType; inputBeginDate, inputEndDate: TDateTime): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetLogEvent(...)';
 Result:= false;
try
 with dmDB.QEventLog do
 begin
  Close; //----- Параметры не обнулять!!!
  case inputViewType of
   byDateAll: SQL.Text:= 'exec sp_GetEventLog_ByDate_All :p_EventBeginDate, :p_EventEndDate';
  else SQL.Text:= 'exec sp_GetEventLog_ByDate_All';
  end;

  Parameters.Clear;
//--------- Create parameter :p_EventBeginDate-----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_EventBeginDate';
  Parameters[Parameters.Count-1].DataType:= ftDateTime;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputBeginDate;
//----------------------------------------------------------------------------------
//--------- Create parameter :p_EventEndDate-----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_EventEndDate';
  Parameters[Parameters.Count-1].DataType:= ftDateTime;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputEndDate;
//----------------------------------------------------------------------------------
  Open();
  Result:= true;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;


function GetDocument_Input_byJob(inputJobName: string; inputSortingType: TOrdersSort; inputDocumentType: TDocumentType): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetDocument_Input_byJob(...)';
 Result:= false;
try
with dmDB.QDocument do
begin
   Close();
   case FilterForOrders.GetState of
    fsOff: SQL.Text:= 'Exec sp_GetDocument_Input_byJob :p_TargetJobName, :p_TargetDocumentType, :p_TargetSortingType';
    fsOn:
     begin
      SQL.Text:= 'Exec sp_GetDocument_Input_byJob_Filter :p_TargetJobName, :p_TargetDocumentType, :p_TargetSortingType, ';
      SQL.Text:= SQL.Text + ':p_FilterOrderCreatorOwnerAsString, :p_FilterOrderPeriodBeginAsString, :p_FilterOrderPeriodEndAsString';
     end;
   end;

   Parameters.Clear;
//--------- Create parameter :p_TargetJobName --------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetJobName';
   Parameters[Parameters.Count-1].DataType:= ftString;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputJobName;
//------------------------------------------------------------------------------
//--------- Create parameter :p_TargetDocumentType --------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetDocumentType';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= 0; //ord(inputDocumentType);
//------------------------------------------------------------------------------
//--------- Create parameter :p_TargetSortingType -------------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetSortingType';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= 0; //ord(inputSortingType);
//------------------------------------------------------------------------------


//----------------- Фильтр надо приделать сюда... ---------------------------
 if FilterForOrders.GetState = fsOn then
 begin
  if FilterForOrders.GetStateInitiatorOwner = fsOn then
  begin
//--------- Create parameter :p_FilterOrderCreatorOwnerAsString ----------------
//   SQL.Text:= SQL.Text + ', :p_FilterOrderCreatorOwnerAsString';
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_FilterOrderCreatorOwnerAsString';
   Parameters[Parameters.Count-1].DataType:= ftString;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= FilterForOrders.GetValueInitiatorOwner;
//------------------------------------------------------------------------------
  end;

  if FilterForOrders.GetStatePeriodCreating = fsOn then
  begin
//--------- Create parameter :p_FilterOrderPeriodBeginAsString -----------------
//   SQL.Text:= SQL.Text + ', :p_FilterOrderPeriodBeginAsString';
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_FilterOrderPeriodBeginAsString';
   Parameters[Parameters.Count-1].DataType:= ftString;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= FormatDateTime('yyyy-mm-dd', FilterForOrders.GetValuePeriodBeginCreating);
//------------------------------------------------------------------------------
//--------- Create parameter :p_FilterOrderPeriodEndAsString -------------------
//   SQL.Text:= SQL.Text + ', :p_FilterOrderPeriodEndAsString';
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_FilterOrderPeriodEndAsString';
   Parameters[Parameters.Count-1].DataType:= ftString;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= FormatDateTime('yyyy-mm-dd', FilterForOrders.GetValuePeriodEndCreating);
//------------------------------------------------------------------------------
  end;
 end;
 Open();
end;
Result:= true;

except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
   WriteDBErrorToLog(dmDB.QDocument.SQL.Text, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;




function GetDocument_Total_byJob(inputJobName: string; inputSortingType: TOrdersSort; inputDocumentType: TDocumentType): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetDocument_Total_byJob(...)';
 Result:= false;
try

with dmDB.QDocument do
begin
   Close();
   case FilterForOrders.GetState of
    fsOff: SQL.Text:= 'Exec sp_GetDocument_Total_byJob :p_TargetJobName, :p_TargetDocumentType, :p_TargetSortingType';
    fsOn:
    begin
     SQL.Text:= 'Exec sp_GetDocument_Total_byJob_Filter :p_TargetJobName, :p_TargetDocumentType, :p_TargetSortingType, ';
     SQL.Text:= SQL.Text + ':p_FilterOrderCreatorOwnerAsString, :p_FilterOrderPeriodBeginAsString, :p_FilterOrderPeriodEndAsString';
    end;
   end;

   Parameters.Clear;
//--------- Create parameter :p_TargetJobName --------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetJobName';
   Parameters[Parameters.Count-1].DataType:= ftString;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputJobName;
//------------------------------------------------------------------------------
//--------- Create parameter :p_TargetDocumentType --------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetDocumentType';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= ord(inputDocumentType);
//------------------------------------------------------------------------------
//--------- Create parameter :p_TargetSortingType -------------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetSortingType';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= ord(inputSortingType);
//------------------------------------------------------------------------------

//----------------- Фильтр надо приделать сюда... ---------------------------
 if FilterForOrders.GetState = fsOn then
 begin
  if FilterForOrders.GetStateInitiatorOwner = fsOn then
  begin
//--------- Create parameter :p_FilterOrderCreatorOwnerAsString ----------------
//   SQL.Text:= SQL.Text + ', :p_FilterOrderCreatorOwnerAsString';
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_FilterOrderCreatorOwnerAsString';
   Parameters[Parameters.Count-1].DataType:= ftString;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= FilterForOrders.GetValueInitiatorOwner;
//------------------------------------------------------------------------------
  end;

  if FilterForOrders.GetStatePeriodCreating = fsOn then
  begin
//--------- Create parameter :p_FilterOrderPeriodBeginAsString -----------------
//   SQL.Text:= SQL.Text + ', :p_FilterOrderPeriodBeginAsString';
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_FilterOrderPeriodBeginAsString';
   Parameters[Parameters.Count-1].DataType:= ftString;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= FormatDateTime('yyyy-mm-dd', FilterForOrders.GetValuePeriodBeginCreating);
//------------------------------------------------------------------------------
//--------- Create parameter :p_FilterOrderPeriodEndAsString -------------------
//   SQL.Text:= SQL.Text + ', :p_FilterOrderPeriodEndAsString';
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_FilterOrderPeriodEndAsString';
   Parameters[Parameters.Count-1].DataType:= ftString;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= FormatDateTime('yyyy-mm-dd', FilterForOrders.GetValuePeriodEndCreating);
//------------------------------------------------------------------------------
  end;
 end;
 Open();
end;
Result:= true;

except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

function GetDocumentItem_MTR(inputDocumentId: TIdDocument): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetDocumentItem_MTR(...)';
 Result:= false;
try
with dmDB.QDocumentItem do
begin
   Close();
   SQL.Text:= 'EXEC sp_GetDocumentItem_MTR :p_TargetDocumentId';
   Parameters.Clear;
//--------- Create parameter :p_TargetDocumentId ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetDocumentId';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputDocumentId;
//------------------------------------------------------------------------------
  Open();
  Result:= true;
end;

except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//--- Процедура получнения всех элементов (Изделий) (Item) заказа, без разузлования для TreeView
function GetOrderItems_ObjectManufacturing(inpuTIdDocument: TIdDocument): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetOrderItems_ObjectManufacturing(...)';
 Result:= false;
try
with dmDB.QDocumentItem_Manufacturing do
begin
   Close();
   SQL.Text:= 'EXEC sp_GetOrderItems_ObjectManufacturing :p_NeededIdOrder';
   Parameters.Clear;
//--------- Create parameter :p_NeededIdOrder ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_NeededIdOrder';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inpuTIdDocument;
//------------------------------------------------------------------------------
  Open();
  Result:= true;
end;

except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//--- Процедура получнения всех составляющих ДСЕ для элемента (Item) заказа
function GetObjectItems_Manufacturing(inputCurrentUser: string; inpuTIdDocumentItem: TIdDocumentItem): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetObjectItems_Manufacturing(...)';
 Result:= false;
try
with dmDB.QDocumentItem do
begin
   Close();
   SQL.Text:= 'EXEC sp_GetObjectItems_Manufacturing :p_IdOrderItem';
   Parameters.Clear;
//--------- Create parameter :p_IdOrderItem ------------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_IdOrderItem';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inpuTIdDocumentItem;
//------------------------------------------------------------------------------
  Open();
  Result:= true;
end;

except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//--- Процедура получнения всех элементов (Изделий) (Item) заказа вместе c разузлованием для DBGrid
function GetOrderItems_ObjectManufacturing_ForTreeView(inpuTIdDocument: TIdDocument): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetOrderItems_ObjectManufacturing_WithTree(...)';
 Result:= false;
try
with dmDB.QDocumentItem_Manufacturing do
begin
   Close();
   SQL.Text:= 'EXEC sp_GetOrderItems_ObjectManufacturing_WithTree :p_NeededIdOrder';
   Parameters.Clear;
//--------- Create parameter :p_NeededIdOrder ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_NeededIdOrder';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inpuTIdDocument;
//------------------------------------------------------------------------------
  Open();
  Result:= true;
end;

except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;


function ExecQueryWithParam1AsString(InputSQLText: string = ''; inputParam1: string = ''): TADOQuery;
begin
 try
  with dmDB.QCommon do
  begin
   Close;
   SQL.Text:= InputSQLText;
   Parameters.Clear;
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_Param1';
   Parameters[Parameters.Count-1].DataType:= ftString;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputParam1;
   Open();
   result:= dmDB.QCommon;
  end;
except
end;
end;

function Execute_SP(inputSPName: string; var outputADOQuery: TADOQuery; inputId: integer = 0): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'Execute_SP(...)';
try
 result:=false;
  with outputADOQuery do
  begin
   Close();
//-------- Не возвращает ничего в Query ---- SQL.Text:= 'EXEC sp_adm_Execute_SP :p_TargetSPName, :Param1';
   SQL.Text:= 'EXEC ' + inputSPName;
   if inputId <> 0 then
   begin
    SQL.Text:= SQL.Text + ' :Param1';
   end;

   Parameters.Clear;
   if inputId <> 0 then
   begin
    Parameters.AddParameter;
    Parameters[Parameters.Count-1].Name:= 'Param1';
    Parameters[Parameters.Count-1].DataType:= ftInteger;
    Parameters[Parameters.Count-1].Direction:= pdInput;
    Parameters[Parameters.Count-1].Value:= inputId;
   end;
{
//--------- Create parameter :p_TargetSPName ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetSpravName';
   Parameters[Parameters.Count-1].DataType:= ftString;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputSPName;
//------------------------------------------------------------------------------
//--------- Create parameter :Param1 ----------------------------------
    Parameters.AddParameter;
    Parameters[Parameters.Count-1].Name:= 'Param1';
    Parameters[Parameters.Count-1].DataType:= ftInteger;
    Parameters[Parameters.Count-1].Direction:= pdInput;
    if inputId <> 0 then Parameters[Parameters.Count-1].Value:= inputId
                     else Parameters[Parameters.Count-1].Value:= Null;
//------------------------------------------------------------------------------
}
   Open();
   Result:= true;
  end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

{
function Execute_SP(inputSPName: string; var outputADOQuery: TADOQuery; inputParam: variant): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
{ strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'Execute_SP(...)';
try
 result:=false;
  with outputADOQuery do
  begin
   Close();
   if VarIsNull(inputParam) then SQL.Text:= 'EXEC sp_Execute_SP :p_TargetSPName'
                                else SQL.Text:= 'EXEC sp_Execute_SP :p_TargetSPName, :Param1';
   Parameters.Clear;
//--------- Create parameter :p_TargetSPName ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetSpravName';
   Parameters[Parameters.Count-1].DataType:= ftString;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputSPName;
//------------------------------------------------------------------------------
//--------- Create parameter :Param1 ----------------------------------
   if not VarIsNull(inputParam) then
   begin
    Parameters.AddParameter;
    Parameters[Parameters.Count-1].Name:= 'Param1';
    case VarType(inputParam) of
     varInteger: Parameters[Parameters.Count-1].DataType:= ftInteger;
     varString: Parameters[Parameters.Count-1].DataType:= ftString;
    end;
    Parameters[Parameters.Count-1].Direction:= pdInput;
    if inputParam <> Null then Parameters[Parameters.Count-1].Value:= inputParam
                     else Parameters[Parameters.Count-1].Value:= Null;
   end;
//------------------------------------------------------------------------------
   Open();
   Result:= true;
  end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;
}

function GetSpravObjectGroup_MTR: TADOQuery;
begin
  with dmDB.QCommon do
  begin
   Close;
   SQL.Text:= 'exec sp_GetSpravObjectGroup_MTR';
   Parameters.Clear;
   Open();
   result:= dmDB.QCommon;
  end;
end;


function GetUserInfo(inputUserLogin: string): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetUserInfo(...)';
 Result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'exec sp_GetUserInfo_byLoginName :p_LoginName';
   Parameters.Clear;
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_LoginName';
   Parameters[Parameters.Count-1].DataType:= ftString;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputUserLogin;
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;
end;


function GetUserList(): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetUserList(...)';
 Result:= false;
try
 with dmDB.adsUserList do
 begin
  Close;
  CommandType:= cmdStoredProc;
  CommandText:= 'sp_GetUserInfo';
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;
end;

function GetJobRole(inputUserId: TIdUser): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetJobRole(...)';
 Result:= false;
try
 Execute_SP('sp_GetJobRole', dmDb.QJobRole, inputUserId);
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;
end;

function GetJobRoleVirtual(inputUserId: TIdUser): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetJobRoleVirtual(...)';
 Result:= false;
try
 with dmDb do
 begin
  sp_GetJobRoleVirtual_byUser.Parameters.ParamByName('@input_UserId').Value:= inputUserId;
  sp_GetJobRoleVirtual_byUser.Open;
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;
end;

function GetSpravList(): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetSpravList(...)';
 Result:= false;
try
 Execute_SP('sp_adm_GetSpravList', dmDb.QSpravList);
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;
end;

function GetSpravData(inputSpravTableName: string; var outputADOQuery: TADOQuery): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetSpravData(...)';
try
 result:=false;
  with outputADOQuery do
  begin
   Close();
   SQL.Text:= 'EXEC sp_adm_GetSpravData :p_TargetSpravName';
   Parameters.Clear;
//--------- Create parameter :p_TargetSpravName ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetSpravName';
   Parameters[Parameters.Count-1].DataType:= ftString;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputSpravTableName;
//------------------------------------------------------------------------------
   Open();
   Result:= true;
  end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

function GetSpravData_byId(inputSpravName: string; inputId: TId; var outputADOQuery: TADOQuery): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetSpravData_byId(...)';
try
 result:=false;
  with outputADOQuery do
  begin
   Close();
   SQL.Text:= 'EXEC sp_GetSpravData_byId :p_TargetSpravName, :p_TargetId';
   Parameters.Clear;
//--------- Create parameter :p_TargetSpravName ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetSpravName';
   Parameters[Parameters.Count-1].DataType:= ftString;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputSpravName;
//------------------------------------------------------------------------------
//--------- Create parameter :p_TargetId ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetId';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputId;
//------------------------------------------------------------------------------
   Open();
   Result:= true;
  end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;


function ExecuteProgramRoleListQuery(): TADOQuery;
begin
  with dmDB.QProgramRoleList do
  begin
   Close;
   SQL.Text:= 'exec sp_GetSpravProgramRole';
   Parameters.Clear;
   Open();
   result:= dmDB.QProgramRoleList;
  end;
end;

function ExecuteProgramRoleQuery(InputUserShortName: String; idOrder: TIdDocument): TADOQuery;
var
   strCurrentProcName: AnsiString;
   i: integer;
begin
 strCurrentProcName:= 'ExecuteProgramRolesQuery(...)';
try
with dmDB.QCommon do
begin
  Close;
  SQL.Text:= 'EXEC sp_GetUserProgramRolesInfo :p_UserShortName, :p_IdOrder';
  Parameters.Clear;
//--------- Create parameter :p_UserShortName -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_UserShortName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= InputUserShortName;
//----------------------------------------------------------------------------------
//--------- Create parameter :p_IdOrder -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdOrder';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= idOrder;
//----------------------------------------------------------------------------------
  Open;
end;
  result:= dmDB.QCommon;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');
end;
end;

//------------------------------------------------------------------------------
//----------- Begin of: [Create, Edit, Delete] Document ------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------ CreateDocument --------------------------------------------
//------------------------------------------------------------------------------
function CreateDocument(inputDocumentTypeCode: TDocumentType; inputExecutionDate: TDateTime; inputShortName, inputNotes: string): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'CreateDocument(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_CreateDocument :p_inputDocumentTypeCode, :p_ExecutionDateAsString, :p_ShortName, :p_Notes';
  Parameters.Clear;
//--------- Create parameter :p_inpuIdDocumentType -----------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_inputDocumentTypeCode';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputDocumentTypeCode;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ExecutionDate ----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ExecutionDate';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= FormatDateTime('yyyy.mm.dd', inputExecutionDate);
//------------------------------------------------------------------------------
//--------- Create parameter :p_ShortName ------------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ShortName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputShortName;
//------------------------------------------------------------------------------
//--------- Create parameter :p_Notes ------------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_Notes';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputNotes;
//------------------------------------------------------------------------------

  Open();
  if not VarIsNull(fields[0].Value) then
  begin
   if fields[0].Value > 0 then
    Result:= true;
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//------------------ EditOrder -----------------------------------------------
//------------------------------------------------------------------------------
function EditDocument(inputDocumentId: TIdDocument; inputExecutionDate: TDateTime; inputNotes, inputDocumentShortName: string; inputDocumentNum: TDocumentNum): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'EditDocument(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_EditDocument :p_DocumentId, :p_ExecutionDate, :p_Notes, :p_DocumentNum, :p_DocumentShortName';
  Parameters.Clear;

  //--------- Create parameter :p_DocumentId ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DocumentId';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputDocumentId;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ExecutionDate ----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ExecutionDate';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= FormatDateTime('yyyy-mm-dd', inputExecutionDate);
//------------------------------------------------------------------------------
//--------- Create parameter :p_Notes ------------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_Notes';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= AllTrim(inputNotes);
//------------------------------------------------------------------------------
//--------- Create parameter :p_DocumentShortName ------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DocumentShortName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= AllTrim(inputDocumentShortName);
//------------------------------------------------------------------------------
//--------- Create parameter :p_DocumentNum ------------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DocumentNum';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputDocumentNum;
//------------------------------------------------------------------------------

  Open();
  if not VarIsNull(fields[0].Value) then
  begin
   if fields[0].Value > 0 then
    Result:= true;
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

function DeleteDocument(targetDocumentId: TIdDocument): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'DeleteDocument(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  Parameters.Clear;
  SQL.Text:= 'EXEC sp_DeleteDocument :p_DocumentId';
  Parameters.Clear;
//--------- Create parameter :p_DocumentId -------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DocumentId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= targetDocumentId;
//------------------------------------------------------------------------------

  Open();
  if not VarIsNull(fields[0].Value) then
  begin
   if fields[0].Value > 0 then
    Result:= true;
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//----------- End of: [Create, Edit, Delete] Order------------------------------
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//----------- Begin of: [Create, Edit, Delete] OrdersItem_MTR ------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------ CreateOrdersItem_MTR --------------------------------------
//------------------------------------------------------------------------------
function CreateDocumentItem_MTR(inputDocumentId: TId; inputObjectGroupId: integer; inputObjectName, inputObjectVolumeAsString: string; inputMeasurementUnitId: integer; inputNotes: string): longint;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'CreateDocumentItem_MTR(...)';
 result:= 0;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_CreateDocumentItem_MTR :p_DocumentId, :p_ObjectShortName, :p_ObjectFullName, :p_Notes, ';
  SQL.Text:= SQL.Text + ' :p_ObjectGroupId, :p_MeasurementUnitId, :p_ObjectVolume';
  Parameters.Clear;

//--------- Create parameter :p_DocumentId ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DocumentId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputDocumentId;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ObjectShortName ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectShortName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= AllTrim(inputObjectName);
//------------------------------------------------------------------------------
//--------- Create parameter :p_ObjectFullName ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectFullName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= '';  //--- FullName Пока не используется
//------------------------------------------------------------------------------
//--------- Create parameter :p_Notes ------------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_Notes';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= AllTrim(inputNotes);
//------------------------------------------------------------------------------
//--------- Create parameter :p_ObjectGroupId -------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectGroupId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputObjectGroupId;
//------------------------------------------------------------------------------
//--------- Create parameter :p_MeasurementUnitId ------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_MeasurementUnitId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputMeasurementUnitId;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ObjectVolume ----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectVolume';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= StrToFloat(AllTrim(inputObjectVolumeAsString));
//------------------------------------------------------------------------------

  Open();
  if not VarIsNull(fields[0].Value) then
  begin
   result:= fields[0].Value;
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//------------------ EditDocumentItem_MTR --------------------------------------
//------------------------------------------------------------------------------
function EditDocumentItem_MTR(inputDocumentItemId: TId; inputObjectGroupId: integer; inputObjectName, inputObjectVolumeAsString: string; inputMeasurementUnitId: integer; inputNotes: string): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'EditDocumentItem_MTR(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_EditDocumentItem_MTR :p_DocumentItemId, :p_ObjectGroupId, ';
  SQL.Text:= SQL.Text + ':p_MeasurementUnitId, :p_ObjectName, :p_ObjectVolume, :p_Notes, :p_ExecutionDate';
  Parameters.Clear;

//--------- Create parameter :p_DocumentItemId ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DocumentItemId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputDocumentItemId;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ObjectGroupId ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectGroupId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputObjectGroupId;
//------------------------------------------------------------------------------
//--------- Create parameter :p_MeasurementUnitId ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_MeasurementUnitId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputMeasurementUnitId;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ObjectName ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputObjectName;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ObjectVolume ----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectVolume';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= StrToInt(AllTrim(inputObjectVolumeAsString));
//------------------------------------------------------------------------------
//--------- Create parameter :p_Notes ------------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_Notes';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputNotes;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ExecutionDate ------------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ExecutionDate';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= ''; //потом добавить этот параметр
//------------------------------------------------------------------------------

  Open();

  if not VarIsNull(fields[0].Value) then
  begin
   result:= fields[0].Value;
   if fields[0].Value <= 0 then
   begin
    tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
    WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
   end;
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
   MessageBox(e.Message, ErrorMessage);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;


function DeleteOrdersItem_MTR(neededIdOrderItem: integer; inputCreatorOwner: string): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'DeleteOrdersItem(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  Parameters.Clear;
  SQL.Text:= 'EXEC sp_DeleteOrdersItem :p_IdOrderItem, :p_CreatorOwnerAsString';
  Parameters.Clear;
//--------- Create parameter :p_IdOrderItem -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdOrderItem';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= neededIdOrderItem;
//----------------------------------------------------------------------------------
//--------- Create parameter :p_CreatorOwnerAsString ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_CreatorOwnerAsString';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputCreatorOwner;
//------------------------------------------------------------------------------
  Open();
  if not VarIsNull(fields[0].Value) then
  begin
   result:= fields[0].Value;
   if fields[0].Value <> 0 then
   begin
    tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
    WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
   end;
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//----------- End of: [Create, Edit, Delete] OrdersItem_MTR --------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//----------- Begin of: [Create, Edit, Delete] OrdersItem_ProductManufacturing -
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------ CreateOrdersItem_ProductManufacturing ---------------------
//------------------------------------------------------------------------------
function CreateOrdersItem_ProductManufacturing(inpuTIdDocument: integer; inputCreatorOwner: string; inputIdSravProductManufacturing: TIdSpravObject; inputObjectVolumeAsInteger: integer; inputNotes: string; inputExecutionDate: TDateTime): longint;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'CreateOrderItem_ObjectManufacturing(...)';
 result:= 0;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_CreateOrderItem_ObjectManufacturing :p_IdOrder, :p_CreatorOwnerAsString, :p_IdSravProductManufacturingAsInteger, ';
  SQL.Text:= SQL.Text + ':p_ObjectVolume, :p_Notes, :p_ExecutionDate';
  Parameters.Clear;

//--------- Create parameter :p_IdOrder ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdOrder';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inpuTIdDocument;
//------------------------------------------------------------------------------

//--------- Create parameter :p_CreatorOwnerAsString ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_CreatorOwnerAsString';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputCreatorOwner;
//------------------------------------------------------------------------------
//--------- Create parameter :p_IdSravProductManufacturingAsInteger ---------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdSravProductManufacturingAsInteger';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputIdSravProductManufacturing;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ObjectVolume ----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectVolume';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputObjectVolumeAsInteger;
//------------------------------------------------------------------------------
//--------- Create parameter :p_Notes ------------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_Notes';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= AllTrim(inputNotes);
//------------------------------------------------------------------------------
//--------- Create parameter :p_ExecutionDate ----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ExecutionDate';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= FormatDateTime('yyyy-mm-dd', inputExecutionDate);
//------------------------------------------------------------------------------

  Open();
  result:= fields[0].Value;
//  ExecSQL;
  if fields[0].AsInteger <= 0 then
  begin
   tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//------------------ EditOrdersItem_ProductManufacturing -----------------------
//------------------------------------------------------------------------------
function EditOrdersItem_ProductManufacturing(inpuTIdDocument: integer; inpuTIdDocumentsItem: integer; inputCreatorOwner: string; inputObjectsGroups: integer; inputObjectName, inputObjectVolumeAsString: string; inputMeasurementsUnits: integer; inputNotes: string; inputExperationDate: TDateTime): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'EditOrdersItem_MTR(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_EditOrderItem_ObjectManufacturing :p_IdOrder, :p_IdOrdersItem, :p_CreatorOwnerAsString, :p_ObjectsGroupsAsInteger, ';
  SQL.Text:= SQL.Text + ':p_MeasurementsUnitsAsInteger, :p_ObjectName, :p_ObjectVolume, :p_Notes, :p_ExecutionDate';
  Parameters.Clear;

//--------- Create parameter :p_IdOrder ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdOrder';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inpuTIdDocument;
//------------------------------------------------------------------------------

//--------- Create parameter :p_IdOrdersItem ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdOrdersItem';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inpuTIdDocumentsItem;
//------------------------------------------------------------------------------

//--------- Create parameter :p_CreatorOwnerAsString ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_CreatorOwnerAsString';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputCreatorOwner;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ObjectsGroupsAsInteger ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectsGroupsAsInteger';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputObjectsGroups;
//------------------------------------------------------------------------------
//--------- Create parameter :p_MeasurementsUnitsAsInteger ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_MeasurementsUnitsAsInteger';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputMeasurementsUnits;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ObjectName ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputObjectName;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ObjectVolume ----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectVolume';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= StrToInt(AllTrim(inputObjectVolumeAsString));
//------------------------------------------------------------------------------
//--------- Create parameter :p_Notes ------------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_Notes';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputNotes;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ExecutionDate -------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ExecutionDate';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= FormatDateTime('yyyy.mm.dd', inputExperationDate);
//------------------------------------------------------------------------------

  Open();
//  ExecSQL;
  if fields[0].AsInteger <> 0 then
  begin
   tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
   MessageBox(e.Message, ErrorMessage);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;


function DeleteOrdersItem_ProductManufacturing(neededIdOrderItem: integer; inputCreatorOwner: string): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'DeleteOrderItem_ObjectManufacturing(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  Parameters.Clear;
  SQL.Text:= 'EXEC sp_DeleteOrderItem_ObjectManufacturing :p_IdOrderItem, :p_CreatorOwnerAsString';
  Parameters.Clear;
//--------- Create parameter :p_IdOrderItem -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdOrderItem';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= neededIdOrderItem;
//----------------------------------------------------------------------------------
//--------- Create parameter :p_CreatorOwnerAsString ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_CreatorOwnerAsString';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputCreatorOwner;
//------------------------------------------------------------------------------
  Open();
  if fields[0].AsInteger <> 0 then
  begin
   tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//----------- End of: [Create, Edit, Delete] OrdersItem_ProductManufacturing ---
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
//----------- Begin of: [Create, Edit, Delete] StoreObject ---------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------ CreateStoreObject -----------------------------------------
//------------------------------------------------------------------------------
function CreateStoreObject(inputDocumentId: TIdDocument; inputDocumentItemId: TIdDocumentItem; inputObjectGroupId: integer; inputObjectShortName, inputObjectFullName, inputObjectVolumeAsString: string; inputMeasurementUnitId: integer; inputNotes: string; inputCreationDate: TDateTime): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'CreateStoreObject(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_CreateStoreObject :p_DocumentId, :p_DocumentItemId, :p_ObjectGroupId, :p_MeasurementUnitId, ';
  SQL.Text:= SQL.Text + ':p_ObjectShortName, :p_ObjectFullName, :p_ObjectVolume, :p_Notes, :p_CreationDate';
  Parameters.Clear;

//--------- Create parameter :p_DocumentId ----------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DocumentId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputDocumentId;
//------------------------------------------------------------------------------

//--------- Create parameter :p_DocumentItemId ------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DocumentItemId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputDocumentItemId;
//------------------------------------------------------------------------------

//--------- Create parameter :p_ObjectGroupId ----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectGroupId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputObjectGroupId;
//------------------------------------------------------------------------------
//--------- Create parameter :p_MeasurementUnitId ---------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_MeasurementUnitId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputMeasurementUnitId;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ObjectShortName ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectShortName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= AllTrim(inputObjectShortName);
//------------------------------------------------------------------------------
//--------- Create parameter :p_ObjectFullName ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectFullName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= AllTrim(inputObjectFullName);
//------------------------------------------------------------------------------
//--------- Create parameter :p_ObjectVolume ----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectVolume';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= StrToInt(AllTrim(inputObjectVolumeAsString));
//------------------------------------------------------------------------------
//--------- Create parameter :p_Notes ------------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_Notes';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= AllTrim(inputNotes);
//------------------------------------------------------------------------------
//--------- Create parameter :p_CreationDate ----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_CreationDate';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= FormatDateTime('yyyy.mm.dd hh:mm:ss', inputCreationDate);
//------------------------------------------------------------------------------
  tmpString:= FormatDateTime('yyyy.mm.dd', inputCreationDate);
  Open();
//  ExecSQL;
  if fields[0].AsInteger <> 0 then
  begin
   tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//------------------ EditStoreObject -------------------------------------------
//------------------------------------------------------------------------------
function EditStoreObject(inpuTIdDocument: integer; inpuTIdDocumentsItem: integer; inputCreatorOwner: string; inputObjectsGroups: integer; inputObjectName, inputObjectVolumeAsString: string; inputMeasurementsUnits: integer; inputNotes: string; inputExperationDate: TDateTime): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'EditStoreObject(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_EditOrdersItem_MTR :p_IdOrder, :p_IdOrdersItem, :p_CreatorOwnerAsString, :p_ObjectsGroupsAsInteger, ';
  SQL.Text:= SQL.Text + ':p_MeasurementsUnitsAsInteger, :p_ObjectName, :p_ObjectVolume, :p_Notes, :p_ExecutionDate';
  Parameters.Clear;

//--------- Create parameter :p_IdOrder ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdOrder';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inpuTIdDocument;
//------------------------------------------------------------------------------

//--------- Create parameter :p_IdOrdersItem ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdOrdersItem';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inpuTIdDocumentsItem;
//------------------------------------------------------------------------------

//--------- Create parameter :p_CreatorOwnerAsString ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_CreatorOwnerAsString';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputCreatorOwner;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ObjectsGroupsAsInteger ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectsGroupsAsInteger';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputObjectsGroups;
//------------------------------------------------------------------------------
//--------- Create parameter :p_MeasurementsUnitsAsInteger ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_MeasurementsUnitsAsInteger';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputMeasurementsUnits;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ObjectName ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputObjectName;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ObjectVolume ----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectVolume';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= StrToInt(AllTrim(inputObjectVolumeAsString));
//------------------------------------------------------------------------------
//--------- Create parameter :p_Notes ------------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_Notes';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputNotes;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ExecutionDate -------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ExecutionDate';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= FormatDateTime('yyyy.mm.dd', inputExperationDate);
//------------------------------------------------------------------------------

  Open();
//  ExecSQL;
  if fields[0].AsInteger <> 0 then
  begin
   tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
   MessageBox(e.Message, ErrorMessage);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;


function DeleteStoreObject(neededIdOrderItem: integer; inputCreatorOwner: string): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'DeleteStoreObject(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  Parameters.Clear;
  SQL.Text:= 'EXEC sp_DeleteOrdersItem :p_IdOrderItem, :p_CreatorOwnerAsString';
  Parameters.Clear;
//--------- Create parameter :p_IdOrderItem -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdOrderItem';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= neededIdOrderItem;
//----------------------------------------------------------------------------------
//--------- Create parameter :p_CreatorOwnerAsString ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_CreatorOwnerAsString';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputCreatorOwner;
//------------------------------------------------------------------------------
  Open();
  if fields[0].AsInteger <> 0 then
  begin
   tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//----------- End of: [Create, Edit, Delete] StoreObject -----------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------


function DocumentItem_AddAttachment(inputDocumentItemId: TIDDocument; inputCurrentUser: string; inputUNCFileName: string): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'DocumentItem_AddAttachment(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_DocumentItem_AddAttachment :p_DocumentItemId, :p_AttachmentName, :p_UNCFileName, :p_BLOBData';
  Parameters.Clear;

//--------- Create parameter :p_DocumentItemId ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DocumentItemId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputDocumentItemId;
//------------------------------------------------------------------------------

//--------- Create parameter :p_AttachmentName ---------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_AttachmentName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= ExtractFileName(inputUNCFileName);
//------------------------------------------------------------------------------

//--------- Create parameter :p_UNCFileName ------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_UNCFileName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputUNCFileName;
//------------------------------------------------------------------------------

//--------- Create parameter :p_BLOBData ---------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_BLOBData';
 Parameters[Parameters.Count-1].DataType:= ftBlob;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].LoadFromFile(inputUNCFileName,ftBlob); // Value:= inputFileName;
//------------------------------------------------------------------------------
  Open();
//  ExecSQL;
  if fields[0].AsInteger <> 0 then
  begin
   tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;


function DeleteAttachmentForOrderItem(inpuTIdDocument: integer; inpuTIdDocumentsItem: integer; inputCurrentUser: string; inputAttachmentName: string; inputIdAttachment: TIdAttachment): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'DeleteAttachmentForOrderItem(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_DeleteAttachmentOrderItem :p_IdOrder, :p_IdOrderItem, :p_CreatorOwnerAsString, :p_AttachmentName, :p_IdAttachment';
  Parameters.Clear;

//--------- Create parameter :p_IdOrder ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdOrder';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inpuTIdDocument;
//------------------------------------------------------------------------------

//--------- Create parameter :p_IdOrderItem ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdOrderItem';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inpuTIdDocumentsItem;
//------------------------------------------------------------------------------

//--------- Create parameter :p_CreatorOwnerAsString ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_CreatorOwnerAsString';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputCurrentUser;
//------------------------------------------------------------------------------

//--------- Create parameter :p_AttachmentName ---------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_AttachmentName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputAttachmentName;
//------------------------------------------------------------------------------

//--------- Create parameter :p_IdAttachment -----------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdAttachment';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputIdAttachment;
//------------------------------------------------------------------------------

  Open();
//  ExecSQL;
  if fields[0].AsInteger <> 0 then
  begin
   tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

function RenameAttachmentForOrderItem(inpuTIdDocument: integer; inpuTIdDocumentsItem: integer; inputCurrentUser: string; inputAttachmentName: string; inputIdAttachment: TIdAttachment): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'RenameAttachmentForOrderItem(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_RenameAttachmentOrderItem :p_IdOrder, :p_IdOrderItem, :p_CreatorOwnerAsString, :p_AttachmentName, :p_IdAttachment';
  Parameters.Clear;

//--------- Create parameter :p_IdOrder ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdOrder';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inpuTIdDocument;
//------------------------------------------------------------------------------

//--------- Create parameter :p_IdOrderItem ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdOrderItem';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inpuTIdDocumentsItem;
//------------------------------------------------------------------------------

//--------- Create parameter :p_CreatorOwnerAsString ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_CreatorOwnerAsString';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputCurrentUser;
//------------------------------------------------------------------------------

//--------- Create parameter :p_AttachmentName ---------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_AttachmentName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputAttachmentName;
//------------------------------------------------------------------------------

//--------- Create parameter :p_IdAttachment -----------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdAttachment';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputIdAttachment;
//------------------------------------------------------------------------------

  Open();
//  ExecSQL;
  if fields[0].AsInteger <> 0 then
  begin
   tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

function GetAttachment(inputDocumentItem: Tid; inputAttachmentName: string; inputIdAttachment: TIdAttachment): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetAttachment(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_GetAttachment :p_DocumentItemId, :p_AttachmentName, :p_IdAttachment';
  Parameters.Clear;

//--------- Create parameter :p_DocumentItemId ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DocumentItemId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputDocumentItem;
//------------------------------------------------------------------------------

//--------- Create parameter :p_AttachmentName ---------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_AttachmentName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputAttachmentName;
//------------------------------------------------------------------------------

//--------- Create parameter :p_IdAttachment -----------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdAttachment';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputIdAttachment;
//------------------------------------------------------------------------------

  Open();
 end;
  result:= true;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;



//------------------------------------------------------------------------------
//----------- Begin of: [Create, Edit, Delete] SpravItem ----------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------ CreateSpravItem ------------------------------------------
//------------------------------------------------------------------------------
function CreateSpravItem(inputCurrentUser: string; inputSpravName: string; inputCode: word; inputShortName: string; inputFullName: string; inputNotes: string): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'CreateSpravItem(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  if inputSpravName = spravJobRole then SQL.Text:= 'EXEC sp_CreateJobPositionItem ';
  SQL.Text:= SQL.Text + ':p_CurrentUser, :p_Code, :p_ShortName, :p_FullName, :p_Notes';
  Parameters.Clear;

//--------- Create parameter :p_CurrentUser ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_CurrentUser';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputCurrentUser;
//------------------------------------------------------------------------------
//--------- Create parameter :p_Code -------------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_Code';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputCode;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ShortName --------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ShortName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= AllTrim(inputShortName);
//------------------------------------------------------------------------------
//--------- Create parameter :p_FullName ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_FullName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= AllTrim(inputFullName);
//------------------------------------------------------------------------------

//--------- Create parameter :p_Notes ------------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_Notes';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= AllTrim(inputNotes);
//------------------------------------------------------------------------------

  Open();
//  ExecSQL;
  if fields[0].AsInteger <> 0 then
  begin
   tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//----------- End of: [Create, Edit, Delete] SpravItem ------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
//----------- Begin of: [Create, Edit, Delete] Route ---------------------------
//------------------------------------------------------------------------------


function GetMaxRouteId(): integer;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetMaxRouteId(...)';
 result:= -1;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_GetSpravMaxRouteId';
  Parameters.Clear;
  Open;
  Result:= FieldValues[queryFieldNameForIdRoute];
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;



//------------------------------------------------------------------------------
//------------------ CreateTemplateProcess ---------------------------------------
//------------------------------------------------------------------------------
function CreateTemplateProcess(inputProcessName: TProcessName; inputProcessFullName: TProcessName; inputNotes: string): TIdProcess;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'CreateTemplateProcess(...)';
 result:= -1;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_CreateTemplateProcess :p_ProcessName, :p_ProcessFullName, :p_Notes, :p_ActiveStatus';
  Parameters.Clear;
//--------- Create parameter :p_ProcessName ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ProcessName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputProcessName;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ProcessFullName --------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ProcessFullName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputProcessFullName;
//------------------------------------------------------------------------------
//--------- Create parameter :p_Notes ------------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_Notes';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputNotes;
//------------------------------------------------------------------------------

  Open();
  Result:= GetMaxRouteId();
//  ExecSQL;
  if fields[0].AsInteger <> 0 then
  begin
   tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//------------------ EditTemplateProcess ---------------------------------------
//------------------------------------------------------------------------------
function EditTemplateProcess(inputProcessId: TIdProcess; inputProcessName: TProcessName; inputProcessFullName: TProcessName; inputNotes: string; inputActiveStatus: TObjectShowStatus): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'EditProcess(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_EditProcess :p_ProcessId, :p_ProcessName, :p_ProcessFullName, :p_Notes, :p_ActiveStatus';
  Parameters.Clear;
//--------- Create parameter :p_ProcessId ----------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= ':p_ProcessId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputProcessId;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ProcessName ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ProcessName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputProcessName;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ProcessFullName --------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ProcessFullName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputProcessFullName;
//------------------------------------------------------------------------------
//--------- Create parameter :p_Notes ------------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_Notes';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputNotes;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ActiveStatus -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ActiveStatus';
 Parameters[Parameters.Count-1].DataType:= ftBoolean;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputActiveStatus;
//------------------------------------------------------------------------------

  Open();
//  ExecSQL;
  if fields[0].AsInteger <> 0 then
  begin
   tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//------------------ DeleteTemplateProcess ---------------------------------------
//------------------------------------------------------------------------------
function DeleteTemplateProcess(inputProcessId: TIdProcess): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'DeleteProcess(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_DeleteProcess :p_ProcessId';
  Parameters.Clear;
//--------- Create parameter :p_ProcessId ----------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= ':p_ProcessId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputProcessId;
//------------------------------------------------------------------------------
  Open();
//  ExecSQL;
  if fields[0].AsInteger <> 0 then
  begin
   tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//----------- End of: [Create, Edit, Delete] TemplateProcess -------------------
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
//----------- Begin of: [Create, Edit, Delete] TemplateProcessItem -------------
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//------------------ CreateTemplateProcessItem ---------------------------------
//------------------------------------------------------------------------------

function CreateTemplateProcessItem(inputProcessId: TId; inputItemLevel: integer; inputJob: TIdJob; inputJobRole: TIdJobRole; inputJobRoleType: TJobRoleType): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'CreateProcessItem(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_CreateTemplateProcessItem :p_ProcessId, :p_ItemLevel, :p_JobId, ';
  SQL.Text:= SQL.Text + ':p_JobRole, :p_JobRoleType';
  Parameters.Clear;

//--------- Create parameter :p_ProcessId --------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ProcessId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputProcessId;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ItemLevel -----------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ItemLevel';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputItemLevel;
//------------------------------------------------------------------------------
//--------- Create parameter :p_JobId ----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_JobId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputJob;
//------------------------------------------------------------------------------
//--------- Create parameter :p_JobRole --------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_JobRole';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputJobRole;
//------------------------------------------------------------------------------
//--------- Create parameter :p_JobRoleType --------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_JobRoleType';
 Parameters[Parameters.Count-1].DataType:= ftBoolean;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= (inputJobRoleType = jrtVirtual);
//------------------------------------------------------------------------------

  Open();
  if not VarIsNull(Fields[0].Value) then
   if Fields[0].Value > 0 then
    Result:= true
  else
   Result:= false;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//------------------ DeleteTemplateProcessItem ---------------------------------
//------------------------------------------------------------------------------
function DeleteTemplateProcessItem(inputProcessItemTemplateId: TIdProcess): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'DeleteProcess(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_DeleteTemplateProcessItem :p_ProcessItemTemplateId';
  Parameters.Clear;
//--------- Create parameter :p_ProcessItemTemplateId --------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= ':p_ProcessItemTemplateId';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputProcessItemTemplateId;
//------------------------------------------------------------------------------
  Open();

  if fields[0].AsInteger = -1 then
  begin
   tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//----------- End of: [Create, Edit, Delete] TemplateProcessItem ---------------
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
//----------- Begin of: [Create, Edit, Delete] TemplateJobItem -----------------
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//------------------ CreateTemplateJobItem -------------------------------------
//------------------------------------------------------------------------------
function CreateTemplateJobItem(inputProcessItemTemplate, inputJobItemLevel, inputJobItem: TId; inputActiveStatus, inputEntireDocumentStatus, inputEDDStatus: boolean; inputDoneCondition, inputDoneResolution, inputConditionDependence: TId; inputDoneResolutionText, inputNotes: string; inputDoneStatus: boolean): TId;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'CreateTemplateJobItem(...)';
 result:= -1;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_CreateTemplateJobItem :p_ProcessItemTemplate, :p_JobItemLevel, :p_JobItem, :p_ActiveStatus, :p_EntireDocumentStatus, ';
  SQL.Text:= SQL.Text + ':p_EDDStatus, :p_DoneCondition, :p_DoneResolution, :p_ConditionDependence, :p_DoneResolutionText, :p_Notes, :p_DoneStatus';
//showmessage(SQL.Text);
  Parameters.Clear;
//--------- Create parameter :p_ProcessItemTemplate ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ProcessItemTemplate';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputProcessItemTemplate;
//------------------------------------------------------------------------------
//--------- Create parameter :p_JobItemLevel -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_JobItemLevel';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputJobItemLevel;
//------------------------------------------------------------------------------
//--------- Create parameter :p_JobItem -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_JobItem';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputJobItem;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ActiveStatus -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ActiveStatus';
 Parameters[Parameters.Count-1].DataType:= ftBoolean;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputActiveStatus;
//------------------------------------------------------------------------------
//--------- Create parameter :p_EntireDocumentStatus ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_EntireDocumentStatus';
 Parameters[Parameters.Count-1].DataType:= ftBoolean;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputEntireDocumentStatus;
//------------------------------------------------------------------------------
//--------- Create parameter :p_EDDStatus -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_EDDStatus';
 Parameters[Parameters.Count-1].DataType:= ftBoolean;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputEDDStatus;
//------------------------------------------------------------------------------
//--------- Create parameter :p_DoneCondition -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DoneCondition';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputDoneCondition;
//------------------------------------------------------------------------------
//--------- Create parameter :p_DoneResolution -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DoneResolution';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputDoneResolution;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ConditionDependence -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ConditionDependence';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputConditionDependence;
//------------------------------------------------------------------------------
//--------- Create parameter :p_DoneResolutionText ------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DoneResolutionText';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputDoneResolutionText;
//------------------------------------------------------------------------------
//--------- Create parameter :p_Notes ------------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_Notes';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputNotes;
//------------------------------------------------------------------------------
//--------- Create parameter :p_DoneStatus -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DoneStatus';
 Parameters[Parameters.Count-1].DataType:= ftBoolean;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputDoneStatus;
//------------------------------------------------------------------------------

  Open();
  if not VarIsNull(fields[0].Value) then
  begin
   result:= fields[0].Value;
   if fields[0].Value <= 0 then
   begin
    tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
    WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
   end;
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//------------------ EditTemplateJobItem ---------------------------------------
//------------------------------------------------------------------------------
function EditTemplateJobItem(inputJobItemTemplateId, inputProcessItemTemplate, inputJobItemLevel, inputJobItem: TId; inputActiveStatus, inputEntireDocumentStatus, inputEDDStatus: boolean; inputDoneCondition, inputDoneResolution, inputConditionDependence: TId; inputDoneResolutionText, inputNotes: string;  inputDoneStatus: boolean): TIdProcess;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'CreateTemplateJobItem(...)';
 result:= -1;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_CreateTemplateJobItem :p_ProcessItemTemplate, :p_JobItemLevel, :p_JobItem, :p_ActiveStatus, :p_DoneStatus, :p_EntireDocumentStatus, ';
  SQL.Text:= SQL.Text + ':p_EDDStatus, :p_DoneCondition, :p_DoneResolution, :p_ConditionDependence, :p_DoneResolutionText, :p_Notes';
  Parameters.Clear;
//--------- Create parameter :p_ProcessItemTemplate ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ProcessItemTemplate';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputProcessItemTemplate;
//------------------------------------------------------------------------------
//--------- Create parameter :p_JobItemLevel -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_JobItemLevel';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputJobItemLevel;
//------------------------------------------------------------------------------
//--------- Create parameter :p_JobItem -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_JobItem';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputJobItem;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ActiveStatus -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ActiveStatus';
 Parameters[Parameters.Count-1].DataType:= ftBoolean;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputActiveStatus;
//------------------------------------------------------------------------------
//--------- Create parameter :p_DoneStatus -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DoneStatus';
 Parameters[Parameters.Count-1].DataType:= ftBoolean;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputDoneStatus;
//------------------------------------------------------------------------------
//--------- Create parameter :p_EntireDocumentStatus ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DoneStatus';
 Parameters[Parameters.Count-1].DataType:= ftBoolean;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputEntireDocumentStatus;
//------------------------------------------------------------------------------
//--------- Create parameter :p_EDDStatus -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DoneStatus';
 Parameters[Parameters.Count-1].DataType:= ftBoolean;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputEDDStatus;
//------------------------------------------------------------------------------
//--------- Create parameter :p_DoneResolutionText ------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_DoneStatus';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputDoneResolutionText;
//------------------------------------------------------------------------------
//--------- Create parameter :p_Notes ------------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_Notes';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputNotes;
//------------------------------------------------------------------------------

  Open();
  Result:= GetMaxRouteId();
//  ExecSQL;
  if fields[0].AsInteger <> 0 then
  begin
   tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//----------- End of: [Create, Edit, Delete] TemplateJobItem -------------------
//------------------------------------------------------------------------------



function FindPositionInDatasetBy(InputDataset: TDataset; findingFieldName: string; neededValue: Variant): integer;
begin
try
 result:= -1;
 InputDataset.Open;
 InputDataset.First;
 if InputDataset.Locate(findingFieldName, neededValue, []) then
   result:= InputDataset.RecNo;
{
 while not InputDataset.Eof do
 begin
  if InputDataset.FieldByName(findingFieldName).Value = neededValue then
  begin
   result:= InputDataset.RecNo;
   break;
  end;
  InputDataset.Next;
 end;
}
except
 result:= InputDataset.RecNo;
end;
end;

function ExecuteUserInfoQuery(InputUserShortName: String): TADOQuery;
var
   strCurrentProcName: AnsiString;
   i: integer;
begin
 strCurrentProcName:= 'ExecuteUserInfoQuery(...)';
try
with dmDB.QCommon do
begin
  Close;
  SQL.Text:= 'EXEC sp_GetUserInfo :p_UserShortName';
  Parameters.Clear;
//--------- Create parameter :p_UserShortName -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_UserShortName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= InputUserShortName;
//----------------------------------------------------------------------------------
  Open;
end;
  result:= dmDB.QCommon;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');
end;
end;

function ExecuteObjectItemInfoQuery_Manufacturing(inpuTIdDocumentItem: TIdDocumentItem): TADOQuery;
var
   strCurrentProcName: AnsiString;
   i: integer;
begin
 strCurrentProcName:= 'ExecuteObjectItemInfoQuery(...)';
try
with dmDB.QCommon do
begin
  Close;
  SQL.Text:= 'EXEC sp_GetObjectInfo_Manufacturing :p_IdOrderItem';
  Parameters.Clear;
//--------- Create parameter :p_IdOrderItem -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_IdOrderItem';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inpuTIdDocumentItem;
//----------------------------------------------------------------------------------
{
//--------- Create parameter :p_ObjectShortName -----------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_ObjectShortName';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputObjectShortName;
//----------------------------------------------------------------------------------
}
  Open;
end;
  result:= dmDB.QCommon;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('SQL.Text = ' + dmDB.QCommon.SQL.Text, dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');
end;
end;



function GetUserProgramRoleName(inputUser: string): String;
var
   tmpString: AnsiString;
begin
with dmDB do
try
  QCommon.Close;
  QCommon.SQL.Text:= 'EXEC sp_GetUserInfo';
  QCommon.Parameters.Clear;
  QCommon.Open;
  Result:= QCommon.FieldByName('RoleName').AsString;
  QCommon.Close;
except
tmpString:= e.Message + #13 + e.ClassName + #13 +
                       'GetUserRoleName';
MessageBox(tmpString, ErrorMessage);
Result:= 'Unknown';
end;
end;

function GetUserFullNameByLogin(inputUser: string): String;
var
   tmpString: AnsiString;
begin
with dmDB do
try
 ExecuteUserInfoQuery(inputUser);
 Result:= QCommon.FieldByName('FullName').AsString;
 QCommon.Close;
except
tmpString:= e.Message + #13 + e.ClassName + #13 +
                       'GetUserRoleName';
MessageBox(tmpString, ErrorMessage);
Result:= 'Unknown';
end;
end;

function GetTemplateProcessInvolvedStatus(inputTemplateProcessId: TIdProcess): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetProcessInvolvedStatus(...)';
 Result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_GetProcessInvolvedStatus';
  SQL.Text:= 'exec sp_GetTemplateProcessInvolvedStatus :p_TemplateProcessId';
  Parameters.Clear;
//--------- Create parameter :p_ProcessId ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TemplateProcessId';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputTemplateProcessId;
//------------------------------------------------------------------------------
  Open();
//  First;
//  if not EOF Then
  Result:= FieldByName('Result').Value;
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;

end;

function GetJobNameProcessItem(inputDocumentId: integer): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetJobNameProcessItem(...)';
 Result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_GetJobNameProcessItem';
  SQL.Text:= 'exec sp_GetJobNameProcessItem :p_TargetDocumentId';
  Parameters.Clear;
//--------- Create parameter :p_TargetDocumentId ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetDocumentId';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputDocumentId;
//------------------------------------------------------------------------------
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;
end;

function GetJobNameProcessItem_DocumentItem(inputDocumentItemId: integer): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetJobNameProcessItem_DocumentItem(...)';
 Result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_GetJobNameProcessItem_DocumentItem';
  SQL.Text:= 'exec sp_GetJobNameProcessItem_DocumentItem :p_TargetDocumentItemId';
  Parameters.Clear;
//--------- Create parameter :p_TargetDocumentItemId ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetDocumentItemId';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputDocumentItemId;
//------------------------------------------------------------------------------
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;
end;

function GetTemplateProcessItem(inputTemplateProcessId: TId): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetTemplateProcessItem(...)';
 Result:= false;
try
 with dmDB.QProcessItem do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_GetTemplateProcessItem';
  SQL.Text:= 'exec sp_GetTemplateProcessItem :p_TargetTemplateProcessId';
  Parameters.Clear;
//--------- Create parameter :p_TargetTemplateProcessId ------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetTemplateProcessId';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputTemplateProcessId;
//------------------------------------------------------------------------------
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;

end;

function GetTemplateProcessItem_Count(inputTemplateProcessId: TId): integer;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetTemplateProcessItemList(...)';
 Result:= -1;
try
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_GetTemplateProcessItem_Count';
  SQL.Text:= 'exec sp_GetTemplateProcessItem_Count :p_TargetTemplateProcessId';
  Parameters.Clear;
//--------- Create parameter :p_TargetTemplateProcessId ------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetTemplateProcessId';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputTemplateProcessId;
//------------------------------------------------------------------------------
  Open();
  if not VarIsNull(Fields[0].Value) then
   Result:= Fields[0].Value
  else
   Result:= -1;
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;

end;

function GetTemplateProcessItem_Info(inputTemplateProcessItemId: TId): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetTemplateProcessItem_Info(...)';
 Result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_GetTemplateProcessItem_Info';
  SQL.Text:= 'exec sp_GetTemplateProcessItem_Info :p_TargetTemplateProcessItemId';
  Parameters.Clear;
//--------- Create parameter :p_TargetTemplateProcessItemId --------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetTemplateProcessId';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputTemplateProcessItemId;
//------------------------------------------------------------------------------
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;

end;


function GetJobItem_TemplateProcessItem_Document(inputTemplateProcessItemId: TId): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetJobItem_TemplateProcessItem_Document(...)';
 Result:= false;
try
 with dmDB.QJobItem do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_GetTemplateJobItem_Document';
  SQL.Text:= 'exec sp_GetTemplateJobItem_Document :p_TargetTemplateProcessItemId';
  Parameters.Clear;
//--------- Create parameter :p_TargetTemplateProcessItemId ------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetTemplateProcessItemId';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputTemplateProcessItemId;
//------------------------------------------------------------------------------
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;

end;


function GetJobItem_TemplateProcessItem_DocumentItem(inputTemplateProcessItemId: TId): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetProcessItemList(...)';
 Result:= false;
try
 with dmDB.QJobItem do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_GetTemplateJobItem_DocumentItem';
  SQL.Text:= 'exec sp_GetTemplateJobItem_DocumentItem :p_TargetTemplateProcessItemId';
  Parameters.Clear;
//--------- Create parameter :p_TargetTemplateProcessItemId ------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetTemplateProcessItemId';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputTemplateProcessItemId;
//------------------------------------------------------------------------------
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;
end;

function GetInstanceJobItem(inputJobItemId: TId): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetInstanceJobItem(...)';
 Result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_GetTemplateJobItem_DocumentItem';
  SQL.Text:= 'exec sp_GetTemplateJobItem_DocumentItem :p_TargetTemplateProcessItemId';
  Parameters.Clear;
//--------- Create parameter :p_TargetTemplateProcessItemId ------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetTemplateProcessItemId';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputJobItemId;
//------------------------------------------------------------------------------
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;
end;

function GetTemplateJobItem(inputTemplateJobItemId: TId): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetTemplateJobItem(...)';
 Result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_GetTemplateJobItem_DocumentItem';
  SQL.Text:= 'exec sp_GetTemplateJobItem_DocumentItem :p_TargetTemplateProcessItemId';
  Parameters.Clear;
//--------- Create parameter :p_TargetTemplateProcessItemId ------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetTemplateProcessItemId';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputTemplateJobItemId;
//------------------------------------------------------------------------------
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');
end;
end;


function GetTemplateProcessList(): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetTemplateProcessList(...)';
 Result:= false;
try
 with dmDB.QProcessList do
 begin
  Close;
  strCurrentStoredProcName:= 'GetTemplateProcessList';
  SQL.Text:= 'exec sp_GetTemplateProcessList';
  Parameters.Clear;
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;
end;

function GetStoreObject_MTR(): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetStoreObject_MTR(...)';
 Result:= false;
try
 with dmDB.QStoreObjectList do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_GetStoreMTRObject_SearchByName';

  tmpString:= 'exec sp_GetStoreMTRObject_SearchByName :p_SortingType';
  Parameters.Clear;

  //--------- Create parameter :p_SortingType ----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_SortingType';
  Parameters[Parameters.Count-1].DataType:= ftInteger;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= 0; //-- Пока не используется, только чтобы избавиться от проблемы с "," при динамическом формировании SQL.Text
//------------------------------------------------------------------------------
{
  if FilterForStoreObjects.GetState = fsOn then
  begin
    if FilterForStoreObjects.GetState = fsOn then
    begin
}
//--------- Create parameter :p_FilterObjectInitiatorOwner ----------------
      Parameters.AddParameter;
      Parameters[Parameters.Count-1].Name:= 'p_FilterObjectInitiatorOwner';
      Parameters[Parameters.Count-1].DataType:= ftString;
      Parameters[Parameters.Count-1].Direction:= pdInput;
      Parameters[Parameters.Count-1].Value:= Null;
     tmpString:= tmpString + ', :p_FilterObjectInitiatorOwner';
//------------------------------------------------------------------------------
     if FilterForStoreObjects.GetStateInitiatorOwner = fsOn then
      Parameters[Parameters.Count-1].Value:= FilterForStoreObjects.GetValueInitiatorOwner;

//--------- Create parameter :p_FilterObjectGroup ----------------
      Parameters.AddParameter;
      Parameters[Parameters.Count-1].Name:= 'p_FilterObjectGroup';
      Parameters[Parameters.Count-1].DataType:= ftString;
      Parameters[Parameters.Count-1].Direction:= pdInput;
      Parameters[Parameters.Count-1].Value:= Null;
     tmpString:= tmpString + ', :p_FilterObjectGroup';
     if FilterForStoreObjects.GetStateObjectsGroup = fsOn then
      Parameters[Parameters.Count-1].Value:= FilterForStoreObjects.GetValueObjectsGroup;

//--------- Create parameter :p_FilterObjectPeriodBeginAsString -----------------
     Parameters.AddParameter;
     Parameters[Parameters.Count-1].Name:= 'p_FilterObjectPeriodBeginAsString';
     Parameters[Parameters.Count-1].DataType:= ftString;
     Parameters[Parameters.Count-1].Direction:= pdInput;
     Parameters[Parameters.Count-1].Value:= Null;
    tmpString:= tmpString + ', :p_FilterObjectPeriodBeginAsString';
    if FilterForStoreObjects.GetStatePeriodCreating = fsOn then
     Parameters[Parameters.Count-1].Value:= FormatDateTime('yyyy-mm-dd', FilterForStoreObjects.GetValuePeriodBeginCreating);
//------------------------------------------------------------------------------
//--------- Create parameter :p_FilterObjectPeriodEndAsString -------------------
     Parameters.AddParameter;
     Parameters[Parameters.Count-1].Name:= 'p_FilterObjectPeriodEndAsString';
     Parameters[Parameters.Count-1].DataType:= ftString;
     Parameters[Parameters.Count-1].Direction:= pdInput;
     Parameters[Parameters.Count-1].Value:= Null;
    tmpString:= tmpString + ', :p_FilterObjectPeriodEndAsString';
    if FilterForStoreObjects.GetStatePeriodCreating = fsOn then
     Parameters[Parameters.Count-1].Value:= FormatDateTime('yyyy-mm-dd', FilterForStoreObjects.GetValuePeriodEndCreating);
//------------------------------------------------------------------------------

//--------- Create parameter :p_FilterObjectPeriodBeginLinkedOrderCreationAsString -----------------
     Parameters.AddParameter;
     Parameters[Parameters.Count-1].Name:= 'p_FilterObjectPeriodBeginLinkedOrderCreationAsString';
     Parameters[Parameters.Count-1].DataType:= ftString;
     Parameters[Parameters.Count-1].Direction:= pdInput;
     Parameters[Parameters.Count-1].Value:= Null;
    tmpString:= tmpString + ', :p_FilterObjectPeriodBeginLinkedOrderCreationAsString';
    if FilterForStoreObjects.GetStatePeriodParentObjectCreating = fsOn then
     Parameters[Parameters.Count-1].Value:= FilterForStoreObjects.GetValuePeriodBeginParentObjectCreating; //FormatDateTime('yyyy-mm-dd', FilterForStoreObjects.GetValuePeriodBeginParentObjectCreating);
//------------------------------------------------------------------------------
//--------- Create parameter :p_FilterObjectPeriodEndLinkedOrderCreationAsString -------------------
     Parameters.AddParameter;
     Parameters[Parameters.Count-1].Name:= 'p_FilterObjectPeriodEndLinkedOrderCreationAsString';
     Parameters[Parameters.Count-1].DataType:= ftString;
     Parameters[Parameters.Count-1].Direction:= pdInput;
     Parameters[Parameters.Count-1].Value:= Null;
    tmpString:= tmpString + ', :p_FilterObjectPeriodEndLinkedOrderCreationAsString';
    if FilterForStoreObjects.GetStatePeriodParentObjectCreating = fsOn then
     Parameters[Parameters.Count-1].Value:= FilterForStoreObjects.GetValuePeriodEndParentObjectCreating; //FormatDateTime('yyyy-mm-dd', FilterForStoreObjects.GetValuePeriodEndParentObjectCreating);
//------------------------------------------------------------------------------


{
   end;
 end; {if}

//--------- Create parameter :p_FilterObjectSearchSubStringForName -------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_FilterObjectSearchSubstringForName';
  Parameters[Parameters.Count-1].DataType:= ftString;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= '%';
  tmpString:= tmpString + ', :p_FilterObjectSearchSubstringForName';
  if FilterForStoreObjects.GetValueSearchSubstringForName <> '' then
     Parameters[Parameters.Count-1].Value:= FilterForStoreObjects.GetValueSearchSubstringForName;
//------------------------------------------------------------------------------

  SQL.Text:= tmpString;
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;

end;


//---------- Устаревшая версия алгоритма (отдельная хранимая процедура) ----------------------
function ExecuteStoreObjectQuery_SearchByName(inputSearchTarget: string): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'ExecuteStoreObjectQuery_SearchByName(...)';
 Result:= false;
try
 with dmDB.QStoreObjectList do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_GetStoreMTRObjects_SearchByName';
  SQL.Text:= 'exec sp_GetStoreMTRObjects_SearchByName :p_NameTarget';
  Parameters.Clear;

//--------- Create parameter :p_IdObjectGroup ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_NameTarget';
   Parameters[Parameters.Count-1].DataType:= ftString;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputSearchTarget;
//------------------------------------------------------------------------------
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;

end;

function ExecuteCommentsForOrderQuery(inputCurrentUser: string; inputDocumentId: TIdDocument): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'ExecuteCommentsForOrderQuery(...)';
 Result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_GetCommentsForOrder';
  SQL.Text:= 'exec sp_GetCommentsForOrder :p_CallerUserAsString, :p_IdOrderAsInteger';
  Parameters.Clear;
//--------- Create parameter :p_CallerUserAsString------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_CallerUserAsString';
  Parameters[Parameters.Count-1].DataType:= ftString;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputCurrentUser;
//------------------------------------------------------------------------------
//--------- Create parameter :p_IdOrderAsInteger -------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_IdOrderAsInteger';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputDocumentId;
//------------------------------------------------------------------------------
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;

end;

function GetCommentForDocument(inputDocumentId: TIdDocument): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetCommentForDocument(...)';
 Result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_GetComment_Document';
  SQL.Text:= 'exec sp_GetComment_Document :p_DocumentId';
  Parameters.Clear;
//--------- Create parameter :p_DocumentId --------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_DocumentId';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputDocumentId;
//------------------------------------------------------------------------------
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;

end;



function GetCommentForDocumentItem(inputDocumentItemId: TIdDocumentItem): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetCommentForDocumentItem(...)';
 Result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_GetComment_DocumentItem';
  SQL.Text:= 'exec sp_GetComment_DocumentItem :p_DocumentItemId';
  Parameters.Clear;
//--------- Create parameter :p_DocumentItemId --------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_DocumentItemId';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputDocumentItemId;
//------------------------------------------------------------------------------
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;

end;


function Document_ExecJob(inputDocumentId: TId; inputJobResult: TJobResult; inputNote: string = ''): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'Document_ExecJob(...)';
 Result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_Document_JobExec';
  SQL.Text:= 'exec sp_Document_JobExec :p_DocumentId, :p_TargetJobResult, :p_TargetNote';
  Parameters.Clear;
//--------- Create parameter :p_DocumentId ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_DocumentId';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputDocumentId;
//------------------------------------------------------------------------------
//--------- Create parameter :p_TargetJobResult --------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetJobResult';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputJobResult;
//------------------------------------------------------------------------------
//--------- Create parameter :p_TargetNote -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_TargetNote';
  Parameters[Parameters.Count-1].DataType:= ftString;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputNote;
//----------------------------------------------------------------------------------
  Open();
{  if not VarIsNull(FieldByName('Result').Value) then
   Result:= FieldByName('Result').Value;
}
  i:= Fields[0].Value;
  if not VarIsNull(Fields[0].Value) then
   Result:= Fields[0].Value;
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;
end;


function DocumentItem_ExecJob(inputDocumentItemId: TId; inputJobResult: TJobResult; inputNote: string = ''): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'DocumentItem_ExecJob(...)';
 Result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_DocumentItem_JobExec';
  SQL.Text:= 'exec sp_DocumentItem_JobExec :p_DocumentItemId, :p_TargetJobResult, :p_TargetNote';
  Parameters.Clear;
//--------- Create parameter :p_DocumentItemId ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_DocumentItemId';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputDocumentItemId;
//------------------------------------------------------------------------------
//--------- Create parameter :p_TargetJobResult --------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_TargetJobResult';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputJobResult;
//------------------------------------------------------------------------------
//--------- Create parameter :p_TargetNote -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_TargetNote';
  Parameters[Parameters.Count-1].DataType:= ftString;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputNote;
//----------------------------------------------------------------------------------
  Open();
{  if not VarIsNull(FieldByName('Result').Value) then
   Result:= FieldByName('Result').Value;
}
  if not VarIsNull(Fields[0].Value) then
   Result:= Fields[0].Value;
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;
end;

function ExecuteDenyToOrdersItem(inputCurrentUser: string; inpuTIdDocument, inpuTIdDocumentsItem: integer; inputResolutionText: string): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'ExecuteDenyToOrdersItem(...)';
 Result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_ActionToDenyOrdersItem';
  SQL.Text:= 'exec sp_ActionToDenyOrdersItem :p_CallerUserAsString, :p_IdOrderAsInteger, :p_IdOrderItemAsInteger, :p_ResolutionText';
  Parameters.Clear;
//--------- Create parameter :p_CallerUserAsString-----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_CallerUserAsString';
  Parameters[Parameters.Count-1].DataType:= ftString;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputCurrentUser;
//----------------------------------------------------------------------------------
//--------- Create parameter :p_IdOrderAsInteger ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_IdOrderAsInteger';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inpuTIdDocument;
//------------------------------------------------------------------------------
//--------- Create parameter :p_IdOrderItemAsInteger ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_IdOrderItemAsInteger';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inpuTIdDocumentsItem;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ResolutionText -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_ResolutionText';
  Parameters[Parameters.Count-1].DataType:= ftString;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputResolutionText;
//----------------------------------------------------------------------------------
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;
end;

function ExecuteAlterToOrdersItem(inputCurrentUser: string; inpuTIdDocument, inpuTIdDocumentsItem: integer; inputResolutionText: string): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'ExecuteAlterToOrdersItem(...)';
 Result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_ActionToAlterOrdersItem';
  SQL.Text:= 'exec sp_ActionToAlterOrdersItem :p_CallerUserAsString, :p_IdOrderAsInteger, :p_IdItemAsInteger, :p_ResolutionText';
  Parameters.Clear;
//--------- Create parameter :p_CallerUserAsString------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_CallerUserAsString';
  Parameters[Parameters.Count-1].DataType:= ftString;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputCurrentUser;
//------------------------------------------------------------------------------
//--------- Create parameter :p_NeededIdOrder ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_IdOrderAsInteger';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inpuTIdDocument;
//------------------------------------------------------------------------------
//--------- Create parameter :p_NeededIdItem ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_IdItemAsInteger';
   Parameters[Parameters.Count-1].DataType:= ftInteger;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inpuTIdDocumentsItem;
//------------------------------------------------------------------------------
//--------- Create parameter :p_ResolutionText ---------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_ResolutionText';
  Parameters[Parameters.Count-1].DataType:= ftString;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputResolutionText;
//------------------------------------------------------------------------------
  Open();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;
end;

function GetDataReport_MTR_ForBuying(inputObjectGroupCode: TIdSpravObject = 0 {все группы}): boolean;
var
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'ExecuteQueryObjectsForReport(...)';
try
 result:= false;
 with dmDB.QReport1 do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_Report_MTR_ForBuying';
  SQL.Text:= 'exec sp_Report_MTR_ForBuying'; //, :p_ObjectGroupCode';
  Parameters.Clear;
//--------- Create parameter :p_ObjectGroupCode-----------------------------------
{
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_ObjectGroupCode';
  Parameters[Parameters.Count-1].DataType:= ftInteger;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputObjectGroupCode;
}
//----------------------------------------------------------------------------------
  Open();
 end;
 result:= true;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');
 result:= false;
end;
end;

function GetRoutePointForOrder(inputUser: string; inpuTIdDocument: integer): Integer;
var
   tmpString: AnsiString;
begin
with dmDB do
try
 Result:= MaxRoutesPointsCount; //--- Временно, пока не будет отработан алгоритм
{
 ExecuteQueryWithParam1AsInteger('exec sp_GetRoutePointForOrder p_IdOrderAsInteger', inpuTIdDocument);
 Result:= QCommon.FieldByName('CountRoutePoint').AsInteger;
 QCommon.Close;
}
except
tmpString:= e.Message + #13 + e.ClassName + #13 +
                       'GetUserRoleName';
MessageBox(tmpString, ErrorMessage);
Result:= -1;
end;
end;

function GetJobCode_byName(inputJobName: string; inputDocumentType: TDocumentType): TIdJob;
var
    strCurrentProcName, tmpString: AnsiString;
begin
with dmDB do
try
 strCurrentProcName:= 'GetJobCode_byName(...)';
 Result:= 0;
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'exec sp_GetJobCode_byName :p_ProcessTemplate, :p_JobName';
  Parameters.Clear;
//--------- Create parameter :p_ProcessTemplate -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_ProcessTemplate';
  Parameters[Parameters.Count-1].DataType:= ftInteger;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputDocumentType;
//----------------------------------------------------------------------------------
//--------- Create parameter :p_JobName -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_ProcessId';
  Parameters[Parameters.Count-1].DataType:= ftString;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputJobName;
//----------------------------------------------------------------------------------
  Open();

 if dmDB.QCommon.FieldByName(queryFieldName_JobCode).Value <> Null then
  Result:= dmDB.QCommon.FieldByName(queryFieldName_JobCode).Value
 else
  Result:= 0;
  Close;
 end;
except
tmpString:= e.Message + #13 + e.ClassName + #13 +
                       'GetUserRoleName';
MessageBox(tmpString, ErrorMessage);
Result:= 0;
end;
end;

function SwitchOnOffRoute(inputRouteCode: TRouteCode; inputCurrentUser: string): Boolean;
var
   strCurrentProcName, strCurrentStoredProcName: string;
   i: integer;
begin
 strCurrentProcName:= 'SwitchOnOffRoute(...)';
try
 result:= false;
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_SwitchOnOffRoute';
  SQL.Text:= 'exec sp_SwitchOnOffRoute :p_CallerUserAsString, :p_ObjectGroupCode';
  Parameters.Clear;
//--------- Create parameter :p_CallerUserAsString-----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_CallerUserAsString';
  Parameters[Parameters.Count-1].DataType:= ftString;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputCurrentUser;
//----------------------------------------------------------------------------------
//--------- Create parameter :p_inputRouteCode-----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_RouteCode';
  Parameters[Parameters.Count-1].DataType:= ftInteger;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputRouteCode;
//----------------------------------------------------------------------------------
  Open();
 end;
 result:= true;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');
 result:= false;
end;
end;

//------------------------------------------------------------------------------
//----------- Begin of: [Create, Edit, Delete] RouteItem ----------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------ EditUser --------------------------------------------------
//------------------------------------------------------------------------------
function EditUser(inputUserLogin: string; inputUserFIO: string; inputUserJobRoleCode: TIdJobRole; inputUserNotes: string): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'EditUser(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_EditUser :p_UserLogin, :p_UserFIO, ';
  SQL.Text:= SQL.Text + ':p_UserJobRoleCode, :p_UserNotes';
  Parameters.Clear;

//--------- Create parameter :p_UserLogin --------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_UserLogin';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputUserLogin;
//------------------------------------------------------------------------------
//--------- Create parameter :p_UserFIO ----------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_UserFIO';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputUserFIO;
//------------------------------------------------------------------------------
//--------- Create parameter :p_UserJobPositionCode ----------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_UserJobPositionCode';
 Parameters[Parameters.Count-1].DataType:= ftInteger;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputUserJobRoleCode;
//------------------------------------------------------------------------------
//--------- Create parameter :p_UserNotes --------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_UserNotes';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputUserNotes;
//------------------------------------------------------------------------------

  Open();
//  ExecSQL;
  if fields[0].AsInteger <> 0 then
  begin
   tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//------------------ DeleteUser ------------------------------------------------
//------------------------------------------------------------------------------

function DeleteUser(inputCallerUser: string; inputUserLogin: string): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'DeleteUser(...)';
 result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  SQL.Text:= 'EXEC sp_DeleteUser :p_CallerUserAsString, :p_UserLogin';
  Parameters.Clear;

//--------- Create parameter :p_CallerUserAsString ---------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_CallerUserAsString';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputCallerUser;
//------------------------------------------------------------------------------
//--------- Create parameter :p_UserLogin --------------------------------------
 Parameters.AddParameter;
 Parameters[Parameters.Count-1].Name:= 'p_UserLogin';
 Parameters[Parameters.Count-1].DataType:= ftString;
 Parameters[Parameters.Count-1].Direction:= pdInput;
 Parameters[Parameters.Count-1].Value:= inputUserLogin;
//------------------------------------------------------------------------------
  Open();
  if fields[0].AsInteger <> 0 then
  begin
   tmpString:= 'EXEC ' + strCurrentProcName + ' завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, strCurrentProcName + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//----------- End of: [Create, Edit, Delete] User ------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------



function GetServerStorageProcedures(): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetStorageProcedures(...)';
 Result:= false;
try
 with dmDB.QSPText do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_adm_Get_SP_Text';
  SQL.Text:='exec sp_adm_Get_SP_Text';
  Parameters.Clear;

  Open();
 end;
 dmDB.dbConnectionAsSA.Close;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;

end;

function GetServerFunctiones(): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'GetServerFunction(...)';
 Result:= false;
try
 with dmDB.QSPText do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_adm_Get_F_Text';
  SQL.Text:='exec sp_adm_Get_F_Text';
  Parameters.Clear;

  Open();
 end;
 dmDB.dbConnectionAsSA.Close;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;

end;


function PutSP_Fn_Absolete_MustDeleted(inputUNCFileName: string): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i, iFileSize: integer;
 pBuffer: Pointer;
begin
 strCurrentProcName:= 'PutStorageProceduresAndFunction(...)';
 Result:= false;
try
 with dmDB.QSPText do
 begin
  strCurrentStoredProcName:= 'sp_X'; //'sp_PutSP_FText';
  iFileSize:= MyGetFileSize(inputUNCFileName);
  GetMem(pBuffer, MyGetFileSize(inputUNCFileName));
  if OpenFileToMemory(inputUNCFileName, pBuffer, MyGetFileSize(inputUNCFileName)) then
  begin
   SQL.Text:= 'exec sp_X :p_Text';
   Parameters.Clear;
//--------- Create parameter :p_Text ---------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_Text';
   Parameters[Parameters.Count-1].DataType:= ftString;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= StrPas(pBuffer);
//------------------------------------------------------------------------------
   ShowMessage(StrPas(pBuffer));

//   WriteDBErrorToLog('', '', 'dbConnectionAsSA', 'SQL.Text', CommandText, '');
//   Prepared:= true;
//   if Prepared then
//   begin
//    dmDB.dbConnectionAsSA.Open;
    Open();
{
 with dmDB.dbCommandAsSA do
 begin
  strCurrentStoredProcName:= 'sp_X'; //'sp_PutSP_FText';
  iFileSize:= MyGetFileSize(inputUNCFileName);
  GetMem(pBuffer, MyGetFileSize(inputUNCFileName));
  if OpenFileToMemory(inputUNCFileName, pBuffer, MyGetFileSize(inputUNCFileName)) then
  begin
   CommandText:= StrPas(pBuffer);
   ShowMessage(CommandText);
   Parameters.Clear;
   WriteDBErrorToLog('', '', 'dbConnectionAsSA', 'SQL.Text', CommandText, '');
   Prepared:= true;
   if Prepared then
   begin
    dmDB.dbConnectionAsSA.Open;
    Execute;
}
   end
   else
   begin
    for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
     WriteDBErrorToLog('', dmDB.dbConnectionAsSA.Errors[1].Description, dmDB.dbConnectionAsSA.Errors[i].Source, '', strCurrentProcName, '');
   end;
  end;
// end;
 dmDB.dbConnectionAsSA.Close;
 FreeMem(pBuffer);
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');
 FreeMem(pBuffer, SizeOf(pBuffer));
end;

end;


function PutSP_FnToServer(var inputTextPointer: PChar): TSQLServerError;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i, iFileSize: integer;
 pBuffer: Pointer;
begin
 strCurrentProcName:= 'PutSPToServer(...)';
 Result:= 0;
try
 with dmDB.QSPText do
 begin
  strCurrentStoredProcName:= 'sp_adm_AlterSP';
  SQL.Text:= 'exec sp_adm_AlterSP :p_Text';
  Parameters.Clear;
//--------- Create parameter :p_Text ---------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_Text';
  Parameters[Parameters.Count-1].DataType:= ftBlob;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= StrPas(inputTextPointer);
//------------------------------------------------------------------------------
//  ShowMessage(StrPas(inputTextPointer));
  Open;
  if not VarIsNull(FieldByName('ErrorNumber').Value) then
   Result:= FieldByName('ErrorNumber').Value
  else
   Result:= 0;
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');
 FreeMem(pBuffer, SizeOf(pBuffer));
end;

end;


function IsSP_FnExists(inputTargetSPName: string): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
 i: integer;
begin
 strCurrentProcName:= 'IsSPExists(...)';
 Result:= false;
try
 with dmDB.QCommon do
 begin
  Close;
  strCurrentStoredProcName:= 'sp_adm_GetProgrammabilityObjectExistsStatus';
  SQL.Text:= 'exec sp_adm_GetProgrammabilityObjectExistsStatus :p_SPName';
  Parameters.Clear;
//--------- Create parameter :p_NeededIdRoute ----------------------------------
   Parameters.AddParameter;
   Parameters[Parameters.Count-1].Name:= 'p_IdRoute';
   Parameters[Parameters.Count-1].DataType:= ftString;
   Parameters[Parameters.Count-1].Direction:= pdInput;
   Parameters[Parameters.Count-1].Value:= inputTargetSPName;
//------------------------------------------------------------------------------
  Open();
//  First;
//  if not EOF Then
  Result:= FieldByName('Result').Value;
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', strCurrentProcName, '');

end;

end;

function GetJobProcessItem_MTR(inputDocumentItemId: TIdDocument): boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetJobProcessItem_MTR(...)';
 Result:= false;
try
with dmDB.QJob do
begin
   Close();
   SQL.Text:= 'EXEC sp_GetJobProcessItem_MTR :p_DocumentItemId';
   Parameters.Clear;
//--------- Create parameter :p_DocumentItemId -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_DocumentItemId';
  Parameters[Parameters.Count-1].DataType:= ftInteger;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputDocumentItemId;
//----------------------------------------------------------------------------------
  Open();
  Result:= true;
end;

except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

function GetFirstDocumentItem(inputDocumentId: TIdDocument): TIdDocumentItem;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetFirstDocumentItem(...)';
 Result:= -1;
try
with dmDB.QJob do
begin
   Close();
   SQL.Text:= 'EXEC sp_GetDocumentItem_First :p_DocumentId';
   Parameters.Clear;
//--------- Create parameter :p_DocumentId -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_DocumentId';
  Parameters[Parameters.Count-1].DataType:= ftInteger;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputDocumentId;
//----------------------------------------------------------------------------------
  Open();
  if not VarIsNull(FieldByName('Result').Value) then
    Result:= FieldByName('Result').Value;
end;

except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;


function GetMinProcessItem_Document(inputDocumentId: TIdDocument): integer;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetMinProcessItem_Document(...)';
 Result:= -1;
try
with dmDB.QJob do
begin
   Close();
   SQL.Text:= 'EXEC sp_GetProcessItemMinimal_Document :p_DocumentId';
   Parameters.Clear;
//--------- Create parameter :p_DocumentId -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_DocumentId';
  Parameters[Parameters.Count-1].DataType:= ftInteger;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputDocumentId;
//----------------------------------------------------------------------------------
  Open();
  if not VarIsNull(FieldByName('Result').Value) then
    Result:= FieldByName('Result').AsInteger;
end;

except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;


function GetCanChangeState_DocumentItem(inputDocumentItemId: TIdDocument): TCanChangeStatus;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetCanChangeStatus_DocumentItem(...)';
 Result:= ccsCanNot;
try
with dmDB.QCommon do
begin
   Close();
   SQL.Text:= 'EXEC sp_CanChangeState_DocumentItem :p_DocumentItemId';
   Parameters.Clear;
//--------- Create parameter :p_DocumentItemId -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_DocumentItemId';
  Parameters[Parameters.Count-1].DataType:= ftInteger;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputDocumentItemId;
//----------------------------------------------------------------------------------
  Open();
  if not VarIsNull(FieldByName('Result').Value) then
   if FieldByName('Result').Value = 1 then
    Result:= ccsCan;
end;

except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;


function GetJobExistsStatus_DocumentItem(inputDocumentItemId: TIdDocument): TJobExistsStatus;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetJobExistsStatus_DocumentItem(...)';
 Result:= jesJobNotExists;
try
with dmDB.QJob do
begin
   Close();
   SQL.Text:= 'EXEC sp_GetJobExistsStatus_DocumentItem :p_DocumentItemId';
   Parameters.Clear;
//--------- Create parameter :p_DocumentItemId -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_DocumentItemId';
  Parameters[Parameters.Count-1].DataType:= ftInteger;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputDocumentItemId;
//----------------------------------------------------------------------------------
  Open();
  if not VarIsNull(FieldByName('Result').Value) then
   if FieldByName('Result').AsBoolean then
    Result:= jesJobExists;
end;

except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;


function GetJobExistsStatus_Document(inputDocumentId: TIdDocument): TJobExistsStatus;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetJobExistsStatus_Document(...)';
 Result:= jesJobNotExists;
try
with dmDB.QJob do
begin
   Close();
   SQL.Text:= 'EXEC sp_GetJobExistsStatus_Document :p_DocumentId';
   Parameters.Clear;
//--------- Create parameter :p_DocumentItemId -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_DocumentId';
  Parameters[Parameters.Count-1].DataType:= ftInteger;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputDocumentId;
//----------------------------------------------------------------------------------
  Open();
  if not VarIsNull(FieldByName('Result').Value) then
   if FieldByName('Result').AsBoolean then Result:= jesJobExists;
end;

except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;



function GetEditStatus_Document(inputDocumentId: TId):boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetEditStatus_Document(...)';
 Result:= false;
try
with dmDB.QCommon do
begin
   Close();
   SQL.Text:= 'EXEC sp_GetEditStatus_Document :p_DocumentId';
   Parameters.Clear;
//--------- Create parameter :p_DocumentId -------------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_DocumentId';
  Parameters[Parameters.Count-1].DataType:= ftInteger;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputDocumentId;
//------------------------------------------------------------------------------
  Open();
  if not VarIsNull(FieldByName('Result').Value) then
    Result:= FieldByName('Result').Value;
end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;


function GetEditStatus_DocumentItem(inputDocumentItemId: TId):boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetEditStatus_DocumentItem(...)';
 Result:= false;
try
with dmDB.QCommon do
begin
   Close();
   SQL.Text:= 'EXEC sp_GetEditStatus_DocumentItem :p_DocumentItemId';
   Parameters.Clear;
//--------- Create parameter :p_DocumentItemId -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_DocumentItemId';
  Parameters[Parameters.Count-1].DataType:= ftInteger;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputDocumentItemId;
//----------------------------------------------------------------------------------
  Open();
  if not VarIsNull(FieldByName('Result').Value) then
    Result:= FieldByName('Result').Value;
end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;

function GetJobItemExtendExistsStatus_DocumentItem(inputDocumentItemId: TIdDocument): TJobExistsStatus;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetJobItemExtendExistsStatus_DocumentItem(...)';
 Result:= jesJobNotExists;
try
with dmDB.QJob do
begin
   Close();
   SQL.Text:= 'EXEC sp_GetJobItemExtendExistsStatus_DocumentItem :p_DocumentItemId';
   Parameters.Clear;
//--------- Create parameter :p_DocumentItemId -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_DocumentItemId';
  Parameters[Parameters.Count-1].DataType:= ftInteger;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputDocumentItemId;
//----------------------------------------------------------------------------------
  Open();
  if not VarIsNull(FieldByName('Result').Value) then
   Result:= FieldByName('Result').Value;
end;

except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;
end;


function GetJobParameter(inputJobItemId: TId):boolean;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetJobParameter(...)';
 Result:= false;
try
with dmDB.QCommon do
begin
   Close();
   SQL.Text:= 'EXEC sp_GetJobItemParameter :p_JobItemId';
   Parameters.Clear;
//--------- Create parameter :p_JobItemId -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_JobItemId';
  Parameters[Parameters.Count-1].DataType:= ftInteger;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputJobItemId;
//----------------------------------------------------------------------------------
  Open();
  Result:= true;
end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
  end;
end;

end;

function GetTemplateJobItemLevelNext(inputProcessItemId: TId):TId;
var
 tmpString: AnsiString;
 strCurrentProcName: string; {для хранения имени текущей процедуры/функции - унификация подстановки}
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'GetTemplateJobItemLevelNext(...)';
 Result:= -1;
try
with dmDB.QJobItem do
begin
   Close();
   SQL.Text:= 'EXEC sp_GetTemplateJobItemLevel_Next :p_TemplateProcessItemId';
   Parameters.Clear;
//--------- Create parameter :p_JobItemId -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_JobItemId';
  Parameters[Parameters.Count-1].DataType:= ftInteger;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= inputProcessItemId;
//----------------------------------------------------------------------------------
  Open();
  if not VarIsNull(FieldByName('Result').Value) then
    Result:= FieldByName('Result').Value;
end;
except
 On e: EOleException do
  begin
   WriteDBErrorToLog(e.Source, e.Message, e.ClassName, e.HelpFile, strCurrentProcName, strCurrentStoredProcName);
   Result:= -1;
  end;

 On e: Exception do
  begin
   WriteDBErrorToLog('', e.Message, e.ClassName, '', strCurrentProcName, strCurrentStoredProcName);
   Result:= -1;
  end;
end;

end;

end.
