unit unUtils;

interface
uses Vcl.Forms, System.Classes, System.SysUtils, Winapi.Windows, Winapi.Messages, IOUtils,
     TlHelp32, ImageHlp, {PsAPI,}
     unVariables;

function GetWorkingDirectoryName(): String;
//function IsTaskDllAttached(DllFileName: String): Integer;
procedure GetLibraryInfo(DllFileName: WideString; var inoutLibraryTask: TLibraryTask);
//procedure GetDLLExportList(const DllFileName: string; var outputList: TArray<string>);
//--- Получение элементов из строки, разделённых ';'
procedure GetItemsFromString(SourceBSTR: WideString; var outputStringItems: TArray_WideString);
procedure FinalizeLibraryes;


implementation
uses unConst, unUtilCommon;

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


function LoadDLL(const DllFileName: WideString): HMODULE;
var
  DLLPath: String;
  OldDir: String;
  OldPath: UnicodeString;
  {$IFDEF WIN32}
  FPUControlWord: Word;
  {$ENDIF}
  {$IFDEF WIN64}
  FPUControlWord: Word;
  {$ENDIF}
begin
  OldDir := GetCurrentDir;
  OldPath := GetEnvironmentVariable('PATH');
  try
    DLLPath := ExtractFilePath(DllFileName);
    SetEnvironmentVariableW('PATH', PWideChar(DLLPath + ';' + OldPATH));
    SetCurrentDir(DLLPath);

    {$IFDEF WIN32}
    asm
      FNSTCW  FPUControlWord
    end;
    {$ENDIF}
    {$IFDEF WIN64}
    FPUControlWord := Get8087CW();
    {$ENDIF}
    try

    Result := LoadLibraryW(PWideChar(DllFileName));
    Win32Check(Result <> 0);

    finally
      {$IFDEF WIN32}
      asm
        FNCLEX
        FLDCW FPUControlWord
      end;
      {$ENDIF}
      {$IFDEF WIN64}
      TestAndClearFPUExceptions(0);
      Set8087CW(FPUControlWord);
      {$ENDIF}
    end;
  finally
    SetEnvironmentVariableW('PATH', PWideChar(OldPATH));
    SetCurrentDir(OldPath);
  end;
  SetLastError(0);
end;

procedure GetItemsFromString(SourceBSTR: WideString; var outputStringItems: TArray_WideString);
var
  i: word;
begin
 if pos(';', SourceBSTR, 1) > 0 then
 begin
  i:= 0;
  while pos(';', SourceBSTR, 1) > 0 do
   begin
    outputStringItems[i]:= Copy(SourceBSTR, 1, pos(';', SourceBSTR, 1) - 1);
    delete(SourceBSTR, 1, Length(outputStringItems[i]) + 1); //--- удалим прочтённую запись и разделитель
    inc(i);
   end;
 end;
end;


procedure GetLibraryInfo(DllFileName: WideString; var inoutLibraryTask: TLibraryTask);
var
  tmp_hTaskLibrary: THandle;  //--- он же HMODULE
  tmpDLLAPIProc: TDLLAPIProc;
  tmpCallingDLLProc: TCallingDLL1Proc1;
  tmpBSTR, tmpWString: WideString; //--- Для обмена строками с Dll только BSTR (или в Делфи WideString)
  i, tmpInfoRecordSize, tmpInfoRecordCount: Byte;
  tmpIntrfDllAPI: ILibraryAPI;
begin
 inoutLibraryTask.LibraryName:= '';
try


 tmp_hTaskLibrary:= LoadDLL(DllFileName); //, 0, LOAD_LIBRARY_AS_DATAFILE{DONT_RESOLVE_DLL_REFERENCES});

 @tmpDLLAPIProc:= GetProcAddress(tmp_hTaskLibrary, DllProcName_LibraryInfo);
 Win32Check(Assigned(tmpDLLAPIProc));

//--- Вызов интерфейса библиотеки с задачами
 tmpDLLAPIProc(ILibraryAPI, tmpIntrfDllAPI);

//--- Получим имя библиотеки
 inoutLibraryTask.LibraryName:= tmpIntrfDllAPI.Name;

 //--- Очистим переменную с именами шаблонов задач
 inoutLibraryTask.Clear;
//--- Получим имена реализованных задач
 for i:= 0 to tmpIntrfDllAPI.GetTaskList.Count do
 begin
  inoutLibraryTask.TaskTemplateName[i]:= tmpIntrfDllAPI.GetTaskList.Strings[i];
//  inoutLibraryTaskInfo.TaskLibraryIndex:= i;
 end;

// intrfDllAPI.GetFormParams;

{
//--- Выделим из полученной строки первую запись - функциональное наименование библиотеки
  LibraryName:= AnsiString(Copy(tmpBSTR, 1, pos(';', tmpBSTR, 1) - 1));
  delete(tmpBSTR, 1, Length(LibraryName) + 1); //--- удалим прочтённую запись и разделитель

//--- Выделим наименования всех реализуемых задач
GetItemsFromString(tmpBSTR, TaskDllProcName);
}
 if intrfDllAPI = nil then
  intrfDllAPI:= tmpIntrfDllAPI;

 tmpIntrfDllAPI:= nil;
finally
 if tmpintrfDllAPI <> nil then
 begin
  tmpintrfDllAPI:= nil;
 end;
 if tmp_hTaskLibrary <> 0 then
//  FreeLibrary(tmp_hTaskLibrary);
end;
end;

procedure FinalizeLibraryes;
begin
  if intrfDllAPI <> nil then
  begin
    intrfDllAPI.FinalizeDLL;         //--- Здесь вылетает ошибка
    intrfDllAPI := nil;
  end;
  if hTaskLibrary <> 0 then
  begin
    FreeLibrary(hTaskLibrary);
    hTaskLibrary := 0;
  end;
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
