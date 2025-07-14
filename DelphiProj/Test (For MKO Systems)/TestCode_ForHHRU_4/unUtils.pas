unit unUtils;

interface
uses Vcl.Forms, System.Classes, System.SysUtils, Winapi.Windows, Winapi.Messages, IOUtils,
     TlHelp32, ImageHlp, {PsAPI,}
     unVariables;

function GetWorkingDirectoryName(): String;
//function IsTaskDllAttached(DllFileName: String): Integer;
procedure GetLibraryInfo(DllFileName: WideString; var inoutLibraryTask: TLibraryTask);
//procedure GetDLLExportList(const DllFileName: string; var outputList: TArray<string>);
//--- ��������� ��������� �� ������, ���������� ';'
procedure GetItemsFromString(SourceBSTR: WideString; var outputStringItems: TArray_WideString);
procedure FinalizeLibraryes;
function LoadLibrary(const LibraryFileName: WideString): HMODULE;

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
----- ������� ������ � ������������ � ������� ������ �� ��������� ������� TDirectory, TFile
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


function LoadLibrary(const LibraryFileName: WideString): HMODULE;
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
    DLLPath := ExtractFilePath(LibraryFileName);
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

    Result := LoadLibraryW(PWideChar(LibraryFileName));
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
    delete(SourceBSTR, 1, Length(outputStringItems[i]) + 1); //--- ������ ��������� ������ � �����������
    inc(i);
   end;
 end;
end;


procedure GetLibraryInfo(DllFileName: WideString; var inoutLibraryTask: TLibraryTask);
var
  tmp_hTaskLibrary: THandle;  //--- �� �� HMODULE
  tmpDLLAPIProc: TDLLAPIProc;
  tmpBSTR, tmpWString: WideString; //--- ��� ������ �������� � Dll ������ BSTR (��� � ����� WideString)
  i, tmpInfoRecordSize, tmpInfoRecordCount: Byte;
  tmpIntrfDllAPI: ILibraryAPI;
begin
 inoutLibraryTask.LibraryName:= '';
try


 tmp_hTaskLibrary:= LoadLibrary(DllFileName); //, 0, LOAD_LIBRARY_AS_DATAFILE{DONT_RESOLVE_DLL_REFERENCES});

 @tmpDLLAPIProc:= GetProcAddress(tmp_hTaskLibrary, DllProcName_LibraryInfo);
 Win32Check(Assigned(tmpDLLAPIProc));

//--- ����� ���������� ���������� � ��������
 tmpDLLAPIProc(ILibraryAPI, tmpIntrfDllAPI);

//--- ������� ��� ����������
 inoutLibraryTask.LibraryName:= tmpIntrfDllAPI.Name;

 //--- ������� ���������� � ������� �������� �����
 inoutLibraryTask.Clear;

 //--- ������� ���������� ������������� � ���������� �����
 inoutLibraryTask.TaskCount:= tmpIntrfDllAPI.GetTaskList.Count;

 //--- ������� ����� ������������� �����
 for i:= 0 to tmpIntrfDllAPI.GetTaskList.Count do
 begin
  inoutLibraryTask.TaskTemplateName[i]:= tmpIntrfDllAPI.GetTaskList.Strings[i];
//  inoutLibraryTaskInfo.TaskLibraryIndex:= i;
 end;

// tmpIntrfDllAPI.GetFormParams;

{
//--- ������� �� ���������� ������ ������ ������ - �������������� ������������ ����������
  LibraryName:= AnsiString(Copy(tmpBSTR, 1, pos(';', tmpBSTR, 1) - 1));
  delete(tmpBSTR, 1, Length(LibraryName) + 1); //--- ������ ��������� ������ � �����������

//--- ������� ������������ ���� ����������� �����
GetItemsFromString(tmpBSTR, TaskDllProcName);
}
 if intrfDllAPI = nil then
    inoutLibraryTask.LibraryAPI:= tmpIntrfDllAPI;
//  intrfDllAPI:= tmpIntrfDllAPI;

 //--- ���� ��� �������� LibraryAPI.InitDLL
  inoutLibraryTask.LibraryAPI.InitDLL;
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
    intrfDllAPI.FinalizeDLL;         //--- ����� �������� ������
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
    SnapProcHandle := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0); //������� ������� ���� ������������ �������
    Result := (SnapProcHandle <> INVALID_HANDLE_VALUE);
    if Result then
      try
        ThreadEntry.dwSize := SizeOf(ThreadEntry);
        NextProc := Thread32First(SnapProcHandle, ThreadEntry);//�������� ������ �����
        while NextProc do begin
          if ThreadEntry.th32OwnerProcessID = PID then begin //�������� �� �������������� � ��������
              Writeln('Thread ID      ' + inttohex(ThreadEntry.th32ThreadID, 8));
              Writeln('base priority  ' + inttostr(ThreadEntry.tpBasePri));
              Writeln('delta priority ' + inttostr(ThreadEntry.tpBasePri));
              Writeln('');
          end;
          NextProc := Thread32Next(SnapProcHandle, ThreadEntry);//�������� ��������� �����
        end;
      finally
        CloseHandle(SnapProcHandle);//����������� �������
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

end.
