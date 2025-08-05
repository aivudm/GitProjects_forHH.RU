unit unLibrary1API;
{$A8}
{$MINENUMSIZE 4}
interface
uses
  Windows, SysUtils, ActiveX, Classes, Diagnostics, IOUtils, System.SyncObjs, Dialogs,
  unVariables, unEditInputParams_Task1, unTaskSource;

const
  dllLibraryId: DWORD = 0;
  dllFuncName: BSTR = 'Файловый функционал (Библиотека №1)';
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
    function GetTaskCount: byte; safecall;
    function NewTaskSource(var LibraryTaskIndex, MainModuleTaskIndex: word): ITaskSource; safecall;
    function GetTaskSource(var MainModuleTaskIndex: word): ITaskSource; safecall;
    function GetStream: IStream; safecall;
    procedure InitDLL; safecall;
    procedure FinalizeDLL; safecall;
    procedure FreeTaskSource(var MainModuleTaskIndex: word); safecall;

    property Name: BSTR read GetName;
    property Version: BSTR read GetVersion;
    property TaskCount: byte read GetTaskCount;

  end;
//------------------------------------------------------------------------------
  TLibraryAPI = class(TInterfacedObject, ILibraryAPI)
  strict private
    FLibraryId: DWORD;
    FLibraryFuncName: BSTR;
    FTaskCount: Byte;
  strict protected
    function GetId: DWORD; safecall;
    function GetName: BSTR; safecall;
    function GetVersion: BSTR; safecall;
    function GetTaskList: IBSTRItems; safecall;
    function GetTaskCount: byte; safecall;
    function NewTaskSource(var LibraryTaskIndex, MainModuleTaskIndex: word): ITaskSource; safecall;
    function GetTaskSource(var MainModuleTaskIndex: word): ITaskSource; safecall;
    function GetStream: IStream; safecall;
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
begin
  inherited;
  FLibraryId:= dllLibraryId;
  FLibraryFuncName:= dllFuncName;
  FTaskCount:= GetTaskList.Count;
end;

function TLibraryAPI.GetId: DWORD; safecall;
begin
  Result := FLibraryId;
end;



function TLibraryAPI.GetName: BSTR;
begin
  Result := FLibraryFuncName;
end;


function TLibraryAPI.GetVersion: BSTR;
begin
  Result := dllVersion;
end;

function TLibraryAPI.GetTaskCount: byte;
begin
  Result := FTaskCount;
end;


procedure TLibraryAPI.InitDLL;
begin
try
 if bDllInitExecuted then
    exit;

 if not Assigned(TaskSourceList) then
 begin
   TaskSourceList:= TTaskSourceList.Create(false); //---
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
  tmpWord: word;
begin
  TaskSourceList.Clear;
  freeandnil(TaskSourceList);

 if Assigned(CriticalSection) then
  freeandnil(CriticalSection);
 if Assigned(LibraryLog) then
  freeandnil(LibraryLog);

//--- Память выделялась через SysReAllocStringLen
//--- для получения строк из визуальных компонентов
 SysFreeString(Task1_Parameters.inputParam1);
 SysFreeString(Task1_Parameters.inputParam2);
 SysFreeString(Task1_Parameters.inputParam3);
 SysFreeString(Task2_Parameters.inputParam1);
 SysFreeString(Task2_Parameters.inputParam2);
 SysFreeString(Task2_Parameters.inputParam3);



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
  SetLength(tmpInfoRecordData, 2);
  tmpInfoRecordData[0] := wsTask1_Name;
  tmpInfoRecordData[1] := wsTask2_Name;
  Result := TBSTRItems.Create(tmpInfoRecordData);
end;

function TLibraryAPI.NewTaskSource(var LibraryTaskIndex, MainModuleTaskIndex: word): ITaskSource; safecall;
var
  tmpTaskSource: TTaskSource;
  tmpWord: word;
begin
  Result:= nil;
  tmpWord:= TaskSourceList.Add(TTaskSource.Create(LibraryTaskIndex));
  TaskSourceList[tmpWord].TaskMainModuleIndex:= MainModuleTaskIndex;
  Result:= TaskSourceList[tmpWord];

{
  tmpTaskSource:= TTaskSource.Create(TaskLibraryIndex);
  TaskSourceList.Add(tmpTaskSource);
  Result:= tmpTaskSource;
}
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
  tmpTaskSource: TTaskSource;
  tmpWord: word;
begin
  for tmpWord:= 0 to (TaskSourceList.Count - 1) do
   if TaskSourceList[tmpWord].TaskMainModuleIndex = MainModuleTaskIndex then
   begin
    TaskSourceList.Remove(TaskSourceList[tmpWord]);
   end;
end;


//------------------------------------------------------------------------------
function TLibraryAPI.GetStream: IStream; safecall;
begin
  Result:= LibraryLog.GetStream;
end;



initialization

end.
