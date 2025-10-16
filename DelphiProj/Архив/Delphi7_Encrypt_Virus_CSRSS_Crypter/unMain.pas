unit unMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ToolWin;

type
  TformMain = class(TForm)
    MainMenu1: TMainMenu;
    sbMain: TStatusBar;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    File1: TMenuItem;
    Open1: TMenuItem;
    Exit1: TMenuItem;
    OpenDialog1: TOpenDialog;
    procedure Exit1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ToolButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formMain: TformMain;

implementation
uses unConstant, unUtils, unUtilFiles, unConstantFiles, unVariables;
{$R *.dfm}

procedure TformMain.Exit1Click(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TformMain.FormShow(Sender: TObject);
begin
 sbMain.Panels[1].Text:= EncryptKey;
 sbMain.Panels[3].Text:= CryptedBodyFile;
end;

procedure TformMain.ToolButton1Click(Sender: TObject);
var
 pBuffer: pchar;
begin
 try
  workingFileName:= GetCurrentDir + DOSPathDelemiter + 'data' + DOSPathDelemiter + CryptedBodyFile;
  iFileSize:= MyGetFileSize(workingFileName);
  iKeyLength:= Length(EncryptKey);
  iBufferSize:= (iFileSize * 2) + (iKeyLength * 2);

  GetMem(pBuffer, iBufferSize);
 if OpenFileToMemory(workingFileName, pBuffer, MyGetFileSize(workingFileName)) then
 begin
  EncryptByteArray(pBuffer, MyGetFileSize(workingFileName), EncryptKey);
  SaveFileFromMemory(workingFileName + '.encrypt', pBuffer, iBufferSize);
 end
 else  ShowMessage('OpenFileToMemory() отработал с ошибками - файл ' + workingFileName);
 finally
  FreeMem(pBuffer);
 end;
end;

end.
