unit unEditUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons,
  unConstant, unVariable, ComCtrls;

type
  TformEditUser = class(TForm)
    pnlBotton: TPanel;
    bbSave: TBitBtn;
    bbCancel: TBitBtn;
    pnlCaption: TPanel;
    pcontUserInfo: TPageControl;
    tsheetUserCommonInfo: TTabSheet;
    gbUserInfo: TGroupBox;
    lbFIO: TLabel;
    lbLogin: TLabel;
    lbJobPosition: TLabel;
    lbNotes: TLabel;
    edFIO: TEdit;
    edLogin: TEdit;
    cbJobRole: TComboBox;
    edNotes: TEdit;
    tsheetUserRightInfo: TTabSheet;
    cbAdminRight: TCheckBox;

    procedure DefaultOnChangeActions(Sender: TObject); //---- ��������� �������
    procedure FormShow(Sender: TObject);
    procedure bbSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    formTypeOperation: TOperationType;
  end;

var
  formEditUser: TformEditUser;

implementation

uses unUtilCommon, unDBUtil, unDM, unEditSettings;

{$R *.dfm}

//-------------- ������� ����������� ��������� � ������ � ������� ---------------------------
procedure TformEditUser.DefaultOnChangeActions(Sender: TObject);
begin
 bbSave.Enabled:= true;
end;
//-------------------------------------------------------------------------------------------


procedure TformEditUser.FormShow(Sender: TObject);
begin
 if IsAuthenticationDone() then
 begin
 case formTypeOperation of
  doAdd:
    begin
     formEditUser.Caption:= '���������� ������������';
     pnlCaption.Caption:= '�������� ������ ������������';
     Execute_SP('sp_GetSpravJobRole', dmDB.QComboBox2);
     FillComboBoxFromQuery(cbJobRole, dmDB.QComboBox2, queryFieldName_SpravShortName);
     cbJobRole.Text:= '';
     edNotes.Text:= '';
     cbAdminRight.Checked:= false;
    end;

  doEdit:
    begin
     formEditUser.Caption:= '�������������� ������������: ' + CurrentUser.GetFullName;
     pnlCaption.Caption:= formEditUser.Caption;
     edFIO.Text:= CurrentUser.GetFullName;
     edLogin.Text:= CurrentUser.GetLoginName;
     Execute_SP('sp_GetSpravJobRole', dmDB.QComboBox2);
     FillComboBoxFromQuery(cbJobRole, dmDB.QComboBox2, queryFieldName_SpravShortName);
     cbJobRole.Text:= CurrentUser.GetJobRoleName;
     edNotes.Text:= CurrentUser.GetNotes;
     cbAdminRight.Checked:= CurrentUser.GetAdminRightState;
    end;

  doView:
    begin
     formEditUser.Caption:= '�������� ������������: ' + CurrentUser.GetFullName;
     pnlCaption.Caption:= formEditUser.Caption;

     edFIO.Text:= CurrentUser.GetFullName;
     edFIO.ReadOnly:= true;
     edLogin.Text:= CurrentUser.GetLoginName;
     edLogin.ReadOnly:= true;
     cbJobRole.Text:= CurrentUser.GetJobRoleName;
     edNotes.Text:= CurrentUser.GetNotes;
     edNotes.ReadOnly:= true;
     cbAdminRight.Checked:= CurrentUser.GetAdminRightState;
     cbAdminRight.Enabled:= false;
    end;
 end;

 edFIO.Text:= CurrentUser.GetFullName;

 formCurrentActive:= 'formEditUser';
 bbSave.Enabled:= false;  //---- ��������� ��������� � ������� - ����� ����� �������� �����
 end;

end;

procedure TformEditUser.bbSaveClick(Sender: TObject);
var
  JobRoleCode: TIdJobRole;
  curRecordPos: TidDSPositionSaver;
begin
 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QUserList);

//--- dmDB.QComboBox1 � dmDB.QComboBox2 ��� ���������!!! (����������� �� ����� OnFormShow)

 if FindRecordInQuery(dmDB.QComboBox2, queryFieldName_SpravShortName, cbJobRole.Text) then
  JobRoleCode:= dmDB.QComboBox2.FieldByName(queryFieldName_SpravCode).AsInteger
 else
 begin
  MessageBox('���� ������������ �� ��������� �� ��������!' +  #13#10 + '���������� �� �����������', ErrorMessage);
  exit;
 end;


 case formEditUser.formTypeOperation of
  doAdd,
  doEdit:
      begin
       bbSave.Enabled:= not EditUser(edLogin.Text, edFIO.Text, JobRoleCode, edNotes.Text);
      end;
 end;
 Execute_SP('sp_GetUserList', dmDB.QUserList);
 DSPositionSaver.RestorePosition(dmDB.QUserList, curRecordPos);
end;

end.
