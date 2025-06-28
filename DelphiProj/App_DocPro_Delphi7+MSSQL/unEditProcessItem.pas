unit unEditProcessItem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons, ExtCtrls,
  unConstant, unVariable;

type
  TformEditProcessItem = class(TForm)
    pnlBotton: TPanel;
    bbSave: TBitBtn;
    bbCancel: TBitBtn;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    lbProcessItemLevel: TLabel;
    edProcessItemLevel: TEdit;
    updnProcessItemLevel: TUpDown;
    gbHowPositioningProcessItemLevel: TGroupBox;
    rbInsertInsteedCurrent: TRadioButton;
    rbAddToEnd: TRadioButton;
    lbRoutePointType: TLabel;
    cbProcessItemName: TComboBox;
    lbJobPosition: TLabel;
    cbProcessItemJob: TComboBox;
    TabSheet2: TTabSheet;
    gbJob: TGroupBox;
    Panel1: TPanel;
    cbStandardJob: TCheckBox;
    stStandardJob: TStaticText;
    procedure DefaultOnChangeActions(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bbSaveClick(Sender: TObject);       //---- ��������� �������
  private
    { Private declarations }
  public
    { Public declarations }
    formTypeOperation: TOperationType;
  end;

var
  formEditProcessItem: TformEditProcessItem;

implementation
uses unUtilCommon, unDBUtil, unDM, unEditProcess, unEditSettings;

{$R *.dfm}
//-------------- ������� ����������� ��������� � ������ � ������� ---------------------------
procedure TformEditProcessItem.DefaultOnChangeActions(Sender: TObject);
begin
 bbSave.Enabled:= true;
end;
//-------------------------------------------------------------------------------------------


procedure TformEditProcessItem.FormShow(Sender: TObject);
begin
 if IsAuthenticationDone() then
 begin
//  updnNumInRout.Position:= not dmDB.dsRoutesItemsList.DataSet.FieldByName(queryFieldNameForRoutePositionLevel).AsInteger;

  Execute_SP('sp_GetSpravJob', dmDB.QComboBox1);
  FillComboBoxFromQuery(cbProcessItemName, dmDB.QComboBox1, queryFieldName_SpravShortName);

  Execute_SP('sp_GetSpravJobRole', dmDB.QComboBox2);
  FillComboBoxFromQuery(cbProcessItemJob, dmDB.QComboBox2, queryFieldName_SpravShortName);

  cbProcessItemName.Text:= cbProcessItemName.Items[0];
  cbProcessItemJob.Text:= cbProcessItemJob.Items[0];

 case formTypeOperation of
  doAdd:
    begin
     formEditProcessItem.Caption:= '���������� ����� ��������';
     updnProcessItemLevel.Position:= CurrentTemplateProcessItem.GetItemLevel;
     gbHowPositioningProcessItemLevel.Visible:= true;
    end;

  doEdit:
    begin
     formEditProcessItem.Caption:= '�������������� ����� �������� � '; // + CurrentProcessItem.GetProcessItemName;
     cbProcessItemName.Text:= dmDB.QProcessItem.FieldByName(queryFieldName_ProcessItemName).AsString;
     cbProcessItemJob.Text:= dmDB.QProcessItem.FieldByName(queryFieldName_JobRoleName).AsString;
     updnProcessItemLevel.Position:= StrToInt(dmDB.QProcessItem.FieldByName(queryFieldName_ProcessItemLevel).AsString);
     gbHowPositioningProcessItemLevel.Visible:= false;
    end;

 end;

 end;
end;

procedure TformEditProcessItem.bbSaveClick(Sender: TObject);
var
  curRecordPos: TidDSPositionSaver;
  curRouteStatus: TObjectShowStatus;
  idProcessJob: TId;
  iProcessItemLevel: integer;
  idJobRole: TIdJobRole;
  idCreatedTemplateProcessItem: TId;
  JobRoleType: TJobRoleType;
begin
 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QProcessItem);

 if rbInsertInsteedCurrent.Checked then iProcessItemLevel:= updnProcessItemLevel.Position
                            else iProcessItemLevel:= GetTemplateProcessItem_Count(CurrentTemplateProcess.GetId);
// if curRecordPos <= 0 then curRecordPos:= 1;
//--- dmDB.QComboBox1 � dmDB.QComboBox2 ��� ���������!!! (����������� �� ����� OnFormShow)
 if FindRecordInQuery(dmDB.QComboBox1, queryFieldName_SpravShortName, cbProcessItemName.Text) then
  idProcessJob:= dmDB.QComboBox1.FieldByName(queryFieldName_JobId).AsInteger
 else

 begin
  MessageBox('������ ����� �������� �� ���������� �� ��������!' +  #13#10 + '���������� �� �����������', ErrorMessage);
  exit;
 end;

 if FindRecordInQuery(dmDB.QComboBox2, queryFieldName_SpravShortName, cbProcessItemJob.Text) then
 begin
  idJobRole:= dmDB.QComboBox2.FieldByName(queryFieldName_SpravId).AsInteger;
  JobRoleType:= dmDB.QComboBox2.FieldByName(queryFieldName_JobRoleType).Value;
 end
 else
 begin
  MessageBox('��������� ����� �������� �� ���������� �� ��������!' +  #13#10 + '���������� �� �����������', ErrorMessage);
  exit;
 end;


 case formEditProcessItem.formTypeOperation of
  doAdd:
      begin
       if not CreateTemplateProcessItem(CurrentTemplateProcess.GetId, iProcessItemLevel, idProcessJob, idJobRole, JobRoleType)
         then MessageBox('���������� ������� ����� �������� ����������� � �������.', ErrorMessage);
      end;
  doEdit:
      begin
//       bbSave.Enabled:= not EditRouteItem(CurrentUser.GetLoginName, dmDB.dsRoutesItemsList.DataSet.FieldByName(queryFieldNameForIdRouteItem).AsInteger,
//                                          idProcessStatus, idJobRoleCode);
                                          //-- ������� ������ ��������, ���� �� ��� �������������� ���� �� ���� ���!
      end;
 end;
// ShowRouteItemsList(formEditRoute.dbgRouteItem, dmDB.QRoutesItemsList, CurrentRouteItem.GetRouteId);
 DSPositionSaver.RestorePosition(dmDB.QProcessItem, curRecordPos);

end;

end.
