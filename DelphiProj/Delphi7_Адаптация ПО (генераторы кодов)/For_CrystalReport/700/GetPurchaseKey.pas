unit GetPurchaseKey;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, FileCtrl, IniFiles;

const
     NameINIFile = 'PurchaseCode.ini';
     BeginFile= 0;
     SupportDLL = 'c2supprt.dll';
     PosInFileUncryprTable: dword = $24E50;
     SizeUncryptTable: dword = 1*1024;
//------ For Setup ---------------
     MaxLenSetupUnlockCode: byte = 11;
     MaxLenSetupUnlockCodePart2: byte = 7;
     SetupDivisionConst: byte = $2A;
     SetupTypeUnlockCode: array [1..11] of string = ('Standart', 'Professional', 'Information',
                          'Pilot', 'Evaluation', 'Profession Sub', 'Professional Upgrade', 'Profissional Sub Upgrade', 'Standart Upgrade', 'Not for Sale',
                          'OEM');
//------ For Loading Purchase ---------------
     MaxLenLoadingUnlockCode: byte = 10;
     MaxLenLoadingUnlockCodeToUncrypt: byte = 7;
     LoadingDivisionConst: byte = $2A;

{     LoadingUncryptTable: array [1..116] of byte = (0, 0, $21, $10,     //{4}
{     		  $42, $20, $63, $30, $84, $40, $0A5, $50, $0C6,        //{13}
{                  $60, $0E7, $70, $8, $81, $29, $91, $4A, $0A1, $6B,    //{23}
{                  $0B1, $8C, $0C1, $0AD, $0D1, $0CE, $0E1, $0EF, $0F1,  //{32}
{                  $31, $12, $10, $2, $73, $32, $52, $22, $B5, $52,      //{42}
{                  $94, $42, $0F7, $72, $0D6, $62, $39, $93, $18, $83,   //{52}
{                  $7B, $0B3, $5A, $0A3, $0BD, $0D3, $9C, $0C3, $0FF,    //{61}
{                  $0F3, $0DE, $0E3, $62, $24, $43, $34, $20, $4,        //{70}
{                  $1, $14, $0E6, $64, $0C7, $74, $0A4, $44, $85, $54,   //{80}
{                  $6A, $0A5, $4B, $0B5, $28, $85, $9, $95, $0EE, $0E5,  //{90}
{                  $0CF, $0F5, $0AC, $0C5, $8D, $0D5, $53, $36, $72,     //{99}
{                  $26, $11, $16, $30, $6, $0D7, $76, $0F6, $66, $95,    //{109}
{                  $56, $0B4, $46, $5B, $0B7, $7A, $0A7);                 //{116}


type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    Button1: TButton;
    ListBox1: TListBox;
    Button2: TButton;
    GroupBox2: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label2: TLabel;
    Label3: TLabel;
    TabSheet3: TTabSheet;
    GroupBox3: TGroupBox;
    Button3: TButton;
    Button4: TButton;
    Edit3: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit4: TEdit;
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UncryptTable: array [0..1*1024+1] of byte;
  Form1: TForm1;
  ButtonStopPressed: boolean = false;
  DecimalRest: string;
  UnCryptTableSize: DWord;
  UncryptPart: string;
  DWResult: dword;
  IniFile:TIniFile;
  LoadingUnlockCode: string;
  UncryptTableIsCreated: boolean = false;
  MyWorkFileName: string;
implementation

//##################### FileOpenReadWrite ################################
function FileOpenReadWrite(MyFileName: string; Mode: Integer): Integer;
begin
if Mode=fmOpenRead then
  Result := CreateFile(PChar(MyFileName), GENERIC_READ,
     FILE_SHARE_READ, nil, OPEN_EXISTING,
     FILE_SHARE_READ,0);
if Mode=fmOpenWrite then
  Result := CreateFile(PChar(MyFileName), GENERIC_WRITE,
     FILE_SHARE_WRITE, nil, OPEN_EXISTING,
     FILE_SHARE_WRITE,0);

end;

//######################### GetUnCryptTable ############
function  GetUnCryptTable(var MyNameFile: string;
                           MyPosInFile, MyUnCryptTableSize: dword): dword;
var
   MyFileHandle, PositionInFile, ActualReaded: integer;
begin
Result:= 0;
 try
  MyFileHandle:= FileOpenReadWrite(MyNameFile, FmOpenRead);
  if MyFileHandle>0 then
   begin
    PositionInFile:=FileSeek(MyFileHandle, MyPosInFile, BeginFile);
    if  PositionInFile = MyPosInFile then
     begin
{      ReadFile(MyFileHandle, buffer, SizeUnCryptTSFKey,
               ActualReaded,
               nil);
}
      asm
       xor eax, eax
       push eax
       lea edi, ActualReaded
       push edi
       push MyUnCryptTableSize
       lea edi, UncryptTable
       push edi
       push MyFileHandle
       call ReadFile
      end;

      Result:= ActualReaded;
     end
    else
     MessageDlg('Не возможно установить позицию '+
                IntToStr(MyPosInFile)+#13#10+' in '+MyNameFile,
                mtError,[mbOK],0);
    CloseHandle(MyFileHandle);
   end
  else
   begin
    MessageDlg('Не удается открыть файл !!!'#13#10
               +MyNameFile+#13#10+
               'Windows Say: Error='+IntToStr(GetLastError)+#13#10+
               '['+SysErrorMessage(GetLastError)+']',
               mtError,[mbOK],0);
   end;
 except
  CloseHandle(MyFileHandle);
  MessageDlg('Ошибка ОС '+#13#10+
             'Windows Say: Error='+IntToStr(GetLastError)+#13#10+
             '['+SysErrorMessage(GetLastError)+']',
             mtError,[mbOK],0);
  Application.Terminate;
 end;
end;

function RegGetValueText(My_PHKEY:integer; MyNeedSubKey, MyNeedSubKeyName: String): string;
var
   MyPHKEY, phkResult: integer;
   DataSize: longint;
   MyRegData: PChar;
   DataBuffer: Pointer;
   MySizeRegValue: DWord;
begin
  if RegOpenKeyEx(My_PHKEY, PChar(MyNeedSubKey), 0, KEY_ALL_ACCESS, phkResult) = 0 then
  try
    GetMem(DataBuffer, 256);
    DataSize := 257;
    RegQueryValueEx(phkResult, PChar(MyNeedSubKeyName), nil, nil , DataBuffer, @DataSize);
    Result:= StrPas(DataBuffer);
  finally
    RegCloseKey(phkResult);
    FreeMem(DataBuffer, 256);
  end;
end;


function Uncrypter_6510(MyUncryptPart: string; MyMaxLenLoadingUnlockCodeToUncrypt:byte): dword;
var
   i: integer;
   TekByte, TekPoint, TekCombination: word;
begin
Result:= 0;
if MyMaxLenLoadingUnlockCodeToUncrypt <> 0 then
 begin
  i:= 1;
  TekCombination:= 0;
  while i<= MyMaxLenLoadingUnlockCodeToUncrypt do
   begin
// TekByte = DX
// TekCombination = AX
// TekPoint = CX
    TekByte:= byte(UncryptPart[i]);
    TekPoint:= 0;
//---  mov cl, ah
    TekPoint:= (TekCombination and $FF00) shr 8;
//----------------
    TekPoint:= TekPoint xor TekByte;
    TekByte:= 0;
//-----  mov	dh, al
    TekByte:= TekCombination and $00FF;
    TekByte:= TekByte shl 8;
//--------------------------
//--  mov ax, ebx[ecx*2]
    TekCombination:= UncryptTable[TekPoint*2+1];
    TekCombination:= TekCombination shl 8;
    TekCombination:= TekCombination or UncryptTable[TekPoint*2];

//-----------------------
    TekCombination:= TekCombination xor TekByte;
    inc(i);
   end;
  Result:= not(TekCombination);
 end;
end;

function DWToDecimalString(MyDWValue: dword): string;
begin
Result:= IntToStr(MyDWValue div 100);
MyDWValue:= MyDWValue mod 100;
Result:= Result + IntToStr(MyDWValue div 10);
Result:= Result + IntToStr(MyDWValue mod 10);
end;

//################# IsCorrectPurchaseCode ###########################
function IsCorrectPurchaseCode(MyLoadingUnlockCode: string): boolean;
var
   DecimalRest: string;
begin
UncryptPart:=   MyLoadingUnlockCode[1] + MyLoadingUnlockCode[8] +
                MyLoadingUnlockCode[9] + MyLoadingUnlockCode[2] +
                MyLoadingUnlockCode[7] + MyLoadingUnlockCode[3] +
                MyLoadingUnlockCode[6];
DWResult:= Uncrypter_6510(UncryptPart, MaxLenLoadingUnlockCodeToUncrypt);
DWResult:= DWResult mod $3E8;   // 1000
DecimalRest:= DWToDecimalString(DWResult);

UncryptPart:= copy(MyLoadingUnlockCode, 1, 3);
UncryptPart:= UncryptPart + DecimalRest[1];
UncryptPart:= UncryptPart + copy(MyLoadingUnlockCode, 5, 6);
UncryptPart[10]:= DecimalRest[2];
UncryptPart[5]:= DecimalRest[3];
Result:= (UncryptPart = MyLoadingUnlockCode);
end;

{$R *.DFM}
procedure TForm1.ComboBox1Change(Sender: TObject);
var
   i: byte;
   PartSetupUnlockCode: string;
   SetupUnlockCode: integer;
begin
//---------- Part1 ------------
PartSetupUnlockCode:= IntToStr(Form1.ComboBox1.Items.IndexOf(Form1.ComboBox1.Text));
if PartSetupUnlockCode= '0' then
 PartSetupUnlockCode:= '1';
while length(PartSetupUnlockCode) < 3 do
 PartSetupUnlockCode:= '0' + PartSetupUnlockCode;
PartSetupUnlockCode:= '70' + PartSetupUnlockCode;
Form1.Edit1.Text:= PartSetupUnlockCode;

//---------- Part2 ------------
PartSetupUnlockCode:= '';
for i:= 1 to MaxLenSetupUnlockCodePart2 do
 PartSetupUnlockCode:= PartSetupUnlockCode + IntToStr(Random(10));

SetupUnlockCode:= StrToInt(Form1.Edit1.Text) + StrToInt(PartSetupUnlockCode);
SetupUnlockCode:= trunc(SetupUnlockCode/ SetupDivisionConst)+1;
PartSetupUnlockCode:= IntToStr((SetupUnlockCode*SetupDivisionConst) - StrToInt(Form1.Edit1.Text));
while length(PartSetupUnlockCode) <> MaxLenSetupUnlockCodePart2 do
 PartSetupUnlockCode:= '0' + PartSetupUnlockCode;
Form1.Edit2.Text:=  PartSetupUnlockCode;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
   i: byte;
begin
for i:= 1 to MaxLenSetupUnlockCode do
 begin
  Form1.ComboBox1.Items.Add(SetupTypeUnlockCode[i]);
 end;
Form1.Edit1.Text:= '';
Form1.Edit2.Text:= '';

Form1.ListBox1.Clear;
Form1.RadioButton1.Checked:= true;
// --- Get from registry path to Crystal Report directory
Form1.Button4Click(Sender);
Form1.Button3.Enabled:= false;
IniFile:=TIniFile.Create(ExtractFilePath(Application.EXEName) + NameINIFile);
Form1.Edit4.Text:= IniFile.ReadString('NoName','LastPosition','0');

Form1.PageControl1.ActivePage:= TabSheet1;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
   i: longint;
   TmpString: string;
   FlagFound: boolean;
begin
 MessageDlg('process of searching for can occupy plenty of time !',
            mtInformation,[mbOK],0);
Form1.ListBox1.Clear;
ButtonStopPressed:= false;

//--------- Begin value for LoadingUnlockCode ----
LoadingUnlockCode:= '';
if Form1.RadioButton1.Checked then
 for i:= 1 to MaxLenLoadingUnlockCode do
  LoadingUnlockCode:= LoadingUnlockCode + IntToStr(Random(10));
if Form1.RadioButton2.Checked then
 begin
  LoadingUnlockCode:= Form1.Edit4.Text;
  while length(LoadingUnlockCode) < MaxLenLoadingUnlockCode do
   LoadingUnlockCode:= '0' + LoadingUnlockCode;
 end;

//- for debug !!!
//LoadingUnlockCode:= '123456789a';
//--- end debug
FlagFound:= false;
i:= 0;
repeat
 if IsCorrectPurchaseCode(LoadingUnlockCode) then
  begin
   Form1.ListBox1.Items.Add(LoadingUnlockCode);
   Form1.Label3.Caption:= IntToStr(StrToInt(Form1.Label3.Caption) + 1);
   FlagFound:= true;
  end;

LoadingUnlockCode:= IntToStr(StrToInt(LoadingUnlockCode)+1);
while length(LoadingUnlockCode) < MaxLenLoadingUnlockCode do
 LoadingUnlockCode:= '0' + LoadingUnlockCode;
Form1.Label5.Caption:= IntToStr(StrToInt(Form1.Label5.Caption) + 1);
if (i+1000) < StrToInt(Form1.Label5.Caption) then
 begin
  i:= StrToInt(Form1.Label5.Caption);
  Application.ProcessMessages;
 end;

until ButtonStopPressed or
      (Form1.RadioButton2.Checked and (LoadingUnlockCode = Replace('9', MaxLenLoadingUnlockCode))
      or (Form1.RadioButton1.Checked and FlagFound);
if ButtonStopPressed then
  MessageDlg('Terminate by user...',
             mtInformation,[mbOK],0);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 ButtonStopPressed:= true;
 Form1.Edit4.Text:= LoadingUnlockCode;
 IniFile.WriteString('NoName', 'LastPosition', Form1.Edit4.Text);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
Form1.Edit3.Text:= RegGetValueText(HKEY_LOCAL_MACHINE,
  'software\Seagate Software\Crystal Reports', 'Path');
if  Form1.Edit3.Text= '' then
 Form1.Edit3.Text:= 'Not installed...';
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
try
 ChDir(Form1.Edit3.Text);
 Form1.Button3.Enabled:= false;
except
 Form1.Button4Click(Sender);
 Form1.Button3.Enabled:= false;
end;
end;

procedure TForm1.Edit3Change(Sender: TObject);
begin
Form1.Button3.Enabled:= true;
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
if (Form1.PageControl1.ActivePage = TabSheet2) and
    not UncryptTableIsCreated then
 begin
//--- make buffer ----
  UnCryptTableSize:= SizeUncryptTable + 1;

//--- Get uncrypt table from
  if Form1.Edit3.Text[length(Form1.Edit3.Text)] <> '\' then
   Form1.Edit3.Text:= Form1.Edit3.Text + '\';
  MyWorkFileName:= Form1.Edit3.Text + SupportDLL;
  if GetUnCryptTable(MyWorkFileName, PosInFileUncryprTable,
                SizeUncryptTable) < SizeUncryptTable then
   begin
    MessageDlg('Uncrypt table is corrupt, '+#13#10+
              'application terminate...',
             mtError,[mbOK],0);
    Form1.PageControl1.ActivePage:= TabSheet3;
   end
  else
   UncryptTableIsCreated:= true;
 end;

 if Form1.RadioButton2.Checked then
  Form1.Edit4.Enabled:= true
 else
  Form1.Edit4.Enabled:= false;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 IniFile.WriteString('NoName', 'LastPosition', Form1.Edit4.Text);
end;

end.


