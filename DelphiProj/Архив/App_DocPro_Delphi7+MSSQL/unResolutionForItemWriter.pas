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
    procedure DefaultOnChangeActions(Sender: TObject);       //---- Добавлена вручную
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
//-------------- Вручную добавленные процедуры и фукции в классах ---------------------------
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
     formResolutionForItemWriter.Caption:= 'Комментарий на отказ позиции заявки № ' + IntToStr(CurrentDocument.IdDocument);
     Panel1.Font.Style:= [fsBold];
     Panel1.Font.Color:= clRed;
     Panel1.Caption:= 'Отказ (закрытие) позиции заявки';
     Memo1.Text:= 'Комментарии обязательны!';

     bbApply.Enabled:= false;  //---- Начальная установка в false - без ввода комментария на отказ НИКАК!
    end;
{
  rtConfirm:
    begin
     formResolutionForItemWriter.Caption:= 'Комментарий на согласование/утверждение позиции заявки';
     Panel1.Font.Style:= [fsBold];
     Panel1.Font.Color:= clGreen;
     Panel1.Caption:= 'Положительное согласование позиции заявки';
     Memo1.Text:= 'Комментарии не обязательны!';

     bbApply.Enabled:= true;  //---- Начальная установка в true - можно сразу нажимать без ввода комментария
    end;
}
  rtAlteration:
    begin
     formResolutionForItemWriter.Caption:= 'на переоформление/изменение';
     Panel1.Font.Style:= [fsBold];
     Panel1.Font.Color:= clRed;
     Panel1.Caption:= 'Направление инициатору на внесение изменений';
     Memo1.Text:= 'Комментарии обязательны - указания инициатору по изменению позиции заявки';

     bbApply.Enabled:= false;  //---- Начальная установка в false - без ввода комментария (пояснений) на переоформление НИКАК (не ясно будет, что делать то???)!
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
 tmpConfirmResult:= ConfirmDlg('Вы действительно хотите отменить оформление действия: ' + Panel1.Caption + #13#10 +
                                'Номер заявки: ' + IntToStr(CurrentDocument.IdDocument) + #13#10 +
                                CurrentDocument.Notes + #13#10 +
                                'Инициатор: ' + CurrentDocument.CreatorOwner + #13#10);
 if (tmpConfirmResult = YesResult) then
 begin
  formResolutionForItemWriter.formModalResult:= mrCancel;   //--- Прервать оформление текущего действия
  exit;
 end
 else formResolutionForItemWriter.formModalResult:= mrOk;   //--- Продолжить оформление текущего действия


end;

procedure TformResolutionForItemWriter.bbApplyClick(Sender: TObject);
begin
 formResolutionForItemWriter.formModalResult:= mrOk;
 if IsCommentsChanged then formResolutionForItemWriter.ResolutionText:= formResolutionForItemWriter.Memo1.Text;
end;

end.
