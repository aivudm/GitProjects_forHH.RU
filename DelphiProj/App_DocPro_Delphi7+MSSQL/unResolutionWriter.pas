unit unResolutionWriter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, Grids, DBGrids,
  unConstant, unVariable;

type
  TformResolutionWriter = class(TForm)
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    Splitter3: TSplitter;
    gbRoutesInfo: TGroupBox;
    Panel1: TPanel;
    gbCommonOrderInfo: TGroupBox;
    lbFIO: TLabel;
    lbOrderOpen: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    edFIO: TEdit;
    dtpOrderCreationDate: TDateTimePicker;
    dtpOrderExecutionDate: TDateTimePicker;
    memNotes: TMemo;
    Panel2: TPanel;
    Panel3: TPanel;
    bbApply: TBitBtn;
    bbCancel: TBitBtn;
    Label3: TLabel;
    edOrderNum: TEdit;
    Memo1: TMemo;
    procedure FormShow(Sender: TObject);
    procedure bbApplyClick(Sender: TObject);
    procedure bbCancelClick(Sender: TObject);
    procedure DefaultOnChangeActions(Sender: TObject);
    procedure FormCreate(Sender: TObject);       //---- ��������� �������
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
  formResolutionWriter: TformResolutionWriter;

implementation
uses unUtilCommon, unDBUtil, unDM;

{$R *.dfm}

//-------------- ������� ����������� ��������� � ������ � ������� ---------------------------
procedure TformResolutionWriter.DefaultOnChangeActions(Sender: TObject);
begin
 bbApply.Enabled:= true;
 IsCommentsChanged:= bbApply.Enabled;
end;
//-------------------------------------------------------------------------------------------

procedure TformResolutionWriter.FormShow(Sender: TObject);
begin
 if IsAuthenticationDone() then
 begin
 Memo1.Clear;
 case formTypeResolution of
  rtDeny:
    begin
     formResolutionWriter.Caption:= '����������� �� ����� ������ � ' + IntToStr(CurrentDocument.IdDocument);
     Panel1.Font.Style:= [fsBold];
     Panel1.Font.Color:= clRed;
     Panel1.Caption:= '����� (��������) ������';
     Memo1.Text:= '����������� �����������!';

     bbApply.Enabled:= false;  //---- ��������� ��������� � false - ��� ����� ����������� �� ����� �����!
    end;
{  rtConfirm:
    begin
     formResolutionWriter.Caption:= '����������� �� ������������/����������� ������';
     Panel1.Font.Style:= [fsBold];
     Panel1.Font.Color:= clGreen;
     Panel1.Caption:= '������������� ������������';
     Memo1.Text:= '����������� �� �����������!';

     bbApply.Enabled:= true;  //---- ��������� ��������� � true - ����� ����� �������� ��� ����� �����������
    end;
}
  rtAlteration:
    begin
     formResolutionWriter.Caption:= '�� ��������������/���������';
     Panel1.Font.Style:= [fsBold];
     Panel1.Font.Color:= clRed;
     Panel1.Caption:= '����������� ���������� �� �������� ���������';
     Memo1.Text:= '����������� ����������� - �������� ���������� �� ��������� ������';

     bbApply.Enabled:= false;  //---- ��������� ��������� � false - ��� ����� ����������� (���������) �� �������������� ����� (�� ���� �����, ��� ������ ��???)!
    end;
 end;

 edOrderNum.Text:= IntToStr(CurrentDocument.IdDocument);
 edFIO.Text:= CurrentDocument.CreatorOwner;
 memNotes.Text:= CurrentDocument.Notes;
 dtpOrderCreationDate.Date:= CurrentDocument.CreationDate;
 dtpOrderExecutionDate.Date:= CurrentDocument.ExecutionDate;
 formResolutionWriter.formModalResult:= mrCancel;
 IsCommentsChanged:= false;
 end;
end;

procedure TformResolutionWriter.bbApplyClick(Sender: TObject);
begin
 formResolutionWriter.formModalResult:= mrOk;
 if IsCommentsChanged then formResolutionWriter.ResolutionText:= formResolutionWriter.Memo1.Text;
end;

procedure TformResolutionWriter.bbCancelClick(Sender: TObject);
var
  tmpConfirmResult: TConfirmResult;
begin
 tmpConfirmResult:= ConfirmDlg('�� ������������� ������ �������� ���������� ��������: ' + Panel1.Caption + #13#10 +
                                '����� ������: ' + IntToStr(CurrentDocument.IdDocument) + #13#10 +
                                CurrentDocument.Notes + #13#10 +
                                '���������: ' + CurrentDocument.CreatorOwner + #13#10);
 if (tmpConfirmResult = YesResult) then
 begin
  formResolutionWriter.formModalResult:= mrCancel;   //--- �������� ���������� �������� ��������
  exit;
 end
 else formResolutionWriter.formModalResult:= mrOk;   //--- ���������� ���������� �������� ��������


end;

procedure TformResolutionWriter.FormCreate(Sender: TObject);
begin
 formResolutionWriter.formModalResult:= mrCancel;
end;

end.
