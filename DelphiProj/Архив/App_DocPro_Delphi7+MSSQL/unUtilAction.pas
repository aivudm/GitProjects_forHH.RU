unit unUtilAction;

interface
uses
  Windows, Classes, Controls, SysUtils, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, DB,
  unConstant, unVariable, ExtCtrls, ExtDlgs, CheckLst;

{
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, DB,
  unConstant, unVariable, ExtCtrls, ExtDlgs, CheckLst;
}


procedure Refresh_Action(Sender: TObject);
procedure Document_Agree(Sender: TObject; inputJob: TJobDocumentItem);

procedure DocumentItem_Agree(Sender: TObject; inputJob: TJobDocumentItem);
procedure DocumentItem_Deny(Sender: TObject; inputJob: TJobDocumentItem);
procedure DocumentItem_Alter(Sender: TObject; inputJob: TJobDocumentItem);

procedure AlterOrder_Action(Sender: TObject; inputResolutionText: string);

procedure DenyOrderItem_Action(Sender: TObject; inputResolutionText: string);
procedure AlterOrderItem_Action(Sender: TObject; inputResolutionText: string);


implementation
uses unUtilCommon, unDBUtil, unDM, unMain, unResolutionWriter;

procedure Refresh_Action(Sender: TObject);
begin
try
 with formMain do
 begin
  SetCursorWait(StatusBar1);
  RefreshDocumentHierarchical(tvHierarchicalTotal, dhtTotal);
  RefreshDocumentHierarchical(tvHierarchicalInput, dhtInput);
//  ShowDataForSelectedNode(CurrentActiveTreeView, CurrentHierarchicalJobView);
//------- Правим интерфейс по ситуации -----------------------------------------
  SetButtonStateForCurrentDocumentType;
//------------------------------------------------------------------------------

  StatusBar1.Panels[2].Text:= 'Всего входящих: ' + IntToStr(tvHierarchicalInput.Items.Count);
  tvHierarchicalTotal.FullExpand;
 end;
finally
  SetCursorIdle(formMain.StatusBar1);
end;
end;

procedure Document_Agree(Sender: TObject; inputJob: TJobDocumentItem);
var
  tmpConfirmResult: TConfirmResult;
  curRecordPos: TIdDSPositionSaver;
  curDocumentJobId: TIdJob;
  tmpString: String;
begin
//-----------------------------------------------------------------------------------------------------------------
//----  inputJob пока не используется. В заявках на МТР Работа состоит только из Базовых Действий -----------------
//-----------------------------------------------------------------------------------------------------------------
 tmpString:= 'Вы действительно хотите согласовать документ?';

 tmpConfirmResult:= ConfirmDlg(tmpString + #13#10 +
                                'Номер документа: ' + CurrentDocument.DocumentNum + #13#10 +
                                'Наименование: ' + CurrentDocument.Notes + #13#10 +
                                'Инициатор: ' + CurrentDocument.CreatorOwner + #13#10);
 if (tmpConfirmResult = NoResult) or (tmpConfirmResult = CancelResult) then exit;

 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocument);

 if not Document_ExecJob(CurrentDocument.IdDocument, jrAgree) then
  MessageBox('Операция не выполнена.', errorMessage);
 ShowDataForSelectedNode;

 DSPositionSaver.RestorePosition(dmDB.QDocument, curRecordPos);

 Refresh_Action(Sender);
 RefreshDocument;

end;


procedure DocumentItem_Agree(Sender: TObject; inputJob: TJobDocumentItem);
var
  tmpConfirmResult: TConfirmResult;
  curRecordPos: TIdDSPositionSaver;
  curDocumentJobId: TIdJob;
  tmpString: String;
begin
//-----------------------------------------------------------------------------------------------------------------
//----  inputJob пока не используется. В заявках на МТР Работа состоит только из Базовых Действий -----------------
//-----------------------------------------------------------------------------------------------------------------
 tmpString:= 'Вы действительно хотите согласовать элемент документа?';

 tmpConfirmResult:= ConfirmDlg(tmpString + #13#10 +
                                'Номер документа: ' + CurrentDocument.DocumentNum + #13#10 +
                                '   Наименование: ' + CurrentDocument.Notes + #13#10 +
                                '      Инициатор: ' + CurrentDocument.CreatorOwner + #13#10);
 if (tmpConfirmResult = NoResult) or (tmpConfirmResult = CancelResult) then exit;

 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocument);

 DocumentItem_ExecJob(CurrentDocument.IdSelectedItem, jrAgree, inputJob.ResolutionText);
 ShowDataForSelectedNode;

 DSPositionSaver.RestorePosition(dmDB.QDocument, curRecordPos);

 Refresh_Action(Sender);
 RefreshDocument;

end;

procedure DocumentItem_Deny(Sender: TObject; inputJob: TJobDocumentItem);
var
  tmpConfirmResult: TConfirmResult;
  curRecordPos: TidDSPositionSaver;
begin
 tmpConfirmResult:= ConfirmDlg('Вы действительно хотите отменить Элемент Документа?' + #13#10 +
                                'Номер Документа: ' + IntToStr(CurrentDocument.IdDocument) + #13#10 +
                                CurrentDocument.Notes + #13#10 +
                                'Инициатор: ' + CurrentDocument.CreatorOwner + #13#10);
 if (tmpConfirmResult = NoResult) or (tmpConfirmResult = CancelResult) then exit;

 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocument);

 DocumentItem_ExecJob(CurrentDocument.IdSelectedItem, jrDeny, inputJob.ResolutionText);
 ShowDataForSelectedNode;

 DSPositionSaver.RestorePosition(dmDB.QDocument, curRecordPos);

 Refresh_Action(Sender);
 RefreshDocument;
end;

procedure DocumentItem_Alter(Sender: TObject; inputJob: TJobDocumentItem);
var
  tmpConfirmResult: TConfirmResult;
  curRecordPos: TidDSPositionSaver;
begin
 tmpConfirmResult:= ConfirmDlg('Вы действительно хотите направить на доработку Элемент Документа?' + #13#10 +
                                'Номер Документа: ' + IntToStr(CurrentDocument.IdDocument) + #13#10 +
                                CurrentDocument.Notes + #13#10 +
                                'Инициатор: ' + CurrentDocument.CreatorOwner + #13#10);
 if (tmpConfirmResult = NoResult) or (tmpConfirmResult = CancelResult) then exit;

 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocument);

 DocumentItem_ExecJob(CurrentDocument.IdSelectedItem, jrDeny, inputJob.ResolutionText);
 ShowDataForSelectedNode;

 DSPositionSaver.RestorePosition(dmDB.QDocument, curRecordPos);

 Refresh_Action(Sender);
 RefreshDocument;
end;

procedure AlterOrder_Action(Sender: TObject; inputResolutionText: string);
var
  tmpConfirmResult: TConfirmResult;
  curRecordPos: TidDSPositionSaver;
begin
 tmpConfirmResult:= ConfirmDlg('Вы действительно хотите отправить заявку на переработку?' + #13#10 +
                                'Номер заявки: ' + IntToStr(CurrentDocument.IdDocument) + #13#10 +
                                CurrentDocument.Notes + #13#10 +
                                'Инициатор: ' + CurrentDocument.CreatorOwner + #13#10);
 if (tmpConfirmResult = NoResult) or (tmpConfirmResult = CancelResult) then exit;

  curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocument);
  DocumentItem_ExecJob(CurrentDocument.IdDocument, jrAlter);
  DSPositionSaver.RestorePosition(dmDB.QDocument, curRecordPos);
  ShowDataForSelectedNode;
  Refresh_Action(Sender);
  RefreshDocument;
end;

procedure DenyOrderItem_Action(Sender: TObject; inputResolutionText: string);
var
  tmpConfirmResult: TConfirmResult;
  curRecordPos, curRecordPos1: TidDSPositionSaver;
begin
 tmpConfirmResult:= ConfirmDlg('Вы действительно хотите отменить выделенную позицию заявки?' + #13#10 +
                                'Номер заявки: ' + IntToStr(CurrentDocument.IdDocument) + #13#10 +
                                'Позиция: ' + #13#10 + '[' + CurrentDocumentItem.ObjectsGroup + ']' + #13#10 +
                                'Наименование: ' + CurrentDocumentItem.ShortName + #13#10 +
                                'Инициатор: ' + CurrentDocument.CreatorOwner + '[' + GetUserFullName(CurrentDocument.CreatorOwner) + ']' + #13#10);
 if (tmpConfirmResult = NoResult) or (tmpConfirmResult = CancelResult) then exit;

  curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocument);
  curRecordPos1:= DSPositionSaver.SavePosition(dmDB.QDocumentItem);

  DenyOrdersItem(CurrentDocument.IdDocument, CurrentDocumentItem.Id, inputResolutionText);
  RefreshDocument;
  ShowDocumentItem_Document(CurrentDocument.IdDocument);

  DSPositionSaver.RestorePosition(dmDB.QDocument, curRecordPos);
  DSPositionSaver.RestorePosition(dmDB.QDocumentItem, curRecordPos1);
end;

procedure AlterOrderItem_Action(Sender: TObject; inputResolutionText: string);
var
  tmpConfirmResult: TConfirmResult;
  curRecordPos, curRecordPos1: TidDSPositionSaver;
begin
 tmpConfirmResult:= ConfirmDlg('Вы действительно хотите отправить выделенную позицию заявки на переработку (будет создано дополнение к основной заявке)?' + #13#10 +
                                'Номер заявки: ' + IntToStr(CurrentDocument.IdDocument) + #13#10 +
                                'Позиция: ' + #13#10 + '[' + CurrentDocumentItem.ObjectsGroup + ']' + #13#10 +
                                'Наименование: ' + CurrentDocumentItem.ShortName + #13#10 +
                                'Инициатор: ' + CurrentDocument.CreatorOwner + '[' + GetUserFullName(CurrentDocument.CreatorOwner) + ']' + #13#10);
 if (tmpConfirmResult = NoResult) or (tmpConfirmResult = CancelResult) then exit;

  curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocument);
  curRecordPos1:= DSPositionSaver.SavePosition(dmDB.QDocumentItem);

  AlterOrdersItem(CurrentDocument.IdDocument, CurrentDocumentItem.Id, inputResolutionText);
  RefreshDocument;
  ShowDocumentItem_Document(CurrentDocument.IdDocument);
  DSPositionSaver.RestorePosition(dmDB.QDocument, curRecordPos);
  DSPositionSaver.RestorePosition(dmDB.QDocumentItem, curRecordPos1);
end;


end.
