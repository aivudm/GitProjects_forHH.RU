unit unEditJobPosition;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,
  unVariable;

type
  TformEditJobPosition = class(TForm)
    pnlBotton: TPanel;
    bbSave: TBitBtn;
    bbCancel: TBitBtn;
    pnlCaption: TPanel;
    gbUserInfo: TGroupBox;
    lbShortJobPosition: TLabel;
    lbedFullNameJobPosition: TLabel;
    lbNotes: TLabel;
    edShortNameJobPosition: TEdit;
    edFullNameJobPosition: TEdit;
    edNotes: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    lbNotesNew: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label3: TLabel;
    edCode: TEdit;

    procedure DefaultOnChangeActions(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bbSaveClick(Sender: TObject); //---- Добавлена вручную
  private
    { Private declarations }
  public
    { Public declarations }
    formTypeOperation: TOperationType;
  end;

var
  formEditJobPosition: TformEditJobPosition;

implementation
uses unConstant, unUtilCommon, unDBUtil, unDM;
{$R *.dfm}

//-------------- Вручную добавленные процедуры и фукции в классах ---------------------------
procedure TformEditJobPosition.DefaultOnChangeActions(Sender: TObject);
begin
 bbSave.Enabled:= true;
end;
//-------------------------------------------------------------------------------------------


procedure TformEditJobPosition.FormShow(Sender: TObject);
begin
 if IsAuthenticationDone() then
 begin
 case formTypeOperation of
  doAdd:
    begin
     formEditJobPosition.Caption:= 'Добавление новой должности';
    end;

  doEdit:
    begin
     formEditJobPosition.Caption:= 'Редактирование должности: ' + CurrentSpravObject.GetFullName;
     pnlCaption.Caption:= formEditJobPosition.Caption;
     edShortNameJobPosition.Text:= CurrentSpravObject.GetFullName;
     edFullNameJobPosition.Text:= CurrentSpravObject.GetShortName;
     edNotes.Text:= CurrentSpravObject.GetNotes;
    end;

  doView:
    begin
     formEditJobPosition.Caption:= 'Просмотр должности: ' + CurrentSpravObject.GetFullName;
     pnlCaption.Caption:= formEditJobPosition.Caption;

     edShortNameJobPosition.Text:= CurrentSpravObject.GetFullName;
     edShortNameJobPosition.ReadOnly:= true;
     edFullNameJobPosition.Text:= CurrentSpravObject.GetShortName;
     edFullNameJobPosition.ReadOnly:= true;
     edNotes.Text:= CurrentSpravObject.GetNotes;
     edNotes.ReadOnly:= true;
    end;
 end;

 edShortNameJobPosition.Text:= CurrentSpravObject.GetFullName;

 formCurrentActive:= 'formEditJobPosition';
 bbSave.Enabled:= false;  //---- Начальная установка в дизэйбл - сразу после открытия формы
 end;

end;

procedure TformEditJobPosition.bbSaveClick(Sender: TObject);
var
  curRecordPos: TidDSPositionSaver;
begin
 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QJobRole);
 with formEditJobPosition do
 begin
  case formEditJobPosition.formTypeOperation of
   doAdd:
      begin
       bbSave.Enabled:= not CreateSpravItem(CurrentUser.GetLoginName, spravJobRole, StrToInt(edCode.Text), formEditJobPosition.edShortNameJobPosition.Text,
                                            formEditJobPosition.edFullNameJobPosition.Text, formEditJobPosition.edNotes.Text);
      end;
   doEdit:
      begin
//       bbSave.Enabled:= not EditSpravItem(CurrentJobPosition.IdOrder, formEditJobPosition.dtpOrderExecutionDate.DateTime,
//                                        formEditJobPosition.memNotes.Text, dbgRoutesList.DataSource.DataSet.Fields.FieldByName('Code').AsInteger);  //-- Маршрут нельзя изменить (по крайней мере на данный момент...)!
      end;
  end;
 end;

 RefreshDocument;
 DSPositionSaver.RestorePosition(dmDB.QJobRole, curRecordPos);
end;

end.
