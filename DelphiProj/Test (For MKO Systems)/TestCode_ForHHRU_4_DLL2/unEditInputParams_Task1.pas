unit unEditInputParams_Task1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IOUtils, ActiveX, IniFiles,
  unTaskSource;

type
  TformEditParams_Task1 = class(TForm)
    Label1: TLabel;
    edShellCommander: TEdit;
    Label2: TLabel;
    edTargetCommand: TEdit;
    btbRunTask: TButton;
    odTargetDirectory: TOpenDialog;
    Label3: TLabel;
    edResultFile: TEdit;
    chkbTypeResultOutput: TCheckBox;
    procedure btbRunTaskClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formEditParams_Task1: TformEditParams_Task1;
  iniFile: TIniFile;



implementation

{$R *.dfm}

procedure TformEditParams_Task1.btbRunTaskClick(Sender: TObject);
var
  tmpWideString: WideString;
  tmpPWideChar: PWideChar;
  tmpWord: word;
begin
try
 if not TFile.Exists(edShellCommander.Text) then
 begin
  WriteDataToLog(format('Целевой файл: %s не найден.', [edShellCommander.Text]),
                        'TformEditParams_Task1.btbRunTaskClick', 'unformEditParams_Task1');
  showmessage('Целевой файл не найден.');
  exit;
 end;
  tmpWord:= edShellCommander.GetTextLen + 1;
  SysReAllocStringLen(Task1_Parameters.inputParam1, Task1_Parameters.inputParam1, tmpWord);
  edShellCommander.GetTextBuf(Task1_Parameters.inputParam1, tmpWord);

  tmpWord:= edTargetCommand.GetTextLen + 1;
  SysReAllocStringLen(Task1_Parameters.inputParam2, Task1_Parameters.inputParam2, tmpWord);
  edTargetCommand.GetTextBuf(Task1_Parameters.inputParam2, tmpWord);

  tmpWord:= edResultFile.GetTextLen + 1;
  SysReAllocStringLen(Task1_Parameters.inputParam3, Task1_Parameters.inputParam3, tmpWord);
  edResultFile.GetTextBuf(Task1_Parameters.inputParam3, tmpWord);

  Task1_Parameters.inputParam4:= chkbTypeResultOutput.Checked; //(chkbTypeResultOutput.Checked);
  Task1_Parameters.inputParam5:= 0; //--- это номер задачи в списке согласно очерёдности запуска в главном модуле

  Close;
finally

end;
end;


procedure TformEditParams_Task1.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
try
 if Assigned(iniFile) then
 begin
  try
//   iniFile.WriteString(wsIniFileTitle1, wsIniFileParam1, edShellCommander.Text);
//   iniFile.WriteString(wsIniFileTitle1, wsIniFileParam1, edTargetCommand.Text);
//   iniFile.WriteString(wsIniFileTitle1, wsIniFileParam1, edResultFile.Text);
  except
//   on E: EIniFileException do

  end;
 end;
finally
  FreeAndNil(iniFile);
end;

end;

procedure TformEditParams_Task1.FormCreate(Sender: TObject);
var
   tmpStr: WideString;
begin
try
 tmpStr:= GetEnvironmentVariable('APPDATA') + '\' + wsIniFileName;
// tmpStr:= wsIniFileName;
 if not TDirectory.Exists(tmpStr) then
  TDirectory.CreateDirectory(tmpStr);
 iniFile:= TIniFile.Create(tmpStr);
except
 FreeAndNil(iniFile);
end;
end;

procedure TformEditParams_Task1.FormShow(Sender: TObject);
var
  tmpString: WideString;
begin
try
// btbRunTaskClick(Sender);
{
 if Assigned(iniFile) then
 begin
   tmpString:= iniFile.ReadString(wsIniFileTitle1, wsIniFileParam1, '');
   if tmpString <> '' then
     edShellCommander.Text:= tmpString;

   tmpString:= iniFile.ReadString(wsIniFileTitle1, wsIniFileParam2, '');
   if tmpString <> '' then
     edTargetCommand.Text:= tmpString;

   tmpString:= iniFile.ReadString(wsIniFileTitle1, wsIniFileParam3, '');
   if tmpString <> '' then
     edResultFile.Text:= tmpString;

 end;
}
finally

end;
end;

end.
