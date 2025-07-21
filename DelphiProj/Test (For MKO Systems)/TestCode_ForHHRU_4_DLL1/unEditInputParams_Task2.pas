unit unEditInputParams_Task2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ActiveX,
  unTaskSource;

type
  TformEditParams_Task2 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edPattern: TEdit;
    edTargetFile: TEdit;
    btbRunTask: TButton;
    edResultFile: TEdit;
    chkbTypeResultOutput: TCheckBox;
    odTargetFile: TOpenDialog;
    chkbTypeCase: TCheckBox;
    procedure btbRunTaskClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formEditParams_Task2: TformEditParams_Task2;

implementation

{$R *.dfm}

procedure TformEditParams_Task2.btbRunTaskClick(Sender: TObject);
var
  tmpWideString: WideString;
  tmpPWideChar: PWideChar;
  tmpWord: word;
begin
try
//  GetMem(tmpPWideChar, tmpWord + 1);
  tmpWord:= edPattern.GetTextLen + 1;

{  ShowMessage('Внутри formEditParams_Task2.btbRunTaskClick'
                + #13#10 + 'edPattern.GetTextLen + 1 = ' + IntToStr(tmpWord));
}
  SysReAllocStringLen(Task2_Parameters.inputParam1, Task2_Parameters.inputParam1, tmpWord);
  edPattern.GetTextBuf(Task2_Parameters.inputParam1, tmpWord);
  tmpWord:= edTargetFile.GetTextLen + 1;
  SysReAllocStringLen(Task2_Parameters.inputParam2, Task2_Parameters.inputParam2, tmpWord);
  edTargetFile.GetTextBuf(Task2_Parameters.inputParam2, tmpWord);
  tmpWord:= edResultFile.GetTextLen + 1;
  SysReAllocStringLen(Task2_Parameters.inputParam3, Task2_Parameters.inputParam3, tmpWord);
  edResultFile.GetTextBuf(Task2_Parameters.inputParam3, tmpWord);

  Task2_Parameters.inputParam4:= true; //(chkbTypeResultOutput.Checked);
  Task2_Parameters.inputParam5:= 1; //--- это номер задачи в списке согласно очерёдности запуска в главном модуле

  Close;
finally
// FreeMem(tmpPWideChar);
end;

end;

end.
