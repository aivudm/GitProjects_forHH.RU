unit unLoginDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, StdCtrls, Buttons, ComCtrls, ExtCtrls, IniFiles, DateUtils,
  ComObj,
  unVariable, unUtilCommon;

type
  TformMainLoginDialog = class(TForm)
    pnlLogin: TPanel;
    lbUserName: TLabel;
    lbPassword: TLabel;
    pnlAnimate: TPanel;
    edUserName: TEdit;
    mePassword: TMaskEdit;
    edDbName: TEdit;
    edSrvName: TEdit;
    bbCancel: TBitBtn;
    bbOk: TBitBtn;
    lbDbName: TLabel;
    lbSrvName: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bbCancelClick(Sender: TObject);
    procedure bbOkClick(Sender: TObject);
    procedure mePasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mePasswordKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formMainLoginDialog: TformMainLoginDialog;


//function CanEnter(): boolean;



implementation

uses unDM;

{$R *.dfm}

procedure TformMainLoginDialog.FormCreate(Sender: TObject);
var
 CurrentDate: AnsiString;
begin
 edUserName.Text:= iniFile.ReadString('Login Dialog', 'Last Logged User', '');
 edDbName.Text:= iniFile.ReadString('Login Dialog', 'Last Logged DataBase', '');
 edSrvName.Text:= iniFile.ReadString('Login Dialog', 'Last Logged Server', '');

end;

procedure TformMainLoginDialog.FormShow(Sender: TObject);
begin
 if (mePassword.CanFocus) and (edUserName.Text <> '') then
  mePassword.SetFocus;
end;

procedure TformMainLoginDialog.bbCancelClick(Sender: TObject);
begin
  ModalResult:= mrCancel;
end;

procedure TformMainLoginDialog.bbOkClick(Sender: TObject);
var
 CurrentDate: AnsiString;
 tmpStr: AnsiString;
 i: integer;
begin

 iniFile.WriteString('Login Dialog', 'Last Logged User', formMainLoginDialog.edUserName.Text);
 iniFile.WriteString('Login Dialog', 'Last Logged DataBase', formMainLoginDialog.edDbName.Text);
 iniFile.WriteString('Login Dialog', 'Last Logged Server', formMainLoginDialog.edSrvName.Text);

 dmDB.dbConnection.Connected:= false;
 dmDB.dbConnection.Close;
// dmDB.dbConnection.ConnectionString:= 'Provider=SQLOLEDB.1;Integrated Security=;Persist Security Info=False;'; //---- For "Trusted Connection by Kerberos" добавить - "Integrated Security=SSPI;"
// dmDB.dbConnection.ConnectionString:= dmDB.dbConnection.ConnectionString + 'Initial Catalog=' + formMainLoginDialog.edDbName.Text + ';';
// dmDB.dbConnection.ConnectionString:= dmDB.dbConnection.ConnectionString + 'Data Source=' + formMainLoginDialog.edSrvName.Text + ';';
// dmDB.dbConnection.ConnectionString:= dmDB.dbConnection.ConnectionString + 'User Name=' + formMainLoginDialog.edUserName.Text + ';';
// dmDB.dbConnection.ConnectionString:= dmDB.dbConnection.ConnectionString + 'Password=' + formMainLoginDialog.mePassword.Text + ';';

 dmDB.dbConnection.ConnectionString:= 'Provider=SQLOLEDB.1;Driver=SQL Server;';
 dmDB.dbConnection.ConnectionString:= dmDB.dbConnection.ConnectionString + 'Server=' + formMainLoginDialog.edSrvName.Text + ';';
 dmDB.dbConnection.ConnectionString:= dmDB.dbConnection.ConnectionString + 'Database=' + formMainLoginDialog.edDbName.Text + ';';
 dmDB.dbConnection.ConnectionString:= dmDB.dbConnection.ConnectionString + 'Trusted_Connection=false' + ';';


// dmDB.dbConnection.ConnectionString:= iniFile.ReadString('Connectivety', 'ADOConnectionString', '');
 WriteDataToLog('ConnectionStringBefore = ' + dmDB.dbConnection.ConnectionString, 'TformMainLoginDialog.bbOkClick()', 'unLoginDialog');

// dmDB.dbConnection.ConnectionString:= dmDB.dbConnection.ConnectionString + 'User Id=' + formMainLoginDialog.edUserName.Text + ';';
// dmDB.dbConnection.ConnectionString:= dmDB.dbConnection.ConnectionString + 'Password=' + formMainLoginDialog.mePassword.Text + ';';

  dmDB.dbConnection.ConnectionTimeout:= 3;
  dmDB.dbConnection.Errors.Clear;
 try
//  showmessage(dmDB.dbConnection.ConnectionString);

  dmDB.dbConnection.Open(formMainLoginDialog.edUserName.Text, formMainLoginDialog.mePassword.Text);
  dmDB.dbConnection.Connected:= true;
  bIsAuthenticationDone:= true; //---- Дублирование действия TdmDB.dbConnectionConnectComplete(...), так как иногда эта процедура вызывается ADO после некоторого ожидания и происходит ложный отказ от входа

  iniFile.WriteString('Connectivety', 'ADOConnectionString', dmDB.dbConnection.ConnectionString);

  mainServerName:= formMainLoginDialog.edSrvName.Text;
  mainDataBaseName:= formMainLoginDialog.edDbName.Text;
  mainUserName:= formMainLoginDialog.edUserName.Text;
  CurrentUser.SetCurrent(mainUserName);
//  mainAuthentication:= Password;

  ModalResult:= mrOk;
  iniFile.WriteString('Login Dialog', 'Last Logged DateTime', FormatDateTime('yyyymmdd', Today()) + ' ' + FormatDateTime('hh:mm:ss', Time()));
  exit;
 except
 on e:EOleException do
 begin
 {Code to handle the exception}
   if (E.ErrorCode=-2147217843) then MessageBox('Не верно указаны имя пользователя или пароль', ErrorMessage);
   if (E.ErrorCode=-2147467259) {E.ErrorCode= HRESULT(80004005)} then MessageBox('Login Fails. Сервер не существует или отсутствует доступ.', ErrorMessage)

                                else MessageBox(e.Message, ErrorMessage);
   WriteDataToLog('E.ErrorCode=' + IntToStr(E.ErrorCode), 'TformMainLoginDialog.bbOkClick()', 'unLoginDialog');
 end;

 end;

{Сюда попадаем, если было исключение при коннекте}
 ModalResult:= mrNone;
 WriteDataToLog('ConnectionStringAfter = ' + dmDB.dbConnection.ConnectionString, 'TformMainLoginDialog.bbOkClick()', 'unLoginDialog');
 if dmDB.dbConnection.Errors.Count > 0 then

  for i:= 0 to dmDB.dbConnection.Errors.Count-1 do
  begin
   tmpStr:= dmDB.dbConnection.Errors[i].Description; // dmDB.dbConnection.Errors[i].NativeError , dmDB.dbConnection.Errors[i].Source, '', 'formMainLoginDialog::bbOkClick(), '');
   MessageBox(tmpStr, ErrorMessage);
  end;
end;

procedure TformMainLoginDialog.mePasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case (Key) of
   17: // Ctrl
    begin
     bCtrlWasPressed:= true;
     exit;
    end;
 end;
end;

procedure TformMainLoginDialog.mePasswordKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case (Key) of
  ord(#13):
   begin
    if (formMainLoginDialog.bbOk.CanFocus()) then
     formMainLoginDialog.bbOk.Click();
   end;
  ord('E'), ord('e'):
    begin
     if (bCtrlWasPressed) then
      begin
       formMainLoginDialog.lbDbName.Enabled:= not (formMainLoginDialog.lbDbName.Enabled);
       formMainLoginDialog.edDbName.Enabled:= formMainLoginDialog.lbDbName.Enabled;
       lbSrvName.Enabled:= formMainLoginDialog.lbDbName.Enabled;
       edSrvName.Enabled:= formMainLoginDialog.lbDbName.Enabled;
       Update();
      end;
    end
  else
   bCtrlWasPressed:= false;
  end;
end;

{*
function CanEnter(): boolean;
var
  LoginAttemptCount: word;
  retcode: integer;
begin
try
 LoginAttemptCount:= 3;
 retcode:= mrNone;
 formMainLoginDialog:= TformMainLoginDialog.Create(Application.MainForm);
 while (LoginAttemptCount >= 0) and (retcode <> mrCancel) and (retcode <> mrOk) do
  begin
   dec(LoginAttemptCount);
   retcode:= formMainLoginDialog.ShowModal();
  end;
 formMainLoginDialog.Free();
 Result:= (retcode = mrOk);
except
 Application.ShowException(E);
 Result:= false;
end;
end;
*}

end.
