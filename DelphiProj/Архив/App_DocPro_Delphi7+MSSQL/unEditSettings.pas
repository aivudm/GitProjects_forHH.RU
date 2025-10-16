unit unEditSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ToolWin, StdCtrls, Menus, ExtCtrls, Grids,
  DBGrids, DB, ADODB,
  unVariable, unConstant;

type
  TformEditSettings = class(TForm)
    StatusBar1: TStatusBar;
    pcontSettings: TPageControl;
    tabsheetCommonInfo: TTabSheet;
    tabsheetRoutes: TTabSheet;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    GroupBox1: TGroupBox;
    CoolBar1: TCoolBar;
    toolbarDatabaseOperations: TToolBar;
    tbApply: TToolButton;
    ToolButton5: TToolButton;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    tbExit: TToolButton;
    Splitter1: TSplitter;
    tvUserJobRole: TTreeView;
    tbRefresh: TToolButton;
    ToolButton18: TToolButton;
    GroupBox4: TGroupBox;
    CheckBox1: TCheckBox;
    ToolButton17: TToolButton;
    tbEditOnOff: TToolButton;
    ToolButton20: TToolButton;
    tabsheetUsers: TTabSheet;
    ilDirectoryOperations: TImageList;
    ilObjectExplorer: TImageList;
    GroupBox5: TGroupBox;
    GroupBox7: TGroupBox;
    gbRoutesDescriptions: TGroupBox;
    ToolBar1: TToolBar;
    tbRefreshProcess: TToolButton;
    ToolButton2: TToolButton;
    tbEditProcess: TToolButton;
    tbAddProcess: TToolButton;
    ToolButton6: TToolButton;
    tbDeleteProcess: TToolButton;
    dbgProcessList: TDBGrid;
    gbJobProcessItem: TGroupBox;
    ToolBar4: TToolBar;
    tbRefreshJobItems: TToolButton;
    ToolButton24: TToolButton;
    tbEditJobItem: TToolButton;
    tbAddJobItem: TToolButton;
    ToolButton27: TToolButton;
    tbDeleteJobItem: TToolButton;
    TabSheet1: TTabSheet;
    ToolButton7: TToolButton;
    cbShowDeactivatedProcess: TCheckBox;
    Panel1: TPanel;
    GroupBox2: TGroupBox;
    Splitter2: TSplitter;
    Panel2: TPanel;
    GroupBox3: TGroupBox;
    ToolBar2: TToolBar;
    tbRefreshSpravData: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    Splitter3: TSplitter;
    Panel3: TPanel;
    GroupBox8: TGroupBox;
    Panel4: TPanel;
    ToolBar5: TToolBar;
    tbRefreshUsersList: TToolButton;
    ToolButton30: TToolButton;
    ToolButton31: TToolButton;
    ToolButton32: TToolButton;
    ToolButton33: TToolButton;
    ToolButton34: TToolButton;
    ToolButton8: TToolButton;
    cbShowDeletedUsers: TCheckBox;
    dbgUsersList: TDBGrid;
    Splitter4: TSplitter;
    Panel6: TPanel;
    ToolBar7: TToolBar;
    tbVirtyualJobRoleList: TToolButton;
    ToolButton42: TToolButton;
    ToolButton43: TToolButton;
    ToolButton44: TToolButton;
    ToolButton45: TToolButton;
    ToolButton46: TToolButton;
    dbgAliasJobRoleList: TDBGrid;
    Splitter5: TSplitter;
    Panel7: TPanel;
    GroupBox6: TGroupBox;
    ToolBar3: TToolBar;
    tbJobRole_byUser: TToolButton;
    ToolButton19: TToolButton;
    ToolButton21: TToolButton;
    ToolButton22: TToolButton;
    ToolButton23: TToolButton;
    ToolButton25: TToolButton;
    ToolButton26: TToolButton;
    CheckBox2: TCheckBox;
    DBGrid3: TDBGrid;
    ToolBar6: TToolBar;
    tbRefreshSpravList: TToolButton;
    ToolButton28: TToolButton;
    ToolButton29: TToolButton;
    ToolButton35: TToolButton;
    ToolButton36: TToolButton;
    ToolButton37: TToolButton;
    ToolButton38: TToolButton;
    CheckBox3: TCheckBox;
    Splitter6: TSplitter;
    gbJobProcess: TGroupBox;
    ToolBar8: TToolBar;
    ToolButton16: TToolButton;
    ToolButton39: TToolButton;
    ToolButton40: TToolButton;
    ToolButton41: TToolButton;
    ToolButton47: TToolButton;
    ToolButton48: TToolButton;
    ToolButton49: TToolButton;
    rbForDocumentItem: TRadioButton;
    rbForDocument: TRadioButton;
    dbgJobItem: TDBGrid;
    Panel5: TPanel;
    dbgProcessItem: TDBGrid;
    procedure DefaultOnChangeActions(Sender: TObject);       //---- Добавлена вручную
    procedure N2Click(Sender: TObject);
    procedure tabsheetCommonInfoShow(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tbRefreshClick(Sender: TObject);
    procedure tvUserJobRoleDblClick(Sender: TObject);
    procedure tbEditOnOffClick(Sender: TObject);
    procedure tbRefreshProgramRolesListClick(Sender: TObject);
    procedure tbRefreshUsersListClick(Sender: TObject);
    procedure pcontSettingsChange(Sender: TObject);
    procedure tbVirtyualJobRoleListClick(Sender: TObject);
    procedure dbgUsersListDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure dbgAliasJobRoleListDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure pcontSettingsResize(Sender: TObject);
    procedure ToolButton31Click(Sender: TObject);
    procedure ToolButton32Click(Sender: TObject);
    procedure dbgUsersListDblClick(Sender: TObject);
    procedure ToolButton43Click(Sender: TObject);
    procedure ToolButton44Click(Sender: TObject);
    procedure tbRefreshProcessClick(Sender: TObject);
    procedure tbAddProcessClick(Sender: TObject);
    procedure tbEditProcessClick(Sender: TObject);
    procedure tabsheetRoutesShow(Sender: TObject);
    procedure tbEditJobItemClick(Sender: TObject);
    procedure tbRefreshJobItemsClick(Sender: TObject);
    procedure tbAddJobItemClick(Sender: TObject);
    procedure dbgProcessListDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure tbDeleteProcessClick(Sender: TObject);
    procedure cbShowDeactivatedProcessClick(Sender: TObject);
    procedure ToolButton34Click(Sender: TObject);
    procedure rbForDocumentItemClick(Sender: TObject);
    procedure rbForDocumentClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tbRefreshSpravListClick(Sender: TObject);
    procedure tbRefreshSpravDataClick(Sender: TObject);
    procedure ToolButton48Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formEditSettings: TformEditSettings;
  CurrentTemplateProcessItem: TProcessItem;

implementation
uses unUtilCommon, unDM, unDBUtil, unEditUser, unEditJobPosition, unEditProcess,
  unEditProcessItem, unEditJobTemplate;
{$R *.dfm}

//-------------- Вручную добавленные процедуры и фукции в классах ---------------------------
procedure TformEditSettings.DefaultOnChangeActions(Sender: TObject);
begin
// bbSave.Enabled:= true;
end;
//-------------------------------------------------------------------------------------------


procedure TformEditSettings.N2Click(Sender: TObject);
begin
 Close;
end;

procedure TformEditSettings.tabsheetCommonInfoShow(Sender: TObject);
begin
 RefreshTreeViewUserJobRole(tvUserJobRole);
 tvUserJobRole.FullExpand;
end;

procedure TformEditSettings.FormShow(Sender: TObject);
begin
try
  formCurrentActive:= 'formEditSettings';
  SetCursorWait(formEditSettings.StatusBar1);
  formEditSettings.pcontSettingsChange(Sender);
finally
  SetCursorIdle(formEditSettings.StatusBar1);
end;

end;

procedure TformEditSettings.tbRefreshClick(Sender: TObject);
begin
  RefreshTreeViewUserJobRole(formEditSettings.tvUserJobRole);
end;

procedure TformEditSettings.tvUserJobRoleDblClick(Sender: TObject);
begin
 if not bCanEditData then exit;

 
end;

procedure TformEditSettings.tbEditOnOffClick(Sender: TObject);
begin
 bCanEditData:= tbEditOnOff.CheckMenuDropdown;
end;

procedure TformEditSettings.tbRefreshProgramRolesListClick(Sender: TObject);
begin
 ShowProgramRoleList(formEditSettings.dbgAliasJobRoleList, dmDB.QProgramRoleList);
end;

procedure TformEditSettings.tbRefreshUsersListClick(Sender: TObject);
begin
 GetUserList();
end;

procedure TformEditSettings.pcontSettingsChange(
  Sender: TObject);
begin
 case pcontSettings.ActivePageIndex of
  0:
   begin
    GetUserList;
    RefreshTreeViewUserJobRole(formEditSettings.tvUserJobRole);
    StatusBar1.Panels[1].Text:= 'Всего пользователей: ' + IntToStr(tvUserJobRole.Items.Count) + '/' + IntToStr(tvUserJobRole.Items.Count);
    tvUserJobRole.FullExpand;
   end;
  1:
   begin
    tbRefreshProcess.Click;
   //    dmDB.dsRoutesList.OnDataChange:= dmDB.dsRoutesListDataChange_From_unEditSettings;
//    dmDB.dsRoutesItemsList.OnDataChange:= dmDB.dsRoutesItemsListDataChange_From_unEditSettings;
//    ExecuteRoutesListQuery(cbShowDeactivatedRoutes.Checked);
   end;
  2:
   begin
    GetUserList;
    tbRefreshUsersList.OnClick(Sender);
   end;
  3:
   begin
    GetSpravList;
    tbRefreshSpravList.OnClick(Sender);
   end;
 end; {case of}
end;

procedure TformEditSettings.tbVirtyualJobRoleListClick(Sender: TObject);
begin
 Execute_SP('sp_GetSpravJobRole', dmDB.QJobRole);
end;

procedure TformEditSettings.dbgUsersListDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
With dbgUsersList do
begin
 if DataSource.DataSet.RecNo mod 2 = 1
	then Canvas.Brush.Color:= ColorZebraGrid;

	// Восстанавливаем выделение текущей позиции курсора
	if  gdSelected in State
	then Begin
		Canvas.Brush.Color:= clHighLight;
		Canvas.Font.Color := clHighLightText;
	end;
	// Просим GRID перерисоваться самому
	DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;
end;

procedure TformEditSettings.dbgAliasJobRoleListDrawColumnCell(
  Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
With dbgAliasJobRoleList do
begin
 if DataSource.DataSet.RecNo mod 2 = 1
	then Canvas.Brush.Color:= ColorZebraGrid;

	// Восстанавливаем выделение текущей позиции курсора
	if  gdSelected in State
	then Begin
		Canvas.Brush.Color:= clHighLight;
		Canvas.Font.Color := clHighLightText;
	end;
	// Просим GRID перерисоваться самому
	DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;
end;

procedure TformEditSettings.pcontSettingsResize(Sender: TObject);
begin
//-------- Раздвинем колонку с наименованием заявки по максимуму,
//-------- в зависимости от общей ширины Grid
//---------------- Изменение размера для ФИО пользователей ---------------------
 with dbgUsersList do
 begin
  Columns[0].Width:= Width - Columns[1].Width - Columns[2].Width - Columns[3].Width
                     - col_ShiftForSysCol;
 end;

//---------------- Изменение размера для наименования должностей ---------------
 with dbgAliasJobRoleList do
 begin
  Columns[0].Width:= Width - Columns[1].Width - col_ShiftForSysCol;
 end;

end;

procedure TformEditSettings.ToolButton31Click(Sender: TObject);
begin
  Application.CreateForm(TformEditUser, formEditUser);
  formEditUser.formTypeOperation:= doEdit;
  formEditUser.ShowModal;
  formEditUser.Free;
  formEditSettings.dbgUsersList.Refresh;
end;

procedure TformEditSettings.ToolButton32Click(Sender: TObject);
begin
  Application.CreateForm(TformEditUser, formEditUser);
  formEditUser.formTypeOperation:= doAdd;
  formEditUser.ShowModal;
  formEditUser.Free;
  formEditSettings.dbgUsersList.Refresh;
end;

procedure TformEditSettings.dbgUsersListDblClick(Sender: TObject);
begin
  Application.CreateForm(TformEditUser, formEditUser);
  formEditUser.formTypeOperation:= doView;
  formEditUser.ShowModal;
  formEditUser.Free;
  formEditSettings.dbgUsersList.Refresh;
end;

procedure TformEditSettings.ToolButton43Click(Sender: TObject);
begin
  Application.CreateForm(TformEditJobPosition, formEditJobPosition);
  formEditJobPosition.formTypeOperation:= doEdit;
  formEditJobPosition.ShowModal;
  formEditJobPosition.Free;
  formEditSettings.dbgAliasJobRoleList.Refresh;
end;

procedure TformEditSettings.ToolButton44Click(Sender: TObject);
begin
  Application.CreateForm(TformEditJobPosition, formEditJobPosition);
  formEditJobPosition.formTypeOperation:= doAdd;
  formEditJobPosition.ShowModal;
  formEditJobPosition.Free;
end;

procedure TformEditSettings.tbRefreshProcessClick(Sender: TObject);
begin
 ShowTemplateProcessList(formEditSettings.dbgProcessList);
end;

procedure TformEditSettings.tbAddProcessClick(Sender: TObject);
var
  tmpConfirmResult: TConfirmResult;
  tmpString: String;
begin
  tmpString:= 'Вы действительно хотите добавить новый процесс?';
  tmpConfirmResult:= ConfirmDlg(tmpString);
  if (tmpConfirmResult = NoResult) or (tmpConfirmResult = CancelResult) then exit;

  
  Application.CreateForm(TformEditProcess, formEditProcess);
  formEditProcess.formTypeOperation:= doAdd;
  formEditProcess.ShowModal;
  formEditProcess.Free;
//  FindPositionInDatasetBy(dmDB.QRoutesList, queryFieldNameForIdRoute, CurrentSpravObject.GetId);
  dbgProcessList.Refresh;
end;

procedure TformEditSettings.tbEditProcessClick(Sender: TObject);
begin
 if IsTemplateProcessInvolvedInDocument(CurrentTemplateProcess.GetId) then
 begin
  MessageBox('Процесс задействован в документах и не может быть изменён!' + #13#10 + 'Можно только запретить для выбора в дальнейшем...', ErrorMessage);
  exit;
 end;

  Application.CreateForm(TformEditProcess, formEditProcess);
  formEditProcess.formTypeOperation:= doEdit;
  formEditProcess.ShowModal;
  formEditProcess.Free;
  dbgProcessList.Refresh;
end;

procedure TformEditSettings.tabsheetRoutesShow(Sender: TObject);
begin
formEditSettings.tbRefreshProcessClick(Sender);
end;

procedure TformEditSettings.tbEditJobItemClick(Sender: TObject);
begin
  Application.CreateForm(TformEditJobTemplate, formEditJobTemplate);
  formEditJobTemplate.formTypeOperation:= doEdit;
  formEditJobTemplate.ShowModal;
  formEditJobTemplate.Free;
  dbgJobItem.Refresh;
end;

procedure TformEditSettings.tbRefreshJobItemsClick(Sender: TObject);
begin
 if not rbForDocumentItem.Checked then
  GetJobItem_TemplateProcessItem_DocumentItem(CurrentTemplateProcessItem.GetId)
 else
  GetJobItem_TemplateProcessItem_Document(CurrentTemplateProcessItem.GetId);
end;

procedure TformEditSettings.tbAddJobItemClick(Sender: TObject);
begin
  Application.CreateForm(TformEditJobTemplate, formEditJobTemplate);
  formEditJobTemplate.formTypeOperation:= doAdd;
  formEditJobTemplate.ShowModal;
  formEditJobTemplate.Free;
  dmDB.dsProcessItemDataChange(Sender, nil);
end;

procedure TformEditSettings.dbgProcessListDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin

With dbgProcessList do
begin
 if DataSource.DataSet.RecNo mod 2 = 1
	then Canvas.Brush.Color:= ColorZebraGrid;

	// Красным выделим не активные маршруты
 if DataSource.DataSet.FieldByName(queryFieldNameForActiveStateOfRoute).AsBoolean
	then Canvas.Brush.Color:= clRed; // Font.Style:= [fsStrikeOut]


	// Восстанавливаем выделение текущей позиции курсора
	if  gdSelected in State
	then Begin
		Canvas.Brush.Color:= clHighLight;
		Canvas.Font.Color := clHighLightText;
	end;
	// Просим GRID перерисоваться самому
	DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;
end;

procedure TformEditSettings.tbDeleteProcessClick(Sender: TObject);
var
  tmpConfirmResult: TConfirmResult;
  curRecordPos: TidDSPositionSaver;
begin
 tmpConfirmResult:= ConfirmDlg('Вы действительно хотите изменить активность процесса?');
 if (tmpConfirmResult = NoResult) or (tmpConfirmResult = CancelResult) then exit;

 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocument);
// SwitchOnOffRoute(dmDB.dsRoutesList.DataSet.FieldByName(queryFieldNameForIdRoute).AsInteger, CurrentUser.GetLoginName);
 tbRefreshProcessClick(Sender);
 DSPositionSaver.RestorePosition(dmDB.QDocument, curRecordPos);

end;

procedure TformEditSettings.cbShowDeactivatedProcessClick(Sender: TObject);
begin
 if (Sender as TCheckBox).Checked then ShowProcessFilter:= ossActiveAndDeleted
                                    else ShowProcessFilter:= ossActiveOnly;
 tbRefreshProcessClick(Sender);
end;

procedure TformEditSettings.ToolButton34Click(Sender: TObject);
var
  tmpConfirmResult: TConfirmResult;
  curRecordPos: TidDSPositionSaver;
begin
 tmpConfirmResult:= ConfirmDlg('Вы действительно хотите удалить пользователя: ' + #13#10 +
                                dmDB.dsUserList.DataSet.fieldByName(queryFieldName_UserLogin).Value +
                                '?');
 if (tmpConfirmResult = NoResult) or (tmpConfirmResult = CancelResult) then exit;

 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QUserList);
 DeleteUser(CurrentUser.GetLoginName, dmDB.dsUserList.DataSet.fieldByName(queryFieldName_UserLogin).Value);
 Execute_SP('sp_GetUserList', dmDB.QUserList);
 DSPositionSaver.RestorePosition(dmDB.QUserList, curRecordPos);
end;

procedure TformEditSettings.rbForDocumentItemClick(Sender: TObject);
begin
 if not rbForDocumentItem.Checked then
  begin
   rbForDocumentItem.Checked:= true;
   rbForDocument.Checked:= not rbForDocumentItem.Checked;
  end;
 GetJobItem_TemplateProcessItem_DocumentItem(CurrentTemplateProcessItem.GetId);
end;

procedure TformEditSettings.rbForDocumentClick(Sender: TObject);
begin
 if not rbForDocument.Checked then
  begin
   rbForDocument.Checked:= true;
   rbForDocumentItem.Checked:= not rbForDocument.Checked;
  end;
 GetJobItem_TemplateProcessItem_Document(CurrentTemplateProcessItem.GetId)

end;

procedure TformEditSettings.FormCreate(Sender: TObject);
begin
 CurrentTemplateProcessItem:= TProcessItem.Create();
 CurrentJobItemTemplate:= TJobItem.Create();
end;

procedure TformEditSettings.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 ShowProcessFilter:= ossActiveOnly;
 if Assigned(CurrentTemplateProcessItem) then CurrentTemplateProcessItem.Free;
 if Assigned(CurrentJobItemTemplate) then CurrentJobItemTemplate.Free;

end;

procedure TformEditSettings.tbRefreshSpravListClick(Sender: TObject);
begin
 GetSpravList();
end;

procedure TformEditSettings.tbRefreshSpravDataClick(Sender: TObject);
begin
 GetSpravData(dmDB.dsSpravList.DataSet.FieldByName(queryFieldName_SpravShortName).AsString, dmDB.QSpravData);
end;

procedure TformEditSettings.ToolButton48Click(Sender: TObject);
var
  tmpConfirmResult: TConfirmResult;
  curRecordPos: TidDSPositionSaver;
begin
 tmpConfirmResult:= ConfirmDlg('Вы действительно хотите исключить Этап Процесса?');
 if (tmpConfirmResult = NoResult) or (tmpConfirmResult = CancelResult) then exit;

 DeleteTemplateProcessItem(CurrentTemplateProcessItem.GetId);
 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QProcessItem);
 tbRefreshProcessClick(Sender);
 DSPositionSaver.RestorePosition(dmDB.QProcessItem, curRecordPos);
 dmDB.dsProcessItemDataChange(Sender, nil);
end;

end.
