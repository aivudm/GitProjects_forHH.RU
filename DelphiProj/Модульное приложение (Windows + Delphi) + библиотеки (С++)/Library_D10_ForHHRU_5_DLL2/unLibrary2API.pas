unit unLibrary2API;
{$A8}
{$MINENUMSIZE 4}
interface
uses
  Windows, SysUtils, ActiveX, Classes, Diagnostics, IOUtils, System.SyncObjs, Dialogs, DateUtils,
  unVariables, unEditInputParams_Task1, unTaskSource;

const
  dllLibraryId: DWORD = 1;
  dllFuncName: BSTR = 'Запуск внешних приложений (Библиотека №2)';
  dllVersion: BSTR = '1.0';

type
//------------------------------------------------------------------------------
  ILibraryAPI = interface (IInterface)
  ['{6D0957A0-EADE-4770-B448-EEE0D92F84CF}']
    // Методы реализуемые DLL API
    function GetId: DWORD; safecall;
    function GetName: BSTR; safecall;
    function GetVersion: BSTR; safecall;
    function GetTaskList: IBSTRItems; safecall;
    function GetTaskCount: DWORD; safecall;
    function NewTaskSource(var LibraryTaskIndex, MainModuleTaskIndex: word): ITaskSource; safecall;
    function GetTaskSource(var MainModuleTaskIndex: word): ITaskSource; safecall;
    function GetStream: IStream; safecall;
    procedure SetOwnerThread(var inputOwnerThread: DWORD); safecall;
    procedure InitDLL; safecall;
    procedure FinalizeDLL; safecall;
    procedure FreeTaskSource(var MainModuleTaskIndex: word); safecall;

    property Name: BSTR read GetName;
    property Version: BSTR read GetVersion;
    property TaskCount: DWORD read GetTaskCount;
    property Stream_Log: IStream read GetStream;

  end;
//------------------------------------------------------------------------------
  TLibraryAPI = class(TInterfacedObject, ILibraryAPI)
  strict private
    FLibraryId: DWORD;
    FLibraryFuncName: BSTR;
    FTaskCount: DWORD;
    FOwnerThread: DWORD;
    FStringStream: TStringStream;
    FStream: IStream;
  strict protected
    function GetId: DWORD; safecall;
    function GetName: BSTR; safecall;
    function GetVersion: BSTR; safecall;
    function GetTaskList: IBSTRItems; safecall;
    function GetTaskCount: DWORD; safecall;
    function NewTaskSource(var LibraryTaskIndex, MainModuleTaskIndex: word): ITaskSource; safecall;
    function GetTaskSource(var MainModuleTaskIndex: word): ITaskSource; safecall;
    function GetStream: IStream; safecall;
    procedure SetOwnerThread(var inputOwnerThread: DWORD); safecall;
    function NotifyReceiver_Thread: BOOL;
    procedure WriteDataToLog(E_source1, CurrentProcName, CurrentUnitName: WideString);
    procedure InitDLL; safecall;
    procedure FinalizeDLL; safecall;
    procedure FreeTaskSource(var MainModuleTaskIndex: word); safecall;
  public
    constructor Create;
  end;

var
  LibraryAPI: ILibraryAPI;

implementation

constructor TLibraryAPI.Create;
var
  tmpString: WideString;
begin
  inherited;
  FLibraryId:= dllLibraryId;
  FLibraryFuncName:= dllFuncName;
  FTaskCount:= GetTaskList.Count;

 tmpString:= format(wsLibraryTitle, [FLibraryId, FLibraryFuncName, FTaskCount]) + wsCRLF;
 FStringStream:= TStringStream.Create(tmpString, TEncoding.ANSI);
 FStream:= TStreamAdapter.Create(FStringStream, soReference);;
end;

function TLibraryAPI.GetId: DWORD; safecall;
begin
  Result := FLibraryId;
end;

//------------------------------------------------------------------------------
function TLibraryAPI.GetName: BSTR;
begin
  Result := FLibraryFuncName;
end;


//------------------------------------------------------------------------------
function TLibraryAPI.GetVersion: BSTR;
begin
  Result := dllVersion;
end;

//------------------------------------------------------------------------------
function TLibraryAPI.GetTaskCount: DWORD;
begin
  Result := FTaskCount;
end;

//------------------------------------------------------------------------------
procedure TLibraryAPI.SetOwnerThread(var inputOwnerThread: DWORD); safecall;
begin
  FOwnerThread:= inputOwnerThread;
//--- Обновить информацию в ТМемо (с журналом работы)
  self.NotifyReceiver_Thread;
end;


procedure TLibraryAPI.InitDLL;
begin
try
 if bDllInitExecuted then
    exit;

 if not Assigned(TaskSourceList) then
 begin
   TaskSourceList:= TTaskSourceList.Create(true); //---
   TaskSourceList.Clear;
 end;
 if not Assigned(CriticalSection) then
   CriticalSection:= TCriticalSection.Create();

 if not Assigned(LibraryLog) then
   LibraryLog:= TLibraryLog.Create;

  bDllInitExecuted:= true;
finally

end;
end;

procedure TLibraryAPI.FinalizeDLL;
var
 tmpTaskSource: ITaskSource;
 tmpInt: integer;
begin
  for tmpInt:= (TaskSourceList.Count - 1) downto 0 do
  begin
//    TaskSourceList.Remove(TTaskSource(TaskSourceList[tmpInt]));
   if Assigned(TaskSourceList[tmpInt]) then
   begin
    tmpTaskSource:= TTaskSource(TaskSourceList.Extract(TaskSourceList[tmpInt]));
    tmpTaskSource._Release;
    tmpTaskSource:= nil;
   end;
  end;
  FreeAndNil(TaskSourceList);



  if Assigned(CriticalSection) then
  freeandnil(CriticalSection); //   CriticalSection.Free;
 if Assigned(LibraryLog) then
  freeandnil(LibraryLog);

//--- Память выделялась через SysReAllocStringLen
//--- для получения строк из визуальных компонентов
 SysFreeString(Task1_Parameters.inputParam1);
 SysFreeString(Task1_Parameters.inputParam2);
 SysFreeString(Task1_Parameters.inputParam3);

{ for tmpWord:= 0 to (TaskSourceList.Count - 1) do
  SysFreeString(TaskSourceList[tmpWord].GetTask2_ResultBuffer);
}
//  FNotify := nil;
  LibraryAPI := nil;
end;


function TLibraryAPI.GetTaskList: IBSTRItems;
var
  tmpInfoRecordData: array of WideString;
begin
  SetLength(tmpInfoRecordData, 1);
  tmpInfoRecordData[0] := wsTask1_Name;

  Result := TBSTRItems.Create(tmpInfoRecordData);
end;

function TLibraryAPI.NewTaskSource(var LibraryTaskIndex, MainModuleTaskIndex: word): ITaskSource; safecall;
var
  tmpTaskSource: TTaskSource;
  tmpWord: word;
begin
 try
  Result:= nil;
  tmpWord:= TaskSourceList.Add(TTaskSource.Create(LibraryTaskIndex));
  TaskSourceList[tmpWord].TaskMainModuleIndex:= MainModuleTaskIndex;
  TaskSourceList[tmpWord].TaskSourceListIndex:= tmpWord;
  Result:= TaskSourceList[tmpWord];
 except
  on tmpE: Exception do
  begin
   self.WriteDataToLog(format(wsLibrary_OnError,
                        [tmpE.ClassName + ', E.Message = ' + tmpE.Message,
                        GetLastError()]),
                  'TLibraryAPI.FreeTaskSource', 'unLibraryAPI');
  end;
 end;
end;

//------------------------------------------------------------------------------
function TLibraryAPI.GetTaskSource(var MainModuleTaskIndex: word): ITaskSource; safecall;
var
  tmpTaskSource: TTaskSource;
  tmpWord: word;
begin
  Result:= nil;
  for tmpWord:= 0 to (TaskSourceList.Count - 1) do
   if TaskSourceList[tmpWord].TaskMainModuleIndex = MainModuleTaskIndex then
    Result:= TaskSourceList[tmpWord];
end;

//------------------------------------------------------------------------------
procedure TLibraryAPI.FreeTaskSource(var MainModuleTaskIndex: word); safecall;
var
  tmpTaskSource: ITaskSource;
  tmpInt: integer;
begin
 try
  for tmpInt:= 0 to (TaskSourceList.Count - 1) do
   if TaskSourceList[tmpInt].TaskMainModuleIndex = MainModuleTaskIndex then
   begin
    tmpTaskSource:= TTaskSource(TaskSourceList.Extract(TaskSourceList[tmpInt]));
    tmpTaskSource._Release
   end;
 except
  on tmpE: Exception do
  begin
   self.WriteDataToLog(format(wsLibrary_OnError,
                        [tmpE.ClassName + ', E.Message = ' + tmpE.Message,
                        GetLastError()]),
                  'TLibraryAPI.FreeTaskSource', 'unLibraryAPI');
  end;
 end;
end;


function TLibraryAPI.GetStream: IStream; safecall;
begin
 Result:= FStream;
end;

//------------------------------------------------------------------------------
procedure TLibraryAPI.WriteDataToLog(E_source1, CurrentProcName, CurrentUnitName: WideString);
var
  tmpWideString: WideString;
begin
 CriticalSection.Enter;
  tmpWideString:= '---- ';
  tmpWideString:= tmpWideString + format(wsLibraryStreamTitle, [self.FLibraryId, self.FLibraryFuncName]);
  tmpWideString:= tmpWideString
                + wsCRLF
                + GetDateTimeStr()
                + wsCRLF
                + 'Сообщение сгенерировано в - ' + CurrentUnitName + '\' + CurrentProcName
                + wsCRLF
                + E_source1
                + wsCRLF;

  FStringStream.WriteString(tmpWideString);
  CriticalSection.Leave;

  self.NotifyReceiver_Thread;

end;

//------------------------------------------------------------------------------
function TLibraryAPI.NotifyReceiver_Thread: BOOL;
begin
//--- Обновить информацию в ТМемо (с журналом работы)
//--- Если не от потока задача/ядро задачи, то TaskNum:= 0, чтобы пройти проверку на соответствие TaskNum и TaskList.Count в WndProc
//--- Установить тип отправителя - API Библиотеки
  try
   Result:= PostThreadMessage(FOwnerThread, WM_Data_Update, MakeDwordAsSender(0, WORD(msLibraryAPI)), CMD_SetMemoLogStreamUpd);
   if not Result then
   begin
     FStringStream.WriteString(format(wsTask_ErrorByPostThreadMessage,
                                     [FLibraryFuncName, GetLastError()])
                                     + ' (TLibraryAPI.NotifyReceiverInfo, unVariables)');
   end;

  finally
  end;

end;


initialization

end.
