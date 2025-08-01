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
    FileCrypt1: TMenuItem;
    Saveas1: TMenuItem;
    Exit2: TMenuItem;
    SaveDialog1: TSaveDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    RichEdit1: TRichEdit;
    Memo1: TMemo;
    procedure Exit1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure OpenLast1Click(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
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
     form1.RichEdit1.Lines.Add('*******�������� � ' + IntToStr(numCurrentTSFParam) + ' {' + arrayNameTSFParam[numCurrentTSFParam] + '}')
    else
     form1.RichEdit1.Lines.Add('*******�������� � ' + IntToStr(numCurrentTSFParam));

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
      form1.Memo1.Lines.LoadFromFile(WorkingFileName);
      flCryptFileIsOpened:= true;
      form1.Memo1.Visible:= true;
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
// ��������� VisualComponents
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
if form1.PageControl1.ActivePage = TabSheet2 then
 begin
  if MakeCloseMemoText then
   begin
    form1.Memo1.Clear;
    form1.Memo1.Visible:= false;
    flCryptFileIsOpened:= false;
   end;
 end;
Form1.PageControl1Change(Sender);
end;

procedure TForm1.OpenLast1Click(Sender: TObject);
begin
WorkingFileName:= Inifile.ReadString('File', 'TSFFileName', WorkingFileName);
CryptFileName:= Inifile.ReadString('File', 'CryptFileName', CryptFileName);
try
 form1.ProgressBar1.Visible:= true;
 form1.ProgressBar1.Max:= TSFParamCount;
 form1.ProgressBar1.Position:= 0;
 form1.Label1.Visible:= true;
 if (form1.PageControl1.ActivePage = TabSheet1) and
     FileExists(WorkingFileName) then
  begin
   form1.RichEdit1.Visible:= false;
   if GetTextFromTSF(WorkingFileName) then
    begin
     flTSFFileIsOpened:= true;
     form1.RichEdit1.Visible:= true;
     form1.CheckBox1.Visible:= true;
     form1.ProgressBar1.Visible:= false;
     form1.Label1.Visible:= false;
   end;
  end;

 if (form1.PageControl1.ActivePage = TabSheet2) and
     FileExists(CryptFileName) then
  begin
   form1.Memo1.Visible:= false;
   form1.Memo1.Lines.LoadFromFile(CryptFileName);
   flCryptFileIsOpened:= true;
   form1.Memo1.Visible:= true;
   form1.CheckBox1.Visible:= true;
   form1.ProgressBar1.Visible:= false;
   form1.Label1.Visible:= false;
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

procedure TForm1.Saveas1Click(Sender: TObject);
var
   tmpStr: string;
   tmpPCHAR: Pchar;
begin
 form1.SaveDialog1.InitialDir:= ExtractFilePath(Application.EXEName);
 form1.SaveDialog1.DefaultExt:= '.tsf';
 form1.SaveDialog1.Execute;
if ExtractFileExt(form1.SaveDialog1.FileName) = '.tsf' then
 begin
  try
   GetMem(tmpPCHAR, form1.Memo1.GetTextLen + 1);
   form1.Memo1.GetTextBuf(tmpPCHAR, form1.Memo1.GetTextLen);
   tmpStr:= CryptToTSFFormat(StrPas(tmpPCHAR));
   tmpPCHAR:= pchar(tmpStr);
   SaveFileFromMemory(form1.SaveDialog1.FileName, tmpPCHAR, form1.Memo1.GetTextLen);
  except
   FreeMem(tmpPCHAR);
  end;
 end
else
 begin
  if form1.SaveDialog1.FileName <> '' then
   form1.Memo1.Lines.SaveToFile(form1.SaveDialog1.FileName);
 end;
end;

function MakeCloseMemoText: boolean;
var
   ModRes: integer;
begin
result:= true;
if form1.Memo1.Modified then
 begin
  ModRes:= MessageDlg('In Crypt window text has been changed. Save it?',
              mtConfirmation, mbYesNoCancel, 0);
  if ModRes = 2 then  //mbCancel
   begin
    result:= false;
    exit;
   end;

  if ModRes = 6 then // mbYes
   if CryptFileName <> '' then
    begin
     form1.Memo1.Lines.SaveToFile(CryptFileName);
    end
   else
    begin
     form1.SaveDialog1.InitialDir:= ExtractFilePath(Application.EXEName);
     form1.SaveDialog1.Execute;
     if form1.SaveDialog1.FileName <> '' then
      begin
       form1.Memo1.Lines.SaveToFile(form1.SaveDialog1.FileName);
      end;
    end;
 end;
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
with form1.MainMenu1 do
 begin
  if form1.PageControl1.ActivePage = TabSheet1 then
   begin
    Close1.Enabled:= flTSFFileIsOpened;
    FileCrypt1.Visible:= false;
   end;

  if form1.PageControl1.ActivePage = TabSheet2 then
   begin
    Close1.Enabled:= flCryptFileIsOpened;
    FileCrypt1.Visible:= true;
    FileCrypt1.Enabled:= flCryptFileIsOpened;
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
  end;
 end;

if form1.PageControl1.ActivePage = TabSheet2 then
 begin
 if FileExists(CryptFileName) then
  begin
   form1.StatusBar1.Panels[1].Text:= CryptFileName;
   form1.StatusBar1.Enabled:= true;
   with form1.MainMenu1 do
    begin
     OpenLast1.Visible:= not flCryptFileIsOpened;
    end;
  end
 else
  begin
   form1.StatusBar1.Panels[1].Text:= 'not selected';
   form1.StatusBar1.Enabled:= false;
  end;
 end;
end;

end.
