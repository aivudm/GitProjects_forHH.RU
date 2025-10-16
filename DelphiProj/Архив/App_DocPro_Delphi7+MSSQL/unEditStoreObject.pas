unit unEditStoreObject;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  unConstant, unVariable;
type
  TformEditStoreObject = class(TForm)
    Splitter1: TSplitter;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lb: TLabel;
    Label2: TLabel;
    edObjectName: TEdit;
    edObjectVolume: TEdit;
    cbMeasurementUnit: TComboBox;
    memNotes: TMemo;
    pnlBottomForm: TPanel;
    bbSave: TBitBtn;
    bbCancel: TBitBtn;
    GroupBox2: TGroupBox;
    cbStoreObjectParentLink: TComboBox;
    lbOrderOpen: TLabel;
    dtpStoreObjectCreationDate: TDateTimePicker;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    cbStoreObjectGroup: TComboBox;
    edStoreObjectShortName: TEdit;
    edStoreObjectVolume: TEdit;
    cbStoreMeasurementUnit: TComboBox;
    memStoreNotes: TMemo;
    Panel1: TPanel;
    sbCopyOrderDataToStoreData: TSpeedButton;
    Label10: TLabel;
    edFIO: TEdit;
    cbObjectGroup: TComboBox;
    edStoreObjectFullName: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    procedure DefaultOnChangeActions(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bbSaveClick(Sender: TObject);
    procedure sbCopyOrderDataToStoreDataClick(Sender: TObject);
    procedure cbStoreObjectParentLinkChange(Sender: TObject);       //---- Добавлена вручную

  private
    { Private declarations }
  public
    { Public declarations }
    formTypeOperation: TOperationType;
  end;

var
  formEditStoreObject: TformEditStoreObject;

implementation
uses unUtilCommon, unDM, unDBUtil;

{$R *.dfm}
//-------------- Вручную добавленные процедуры и фукции в классах ---------------------------
procedure TformEditStoreObject.DefaultOnChangeActions(Sender: TObject);
begin
 bbSave.Enabled:= true;
end;
//-------------------------------------------------------------------------------------------




procedure TformEditStoreObject.FormShow(Sender: TObject);
begin
 if IsAuthenticationDone() then
 begin
  Execute_SP('sp_GetSpravStoreObjectParentLink', dmDB.QComboBox1);
  FillComboBoxFromQuery(cbStoreObjectParentLink, dmDB.QComboBox1, 'ShortName');

  Execute_SP('sp_GetSpravObjectGroup_MTR', dmDB.QComboBox1);
  FillComboBoxFromQuery(cbObjectGroup, dmDB.QComboBox1, 'ShortName');
  FillComboBoxFromQuery(cbStoreObjectGroup, dmDB.QComboBox1, 'ShortName');

  cbStoreObjectParentLink.Text:= cbStoreObjectParentLink.Items[0];

  dmDB.QComboBox2.Close;
  Execute_SP('sp_GetSpravMeasurementUnit', dmDB.QComboBox2);
  FillComboBoxFromQuery(cbStoreMeasurementUnit, dmDB.QComboBox2, 'ShortName');
  cbMeasurementUnit.Text:= cbStoreMeasurementUnit.Items[0];
  dtpStoreObjectCreationDate.Date:= CurrentDocument.CreationDate;

 case formTypeOperation of
  doAdd:
    begin
     formEditStoreObject.Caption:= 'Добавление позиции на склад';
     dtpStoreObjectCreationDate.Date:= Date;

     edFIO.Text:= GetUserFullNameByLogin(CurrentDocumentItem.CreatorOwner);
     cbObjectGroup.Text:= CurrentDocumentItem.ObjectsGroup;
     edObjectName.Text:= CurrentDocumentItem.ShortName;
     edObjectVolume.Text:= IntToStr(CurrentDocumentItem.Volume);
     cbMeasurementUnit.Text:= CurrentDocumentItem.MeasurementUnit;
     memNotes.Text:= CurrentDocumentItem.Notes;

     cbStoreObjectGroup.Text:= '';
     edStoreObjectShortName.Text:= '';
     edStoreObjectFullName.Text:= '';
     edStoreObjectVolume.Text:= '';
     cbStoreMeasurementUnit.Text:= '';
     memNotes.Text:= '';

     cbStoreObjectParentLink.ItemIndex:= 2;
     cbStoreObjectParentLinkChange(Sender);
    end;

  doEdit:
    begin
    end;

  doView:
    begin
    end;
 end;

 end;
 bbSave.Enabled:= false;
end;

procedure TformEditStoreObject.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  dmDB.QComboBox1.Close;
  dmDB.QComboBox2.Close;
end;

procedure TformEditStoreObject.bbSaveClick(Sender: TObject);
var
  idDocument, idDocumentItem, i: integer;
  idStoreObjectParentLink: TidStoreObjectParentLink;
  idMeasurementsUnit: TIdMeasurementUnit;
  idStoreObjectGroup: TIdStoreObjectGroup;
begin

 Execute_SP('sp_GetSpravStoreObjectParentLink', dmDB.QComboBox1);
 if FindRecordInQuery(dmDB.QComboBox1, 'ShortName', cbStoreObjectParentLink.Text) then
  idStoreObjectParentLink:= dmDB.QComboBox1.FieldByName('id').AsInteger
 else
 begin
  MessageBox('Код типа привязки объекта склада к заявкам не определён по названию!' +  #13#10 + 'Сохранение не произведено', ErrorMessage);
  exit;
 end;

 Execute_SP('sp_GetSpravObjectGroup_MTR', dmDB.QComboBox2);
 if FindRecordInQuery(dmDB.QComboBox2, 'ShortName', cbStoreObjectGroup.Text) then
  idStoreObjectGroup:= dmDB.QComboBox2.FieldByName('id').AsInteger
 else
 begin
  MessageBox('Код группы объекта не определён по названию!' +  #13#10 + 'Сохранение не произведено', ErrorMessage);
  exit;
 end;

 Execute_SP('sp_GetSpravMeasurementUnit', dmDB.QComboBox2);
 if FindRecordInQuery(dmDB.QComboBox2, 'ShortName', cbStoreMeasurementUnit.Text) then
  idMeasurementsUnit:= dmDB.QComboBox2.FieldByName('id').AsInteger
 else
 begin
  MessageBox('Код группы объекта не определён по названию!' +  #13#10 + 'Сохранение не произведено', ErrorMessage);
  exit;
 end;

 case cbStoreObjectParentLink.ItemIndex of
  0:
    begin
     idDocument:= 0;
     idDocumentItem:= 0;
    end;

  1:
    begin
     IdDocument:= CurrentDocument.IdDocument;
     IdDocumentItem:= 0;
    end;

  2:
    begin
     IdDocument:= CurrentDocument.IdDocument;
     IdDocumentItem:= CurrentDocumentItem.Id;
 end;
end;

 with formEditStoreObject do
 begin
  case formTypeOperation of
   doAdd:
       begin
        bbSave.Enabled:= not CreateStoreObject(IdDocument, IdDocumentItem, idStoreObjectGroup, edStoreObjectShortName.Text, edStoreObjectFullName.Text, edObjectVolume.Text,
                                               idMeasurementsUnit, memNotes.Text, dtpStoreObjectCreationDate.DateTime);
       end;
   doEdit:
       begin
//        bbSave.Enabled:= not EditStoreObject(CurrentOrder.IdDocument, CurrentOrder.IdSelectedItem, CurrentUser.GetLoginName, idStoreObjectParentLink, edObjectName.Text, edObjectVolume.Text,
//                                                  idMeasurementsUnit, memNotes.Text, dtpStoreObjectCreationDate.DateTime);
       end;
  end;
 end;

end;

procedure TformEditStoreObject.sbCopyOrderDataToStoreDataClick(Sender: TObject);
begin
 cbStoreObjectGroup.Text:= cbObjectGroup.Text;
 edStoreObjectShortName.Text:= edObjectName.Text;
 edStoreObjectVolume.Text:= edObjectVolume.Text;
 cbStoreMeasurementUnit.Text:= cbMeasurementUnit.Text;
end;

procedure TformEditStoreObject.cbStoreObjectParentLinkChange(
  Sender: TObject);
begin
 case cbStoreObjectParentLink.ItemIndex of
  0, 1:
    begin
     edFIO.Visible:= false;
     cbObjectGroup.Visible:= false;
     edObjectName.Visible:= false;
     edObjectVolume.Visible:= false;
     cbMeasurementUnit.Visible:= false;
     memNotes.Visible:= false;
     sbCopyOrderDataToStoreData.Visible:= false;

     cbStoreObjectGroup.Text:= '';
     edStoreObjectShortName.Text:= '';
     edStoreObjectFullName.Text:= '';
     edStoreObjectVolume.Text:= '';
     cbStoreMeasurementUnit.Text:= '';
     memNotes.Text:= '';
    end;

  2:
    begin
     edFIO.Visible:= true;
     cbObjectGroup.Visible:= true;
     edObjectName.Visible:= true;
     edObjectVolume.Visible:= true;
     cbMeasurementUnit.Visible:= true;
     memNotes.Visible:= true;
     sbCopyOrderDataToStoreData.Visible:= true;

     edFIO.Text:= GetUserFullNameByLogin(CurrentDocumentItem.CreatorOwner);
     cbObjectGroup.Text:= CurrentDocumentItem.ObjectsGroup;
     edObjectName.Text:= CurrentDocumentItem.ShortName;
     edObjectVolume.Text:= IntToStr(CurrentDocumentItem.Volume);
     cbMeasurementUnit.Text:= CurrentDocumentItem.MeasurementUnit;
     memNotes.Text:= CurrentDocumentItem.Notes;
    end;
 end;
end;

end.

