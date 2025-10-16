unit SetLicense;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ComCtrls, IniFiles;

const
     NameINIFile: String = 'DBNTConnect.ini';
type
    TNeedCombination = array [1..11] of Char;
    PNeedCombination = Pointer;
const
     SuffixNewFile: string = '.new';
     CountByteInCombination: DWord = 11;
     OffsToNumUser_ForVers_751: byte = $29;
     OffsToNumUser_ForVers_700: byte = $2A;
     ImageVersion_700: String = '7.0.0';
     ImageVersion_751: String = '7.5.1';
     OffsToTitleInfo_ForVers_751: DWord = $14;
     NeedCombination_Version: TNeedCombination=(Char('M'), Char('E'), Char('C'),
                                        Char('A'), Char('L'), Char('E'),
                                        Char('C'), Char('A'), Char('H'),
                                        Char('I'), Chr(0));
type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    MenuOpen: TMenuItem;
    MenuClose: TMenuItem;
    Exit1: TMenuItem;
    GroupBox1: TGroupBox;
    StatusBar1: TStatusBar;
    Work: TMenuItem;
    OpenDialog1: TOpenDialog;
    MenuSetConnect: TMenuItem;
    MenuOpenLast: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    Edit1: TEdit;
    UpDown1: TUpDown;
    CheckBox1: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    procedure Exit1Click(Sender: TObject);
    procedure MenuOpenClick(Sender: TObject);
    procedure MenuCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuOpenLastClick(Sender: TObject);
    procedure MenuSetConnectClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure SetButtonPostOpenFile;
    procedure SetButtonPostCloseFile;
    function MyGetFileSize(MyFileName:string):LongInt;
    function FileOpenReadWrite(const FileName: string; Mode: Integer): Integer;
    function GetBeginPosForCrack(Buffer: Pointer; MyFileSize: DWord; PCurrentNeedCombination: Pointer): DWord;
    function OpenFileToMemory(MyNameFile: String; Buffer:PChar {Pointer};MySizeOfFile:LongInt): boolean;
    procedure SaveFileFromMemory(MyNameFile: String;Buffer:Pointer;MySizeOfFile:LongInt);
    function SetConnect(MyWorkingFileName: String; MyNumConnect: Byte): boolean;
    procedure MyGetFile(MyWorkingFileName: string);
    function GetVersionSQLServer: string;
    procedure SetTitleInfo(MyPosInFile: DWord; MyNumUser: byte);
  public
    { Public declarations }
  end;
var
  Form1: TForm1;

  WorkingFileName: String;
  FlagError: Boolean = False;
  MyFileHandle: Integer;
  IniFile: TIniFile;
  Buffer: Pointer;
  CurrentFileSize: DWord;
  OffsToNumUser: byte;

function GetNumUser: PChar;
function GetOffsToNumUser(MyVersionSQLServer: String):DWord;
function IsDigit(MyOperand: String):boolean;

implementation

{$R *.DFM}

//####################### IsDigit #####################################
function IsDigit(MyOperand: String):boolean;
begin
asm
 mov Result, 1 // True
 mov esi, MyOperand
@@BeginTest:
 mov al, byte ptr [esi]
 cmp al, 00
 jz @@ExitFromIsDigit
 cmp al, 30h
 jb @@NotDigit
 cmp al, 39h
 ja @@NotDigit
 inc esi
 jmp  @@BeginTest

@@NotDigit:
 mov Result, 0 // False

@@ExitFromIsDigit:

end;
end;

//########################## GetOffsToNumUser ##########################
function GetOffsToNumUser(MyVersionSQLServer: String):DWord;
begin
if MyVersionSQLServer= ImageVersion_700 then
 Result:= OffsToNumUser_ForVers_700;
if MyVersionSQLServer= ImageVersion_751 then
 Result:= OffsToNumUser_ForVers_751;
end;

//#################### SetTitleInfo ###########################
procedure TForm1.SetTitleInfo(MyPosInFile: DWord; MyNumUser: byte);
var
   TmpPChar: PChar;
   TmpString: string;
begin
if Form1.GetVersionSQLServer = ImageVersion_751 then
 begin
  MyPosInFile:= MyPosInFile+ OffsToTitleInfo_ForVers_751;
  asm
   mov eax, MyPosInFile
   add eax, Buffer
   mov TmpPChar, eax
  end;
  TmpString:= copy(TmpPChar, 1, pos('(', TmpPChar));
  case MyNumUser of
   0:  TmpString:= TmpString+'Not Limited)';
   1:  TmpString:= TmpString+ IntToStr(MyNumUser)+' Client)';
   2..255: TmpString:= TmpString+ IntToStr(MyNumUser)+' Clients)';
  end;
// Remove TmpString in Buffer file
  asm
   mov  esi, TmpString
   mov  edi, TmpPChar
 @@BeginRemov:
   mov  al, byte ptr [esi]
   mov byte ptr [edi], al
   inc esi
   inc edi
   test al, al
   jnz @@BeginRemov
  end;
 end;
if Form1.GetVersionSQLServer = ImageVersion_700 then
 begin
 end;
end;

function ConverByteToDigit:PChar; assembler;stdcall;
begin
asm
 push ebp
 mov ebp, esp
 push edi
 mov ebx, [ebp+8]    // first parameter
 mov al, bl
 xor ah, ah
 mov edi, [ebp+0Ch]  // second parameter
 push edi
 mov cl, 100
 div cl
 add al, 30h
 mov byte ptr [edi], al
 inc edi
 mov al, ah
 xor ah, ah
 mov cl, 10
 div cl
 add al, 30h
 mov byte ptr [edi], al
 inc edi
 add ah, 30h
 mov byte ptr [edi], ah
 inc edi
//-- Set as ASCIIZ
 xor al, al
 mov byte ptr [edi], al
 pop eax  // get point to begin second parameter т.е. Result

 pop edi
 pop ebp
 ret
end;
end;

//##################### GetNumUser #######################################
function GetNumUser: PChar;
var
   CurCombination: PNeedCombination;
   PosInFileForBeginCrack: DWord;
   TmpResult: PChar;
begin
Result:= '';
CurCombination:= @NeedCombination_Version;
PosInFileForBeginCrack:= Form1.GetBeginPosForCrack(Buffer, Form1.MyGetFileSize(WorkingFileName),
                          CurCombination);
  if PosInFileForBeginCrack<>0 then
   begin
   OffsToNumUser:= GetOffsToNumUser(Form1.GetVersionSQLServer);
   PosInFileForBeginCrack:= PosInFileForBeginCrack+ OffsToNumUser;
   try
    GetMem(TmpResult, 5);
    asm
     mov  edi, TmpResult
     mov  esi, Buffer
     add  esi, PosInFileForBeginCrack
     mov  al, byte ptr [esi]
//-- Convert char to string digit
     push edi
     push eax
     call ConverByteToDigit
//     mov TmpResult, eax   // TmpResult:= ConverByteToDigit(al);
     end;
    Result:= TmpResult;
    if Result='' then
     Result:= 'Unknown';

    except
     FreeMem(TmpResult);
    end;
   end   {if}
  else
 Result:= 'Unknown';
end;

//########################## GetVersionSQLServer #################################
function TForm1.GetVersionSQLServer: string;
var
   CurCombination: PNeedCombination;
   PosInFileForBeginCrack: DWord;
   TmpResult: PChar;
begin
Result:= '';
CurCombination:= @NeedCombination_Version;
PosInFileForBeginCrack:= Form1.GetBeginPosForCrack(Buffer, Form1.MyGetFileSize(WorkingFileName),
                          CurCombination);
if PosInFileForBeginCrack<>0 then
 begin
  try
   GetMem(TmpResult, 10);
   PosInFileForBeginCrack:= PosInFileForBeginCrack+SizeOf(TNeedCombination);
  asm
   mov edi, TmpResult
   mov esi, Buffer
   add esi, PosInFileForBeginCrack
   xor ecx, ecx

@@GapZero:

   cmp byte ptr [esi], 00
   jnz @@GetVersion
   inc esi
   jmp @@GapZero

@@GetVersion:

   mov al, Byte ptr [esi]
   add al, 30h
   mov byte ptr [edi], al
   inc esi
   inc edi
   cmp byte ptr [esi], 00
   jnz @@GetVersion
   inc esi
   mov byte ptr [edi], '.'
   inc edi
   inc ecx
   cmp ecx, 3
   jb @@GetVersion
   dec edi
   mov byte ptr [edi], 00
  end;
  Result:= StrPas(TmpResult);
  finally
   FreeMem(TmpResult);
  end;
 end
else
 Result:= 'Unknown';
end;

//##################### MyGetFile ##################################
procedure TForm1.MyGetFile(MyWorkingFileName: string);
var
   MyNumUser: string;
   MyMapFileHandle, MyFileHandle: THandle;
begin
   Form1.StatusBar1.Panels[0].Text:= 'Reading file...';
   try
    MyFileHandle:= FileOpenReadWrite(MyWorkingFileName, FmOpenRead or FmOpenWrite);
    MyMapFileHandle:= CreateFileMapping(MyFileHandle, nil, PAGE_READWRITE, 0, 0, nil);
    if MyMapFileHandle<>0 then
     begin
      Form1.SetButtonPostOpenFile;
      Form1.StatusBar1.Panels[0].Text:= MyWorkingFileName;
      Form1.StatusBar1.Panels[1].Text:=IntToStr(MyGetFileSize(MyWorkingFileName));
      Form1.Label2.Caption:= Form1.GetVersionSQLServer;
     end
    else
     MessageDlg('Windows Say: Error='+IntToStr(GetLastError)+#13#10+
                '['+SysErrorMessage(GetLastError)+']',
                mtError,[mbOK],0);
   except
    Form1.Label2.Caption:= '';
    Form1.StatusBar1.Panels[0].Text:= '';
    Form1.StatusBar1.Panels[1].Text:= '';
    Form1.SetButtonPostCloseFile;
   end;
end;

//########################## SetConnect ##################################
function TForm1.SetConnect(MyWorkingFileName: String; MyNumConnect: Byte): boolean;
var
   CurCombination: PNeedCombination;
   PosInFileForBeginCrack: DWord;
   FlagCrack: boolean;
begin
FlagCrack:= True;
Result:= false;
CurCombination:= @NeedCombination_Version;
PosInFileForBeginCrack:= Form1.GetBeginPosForCrack(Buffer, Form1.MyGetFileSize(WorkingFileName),
                          CurCombination);
  if PosInFileForBeginCrack<>0 then
   begin
    OffsToNumUser:= GetOffsToNumUser(Form1.GetVersionSQLServer);
    PosInFileForBeginCrack:= PosInFileForBeginCrack+ OffsToNumUser;
    asm
     mov  edi, Buffer
     add  edi, PosInFileForBeginCrack
      mov  al, MyNumConnect
      mov  byte ptr [edi], al
     end;
     Result:= true;
     Form1.SetTitleInfo(PosInFileForBeginCrack- OffsToNumUser, MyNumConnect);
    end   {if}
  else
   FlagCrack:= False;
if not FlagCrack then
 begin
   MessageDlg('Версия данного сервера не опознана !!!',
              mtInformation,[mbOK],0);
 end
else
 begin
   MessageDlg('Max Number of user is seted succesful',
              mtInformation,[mbOK],0);
   Form1.Label4.Caption:= GetNumUser;
 end;
end;

//################## FileOpenReadWrite ########################
function TForm1.FileOpenReadWrite(const FileName: string; Mode: Integer): Integer;
begin
if Mode=fmOpenRead then
  Result := CreateFile(PChar(FileName), GENERIC_READ,
     0, nil, OPEN_EXISTING,
     FILE_SHARE_READ,0);
if Mode=fmOpenWrite then
  Result := CreateFile(PChar(FileName), GENERIC_WRITE,
     0, nil, CREATE_ALWAYS,
     FILE_SHARE_READ,0);
if Mode=fmOpenWrite or fmOpenRead then
  Result := CreateFile(PChar(FileName), GENERIC_READ or GENERIC_WRITE,
     0, nil, OPEN_EXISTING,
     FILE_SHARE_READ,0);

end;

//################## OpenFileToMemory ########################
function TForm1.OpenFileToMemory(MyNameFile: String;Buffer:PChar {Pointer};MySizeOfFile:LongInt):boolean;
var
   MyFileHandle,ActualeRead:Integer;
begin //OpenFileToMemory
Result:= False;
           try
              MyFileHandle:=FileOpenReadWrite(MyNameFile,FmOpenRead);
              ActualeRead:=0;
              if MyFileHandle>0 then  //if4
                begin
                  ActualeRead:=FileRead(MyFileHandle,Buffer^,
                  MySizeOfFile);
                  CloseHandle(MyFileHandle);
                end
              else      //else4
               begin
                  MessageDlg('Не удается открыть файл !!!'#13#10
                   +MyNameFile+#13#10+
                      'Windows Say: Error='+IntToStr(GetLastError)+#13#10+
                      '['+SysErrorMessage(GetLastError)+']',
                   mtError,[mbOK],0);
                  FlagError:=True;
               end;

              if (Not FlagError) and
                 (MySizeOfFile<>ActualeRead) then //if5
               begin
                 MessageDlg('Не удается полностью прочитать файл !!!'#13#10
                   +MyNameFile+#13#10+
                      'Windows Say: Error='+IntToStr(GetLastError)+#13#10+
                      '['+SysErrorMessage(GetLastError)+']',
                  mtError,[mbOK],0);
                 FlagError:=True;
               end;
           except
              //FreeMem(Buffer,MySizeOfFile);
              StrDispose(Buffer);
              MessageDlg('Ошибка ОС '+#13#10+
                      'Windows Say: Error='+IntToStr(GetLastError)+#13#10+
                      '['+SysErrorMessage(GetLastError)+']',
                       mtError,[mbOK],0);
              Application.Terminate;
           end;
Result:= not FlagError;
end; // OpenFileToMemory

//###################### SaveFileFromMemory #####################
procedure TForm1.SaveFileFromMemory(MyNameFile: String;Buffer:Pointer;MySizeOfFile:LongInt);
var
   MyFileHandle,ActualeWrite:Integer;
   MyFileAttributes: DWord;
begin // SaveFileFromMemory
           try
             MyNameFile:= MyNameFile+ SuffixNewFile;
              if FileExists(MyNameFile) then
               begin
                MyFileAttributes:= GetFileAttributes(PChar(MyNameFile));
                MyFileAttributes:= FILE_ATTRIBUTE_NORMAL;    //MyFileAttributes xor FILE_ATTRIBUTE_READONLY;
                SetFileAttributes(PChar(MyNameFile), MyFileAttributes);
               end;
              MyFileHandle:= FileOpenReadWrite(MyNameFile, FmOpenWrite);
              ActualeWrite:=0;
              if MyFileHandle>0 then  //if4
                begin
                  ActualeWrite:=FileWrite(MyFileHandle,Buffer^,
                  MySizeOfFile);
                  CloseHandle(MyFileHandle);
                  if MySizeOfFile<>ActualeWrite then //if5
                   begin
                    MessageDlg('Не удается полностью записать файл !!!'#13#10
                    +MyNameFile+#13#10+
                    'Windows Say: Error='+IntToStr(GetLastError)+#13#10+
                    '['+SysErrorMessage(GetLastError)+']',
                    mtError,[mbOK],0);
                    FlagError:=True;
                   end;
                end
              else      //else4
               begin
                  MessageDlg('Файл: '#13#10
                             +MyNameFile+#13#10+
                         'Windows Say: Error='+IntToStr(GetLastError)+#13#10+
                         '['+SysErrorMessage(GetLastError)+']',
                   mtError,[mbOK],0);
                  FlagError:=True;
               end;

           except
              FreeMem(Buffer,MySizeOfFile);
              MessageDlg('Ошибка ОС '+#13#10+
                         'Windows Say: Error='+IntToStr(GetLastError)+#13#10+
                         '['+SysErrorMessage(GetLastError)+']',
                          mtError,[mbOK],0);
              Application.Terminate;
           end;
end; // SaveFileFromMemory


function TForm1.GetBeginPosForCrack(Buffer: Pointer; MyFileSize: DWord;
                                            PCurrentNeedCombination: Pointer):DWord;
var
   LastPos, Test: DWord;
begin
asm
 mov esi, Buffer
 dec esi
 mov LastPos, esi
 xor edx, edx

@@BeginCompare:

 inc LastPos
 inc edx
 mov Test, edx
 cmp edx, 327fh
 jb @@Test1
 test edx, edx
@@Test1:

 mov eax, MyFileSize
 sub eax, CountByteInCombination
 cmp eax, edx
 jb @@Exit_Failed
 mov esi, LastPos
 mov edi, PCurrentNeedCombination
 mov ecx, CountByteInCombination
@@CompareByte:
 mov al, byte ptr [edi]
 mov ah, byte ptr [esi]
 cmp al, ah
 jnz @@BeginCompare
 inc esi
 inc edi
 dec ecx
 ja @@CompareByte
 mov eax, LastPos
 sub eax, Buffer
 jmp @@Exit
@@Exit_Failed:
 xor eax, eax
@@Exit:
 mov Result, eax
end;
end;

//###################### MyGetFileSize ###################
function TForm1.MyGetFileSize(MyFileName:string):LongInt;
var
   ActualeRead, CountOfSize:Integer;
   Buffer:Pointer;
begin  // MyGetFileSize
try
   MyFileHandle:=FileOpenReadWrite(MyFileName,FmOpenRead);
   if MyFileHandle>0 then
    begin
       ActualeRead:= GetFileSize(MyFileHandle, @CountOfSize);
       Result:= CountOfSize*$ffffffff+ActualeRead;
    end
   else
     Result:=-1;
except
   MessageDlg('Ошибка ОС '+#13#10+
               'Windows Say: Error='+IntToStr(GetLastError)+#13#10+
               '['+SysErrorMessage(GetLastError)+']',
               mtError,[mbOK],0);
   Application.Terminate;
end;
end; // MyGetFileSize

//################### SetButtonPostOpenFile #####################
procedure TForm1.SetButtonPostOpenFile;
begin // SetButtonPostOpenFile
// Для Меню
  with Form1.MainMenu1 do
   begin
  //  Пункт "File"
    MenuOpen.Enabled:= False;
    MenuOpenLast.Enabled:= False;
    MenuClose.Enabled:= True;
  //  Пункт "Work"
    Work.Enabled:= True;
    MenuSetConnect.Enabled:= True;
   end;
  // Для Edit1

end; // SetButtonPostOpenFile

//################### SetButtonPostCloseFile #####################
procedure TForm1.SetButtonPostCloseFile;
begin //  SetButtonPostCloseFile
// Для Меню
  with Form1.MainMenu1 do
   begin
  //  Пункт "File"
    MenuOpen.Enabled:= True;
    MenuOpenLast.Enabled:= True;
    MenuClose.Enabled:= False;
  //  Пункт "Work"
    Work.Enabled:= False;
    MenuSetConnect.Enabled:= False;
   end;

  // Для Edit1

end; // SetButtonPostCloseFile

procedure TForm1.Exit1Click(Sender: TObject);
begin
try
 FreeMem(Buffer);
finally
 Application.Terminate;
end;
end;

procedure TForm1.MenuOpenClick(Sender: TObject);
begin
 FlagError:= False;
 OpenDialog1.InitialDir:='c:\';
 OpenDialog1.FileName:='';
 OpenDialog1.Execute;
 Form1.Update;
if FileExists(Form1.OpenDialog1.FileName) then
 begin
   WorkingFileName:= OpenDialog1.FileName;
   Inifile.WriteString('File', 'LastOpened', WorkingFileName);
   try
    MyGetFile(WorkingFileName);
   except
    FreeMem(Buffer);
   end;
 end
end;

procedure TForm1.MenuCloseClick(Sender: TObject);
begin
 Form1.SetButtonPostCloseFile;
 Form1.StatusBar1.Panels[0].Text:='';
 Form1.StatusBar1.Panels[1].Text:='';
 Form1.Label2.Caption:= '';
 Form1.Label4.Caption:= '';
 try
  FreeMem(Buffer);
 except
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
   SoursePathOfProgram: String;
begin
SoursePathOfProgram:=ExtractFilePath(Application.EXEName);
IniFile:=TIniFile.Create(SoursePathOfProgram+NameINIFile);
WorkingFileName:=IniFile.ReadString('File','LastOpened','');
Form1.Label2.Caption:= '';
Form1.Label4.Caption:= '';
Form1.UpDown1.Position:= Form1.UpDown1.Min;
with Form1.MainMenu1 do
  MenuOpenLast.Visible:= FileExists(WorkingFileName);
end;

procedure TForm1.MenuOpenLastClick(Sender: TObject);
begin
if FileExists(IniFile.ReadString('File','LastOpened','')) then
 begin
   WorkingFileName:= IniFile.ReadString('File','LastOpened','');
   MyGetFile(WorkingFileName);
  end;
Form1.SetButtonPostOpenFile;

end;

procedure TForm1.MenuSetConnectClick(Sender: TObject);
var
   SetingNumConnect: byte;
begin
  Form1.StatusBar1.Panels[0].Text:= '';
  Form1.StatusBar1.Panels[0].Text:= 'writing file...';
  if Form1.CheckBox1.Checked then
   SetingNumConnect:= 0
  else
   SetingNumConnect:= Form1.UpDown1.Position;
  Form1.SetConnect(WorkingFileName, SetingNumConnect);
  Form1.SaveFileFromMemory(WorkingFileName,
                           Buffer, Form1.MyGetFileSize(WorkingFileName));
  Form1.StatusBar1.Panels[0].Text:= WorkingFileName;
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
if Form1.CheckBox1.Checked then
 begin
  Form1.UpDown1.Position:= 00;
  Form1.UpDown1.Enabled:= False;
  Form1.Edit1.Enabled:= False;
 end
else
 begin
  Form1.UpDown1.Enabled:= True;
  Form1.Edit1.Enabled:= True;
 end;

end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 try
  FreeMem(Buffer);
 except
 end;
end;

end.
