unit unUtilCommon;

interface
uses
  Windows, TlHelp32, ImageHlp, PsAPI, SysUtils, Classes, Forms, Controls, StdCtrls,
  DateUtils, Messages;


function GetSubStr(FullString:String;Index:Byte;Count:Integer):String;
function IndexInString(SubStr,FullString:String; MyPosBegin: Word): Word;
function StreamToString(Stream: TStream): String;
function translate_utf8_ansi(const Source: string):string;
procedure ListDLLsForProcess(inputProcessID: DWORD; outputStringList: TStrings);
procedure WriteDataToLog(E_source1, CurrentProcName, CurrentUnitName: WideString);
function ByteToWS(inputBytes: TArray<Byte>; inputBytesSize: dword): WideString;


implementation
uses unConst, unVariables;

function GetSubStr(FullString:String;Index:Byte;Count:Integer):String;
begin
if Count<>-1 then
   Result:=copy(FullString,Index,Count)
else
   Result:=copy(FullString,Index,(length(FullString)-Index+1));
end; // GetSubStr

function IndexInString(SubStr,FullString:String; MyPosBegin: Word): Word;
var
   MyStr: String;
begin
MyStr:= GetSubStr(FullString,MyPosBegin,-1);
Result:=pos(SubStr, MyStr);

end; // IndexInString(FullString,SubStr:String)

function StreamToString(Stream: TStream): String;
var
  ssTmp: TStringStream;
begin
//    with TStringStream.Create('') do
 ssTMP:= TStringStream.Create('');
    with ssTMP do
    try
        CopyFrom(Stream, Stream.Size - Stream.Position);
        Result := DataString;
    finally
     Free;
    end;
end;

function translate_utf8_ansi(const Source: string):string;
    var
       Iterator, SourceLength, FChar, NChar: Integer;
    begin
       Result := '';
       Iterator := 0;
       SourceLength := Length(Source);
       while Iterator < SourceLength do
       begin
          Inc(Iterator);
          FChar := Ord(Source[Iterator]);
          if FChar >= $80 then
          begin
             Inc(Iterator);
             if Iterator > SourceLength then break;
             FChar := FChar and $3F;
             if (FChar and $20) <> 0 then
             begin
                FChar := FChar and $1F;
                NChar := Ord(Source[Iterator]);
                if (NChar and $C0) <> $80 then break;
                FChar := (FChar shl 6) or (NChar and $3F);
                Inc(Iterator);
                if Iterator > SourceLength then break;
             end;
             NChar := Ord(Source[Iterator]);
             if (NChar and $C0) <> $80 then break;
             Result := Result + WideChar((FChar shl 6) or (NChar and $3F));
          end
          else
             Result := Result + WideChar(FChar);
       end;
    end;

procedure ListDLLsForProcess(inputProcessID: DWORD; outputStringList: TStrings);
var
  Snapshot: THandle;
  ModuleEntry: MODULEENTRY32;
  hModule: THandle; //HMODULE;
  ModuleFileName: array[0..MAX_PATH] of Char;
  ModuleLoadedInThisProcess: Boolean;
begin
  // Создаем снимок модулей процесса
  Snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, inputProcessID);
  if Snapshot = INVALID_HANDLE_VALUE then Exit;
  try
    ModuleEntry.dwSize := SizeOf(ModuleEntry);
    if Module32First(Snapshot, ModuleEntry) then
    begin
      repeat
        // Проверяем, загружен ли модуль в текущее приложение
        hModule := GetModuleHandle(ModuleEntry.szModule);
        ModuleLoadedInThisProcess := hModule <> 0;

        // Получаем полное имя файла библиотеки
        GetModuleFileNameEx(GetCurrentProcess, hModule, ModuleFileName, MAX_PATH);

        // Формируем строку с именем модуля и комментарием
        if ModuleLoadedInThisProcess then
          outputStringList.Add(Format('%s - %s [+]', [ModuleEntry.szModule, ModuleFileName]))
        else
          outputStringList.Add(Format('%s - %s', [ModuleEntry.szModule, ModuleFileName]));
      until not Module32Next(Snapshot, ModuleEntry);
    end;
  finally
    CloseHandle(Snapshot);
  end;
end;

procedure WriteDataToLog(E_source1, CurrentProcName, CurrentUnitName: WideString);
var
  tmpWideString: WideString;
  tmpCardinal: Cardinal;
begin
 CriticalSection.Enter;
  tmpWideString:= '---- Главный модуль ------------------------------'
                + #13#10
                + DatetimeToStr(today())
                + #13#10
                + 'Сообщение сгенерировано в - ' + CurrentUnitName + '\' + CurrentProcName
                + #13#10
                + E_source1
                + #13#10
                + '--------------------------------------------------';
  logFileStringStream.WriteString(tmpWideString);
  CriticalSection.Leave;
//--- Обновить информацию в ТМемо (с журналом работы)
  PostMessage(OutInfo_ForViewing.hMemoLogInfo_2, WM_Data_Update, CMD_SetMemoStreamUpd, 0);
end;

function ByteToWS(inputBytes: TArray<Byte>; inputBytesSize: dword): WideString;
var
  tmpPChar: PChar;
  tmpWord: word;
  tmpStr: AnsiString;
begin
  Result:= '';
  if inputBytesSize < 1 then
  begin
   Result:= '';
   exit;
  end;
end;



end.
