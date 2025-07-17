unit unVariables;

interface
uses Windows, SysUtils, Forms, System.Contnrs, StdCtrls, Classes, Winapi.Messages, IOUtils, Dialogs,
    System.Generics.Collections, IniFiles;

type
  BSTR = WideString;
  ITaskSource = interface;
//------------------------------------------------------------------------------
//--- Выходные параметры Задачи №1 (Индекс задачи в библиотеке - 0)

  TTask1_Result = packed record
    dwEqualsCount: DWORD;
  end;

//------------------------------------------------------------------------------

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
   procedure TaskProcedure(TaskLibraryIndex: word);
   function GetTask1_Result: TTask1_Result; safecall;
   property Task1_Result: TTask1_Result read GetTask1_Result;
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

  TArray_WideString = array [0..High(Byte)] of WideString;
  TArray_Cardinal = array [0..High(Byte)] of Cardinal;

type
//------------------------------------------------------------------------------
  TModulsExchangeType = (etMessage_WMCopyData = 0, etClientServerUDP = 1);
//------------------------------------------------------------------------------

  TLibraryTask = class (TObject)
   private
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

    property LibraryAPI: ILibraryAPI read FLibraryAPI write FLibraryAPI;
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


  TOutInfo_ForViewing = packed record
    hWndViewObject: hWnd;
    IndexInViewComponent: integer;
    TextForViewComponent: ansistring;
  end;


//------------------------------------------------------------------------------
  TFileItem = class (TObject)
   private
    FFileName: string;
    FTaskNum: word;

   protected
    FFileId: THandle;

   public
    FStreamWriter: TStreamWriter;
    constructor Create(TaskItemNum: word); overload;
    procedure SetFileName(FileItemName: string = '');
    procedure SetTaskNum(TaskNum: word);

  published
    property FileName: string read FFileName;
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



var
  intrfDllAPI: ILibraryAPI;
  hTaskLibrary: THandle;  //--- он же HMODULE
  iniFile: TIniFile;


var
  ModulsExchangeType: TModulsExchangeType = etMessage_WMCopyData;
  iTreadCount: byte= 0;
  aResultArraySimple: TArray<Int64>;
  FileList: TFileList; //StreamWriter: TStreamWriter;

  CallingDLLProc: TCallingDLLProc;
  hDllTask: THandle;
  sWorkDirectory: string = '';
  sFileNameDefault: string = '';
  sFileExtensionDefault: string = '.txt';
  LibraryTask: TLibraryTask;
  LibraryList: TLibraryList; //TObjectList<TLibraryTaskInfo>;

procedure InitializeVariables;
procedure DeinitializeVariables;

implementation
uses unConst, unTasks, unUtils;

procedure InitializeVariables;
begin
end;

procedure DeinitializeVariables;
begin
 if Assigned(TaskList) then TaskList.Free;
 if Assigned(CriticalSection) then CriticalSection.Free;

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

procedure TFileItem.SetFileName(FileItemName: string = '');
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

//StreamWriter:= TFile.CreateText('d:\Task_3_SimpleNumbers.txt');

finalization
if Assigned(LibraryList) then
 LibraryList.Free;

if Assigned(iniFile) then
 iniFile.Free;
//StreamWriter.Free;

end.
