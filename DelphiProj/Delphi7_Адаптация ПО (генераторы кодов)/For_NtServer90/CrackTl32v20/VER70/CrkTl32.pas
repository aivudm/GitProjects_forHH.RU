unit CrkTl32;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ComCtrls, IniFiles, ExtCtrls;
const
     MaxLengthDOSPath: byte = 255;
//     NameTSFFile: string = 'dbntsrv.tsf';
     NameTrialLimitDLL: string = 'tl32v20.dll';
type
  TCallingDLLProc = procedure(Param1: string); stdcall;
  TForm1 = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    procedure Exit1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    function MyGetFileSize(MyFileName:string):LongInt;
    function FileOpenReadWrite(const FileName: string; Mode: Integer): Integer;
    function OpenFileToMemory(MyNameFile: String; Buffer:PChar {Pointer};MySizeOfFile:LongInt): boolean;
    procedure SaveFileFromMemory(MyNameFile: String;Buffer:Pointer;MySizeOfFile:LongInt);
    procedure CrackTrialLimitDLL(MyWorkingFileName: String);
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
  BeginPosCrack: DWord = $0000327F;
implementation

{$R *.DFM}

procedure TForm1.CrackTrialLimitDLL(MyWorkingFileName: String);
var
   Buffer: Pointer;
   PosInFile, MyFileSize: longint;
begin
MyFileSize:= Form1.MyGetFileSize(MyWorkingFileName);
try
GetMem(Buffer, MyFileSize);
if Form1.OpenFileToMemory(MyWorkingFileName,
      Buffer, MyFileSize) then
 begin
  PosInFile:= BeginPosCrack;
 asm
  mov  edi, Buffer
  add  edi, 327Fh  // offset to jz Err_ZeroLengthUnlockCode
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
//===============================================
  mov  edi, Buffer
  add  edi, 32A6h  // offset to jg PurchaseInformationOfUser

//---------------- jmp short -------------
  mov  al, 0EBh
  mov  byte ptr [edi], al
//===============================================

  mov  edi, Buffer
  add  edi, 335Ah  // offset to RestorTrialPeriod

//---------------- call $+4 -------------
  mov  al, 0E8h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 00h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 00h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 00h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 00h
  mov  byte ptr [edi], al
  inc  edi
//==============================================================
//---------------- pop edi -------------
  mov  al, 5Fh
  mov  byte ptr [edi], al
  inc  edi

  //---------------- mov eax, offset_GetDlgItem -------------
  mov  al, 0B8h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 69h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 24h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 01h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 00h
  mov  byte ptr [edi], al
  inc  edi
//====================================================================
//---------------- add edi, eax -------------
  mov  al, 03h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 0F8h
  mov  byte ptr [edi], al
  inc  edi

//---------------- push 2333h -------------
  mov  al, 68h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 33h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 23h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 0h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 0h
  mov  byte ptr [edi], al
  inc  edi
//---------------- mov esi, [ebp+8] ---------------
  mov  al, 8Bh
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 75h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 08h
  mov  byte ptr [edi], al
  inc  edi
//---------------- push esi -------------
  mov  al, 56h
  mov  byte ptr [edi], al
  inc  edi
//------------------------ Hash ------------------------------
  mov  al, 0FFh
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 0FFh
  mov  byte ptr [edi], al
  inc  edi
//---------------- call edi -------------
  mov  al, 0FFh
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 0D7h
  mov  byte ptr [edi], al
  inc  edi
//================================================

//---------------- mov ebx, eax -------------
  mov  al, 8Bh
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 0D8h
  mov  byte ptr [edi], al
  inc  edi

//---------------- push [ebp-28] -------------
  mov  al, 0FFh
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 75h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 0D8h
  mov  byte ptr [edi], al
  inc  edi
//---------------- push ebx -------------
  mov  al, 53h
  mov  byte ptr [edi], al
  inc  edi
//=========================================================================
//---------------- sub edi, 8 -------------
  mov  al, 81h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 0EFh
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 08h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 00h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 00h
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 00h
  mov  byte ptr [edi], al
  inc  edi
//=============================================================================
//---------------- call edi ------------------------------
  mov  al, 0FFh
  mov  byte ptr [edi], al
  inc  edi
  mov  al, 0D7h
  mov  byte ptr [edi], al
  inc  edi
{//----------- Восстановление порушенных переходов -------------
  mov  edi, Buffer
  add  edi, 327Fh  // offset to jz Err_ZeroLengthUnlockCode
//---------------- nop1 -------------
  mov  al, 0Fh
  mov  byte ptr [edi], al
  inc  edi
//---------------- nop2 -------------
  mov  al, 84h
  mov  byte ptr [edi], al
  inc  edi
//---------------- nop3 -------------
  mov  al, 4Bh
  mov  byte ptr [edi], al
  inc  edi
//---------------- nop4 -------------
  mov  al, 01h
  mov  byte ptr [edi], al
  inc  edi
//---------------- nop5 -------------
  mov  al, 00h
  mov  byte ptr [edi], al
  inc  edi
//---------------- nop6 -------------
  mov  al, 00h
  mov  byte ptr [edi], al
//===============================================
  mov  edi, Buffer
  add  edi, 32A6h  // offset to jg PurchaseInformationOfUser

//---------------- jg -------------
  mov  al, 7Fh
  mov  byte ptr [edi], al
//=============================================================
}
//---------------- jmp short -------------
  mov  al, 0EBh
  mov  byte ptr [edi], al
  inc  edi
//---------------- offset to ProcessWM_PAINT__PurchaseDialog -------------
  mov  al, 7Dh
  mov  byte ptr [edi], al

 end;
  Form1.SaveFileFromMemory(MyWorkingFileName,
      Buffer, MyFileSize);
 end;
finally
FreeMem(Buffer);
end;
end;

function TForm1.FileOpenReadWrite(const FileName: string; Mode: Integer): Integer;
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
procedure TForm1.SaveFileFromMemory(MyNameFile: String;Buffer:Pointer;MySizeOfFile:LongInt);
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

procedure TForm1.Exit1Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
   Buffer: PChar;
begin
FlagError:= False;
try
 GetMem(Buffer, MaxLengthDOSPath);
 GetWindowsDirectory(Buffer, MaxLengthDOSPath);
 WorkingFileName:= StrPas(Buffer);
 if WorkingFileName[length(WorkingFileName)]<>'\' then
  WorkingFileName:= WorkingFileName+'\';
 WorkingFileName:= WorkingFileName+ NameTrialLimitDLL;
 if FileExists(WorkingFileName) then
  begin
   CrackTrialLimitDLL(WorkingFileName);
  end
 else
  begin
   Form1.Visible:= False;
   MessageDlg('Не найден файл:'+#13+#10+
              WorkingFileName,
              mtError,[mbOK],0);
  end;
if FlagError then
 Application.Terminate;

finally
 FreeMem(Buffer);
end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
Application.Terminate;
end;

end.
