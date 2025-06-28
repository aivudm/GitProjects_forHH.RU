unit unTrashButHelpful;

interface
//function CreateCard: boolean;
//function AddDiagnosisRecord(inputIdCard: integer; inputDateDiagnosis: TDateTime; inputDiseaseCode: string): boolean;
//procedure FillTree(Tree: TTreeView; Query: TADOQuery; idNode, idParent, cNodeName: string);
//procedure TreeViewQuickSearch(InputTree: TTreeView; SearchTarget: string );
//function TransOemToAnsi(NameString:String):String;
//function TransAnsiToOem(NameString:String):String;
//function IsDateAsTextValid(InputStringAsDate: String):boolean;
//    procedure QReport1AfterScroll(DataSet: TDataSet);
//    procedure QReport2FilterRecord(DataSet: TDataSet; var Accept: Boolean);


implementation

{
function CreateCard: boolean;
var
 tmpString: AnsiString;
begin
try
 with dmDB.QCommon do
 begin
  SQL.Text:= 'EXEC sp_CreateCard :p_AreaNumber, :p_CardOpenedDate, :p_Firstname, ';
  SQL.Text:= SQL.Text + ':p_Name, :p_FatherName, :p_Sex, :p_Birthday';
  Parameters.Clear;

  //--------- Create parameter :p_AreaNumber -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_AreaNumber';
  Parameters[Parameters.Count-1].DataType:= ftString;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= formCreateCard.cbAreaNumber.Text;
//----------------------------------------------------------------------------------
//--------- Create parameter :p_CardOpenedDate -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_CardOpenedDate';
  Parameters[Parameters.Count-1].DataType:= ftDatetime;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= formCreateCard.dtpCardOpenedDate.DateTime;
//----------------------------------------------------------------------------------
//--------- Create parameter :p_Firstname -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_Firstname';
  Parameters[Parameters.Count-1].DataType:= ftString;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= formCreateCard.edF.Text;
//----------------------------------------------------------------------------------
//--------- Create parameter :p_Name -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_Name';
  Parameters[Parameters.Count-1].DataType:= ftString;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= formCreateCard.edN.Text;
//----------------------------------------------------------------------------------
//--------- Create parameter :p_FatherName -----------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_FatherName';
  Parameters[Parameters.Count-1].DataType:= ftString;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= formCreateCard.edFN.Text;
//----------------------------------------------------------------------------------
//--------- Create parameter :p_Sex ------------------------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_Sex';
  Parameters[Parameters.Count-1].DataType:= ftString;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= formCreateCard.cbSex.Text;
//----------------------------------------------------------------------------------
//--------- Create parameter :p_Birthday -----------------------------------------
  Parameters.AddParameter;
  Parameters[Parameters.Count-1].Name:= 'p_Birthday';
  Parameters[Parameters.Count-1].DataType:= ftDatetime;
  Parameters[Parameters.Count-1].Direction:= pdInput;
  Parameters[Parameters.Count-1].Value:= formCreateCard.dtpBirthday.DateTime;
//----------------------------------------------------------------------------------

  Open();
//  ExecSQL;
  if fields[0].AsInteger <> 0 then
  begin
   tmpString:= 'EXEC sp_CreateCard завершился с ошибкой: ' + IntToStr(fields[0].AsInteger);
   WriteLn(logFile, 'CreateCard(...)' + 'Error: ' + tmpString);
  end;
 end;
except
 On e: EOleException do
  begin
   tmpString:= e.Message + '; ' + IntToStr(e.ErrorCode) + e.HelpFile;
   WriteLn(logFile, 'CreateCard(...)' + 'Error: ' + tmpString);
  end;

 On e: Exception do
  begin
   tmpString:= e.Message + #13#10 + e.ClassName();
   WriteLn(logFile, 'CreateCard(...)' + 'Error: ' + tmpString);
  end;
end;
end;
}

{
function AddDiagnosisRecord(inputIdCard: integer; inputDateDiagnosis: TDateTime; inputDiseaseCode: string): boolean;
var
 tmpString: AnsiString;
begin
try
 with dmDB.spAddDiagnosis do
 begin
  Parameters.ParamByName('@input_IdCard').Value:= inputIdCard;
  Parameters.ParamByName('@input_DateDiseaseSet').Value:= inputDateDiagnosis;
  Parameters.ParamByName('@input_DiseaseCode').Value:= AllTrim(inputDiseaseCode);
  Parameters.ParamByName('@input_DiseaseCodeBasic').Value:= AllTrim(inputDiseaseCode);
  Active;
  if Parameters.ParamByName('@RETURN_VALUE').Value <> 0 then
  begin
   WriteLn(logFile, 'ошибка в AddDiagnosisRecord(...)');
  end;
 end;
except
 On e: EOleException do
  begin
   tmpString:= e.Message + '; ' + IntToStr(e.ErrorCode) + e.HelpFile;
   WriteLn(logFile, FormatDateTime('yyyy.mm.dd hh:mm:ss', Today()) + 'CreateCard(...)' + 'Error: ' + tmpString);
  end;

 On e: Exception do
  begin
   tmpString:= e.Message + #13#10 + e.ClassName();
   WriteLn(logFile, FormatDateTime('yyyy.mm.dd hh:mm:ss', Today()) + 'CreateCard(...)' + 'Error: ' + tmpString);
  end;
end;
end;
}

{
procedure FillTree(Tree: TTreeView; Query: TADOQuery; idNode, idParent,
  cNodeName: string);
var
  i: integer;
begin
  // Корневой узел, должен быть первым в выборке Query
  Query.First;
  Tree.Items.Clear;
  Tree.Items.AddObject(nil, Query.FieldByName(cNodeName).AsString,
    Pointer(Query.FieldByName(idNode).asInteger));
  Query.Next;
  while not Query.Eof do
  begin
    i := 0;
    while i < Tree.Items.Count do
      if Tree.Items.Item[i].Data = Pointer(Query.FieldByName(idParent).asInteger)
        then
      begin
        Tree.Items.AddChildObject(Tree.Items.Item[i],
          Query.FieldByName(cNodeName).AsString,
          Pointer(Query.FieldByName(idNode).asInteger));
        break;
      end
      else
        Inc(i);
    Query.Next;
  end;
end;

}

{
procedure TreeViewQuickSearch(InputTree: TTreeView; SearchTarget: string );
var
  CurNode: TTreeNode;
  Searching: boolean;
begin
   CurNode := InputTree.Items[0];
   Searching := true;
   while ( Searching ) and ( CurNode <> nil ) do
   begin
      if copy(CurNode.Text, 0, length(SearchTarget)) = SearchTarget then
      begin
         Searching := false;
         InputTree.Selected := CurNode;
         InputTree.SetFocus;
      end
      else
         CurNode := CurNode.GetNext;
   end;
end;
}

{

function TransOemToAnsi(NameString:String):String;
var
   PNameString:PChar;
begin // TransOemToAnsi
try
   GetMem(PNameString,MaxLenMyTransString);
   StrPCopy(PNameString,NameString);
   OemToAnsi(PNameString,PNameString);
   Result:=StrPas(PNameString);
   FreeMem(PNameString,MaxLenMyTransString);

except
   FreeMem(PNameString,MaxLenMyTransString);
   Application.Terminate;
end;
end; // TransOemToAnsi

function TransAnsiToOem(NameString:String):String;
var
   PNameString: PChar;
begin
try
   GetMem(PNameString, MaxLenMyTransString);
   StrPCopy(PNameString, NameString);
   AnsiToOem(PNameString, PNameString);
   Result:=StrPas(PNameString);
   FreeMem(PNameString, MaxLenMyTransString);
except
   FreeMem(PNameString,MaxLenMyTransString);
   Application.Terminate;
end;
end; // TransAnsiToOem
}

{

function IsDateAsTextValid(InputStringAsDate: String):boolean;
begin
 try
  FormatDateTime('yyyymmdd', StrToDate(InputStringAsDate));
  result:= true;
 except
  result:= false;
 end;
end;
}

{
function MakeCardsQuery(CurrentClientsOrder: TClientsOrder): boolean;   //------- Вариант без фильтра
var
 tmpString: AnsiString;
 strCurrentProcName: string; //для хранения имени текущей процедуры/функции - унификация подстановки
 strCurrentStoredProcName: string;
begin
 strCurrentProcName:= 'MakeCardsQuery(...)';
 Result:= false;
try
 case CurrentClientsOrder of
  byName: dmDB.QCardsList.SQL.Text:= 'EXEC sp_GetCardsList_byName';
  byAreaNumber_FIO: dmDB.QCardsList.SQL.Text:= 'EXEC sp_GetCardsList_byAreaNumberFIO';
 else dmDB.QCardsList.SQL.Text:= 'EXEC sp_GetCardsList_byName';
 end;
 dmDB.QCardsList.Open();
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

procedure ShowRoutesList_OnlyValid(InputDBGrid: TDBGrid; inputRouteType: TRouteType);
var
 i: integer;
begin
try
// InputQuery:= ExecuteRoutesListQuery(ShowActiveRoutes);
  case ShowRoutesFilter of
   rasActiveAndDeleted: i:= 0;
   rasActiveOnly: i:= 1;
   else i:= 0;
  end;
//  ExecuteRoutesListQuery_OnlyValid(i);
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

function GetNameProcessStatusByCode(inputProcessStatusCode: TOrderProcessStatus): string;
var
   i: integer;
begin
 result:= '';
 for i:= 1 to ProcessStatusCount do
 begin
  if CodeOfProcessStatus[i] = inputProcessStatusCode then
  begin
   result:= NameOfProcessStatus[i];
   exit;
  end;
 end;
end;



procedure TformMain.pcontStatusListChange(Sender: TObject);
begin
 case (Sender as TPageControl).ActivePageIndex of
 0:
  begin
   //--- Сохраним в .INI параметры фильтра
//   formMain.tbFilterSettingsStoreClick(Sender);
1  //---------------------------------------------------
   pcontCommonInfo.ActivePage:= tsheetOrderInfo_MTR;
   gbCurrentOrdersRoute.Visible:= true;
//   pnlCurrentOrdersRoute.Visible:= true;

//   CurrentOrder.SetCurrent(dmDB.dsDocumentList.DataSet, dmDB.dsOrdersItems.DataSet);
//   ShowObjectDetailedInfo(CurrentOrder.IdCard);
//   FindPositionInTreeBy(tvObjects, CurrentOrder.Name + ' ' +
//                                   CurrentOrder.Firstname + ' ' +
//                                   CurrentOrder.Fathername, CurrentOrder.IdCard);
  end;
 1:
  begin
   pcontCommonInfo.ActivePage:= tsheetStoreInfo_MTR;
   tsheetStoreInfo_MTR.Caption:= tsheetStoreMTRCommonInfo_Name;
   gbCurrentOrdersRoute.Visible:= false;


//   pnlCurrentOrdersRoute.Visible:= false;
   tbRefreshStoreObject.OnClick(Sender);

//------- Заполнение ComboBox's из справочников ---------------------------------

  Execute_SP('sp_GetUserCreatedDocument', dmDB.QComboBox1);
  FillComboBoxFromQuery(cbObjectInitiatorOwner, dmDB.QComboBox1, queryFieldName_SpravFullName);
//  cbOrderCreatorOwner.Text:= cbOrderCreatorOwner.Items[0];

  Execute_SP('sp_GetSpravObjectGroup_MTR', dmDB.QComboBox2);
  FillComboBoxFromQuery(cbObjectGroup, dmDB.QComboBox2, queryFieldName_SpravShortName);
//  cbObjectGroup.Text:= cbObjectGroup.Items[0];
//------- Конец заполнения ComboBox's из справочников ---------------------------------

  FilterForStoreObjects.ReadValuesFromIniFile(FilterForStoreObjects);
  ckbOrdersCreatorOwner.Checked:= (FilterForStoreObjects.GetStateInitiatorOwner = fsOn);
  cbObjectInitiatorOwner.Text:= FilterForStoreObjects.GetValueInitiatorOwner;

  ckbObjectsGroups.Checked:= (FilterForStoreObjects.GetStateObjectsGroup = fsOn);
  cbObjectGroup.Text:= FilterForStoreObjects.GetValueObjectsGroup;
  ckbPeriodOrderCreating.Checked:= (FilterForStoreObjects.GetStatePeriodParentObjectCreating = fsOn);
  dtpPeriodBeginLinkedOrderCreation.Date:= FilterForStoreObjects.GetValuePeriodBeginParentObjectCreating;
  dtpPeriodEndLinkedOrderCreation.Date:= FilterForStoreObjects.GetValuePeriodEndParentObjectCreating;
  ckbPeriodStoreObjectCreating.Checked:= (FilterForStoreObjects.GetStatePeriodCreating = fsOn);
  dtpPeriodBeginPutOnStock.Date:= FilterForStoreObjects.GetValuePeriodBeginCreating;
  dtpPeriodEndPutOnStock.Date:= FilterForStoreObjects.GetValuePeriodEndCreating;

  rbFilterON.Checked:= (FilterForStoreObjects.GetState = fsOn);
  end;
 end;
end;

procedure TdmDB.QReport1AfterScroll(DataSet: TDataSet);
var
  tmpInt: Integer;
begin
{
 if not Assigned(QReport1) then exit;
 QReport2.Filtered:= false;
 tmpInt:= QReport2.RecordCount;
 QReport2.Filter:= 'CodeGroup=' + IntToStr(DataSet.Fields.FieldByName('Code').Value);
// QReport2.Filter:= 'CodeGroup=2';

 CurrentLookupObjectGroup:= DataSet.Fields.FieldByName('Code').Value;
 QReport2.Filtered:= true;
 QReport2.First;
 tmpInt:= QReport2.RecordCount;
}
// if CurrentLookupObjectGroup <> 4 then


// QReport2.Close;
// CurrentLookupObjectGroup:= DataSet.Fields.FieldByName('Code').Value;
// MakeQueryObjectsForReport(CurrentUser.GetLoginName, CurrentLookupObjectGroup);
// QReport2.Open;
// QReport2.Filtered:= true;
// if QReport1.Eof then dmDB.QReport1.AfterScroll:= nil;
//end;
{
procedure TdmDB.QReport2FilterRecord(DataSet: TDataSet;
  var Accept: Boolean);
var
  tmpInt: integer;
begin
 Accept:= true; //(DataSet.Fields.FieldByName(queryFieldNameForCodeGroup).Value = QReport1.Fields.FieldByName(queryFieldNameForSpravCode).Value);
 tmpInt:= DataSet.Fields.FieldByName(queryFieldName_DocumentId).Value;
end;


}
end.
