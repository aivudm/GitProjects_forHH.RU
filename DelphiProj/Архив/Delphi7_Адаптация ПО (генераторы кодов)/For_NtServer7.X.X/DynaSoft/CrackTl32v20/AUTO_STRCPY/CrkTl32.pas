unit CrkTl32;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ComCtrls, IniFiles, ExtCtrls;
const
     CountByteInCombination: DWord = 17;

type
    TNeedCombination = array [1..17] of byte;
    PNeedCombination = Pointer;
const
     MaxLengthDOSPath: byte = 255;
//     NameTSFFile: string = 'dbntsrv.tsf';
     NameTrialLimitDLL: string = 'tl32v20.dll';
     NeedCombination_ErrZeroLengthUnlockCode: TNeedCombination=($0F, $84, $4B, $01, $00, $00, $6A,
                                             $14, $8D, $45, $EC, $50, $53,
                                             $FF, $15, $DC, $63);
     NeedCombination_ErrUnlockCode: TNeedCombination=($75, $53, $8D, $45, $EC, $50, $68,
                                             $85, $45, $01, $10, $E8, $7B,
                                             $0F, $00, $00, $83);
     NeedCombination_SwithOnInternalUnlockCode:  TNeedCombination=($EC, $50, $68, $85, $45,
                                             $01, $10, $E8, $7B, $0F, $00,
                                             $00, $83, $C4, $08, $8D, $45);
type
  TCallingDLLProc = procedure(Param1: string); stdcall;
  TForm1 = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
const
     NameINIFile: String = 'GetUnCode.ini';
var
  Form1: TForm1;

  WorkingFileName: String;
  FlagError: Boolean = False;
  MyFileHandle: Integer;
    function MyGetFileSize(MyFileName:string):LongInt;
    function FileOpenReadWrite(const FileName: string; Mode: Integer): Integer;
    function OpenFileToMemory(MyNameFile: String; Buffer:PChar {Pointer};MySizeOfFile:LongInt): boolean;
    procedure SaveFileFromMemory(MyNameFile: String;Buffer:Pointer;MySizeOfFile:LongInt);
    function CrackTrialLimitDLL(MyWorkingFileName: String): boolean;
    function GetBeginPosForCrack(Buffer: Pointer; MyFileSize: DWord; PCurrentNeedCombination: Pointer): DWord;
implementation

{$R *.DFM}
function GetBeginPosForCrack(Buffer: Pointer; MyFileSize: DWord;
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

function CrackTrialLimitDLL(MyWorkingFileName: String): boolean;
var
   Buffer: Pointer;
   CurCombination: PNeedCombination;
   PosInFileForBeginCrack, CurrentFileSize: DWord;
   FlagCrack: boolean;
begin
FlagCrack:= True;
CurrentFileSize:= MyGetFileSize(MyWorkingFileName);
try
GetMem(Buffer, CurrentFileSize);
if OpenFileToMemory(MyWorkingFileName,
      Buffer, CurrentFileSize) then
 begin
  CurCombination:= @NeedCombination_ErrZeroLengthUnlockCode;
  PosInFileForBeginCrack:= GetBeginPosForCrack(Buffer, MyGetFileSize(MyWorkingFileName),
                          CurCombination);
// PosInFileForBeginCrack:= $327F;
  if PosInFileForBeginCrack<>0 then
   begin
    asm
     mov  edi, Buffer
     add  edi, PosInFileForBeginCrack  // offset to jz Err_ZeroLengthUnlockCode
//---------------- nop1 -------------
      mov  al, 90h
      mov  byte ptr [edi], al
      inc  edi
//---------------- nop2 -------------
      mov  al, 90h
      mov  byte ptr [edi], al
      inc  edi
//---------------- nop3 -------------
      mov  al, 90h
      mov  byte ptr [edi], al
      inc  edi
//---------------- nop4 -------------
      mov  al, 90h
      mov  byte ptr [edi], al
      inc  edi
//---------------- nop5 -------------
      mov  al, 90h
      mov  byte ptr [edi], al
      inc  edi
//---------------- nop6 -------------
      mov  al, 90h
      mov  byte ptr [edi], al
     end;
    end   {if}
  else
   FlagCrack:= False;

//===============================================
  CurCombination:= @NeedCombination_ErrUnlockCode;
  PosInFileForBeginCrack:= GetBeginPosForCrack(Buffer, MyGetFileSize(MyWorkingFileName),
                           CurCombination);
// PosInFileForBeginCrack:= $32A6;
  if PosInFileForBeginCrack<>0 then
   begin
    asm
     mov  edi, Buffer
     add  edi, PosInFileForBeginCrack  // offset to jnz RestoreTrialSession
//---------------- delete jnz short loc_10003BF8 -------------
     mov  al, 90h
     mov  byte ptr [edi], al
     inc  edi
     mov  al, 90h
     mov  byte ptr [edi], al
   end;
  end
 else
   FlagCrack:= False;

//==============================================================
  CurCombination:= @NeedCombination_SwithOnInternalUnlockCode;
  PosInFileForBeginCrack:= GetBeginPosForCrack(Buffer, MyGetFileSize(MyWorkingFileName),
                           CurCombination);
// PosInFileForBeginCrack:= $335A;
  if PosInFileForBeginCrack<>0 then
   begin
    asm
//---------------- замена [ebp-14h] на [ebp-28h] -------------
     mov  edi, Buffer
     add  edi, PosInFileForBeginCrack  // offset to byte 14 in lea eax, [ebp-28]
     mov  al, 0D8h
     mov  byte ptr [edi], al
    end;
   end
  else
   FlagCrack:= False;
if not FlagCrack then
 begin
   MessageDlg('Tl32v20.dll уже сломана или версия неизвестна !!!',
              mtInformation,[mbOK],0);
 end
else
  SaveFileFromMemory(MyWorkingFileName,
      Buffer, MyGetFileSize(MyWorkingFileName));
end;
finally
 FreeMem(Buffer);
 Result:= FlagCrack;
end;
end;

function FileOpenReadWrite(const FileName: string; Mode: Integer): Integer;
begin
if Mode=fmOpenRead then
  Result := CreateFile(PChar(FileName), GENERIC_READ,
     FILE_SHARE_READ, nil, OPEN_EXISTING,
     FILE_SHARE_READ,0);
if Mode=fmOpenWrite then
  Result := CreateFile(PChar(FileName), GENERIC_WRITE,
     FILE_SHARE_WRITE, nil, OPEN_EXISTING,
     FILE_SHARE_WRITE,0);

end;

//################## OpenFileToMemory ########################
function OpenFileToMemory(MyNameFile: String;Buffer:PChar {Pointer};MySizeOfFile:LongInt):boolean;
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
                  FileClose(MyFileHandle);
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
procedure SaveFileFromMemory(MyNameFile: String;Buffer:Pointer;MySizeOfFile:LongInt);
var
   MyFileHandle,ActualeWrite:Integer;
begin // SaveFileFromMemory
           try
              MyFileHandle:= FileOpenReadWrite(MyNameFile, FmOpenWrite);
              ActualeWrite:=0;
              if MyFileHandle>0 then  //if4
                begin
                  ActualeWrite:=FileWrite(MyFileHandle,Buffer^,
                  MySizeOfFile);
                  FileClose(MyFileHandle);
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

              if ActualeWrite=-1 then //if5
               begin
                 MessageDlg('Ошибка записи файла !!!'#13#10
                  +MyNameFile+#13#10+
                  'Windows Say: Error='+IntToStr(GetLastError)+#13#10+
                  '['+SysErrorMessage(GetLastError)+']',
                  mtError,[mbOK],0);
                 FlagError:=True;
               end
              else
               if MySizeOfFile<>ActualeWrite then //if5
                begin
                 MessageDlg('Не удается полностью записать файл !!!'#13#10
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

//###################### MyGetFileSize ###################
function MyGetFileSize(MyFileName:string):LongInt;
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
       FileClose(MyFileHandle);
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

procedure TForm1.Button1Click(Sender: TObject);
begin
Application.Terminate;
end;

end.
