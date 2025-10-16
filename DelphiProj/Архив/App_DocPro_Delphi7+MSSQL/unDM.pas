unit unDM;

interface

uses
  SysUtils, Classes, DB, ADODB, dialogs, Forms,
  Variants,
  unVariable, frxClass, frxDBSet;

type
  TdmDB = class(TDataModule)
    dbConnection: TADOConnection;
    QCommon: TADOQuery;
    QDocument: TADOQuery;
    QDocumentItem: TADOQuery;
    dsDocument: TDataSource;
    QEditOrder: TADOQuery;
    dsObjectsTree: TDataSource;
    spAddDiagnosis: TADOStoredProc;
    QErrorLog: TADOQuery;
    dsErrorLog: TDataSource;
    QEventLog: TADOQuery;
    dsEventLog: TDataSource;
    dsDocumentItem: TDataSource;
    QComboBox1: TADOQuery;
    dsComboBox1: TDataSource;
    QProcessList: TADOQuery;
    dsProcessList: TDataSource;
    QComboBox2: TADOQuery;
    dsComboBox2: TDataSource;
    QReport1: TADOQuery;
    dsUserList: TDataSource;
    QProgramRoleList: TADOQuery;
    dsProgramRoleList: TDataSource;
    dsProcessItem: TDataSource;
    QProcessItem: TADOQuery;
    QObjectsTree: TADOQuery;
    QStoreObjectList: TADOQuery;
    dsStoreObjectList: TDataSource;
    QSPText: TADOQuery;
    dsCommon: TDataSource;
    dbConnectionAsSA: TADOConnection;
    dbCommandAsSA: TADOCommand;
    QDocumentItem_Manufacturing: TADOQuery;
    dsDocumentItem_Manufacturing: TDataSource;
    QJob: TADOQuery;
    dsJob: TDataSource;
    QJobRole: TADOQuery;
    dsJobRole: TDataSource;
    dsJobRoleVirtual: TDataSource;
    QJobRoleVirtual: TADOQuery;
    sp_GetJobRoleVirtual_byUser: TADOStoredProc;
    QUserList: TADOQuery;
    adsUserList: TADODataSet;
    dsSpravList: TDataSource;
    adsSpravList: TADODataSet;
    QSpravList: TADOQuery;
    QSpravData: TADOQuery;
    dsSpravData: TDataSource;
    dsJobItem: TDataSource;
    QJobItem: TADOQuery;
    QComboBox3: TADOQuery;
    dsComboBox3: TDataSource;
    frxReport_MTR_ForBuying: TfrxReport;
    frxDBDataset1: TfrxDBDataset;
    procedure DataModuleDestroy(Sender: TObject);
    procedure dsDocumentItemDataChange(Sender: TObject; Field: TField);
    procedure dsDocumentDataChange(Sender: TObject; Field: TField);
    procedure dbConnectionConnectComplete(Connection: TADOConnection;
      const Error: Error; var EventStatus: TEventStatus);
    procedure dbConnectionInfoMessage(Connection: TADOConnection;
      const Error: Error; var EventStatus: TEventStatus);
    procedure dbConnectionDisconnect(Connection: TADOConnection;
      var EventStatus: TEventStatus);
    procedure dsUserListDataChange(Sender: TObject; Field: TField);
    procedure dsJobRoleListDataChange(Sender: TObject; Field: TField);
    procedure dsRoutesItemsListDataChange(Sender: TObject; Field: TField);
    procedure dsStoreObjectListDataChange(Sender: TObject; Field: TField);
    procedure dsSpravListDataChange(Sender: TObject; Field: TField);
    procedure dsProcessListDataChange(Sender: TObject; Field: TField);
    procedure dsProcessItemDataChange(Sender: TObject; Field: TField);
    procedure dsJobItemDataChange(Sender: TObject; Field: TField);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmDB: TdmDB;
  CurrentLookupObjectGroup: TIdSpravObject;

implementation
uses unConstant, unUtilCommon, unMain, unLoginDialog, unEditDocument, unDBUtil,
  unEditSettings, unEditJobTemplate;
{$R *.dfm}

procedure TdmDB.DataModuleDestroy(Sender: TObject);
begin
 dbConnection.Close;
end;

procedure TdmDB.dsDocumentItemDataChange(Sender: TObject; Field: TField);
begin
//---------- Заносим информацию из текущей карты (Dataset) в объект "Текущая карта"
//---------- с которым потом и будет проходить вся работа, а не с Dataset-ом!!!
//---------- таким образом мы отвяжемся от структуры Dataset и в последствии, при
//-- его изменении нужно будет править только CurrentClientCard.SetCurrent(...)
  case CurrentDocument.DocumentType of
   dtMTR:
    begin
     if not VarIsNull(dsDocumentItem.DataSet.FieldByName(queryFieldName_DocumentItemId).Value) then
     begin
       CurrentDocumentItem.SetCurrent(dsDocumentItem.DataSet.FieldByName(queryFieldName_DocumentItemId).Value);
       {Обновить ЭП для текущего ЭД}
       ShowProcessItem_DocumentItem(formMain.clbProcessItemList, CurrentDocumentItem.Id);
       SetButtonState_DocumentMTR;
     end;
    end;
   dtManufacturing:
    begin
//     CurrentOrdersItem_Tree.SetCurrent(formMain.tvManufacturingItem.Selected);
    end;
   dtRepairing:
    begin
    end;
  end;

 ShowObjectDetailedInfo(CurrentDocument.IdDocument);
 if CurrentDocumentItem.Id <> 0 then
//   if formMain.dbgrDocumentItem.Focused then
    if ShowCommentForSelectedDocumentItem(formMain.tvDocumentItemComment, CurrentDocument.IdSelectedItem) then
    begin
     formMain.tsheetDocumentItemComment.TabVisible:= true;
     formMain.tvDocumentItemComment.FullExpand;
     formMain.pcontComments.ActivePageIndex:= 1;
    end
    else formMain.tsheetDocumentItemComment.TabVisible:= false;

end;

procedure TdmDB.dsDocumentDataChange(Sender: TObject; Field: TField);
begin
//---------- Заносим информацию из текущего заказа (Dataset) в объект "Текущий заказ"
//---------- с которым потом и будет проходить вся работа, а не с Dataset-ом!!!
//---------- таким образом мы отвяжемся от структуры Dataset и в последствии, при
//-- его изменении нужно будет править только CurrentOrder.SetCurrent(...)
  case CurrentDocument.DocumentType of
   dtMTR:
    begin
     CurrentActiveQueryDocumentItem:= QDocumentItem;
     CurrentDocument.SetCurrent(dsDocument.DataSet, dsDocumentItem.DataSet);
     ShowInfoOnStatusBar(3, 'Документ: ' + IntToStr(CurrentDocument.IdDocument) + '; Элемент Документа: ' + IntToStr(CurrentDocument.IdSelectedItem));
     RefreshInfoAfterDocumentChange;
     SetButtonState_DocumentMTR;
    end;
   dtManufacturing:
    begin
     CurrentActiveQueryDocumentItem:= QDocumentItem_Manufacturing;
     CurrentDocument.SetCurrent(dsDocument.DataSet, dsDocumentItem_Manufacturing.DataSet);

     if formMain.pcontDocumentItem.ActivePage = formMain.pcontDocumentItem.Pages[1] then
     begin

     end;
     if formMain.pcontDocumentItem.ActivePage = formMain.pcontDocumentItem.Pages[2] then
     begin
     end;

    end;
   dtRepairing:
    begin
    end;
   dtAll:
    begin
     CurrentDocument.SetCurrent(dsDocument.DataSet, dsDocumentItem.DataSet);
    end;
  end;

 if CurrentDocument.IdDocument <> 0 then
//   if formMain.dbgrDocument_MTR.Focused then
    if ShowCommentForSelectedDocument(formMain.tvDocumentComment, CurrentDocument.IdDocument) then
    begin
     formMain.tsheetDocumentComment.TabVisible:= true;
     formMain.tvDocumentComment.FullExpand;
     formMain.pcontComments.ActivePageIndex:= 1;
    end
    else formMain.tsheetDocumentComment.TabVisible:= false;

end;

procedure TdmDB.dbConnectionConnectComplete(Connection: TADOConnection;
  const Error: Error; var EventStatus: TEventStatus);
var
    i: byte;
begin
 If EventStatus = esOk then
 begin
  bIsAuthenticationDone:= true;
  exit;
 end;

//--- EventStatus = esErrorsOccured
 bIsAuthenticationDone:= false;
 WriteDBErrorToLog('', Error.Description, Error.Source, '', 'dmDB.dbConnectionConnectComplete', '');
 if Connection.Errors.Count > 0 then
  for i:= 0 to Connection.Errors.Count-1 do
   WriteDBErrorToLog('', Connection.Errors[i].Description, Connection.Errors[i].Source, '', 'dmDB.dbConnectionConnectComplete', '');

end;

procedure TdmDB.dbConnectionInfoMessage(Connection: TADOConnection;
  const Error: Error; var EventStatus: TEventStatus);
begin
 if EventStatus = esErrorsOccured then
  WriteDBErrorToLog('', Error.Description, Error.Source, '', 'dmDB.dbConnectionConnectComplete', '');
end;

procedure TdmDB.dbConnectionDisconnect(Connection: TADOConnection;
  var EventStatus: TEventStatus);
begin
 if EventStatus = esErrorsOccured then
  WriteDBErrorToLog('', 'EventStatus = esErrorsOccured', 'ConnectionDisconnect', '', 'dmDB.dbConnectionConnectComplete', '');
end;

procedure TdmDB.dsUserListDataChange(Sender: TObject; Field: TField);
begin
//---------- Заносим информацию из текущего пользователя (Dataset) в объект "Текущий пользователь"
//---------- с которым потом и будет проходить вся работа, а не с Dataset-ом!!!
//---------- таким образом мы отвяжемся от структуры Dataset и в последствии, при
//-- его изменении нужно будет править только CurrentUser.SetCurrent(...)

 CurrentUser.SetCurrent(dsUserList.Dataset.FieldByName(queryFieldName_UserLogin).AsString);
 GetJobRole(CurrentUser.GetIdUser);
 GetJobRoleVirtual(CurrentUser.GetIdUser);
// SetButtonStateOrdersList(CurrentActiveTreeView);
end;

procedure TdmDB.dsJobRoleListDataChange(Sender: TObject;
  Field: TField);
begin
//---------- Заносим информацию из текущей должности (Dataset) в объект "Текущий объект справочника"
//---------- с которым потом и будет проходить вся работа, а не с Dataset-ом!!!
//---------- таким образом мы отвяжемся от структуры Dataset и в последствии, при
//-- его изменении нужно будет править только CurrentSpravObject.SetCurrent(...)
 CurrentSpravObject.SetCurrent(spravJobName, dsJobRole.Dataset.FieldByName('Id').AsInteger);
end;


procedure TdmDB.dsRoutesItemsListDataChange(Sender: TObject;
  Field: TField);
begin
// CurrentRouteItem.SetCurrent(dsRoutesItemsList.DataSet);
end;

procedure TdmDB.dsStoreObjectListDataChange(Sender: TObject;
  Field: TField);
begin
 CurrentStoreObject.SetCurrent(dsStoreObjectList.DataSet);
end;

procedure TdmDB.dsSpravListDataChange(Sender: TObject; Field: TField);
begin
 CurrentSprav.SetCurrent(dsSpravList.Dataset.FieldByName(queryFieldName_SpravShortName).AsString);
 GetSpravData(CurrentSprav.GetShortName, dmDb.QSpravData);
end;

procedure TdmDB.dsProcessListDataChange(Sender: TObject; Field: TField);
begin
 CurrentTemplateProcess.SetCurrent(dsProcessList.DataSet.FieldByName(queryFieldName_TemplateProcessId).AsInteger);
 GetTemplateProcessItem(CurrentTemplateProcess.GetId);
end;

procedure TdmDB.dsProcessItemDataChange(Sender: TObject; Field: TField);
begin
 CurrentTemplateProcessItem.SetCurrent(dsProcessItem.DataSet.FieldByName(queryFieldName_TemplateProcessItemId).AsInteger);
 if formEditSettings.rbForDocument.checked then
  GetJobItem_TemplateProcessItem_Document(CurrentTemplateProcessItem.GetId)
  else
  GetJobItem_TemplateProcessItem_DocumentItem(CurrentTemplateProcessItem.GetId);

end;

procedure TdmDB.dsJobItemDataChange(Sender: TObject; Field: TField);
begin
 CurrentJobItemTemplate.SetCurrent(dsProcessItem.DataSet.FieldByName(queryFieldName_TemplateProcessItemId).AsInteger, dtTemplate);
end;

end.
