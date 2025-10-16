unit unUtilCommon;
interface
uses Forms, Controls, Windows, ComCtrls, SysUtils, ADOdb, DB,
     DBCtrlsEh, Variants, DateUtils, Classes,
     StdCtrls, ExtCtrls, ToolWin, Messages, CheckLst,
     DBGrids, DBTables, Grids, ShellApi, Dialogs,
     unConstant, unVariable;

procedure MessageBox(MessageText: string; MessageType: TMessageType; editTextNew: string = '');
function ConfirmDlg(ConfirmText: string): TConfirmResult;
function CanEnter(inputLoginDialogForm: TForm): boolean;

function AllTrim(MyString: String):String;
procedure SetTextAsInteger(Sender: TObject; var Key: Char);
procedure SetTextAsReal(Sender: TObject; var Key: Char);
//function IsDateAsTextValid(InputStringAsDate: String):boolean; //external 'CommonUtils.dll';
function IsDateAsTextNotEmpty(InputDateTimePicker: TDBDatetimeEditEh):boolean;

//-------------- Procedures thats have been work with StatusBar ----------------
procedure SetCursorWait(workStatusBar: TStatusBar);
procedure SetCursorIdle(workStatusBar: TStatusBar);
procedure ShowActiveUserDB(workStatusBar: TStatusBar);
procedure ShowInfoOnStatusBar(TargetPanelNum: byte; inputText: string);
//------------------------------------------------------------------------------

//-------------- Procedures thats have been worked with Interface --------------
procedure SetInterfaceAfterCommonInfoChange(Sender: TObject);
procedure SetInterfaceAfterDocumentTypeChange;
procedure SetButtonStateForCurrentDocumentType;
procedure SetButtonState_DocumentMTR;
procedure SetMainMenuStateForActiveUser;
//------------------------------------------------------------------------------

procedure ShowObjectDetailedInfo(inpuTIdDocument: TIdDocument);
function RefreshDocument: boolean;
function RefreshDocumentHierarchical(InputTreeView: TTreeView; inputDocHierarchicalType: TDocumentViewType): boolean;
function RefreshStoreObjectList: boolean;
function RefreshInfoAfterDocumentChange: boolean;


//procedure ShowDataForSelectedNode(InputTreeView: TTreeView; Node:  TTreeNode);
procedure ShowDataForSelectedNode;
procedure ShowDocumentItem_Document(inputDocumentId: integer);
procedure ShowOrderItems_ObjectManufacturing_ForTreeView(InputTreeView: TTreeView);
procedure ShowOrderItems_ObjectManufacturing_ForDBGrid(InpuTIdDocument: TIdDocument);

procedure ShowProcessItem_Document(InputCheckListBox: TCheckListBox; inputDocumentId: TIdDocument);
procedure ShowProcessItem_DocumentItem(InputCheckListBox: TCheckListBox; inputDocumentItemId: TIdDocument);
procedure ShowTemplateProcessList(InputDBGrid: TDBGrid);
procedure ShowProgramRoleList(InputDBGrid: TDBGrid; var InputQuery: TADOQuery);

function ShowCommentForSelectedDocument(var InputTreeView: TTreeView; inputDocumentId: TIdDocument): boolean;
function ShowCommentForSelectedDocumentItem(var InputTreeView: TTreeView; inputDocumentItemId: TIdDocumentItem): boolean;
procedure ShowObjectItemsTree_Manufacture(var InputTreeView: TTreeView; inpuTIdDocument: TIdDocument; inpuTIdDocumentsItems: TIdDocumentItem);
//procedure ShowObjectItemsTree_Manufacture(var InputTreeView: TTreeView; inputTargetNode: TTreeNode);
procedure ShowJobDocument_MTR(var InputPanel: TPanel);
procedure ShowProcessItemJob_Document_MTR(var InputPanel: TPanel);
procedure ShowProcessItemJob_DocumentItem_MTR(var InputPanel: TPanel);


procedure DenyOrdersItem(inpuTIdDocument, inpuTIdDocumentsItem: integer; ResolutionText: string);
procedure AlterOrdersItem(inpuTIdDocument, inpuTIdDocumentsItem: integer; ResolutionText: string);


//procedure FillComboBoxFromQuery(InputComboBox: TComboBox; InputSQLText: string; InputField: string; inputParam1: string = '');
procedure FillComboBoxFromQuery(InputComboBox: TComboBox; var InputAssignedQuery: TADOQuery; InputField: string);
procedure FillEditFromQuery(InputEdit: TEdit; InputSQLText: string; InputField: string; inputParam1: string = '');
procedure FillListBoxFromQuery(InputListBox: TListBox; InputSPName: string; InputField: string; inputParam1: integer = 0);
procedure FillMemoFromQuery(InputMemo: TMemo; InputSQLText: string; InputField: string; inputParam1: string = '');
procedure FillArrayFromQuery(var InputArray: TVariantArray; InputSQLText: string; InputField: string; inputParam1: string = '');
function FindRecordInQuery(InputQuery: TADOQuery; SourceFieldName: string; InputValue: Variant): boolean;


function PrepareReport_MTR_ForBuying(): boolean;

function RefreshTreeViewUserJobRole(InputTreeView: TTreeView): boolean;

function GetUserFullName(inputUserShortName: string): string;
function GetAttachmentForDocumentItem(inputDocumentItemId: TIdDocumentItem; var outputAttachments: TAttachment): word;
function OpenAttachment(inputAttachmentNumber: integer; inputAttachment: TAttachment): boolean;
function GetProgramRolesForCurrent(TargetUserLoginName: string; TargeTIdDocument: TIdDocument): TProgramRoles;

function IsTemplateProcessInvolvedInDocument(inputProcessId: TIdProcess): boolean;


//------- Для работы с Tree ----------------------------------------------------
function FindPositionInTreeByName(InputTreeView: TTreeView; findingNodeName: string): boolean;
function FindPositionInTreeBy(InputTreeView: TTreeView; findingNodeName: string; neededValue: Variant): boolean;
//function ConvertPointerToIdObjectItem(targetNode: TTreeNode): TIdDocumentItem;
function ConvertPointerToIdObjectItem(targetPointer: Pointer): TIdDocumentItem;
function GetParentTreeNodeIndex(inputTreeItems: TTreeItemArray; inputTargetIdItem: TIdDocumentItem; inputMaxArrayNumber: integer = maxObjectItemsCount_Manufacturing): integer;
procedure OrdersQuickSearch(inputSearchTarget: string );
procedure StoreObjectQuickSearch(inputSearchTarget: string);
//------------------------------------------------------------------------------

//-------- Для работы с .log ---------------------------------------------------
procedure WriteDBErrorToLog(E_source1, E_source2, E_source3, E_source4, CurrentProcName, CurrentStoredProcName: string);
procedure WriteDataToLog(E_source1, CurrentProcName, CurrentUnitName: string);
//------------------------------------------------------------------------------

function Replicate(Substr: String; Count: Word): String;
function MyFormatString(MyOperand: String; MyLenString: word; MytxFormatText: TFormatText): String;

//----------------- Тестовые процедуры и функции -------------------------------
//procedure Test_ExecAlterSPFromText();
//------------------------------------------------------------------------------


implementation
uses unDBUtil, unDM, unConfirmDlg, unMessageBox, unMain, unEditSettings, unUtilFiles, unJob;

procedure MessageBox(MessageText: string; MessageType: TMessageType; editTextNew: string = '');
begin
  Application.CreateForm(TformMessageBox, formMessageBox);
  formMessageBox.stMessageText.Caption:= MessageText;
  case MessageType of
   ErrorMessage: formMessageBox.imgMessageType.Picture:= formMessageBox.imgError.Picture;
   InfoMessage: formMessageBox.imgMessageType.Picture:= formMessageBox.imgInfo.Picture;
   EditMessage:
    begin
     formMessageBox.imgMessageType.Picture:= formMessageBox.imgEdit.Picture;
     formMessageBox.edNewText.Visible:= true;
     formMessageBox.edNewText.Text:= editTextNew;
    end
  else formMessageBox.imgMessageType.Picture:= formMessageBox.imgInfo.Picture;
  end; {case}
  formMessageBox.ShowModal;
  formMessageBox.Free;
end;

function ConfirmDlg(ConfirmText: string): TConfirmResult;
begin
  Application.CreateForm(TformConfirmDlg, formConfirmDlg);
  formConfirmDlg.stConfirmText.Caption:= ConfirmText;
  formConfirmDlg.ShowModal;
  result:= formConfirmDlg.ConfirmResult;
  formConfirmDlg.Free;
end;

function CanEnter(inputLoginDialogForm: TForm): boolean;
var
  LoginAttemptCount: word;
  retcode: integer;
begin
try
 LoginAttemptCount:= 3;
 retcode:= mrNone;
  while (LoginAttemptCount >= 0) and (retcode <> mrCancel) and (retcode <> mrOk) do
  begin
   dec(LoginAttemptCount);
   retcode:= inputLoginDialogForm.ShowModal();
  end;
  inputLoginDialogForm.Free();
 Result:= (retcode = mrOk) and (IsAuthenticationDone());
except
 Application.ShowException(E);      
 Result:= false;
end;
end;

function AllTrim(MyString: String):String;
var
   FirstSymb,LastSymb:byte;
   TekChar:char;
begin
Result:='';
if MyString<>'' then
 begin
   FirstSymb:=1;
   try
     TekChar:=MyString[FirstSymb];
     while (FirstSymb<=length(MyString)) and
          (TekChar=' ') do
       begin // while
        FirstSymb:=FirstSymb+1; //
        TekChar:=MyString[FirstSymb];
       end; // while
     LastSymb:=length(MyString);
     while (LastSymb>=0) and (MyString[LastSymb]=' ') do
            LastSymb:=LastSymb-1; //
     for FirstSymb:=FirstSymb to LastSymb do
        Result:=Result+MyString[FirstSymb];
   except
     Result:='';
   end; // try
 end; // if <>''
end; // AllTrim(MyString:String)


procedure SetCursorWait(workStatusBar: TStatusBar);
begin
  lastCursor:= Screen.Cursor;
  Screen.Cursor:= crHourGlass;
  workStatusBar.Panels[0].Text:= 'Wait';
end;

procedure SetCursorIdle(workStatusBar: TStatusBar);
begin
  Screen.Cursor:= lastCursor;
  workStatusBar.Panels[0].Text:= 'Idle';
end;

//######################## GetSubStr ##################################
function GetSubStr(FullString:String;Index:Byte;Count:Integer):String;
begin
if Count<>-1 then
   Result:=copy(FullString,Index,Count)
else
   Result:=copy(FullString,Index,(length(FullString)-Index+1));
end; // GetSubStr

//############################### IndexInString ########################
function IndexInString(SubStr,FullString:String; MyPosBegin: Word): Word;
var
   MyStr: String;
begin
MyStr:= GetSubStr(FullString,MyPosBegin,-1);
Result:=pos(SubStr, MyStr);

end; // IndexInString(FullString,SubStr:String)

procedure SetTextAsInteger(Sender: TObject; var Key: Char);
begin

if not (Sender is TCustomEdit) then
begin
 beep;
 abort;
end;
 case key  of
  '0'..'9', #8: key:=key;
           #13:  PostMessage(0, WM_NEXTDLGCTL, 0, 0);
   else
   begin
    Beep ;
    Abort
   end;
  end;
end;

procedure SetTextAsReal(Sender: TObject; var Key: Char);
begin

if not (Sender is TCustomEdit) then
begin
 beep;
 abort;
end;
 case key  of
  '0'..'9', #8: key:=key;
           #13:  PostMessage(0, WM_NEXTDLGCTL, 0, 0);
char('.'), char(','):
                begin
                 if IndexInString(key, (Sender as TCustomEdit).Text, 1) = 0 then
                  key:= char(DecimalPointDelemiter)
                 else
                 begin
                  Beep ;
                  Abort
                 end;

                end;
   else
   begin
    Beep ;
    Abort
   end;
  end;
end;


procedure ShowActiveUserDB(workStatusBar: TStatusBar);
begin
  workStatusBar.Panels[1].Text:= 'Act. user: ';
end;


procedure ShowObjectDetailedInfo(inpuTIdDocument: TIdDocument);
var
 tmpString: AnsiString;
begin
try
  if assigned(formMain.pcontCommonInfo.ActivePage.OnShow) then
    formMain.pcontCommonInfo.ActivePage.OnShow(nil);
except
 tmpString:= e.Message + #13 + e.ClassName();
 WriteLn(logFile, 'ShowObjectDetailedInfo(...)' + 'Error: ' + tmpString);
end;
end;

function RefreshDocument: boolean;
var
  curRecordPos: TIdDSPositionSaver;
  curRecordPos1: TIdDSPositionSaver;
  tmpString: string;
begin
 result:= false;
 exit;
try
if dmDB.QDocument.Active then
begin
 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocument);
 curRecordPos1:= DSPositionSaver.SavePosition(CurrentActiveQueryDocumentItem);
 dmDB.QDocument.Refresh;
// if dmDB.QDocumentItem.Active then CurrentActiveQueryDocumentItem.Refresh;
 DSPositionSaver.RestorePosition(dmDB.QDocument, curRecordPos);
 DSPositionSaver.RestorePosition(CurrentActiveQueryDocumentItem, curRecordPos1);
 result:= true;
end;
except
 if Assigned(e) then tmpString:= e.Message + #13 + e.ClassName()
              else tmpString:= 'Ошибка внутри процедуры...';
 WriteLn(logFile, 'RefreshOrders(...)' + 'Error: ' + tmpString);
end;
end;


function RefreshInfoAfterDocumentChange: boolean;
begin
 result:= false;
 ShowProcessItem_Document(formMain.clbProcessItemList, CurrentDocument.IdDocument);
// ShowCommentForSelectedDocument(formMain.tvDocumentComment, CurrentDocumentItem.Id);

 ShowDocumentItem_Document(CurrentDocument.IdDocument);

 result:= true;
end;


function RefreshStoreObjectList: boolean;
var
 tmpString: AnsiString;
begin
 result:= false;
try
 GetStoreObject_MTR();
 formMain.dbgrStoreMTR.Refresh;
 result:= true;
except
 tmpString:= e.Message + #13 + e.ClassName();
 WriteLn(logFile, 'RefreshOrders(...)' + 'Error: ' + tmpString);
end;
end;

procedure OrdersQuickSearch(inputSearchTarget: string);
var
 tmpString: AnsiString;
begin
try
 if inputSearchTarget <> '' then
 begin
  if formMain.popMSearch_byBeginingAs.Checked then
//   ExecuteCardsQuerySearchByName(inputSearchTarget + '%');
  if formMain.popMSearch_byIncludingAs.Checked then
//   ExecuteCardsQuerySearchByName('%' + AllTrim(inputSearchTarget) + '%');
 end
 else GetDocument_Total_byJob(formMain.tvHierarchicalTotal.Selected.Text, byCreationDate, TargetDocumentType);
except
 tmpString:= e.Message + #13 + e.ClassName();
 WriteLn(logFile, 'ClientsCardsQuickSearch(...)' + 'Error: ' + tmpString);
 try
  GetDocument_Total_byJob(formMain.tvHierarchicalTotal.Selected.Text, byCreationDate, TargetDocumentType);
 except
  tmpString:= e.Message + #13 + e.ClassName();
  WriteLn(logFile, 'ExecuteCardsQuery(byName)' + 'Error: ' + tmpString);
 end;
end;
end;

procedure StoreObjectQuickSearch(inputSearchTarget: string);
var
 tmpString: AnsiString;
begin
try if inputSearchTarget <> '' then
 begin
  if FilterForStoreObjects.GetStateSearchSubstringForName = fsBeginingAs then
   tmpString:= inputSearchTarget + '%';
  if FilterForStoreObjects.GetStateSearchSubstringForName = fsIncludingAs then
   tmpString:= '%' + AllTrim(inputSearchTarget) + '%';
 end
 else tmpString:= '';
 FilterForStoreObjects.SetValueSearchSubstringForName:= tmpString;
 GetStoreObject_MTR();
except
 tmpString:= e.Message + #13 + e.ClassName();
 WriteLn(logFile, 'StoreObjectQuickSearch(...)' + 'Error: ' + tmpString);
 try
  GetDocument_Total_byJob(formMain.tvHierarchicalTotal.Selected.Text, byCreationDate, TargetDocumentType);
 except
  tmpString:= e.Message + #13 + e.ClassName();
  WriteLn(logFile, 'StoreObjectQuickSearch(inputSearchTarget: string)' + 'Error: ' + tmpString);
 end;
end;
end;

function IsDateAsTextNotEmpty(InputDateTimePicker: TDBDatetimeEditEh):boolean;
begin
 try
//  result:= InputDateTimePicker.Text <> ' . . ';
  result:= VarIsNull(InputDateTimePicker.Value);
 except
  result:= false;
 end;
end;

procedure WriteDBErrorToLog(E_source1, E_source2, E_source3, E_source4, CurrentProcName, CurrentStoredProcName: string);
var
  tmpString: string;
begin
 WriteLn(logFile, '-------------------------------------------------------------');
 WriteLn(logFile, FormatDateTime('yyyy.mm.dd', Today()) + ' ' + FormatDateTime('hh:mm:ss', Time()));
 WriteLn(logFile, #13#10);
 WriteLn(logFile, 'Ошибка при выполнении - ' + CurrentProcName);
 tmpString:= E_source1 + #13#10 + E_source2 + #13#10 + E_source3 + #13#10 + E_source4;
 WriteLn(logFile, 'Error: ' + tmpString);
 WriteLn(logFile, '-------------------------------------------------------------');
end;

procedure WriteDataToLog(E_source1, CurrentProcName, CurrentUnitName: string);
var
  tmpString: string;
begin
 WriteLn(logFile, '-------------------------------------------------------------');
 WriteLn(logFile, FormatDateTime('yyyy.mm.dd', Today()) + '  ' + FormatDateTime('hh:mm:ss', Time()));
 WriteLn(logFile, #13#10);
 WriteLn(logFile, 'Сообщение сгенерировано в - ' + CurrentUnitName + '\' + CurrentProcName);
 tmpString:= E_source1;
 WriteLn(logFile, 'Msg: ' + tmpString);
 WriteLn(logFile, '-------------------------------------------------------------');
end;


function RefreshDocumentHierarchical(InputTreeView: TTreeView; inputDocHierarchicalType: TDocumentViewType): boolean;
var
 tmpString: AnsiString;
 TopNode: TTreeNode;
 CurNodeChild: TTreeNode;
 i: integer;
 CurJobCode: TIdJob;
begin
try
 InputTreeView.Items.Clear;

 case inputDocHierarchicalType of
  dhtInput: GetDocumentHierarchical_Input(TargetDocumentType);
  dhtTotal: GetDocumentHierarchical_Total(TargetDocumentType);
 end;

 with dmDB.QCommon do
 begin
  if not Eof then
  begin
   First;
   tmpString:= FieldByName(queryFieldName_ShortName).AsString;    //--- Для отработки
   TopNode:= InputTreeView.Items.AddObject(nil, FieldByName(queryFieldName_ShortName).AsString, nil);
//   InputTreeView.Select(TopNode);

   if not Eof then Next();

   while not Eof do
   begin
     CurJobCode:= FieldByName(queryFieldName_JobCode).Value;
     CurNodeChild:= InputTreeView.Items.AddChildObject(TopNode, FieldByName(queryFieldName_ShortName).AsString,
                                                 Pointer(FieldByName(queryFieldName_JobCode).AsInteger));
     CurNodeChild.ImageIndex:= 0;
     CurNodeChild.SelectedIndex:= 0;
     while (CurJobCode = FieldByName(queryFieldName_JobCode).Value) and (not Eof) do
      Next();
   end;
  end;
 end;

// TopNode:= InputTreeView.Items.GetFirstNode();
 InputTreeView.FullExpand;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', 'RefreshOrdersTreeView', '');
end;
end;

procedure ShowOrderItems_ObjectManufacturing_ForTreeView(InputTreeView: TTreeView);
var
 CurNode: TTreeNode;
 CurNodeChild: TTreeNode;
 i: integer;
begin
try
 InputTreeView.Items.Clear;

// if InputTreeView.Name = 'tvManufacturingItem' then GetOrderItems_ObjectManufacturing(CurrentOrder.IdDocument);

 with dmDB.QDocumentItem_Manufacturing do
 begin
  if not Eof then
  begin
   InputTreeView.Items.AddObject(nil, MyFormatString('Обозначение', 24, txFormatCenter) + '|' +
                                                MyFormatString('Полное наименование', 44, txFormatCenter) + '|' +
                                                MyFormatString('Единица измерения', 34, txFormatCenter) + '|' +
                                                MyFormatString('Описание', 54, txFormatCenter), nil);
   while not Eof do
   begin
    CurNode:= InputTreeView.Items.AddObject(nil, MyFormatString(FieldByName(queryFieldName_ShortNameObjectManufacture).AsString, 24, txFormatCenter) + '|' +
                                                 MyFormatString(FieldByName(queryFieldName_FullNameObjectManufacture).AsString, 44, txFormatCenter) + '|' +
                                                 MyFormatString(FieldByName(queryFieldName_MeasurmentUnitNameObjectManufacture).AsString, 34, txFormatCenter) + '|'
                                          , Pointer(FieldByName('DocumentId' {queryFieldName_DocumentId}).AsInteger));
     //----------- Child делается пустой и только для того, чтобы "плюсик" был для последующего раскрытия --------------------------------------
     CurNodeChild:= InputTreeView.Items.AddChildObject(CurNode, '', nil);
     CurNodeChild.ImageIndex:= 0;
     CurNodeChild.SelectedIndex:= 0;
     Next();
   end;
  end;
 end;

 InputTreeView.FullCollapse;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', 'RefreshOrdersTreeView', '');
end;
end;

procedure ShowOrderItems_ObjectManufacturing_ForDBGrid(InpuTIdDocument: TIdDocument);
var
 i: integer;
begin
try

 GetOrderItems_ObjectManufacturing_ForTreeView(InpuTIdDocument);

except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', 'RefreshOrdersTreeView', '');
end;
end;


function RefreshTreeViewUserJobRole(InputTreeView: TTreeView): boolean;
var
 TopNode: TTreeNode;
 CurNodeChild: TTreeNode;
 i: integer;
 CurGroupId: integer;
begin
try
 InputTreeView.Items.Clear;
 GetUserList();

  TopNode:= InputTreeView.Items.AddObject(nil, 'Рабочие Роли, учавствующие в Этапах Процессов', nil);
  InputTreeView.Select(TopNode);

  with dmDB.adsUserList do
  begin
   while not Eof do
   begin
    CurGroupId:= FieldByName(queryFieldName_JobRoleId).AsInteger;
    CurNodeChild:= InputTreeView.Items.AddChildObject(TopNode, 'Роль: ' + FieldByName(queryFieldName_JobRoleName).AsString,
                                                 Pointer(FieldByName(queryFieldName_JobRoleId).AsInteger));
    InputTreeView.Items.AddChildObject(CurNodeChild, 'login: ' + FieldByName(queryFieldName_UserLogin).AsString + ' ( ' +
                                                                 FieldByName(queryFieldName_UserFullName).AsString + ')',
                                                         Pointer(FieldByName(queryFieldName_UserId).AsInteger));
    CurNodeChild.ImageIndex:= 0;
    CurNodeChild.SelectedIndex:= 0;
    Next();

    while (CurGroupId = FieldByName(queryFieldName_JobRoleId).AsInteger) and (not Eof) do
    begin
     InputTreeView.Items.AddChildObject(CurNodeChild, 'login: ' + FieldByName(queryFieldName_UserLogin).AsString + ' (' +
                                                                  FieldByName(queryFieldName_UserFullName).AsString + ')',
                                                          Pointer(FieldByName(queryFieldName_UserId).AsInteger));
     CurNodeChild.ImageIndex:= 0;
     CurNodeChild.SelectedIndex:= 0;
     Next();
    end;
   end;
// TopNode:= InputTreeView.Items.GetFirstNode();
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', 'RefreshOrdersTreeView', '');
 MessageBox('У Вас нет прав администратора', ErrorMessage);
end;
end;


procedure ShowDataForSelectedNode;
var
   tmpString: AnsiString;
begin
 try
  if CurrentHierarchicalView = hvInput then
   GetDocument_Input_byJob(CurrentHierarchicalJobStatus, byCreationDate, TargetDocumentType);
  if CurrentHierarchicalView = hvTotal then
   GetDocument_Total_byJob(CurrentHierarchicalJobStatus, byCreationDate, TargetDocumentType);
 except
 if E <> nil then
 begin
  tmpString:= e.Message + #13#10 + e.ClassName();
  WriteLn(logFile, 'ShowDataForSelectedNode(...)' + 'Error: '+ tmpString);
 end;
 end;
end;

procedure ShowDocumentItem_Document(inputDocumentId: integer);
begin
  case CurrentDocument.DocumentType of
   dtMTR:
    begin
     GetDocumentItem_MTR(inputDocumentId);
//     formMain.dbgrDocumentItem.Refresh;
    end;
   dtManufacturing:
    begin
     if formMain.pcontDocumentItem.ActivePage = formMain.pcontDocumentItem.Pages[1] then
     begin
      GetOrderItems_ObjectManufacturing(inputDocumentId);
      ShowOrderItems_ObjectManufacturing_ForTreeView(formMain.tvManufacturingItem);
     end;
     if formMain.pcontDocumentItem.ActivePage = formMain.pcontDocumentItem.Pages[2] then
     begin
//      GetOrderItems_ObjectManufacturing_ForTreeView(inpuTIdDocument);
      ShowOrderItems_ObjectManufacturing_ForDBGrid(inputDocumentId);
     end;


    end;
   dtRepairing:
    begin
    end;
   dtAll:
    begin
    end;
  end;
end;

procedure SetInterfaceAfterDocumentTypeChange;
begin
  case TargetDocumentType of
   dtMTR:
    begin
     formMain.pcontDocumentItem.Pages[0].TabVisible:= true;
     formMain.pcontDocumentItem.Pages[1].TabVisible:= false;
     formMain.pcontDocumentItem.Pages[2].TabVisible:= false;
     formMain.pcontDocumentItem.Pages[3].TabVisible:= false;
     formMain.pcontDocumentItem.Pages[4].TabVisible:= false;
    end;
   dtManufacturing:
    begin
     formMain.pcontDocumentItem.Pages[0].TabVisible:= false;
     formMain.pcontDocumentItem.Pages[1].TabVisible:= true;
     formMain.pcontDocumentItem.Pages[2].TabVisible:= true;
     formMain.pcontDocumentItem.Pages[3].TabVisible:= false;
     formMain.pcontDocumentItem.Pages[4].TabVisible:= false;
    end;
   dtRepairing:
    begin
     formMain.pcontDocumentItem.Pages[0].TabVisible:= false;
     formMain.pcontDocumentItem.Pages[1].TabVisible:= false;
     formMain.pcontDocumentItem.Pages[2].TabVisible:= false;
     formMain.pcontDocumentItem.Pages[3].TabVisible:= true;
     formMain.pcontDocumentItem.Pages[4].TabVisible:= true;
    end;
  end;
end;

procedure SetInterfaceAfterCommonInfoChange(Sender: TObject);
begin
with formMain do
begin
 case (Sender as TPageControl).ActivePageIndex of
 0:
  begin
   tsheetTreeList.TabVisible:= true;
   tsheetStoreMTR.TabVisible:= false;
  end;
 1:
  begin
   tsheetTreeList.TabVisible:= false;
   tsheetStoreMTR.TabVisible:= true;
  end;
 2:
  begin
   tsheetTreeList.TabVisible:= false;
   tsheetStoreMTR.TabVisible:= false;
  end;
 end;
end;
  SetInterfaceAfterDocumentTypeChange;
end;

{
procedure ShowProcessItem_Document(InputCheckListBox: TCheckListBox; inputDocumentId: TIdDocument);
var
 tmpString: AnsiString;
 i, iCurrentProcessItem: integer;
begin
try
 if inputDocumentId < 1 then exit;

 GetJobNameProcessItem(inputDocumentId);

 InputCheckListBox.Clear;


 with dmDB do
 begin
  for i:= 0 to QCommon.RecordCount do //--- GetRoutePointForOrder(CurrentUser.GetLoginName, CurrentOrder.IdDocument) do
  ProcessItemCheckData[i]:= FuturePoint;
  i:= 0;
  iCurrentProcessItem:= i;
  QCommon.First;
  while not QCommon.Eof do
  begin
   InputCheckListBox.Items.Add(QCommon.FieldByName(queryFieldName_ShortName).AsString + ' (' +
                                QCommon.FieldByName(queryFieldName_JobRoleName).AsString + ')' );
   if QCommon.FieldByName(queryFieldName_ProcessItemLevel).AsInteger <= CurrentDocument.CurrentProcessItem then
    if QCommon.FieldByName(queryFieldName_ProcessItemLevel).AsInteger < CurrentDocument.CurrentProcessItem then
    begin
     ProcessItemCheckData[i]:= PassedPoint;
     InputCheckListBox.Checked[i]:= true;
    end
    else
    begin
     ProcessItemCheckData[i]:= CurrentPoint;
     iCurrentProcessItem:= i;
    end;
   i:= i + 1;
   QCommon.Next();
  end;
 QCommon.Close;
 end;
 if iCurrentProcessItem = (i-1) then
 begin
  ProcessItemCheckData[iCurrentProcessItem]:= PassedPoint;
  InputCheckListBox.Checked[iCurrentProcessItem]:= true;
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', 'ShowProcessItem_Document', '');
end;
end;
}

procedure ShowProcessItem_Document(InputCheckListBox: TCheckListBox; inputDocumentId: TIdDocument);
var
 tmpString: AnsiString;
 i, iCurrentProcessItem, iTargetProcessItem: integer;
begin
try
 if inputDocumentId < 1 then exit;

 GetJobNameProcessItem(inputDocumentId);

 if CurrentDocument.CurrentProcessItem <> -1 then
   iTargetProcessItem:= CurrentDocumentItem.CurrentProcessItem
 else iTargetProcessItem:= CurrentDocument.CurrentProcessItem;
 InputCheckListBox.Clear;


 with dmDB do
 begin
  for i:= 0 to QCommon.RecordCount do ProcessItemCheckData[i]:= FuturePoint;
  i:= 0;
  iCurrentProcessItem:= i;
  QCommon.First;
  while not QCommon.Eof do
  begin
   InputCheckListBox.Items.Add(QCommon.FieldByName(queryFieldName_ShortName).AsString + ' (' +
                                QCommon.FieldByName(queryFieldName_JobRoleName).AsString + ')' );
   if QCommon.FieldByName(queryFieldName_ProcessItemLevel).AsInteger <= iTargetProcessItem then
    if QCommon.FieldByName(queryFieldName_ProcessItemLevel).AsInteger < iTargetProcessItem then
    begin
     ProcessItemCheckData[i]:= PassedPoint;
     InputCheckListBox.Checked[i]:= true;
    end
    else
    begin
     ProcessItemCheckData[i]:= CurrentPoint;
     iCurrentProcessItem:= i;
    end;
   i:= i + 1;
   QCommon.Next();
  end;
 QCommon.Close;
 end;
 if iCurrentProcessItem = (i-1) then
 begin
  ProcessItemCheckData[iCurrentProcessItem]:= PassedPoint;
  InputCheckListBox.Checked[iCurrentProcessItem]:= true;
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', 'ShowProcessItem_Document', '');
end;
end;

procedure ShowProcessItem_DocumentItem(InputCheckListBox: TCheckListBox; inputDocumentItemId: TIdDocument);
var
 tmpString: AnsiString;
 i, iCurrentProcessItem, iTargetProcessItem: integer;
begin
try
 if inputDocumentItemId < 1 then exit;

 GetJobNameProcessItem_DocumentItem(inputDocumentItemId);

 InputCheckListBox.Clear;

 with dmDB do
 begin
  for i:= 0 to QCommon.RecordCount do ProcessItemCheckData[i]:= FuturePoint;
  i:= 0;
  iCurrentProcessItem:= i;
  QCommon.First;
  while not QCommon.Eof do
  begin
   InputCheckListBox.Items.Add(QCommon.FieldByName(queryFieldName_ShortName).AsString + ' (' +
                                QCommon.FieldByName(queryFieldName_JobRoleName).AsString + ')' );
   if QCommon.FieldByName(queryFieldName_StateCurrent).Value <> Null then
    begin
     case QCommon.FieldByName(queryFieldName_StateCurrent).Value of
      ord(jrNone):
       begin
        {Ничего не делаем}
       end;
      ord(jrAgree):
       begin
        ProcessItemCheckData[i]:= PassedPoint;
        InputCheckListBox.Checked[i]:= true;
       end;
      ord(jrDeny):
       begin
        ProcessItemCheckData[i]:= CanceledPoint;
       end;
      ord(jrAlter): {Ничего не делаем}
     end;
    end;
   i:= i + 1;
   QCommon.Next();
  end;
 QCommon.Close;
 end;
 if iCurrentProcessItem = (i-1) then
 begin
  ProcessItemCheckData[iCurrentProcessItem]:= PassedPoint;
  InputCheckListBox.Checked[iCurrentProcessItem]:= true;
 end;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', 'ShowProcessItem_DocumentItem', '');
end;
end;


procedure ShowTemplateProcessList(InputDBGrid: TDBGrid); //; var InputQuery: TADOQuery); //; inputShowActiveRoutes: integer = 0 {0 = Все, не 0 = тольео активные});
var
 bShowDeletedRoutes: boolean;
 i: integer;
begin
try
  GetTemplateProcessList();
  case ShowProcessFilter of
   ossActiveAndDeleted: bShowDeletedRoutes:= true;
   ossActiveOnly: bShowDeletedRoutes:= false;
   else bShowDeletedRoutes:= false;
  end;
//  ExecuteRoutesListQuery(bShowDeletedRoutes);
//--- Не работает так, не надо так делать!!!!!!!!!
// InputQuery.Open;
// InputDBGrid.DataSource.DataSet:= InputQuery.DataSource.DataSet;
 InputDBGrid.Refresh;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', 'ShowRoutesList', '');
end;
end;

procedure ShowProgramRoleList(InputDBGrid: TDBGrid; var InputQuery: TADOQuery);
var
 i: integer;
begin
try
 InputQuery:= ExecuteProgramRoleListQuery();
//--- Не работает так, не надо так делать!!!!!!!!!
// InputQuery.Open;
// InputDBGrid.DataSource.DataSet:= InputQuery.DataSource.DataSet;
 InputDBGrid.Refresh;
except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', 'ShowProgramsRolesList', '');
end;
end;

function ShowCommentForSelectedDocument(var InputTreeView: TTreeView; inputDocumentId: TIdDocumentItem): boolean;
var
 TopNode: TTreeNode;
 CurNodeChild: TTreeNode;
 i: integer;
 CurCycleOfApprovments: integer;
begin
result:= false;
try
 InputTreeView.Items.Clear;
 GetCommentForDocument(inputDocumentId);
 InputTreeView.Items.Clear;

 if dmDB.QCommon.RecordCount < 1 then exit;

 result:= true;
 with dmDB do
 begin
  if QCommon.FieldByName(queryFieldName_DocumentCycleOfApprovment).AsInteger < 0 then exit;

  TopNode:= InputTreeView.Items.AddObject(nil, 'Циклы согласования', nil);
  InputTreeView.Select(TopNode);

  while not QCommon.Eof do
  begin
   CurCycleOfApprovments:= QCommon.FieldByName(queryFieldName_DocumentCycleOfApprovment).AsInteger;
   CurNodeChild:= InputTreeView.Items.AddChildObject(TopNode, ('Цикл согласования - ' + IntToStr(CurCycleOfApprovments)),
                                                Pointer(CurCycleOfApprovments));
   InputTreeView.Items.AddChildObject(CurNodeChild,  QCommon.FieldByName(queryFieldName_JobRoleName).AsString +
                                                     ': [' +
                                                     QCommon.FieldByName(queryFieldName_JobResultName).AsString + ']   ' +
                                                     QCommon.FieldByName(queryFieldNameForCommentText).AsString, nil);
   CurNodeChild.ImageIndex:= 0;
   CurNodeChild.SelectedIndex:= 0;
   QCommon.Next();

   while (CurCycleOfApprovments = QCommon.FieldByName(queryFieldName_DocumentCycleOfApprovment).AsInteger) and (not QCommon.Eof) do
   begin
    InputTreeView.Items.AddChildObject(CurNodeChild, QCommon.FieldByName(queryFieldName_JobRoleName).AsString +
                                                                     ':    ' +QCommon.FieldByName('CommentsText').AsString, nil);
    CurNodeChild.ImageIndex:= 0;
    CurNodeChild.SelectedIndex:= 0;
    QCommon.Next();
   end;
  end;
 end;

except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', 'RefreshOrdersTreeView', '');
 MessageBox('У Вас нет прав администратора', ErrorMessage);
end;
end;


function ShowCommentForSelectedDocumentItem(var InputTreeView: TTreeView; inputDocumentItemId: TIdDocumentItem): boolean;
var
 TopNode: TTreeNode;
 CurNodeChild: TTreeNode;
 i: integer;
 CurCycleOfApprovments: integer;
begin
result:= false;
try
 InputTreeView.Items.Clear;
 GetCommentForDocumentItem(inputDocumentItemId);
 InputTreeView.Items.Clear;

 if dmDB.QCommon.RecordCount < 1 then exit;

 result:= true;
 with dmDB do
 begin
  if QCommon.FieldByName(queryFieldName_DocumentCycleOfApprovment).AsInteger < 0 then exit;

  TopNode:= InputTreeView.Items.AddObject(nil, 'Циклы согласования', nil);
  InputTreeView.Select(TopNode);

  while not QCommon.Eof do
  begin
   CurCycleOfApprovments:= QCommon.FieldByName(queryFieldName_DocumentCycleOfApprovment).AsInteger;
   CurNodeChild:= InputTreeView.Items.AddChildObject(TopNode, ('Цикл согласования - ' + IntToStr(CurCycleOfApprovments)),
                                                Pointer(CurCycleOfApprovments));
   InputTreeView.Items.AddChildObject(CurNodeChild,  QCommon.FieldByName(queryFieldName_JobRoleName).AsString +
                                                     ': [' +
                                                     QCommon.FieldByName(queryFieldName_JobResultName).AsString + ']   ' +
                                                     QCommon.FieldByName(queryFieldNameForCommentText).AsString, nil);
   CurNodeChild.ImageIndex:= 0;
   CurNodeChild.SelectedIndex:= 0;
   QCommon.Next();

   while (CurCycleOfApprovments = QCommon.FieldByName(queryFieldName_DocumentCycleOfApprovment).AsInteger) and (not QCommon.Eof) do
   begin
    InputTreeView.Items.AddChildObject(CurNodeChild, QCommon.FieldByName(queryFieldName_JobRoleName).AsString +
                                                                     ':    ' +QCommon.FieldByName('CommentsText').AsString, nil);
    CurNodeChild.ImageIndex:= 0;
    CurNodeChild.SelectedIndex:= 0;
    QCommon.Next();
   end;
  end;
 end;

except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', 'RefreshOrdersTreeView', '');
 MessageBox('У Вас нет прав администратора', ErrorMessage);
end;
end;

procedure ShowObjectItemsTree_Manufacture(var InputTreeView: TTreeView; inpuTIdDocument: TIdDocument; inpuTIdDocumentsItems: TIdDocumentItem);
var
 TopNode: TTreeNode;
 CurNode: TTreeNode;
 CurNodeChild: TTreeNode;
 i, CurrentTreeItemIndex: integer;
 CurParentId: TIdDocumentItem;
 IdDocumentItem: TIdDocumentItem;
begin
try

 GetObjectItems_Manufacturing(CurrentUser.GetLoginName, inpuTIdDocumentsItems);

// InputTreeView.Items.Clear;
 with dmDB.QDocumentItem do
 begin
  TopNode:= InputTreeView.Selected;
  TopNode.DeleteChildren;
  IdDocumentItem:= ConvertPointerToIdObjectItem(TopNode.Data); //--- Переменная для ускорения
  CurNode:= TopNode;

  InputTreeView.Select(CurNode);

  i:= 0; //--- "Перебиратель" номеров CurrentTreeItems[]
  while not Eof do
  begin
   i:= i + 1;
   CurrentTreeItems[i].IdTopNode:= IdDocumentItem;
   CurrentTreeItems[i].IdObjectItem:= FieldByName('Id').AsInteger;
   CurNodeChild:= InputTreeView.Items.AddChildObject(CurNode, FieldByName(queryFieldName_ShortNameObjectManufacture).Value,
                                                Pointer(CurrentTreeItems[i].IdObjectItem));
   CurrentTreeItems[i].IdParent:= FieldByName(queryFieldName_ParentIdObjectManufacture).AsInteger;
   CurParentId:= CurrentTreeItems[i].IdParent;
   CurrentTreeItems[i].TreeItemIndex:= CurNodeChild.AbsoluteIndex;

   CurNodeChild.ImageIndex:= 0;
   CurNodeChild.SelectedIndex:= 0;
   Next();

   while (CurParentId = FieldByName(queryFieldName_ParentIdObjectManufacture).AsInteger) and (not Eof) do
   begin
    i:= i + 1;
    CurrentTreeItems[i].IdTopNode:= IdDocumentItem;
    CurrentTreeItems[i].IdObjectItem:= FieldByName('Id').AsInteger;
    CurNodeChild:= InputTreeView.Items.AddChildObject(CurNode, FieldByName(queryFieldName_ShortNameObjectManufacture).Value,
                                                Pointer(CurrentTreeItems[i].IdObjectItem));
    CurrentTreeItems[i].IdParent:= FieldByName(queryFieldName_ParentIdObjectManufacture).AsInteger;
    CurParentId:= CurrentTreeItems[i].IdParent;
    CurrentTreeItems[i].TreeItemIndex:= CurNodeChild.AbsoluteIndex;

    CurNodeChild.ImageIndex:= 0;
    CurNodeChild.SelectedIndex:= 0;
    Next();
   end;

   CurParentId:= FieldByName(queryFieldName_ParentIdObjectManufacture).AsInteger;
   CurrentTreeItemIndex:= GetParentTreeNodeIndex(CurrentTreeItems, CurParentId, i);
   if CurrentTreeItemIndex = -1 then
   begin
   //---------- Здесь потом прописать код для фиксации ошибки отображения DCE - это очень серьёзная ошибка!!!
    exit;
   end;
   CurNode:= InputTreeView.Items.Item[CurrentTreeItemIndex];

  end;
 end;

except
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', 'RefreshOrdersTreeView', '');
 MessageBox('У Вас нет прав администратора', ErrorMessage);
end;
end;

procedure ShowJobDocument_MTR(var InputPanel: TPanel);
var
  i: integer;
  iPnlHeigth: integer;
begin
 GetJobProcessItem_MTR(CurrentDocument.IdDocument);
 with dmDB.QJob do
 begin
  iPnlHeigth:= formJob.pnlJob.Height;
  if RecordCount > 0 then formJob.gbJob1.Caption:= FieldByName(queryFieldName_SpravFullName).AsString;
  while not eof do
  begin
   case FieldByName(queryFieldName_JobType).Value of
    Ord(jtJob):
     begin
      formJob.Caption:= FieldByName(queryFieldName_SpravFullName).AsString;
      formJob.tsheetJob1.Caption:= FieldByName(queryFieldName_SpravShortName).AsString;
      formJob.Height:= formJob.Height + iPnlHeigth;
     end;
    Ord(jtJobItem):
     begin
       for i:= RecNo to RecordCount do
       begin
        formJob.Height:= formJob.Height + iPnlHeigth;
        formJob.gbJob1.Caption:= FieldByName(queryFieldName_SpravFullName).AsString;
       end;
     end;
    end; {case}
   Next;
  end; {while}
 end;
end;

procedure ShowProcessItemJob_Document_MTR(var InputPanel: TPanel);       //????????????????????????????????????????????????????
var
  i: integer;
  iJobItemNum: integer;
  iPnlHeigth, iPnlHeigth_Space: integer;
begin
 GetJobProcessItem_MTR(CurrentDocument.IdSelectedItem);
 with dmDB.QJob do
 begin
//  iPnlHeigth:= formJob.pnlJob.Height;
  iPnlHeigth:= formJob.gbJob1.Height;
  iPnlHeigth_Space:= 6;
  iJobItemNum:= 0;
  while not eof do
  begin
   case FieldByName(queryFieldName_JobStatus).Value of
    Ord(jtJob):
     begin
      formJob.Caption:= FieldByName(queryFieldName_ShortName).AsString;
      formJob.tsheetJob1.Caption:= FieldByName(queryFieldName_FullName).AsString;
      formJob.Height:= formJob.Height - iPnlHeigth;
      iJobItemNum:= 0;
     end;
    end; {case}
   Next;
  end; {while}
 end;
end;


procedure ShowProcessItemJob_DocumentItem_MTR(var InputPanel: TPanel);
var
  i: integer;
  iJobItemNum: integer;
  iPnlHeigth, iPnlHeigth_Space: integer;
begin
 GetJobProcessItem_MTR(CurrentDocument.IdSelectedItem);
 with dmDB.QJob do
 begin
//  iPnlHeigth:= formJob.pnlJob.Height;
  iPnlHeigth:= formJob.gbJob1.Height;
  iPnlHeigth_Space:= 6;
  iJobItemNum:= 0;
  while not eof do
  begin
   case FieldByName(queryFieldName_JobStatus).Value of

    Ord(jtJob):
     begin
      if VarIsNull(FieldByName(queryFieldName_JobIsActive).Value) and VarIsNull(FieldByName(queryFieldName_JobIsEDD).Value)
         and VarIsNull(FieldByName(queryFieldName_JobIsEntireDocument).Value) then
      begin
       formJob.tsheetJob1.Caption:= FieldByName(queryFieldName_ShortName).AsString;
       formJob.stJobNotes.Caption:= FieldByName(queryFieldName_JobNotesItem).AsString + #13#10;
       formJob.stJobNotes.Caption:= formJob.stJobNotes.Caption + FieldByName(queryFieldName_JobNotes).AsString;
      end
      else
      begin
       iJobItemNum:= iJobItemNum + 1;
      end;
     end;


    Ord(jtJobItem):
     begin
       iJobItemNum:= iJobItemNum + 1;
     end;
    end; {case}

   if not VarIsNull(FieldByName(queryFieldName_JobIsActive).Value) then
    if FieldByName(queryFieldName_JobIsActive).AsBoolean then
    begin
    if not VarIsNull(FieldByName(queryFieldName_JobIsEDD).Value) then
     if FieldByName(queryFieldName_JobIsEDD).AsBoolean then
     begin
      formJob.gbEDD.Visible:= true;
//      break; {while ... of}
     end;

     case iJobItemNum of
      1:
      begin
       formJob.Height:= formJob.Height + iPnlHeigth + iPnlHeigth_Space;
       formJob.gbJob1.Caption:= FieldByName(queryFieldName_JobNotesItem).AsString;
      end;
      2:
      begin
//       formJob.Height:= formJob.Height + iPnlHeigth + iPnlHeigth_Space;
//       formJob.gbJob2.Caption:= FieldByName(queryFieldName_JobNotesItem).AsString;
      end;
      3:
       begin
//        formJob.Height:= formJob.Height + iPnlHeigth + iPnlHeigth_Space;
//        formJob.gbJob3.Caption:= FieldByName(queryFieldName_JobNotesItem).AsString;
       end;
      4:
       begin
//        formJob.Height:= formJob.Height + iPnlHeigth + iPnlHeigth_Space;
//        formJob.gbJob4.Caption:= FieldByName(queryFieldName_JobNotesItem).AsString;
       end;
      end; {case}

      if not GetJobParameter(FieldByName(queryFieldName_JobItemId).Value) then
      begin
       MessageBox('Не возможно получить параметры работы', ErrorMessage);
      end;
     end;
   Next;
  end; {while}
 end;
end;


function GetParentTreeNodeIndex(inputTreeItems: TTreeItemArray; inputTargetIdItem: TIdDocumentItem; inputMaxArrayNumber: integer = maxObjectItemsCount_Manufacturing): integer;
var
  i: word;
begin
try
 result:= -1;
 i:= 1;
 while i <= inputMaxArrayNumber do
 begin
  if inputTreeItems[i].IdObjectItem = inputTargetIdItem then
  begin
   result:= inputTreeItems[i].TreeItemIndex;
   break;
  end;
  i:= i + 1;
 end;
except
 result:= -1;
 WriteLn(logFile, 'GetParentTreeNodeIndex(...)' + ' "Exeption" ');
end;
end;

function ConvertPointerToIdObjectItem(targetPointer: Pointer): TIdDocumentItem;
var
  p: Pointer;
  iTmp: longint;
begin
 result:= 0;
 try
   p:= targetPointer;
   asm                         //--- Китайский метод для
    push eax                   //--- i:= PointerToInt(p)
    mov eax, p
    mov iTmp, eax
    pop eax
   end;
   result:= iTmp;
 except
  result:= 0;
  WriteLn(logFile, 'ConvertPointerToIdObjectItem(...)' + ' "Exeption" ');
 end;
end;

function FindPositionInTreeBy(InputTreeView: TTreeView; findingNodeName: string; neededValue: Variant): boolean;
var
  i: integer;
  p: Pointer;
  iTmp: longint;
begin
 result:= false;
 try
  for i:= 0 to InputTreeView.Items.Count - 1 do
  begin
   p:= InputTreeView.Items[i].Data;
   asm                         //--- Китайский метод для
    push eax                   //--- i:= PointerToInt(p)
    mov eax, p
    mov iTmp, eax
    pop eax
   end;
   if  iTmp = neededValue then
   begin
    InputTreeView.Selected:= InputTreeView.Items[i];
    result:= true;
    break;
   end;
  end;
{
  for i:= 0 to InputTreeView.Items.Count - 1 do
  begin
   if InputTreeView.Items[i].Text = findingNodeName then
   begin
    InputTreeView.Selected:= InputTreeView.Items[i];
    result:= true;
    break;
   end;
  end;
}

 except
  result:= false;
  WriteLn(logFile, 'FindPositionInTreeBy(...)' + ' "Exeption" ');
 end;
end;

function FindPositionInTreeByName(InputTreeView: TTreeView; findingNodeName: string): boolean;
var
  i: integer;
begin
 result:= false;
try
  for i:= 0 to InputTreeView.Items.Count - 1 do
  begin
   if InputTreeView.Items[i].Text = findingNodeName then
   begin
    InputTreeView.Items[i].Selected:= true;
    result:= true;
    break;
   end;
  end;

except
 result:= false;
 WriteLn(logFile, 'FindPositionInTreeBy(...)' + ' "Exeption" ');
end;
end;

procedure DenyOrdersItem(inpuTIdDocument, inpuTIdDocumentsItem: integer; ResolutionText: string);
begin
 ExecuteDenyToOrdersItem(CurrentUser.GetLoginName, inpuTIdDocument, inpuTIdDocumentsItem, ResolutionText);
end;

procedure AlterOrdersItem(inpuTIdDocument, inpuTIdDocumentsItem: integer; ResolutionText: string);
begin
 ExecuteAlterToOrdersItem(CurrentUser.GetLoginName, inpuTIdDocument, inpuTIdDocumentsItem, ResolutionText);
end;


procedure FillComboBoxFromQuery(InputComboBox: TComboBox; var InputAssignedQuery: TADOQuery; InputField: string);
var
  tmpQuery: TADOQuery;
begin
  InputComboBox.Clear;
//--- Модернизация - используем выделенный Query для хранения запроса, чтобы потом отправлять в SQL Server не строковое наименование выбранного
//--- элемента, а его справочный код. Так как возникли проблемы с кодировкой - значит и в последствие может такое произойти у клиента.
//--- Если такой вариант приживётся, тогда убрать переменную tmpQuery из обращения вообще.
//  InputAssignedQuery:= tmpQuery;
//  InputAssignedQuery:= ExecuteQueryWithParam1AsString(InputSQLText, inputParam1);
  with InputAssignedQuery do
  begin
   Close();
   Open();
   while not EOF do
   begin
    InputComboBox.items.add(FieldByName(InputField).AsString);
    next;
   end;
  end;
end;

procedure FillListBoxFromQuery(InputListBox: TListBox; InputSPName: string; InputField: string; inputParam1: integer = 0);
begin
  InputListBox.Clear;
  Execute_SP(InputSPName, dmDB.QCommon, inputParam1);
  with dmDB.QCommon do
  begin
   Open();
   while not EOF do
   begin
    InputListBox.items.add(FieldByName(InputField).AsString);
    next;
   end;
  end;
end;


procedure FillMemoFromQuery(InputMemo: TMemo; InputSQLText: string; InputField: string; inputParam1: string = '');
var
  tmpQuery: TADOQuery;
begin
  InputMemo.Clear;
  tmpQuery:= ExecQueryWithParam1AsString(InputSQLText, inputParam1);
  with tmpQuery do
  begin
   Open();
   while not EOF do
   begin
    InputMemo.Lines.add(FieldByName(InputField).AsString);
    next;
   end;
  end;
end;

procedure FillEditFromQuery(InputEdit: TEdit; InputSQLText: string; InputField: string; inputParam1: string = '');
var
  tmpQuery: TADOQuery;
begin
  InputEdit.Clear;
  tmpQuery:= ExecQueryWithParam1AsString(InputSQLText, inputParam1);
  with tmpQuery do
  begin
   Open();
   InputEdit.Text:= FieldByName(InputField).AsString;
  end;
end;

procedure FillArrayFromQuery(var InputArray: TVariantArray; InputSQLText: string; InputField: string; inputParam1: string = '');
var
  tmpQuery: TADOQuery;
  i: word;
begin
  for i:= 1 to DocumentTypeCount do InputArray[i]:= '';
  tmpQuery:= ExecQueryWithParam1AsString(InputSQLText, inputParam1);
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
end;

function FindRecordInQuery(InputQuery: TADOQuery; SourceFieldName: string; InputValue: Variant): boolean;
var
  i: integer;
  tmpString: string;
begin
result:= false;
try
  with InputQuery do
  begin
   Close();
   Open();
   First;
   while not EOF do
   begin
    tmpString:= FieldByName(SourceFieldName).AsString; //--- Для отработки (временно!)
    if FieldByName(SourceFieldName).Value = InputValue then
    begin
     result:= true;
     break;
    end;
    next;
   end;
// Close(); - не закрывать!
  end;
except
  result:= false;
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', 'FindRecordInQuery', '');
end;
end;

function FindRecordInQuery_Int(InputQuery: TADOQuery; SourceFieldName, DestonyFieldName: string; InputValueInteger: integer): integer;
var
  i: integer;
begin
result:= -1;
try
  with InputQuery do
  begin
   Close();
   Open();
   First;
   while not EOF do
   begin
    if FieldByName(SourceFieldName).AsInteger = InputValueInteger then
    begin
     result:= FieldByName(DestonyFieldName).AsInteger;
     break;
    end;
    next;
   end;
// Close(); - не закрывать!
  end;
except
  result:= -1;
 if dmDB.dbConnection.Errors.Count > 0 then
  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
   WriteDBErrorToLog('', dmDB.dbConnection.Errors[i].Description, dmDB.dbConnection.Errors[i].Source, '', 'RefreshOrdersTreeView', '');
end;
end;

procedure SetMainMenuStateForActiveUser;
var
  tmpProgRoles: TProgramRoles;
begin
 if prAdmin in CurrentUser.GetProgramRoles then formMain.N101.Visible:= true else formMain.N101.Visible:= false;
 if prExecuter in CurrentUser.GetProgramRoles then formMain.N16.Visible:= true else formMain.N16.Visible:= false;
end;

procedure SetButtonStateForCurrentDocumentType;
var
  tmpProgRoles: TProgramRoles;
begin
 case TargetDocumentType of
  dtMTR:            SetButtonState_DocumentMTR;
//  dtManufacturing:  ;
//  dtRepairing:    ;
 end;
end;

procedure SetButtonState_DocumentMTR;
var
  tmpProgRoles: TProgramRoles;
  tmpInteger: integer;
begin

  with formMain do
  begin

 //------- Кнопки редактирования Документа -----------------------------------------------
   tbAddDocument.Enabled:= true; //GetEditStatus_DocumentItem(CurrentDocument.CurrentProcessItem);
   tbEditDocument.Enabled:= (GetEditStatus_Document(CurrentDocument.IdSelectedItem)) and (CurrentDocument.GetDocumentStatus = dsActive) and (dmDB.QDocument.RecordCount > 0);
   tbDeleteDocument.Enabled:= tbEditDocument.Enabled;

 //------- Кнопки редактирования Элемента Документа -----------------------------------------------
   tbAddDocumentItem.Enabled:= tbAddDocument.Enabled; //GetEditStatus_DocumentItem(CurrentDocument.CurrentProcessItem); //tbEditDocument.Enabled and (CurrentDocument.GetDocumentStatus = dsActive);
   tbEditDocumentItem.Enabled:= GetEditStatus_DocumentItem(CurrentDocumentItem.Id);
   tbDeleteDocumentItem.Enabled:= tbEditDocumentItem.Enabled;

 //------ Кнопка Действия для Документа------------------------------------------------------
   formMain.sbJobDocument_MTR.Enabled:= (GetJobExistsStatus_Document(CurrentDocument.IdDocument) = jesJobExists);

 //------ Кнопка Действия для Элемента Документа------------------------------------------------------
   formMain.sbJobDocumentItem_MTR.Enabled:= (GetCanChangeState_DocumentItem(CurrentDocumentItem.Id) = ccsCan);// (GetJobExistsStatus_DocumentItem(CurrentDocumentItem.Id) = jesJobExists);

  end;
end;



function GetUserFullName(inputUserShortName: string): string;
var
  tmpQuery: TADOQuery;
begin
 tmpQuery:= ExecuteUserInfoQuery(inputUserShortName);
 Result:= tmpQuery.FieldByName('FullName').AsString;
end;


function GetAttachmentForDocumentItem(inputDocumentItemId: TIdDocumentItem; var outputAttachments: TAttachment): word;
var
  i: integer;
begin
 Result:= 0;
 try
  Execute_SP('sp_GetAttachmentFilesNameForDocumentItem', dmDB.QCommon, inputDocumentItemId);

  for i:= 1 to dmDB.QCommon.RecordCount do
  begin
   outputAttachments.SetAttachmentName(i, dmDB.QCommon.FieldByName(queryFieldName_AttachmentName).AsString);
   outputAttachments.SetAttachmentId(i, dmDB.QCommon.FieldByName(queryFieldName_AttachmentId).Value);
   outputAttachments.SetAttachmentState(i, asIs);
   dmDB.QCommon.Next;
   Result:= Result + 1;
  end;

 except
  Result:= 0;
 end;
end;


function IsTemplateProcessInvolvedInDocument(inputProcessId: TIdProcess): boolean;
begin
 Result:= GetTemplateProcessInvolvedStatus(inputProcessId);
end;


function PrepareReport_MTR_ForBuying(): boolean;
begin
 result:= false;
 try
  dmDB.QReport1.AfterScroll:= nil;
  GetDataReport_MTR_ForBuying();
  Result:= true;
 except
  result:= false;
 end;
end;

function OpenAttachment(inputAttachmentNumber: integer; inputAttachment: TAttachment): boolean;
var
  vBLOBData: TADOBlobStream;
  tmpStr: string;
begin
if not GetAttachment(CurrentDocumentItem.Id, CurrentDocumentItem.Attachments.GetAttachmentName(inputAttachmentNumber),
                 CurrentDocumentItem.Attachments.GetAttachmentId(inputAttachmentNumber)) then exit;
try
 vBLOBData:= TADOBlobStream.Create(dmDB.QCommon.FieldByName(queryFieldName_AttachmentData) as TBlobField, bmRead);
 tmpStr:= GetEnvironmentVariable('TEMP') + '\';

 tmpStr:= tmpStr + ExtractFileName(dmDB.QCommon.FieldByName(queryFieldName_AttachmentName).AsString) + ExtractFileExt(dmDB.QCommon.FieldByName(queryFieldName_AttachmentUNCFileName).AsString);
 vBLOBData.SaveToFile(tmpStr);
 ShellExecute(Application.Handle,
  'open', PChar(tmpStr), nil, nil, SW_SHOWNORMAL);
 result:= true;
 vBLOBData.Free;
except
 vBLOBData.Free;
 result:= false;
end;
end;

function GetProgramRolesForCurrent(TargetUserLoginName: string; TargeTIdDocument: TIdDocument): TProgramRoles;
var
  tmpQuery: TADOQuery;
  i: integer;
  tmpProgramRoles: TProgramRoles;
begin
try
  tmpProgramRoles:= [];
  result:= tmpProgramRoles;
  tmpQuery:= ExecuteProgramRoleQuery(TargetUserLoginName, TargeTIdDocument);
  i:= dmDB.QCommon.RecordCount;
  dmDB.QCommon.First;
  while not dmDB.QCommon.Eof do
  begin
   i:= dmDB.QCommon.FieldByName(queryFieldNameForCodeProgramRole).Value;
   case i of
    1: tmpProgramRoles:= tmpProgramRoles + [prInitiate];
    2: tmpProgramRoles:= tmpProgramRoles + [prAgreements];
    3: tmpProgramRoles:= tmpProgramRoles + [prApproves];
    4: tmpProgramRoles:= tmpProgramRoles + [prExecuter];
    99: tmpProgramRoles:= tmpProgramRoles + [prAdmin];
   end;
   dmDB.QCommon.Next;
  end;
finally
 result:= tmpProgramRoles;
end;
end;


//################# Replicate ###########################
function Replicate(Substr: String; Count: Word): String;
var
   i: Word;
begin // Replicate
Result:='';
for i:=1 to Count do
  Result:=Result+Substr;
end; // Replicate

//############## ExecuteAsCenterString ###################
function MyFormatString(MyOperand: String; MyLenString: word;
                                   MytxFormatText: TFormatText): String;
begin // ExecuteAsCenterString
//----------- Если длина текста больше, чем область куда его хотят всунуть
//----------- придется отрезать лишнее...
if length(MyOperand) > MyLenString then
 MyOperand:= GetSubStr(MyOperand, 1, MyLenString);
case MytxFormatText of
     txFormatLeft:
// Для левого выравнивания текста
       begin
        Result:=MyOperand+ Replicate(Space,
                           MyLenString-length(MyOperand));
       end;
     txFormatCenter:
// Для центрирования текста
       begin
        Result:=Replicate(Space,Trunc((MyLenString-length(MyOperand))/2))+
                               MyOperand;
        Result:= Result+ Replicate(Space, MyLenString-length(Result));
       end;
     txFormatRight:
// Для правого выравнивания текста
       begin
        Result:= Replicate(Space,
                          MyLenString-length(MyOperand))+
                          MyOperand;
       end;
end; {case}
end; //ExecuteAsCenterString

//------------------------------------------------------------------------------

procedure ShowInfoOnStatusBar(TargetPanelNum: byte; inputText: string);
begin
  formMain.StatusBar1.Panels[TargetPanelNum].Text:= inputText;
end;

end.
