unit unUtils;

interface
uses Vcl.Forms, System.Classes, System.SysUtils, Winapi.Windows, Winapi.Messages, Vcl.StdCtrls, IOUtils,
     Vcl.AxCtrls, TlHelp32, ImageHlp, {PsAPI,}
     unVariables;

function GetWorkingDirectoryName(): WideString;
//function IsTaskDllAttached(DllFileName: String): Integer;
procedure GetLibraryInfo(inputDllFileName: WideString; inputLibraryNum: word);
//procedure GetDLLExportList(const DllFileName: string; var outputList: TArray<string>);
//--- ��������� ��������� �� ������, ���������� ';'
procedure GetItemsFromString(SourceBSTR: WideString; var outputStringItems: TArray_WideString);
procedure FinalizeLibraryes;
function LoadAnyLibrary(const LibraryFileName: WideString): HMODULE;
function GetPIDByName(const name: PWideChar): Cardinal;
function GetThreadsInfo(PID: Cardinal; var ThreadList: TArray<WideString>): Boolean;
function GetThreadsInfoBySubThread(PID: Cardinal; var memViewer: TMemo; memViewerLine: word): Boolean;


implementation
uses unConst, unUtilCommon;

function GetWorkingDirectoryName(): WideString;
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


function LoadAnyLibrary(const LibraryFileName: WideString): HMODULE;
var
  DLLPath: String;
begin
 try
  if FileExists(LibraryFileName) then
  begin
   Result := LoadLibrary(PWideChar(LibraryFileName)); //LoadLibraryEx(PWideChar(LibraryFileName), 0, LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR or LOAD_LIBRARY_SEARCH_DEFAULT_DIR);
   Win32Check(Result <> 0);
  end
  else
  begin
   Result:= 0;
   exit;
  end;
 finally
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


procedure GetLibraryInfo(inputDllFileName: WideString; inputLibraryNum: word);
var
  tmp_hTaskLibrary: THandle;  //--- �� �� HMODULE
  tmpDLLAPIProc: TDLLAPIProc;
  tmpBSTR, tmpWString: WideString; //--- ��� ������ �������� � Dll ������ BSTR (��� � ����� WideString)
  tmpInfoRecordSize, tmpInfoRecordCount: Byte;
  tmpInt: integer;
  tmpIntrfDllAPI: ILibraryAPI;
begin
 LibraryList[inputLibraryNum].LibraryName:= '';
try
 for tmpInt:= 0 to LibraryList.Count - 1 do
//--- ��������� �� ������ ����������� ����������, ���� ����� ��� ����, �� �������
  if LibraryList.Items[tmpInt].LibraryFileName = inputDllFileName then
  begin
   LibraryList.Items[tmpInt].Free;
  end;

 tmp_hTaskLibrary:= LoadAnyLibrary(inputDllFileName);
 if tmp_hTaskLibrary = INVALID_HANDLE_VALUE then
 begin
  WriteDataToLog(wsError_LoadLibrary + ': ' + inputDllFileName, 'GetLibraryInfo()', 'unUtils');
  exit;
 end;


//--- ��������� ���������� ������ ���������� � ��������
 try
  @tmpDLLAPIProc:= GetProcAddress(tmp_hTaskLibrary, DllProcName_LibraryInfo);
  if not Win32Check(Assigned(tmpDLLAPIProc)) then
  begin
   FreeLibrary(tmp_hTaskLibrary);
   WriteDataToLog(wsError_LoadLibraryWithTargetAPI + ': ' + inputDllFileName, 'GetLibraryInfo()', 'unUtils');
  end;
 except
  FreeLibrary(tmp_hTaskLibrary);
  WriteDataToLog(wsError_LoadLibraryWithTargetAPI + ': ' + inputDllFileName, 'GetLibraryInfo()', 'unUtils');
  exit;
 end;


//--- ����� ���������� ����������
 tmpDLLAPIProc(ILibraryAPI, tmpIntrfDllAPI);
 if not Assigned(tmpIntrfDllAPI) then
 begin
  FreeLibrary(tmp_hTaskLibrary);
  WriteDataToLog(wsError_LoadLibraryWithTargetAPI + ': ' + inputDllFileName, 'GetLibraryInfo()', 'unUtils');
  exit;
 end;

//--- �������� ��������� � ������� LibraryTask
 if LibraryList[inputLibraryNum].LibraryAPI = nil then
    LibraryList[inputLibraryNum].LibraryAPI:= tmpIntrfDllAPI;

//--- ������� Id ����������
 LibraryList[inputLibraryNum].LibraryId:= tmpIntrfDllAPI.GetId;

//--- ������� ��� ����������
 LibraryList[inputLibraryNum].LibraryName:= tmpIntrfDllAPI.Name;

  //--- ������� ���������� � ������� �������� �����
// inoutLibraryTask.Clear;

 //--- ������� ���������� ������������� � ���������� �����
 LibraryList[inputLibraryNum].TaskCount:= tmpIntrfDllAPI.GetTaskList.Count;
 LibraryList[inputLibraryNum].SetTaskTemplateCount(tmpIntrfDllAPI.GetTaskList.Count);
 //--- ������� ����� ������������� �����
 for tmpInt:= 0 to (tmpIntrfDllAPI.GetTaskList.Count - 1) do
 begin
  LibraryList[inputLibraryNum].TaskTemplateName[tmpInt]:= tmpIntrfDllAPI.GetTaskList.Strings[tmpInt];
 end;

// tmpIntrfDllAPI.GetFormParams;

{
//--- ������� �� ���������� ������ ������ ������ - �������������� ������������ ����������
  LibraryName:= AnsiString(Copy(tmpBSTR, 1, pos(';', tmpBSTR, 1) - 1));
  delete(tmpBSTR, 1, Length(LibraryName) + 1); //--- ������ ��������� ������ � �����������

//--- ������� ������������ ���� ����������� �����
GetItemsFromString(tmpBSTR, TaskDllProcName);
}

//------------>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 if intrfDllAPI = nil then
    LibraryList[inputLibraryNum].LibraryAPI:= tmpIntrfDllAPI;

 //--- ���� ��� �������� LibraryAPI.InitDLL
//--- �������� ��
  LibraryList[inputLibraryNum].LibraryAPI.InitDLL;
  tmpIntrfDllAPI:= nil;

  LibraryList[inputLibraryNum].SetLibraryFileName(inputDllFileName);
  LibraryList[inputLibraryNum].LibraryHandle:= tmp_hTaskLibrary;
//--- ��������� ������ �������� ����������� �� ��������� � ������� ������
   LibraryList[inputLibraryNum].Stream:= TOleStream.Create(LibraryList[inputLibraryNum].LibraryAPI.GetStream);
   LibraryList[inputLibraryNum].Stream.Position:= 0;
   LibraryList[inputLibraryNum].Stream_LastPos:= 0;


finally
 if tmpintrfDllAPI <> nil then
 begin
//--- �������� _RefCount ��� ���������� ���������
//--- ������ � ���������� ��������� ������ ������ ����� LibraryList[inputLibraryNum.LibraryAPI
  tmpintrfDllAPI:= nil;
 end;
end;
end;

procedure FinalizeLibraryes;
var
  tmpWord: word;
begin
 for tmpWord:= 0 to (LibraryList.Count - 1) do
 begin
  if LibraryList[tmpWord].LibraryAPI <> nil then
  begin
    LibraryList[tmpWord].LibraryAPI.FinalizeDLL;         //--- ����� �������� ������
    LibraryList[tmpWord].LibraryAPI:= nil;
  end;
  if LibraryList[tmpWord].LibraryHandle <> 0 then
  begin
    FreeLibrary(LibraryList[tmpWord].LibraryHandle);
    LibraryList[tmpWord].LibraryHandle := 0;
  end;
 end;
end;


function GetThreadsInfo(PID: Cardinal; var ThreadList: TArray<WideString>): Boolean;
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
          if ThreadEntry.th32OwnerProcessID = PID then
          begin //�������� �� �������������� � ��������
           setlength(ThreadList, length(ThreadList) + 1);
           ThreadList[length(ThreadList) - 1]:= inttostr(ThreadEntry.th32ThreadID);
//              Writeln('base priority  ' + inttostr(ThreadEntry.tpBasePri));
//              Writeln('delta priority ' + inttostr(ThreadEntry.tpBasePri));
//              Writeln('');
          end;
          NextProc := Thread32Next(SnapProcHandle, ThreadEntry);//�������� ��������� �����
        end;
      finally
        CloseHandle(SnapProcHandle);//����������� �������
      end;
  end;


function GetThreadsInfoBySubThread(PID: Cardinal; var memViewer: TMemo; memViewerLine: word): Boolean;
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
              memViewer.Lines[memViewerLine]:= memViewer.Lines[memViewerLine] + 'Thread ID ' + inttostr(ThreadEntry.th32ThreadID) + '; ';
//              Writeln('base priority  ' + inttostr(ThreadEntry.tpBasePri));
//              Writeln('delta priority ' + inttostr(ThreadEntry.tpBasePri));
//              Writeln('');
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

initialization

finalization

end.
