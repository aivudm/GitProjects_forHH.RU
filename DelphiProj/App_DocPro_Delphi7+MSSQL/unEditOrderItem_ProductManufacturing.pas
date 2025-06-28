unit unEditOrderItem_ProductManufacturing;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  unConstant, unVariable;

type
  TformEditOrderItem_ProductManufacturing = class(TForm)
    Splitter1: TSplitter;
    GroupBox1: TGroupBox;
    lbFIO: TLabel;
    lbOrderOpen: TLabel;
    Label6: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lb: TLabel;
    Label2: TLabel;
    edFIO: TEdit;
    dtpOrderItemsCreationDate: TDateTimePicker;
    dtpOrderItemsExecutionDate: TDateTimePicker;
    edObjectName: TEdit;
    edObjectVolume: TEdit;
    cbMeasurementsUnits: TComboBox;
    memNotes: TMemo;
    cbAddAttachment: TCheckBox;
    gbAttachements: TGroupBox;
    sbAddAttachment: TSpeedButton;
    sbDeleteAttachment: TSpeedButton;
    sbRenameAttachment: TSpeedButton;
    pnlAttachmentList: TPanel;
    lbAttachments: TListBox;
    pnlBottomForm: TPanel;
    bbSave: TBitBtn;
    bbCancel: TBitBtn;
    opdAddFile: TOpenPictureDialog;
    edObjectIdentificator: TEdit;
    bbSelectObjectManufacture: TBitBtn;
    procedure DefaultOnChangeActions(Sender: TObject);       //---- Добавлена вручную
    procedure bbSelectObjectManufactureClick(Sender: TObject);
    procedure bbSaveClick(Sender: TObject);
    procedure edObjectVolumeKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    formTypeOperation: TOperationType;
  end;

var
  formEditOrderItem_ProductManufacturing: TformEditOrderItem_ProductManufacturing;

implementation
uses unUtilCommon, unDBUtil, unDM, unSelectObjectManufacture;

{$R *.dfm}
//-------------- Вручную добавленные процедуры и фукции в классах ---------------------------
procedure TformEditOrderItem_ProductManufacturing.DefaultOnChangeActions(Sender: TObject);
begin
 bbSave.Enabled:= true;
end;
//-------------------------------------------------------------------------------------------

procedure TformEditOrderItem_ProductManufacturing.bbSelectObjectManufactureClick(
  Sender: TObject);
begin
  Application.CreateForm(TformSelectObjectManufacture, formSelectObjectManufacture);
  formSelectObjectManufacture.ShowModal;
  formSelectObjectManufacture.Free;
  edObjectIdentificator.Text:= CurrentSpravObject.GetShortName;
  edObjectName.Text:= CurrentSpravObject.GetFullName;
  cbMeasurementsUnits.Text:= CurrentSpravObject.GetMeasurmentUnitShortName;
  SetButtonState_DocumentMTR;
end;

procedure TformEditOrderItem_ProductManufacturing.bbSaveClick(Sender: TObject);
var
  curRecordPos, curRecordPos1: TidDSPositionSaver;
  i: integer;
  idMeasurementsUnit: TIdMeasurementUnit;
begin
 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocument);
 curRecordPos1:= DSPositionSaver.SavePosition(dmDB.QDocumentItem);

 Execute_SP('sp_GetSpravMeasurementUnit', dmDB.QComboBox2);
 if FindRecordInQuery(dmDB.QComboBox2, queryFieldName_SpravShortName, cbMeasurementsUnits.Text) then
  idMeasurementsUnit:= dmDB.QComboBox2.FieldByName(queryFieldName_SpravId).AsInteger
 else
 begin
  MessageBox('Код группы объекта не определён по названию!' +  #13#10 + 'Сохранение не произведено', ErrorMessage);
  exit;
 end;

 with formEditOrderItem_ProductManufacturing do
 begin
  case formTypeOperation of
   doAdd:
       begin
        i:= CreateOrdersItem_ProductManufacturing(CurrentDocument.IdDocument, CurrentUser.GetLoginName, CurrentSpravObject.GetId, StrToInt(Alltrim(edObjectVolume.Text)), memNotes.Text, dtpOrderItemsExecutionDate.DateTime);
        if (i > 0) then
        begin
         bbSave.Enabled:= true;
         CurrentDocument.IdSelectedItem:= i;
        end;
        if bbSave.Enabled then
        for i:= 1 to lbAttachments.Items.Count do
         case CurrentDocumentItem.Attachments.GetAttachmentState(i) of
          asNew: bbSave.Enabled:= not (bbSave.Enabled and DocumentItem_AddAttachment(CurrentDocument.IdSelectedItem, CurrentUser.GetLoginName, lbAttachments.Items.Strings[i-1]));
          asRenamed: bbSave.Enabled:= not (bbSave.Enabled and RenameAttachmentForOrderItem(CurrentDocument.IdDocument, CurrentDocument.IdSelectedItem, CurrentUser.GetLoginName, lbAttachments.Items.Strings[i-1], CurrentDocumentItem.Attachments.GetAttachmentId(i)));
          asDeleted: bbSave.Enabled:= not (bbSave.Enabled and DeleteAttachmentForOrderItem(CurrentDocument.IdDocument, CurrentDocument.IdSelectedItem, CurrentUser.GetLoginName, lbAttachments.Items.Strings[i-1], CurrentDocumentItem.Attachments.GetAttachmentId(i)));
         end;

       end;
   doEdit:
       begin
//        bbSave.Enabled:= not EditOrdersItem_ProductManufacturing(CurrentOrder.IdDocument, CurrentOrder.IdSelectedItem, CurrentUser.GetLoginName, idObjectsGroup, edObjectName.Text, edObjectVolume.Text,
//                                                  idMeasurementsUnit, memNotes.Text, dtpOrderItemsExecutionDate.DateTime);
        for i:= 1 to lbAttachments.Items.Count do
         case CurrentDocumentItem.Attachments.GetAttachmentState(i) of
          asNew: bbSave.Enabled:= not (bbSave.Enabled and DocumentItem_AddAttachment(CurrentDocument.IdSelectedItem, CurrentUser.GetLoginName, lbAttachments.Items.Strings[i-1]));
          asRenamed: bbSave.Enabled:= not (bbSave.Enabled and RenameAttachmentForOrderItem(CurrentDocument.IdDocument, CurrentDocument.IdSelectedItem, CurrentUser.GetLoginName, lbAttachments.Items.Strings[i-1], CurrentDocumentItem.Attachments.GetAttachmentId(i)));
          asDeleted: bbSave.Enabled:= not (bbSave.Enabled and DeleteAttachmentForOrderItem(CurrentDocument.IdDocument, CurrentDocument.IdSelectedItem, CurrentUser.GetLoginName, lbAttachments.Items.Strings[i-1], CurrentDocumentItem.Attachments.GetAttachmentId(i)));
         end;
       end;
  end;
 end;

 ShowDocumentItem_Document(CurrentDocument.IdDocument);
 DSPositionSaver.RestorePosition(dmDB.QDocument, curRecordPos);
 DSPositionSaver.RestorePosition(dmDB.QDocumentItem, curRecordPos1);
end;

procedure TformEditOrderItem_ProductManufacturing.edObjectVolumeKeyPress(
  Sender: TObject; var Key: Char);
begin
 SetTextAsInteger(Sender, Char(Key));
 inherited;
end;

end.
