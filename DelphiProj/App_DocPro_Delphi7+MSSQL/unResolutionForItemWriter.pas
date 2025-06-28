unit unResolutionForItemWriter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls,
  unConstant, unVariable;

type
  TformResolutionForItemWriter = class(TForm)
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    gbRoutesInfo: TGroupBox;
    Memo1: TMemo;
    Panel1: TPanel;
    gbCommonOrderInfo: TGroupBox;
    Panel2: TPanel;
    Panel3: TPanel;
    bbApply: TBitBtn;
    bbCancel: TBitBtn;
    Label1: TLabel;
    lbOrderOpen: TLabel;
    lbFIO: TLabel;
    lb: TLabel;
    Label6: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    cbObjectsGroups: TComboBox;
    dtpOrderItemCreationDate: TDateTimePicker;
    cbMeasurementsUnits: TComboBox;
    dtpOrderItemsExecutionDate: TDateTimePicker;
    edFIO: TEdit;
    edObjectVolume: TEdit;
    memNotes: TMemo;
    edObjectName: TEdit;
    procedure FormShow(Sender: TObject);
    procedure bbCancelClick(Sender: TObject);
    procedure bbApplyClick(Sender: TObject);
    procedure DefaultOnChangeActions(Sender: TObject);       //---- ��������� �������
  private
    { Private declarations }
  public
    { Public declarations }
    formTypeResolution: TResolutionType;
    ResolutionText: String;
    formModalResult: TModalResult;
    IsCommentsChanged: boolean;
  end;

var
  formResolutionForItemWriter: TformResolutionForItemWriter;

implementation
uses unUtilCommon, unDBUtil, unDM;

{$R *.dfm}
//-------------- ������� ����������� ��������� � ������ � ������� ---------------------------
procedure TformResolutionForItemWriter.DefaultOnChangeActions(Sender: TObject);
begin
 bbApply.Enabled:= true;
 IsCommentsChanged:= bbApply.Enabled;
end;
//-------------------------------------------------------------------------------------------

procedure TformResolutionForItemWriter.FormShow(Sender: TObject);
begin
 if IsAuthenticationDone() then
 begin
 Memo1.Clear;
 case formTypeResolution of
  rtDeny:
    begin
     formResolutionForItemWriter.Caption:= '����������� �� ����� ������� ������ � ' + IntToStr(CurrentDocument.IdDocument);
     Panel1.Font.Style:= [fsBold];
     Panel1.Font.Color:= clRed;
     Panel1.Caption:= '����� (��������) ������� ������';
     Memo1.Text:= '����������� �����������!';

     bbApply.Enabled:= false;  //---- ��������� ��������� � false - ��� ����� ����������� �� ����� �����!
    end;
{
  rtConfirm:
    begin
     formResolutionForItemWriter.Caption:= '����������� �� ������������/����������� ������� ������';
     Panel1.Font.Style:= [fsBold];
     Panel1.Font.Color:= clGreen;
     Panel1.Caption:= '������������� ������������ ������� ������';
     Memo1.Text:= '����������� �� �����������!';

     bbApply.Enabled:= true;  //---- ��������� ��������� � true - ����� ����� �������� ��� ����� �����������
    end;
}
  rtAlteration:
    begin
     formResolutionForItemWriter.Caption:= '�� ��������������/���������';
     Panel1.Font.Style:= [fsBold];
     Panel1.Font.Color:= clRed;
     Panel1.Caption:= '����������� ���������� �� �������� ���������';
     Memo1.Text:= '����������� ����������� - �������� ���������� �� ��������� ������� ������';

     bbApply.Enabled:= false;  //---- ��������� ��������� � false - ��� ����� ����������� (���������) �� �������������� ����� (�� ���� �����, ��� ������ ��???)!
    end;
 end;

 edFIO.Text:= GetUserFullNameByLogin(CurrentDocument.CreatorOwner);
 dtpOrderItemCreationDate.Date:= CurrentDocument.CreationDate;
 dtpOrderItemsExecutionDate.Date:= CurrentDocument.ExecutionDate;
 cbObjectsGroups.Text:= CurrentDocumentItem.ObjectsGroup;
 edObjectName.Text:= CurrentDocumentItem.ShortName;
 edObjectVolume.Text:= IntToStr(CurrentDocumentItem.Volume);
 memNotes.Text:= CurrentDocument.Notes;

 IsCommentsChanged:= false;
 end;
end;

procedure TformResolutionForItemWriter.bbCancelClick(Sender: TObject);
var
  tmpConfirmResult: TConfirmResult;
begin
 tmpConfirmResult:= ConfirmDlg('�� ������������� ������ �������� ���������� ��������: ' + Panel1.Caption + #13#10 +
                                '����� ������: ' + IntToStr(CurrentDocument.IdDocument) + #13#10 +
                                CurrentDocument.Notes + #13#10 +
                                '���������: ' + CurrentDocument.CreatorOwner + #13#10);
 if (tmpConfirmResult = YesResult) then
 begin
  formResolutionForItemWriter.formModalResult:= mrCancel;   //--- �������� ���������� �������� ��������
  exit;
 end
 else formResolutionForItemWriter.formModalResult:= mrOk;   //--- ���������� ���������� �������� ��������


end;

procedure TformResolutionForItemWriter.bbApplyClick(Sender: TObject);
begin
 formResolutionForItemWriter.formModalResult:= mrOk;
 if IsCommentsChanged then formResolutionForItemWriter.ResolutionText:= formResolutionForItemWriter.Memo1.Text;
end;

end.
