unit unUtils;

interface
uses Vcl.Forms, System.Classes, System.SysUtils, Winapi.Windows, Winapi.Messages, IOUtils,
     TlHelp32, ImageHlp; {PsAPI,}

function GetWorkingDirectoryName(): string;
function IsTaskDllAttached(DllFileName: string): integer;
function GetDllLibraryNickName(DllFileName: string): string;
procedure GetDLLExportList(const DllFileName: string; var outputList: TArray<string>);


implementation
uses unConst, unVariables, unUtilCommon;

function GetWorkingDirectoryName(): string;
var
  tmpStr: string;
begin
 Result:= '';
try
 tmpStr:= GetEnvironmentVariable('APPDATA') + '\' + Copy(ExtractFileName(Application.ExeName), 1, Pos('.', ExtractFileName(Application.ExeName)) - 1);
 if not TDirectory.Exists(tmpStr) then
  TDirectory.CreateDirectory(tmpStr);
 Result:= tmpStr;
except
 on E: Exception do
       Writeln(E.ClassName, ': ', E.Message);
end;
{
----- Вариант работы с директориями и именами файлов до появления классов TDirectory, TFile
  tmpStr:= Copy(ExtractFileName(Application.ExeName), 1, Pos('.', ExtractFileName(Application.ExeName)) - 1);
  CreateDir(GetEnvironmentVariable('APPDATA') + '\' + tmpStr);
  tmpStr:= GetEnvironmentVariable('APPDATA') + '\' + tmpStr;
  tmpStr:= tmpStr + '\' + ExtractFileName(ChangeFileExt(Application.ExeName, '.txt' ));
  if FileExists(tmpStr) then DeleteFile(PWideChar(tmpStr));
  fsResult:= TFileStream.Create(ChangeFileExt(Application.ExeName, '.txt' ), fmCreate or fmOpenWrite);
  tmpStr:= Copy(ExtractFileName(Application.ExeName), 1, Pos('.', ExtractFileName(Application.ExeName)) - 1);
  CreateDir(GetEnvironmentVariable('APPDATA') + '\' + tmpStr);
  Result:= GetEnvironmentVariable('APPDATA') + '\' + tmpStr;
  tmpStr:= tmpStr + '\' + ExtractFileName(ChangeFileExt(Application.ExeName, '.txt' ));

}

end;

function IsTaskDllAttached(DllFileName: string): integer;
begin
 Result:= -1;
  if  Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
   hDllTask:= LoadLibrary(PChar(DllFileName)); //, 0, LOAD_LIBRARY_AS_DATAFILE{DONT_RESOLVE_DLL_REFERENCES});
  end
  else
   hDllTask:= LoadLibrary(PChar(DllFileName)); //, 0, 0{DONT_RESOLVE_DLL_REFERENCES});
 Result:= hDllTask;
end;

function GetDllLibraryNickName(DllFileName: string): string;
var
  tmp_hDllTask: THandle;
  tmpCallingDLLProc: TCallingDLLProc1;
begin
 Result:= '';
  if  Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
   tmp_hDllTask:= LoadLibrary(PChar(DllFileName)); //, 0, LOAD_LIBRARY_AS_DATAFILE{DONT_RESOLVE_DLL_REFERENCES});
  end
  else
   tmp_hDllTask:= LoadLibrary(PChar(DllFileName)); //, 0, 0{DONT_RESOLVE_DLL_REFERENCES});

 @tmpCallingDLLProc:= GetProcAddress(tmp_hDllTask, DllProcName_NickName);
 if @tmpCallingDLLProc <> nil then
   tmpCallingDLLProc(Result);
 FreeLibrary(tmp_hDllTask);
end;

function GetThreadsInfo(PID: Cardinal): Boolean;
  var
    SnapProcHandle: THandle;
    NextProc      : Boolean;
    ThreadEntry  : TThreadEntry32;
  begin
    SnapProcHandle := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0); //Создаем снэпшот всех существующих потоков
    Result := (SnapProcHandle <> INVALID_HANDLE_VALUE);
    if Result then
      try
        ThreadEntry.dwSize := SizeOf(ThreadEntry);
        NextProc := Thread32First(SnapProcHandle, ThreadEntry);//получаем первый поток
        while NextProc do begin
          if ThreadEntry.th32OwnerProcessID = PID then begin //проверка на принадлежность к процессу
              Writeln('Thread ID      ' + inttohex(ThreadEntry.th32ThreadID, 8));
              Writeln('base priority  ' + inttostr(ThreadEntry.tpBasePri));
              Writeln('delta priority ' + inttostr(ThreadEntry.tpBasePri));
              Writeln('');
          end;
          NextProc := Thread32Next(SnapProcHandle, ThreadEntry);//получаем следующий поток
        end;
      finally
        CloseHandle(SnapProcHandle);//освобождаем снэпшот
      end;
  end;

function GetPIDByName(const name: PWideChar): Cardinal;
var
  SnapProcHandle: THandle;
  ProcEntry : TProcessEntry32;
  NextProc : Boolean;
begin
  Result := 0;
  SnapProcHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    ProcEntry.dwSize := SizeOf(ProcEntry);
    NextProc := Process32First(SnapProcHandle, ProcEntry);
    while NextProc do begin
      if StrComp(name, ProcEntry.szExeFile) = 0 then
        Result := ProcEntry.th32ProcessID;
      NextProc := Process32Next(SnapProcHandle, ProcEntry);
    end;
  finally
    CloseHandle(SnapProcHandle);
  end;
end;
{
//--- Callback функция для получения имён при вызове SymEnumSymbols (старое название - )SymEnumerateSymbols
function cfEnumSymbols(SymbolName: PWideChar; SymbolAddress, SymbolSize: ULONG;
  Strings: Pointer): Bool; stdcall;
begin
  TStrings(Strings).Add(SymbolName);
  Result := True;
end;

procedure GetDLLExportList(const DllFileName: string; var outputList: TArray<string>);
var
  Handle: THandle;
  hProcess: THandle;
  VersionInfo: TOSVersionInfo;
begin

  SymSetOptions(SYMOPT_UNDNAME or SYMOPT_DEFERRED_LOADS);

  VersionInfo.dwOSVersionInfoSize := SizeOf(VersionInfo);
  if not GetVersionEx(VersionInfo) then
    Exit;

  if VersionInfo.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS then
    hProcess := GetCurrentProcessId
  else
    hProcess := GetCurrentProcess;

  if not SymInitialize(hProcess, nil, True) then
    Exit;
  try
    Handle := LoadLibrary(PChar(DllFileName));
    if Handle = 0 then
      Exit;
    try
      if not SymLoadModule(hProcess, 0, PAnsiChar(AnsiChar(DllFileName)), nil, Handle, 0) then
        Exit;
      try
        if not SymEnumerateSymbols(hProcess, Handle, cfEnumSymbols, outputList) then
          Exit;
      finally
        SymUnloadModule(hProcess, Handle);
      end;
    finally
      FreeLibrary(Handle);
    end;
  finally
    SymCleanup(hProcess);
  end;
  Result := True;
end;
}

//--- Вариант_2 получения списка экспорта из образа
procedure GetDLLExportList(const DllFileName: string; var outputList: TArray<string>);
 type
   TDWordArray = array [0..$FFFFF] of DWORD;
 var
   i: Word;
   imageinfo: LoadedImage;
   pExportDirectory: PImageExportDirectory;
   dirsize: Cardinal;
   pDummy: PImageSectionHeader;
   pNameRVAs: ^TDWordArray;
   DllProcName: string;
   tmpList: TStrings;
   tmpPointer: Pointer;
 begin
  tmpList:= TStrings.Create;
   if MapAndLoad(PAnsiChar(AnsiString(DllFileName)), nil, @imageinfo, true, true) then
   begin
     try
       pExportDirectory := ImageDirectoryEntryToData(imageinfo.MappedAddress,
         False, IMAGE_DIRECTORY_ENTRY_EXPORT, dirsize);
       if (pExportDirectory <> nil) then
       begin
       // Получим указатель на первое элемент (вхождение) в директории экспортныъ имён образа
         pNameRVAs := ImageRvaToVa(imageinfo.FileHeader, imageinfo.MappedAddress,
           DWORD(pExportDirectory^.AddressOfNames), pDummy);

       // Проход по асем вхождениям имён в директории образа
         for i := 0 to pExportDirectory^.NumberOfNames - 1 do
         begin
           tmpPointer:= ImageRvaToVa(imageinfo.FileHeader, imageinfo.MappedAddress,
             pNameRVAs^[i], pDummy);
           DllProcName:= Utf8ToWideString(PChar(tmpPointer));
           tmpList.Add(DllProcName);
         end;
       end;
     finally
       UnMapAndLoad(@imageinfo);
     end;
   end;
 end;


end.
