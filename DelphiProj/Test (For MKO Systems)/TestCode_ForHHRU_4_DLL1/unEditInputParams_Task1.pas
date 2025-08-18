unit unEditInputParams_Task1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IOUtils, ActiveX,
  unTaskSource, Vcl.Buttons, CommDlg;

type
  TformEditParams_Task1 = class(TForm)
    Label1: TLabel;
    edMask: TEdit;
    Label2: TLabel;
    edTargetDirectory: TEdit;
    btbRunTask: TButton;
    lbResultFile: TLabel;
    edResultFile: TEdit;
    chkbTypeResultOutput: TCheckBox;
    bbOpenDirectory: TBitBtn;
    procedure btbRunTaskClick(Sender: TObject);
    procedure sbSelectDirectoryClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bbOpenDirectoryClick(Sender: TObject);
    procedure chkbTypeResultOutputClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formEditParams_Task1: TformEditParams_Task1;
  edTargetDirectory_Buffer: PWideChar;


implementation
//uses Shobjidl;
{$R *.dfm}

procedure TformEditParams_Task1.bbOpenDirectoryClick(Sender: TObject);
var
  tmpWideString: WideString;
begin
 if SelectDirectory(Handle, wsTask1_Name, wsTask1_DefaultDirectory, tmpWideString) then
 begin
  setlength(tmpWideString, length(tmpWideString) + 1);
  try
   SysAllocStringLen(edTargetDirectory_Buffer, length(tmpWideString)*sizeof(WideChar) + 1);
   edTargetDirectory_Buffer:= PWideChar(tmpWideString);
   edTargetDirectory.SetTextBuf(edTargetDirectory_Buffer);
  except
   SysFreeString(edTargetDirectory_Buffer);
  end;
 end;
end;

procedure TformEditParams_Task1.btbRunTaskClick(Sender: TObject);
var
  tmpWideString: WideString;
  tmpPWideChar: PWideChar;
  tmpWord: word;
begin
try
 if (not TDirectory.Exists(edTargetDirectory.Text)) or (edTargetDirectory.Text = '') then
 begin
  showmessage(wsTask1_TargetDirectoryNotFound);
  exit;
 end;
//  GetMem(tmpPWideChar, tmpWord + 1);
//   Task1_Parameters.inputParam1:= PWideChar(edMask.Text);
  tmpWord:= edMask.GetTextLen + 1;
  SysReAllocStringLen(Task1_Parameters.inputParam1, Task1_Parameters.inputParam1, tmpWord);
  edMask.GetTextBuf(Task1_Parameters.inputParam1, tmpWord);
//   Task1_Parameters.inputParam2:= PWideChar(edTargetDirectory.Text);
  tmpWord:= edTargetDirectory.GetTextLen + 1;
  SysReAllocStringLen(Task1_Parameters.inputParam2, Task1_Parameters.inputParam2, tmpWord);
  edTargetDirectory.GetTextBuf(Task1_Parameters.inputParam2, tmpWord);
//   Task1_Parameters.inputParam3:=  PWideChar(edResultFile.Text); //MultibyteToWideChar
  tmpWord:= edResultFile.GetTextLen + 1;
  SysReAllocStringLen(Task1_Parameters.inputParam3, Task1_Parameters.inputParam3, tmpWord);
  edResultFile.GetTextBuf(Task1_Parameters.inputParam3, tmpWord);

  Task1_Parameters.inputParam4:= chkbTypeResultOutput.Checked; //(chkbTypeResultOutput.Checked);
  Task1_Parameters.inputParam5:= 0; //--- это номер задачи в списке согласно очерёдности запуска в главном модуле

  Close;
finally
// FreeMem(tmpPWideChar);
end;
end;


procedure TformEditParams_Task1.chkbTypeResultOutputClick(Sender: TObject);
begin
 lbResultFile.Visible:= (Sender as TCheckBox).Checked;
 edResultFile.Visible:= (Sender as TCheckBox).Checked;
end;

procedure TformEditParams_Task1.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
 SysFreeString(edTargetDirectory_Buffer);
end;

procedure TformEditParams_Task1.sbSelectDirectoryClick(Sender: TObject);
var
  tmpWideString: WideString;
begin
 if SelectDirectory(Handle, wsTask1_Name, wsTask1_DefaultDirectory, tmpWideString) then
 begin
  setlength(tmpWideString, length(tmpWideString) + 1);
  try
   SysAllocStringLen(edTargetDirectory_Buffer, length(tmpWideString)*sizeof(WideChar) + 1);
   edTargetDirectory_Buffer:= PWideChar(tmpWideString);
   edTargetDirectory.SetTextBuf(edTargetDirectory_Buffer);
  except
   SysFreeString(edTargetDirectory_Buffer);
  end;
 end;

end;

end.
