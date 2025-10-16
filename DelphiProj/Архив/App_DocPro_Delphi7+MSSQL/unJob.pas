unit unJob;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, ImgList, Buttons,
  unConstant, unVariable, ToolWin, Grids, DBGrids, CheckLst;

type
  TformJob = class(TForm)
    pcontJobList: TPageControl;
    StatusBar1: TStatusBar;
    tsheetJob1: TTabSheet;
    ilOrderItemOperations: TImageList;
    Panel2: TPanel;
    gbResolution: TGroupBox;
    pnlJob: TPanel;
    pcontResolution: TPageControl;
    tshFreeText: TTabSheet;
    tshTemplatedText: TTabSheet;
    mResolutionText: TMemo;
    ListBox1: TListBox;
    gbJob1: TGroupBox;
    stJobNotes: TStaticText;
    Panel1: TPanel;
    gbEDD: TGroupBox;
    rbConfirm: TRadioButton;
    rbDeny: TRadioButton;
    rbAltering: TRadioButton;
    Panel3: TPanel;
    bbCancel: TBitBtn;
    bbSave: TBitBtn;
    CheckListBox1: TCheckListBox;
    Panel6: TPanel;
    gbJobItemExtend: TGroupBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel5: TPanel;
    dbgrDataSource: TDBGrid;
    TabSheet2: TTabSheet;
    DBGrid1: TDBGrid;
    ToolBar4: TToolBar;
    tbRefreshJobItemResolution: TToolButton;
    ToolButton24: TToolButton;
    tbEditJobItemResolution: TToolButton;
    tbAddJobItemResolution: TToolButton;
    ToolButton27: TToolButton;
    tbDeleteJobItemResolution: TToolButton;
    ToolButton49: TToolButton;
    cbDetermineResolutionStatus: TCheckBox;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Panel4: TPanel;
    Label5: TLabel;
    cbDataType: TComboBox;
    Label4: TLabel;
    cbDataSource: TComboBox;
    TabSheet5: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure rbConfirmClick(Sender: TObject);
    procedure rbDenyClick(Sender: TObject);
    procedure rbAlteringClick(Sender: TObject);
    procedure mResolutionTextKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure bbSaveClick(Sender: TObject);
    procedure mResolutionTextChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formJob: TformJob;
  IsResolutionChanged: boolean;

implementation
uses unUtilCommon, unDM, unDBUtil, unUtilAction, unResolutionForItemWriter;

{$R *.dfm}

procedure TformJob.FormCreate(Sender: TObject);
begin
 IsResolutionChanged:= false;
 tshTemplatedText.TabVisible:= false;

{
 case CurrentActiveObject of
  aoDocument:
   begin
    rbConfirm.Enabled:= bConfirmDocument_Action;
    rbDeny.Enabled:= bDenyDocument_Action;
    rbAltering.Enabled:= bAlteringDocument_Action;
   end;
  aoDocumentItem:
   begin
    rbConfirm.Enabled:= bConfirmOrderItem_Action;
    rbDeny.Enabled:= bDenyOrderItem_Action;
    rbAltering.Enabled:= bAlteringOrderItem_Action;
   end;
 end; {case}

end;

procedure TformJob.rbConfirmClick(Sender: TObject);
begin
 bbSave.Enabled:= true;
end;

procedure TformJob.rbDenyClick(Sender: TObject);
begin
 bbSave.Enabled:= (mResolutionText.GetTextLen <> 0);
end;

procedure TformJob.rbAlteringClick(Sender: TObject);
begin
 bbSave.Enabled:= (mResolutionText.GetTextLen <> 0);
end;

procedure TformJob.mResolutionTextKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
 if mResolutionText.GetTextLen > 0 then bbSave.Enabled:= true;
end;


procedure tbDenyDocumentItemClick;
var
  tmpConfirmResult: TConfirmResult;
  tmpModalResult: TModalResult;
  curRecordPos, curRecordPos1: TidDSPositionSaver;
  tmpString: String;
begin
 tmpString:= 'Вы действительно хотите отменить выделенную позицию заявки?';

 tmpConfirmResult:= ConfirmDlg(tmpString + #13#10 +
                                'Номер заявки: ' + IntToStr(CurrentDocument.IdDocument) + #13#10 +
                                'Позиция: ' + #13#10 + '[' + CurrentDocumentItem.ObjectsGroup + ']' + #13#10 +
                                'Наименование: ' + CurrentDocumentItem.ShortName + #13#10 +
                                'Инициатор: ' + CurrentDocument.CreatorOwner + '[' + GetUserFullName(CurrentDocument.CreatorOwner) + ']' + #13#10);
 if (tmpConfirmResult = NoResult) or (tmpConfirmResult = CancelResult) then exit;

 Application.CreateForm(TformResolutionForItemWriter, formResolutionForItemWriter);
 formResolutionForItemWriter.formTypeResolution:= rtDeny;
 formResolutionForItemWriter.ShowModal;
 tmpString:= formResolutionForItemWriter.ResolutionText;
 tmpModalResult:= formResolutionForItemWriter.formModalResult;
 formResolutionForItemWriter.Free;
 if (tmpModalResult = mrOk) then
 begin
  curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocument);
  curRecordPos1:= DSPositionSaver.SavePosition(dmDB.QDocumentItem);

  DenyOrdersItem(CurrentDocument.IdDocument, CurrentDocumentItem.Id, tmpString);
  ShowDataForSelectedNode;
  RefreshDocument;
  ShowDocumentItem_Document(CurrentDocument.IdDocument);

  DSPositionSaver.RestorePosition(dmDB.QDocument, curRecordPos);
  DSPositionSaver.RestorePosition(dmDB.QDocumentItem, curRecordPos1);
 end;
end;

procedure tbAlterDocumentItemClick;
var
  tmpConfirmResult: TConfirmResult;
  tmpModalResult: TModalResult;
  curRecordPos, curRecordPos1: TidDSPositionSaver;
  tmpString, strResolutionText: String;
begin
 tmpString:= 'Вы действительно хотите отправить выделенную позицию заявки на переработку (будет создано дополнение к основной заявке)?';

 tmpConfirmResult:= ConfirmDlg(tmpString + #13#10 +
                                'Номер заявки: ' + IntToStr(CurrentDocument.IdDocument) + #13#10 +
                                'Позиция: ' + #13#10 + '[' + CurrentDocumentItem.ObjectsGroup + ']' + #13#10 +
                                'Наименование: ' + CurrentDocumentItem.ShortName + #13#10 +
                                'Инициатор: ' + CurrentDocument.CreatorOwner + '[' + GetUserFullName(CurrentDocument.CreatorOwner) + ']' + #13#10);
 if (tmpConfirmResult = NoResult) or (tmpConfirmResult = CancelResult) then exit;

 Application.CreateForm(TformResolutionForItemWriter, formResolutionForItemWriter);
 formResolutionForItemWriter.formTypeResolution:= rtAlteration;
 formResolutionForItemWriter.ShowModal;
 strResolutionText:= formResolutionForItemWriter.ResolutionText;
 tmpModalResult:= formResolutionForItemWriter.formModalResult;
 formResolutionForItemWriter.Free;
 if (tmpModalResult = mrOk) then
 begin
  curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocument);
  curRecordPos1:= DSPositionSaver.SavePosition(dmDB.QDocumentItem);

  AlterOrdersItem(CurrentDocument.IdDocument, CurrentDocumentItem.Id, strResolutionText);
  ShowDataForSelectedNode;
 // tbRefreshClick(Sender);
  RefreshDocument;
  ShowDocumentItem_Document(CurrentDocument.IdDocument);
  DSPositionSaver.RestorePosition(dmDB.QDocument, curRecordPos);
  DSPositionSaver.RestorePosition(dmDB.QDocumentItem, curRecordPos1);
 end;
end;

procedure tbConfirmDocumentItemClick;
var
  tmpConfirmResult: TConfirmResult;
  tmpModalResult: TModalResult;
  curRecordPos, curRecordPos1: TidDSPositionSaver;
  tmpString, strResolutionText: String;
begin
  curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocument);
  curRecordPos1:= DSPositionSaver.SavePosition(dmDB.QDocumentItem);

  DocumentItem_ExecJob(CurrentDocumentItem.Id, jrAgree);
  ShowDataForSelectedNode;
  RefreshDocument;
  ShowDocumentItem_Document(CurrentDocument.IdDocument);
  DSPositionSaver.RestorePosition(dmDB.QDocument, curRecordPos);
  DSPositionSaver.RestorePosition(dmDB.QDocumentItem, curRecordPos1);
end;

procedure TformJob.bbSaveClick(Sender: TObject);
var
   ResolutionText: string;
begin
 JobDocumentItem.ResolutionText:= mResolutionText.Text;
 case CurrentActiveObject of
  aoDocument:
   begin
     if rbConfirm.Checked then Document_Agree(Sender, JobDocumentItem);
//     if rbDeny.Checked then DenyOrder_Action(Sender, ResolutionText);
//     if rbAltering.Checked then AlterOrder_Action(Sender, ResolutionText);
   end;
  aoDocumentItem:
   begin
     if rbConfirm.Checked then DocumentItem_Agree(Sender, JobDocumentItem);
     if rbDeny.Checked then DocumentItem_Deny(Sender, JobDocumentItem);
     if rbAltering.Checked then DocumentItem_Alter(Sender, JobDocumentItem);
   end;
 end; {case}
 Close;
end;

procedure TformJob.mResolutionTextChange(Sender: TObject);
begin
 IsResolutionChanged:= true;
end;



procedure TformJob.FormShow(Sender: TObject);
begin
 gbJob1.Visible:= (GetJobItemExtendExistsStatus_DocumentItem(CurrentDocument.IdSelectedItem) = jesJobExists);
 gbJobItemExtend.Visible:= gbJob1.Visible;
 if not gbJob1.Visible then formJob.Height:= formJob.Height - Panel6.Height;
end;

end.
