unit unEditProcess;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Grids, DBGrids, ImgList, ToolWin, Buttons,
  ExtCtrls,
  unConstant, unVariable;

type
  TformEditProcess = class(TForm)
    ilOrderOperations: TImageList;
    ImageList1: TImageList;
    pnlBotton: TPanel;
    bbSave: TBitBtn;
    bbCancel: TBitBtn;
    PageControl1: TPageControl;
    tsRouteCommonInfo: TTabSheet;
    GroupBox1: TGroupBox;
    lbProcessActivity: TLabel;
    lbOrderType: TLabel;
    stRoutesName: TStaticText;
    edProcessName: TEdit;
    cbProcessIsActive: TCheckBox;
    cbProcessType: TComboBox;
    stSpravOrderTypeFullName: TStaticText;
    gbRoutesItems: TGroupBox;
    ToolBar2: TToolBar;
    tbEditOrdersItem: TToolButton;
    tbAddOrdersItem: TToolButton;
    ToolButton6: TToolButton;
    tbDeleteOrdersItem: TToolButton;
    dbgProcessItem: TDBGrid;
    tsRouteJob: TTabSheet;
    gbJob: TGroupBox;
    Panel1: TPanel;
    cbStandardJob: TCheckBox;
    stStandardJob: TStaticText;
    StaticText1: TStaticText;
    edFullProcessName: TEdit;
    StaticText2: TStaticText;
    edNotes: TEdit;
    procedure DefaultOnChangeActions(Sender: TObject);       //---- Добавлена вручную
    procedure FormShow(Sender: TObject);
    procedure tbEditRouteItemClick(Sender: TObject);
    procedure tbAddOrdersItemClick(Sender: TObject);
    procedure bbSaveClick(Sender: TObject);
    procedure tbEditOrdersItemClick(Sender: TObject);
    procedure bbCancelClick(Sender: TObject);
    procedure cbProcessTypeChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    formTypeOperation: TOperationType;
  end;

var
  formEditProcess: TformEditProcess;

implementation
uses unUtilCommon, unDBUtil, unDM, unEditProcessItem;

{$R *.dfm}

//-------------- Вручную добавленные процедуры и фукции в классах ---------------------------
procedure TformEditProcess.DefaultOnChangeActions(Sender: TObject);
begin
 bbSave.Enabled:= true;
end;
//-------------------------------------------------------------------------------------------

procedure InitializeComboBoxesForThisForm;
begin
 with formEditProcess do
 begin
  Execute_SP('sp_GetSpravDocumentType', dmDB.QComboBox1);
  FillComboBoxFromQuery(cbProcessType, dmDB.QComboBox1, queryFieldName_SpravShortName);
 end;
end;


procedure TformEditProcess.FormShow(Sender: TObject);
var
  i: integer;
begin
 if IsAuthenticationDone() then
 begin

 InitializeComboBoxesForThisForm;

 case formTypeOperation of
  doAdd:
    begin
     cbProcessType.Text:= cbProcessType.Items[0];
     stSpravOrderTypeFullName.Caption:= dmDB.QComboBox1.FieldByName(queryFieldName_SpravFullName).AsString;
     formEditProcess.Caption:= 'Добавление процесса';
     i:= CreateTemplateProcess(edProcessName.Text, edFullProcessName.Text, edNotes.Text);
     if i <= 0 then
     begin
      MessageBox('Ошибка создания процесса.', ErrorMessage);
      exit;
     end
     else CurrentSpravObject.SetCurrent(spravProcessList, i);
     Close;
    end;

  doEdit:
    begin
//     CurrentSpravObject.SetCurrent(spravRoutesList, dmDB.dsRoutesList.Dataset.FieldByName(queryFieldNameForIdRoute).AsInteger);
     if FindRecordInQuery(dmDB.QComboBox1, queryFieldName_SpravOrderType, ord(CurrentSpravObject.getOrderType)) then
      stSpravOrderTypeFullName.Caption:= dmDB.QComboBox1.FieldByName(queryFieldName_SpravFullName).Value;
//     cbSpravOrderType.Text:= ;
     formEditProcess.Caption:= 'Редактирование процесса' + CurrentSpravObject.GetShortName;
     formEditProcess.edProcessName.Text:= CurrentSpravObject.GetShortName;
    end;

 end;
// dmDB.QComboBox1.Close; -- Close QComboBox1 не надо здесь делать - используется до закрытия формы!

// dbgRouteItems.Columns[0].Width:= ;
// dbgRouteItems.Columns[0].Width:= ;

// FillListBoxFromQuery(lbRoutesItems, 'exec sp_GetRoutesItemsByShortName', queryFieldNameForRoutePointName, dbgRoutesList.DataSource.DataSet.Fields.FieldByName('Code').Value);

// ShowRouteItemsList(formEditRoute.dbgRouteItem, dmDB.QRoutesItemsList, CurrentSpravObject.GetCode);

// cbRouteIsActive.Checked:= not dmDB.dsRoutesList.DataSet.FieldByName(queryFieldNameForActiveStateOfRoute).AsBoolean;
 formCurrentActive:= 'formEditRoute';
 bbSave.Enabled:= false;  //---- Начальная установка в дизэйбл - сразу после открытия формы
 end;

end;

procedure TformEditProcess.tbEditRouteItemClick(Sender: TObject);
begin
  Application.CreateForm(TformEditProcessItem, formEditProcessItem);
  formEditProcessItem.formTypeOperation:= doEdit;
  formEditProcessItem.ShowModal;
  formEditProcessItem.Free;
end;

procedure TformEditProcess.tbAddOrdersItemClick(Sender: TObject);
begin
  Application.CreateForm(TformEditProcessItem, formEditProcessItem);
  formEditProcessItem.formTypeOperation:= doAdd;
  formEditProcessItem.ShowModal;
  formEditProcessItem.Free;
  InitializeComboBoxesForThisForm;
  dbgProcessItem.Refresh;
end;

procedure TformEditProcess.bbSaveClick(Sender: TObject);
var
  curRecordPos: TidDSPositionSaver;
  curProcessStatus: TObjectShowStatus;
begin
// curRecordPos:= DSPositionSaver.SavePosition(dmDB.QRoutesList);

 case formEditProcess.formTypeOperation of
  doAdd:
      begin
//       bbSave.Enabled:= not CreateRoute(CurrentUser.GetLoginName, CurrentSpravObject.GetCode, AllTrim(formEditRoute.edRouteName.Text), '');
       case cbProcessIsActive.Checked of
        true: curProcessStatus:= ossActiveOnly;
        false: curProcessStatus:= ossActiveAndDeleted;
       end;
       bbSave.Enabled:= not EditTemplateProcess(CurrentTemplateProcess.GetId, AllTrim(formEditProcess.edProcessName.Text),
                                        '', '', curProcessStatus);  //-- Маршрут нельзя изменить (по крайней мере на данный момент...)!
      end;
  doEdit:
      begin
       case cbProcessIsActive.Checked of
        true: curProcessStatus:= ossActiveOnly;
        false: curProcessStatus:= ossActiveAndDeleted;
       end;
       bbSave.Enabled:= not EditTemplateProcess(CurrentTemplateProcess.GetId, AllTrim(formEditProcess.edProcessName.Text),
                                        '', '', curProcessStatus);  //-- Маршрут нельзя изменить (по крайней мере на данный момент...)!
      end;
 end;

// DSPositionSaver.RestorePosition(dmDB.QRoutesList, curRecordPos);
end;

procedure TformEditProcess.tbEditOrdersItemClick(Sender: TObject);
begin
 if IsTemplateProcessInvolvedInDocument(CurrentSpravObject.GetCode) then
 begin
  MessageBox('Маршрут задействован в заявках и не может быть изменён!', ErrorMessage);
  exit;
 end;

 Application.CreateForm(TformEditProcessItem, formEditProcessItem);
 formEditProcessItem.formTypeOperation:= doEdit;
 formEditProcessItem.ShowModal;
 formEditProcessItem.Free;
 InitializeComboBoxesForThisForm;
 dbgProcessItem.Refresh;
end;

procedure TformEditProcess.bbCancelClick(Sender: TObject);
begin
 if formEditProcess.formTypeOperation = doAdd then
 begin
  DeleteTemplateProcess(CurrentSpravObject.GetId);
 end;
end;

procedure TformEditProcess.cbProcessTypeChange(Sender: TObject);
begin
 bbSave.Enabled:= true;
 if FindRecordInQuery(dmDB.QComboBox1, queryFieldName_SpravShortName, cbProcessType.Text) then
   stSpravOrderTypeFullName.Caption:= dmDB.QComboBox1.FieldByName(queryFieldName_SpravFullName).AsString
 else
   stSpravOrderTypeFullName.Caption:= '...';
end;

end.
