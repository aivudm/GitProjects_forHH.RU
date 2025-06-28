unit PasTSFReader;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, IniFiles, ConstTSFReader, ComCtrls, extctrls;

type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Close1: TMenuItem;
    Exit1: TMenuItem;
    StatusBar1: TStatusBar;
    CheckBox1: TCheckBox;
    OpenDialog1: TOpenDialog;
    ProgressBar1: TProgressBar;
    Label1: TLabel;
    OpenLast1: TMenuItem;
    N1: TMenuItem;
    Exit2: TMenuItem;
    SaveDialog1: TSaveDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    RichEdit1: TRichEdit;
    procedure Exit1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure OpenLast1Click(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
//  Timer1: TTimer;
  WorkingFileName: string;
  IniFile: TIniFile;
  flTSFFileIsOpened: boolean = false;
  flCryptFileIsOpened: boolean = false;
  CryptFileName: string;

function GetTextFromTSF(MyTSFFileName: string): boolean;
function GetTSFVariableAsText(MyTSFFileName: string; MyNumberTSFParam: dword): string;
function MakeCloseMemoText: boolean;

implementation

{$R *.DFM}
procedure SetDefaultRichEditFont(MyRichEdit: TRichEdit);
begin
 MyRichEdit.SelAttributes.Size:= 10;
 MyRichEdit.SelAttributes.Color:= clBlack;
 MyRichEdit.SelAttributes.Style:= [];
end;

function GetTSFVariableAsText(MyTSFFileName: string; MyNumberTSFParam: dword): string;
var
  UniversalZero: dword;
  UnCryptTSFKey: string;
begin
try
 UnCryptTSFKey:= GetInternalUnCryptTSFKey(MyTSFFileName);
 GetMem(lpTSFParam, arraySizeTSFParam[MyNumberTSFParam] +1);
if GetVariableFromTSFFile(MyTSFFileName,
                          arrayOffsetTSFParam[MyNumberTSFParam],
                          arraySizeTSFParam[MyNumberTSFParam]
                          ) = arraySizeTSFParam[MyNumberTSFParam] then
 begin
  UniversalZero:= $0000;
  result:= StrPas(lpTSFParam);
  result:= UnCrypter(result, UnCryptTSFKey,
                            UniversalZero);
 end
finally
 freeMem(lpTSFParam);
end;
end;

function GetTextFromTSF(MyTSFFileName: string): boolean;
VAR
   numCurrentTSFParam: dword;
   tmpStr: string;
begin
try
 result:= false;
 for numCurrentTSFParam:= 1 to TSFParamCount do
  begin
    SetDefaultRichEditFont(form1.RichEdit1);

    form1.RichEdit1.SelAttributes.Color:= clBlue;
    form1.RichEdit1.SelAttributes.Size:= 12;
    form1.RichEdit1.SelAttributes.Style:= form1.RichEdit1.SelAttributes.Style + [fsBold];

    if arrayNameTSFParam[numCurrentTSFParam] <> '' then
     form1.RichEdit1.Lines.Add('*******Parameter № ' + IntToStr(numCurrentTSFParam) + ' {' + arrayNameTSFParam[numCurrentTSFParam] + '}')
    else
     form1.RichEdit1.Lines.Add('*******Parameter № ' + IntToStr(numCurrentTSFParam));

    SetDefaultRichEditFont(form1.RichEdit1);
    tmpStr:= GetTSFVariableAsText(MyTSFFileName, numCurrentTSFParam);
    form1.RichEdit1.Lines.Add(tmpStr);
    form1.ProgressBar1.Position:= numCurrentTSFParam;
  end;
result:= true;
except
 result:= false;
end;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
form1.Exit2Click(Sender);
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
 form1.ProgressBar1.Visible:= true;
 form1.ProgressBar1.Max:= TSFParamCount;
 form1.ProgressBar1.Position:= 0;
 form1.Label1.Visible:= true;
 form1.RichEdit1.Visible:= false;
 form1.OpenDialog1.InitialDir:='c:\';
 form1.OpenDialog1.FileName:='';
 form1.OpenDialog1.Execute;
 Form1.Update;
if FileExists(Form1.OpenDialog1.FileName) then
 begin
   WorkingFileName:= OpenDialog1.FileName;
   if form1.PageControl1.ActivePage = TabSheet1 then
    begin
     Inifile.WriteString('File', 'TSFFileName', WorkingFileName);
     try
      if GetTextFromTSF(WorkingFileName) then
       begin
        flTSFFileIsOpened:= true;
        form1.RichEdit1.Visible:= true;
        form1.CheckBox1.Visible:= true;
        form1.ProgressBar1.Visible:= false;
        form1.Label1.Visible:= false;
       end;
     except
      form1.ProgressBar1.Visible:= false;
      form1.Label1.Visible:= false;
     end;
    end
   else
    begin
     Inifile.WriteString('File', 'CryptTSFFileName', WorkingFileName);
     try
      flCryptFileIsOpened:= true;
      form1.CheckBox1.Visible:= true;
      form1.ProgressBar1.Visible:= false;
      form1.Label1.Visible:= false;
     except
      form1.ProgressBar1.Visible:= false;
      form1.Label1.Visible:= false;
     end;
    end;
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
   PathBuffer: PChar;
   NameFileTSF: string;
begin
try
// Get RootPath Windows
 GetMem(PathBuffer, MaxLengthDOSPath);
 GetWindowsDirectory(PathBuffer, MaxLengthDOSPath);
 WorkingFileName:= StrPas(PathBuffer);
 if WorkingFileName[length(WorkingFileName)]<>'\' then
  WorkingFileName:= WorkingFileName+'\';
// Get Name TSFFile from .ini
 IniFile:=TIniFile.Create(ExtractFilePath(Application.EXEName) + NameINIFile);
 WorkingFileName:= IniFile.ReadString('File', 'TSFFileName', WorkingFileName + DefaultTSFFileName + DefaultExtentionTSFFile);
 CryptFileName:= IniFile.ReadString('File', 'CryptTSFFileName', '');

 form1.PageControl1Change(Sender);
 finally
  FreeMem(PathBuffer, MaxLengthDOSPath);
 end;
// Настройка VisualComponents
form1.RichEdit1.Lines.Clear;
form1.CheckBox1.Visible:= false;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
if form1.CheckBox1.Checked then
 form1.RichEdit1.WordWrap:= true
else
 form1.RichEdit1.WordWrap:= false;
end;

procedure TForm1.Close1Click(Sender: TObject);
var
   ModRes: integer;
begin
if form1.PageControl1.ActivePage = TabSheet1 then
 begin
  form1.RichEdit1.Clear;
  form1.RichEdit1.Visible:= false;
  form1.CheckBox1.Visible:= false;
  flTSFFileIsOpened:= false;
 end;
Form1.PageControl1Change(Sender);
end;

procedure TForm1.OpenLast1Click(Sender: TObject);
begin
WorkingFileName:= Inifile.ReadString('File', 'TSFFileName', WorkingFileName);
CryptFileName:= Inifile.ReadString('File', 'CryptFileName', CryptFileName);
try
 if (form1.PageControl1.ActivePage = TabSheet1) and
     FileExists(WorkingFileName) then
  begin
   form1.RichEdit1.Visible:= false;
   if GetTextFromTSF(WorkingFileName) then
    begin
     form1.ProgressBar1.Visible:= true;
     form1.ProgressBar1.Max:= TSFParamCount;
     form1.ProgressBar1.Position:= 0;
     form1.Label1.Visible:= true;
     flTSFFileIsOpened:= true;
     form1.RichEdit1.Visible:= true;
     form1.CheckBox1.Visible:= true;
     form1.ProgressBar1.Visible:= false;
     form1.Label1.Visible:= false;
   end;
  end;

 form1.PageControl1Change(Sender);
 except
  with form1.MainMenu1 do
   begin
    OpenLast1.Visible:= false
   end;
 end;
end;

procedure TForm1.Exit2Click(Sender: TObject);
begin
if MakeCloseMemoText then
  application.Terminate;
end;

function MakeCloseMemoText: boolean;
var
   ModRes: integer;
begin
result:= true;
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
with form1.MainMenu1 do
 begin
  if form1.PageControl1.ActivePage = TabSheet1 then
   begin
    Close1.Enabled:= flTSFFileIsOpened;
   end;

  Open1.Enabled:= not Close1.Enabled;
 end;

if form1.PageControl1.ActivePage = TabSheet1 then
 begin
  if FileExists(WorkingFileName) then
  begin
   form1.StatusBar1.Panels[1].Text:= WorkingFileName;
   form1.StatusBar1.Enabled:= true;
   with form1.MainMenu1 do
    begin
     OpenLast1.Visible:= not flTSFFileIsOpened;
    end;
  end
 else
  begin
   form1.StatusBar1.Panels[1].Text:= 'not selected';
   form1.StatusBar1.Enabled:= false;
   OpenLast1.Visible:= false;
  end;
 end;

 end;

end.
