unit unEditInputParams_Task1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IOUtils, ActiveX,
  unTaskSource;

type
  TformEditParams_Task1 = class(TForm)
    Label1: TLabel;
    edMask: TEdit;
    Label2: TLabel;
    edTargetDirectory: TEdit;
    btbRunTask: TButton;
    odTargetDirectory: TOpenDialog;
    Label3: TLabel;
    edResultFile: TEdit;
    chkbTypeResultOutput: TCheckBox;
    procedure btbRunTaskClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formEditParams_Task1: TformEditParams_Task1;


implementation

{$R *.dfm}

procedure TformEditParams_Task1.btbRunTaskClick(Sender: TObject);
var
  tmpWideString: WideString;
  tmpPWideChar: PWideChar;
  tmpWord: word;
begin
try
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

  Task1_Parameters.inputParam4:= true; //(chkbTypeResultOutput.Checked);
  Task1_Parameters.inputParam5:= 0; //--- это номер задачи в списке согласно очерёдности запуска в главном модуле

  Close;
finally
// FreeMem(tmpPWideChar);
end;
end;


procedure TformEditParams_Task1.FormShow(Sender: TObject);
begin
// btbRunTaskClick(Sender);
end;

end.
