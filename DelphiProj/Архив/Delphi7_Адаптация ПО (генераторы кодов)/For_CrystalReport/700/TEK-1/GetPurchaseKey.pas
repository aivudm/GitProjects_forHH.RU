unit GetPurchaseKey;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, FileCtrl;

const
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
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ComboBox1: TComboBox;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Edit2: TEdit;
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
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ButtonStopPressed: boolean = false;
  UncryptTable, DecimalRest: PChar;
  DWBufferResult: dword;
  BoolResult: boolean;
  UncryptPart, LoadingUnlockCode: pchar;
  MyStrFormat, StrUncryptPart : string;
  UnCryptTableSize: DWord;

implementation

//##################### InitPointerVariables ####################
procedure InitPointerVariables;
begin
try
 GetMem(UncryptTable, UnCryptTableSize);
 GetMem(DecimalRest, 4);
 GetMem(UncryptPart, 11);
 GetMem(LoadingUnlockCode, 11);
except
 FreeMem(UncryptTable, UnCryptTableSize+48);
 FreeMem(DecimalRest, 4+48);
 FreeMem(UncryptPart, 11+48);
 FreeMem(LoadingUnlockCode, 11+48);
 Application.Terminate;
end;
end;

//############### DeInitPointerVariables ###########################
procedure DeInitPointerVariables;
begin
try
 FreeMem(UncryptTable);
 FreeMem(DecimalRest);
 FreeMem(UncryptPart);
 FreeMem(LoadingUnlockCode);
except
 Application.Terminate;
end;
end;

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
       mov edi, UncryptTable
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

procedure MywsprintfA;
begin
asm
 push edi
 push edx
 mov edi, eax  // 1 parameter
 mov eax, edx    // 3 parameter
 xor edx, edx
 xor ecx, ecx
 mov cl, 100
 idiv ecx
 add al, 30h
 mov byte ptr [edi], al
 inc edi
 mov eax, edx
 xor edx, edx
 xor ecx, ecx
 mov cl, 10
 div ecx
 add al, 30h
 mov byte ptr [edi], al
 inc edi
 add dl, 30h
 mov byte ptr [edi], dl
 inc edi
//-- Set as ASCIIZ
 xor al, al
 mov byte ptr [edi], al

 pop edx
 pop edi
 ret
end;
end;


//################# IsCorrectPurchaseCode ###########################
procedure GetConvertPurchaseCode;
begin
asm
push  ebp
// ----- Uncrypter_6510 -----------
  mov   ebx, UncryptTable
  movzx	ecx, MaxLenLoadingUnlockCodeToUncrypt
  xor	eax, eax
  mov	edx, ecx
  dec	ecx
  test	edx, edx
  jle	@@loc_1000654B
  mov	esi, UncryptPart
  lea	edi, [ecx+1]

@@loc_10006526:

  movzx	dx, byte ptr [esi]
  xor	ecx, ecx
  mov	cl, ah
  xor	ecx, edx
  xor	edx, edx
  and	ecx, 0FFFFh
  mov	dh, al
  inc	esi
  mov	ax, ebx[ecx*2]
  xor	ax, dx
  dec	edi
  jnz	@@loc_10006526

@@loc_1000654B:

  not	eax

// Part 2
 and	eax, 0000FFFFh
 xor	edx, edx
 mov	ecx, 3E8h
 div	ecx
 mov	eax, DecimalRest
 call	MywsprintfA // 1 param - eax, 2 param - edx

 mov	eax, LoadingUnlockCode
 mov	edi, UncryptPart
 mov    esi, edi
 mov    ebx, DecimalRest
 mov	ecx, [eax]
 mov	dword ptr [edi], ecx
 mov	cl, [ebx]
 mov	edx, [eax+4]
 mov	[edi+3], cl
 mov	dword ptr [edi+4], edx
 mov	dl, [ebx+1]
 mov	eax, [eax+8]
 mov	ecx, 0Ch
 mov	[edi+8], eax
 mov	al, [ebx+2]
 mov	byte ptr [edi+9], dl
 xor	edx, edx
 mov	[edi+4], al
 mov    [edi+10], dl
{ mov	eax, edx
 mov    ecx, 0Ch
 rep cmpsb
 setz	al
//--- this function have inverse condition
 test al, al
 jz @@MakeNotZero
 xor al, al
 jmp @@Exit
@@MakeNotZero:
 inc al
@@Exit:
 mov PCharResult, al
}
pop  ebp
end;
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
   MyWorkFileName: string;
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
//--- make buffer ----
UnCryptTableSize:= SizeUncryptTable + 1;

try
 GetMem(UncryptTable, UnCryptTableSize);
 GetMem(DecimalRest, 4);
 GetMem(UncryptPart, 11);
 GetMem(LoadingUnlockCode, 11);
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
  Application.Terminate;
 end;
except
 FreeMem(UncryptTable, UnCryptTableSize);
 FreeMem(DecimalRest, 4);
 FreeMem(UncryptPart, 11);
 FreeMem(LoadingUnlockCode, 11);
 Application.Terminate;
end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
   i: byte;
   IntLoadingUnlockCode, IntLabel5: longint;
   UncryptUnlockCode, StrLoadingUnlockCode: string;
begin
 MessageDlg('process of searching for can occupy plenty of time !',
            mtInformation,[mbOK],0);
Form1.ListBox1.Clear;
ButtonStopPressed:= false;

//--------- Begin value for LoadingUnlockCode ----
LoadingUnlockCode:= '';
if Form1.RadioButton1.Checked then
 for i:= 1 to MaxLenLoadingUnlockCode do
  StrLoadingUnlockCode:= StrLoadingUnlockCode + IntToStr(Random(10));
if Form1.RadioButton2.Checked then
 StrLoadingUnlockCode:= '0000000000';
//- for debug !!!
//LoadingUnlockCode:= '123456789a';
//--- end debug
LoadingUnlockCode:= PChar(StrLoadingUnlockCode);
IntLoadingUnlockCode:= StrToInt(StrLoadingUnlockCode);
repeat
StrUncryptPart:= LoadingUnlockCode[1] + LoadingUnlockCode[8] +
                LoadingUnlockCode[9] + LoadingUnlockCode[2] +
                LoadingUnlockCode[7] + LoadingUnlockCode[3] +
                LoadingUnlockCode[6];
UncryptPart:= Pchar(StrUncryptPart);
GetConvertPurchaseCode; // Input = LoadingUnlockCode
                        // Output= UncryptPart
 if UncryptPart = LoadingUnlockCode then
  begin
   Form1.ListBox1.Items.Add(LoadingUnlockCode);
   Form1.Label3.Caption:= IntToStr(StrToInt(Form1.Label3.Caption) + 1);
  end;
inc(IntLoadingUnlockCode);
StrLoadingUnlockCode:= IntToStr(IntLoadingUnlockCode);
while length(StrLoadingUnlockCode) < MaxLenLoadingUnlockCode do
 StrLoadingUnlockCode:= '0' + StrLoadingUnlockCode;
//Form1.Label5.Caption:= IntToStr(IntLabel5 + 1);
Application.ProcessMessages;
LoadingUnlockCode:= PChar(StrLoadingUnlockCode);
until ButtonStopPressed or
      (not (Form1.RadioButton2.Checked {and (LoadingUnlockCode <> '9999999999')}))
      or Form1.RadioButton1.Checked;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 ButtonStopPressed:= true;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
Form1.Edit3.Text:= RegGetValueText(HKEY_LOCAL_MACHINE,
  'software\Seagate Software\Crystal Reports', 'Path');
if  Form1.Edit3.Text= '' then
 Form1.Edit3.Text:= 'c:\';
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

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
DeInitPointerVariables
end;

end.


