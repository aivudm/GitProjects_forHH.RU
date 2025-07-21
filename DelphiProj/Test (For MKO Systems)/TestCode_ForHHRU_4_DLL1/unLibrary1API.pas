unit unLibrary1API;
{$A8}
{$MINENUMSIZE 4}
interface
uses
  Windows, SysUtils, ActiveX, Classes, Diagnostics, IOUtils, System.SyncObjs,
  unVariables, unEditInputParams_Task1, unTaskSource;
{
//function _GetLibraryInfo (out outputParam1: WideString; out InfoRecordSize, InfoRecordCount: Byte): HRESULT; stdcall;
procedure _GetLibraryInfo (out outputParam1: WideString); stdcall;
function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; iTargetWorkTime: WORD; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT; stdcall;
function Task2_FileFinderByPattern (var inputParam1, inputParam2: WideString; var iResult: DWORD; iTargetWorkTime: WORD): HRESULT; stdcall;
}

{ Задачи реализуемые данной библиотекой
  _GetLibraryInfo name 'GetLibraryInfo',
  Task1_FileFinderByMask name 'FileFinderByMask',
  Task2_FileFinderByPattern name 'FileFinderByPattern';
 }

type
  ILibraryAPI = interface (IInterface)
  ['{6D0957A0-EADE-4770-B448-EEE0D92F84CF}']
    // Методы реализуемые DLL API
    function GetName: BSTR; safecall;
    function GetVersion: BSTR; safecall;
    function GetTaskList: IBSTRItems; safecall;
    function GetTaskCount: byte; safecall;
    function NewTaskSource(TaskLibraryIndex: word): ITaskSource; safecall;
    procedure InitDLL; safecall;
    procedure FinalizeDLL; safecall;
//--- Тестирование (удалить!)
//    procedure GetFormParams; safecall;

    property Name: BSTR read GetName;
    property Version: BSTR read GetVersion;
    property TaskCount: byte read GetTaskCount;

    //--- Реализованный функционал в этой библиотеки
    //--- Для передачи
//    function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; iTargetWorkTime: WORD): HRESULT;  safecall; //; out outputResult: Pointer = Pointer(nil); out outputResultSize: DWORD = 0): HRESULT;  safecall;
//    function Task2_FileFinderByPattern (var inputParam1, inputParam2: WideString; var iResult: DWORD; iTargetWorkTime: WORD): HRESULT; safecall;
  end;

  TLibraryAPI = class(TInterfacedObject, ILibraryAPI) //, ISupportErrorInfo)
  strict private
    FLibraryFuncName: BSTR;
    FTaskCount: Byte;
  strict protected
    function GetName: BSTR; safecall;
    function GetVersion: BSTR; safecall;
    function GetTaskList: IBSTRItems; safecall;
    function GetTaskCount: byte; safecall;
    function NewTaskSource(TaskLibraryIndex: word): ITaskSource; safecall;
    procedure InitDLL; safecall;
    procedure FinalizeDLL; safecall;
  public
    constructor Create;
  end;

var
  LibraryAPI: ILibraryAPI;

  dllFuncName: BSTR = 'Файловый функционал';
  dllVersion: BSTR = '1.0';

implementation

constructor TLibraryAPI.Create;
begin
  inherited;
  FLibraryFuncName:= dllFuncName;
  FTaskCount:= GetTaskList.Count;
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
 if Win32Check(not Assigned(TaskSourceList)) then
   TaskSourceList:= TTaskSourceList.Create;
 if Win32Check(not Assigned(CriticalSection)) then
   CriticalSection:= TCriticalSection.Create();

end;

procedure TLibraryAPI.FinalizeDLL;
begin
 if Win32Check(Assigned(TaskSourceList)) then
  freeandnil(TaskSourceList);//    TaskSourceList.Free;
 if Win32Check(not Assigned(CriticalSection)) then
  freeandnil(CriticalSection); //   CriticalSection.Free;
//--- Память выделялась через SysReAllocStringLen
//--- для получения строк из визуальных компонентов
 SysFreeString(Task1_Parameters.inputParam1);
 SysFreeString(Task1_Parameters.inputParam2);
 SysFreeString(Task1_Parameters.inputParam3);

//  FNotify := nil;
  LibraryAPI := nil;
end;


function TLibraryAPI.GetTaskList: IBSTRItems;
var
  tmpInfoRecordData: array of WideString;
begin
  SetLength(tmpInfoRecordData, 2);
  tmpInfoRecordData[0] := 'Поиск файлов по маске';
  tmpInfoRecordData[1] := 'Поиск в файлах по шаблонам';

  Result := TBSTRItems.Create(tmpInfoRecordData);
end;

function TLibraryAPI.NewTaskSource(TaskLibraryIndex: word): ITaskSource;
var
  tmpTaskSource: TTaskSource;
begin
  tmpTaskSource:= TTaskSource.Create(TaskLibraryIndex);
  Result:= tmpTaskSource;
end;


{
//--- Для отраьотки - удалить
procedure TLibraryAPI.GetFormParams;
var
  tmpformEditInputParams: TformEditParams_Task1;
begin
 tmpformEditInputParams:= TformEditParams_Task1.Create(nil);
 tmpformEditInputParams.ShowModal;
end;
}

initialization
//  LoadWinAPIFunctions;
//  {$IFDEF WIN32}FixSafeCallExceptions;{$ENDIF}

end.
