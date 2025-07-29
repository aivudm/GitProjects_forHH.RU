unit unVariables;

interface
uses Windows, SysUtils, Forms, System.Contnrs, StdCtrls, Classes, Winapi.Messages, IOUtils, Dialogs,
    System.Generics.Collections, IniFiles, ActiveX, SyncObjs;

type
  BSTR = WideString;
  ITaskSource = interface;

//------------------------------------------------------------------------------
//--- Выходные параметры Задач: №0,№1 (Библиотека №0), №0 (Библиотека №1)
  TSearchPattern = array of byte;

  TTask_Result = packed record
    dwEqualsCount: DWORD;
    SearchPattern: TSearchPattern;
  end;

  TTask_Results = array of TTask_Result;

//------------------------------------------------------------------------------
  IBSTRItems = interface
  ['{7988654F-59FB-401F-9E4C-972FF343C66B}']
    function GetCount: Integer; safecall;
    function GetString(const AIndex: Integer): BSTR; safecall;

    property Count: Integer read GetCount;
    property Strings[const AIndex: Integer]: BSTR read GetString; default;
  end;

//------------------------------------------------------------------------------
  ILibraryAPI = interface (IInterface)
  ['{6D0957A0-EADE-4770-B448-EEE0D92F84CF}']
    // Методы реализуемые DLL API
    function GetId: DWORD; safecall;
    function GetName: BSTR; safecall;
    function GetVersion: BSTR; safecall;
    function GetTaskList: IBSTRItems; safecall;
    function GetTaskCount: byte; safecall;
    function NewTaskSource(TaskLibraryIndex: word): ITaskSource; safecall;
    procedure InitDLL; safecall;
    procedure FinalizeDLL; safecall;

    property Name: BSTR read GetName;
    property Version: BSTR read GetVersion;
    property TaskCount: byte read GetTaskCount;

  end;

//------------------------------------------------------------------------------
  ITaskSource = interface (IInterface)
  ['{6D0957A0-EADE-4770-B448-EEE0D92F84CF}']
   procedure TaskProcedure(TaskLibraryIndex: word); safecall;
   function GetTaskLibraryIndex: word;
   function GetTask_Result: TTask_Result; safecall;
   function GetTask_ResultByIndex(ResultIndex: integer): TTask_Result; safecall;
   function GetTask_TotalResult: DWORD; safecall;
   function GetTask_ResultStream: IStream; safecall;
   procedure SetTaskMainModuleIndex(inputTaskMainModuleIndex: WORD);
   property TaskLibraryIndex: WORD read GetTaskLibraryIndex;
   property Task_Result: TTask_Result read GetTask_Result;
   property Task_Results[ResultIndex: integer]: TTask_Result read GetTask_ResultByIndex;
   property Task_TotalResult: DWORD read GetTask_TotalResult;
   property Task_ResultStream: IStream read GetTask_ResultStream;
   property TaskMainModuleIndex: WORD write SetTaskMainModuleIndex;
  end;

//------------------------------------------------------------------------------

  TDLLAPIProc = function (const inputIID: TGUID; var Intf): HRESULT; stdcall;
  TCallingDLLProc = procedure (var inputParam1: integer; var fsResult: TStreamWriter; iTargetWorkTime: integer); stdcall;
//--- FileFinderByMask
  TCallingDLL1Proc1 = function (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; iTargetWorkTime: WORD; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT; stdcall;
//--- Для нового формата вызова - через блок управления запуском и подготовкой входных и выходных данных для подпрограммы
//--- Для вызывающего - это выхов без параметров, остальное в библиотеке
  TCallingDLL1Proc = function (): HRESULT; stdcall;
//--- FileFinderByPattern

  TArray_WideString = TArray<WideString>;
  TArray_Cardinal = array [0..High(Byte)] of Cardinal;

type
//------------------------------------------------------------------------------
  TModulsExchangeType = (etMessage_WMCopyData = 0, etClientServerUDP = 1);
//------------------------------------------------------------------------------

  TLibraryTask = class (TObject)
   private
    FLibraryId: DWORD;
    FLibraryName: WideString;
    FTaskCount: Byte;
    FTaskTemplateName: TArray_WideString; //--- заполняется после подключения Dll
    FLibraryAPI: ILibraryAPI; //--- заполняется после подключения Dll
    FLibraryFileName: WideString;

    function GetItemName(Index: integer): WideString;
    procedure SetItemName(Index: integer; const Value: WideString);
    function GetLibraryAPI(): ILibraryAPI;
    procedure SetLibraryAPI(LibraryAPI: ILibraryAPI);

   protected

   public
    procedure Clear;
    procedure SetLibraryFileName(inputLibraryFileName: WideString);
    procedure SetTaskTemplateCount(inputTaskTemplateCount: word);
    property LibraryAPI: ILibraryAPI read FLibraryAPI write FLibraryAPI;
    property LibraryId: DWORD read FLibraryId write FLibraryId;
    property LibraryName: WideString read FLibraryName write FLibraryName;
    property LibraryFileName: WideString read FLibraryFileName write SetLibraryFileName;
    property TaskCount: Byte read FTaskCount write FTaskCount;
    property TaskTemplateName[Index: integer]: WideString read GetItemName write SetItemName;
//    property TaskLibraryIndex[Index: integer]: Cardinal read GetItemIndex write SetItemIndex; default;

  end;
//------------------------------------------------------------------------------

//  TLibraryList = TArray<TLibraryTaskInfo>;   //--- Применён из-за встроенного менеджера памяти

//------------------------------------------------------------------------------
  TLibraryList = class (TObjectList)   //--- Применён из-за встроенного менеджера памяти
   private
    function GetItem(Index: integer): TLibraryTask;
    procedure SetItem(Index: integer; const Value: TLibraryTask);
   public
    property Items[Index: integer]: TLibraryTask read GetItem write SetItem; default;
  end;


//------------------------------------------------------------------------------
  TFileItem = class (TObject)
   private
    FFileName: WideString;
    FTaskNum: word;

   protected
    FFileId: THandle;

   public
    FStreamWriter: TStreamWriter;
    constructor Create(TaskItemNum: word); overload;
    procedure SetFileName(FileItemName: WideString = '');
    procedure SetTaskNum(TaskNum: word);

  published
    property FileName: WideString read FFileName;
    property TaskNum: word read FTaskNum;
    property StreamWriter: TStreamWriter read FStreamWriter;

  end;


//------------------------------------------------------------------------------
  TFileList = class (TObjectList)   //--- Применён из-за встроенного менеджера памяти
   private
    function GetItem(Index: integer): TFileItem;
    procedure SetItem(Index: integer; const Value: TFileItem);
   public
    property Items[Index: integer]: TFileItem read GetItem write SetItem; default;
  end;
//------------------------------------------------------------------------------

  PCopyDataStruct = ^TCopyDataStruct;
  TCopyDataStruct = record
    dwData: LongInt;
    cbData: LongInt;
    lpData: Pointer;
  end;

//------------------------------------------------------------------------------
  PInfoToClient = ^TInfoToClient;
  TInfoToClient = packed record
    text_msg : TArray_WideString;
    size_msg : integer;
  end;
//------------------------------------------------------------------------------

  TOutInfo_ForViewing = packed record
    IndexInViewComponent: integer;
    TextForViewComponent: ansistring;
    hMemoThreadInfo_Main: HWND;  //--- для журнала
    hMemoThreadInfo_1: HWND;  //--- для информации от потоков
    hMemoLogInfo_2: HWND;  //--- для журнала
    CurrentViewingTask: word;
  end;

//------------------------------------------------------------------------------
  TFileBuffer = array of byte;
//------------------------------------------------------------------------------

var
  intrfDllAPI: ILibraryAPI;
  hTaskLibrary: THandle;  //--- он же HMODULE
  iniFile: TIniFile;
  logFileName: WideString;
  logFileBuffer: TFileBuffer;
  logFileStringList: TStringList;
  logFileStream: TFileStream;
  logFileStringStream: TStringStream;
  logFileStream_LastPos: Cardinal = 0;
  logFile: TextFile;


var
  ModulsExchangeType: TModulsExchangeType = etMessage_WMCopyData;
  iTreadCount: byte= 0;
  aResultArraySimple: TArray<Int64>;
  FileList: TFileList; //StreamWriter: TStreamWriter;

  OutInfo_ForViewing: TOutInfo_ForViewing;
  CallingDLLProc: TCallingDLLProc;
  hDllTask: THandle;
  sWorkDirectory: WideString = '';
  sFileNameDefault: WideString = '';
  sFileExtensionDefault: WideString = '.txt';
  LibraryTask: TLibraryTask;
  LibraryList: TLibraryList; //TObjectList<TLibraryTaskInfo>;
  CriticalSection: TCriticalSection;




procedure InitializeVariables;
procedure DeinitializeVariables;

implementation
uses unConst, unTasks, unUtils;

procedure InitializeVariables;
begin
end;

procedure DeinitializeVariables;
begin
 if Win32Check(Assigned(TaskList)) then
 begin
  freeandnil(TaskList);
 end;

 if Assigned(LibraryList) then
 begin
  freeandnil(LibraryList);
 end;

 if Assigned(iniFile) then
  freeandnil(iniFile)

end;

//------------------------------------------------------------------------------
//---------- Данные для TLibraryTask -------------------------------------------
//------------------------------------------------------------------------------
function TLibraryTask.GetLibraryAPI(): ILibraryAPI;
begin
 Result:= self.FLibraryAPI;
end;

procedure TLibraryTask.SetLibraryAPI(LibraryAPI: ILibraryAPI);
begin
 self.FLibraryAPI:= LibraryAPI;
end;

function TLibraryTask.GetItemName(Index: integer): WideString;
begin
 Result:= self.FTaskTemplateName[Index];
end;

procedure TLibraryTask.SetItemName(Index: integer; const Value: WideString);
begin
 self.FTaskTemplateName[Index]:= Value;
end;

procedure TLibraryTask.Clear;
begin
 FillChar(self.FTaskTemplateName, 0, SiZeOf(FTaskTemplateName));
end;

procedure TLibraryTask.SetLibraryFileName(inputLibraryFileName: WideString);
begin
  FLibraryFileName:= inputLibraryFileName;
end;

procedure TLibraryTask.SetTaskTemplateCount(inputTaskTemplateCount: word);
begin

 setlength(FTaskTemplateName, inputTaskTemplateCount);
end;


//------------------------------------------------------------------------------
//---------- Данные для TLibraryList ---------------------------------------
//------------------------------------------------------------------------------
function TLibraryList.GetItem(Index: integer): TLibraryTask;
begin
 Result:= TLibraryTask(inherited GetItem(Index));
end;

procedure TLibraryList.SetItem(Index: integer; const Value: TLibraryTask);
begin
 inherited SetItem(Index, Value);
end;


//------------------ TFileItem -------------------------------------------------
constructor TFileItem.Create(TaskItemNum: word);
var
  tmpProc: TTaskProcedure;
begin
 FFileName:= sWorkDirectory + '/' + sFileNameDefault + '_' + IntToStr(TaskItemNum) + sFileExtensionDefault;
 inherited Create(); //, fmCreate or fmOpenWrite);
 FStreamWriter:= TFile.CreateText(FFileName);
 FTaskNum:= TaskItemNum;
// TaskList[TaskItemNum].SetStreamWriter(self);
end;

procedure TFileItem.SetFileName(FileItemName: WideString = '');
begin
 if FileItemName = '' then
  FFileName:= sFileNameDefault
 else
  FFileName:= FileItemName;
end;

procedure TFileItem.SetTaskNum(TaskNum: word);
begin
  FTaskNum:= TaskNum;
end;

//------------------------------------------------------------------------------
//---------- Данные для TFileList ----------------------------------------------
//------------------------------------------------------------------------------
function TFileList.GetItem(Index: integer): TFileItem;
begin
 Result:= TFileItem(inherited GetItem(Index));
end;

procedure TFileList.SetItem(Index: integer; const Value: TFileItem);
begin
 inherited SetItem(Index, Value);
end;
//------------------------------------------------------------------------------




initialization
//if IsTaskDllAttached() = -1 then
// Showmessage('Не удаётся подключить библиотеку с прототипами задач');

//---- Имя текущей директории приложения получаем из TDirectory.GetCurrentDirectory;
sWorkDirectory:= GetWorkingDirectoryName();

sFileNameDefault:= Copy(ExtractFileName(Application.ExeName), 1, Pos('.', ExtractFileName(Application.ExeName)) - 1);

LibraryList:= TLibraryList.Create;; //TObjectList<TLibraryTaskInfo>.Create;
FileList:= TFileList.Create();

iniFile:= TIniFile.Create(sWorkDirectory + '\' + ExtractFileName(ChangeFileExt(Application.ExeName, '.ini' )));

{
FileMode:= fmOpenReadWrite or fmShareDenyWrite;
AssignFile(logFile, logFileName);
if FileExists(sWorkDirectory + '\' + ExtractFileName(ChangeFileExt(Application.ExeName, '.log' ))) then
 Append(logFile)
else
 Rewrite(logFile);
}

logFileName:= sWorkDirectory + '\' + ExtractFileName(ChangeFileExt(Application.ExeName, '.log'));
//--- Создание потока для файла журнала
logFileStream:= TFileStream.Create(logFileName, fmOpenRead or fmShareDenyWrite);
SetLength(logFileBuffer, logFileStream.Size);
logFileStream.ReadBuffer(Pointer(logFileBuffer)^, Length(logFileBuffer));
//logFileStream.Position:= 0;

logFileStringList:= TStringList.Create;
logFileStringStream:= TStringStream.Create(logFileStringList.Text, TEncoding.ANSI)

//StreamWriter:= TFile.CreateText('d:\Task_3_SimpleNumbers.txt');

finalization

FreeAndNil(LibraryList);
FreeAndNil(iniFile);
FreeAndNil(logFileStream);
FreeAndNil(logFileStringStream);
//StreamWriter.Free;

end.
