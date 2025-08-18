unit unEditInputParams_Task2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ActiveX,
  unTaskSource, Vcl.Buttons, IOUtils;

type
  TformEditParams_Task2 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    lbResultFile: TLabel;
    edPattern: TEdit;
    edTargetFile: TEdit;
    btbRunTask: TButton;
    edResultFile: TEdit;
    chkbTypeResultOutput: TCheckBox;
    chkbTypeCase: TCheckBox;
    bbOpenFile: TBitBtn;
    procedure btbRunTaskClick(Sender: TObject);
    procedure bbOpenFileClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure chkbTypeResultOutputClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
   TaskSourceListIndex: word;
  end;

var
  formEditParams_Task2: TformEditParams_Task2;
  edTargetFile_Buffer: PWideChar;

implementation
uses unVariables;
{$R *.dfm}

procedure TformEditParams_Task2.bbOpenFileClick(Sender: TObject);
var
  tmpWideString: WideString;
begin
 if SelectFile(Handle, wsTask2_Name, wsTask2_DefaultDirectory, tmpWideString) then
 begin
  setlength(tmpWideString, length(tmpWideString) + 1);
  try
   SysAllocStringLen(edTargetFile_Buffer, length(tmpWideString)*sizeof(WideChar) + 1);
   edTargetFile_Buffer:= PWideChar(tmpWideString);
   edTargetFile.SetTextBuf(edTargetFile_Buffer);
  except
   SysFreeString(edTargetFile_Buffer);
  end;
 end;
end;

procedure TformEditParams_Task2.btbRunTaskClick(Sender: TObject);
var
  tmpWideString: WideString;
  tmpPWideChar: PWideChar;
  tmpWord: word;
begin
try
 if not TFile.Exists(edTargetFile.Text) then
 begin
  TaskSourceList[TaskSourceListIndex].StringStream_Log.WriteString(wsResultStreamTitle +
                               wsCRLF +
                               format(wsTask1_TargetFileNotFound, [edTargetFile.Text]) +
                               ' (TformEditParams_Task2.btbRunTaskClick, unformEditParams_Task2)');
  showmessage(wsTask1_TargetFileNotFound);
  exit;
 end;

//  GetMem(tmpPWideChar, tmpWord + 1);
  tmpWord:= edPattern.GetTextLen + 1;
  SysReAllocStringLen(Task2_Parameters.inputParam1, Task2_Parameters.inputParam1, tmpWord);
  edPattern.GetTextBuf(Task2_Parameters.inputParam1, tmpWord);
  tmpWord:= edTargetFile.GetTextLen + 1;
  SysReAllocStringLen(Task2_Parameters.inputParam2, Task2_Parameters.inputParam2, tmpWord);
  edTargetFile.GetTextBuf(Task2_Parameters.inputParam2, tmpWord);
  tmpWord:= edResultFile.GetTextLen + 1;
  SysReAllocStringLen(Task2_Parameters.inputParam3, Task2_Parameters.inputParam3, tmpWord);
  edResultFile.GetTextBuf(Task2_Parameters.inputParam3, tmpWord);

  Task2_Parameters.inputParam4:= chkbTypeResultOutput.Checked; //(chkbTypeResultOutput.Checked);
  Task2_Parameters.inputParam5:= 1; //--- это номер задачи в списке согласно очерёдности запуска в главном модуле

  Close;
finally
// FreeMem(tmpPWideChar);
end;

end;

procedure TformEditParams_Task2.chkbTypeResultOutputClick(Sender: TObject);
begin
 lbResultFile.Visible:= (Sender as TCheckBox).Checked;
 edResultFile.Visible:= (Sender as TCheckBox).Checked;
end;

procedure TformEditParams_Task2.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   SysFreeString(edTargetFile_Buffer);
end;

end.
