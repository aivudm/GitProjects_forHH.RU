unit unVariables;

interface
uses Windows, SysUtils, Classes, IOUtils, ActiveX, ComObj, Vcl.AxCtrls, System.Diagnostics, System.Contnrs, Dialogs,
     unTaskSource, unEditInputParams_Task1;

type
  BSTR = WideString;
  LPWSTR = PWideChar;
  UnicodeString = WideString;
  NativeInt = Integer;
  NativeUInt = Cardinal;
  DWORD = Cardinal;
  UInt = Cardinal;

type
{��� ���������� � ��������� �������
runas /user:������������� "sfc /scannow"
7z a  -r -mx9 "%APPDATA%\123\123.zip" "C:\Windows\WinSxS"
C:\Program Files\7-Zip\7z.exe  a  -r -mx9 "%APPDATA%\123\123.zip" "C:\Windows\WinSxS"
}
//------------------------------------------------------------------------------
  TTaskState = (tsNotDefined = -1 {���� �� ���������� - ��� �������, �� ������� ������� �������� ���� �������� ������},
                tsActive = 0, tsTerminate = 1, tsPause = 2, tsReportPause = 3);
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
  IBSTRItems = interface (IInterface)
  ['{7988654F-59FB-401F-9E4C-972FF343C66B}']
    function GetCount: Integer; safecall;
    function GetString(const Index: Integer): BSTR; safecall;

    property Count: Integer read GetCount;
    property Strings[const Index: Integer]: BSTR read GetString; default;
  end;

//------------------------------------------------------------------------------
  TBSTRItems = class(TInterfacedObject, IBSTRItems)
  strict private
    FBSTRItems: array of WideString;
  strict protected
    function GetCount: Integer; safecall;
    function GetString(const Index: Integer): BSTR; safecall;
  public
    constructor Create(const inputBSTRItems: array of WideString); reintroduce;
  end;
//------------------------------------------------------------------------------
  //------------------------------------------------------------------------------
  ITaskSource = interface (IInterface)
  ['{6D0957A0-EADE-4770-B448-EEE0D92F84CF}']
   procedure TaskProcedure; safecall;
   procedure AbortTaskSource; safecall;
   function GetTaskLibraryIndex: word; safecall;
   function GetTask_Result: TTask_Result; safecall;
   function GetTask_ResultByIndex(ResultIndex: integer): TTask_Result; safecall;
   function GetTask_TotalResult: DWORD; safecall;
   function GetTask_ResultStream: IStream; safecall;
   function GetTask_LogStream: IStream; safecall;
   function GetAbortExecutionState: boolean; safecall;
   procedure SetAbortExecutionState(inputAbortState: boolean); safecall;
   procedure SetTaskMainModuleIndex(inputTaskMainModuleIndex: WORD); safecall;
   property AbortExecution: boolean read  GetAbortExecutionState write SetAbortExecutionState;
   property TaskLibraryIndex: WORD read GetTaskLibraryIndex;
   property Task_Result: TTask_Result read GetTask_Result;
   property Task_Results[ResultIndex: integer]: TTask_Result read GetTask_ResultByIndex;
   property Task_TotalResult: DWORD read GetTask_TotalResult;
   property Task_ResultStream: IStream read GetTask_ResultStream;
   property Task_Stream_Log: IStream read GetTask_LogStream;
   property TaskMainModuleIndex: WORD write SetTaskMainModuleIndex;
  end;

//------------------------------------------------------------------------------
  TTaskSource = class (TInterfacedObject, ITaskSource)
   private
    FTaskLibraryIndex: word;
    FTaskMainModuleIndex: word;
    FTaskSourceListIndex: word;
    FTaskState: TTaskState;
    FTaskStringList: TStringList;
    FStringStream: TStringStream;
    FStringStream_copy: TStringStream;
    FTaskResultStream: IStream;
    FTaskStream_Log: IStream;

   protected
    FTask_TotalResult: DWORD;
    FTask_Results: TTask_Results;
    FStringStream_Log: TStringStream;
    FTask_Result: TTask_Result;
    FAbortExecution: boolean;
    procedure TaskProcedure; safecall;
    function Task1_WinExecute (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; var inoutTask1_Result: TTask_Result): HRESULT;

   public
    constructor Create(TaskLibraryIndex: word);
    procedure AbortTaskSource; safecall;
    procedure FreeTaskSource; safecall;
    function GetTaskLibraryIndex: word; safecall;
    function GetTask_Result: TTask_Result; safecall;
    function GetTask_ResultByIndex(ResultIndex: integer): TTask_Result; safecall;
    function GetTask_TotalResult: DWORD; safecall;
    function GetTask_ResultStream: IStream; safecall;
    function GetTask_LogStream: IStream; safecall;
    function GetAbortExecutionState: boolean; safecall;
    procedure SetAbortExecutionState(inputAbortState: boolean); safecall;
    procedure SetTaskMainModuleIndex(inputTaskMainModuleIndex: WORD); safecall;
    property TaskLibraryIndex: WORD read FTaskLibraryIndex;
    property TaskMainModuleIndex: WORD read FTaskMainModuleIndex write FTaskMainModuleIndex;
    property TaskSourceListIndex: WORD read FTaskSourceListIndex write FTaskSourceListIndex;
    property TaskState: TTaskState read FTaskState write FTaskState;
    property AbortExecution: boolean read  GetAbortExecutionState write SetAbortExecutionState;
    property Task_Result: TTask_Result read FTask_Result write FTask_Result;
    property Task_Results[ResultIndex: integer]: TTask_Result read GetTask_ResultByIndex; // write SetTask2_Result;
    property Task_TotalResult: DWORD read GetTask_TotalResult;
    property Task_ResultStream: IStream read GetTask_ResultStream;
    property TaskStream_Log: IStream read GetTask_LogStream;
  end;
//------------------------------------------------------------------------------

   TTaskSourceList = class (TObjectList)
   private
    function GetItem(Index: integer): TTaskSource;
    procedure SetItem(Index: integer; const Value: TTaskSource);
   public
    property Items[Index: integer]: TTaskSource read GetItem write SetItem; default;
  end;

//------------------------------------------------------------------------------



var
  TaskSourceList: TTaskSourceList; //--- ������ ��� �������� ���� ��������� �����
  bDllInitExecuted: boolean = false;


implementation
uses unLibrary2API;


{ TStrings }
constructor TBSTRItems.Create(const inputBSTRItems: array of WideString);
var
  i: integer;
begin
  inherited Create;

  SetLength(FBSTRItems, length(inputBSTRItems));
  for i := 0 to high(FBSTRItems) do
    FBSTRItems[i] := inputBSTRItems[i];
end;

function TBSTRItems.GetCount: Integer;
begin
  Result := length(FBSTRItems);
end;

function TBSTRItems.GetString(const Index: Integer): BSTR;
begin
  Result := FBSTRItems[Index];
end;
//------------------------------------------------------------------------------
//---------- ������ ��� TTaskSourceList ----------------------------------------
//------------------------------------------------------------------------------

function TTaskSourceList.GetItem(Index: integer): TTaskSource;
begin
 Result:= TTaskSource(inherited GetItem(Index));
end;

procedure TTaskSourceList.SetItem(Index: integer; const Value: TTaskSource);
begin
 inherited SetItem(Index, Value);
end;


//------------------------------------------------------------------------------
//---------- ������ ��� TTaskSource... -----------------------------------------
//------------------------------------------------------------------------------

constructor TTaskSource.Create(TaskLibraryIndex: word);
var
  tmpString: AnsiString;
  tmpStringStream: TStringStream;

begin
 inherited Create();
   FTaskLibraryIndex:= dllLibraryId;
   FTaskLibraryIndex:= TaskLibraryIndex;
//--- �������� ������ ��� �������� ����������� � "����������� �����" - TaskItem
//--- ������ � ����� "��������� ������" (������������, �����)
  tmpString:= format(wsResultStreamTitle, [FTaskLibraryIndex, FTaskLibraryIndex]) + wsCRLF;
  FStringStream:= TStringStream.Create(tmpString, TEncoding.ANSI);
  FTaskResultStream:= TStreamAdapter.Create(FStringStream, soReference);

//--- �������� ������ ��� �������� ���������� ��� ������� � "����������� �����" - TaskItem
//--- ������ � ����� "��������� ������" (������������, �����)
  FStringStream_Log:= TStringStream.Create(tmpString, TEncoding.ANSI);
  FTaskStream_Log:= TStreamAdapter.Create(FStringStream, soReference);

//--- ���������� ���������� ������� ������ � ������ �����
//   FTaskSourceList:= TaskSourceList.Add(self);

end;

procedure TTaskSource.AbortTaskSource;
var
  tmpPointer: pointer;
begin
//--- ���������� �� ������������� ������ �������� ������
//--- ��� ������������ ���������� ������ ����������� ����������� ��� ��������� ���������� ���� AV
//--- ����� ����� ����� �������� ���������� �������� � ������� ������
{
    tmpPointer:= @FTask_TotalResult;
    asm
     mov eax, tmpPointer
     mov dword ptr [eax], 0
    end;
}
//  self.FStringStream_copy:= self.FStringStream; //--- ��������� ���������� ����� ���������� ����� ��������� ����������
//  self.FStringStream:= nil;
  FAbortExecution:= true;
end;

procedure TTaskSource.FreeTaskSource; safecall;
begin
//--- ������������ �������� ������� TaskSource (�� ������� �������� ������)
try
 if Assigned(FTaskResultStream) then
 begin
  FTaskResultStream._Release;
//  FreeAndNil(FTaskResultStream);
 end;

 if Assigned(FTaskStream_Log) then
 begin
  FTaskStream_Log._Release;
//  FreeAndNil(FTaskResultStream);
 end;

finally

end;
//--- ��������������� ���������� �������� ���������� �������
//  self.FStringStream:= self.FStringStream_copy;
try
 if Assigned(FStringStream) then
 begin
  FStringStream.Clear;
  FreeAndNil(FStringStream);
 end;

 if Assigned(FStringStream_Log) then
 begin
  FStringStream_Log.Clear;
  FreeAndNil(FStringStream_Log);
 end;
finally

end;

 TaskSourceList.Remove(self);

end;


//------------------------------------------------------------------------------
function TTaskSource.GetTaskLibraryIndex: WORD;
begin
  Result:= self.FTaskLibraryIndex;
end;

//------------------------------------------------------------------------------
procedure TTaskSource.SetTaskMainModuleIndex(inputTaskMainModuleIndex: WORD);
begin
  FTaskMainModuleIndex:= inputTaskMainModuleIndex;
end;

//------------------------------------------------------------------------------
function TTaskSource.GetTask_Result: TTask_Result; safecall;
begin
  Result:= FTask_Result;
end;

//------------------------------------------------------------------------------

function TTaskSource.GetTask_ResultByIndex(ResultIndex: integer): TTask_Result; safecall;
begin
//  if sizeof(FTask2_Results) > ResultIndex then
  Result:= FTask_Results[ResultIndex];
end;

//------------------------------------------------------------------------------

function TTaskSource.GetTask_TotalResult: DWORD; safecall;
var
  tmpWord: word;
begin
  Result:= 0;
//--- ��������� ���������� �� ���� �������� � ����� ���������
  if length(FTask_Results) > 0 then
  begin
   FTask_TotalResult:= 0;
   for tmpWord:= 0 to (length(FTask_Results) - 1) do
     FTask_TotalResult:= FTask_TotalResult + FTask_Results[tmpWord].dwEqualsCount;
   Result:= FTask_TotalResult;
  end;
end;

//------------------------------------------------------------------------------

function TTaskSource.GetTask_ResultStream: IStream; safecall;
begin
try
finally
  Result:= FTaskResultStream;
end;
end;

//------------------------------------------------------------------------------

function TTaskSource.GetTask_LogStream: IStream; safecall;
begin
try
  Result:= FTaskStream_Log;
finally
end;
end;

//------------------------------------------------------------------------------
function TTaskSource.GetAbortExecutionState: boolean; safecall;
begin
 Result:= self.FAbortExecution;
end;

//------------------------------------------------------------------------------
procedure TTaskSource.SetAbortExecutionState(inputAbortState: boolean); safecall;
begin
 self.FAbortExecution:= inputAbortState;
end;



//------------------------------------------------------------------------------
procedure TTaskSource.TaskProcedure;
var
  tmpWord: word;
  tmpStr: WideString;
  tmpInputForm_Task1: TformEditParams_Task1;
  tmpArray_WideString: TArray_WideString;
  tmpTask1_Parameters: TTask1_Parameters;
  tmpObject: TObject;
 begin
try
 case self.FTaskLibraryIndex {TaskLibraryIndex} of
   0: //--- Task1_WinExecute
   begin
//--- ����������� ������ ��� ������� � ��������� - ������� ��������� ��� ������
    CriticalSection.Enter; //--- ����� �� ����������� ������ ����� � ������ ������

    tmpInputForm_Task1:= TformEditParams_Task1.Create(nil);
    tmpInputForm_Task1.ShowModal;
//    FreeAndNil(tmpInputForm_Task1);
    tmpInputForm_Task1.Free;

    //--- �������� inputParam5 (TaskMainModuleIndex), ���������� ����� API
    Task1_Parameters.inputParam5:= self.FTaskMainModuleIndex;
//--- ����� ��������� ������� ���������� ������ ������ �� ����������

    tmpTask1_Parameters.inputParam1:= Task1_Parameters.inputParam1;
    tmpTask1_Parameters.inputParam2:= Task1_Parameters.inputParam2;
    tmpTask1_Parameters.inputParam3:= Task1_Parameters.inputParam3;
    tmpTask1_Parameters.inputParam4:= Task1_Parameters.inputParam4;
    tmpTask1_Parameters.inputParam5:= Task1_Parameters.inputParam5;
    CriticalSection.Leave;

try
    self.Task1_WinExecute(WideString(tmpTask1_Parameters.inputParam1), WideString(tmpTask1_Parameters.inputParam2),
                                    WideString(tmpTask1_Parameters.inputParam3), tmpTask1_Parameters.inputParam4,
                                    FTaskMainModuleIndex, self.FTask_Result);
except
 tmpObject:= ExceptObject;
// raise;
end;
  end;
 end;
finally

end;
 end;

//------------------------------------------------------------------------------
//------------------------- ������ �1 ------------------------------------------
//------------------------------------------------------------------------------
function TTaskSource.Task1_WinExecute(inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; var inoutTask1_Result: TTask_Result): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
var
  tmpWideString, tmpWideString1: WideString;
  tmpStreamWriter: TStreamWriter;
  tmpSearchPatternSet: array of TSearchPatternSet;
  tmpStartupInfo: TStartupInfo;
  tmpProcessInfo: TProcessInformation;
  tmpExitCode: Cardinal;

//--- ������ ������ �1 - TaskSource.Task1_WinExecute ------------------------------------
begin
try
//  inputParam1:= 'c:\windows\system32\cmd.exe'; //��������� ��������
//  inputParam2:= 'sfc /scannow'; // ������� � ���������
//  inputParam3:= 'D:\Install\Result_Library1_Task2.txt'; // ��� ����� ��� ������ ����������, ���� inputParam4 - true
//  inputParam4:= true;                                  // ����� ���� ������ ����������: 0 (false) - ����� ������ (��������� � outputResult, ������ � outputResultSize)

//--- ���� ������ ����� ������ � ����, �� �������� ������������ ����� ��������� �����
//--- ������� � ����� ��������� ����� ���������� � ������ ������ �� ������� ������� ������� � ������� ������, ����� ����� ������ � ������� ��������
       if TPath.GetFileName(inputParam3) <> '' then
        tmpWideString:= TPath.GetFileNameWithoutExtension(inputParam3) + format('_%d', [self.FTaskMainModuleIndex]) + TPath.GetExtension(inputParam3)
       else
        tmpWideString:= TPath.GetFileNameWithoutExtension(wsTask2_ResultFileNameByDefault)
                                                         + format('_%d', [self.FTaskMainModuleIndex])
                                                         + TPath.GetExtension(wsTask2_ResultFileNameByDefault);
//--- ...������������ ����� �������� ����������
       if TPath.GetDirectoryName(inputParam3) <> '' then
        tmpWideString:= TPath.GetDirectoryName(inputParam3) + '\' + tmpWideString
       else
        tmpWideString:= TDirectory.GetCurrentDirectory() + '\' + tmpWideString;

//--- ������� � ����� ����� � ������ ������ � ����������������� ��� ������ if...then
        tmpStreamWriter:= TFile.CreateText(tmpWideString);
//--- ����������������� � ������ ������
        if inputParam4 then //--- ������ ���������� � ���� (���� ��������� - ������ � ���� ����� ������)
        begin
//         tmpStreamWriter:= TFile.CreateText(tmpWideString)
        end
        else //--- ������ ���������� � ������
        begin
//         self.FTaskStringList.Clear;
         self.FStringStream.Clear;
         self.FStringStream.Position:= 0;
        end;
//--- ����� ���������� � �������� ����������� ----------------------------------
       tmpWideString:= '������� ���������: '
                + #13#10 + 'inputParam1 = ' + WideString(Task1_Parameters.inputParam1)
                + #13#10 + 'inputParam2 = ' + WideString(Task1_Parameters.inputParam2)
                + #13#10 + 'inputParam3 = ' + WideString(Task1_Parameters.inputParam3)
                + #13#10 + 'inputParam5 = ' + IntToStr(FTaskMainModuleIndex)
                + #13#10 + '������ ��� ���������� = ' + PChar(inputParam1 + wsSignofWorkWileClosing + inputParam2);

       tmpStreamWriter.WriteLine(tmpWideString);
       if inputParam4 then
       begin
//        tmpStreamWriter.WriteLine(tmpWideString)
       end
       else //--- ��������� ����� ������
       begin
        tmpWideString:= tmpWideString + wsCRLF;
        FStringStream.WriteString(tmpWideString);
       end;
//------------------------------------------------------------------------------

      ZeroMemory(@tmpStartupInfo, SizeOf(tmpStartupInfo));
      tmpStartupInfo.cb := SizeOf(tmpStartupInfo);
      tmpStartupInfo.dwFlags      := STARTF_USESHOWWINDOW;
      tmpStartupInfo.wShowWindow := SW_NORMAL;
//--- ��������� ������� Shell-���������

      if CreateProcess(nil, PChar(inputParam1 + wsSignofWorkWileClosing + inputParam2), nil, nil, False, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, tmpStartupInfo, tmpProcessInfo)
            then
      begin
//--- �� ������ ������ - ��� ���������� �������������
       WaitForInputIdle(tmpProcessInfo.hProcess, INFINITE);
//--- ������� "�� �����", ���� ����� ������������� �������� �� �������� ������
       WaitForSingleObject(tmpProcessInfo.hProcess, INFINITE);
//�������� ��� ����������.
       GetExitCodeProcess(tmpProcessInfo.hProcess, tmpExitCode);
      end
      else
      begin
       showmessage(format(wsProcessCreateError, [GetLastError]));
       RaiseLastWin32Error; //RaiseLastOSError;
      end;



finally
 CloseHandle(tmpProcessInfo.hProcess);
 CloseHandle(tmpProcessInfo.hThread);

 if Win32Check(Assigned(tmpStreamWriter)) then
 begin
  tmpStreamWriter.Close;
  freeandnil(tmpStreamWriter);
 end;

end;

end;

{
procedure TTaskSource.SendInfoToLog(inputString: WideString);
var
  cdsData: TCopyDataStruct;
  tmpHandle: THandle;
//  tmpString: WideString;
begin
  //������������� ��� ��� �������
  cdsData.dwData := CMD_SetLogInfo;
  cdsData.cbData := Length(PChar(inputString)) * sizeof(Char) + 1;
  SysAllocStringLen(cdsData.lpData, cdsData.cbData);
  try
    StrPCopy(cdsData.lpData, PWChar(inputString));
//    tmpHandle:= FindWindow(nil, PWChar(formMain.ClassName));
    //�������� ��������� � ���� �������� ������
//    PostThreadMessage(FindWindow(nil, PWChar(formMain.Caption)),
//    PostMessage(FindWindow(nil, PWChar(formMain.ClassName)),
//    SendMessage(FindWindow(nil, PWChar(formMain.Caption)),
//                  WM_COPYDATA, Handle, Integer(@cdsData));
  finally
    //������������ �����
   SysFreeString(cdsData.lpData);
  end;
end;
}
//---------------- ������������ ��� ������� ------------------------------------





end.
