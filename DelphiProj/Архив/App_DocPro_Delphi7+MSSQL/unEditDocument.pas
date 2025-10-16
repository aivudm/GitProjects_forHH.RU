unit unEditDocument;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, DBCtrls, ComCtrls, Buttons,
  CheckLst, Grids, DBGrids, ExtCtrls,
  unConstant, unVariable, ExtDlgs, jpeg;

type
  TformEditDocument = class(TForm)
    gbRoutesInfo: TGroupBox;
    gbRoutesList: TGroupBox;
    dbgRoutesList: TDBGrid;
    gbRoutesItems: TGroupBox;
    lbRoutesItems: TListBox;
    pnlCaption: TPanel;
    gbCommonOrderInfo: TGroupBox;
    lbFIO: TLabel;
    edFIO: TEdit;
    dtpDocumentCreationDate: TDateTimePicker;
    Label6: TLabel;
    dtpDocumentExecutionDate: TDateTimePicker;
    Label2: TLabel;
    Label1: TLabel;
    memNotes: TMemo;
    Splitter1: TSplitter;
    Panel2: TPanel;
    cbUseDefaultRoute: TCheckBox;
    Splitter2: TSplitter;
    pnlBotton: TPanel;
    bbSave: TBitBtn;
    bbCancel: TBitBtn;
    Splitter3: TSplitter;
    Label3: TLabel;
    cbDocumentType: TComboBox;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    edDocumentShortName: TEdit;
    procedure DefaultOnChangeActions(Sender: TObject);       //---- Добавлена вручную
    procedure bbSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edVolumeMTSKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dtpDocumentCreationDateChange(Sender: TObject);
    procedure cbUseDefaultRouteClick(Sender: TObject);
    procedure memNotesChange(Sender: TObject);
    procedure edDocumentShortNameChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    formTypeOperation: TOperationType;
  end;

var
  formEditDocument: TformEditDocument;

implementation
uses unUtilCommon, unDBUtil, unDM;

{$R *.dfm}

//-------------- Вручную добавленные процедуры и фукции в классах ---------------------------
procedure TformEditDocument.DefaultOnChangeActions(Sender: TObject);
begin
 bbSave.Enabled:= true;
end;
//-------------------------------------------------------------------------------------------

procedure TformEditDocument.bbSaveClick(Sender: TObject);
var
  DocumentType: TDocumentType;
begin
 case formEditDocument.formTypeOperation of
  doAdd:
      begin
       Execute_SP('sp_GetSpravDocumentType', dmDB.QComboBox1);
       if FindRecordInQuery(dmDB.QComboBox1, queryFieldName_SpravShortName, cbDocumentType.Text) then
        DocumentType:= dmDB.QComboBox1.FieldByName(queryFieldName_SpravId).Value
      else
       begin
        MessageBox('Тип документа не определено по названию!' +  #13#10 + 'Сохранение не произведено', ErrorMessage);
        exit;
       end;

       bbSave.Enabled:= not CreateDocument(DocumentType, formEditDocument.dtpDocumentExecutionDate.DateTime,
                                            edDocumentShortName.Text, memNotes.Text);
      end;
  doEdit:
      begin
       bbSave.Enabled:= not EditDocument(CurrentDocument.IdDocument, formEditDocument.dtpDocumentExecutionDate.DateTime,
                                         edDocumentShortName.Text, memNotes.Text, CurrentDocument.GetDocumentNum);
      end;
 end;

 RefreshDocument;
end;

procedure TformEditDocument.FormShow(Sender: TObject);
begin
 if IsAuthenticationDone() then
 begin

 dbgRoutesList.Columns[0].Width:= dbgRoutesList.Width;

 Execute_SP('sp_GetSpravDocumentType', dmDB.QComboBox1);
 FindRecordInQuery(dmDB.QComboBox1, queryFieldName_SpravShortName, 'Изготовление');
 FillComboBoxFromQuery(cbDocumentType, dmDB.QComboBox1, queryFieldName_SpravShortName);
 Execute_SP('sp_GetSpravJobRole', dmDB.QComboBox1);
 cbDocumentType.Text:= cbDocumentType.Items[0];

 edFIO.Text:= CurrentUser.GetFullName;
 dmDB.dsProcessList.OnDataChange:= nil;

 case formTypeOperation of
  doAdd:
    begin
     formEditDocument.Caption:= 'Добавление документа';
     dtpDocumentCreationDate.Date:= Date();
     dtpDocumentExecutionDate.Date:= Date() + 14;
     edFIO.Text:= CurrentUser.GetFullName;
     if CurrentUser.GetDefaultRoute <> 0 then
     begin
      cbUseDefaultRoute.Checked:= true;
     end;
    end;

  doEdit:
    begin
     formEditDocument.Caption:= 'Редактирование документа № ' + IntToStr(CurrentDocument.IdDocument);
     pnlCaption.Caption:= formEditDocument.Caption;
     edFIO.Text:= CurrentDocument.CreatorOwner;
     cbDocumentType.Enabled:= false;
     dtpDocumentCreationDate.Date:= CurrentDocument.CreationDate;
     dtpDocumentExecutionDate.Date:= CurrentDocument.ExecutionDate;
     memNotes.Text:= CurrentDocument.Notes;
     edDocumentShortName.Text:= CurrentDocument.GetDocumentShortName;
    end;

  doView:
    begin
     formEditDocument.Caption:= 'Просмотр документа № ' + IntToStr(CurrentDocument.IdDocument);
     pnlCaption.Caption:= formEditDocument.Caption;
     edFIO.Text:= CurrentDocument.CreatorOwner;
     cbDocumentType.Enabled:= false;
     dtpDocumentCreationDate.Date:= CurrentDocument.CreationDate;
     dtpDocumentCreationDate.Enabled:= false;
     dtpDocumentExecutionDate.Date:= CurrentDocument.ExecutionDate;
     dtpDocumentExecutionDate.Enabled:= false;
     memNotes.Text:= CurrentDocument.Notes;
     memNotes.ReadOnly:= true;
     edDocumentShortName.Text:= CurrentDocument.GetDocumentShortName;
     edDocumentShortName.ReadOnly:= true;
     cbUseDefaultRoute.Visible:= false;
    end;
 end;


 formCurrentActive:= 'formEditOrder';
 formEditDocument.Height:= formEditDocument.Height - formEditDocument.Panel2.Height - formEditDocument.gbRoutesInfo.Height;
 bbSave.Enabled:= false;  //---- Начальная установка в дизэйбл - сразу после открытия формы
 end;

end;

procedure TformEditDocument.edVolumeMTSKeyPress(Sender: TObject;
  var Key: Char);
begin
 SetTextAsReal(Sender, Key);
end;

procedure TformEditDocument.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  dmDB.QCommon.Close;
end;

procedure TformEditDocument.dtpDocumentCreationDateChange(Sender: TObject);
begin
 if (dtpDocumentCreationDate.Date < dtpDocumentExecutionDate.Date) then
     dtpDocumentExecutionDate.Date:= dtpDocumentCreationDate.Date + 14;

 DefaultOnChangeActions(Sender);
end;

procedure TformEditDocument.cbUseDefaultRouteClick(Sender: TObject);
begin
 bUseDefaultRouteForCurrentInitiator:= (Sender as TCheckBox).Checked;
 dbgRoutesList.Enabled:= not bUseDefaultRouteForCurrentInitiator;
 lbRoutesItems.Enabled:= not bUseDefaultRouteForCurrentInitiator;
end;

procedure TformEditDocument.memNotesChange(Sender: TObject);
begin

 DefaultOnChangeActions(Sender);
end;

procedure TformEditDocument.edDocumentShortNameChange(Sender: TObject);
begin
 DefaultOnChangeActions(Sender);
end;

end.
