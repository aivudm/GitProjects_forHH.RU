unit unUtilFiles;

interface
uses windows, sysutils, stdctrls, checklst, dialogs, forms;

type
    TDirectoryElement = record
    end;
    PDirectoryElement = ^TDirectoryElement;

var
      CurrentFilePointer: dword;

function MyGetFileSize(MyFileName:string):LongInt;
function OpenFileToMemory(MyNameFile: String; var Buffer: PChar; MySizeOfFile:LongInt): boolean;
procedure SaveFileFromMemory(MyNameFile: String; Buffer: PChar; MySizeOfFile:LongInt);
function GetSubStr(FullString:String;Index:Byte;Count:Integer):String;

function GetPosForMarker(Buffer: Pointer; BufferSize: dword; BeginPos: dword; PMarker: Pointer; MarkerSize: dword): dword; stdcall;
function ReplacePartOfBuffer(pBuffer: Pointer; BufferSize: dword; BeginPos: dword; OldText, NewText: string): boolean; stdcall;
function FillBuffer(pBuffer: Pointer; BufferSize: dword; FillCode: byte): boolean; stdcall;

function GetSizeBetweenpointers(pBeginPosInBuffer, pEndPosInBuffer: Pointer): longint; stdcall;
function GetPointerWithOffset(pBuffer: Pointer; OffsetInBuffer: dword): Pointer; stdcall;
function GetAmountMarker(Buffer: Pointer; BufferSize: dword; BeginPos: dword; PMarker: Pointer; MarkerSize: dword): dword; stdcall;
function GetSP_FnNameFromText(pBuffer: Pointer; BufferSize: dword; BeginPos: dword; pMarker: Pointer; MarkerSize: dword): string;

implementation
uses unConstantFiles;

//--------------------------------------------------------------------------------
//---------------------- Процедуры для внутреннего использования -----------------
//--------------------------------------------------------------------------------
//###################### FileOpenReadWrite ###################
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

if Mode=fmOpenInfo then
  Result := CreateFile(PChar(FileName), 0,
     0, nil, OPEN_EXISTING,
     0{FILE_ATTRIBUTE_READONLY}, 0);
end;
//--------------------------------------------------------------------------------
//---------------------- Конец Процедуры для внутреннего использования ----------
//--------------------------------------------------------------------------------



//################## OpenFileToMemory ########################
function OpenFileToMemory(MyNameFile: String; var Buffer: PChar;
                          MySizeOfFile:LongInt):boolean;
var
   MyFileHandle,ActualeRead:Integer;
   FlagError: boolean;
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
procedure SaveFileFromMemory(MyNameFile: String; Buffer:PChar; MySizeOfFile:LongInt);
var
   MyFileHandle,ActualeWrite:Integer;
   FlagError: boolean;
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
   MyFileHandle: Integer;

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

//######################## GetSubStr ##################################
function GetSubStr(FullString:String;Index:Byte;Count:Integer):String;
begin
if Count<>-1 then
   Result:=copy(FullString,Index,Count)
else
   Result:=copy(FullString,Index,(length(FullString)-Index+1));
end; // GetSubStr(FullString:String;Index,Count:Byte)

function ReplacePartOfBuffer(pBuffer: Pointer; BufferSize: dword; BeginPos: dword; OldText, NewText: string): boolean;
var
   pNewText, pOldText: pointer;
   iLengthText: dword;
   BeginPosOfOldText: DWord;
begin
 result:= false;
 pNewText:= @NewText;
 pOldText:= @OldText;
 iLengthText:= length(OldText);
 BeginPosOfOldText:= GetPosForMarker(pBuffer, BufferSize, 0, pOldText, length(OldText));
 if BeginPosOfOldText <> -1 then
  begin
   asm
    push ebp
    push esp
    push ebx
    push esi
    push edi
    push es

    mov  esi, NewText
    mov  edi, pBuffer
    mov  ecx, iLengthText
    add  edi, BeginPos
    cld
    push ds
    pop  es
    rep movsb

    cld
    pop es
    pop edi
    pop esi
    pop ebx
    pop esp
    pop ebp
    end;
   end   {if}
 else
  result:= true;
end;

function GetPosForMarker(Buffer: Pointer; BufferSize: dword; BeginPos: dword; PMarker: Pointer; MarkerSize: dword): dword;
asm
 push ebp
 push esp
 push ebx
 push esi
 push edi

 mov eax, BufferSize
 sub eax, MarkerSize
 jbe @@Exit_Failed

 mov esi, Buffer
 add esi, BeginPos
 mov edx, esi  //--- edx= LastPos
 mov ebx, Buffer
 add ebx, BufferSize

@@BeginCompare:

 inc edx
 cmp ebx, edx
 jbe @@Exit_Failed
 mov esi, edx
 mov edi, PMarker
 mov ecx, MarkerSize
@@CompareByte:
 mov al, byte ptr [edi]
 mov ah, byte ptr [esi]
 cmp al, ah
 jnz @@BeginCompare
 inc esi
 inc edi
 dec ecx
 ja @@CompareByte
 mov eax, edx
 sub eax, Buffer
 jmp @@Exit
@@Exit_Failed:
 mov eax, 0FFFFFFFFh
@@Exit:
 mov Result, eax

 cld
 pop edi
 pop esi
 pop ebx
 pop esp
 pop ebp
end;

function GetSizeBetweenpointers(pBeginPosInBuffer, pEndPosInBuffer: Pointer): longint;
asm
 push ebp
 push esp
 push ebx
 push esi
 push edi

 mov esi, pBeginPosInBuffer
 mov edi, pEndPosInBuffer
 sub edi, esi
 mov Result, edi

 cld
 pop edi
 pop esi
 pop ebx
 pop esp
 pop ebp
end;

function GetPointerWithOffset(pBuffer: Pointer; OffsetInBuffer: dword): Pointer;
asm
 push ebp
 push esp
 push ebx
 push esi
 push edi

 mov esi, pBuffer
 mov edi, OffsetInBuffer
 add edi, esi
 mov Result, edi

 cld
 pop edi
 pop esi
 pop ebx
 pop esp
 pop ebp
end;

function GetAmountMarker(Buffer: Pointer; BufferSize: dword; BeginPos: dword; PMarker: Pointer; MarkerSize: dword): dword;
asm
 push ebp
 push esp
 push ebx
 push esi
 push edi

 mov eax, BufferSize
 cmp eax, MarkerSize
 jb @@Exit_Failed

 mov esi, Buffer
 add esi, BeginPos
 mov edx, esi  //--- edx= LastPos
 xor ebx, ebx // mov dword ptr [Result], 0
 dec edx


@@BeginCompare:

 inc edx
 mov eax, Buffer
 add eax, BufferSize
 cmp eax, edx
 jbe @@Exit

 mov esi, edx
 mov edi, PMarker
 mov ecx, MarkerSize
@@CompareByte:
 mov al, byte ptr [edi]
 mov ah, byte ptr [esi]
 cmp al, ah
 jnz @@BeginCompare
 inc esi
 inc edi
 dec ecx
 jnz @@CompareByte
 inc ebx // inc dword ptr [Result]
 jmp @@BeginCompare
@@Exit_Failed:
 mov eax, 0FFFFFFFFh
@@Exit:
 mov Result, ebx

 cld
 pop edi
 pop esi
 pop ebx
 pop esp
 pop ebp
end;

function GetSP_FnNameFromText(pBuffer: Pointer; BufferSize: dword; BeginPos: dword; pMarker: Pointer; MarkerSize: dword): string;
var
  CurrentPositionInBuffer, BeginPositionTargetName, EndPositionTargetName: dword;
  Buffer, Marker: string;
  pBufferCut: pointer;
begin
 Buffer:= StrPas(pBuffer);
 Marker:= StrPas(pMarker);
//--- Пропустим Create Procedure или Function
 CurrentPositionInBuffer:= pos(Marker, Buffer);
 CurrentPositionInBuffer:= CurrentPositionInBuffer + length(Marker);
 CurrentPositionInBuffer:= CurrentPositionInBuffer + pos('[', GetSubStr(Buffer, CurrentPositionInBuffer, -1));
 CurrentPositionInBuffer:= CurrentPositionInBuffer + pos(']', GetSubStr(Buffer, CurrentPositionInBuffer, -1));

 BeginPositionTargetName:= CurrentPositionInBuffer + pos('[', GetSubStr(Buffer, CurrentPositionInBuffer, -1));
 EndPositionTargetName:= BeginPositionTargetName + pos(']', GetSubStr(Buffer, BeginPositionTargetName, -1)) - 1;
 result:= copy(Buffer, BeginPositionTargetName, (EndPositionTargetName - BeginPositionTargetName));
{
//--- Пропустим все пробелы после Create Procedure или Function
 repeat
  BeginPosName:= BeginPosName + 1;
 until Buffer[BeginPosName] = ' ';
}
end;

function FillBuffer(pBuffer: Pointer; BufferSize: dword; FillCode: byte): boolean; stdcall;
asm
 push ebp
 push esp
 push ebx
 push esi
 push edi

 mov edi, pBuffer
 mov al, FillCode
 mov ecx, BufferSize

@@BeginCycle:
 mov byte ptr [edi], al
 inc edi
 dec ecx
 ja @@BeginCycle

 cld
 pop edi
 pop esi
 pop ebx
 pop esp
 pop ebp
end;

end.

