unit unEditJobTemplate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  unConstant, unVariable, StdCtrls, Buttons, ExtCtrls, ComCtrls, ImgList,
  ToolWin, Grids, DBGrids;

type
  TformEditJobTemplate = class(TForm)
    pnlBotton: TPanel;
    bbSave: TBitBtn;
    bbCancel: TBitBtn;
    GroupBox1: TGroupBox;
    pnlTopText: TPanel;
    Panel1: TPanel;
    Label3: TLabel;
    Edit1: TEdit;
    updnJobItemLevel: TUpDown;
    Label6: TLabel;
    cbJobItem: TComboBox;
    cbActiveStatus: TCheckBox;
    cbDoneStatus: TCheckBox;
    cbEddStatus: TCheckBox;
    cbEntireDocumentStatus: TCheckBox;
    Label2: TLabel;
    memoNotes: TMemo;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label5: TLabel;
    cbDataType: TComboBox;
    Label4: TLabel;
    cbDataSource: TComboBox;
    TabSheet2: TTabSheet;
    DBGrid1: TDBGrid;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    ToolBar4: TToolBar;
    tbRefreshJobItemResolution: TToolButton;
    ToolButton24: TToolButton;
    tbEditJobItemResolution: TToolButton;
    tbAddJobItemResolution: TToolButton;
    ToolButton27: TToolButton;
    tbDeleteJobItemResolution: TToolButton;
    ToolButton49: TToolButton;
    ilObjectExplorer: TImageList;
    cbDetermineResolutionStatus: TCheckBox;
    Panel2: TPanel;
    dbgrDataSource: TDBGrid;
    procedure DefaultOnChangeActions(Sender: TObject);
    procedure bbSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbDataTypeChange(Sender: TObject);       //---- Добавлена вручную
  private
    { Private declarations }
   bDoneResolutionChanged, bNotesChanged: boolean;
  public
    { Public declarations }
    formTypeOperation: TOperationType;
  end;

var
  formEditJobTemplate: TformEditJobTemplate;

implementation
uses unDM, unDBUtil, unUtilCommon, unEditSettings;
{$R *.dfm}
//-------------- Вручную добавленные процедуры и фукции в классах ---------------------------
procedure TformEditJobTemplate.DefaultOnChangeActions(Sender: TObject);
begin
 bbSave.Enabled:= true;
end;
//-------------------------------------------------------------------------------------------

procedure InitializeComboBoxesForThisForm;
begin
 with formEditJobTemplate do
 begin
  Execute_SP('sp_GetSpravJobItem', dmDB.QComboBox1);
  FillComboBoxFromQuery(cbJobItem, dmDB.QComboBox1, queryFieldName_SpravShortName);

  Execute_SP('sp_GetSpravDataType', dmDB.QComboBox2);
  FillComboBoxFromQuery(cbDataType, dmDB.QComboBox2, queryFieldName_SpravShortName);

  if FindRecordInQuery(dmDB.QComboBox2, queryFieldName_SpravShortName, cbJobItem.Text) then
   Execute_SP('sp_GetSpravDataSource_ForDataType', dmDB.QComboBox3, dmDB.QComboBox2.FieldByName(queryFieldName_DataTypeJobItem).AsInteger)
  else
   Execute_SP('sp_GetSpravDataSource_ForDataType', dmDB.QComboBox3);
//  FillComboBoxFromQuery(cbDataSource, dmDB.QComboBox3, queryFieldName_SpravShortName);
  dbgrDataSource.DataSource:= dmDB.dsComboBox3;

 end;
end;



procedure TformEditJobTemplate.bbSaveClick(Sender: TObject);
var
  curRecordPos: TidDSPositionSaver;
  curProcessStatus: TObjectShowStatus;
  idJobItem, idCreatedTemplateJobItem: TId;
begin
 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QJobItem);
 case formTypeOperation of
  doAdd:
      begin
       if FindRecordInQuery(dmDB.QComboBox1, queryFieldName_SpravShortName, cbJobItem.Text) then
        idJobItem:= dmDB.QComboBox1.FieldByName(queryFieldName_JobItemId).AsInteger
       else
       begin
        MessageBox('Элемент Работы Этапа Процесса не определен по названию!' +  #13#10 + 'Сохранение не произведено', ErrorMessage);
        exit;
       end;

//       if not bDoneResolutionChanged then memoDoneResolution.Text:= '';
       if not bNotesChanged  then memoNotes.Text:= '';

       idCreatedTemplateJobItem:= CreateTemplateJobItem(CurrentTemplateProcessItem.GetId,
                                                       updnJobItemLevel.Position,
                                                       idJobItem,
                                                       cbActiveStatus.Checked,
                                                       cbEntireDocumentStatus.Checked,
                                                       cbEddStatus.Checked,
                                                       0, {DoneCondition}
                                                       0, {DoneResolution}
                                                       0, {ConditionDependence}
                                                       '', //AllTrim(memoDoneResolution.Text),
                                                       AllTrim(memoNotes.Text),
                                                       cbDoneStatus.Checked);
        if idCreatedTemplateJobItem = -1 then   MessageBox('Добавление элемента работы завершилось с ошибкой.', ErrorMessage);
      end;
  doEdit:
      begin
       idCreatedTemplateJobItem:= EditTemplateJobItem(dmDB.dsJobItem.DataSet.FieldByName(queryFieldName_JobItemId).AsInteger,
                                                       dmDB.dsProcessItem.DataSet.FieldByName(queryFieldName_ProcessItemId).AsInteger,
                                                       updnJobItemLevel.Position,
                                                       idJobItem,
                                                       cbActiveStatus.Checked,
                                                       cbEntireDocumentStatus.Checked,
                                                       cbEddStatus.Checked,
                                                       0, {DoneCondition}
                                                       0, {DoneResolution}
                                                       0, {ConditionDependence}
                                                       '', //AllTrim(memoDoneResolution.Text),
                                                       AllTrim(memoNotes.Text),
                                                       cbDoneStatus.Checked);
        if idCreatedTemplateJobItem = -1 then   MessageBox('Изменение элемента работы завершилось с ошибкой.', ErrorMessage);
      end;
 end;

 DSPositionSaver.RestorePosition(dmDB.QJobItem, curRecordPos);
end;

procedure TformEditJobTemplate.FormShow(Sender: TObject);
var
  i: TId;
begin
 InitializeComboBoxesForThisForm;
 case formTypeOperation of
  doAdd:
    begin
     cbJobItem.Text:= cbJobItem.Items[0];
     formEditJobTemplate.Caption:= 'Добавление Элемента Работы';
     bDoneResolutionChanged:= false;
     bNotesChanged:= false;
     updnJobItemLevel.Position:= GetTemplateJobItemLevelNext(CurrentTemplateProcessItem.GetId);
    end;

  doEdit:
    begin
     if FindRecordInQuery(dmDB.QComboBox1, queryFieldName_SpravShortName, CurrentJobItemTemplate.GetJobItemIdSprav) then
//      stSpravOrderTypeFullName.Caption:= dmDB.QComboBox1.FieldByName(queryFieldName_SpravFullName).Value;
     formEditJobTemplate.Caption:= 'Редактирование Элемента Работы'; // + CurrentSpravObject.GetShortName;
//     formEditJobTemplate.edProcessName.Text:= CurrentSpravObject.GetShortName;
     updnJobItemLevel.Position:= CurrentJobItemTemplate.GetItemLevel;
     cbActiveStatus.Checked:= CurrentJobItemTemplate.GetActiveStatus;
     cbDoneStatus.Checked:= CurrentJobItemTemplate.GetDoneStatus;
     cbEDDStatus.Checked:= CurrentJobItemTemplate.GetEDDStatus;
     cbEntireDocumentStatus.Checked:= CurrentJobItemTemplate.GetEDDStatus;
    end;

 end;
 pnlTopText.Caption:= ' для Этапа Процесса № ' + IntToStr(CurrentTemplateProcessItem.GetId) + '( ' + CurrentTemplateProcessItem.GetName + ')';
 formCurrentActive:= 'formEditJobTemplate';
 bbSave.Enabled:= false;  //---- Начальная установка в дизэйбл - сразу после открытия формы
end;

procedure TformEditJobTemplate.cbDataTypeChange(Sender: TObject);
begin
  if FindRecordInQuery(dmDB.QComboBox2, queryFieldName_SpravShortName, cbJobItem.Text) then
   Execute_SP('sp_GetSpravDataSource_ForDataType', dmDB.QComboBox3, dmDB.QComboBox2.FieldByName(queryFieldName_DataTypeJobItem).AsInteger);

  FillComboBoxFromQuery(cbDataSource, dmDB.QComboBox3, queryFieldName_SpravShortName);
end;

end.
