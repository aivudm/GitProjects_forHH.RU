unit unVariables;

interface
uses Windows, SysUtils, Forms, System.Contnrs, StdCtrls, Classes, Winapi.Messages, IOUtils, Dialogs,
    System.Generics.Collections;

type
  TDLLAPIProc = function (const inputIID: TGUID; var Intf): HRESULT; stdcall;
  TCallingDLLProc = procedure (var inputParam1: integer; var fsResult: TStreamWriter; iTargetWorkTime: integer); stdcall;
//--- GetLibraryInfo
  TCallingDLL1Proc1 = procedure (var outputParam: WideString; tmpInfoRecordSize, tmpInfoRecordCount: Byte); stdcall;
//--- FileFinderByMask
  TCallingDLL1Proc2 = function (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; iTargetWorkTime: WORD; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT; stdcall;
//--- FileFinderByPattern

  TArray_WideString = array [0..High(Byte)] of WideString;
  TArray_Cardinal = array [0..High(Byte)] of Cardinal;

  BSTR = WideString;

type
  TExchangeType = (etSynchronize = 0, etClientServerUDP = 1);



  TLibraryTask = class (TObject)
   private
    FLibraryName: WideString;
    FTaskCount: Byte;
    FTaskTemplateName: TArray_WideString; //--- заполняется после подключения Dll
//    FTaskLibraryIndex: array [1..High(Byte)] of Cardinal; //--- заполняется после подключения Dll

    function GetItemName(Index: integer): WideString;
    procedure SetItemName(Index: integer; const Value: WideString);
//    function GetItemIndex(Index: integer): Cardinal;
//    procedure SetItemIndex(Index: integer; const Value: Cardinal);

   protected

   public
    procedure Clear;

    property LibraryName: WideString read FLibraryName write FLibraryName;
    property TaskCount: Byte read FTaskCount write FTaskCount;
    property TaskTemplateName[Index: integer]: WideString read GetItemName write SetItemName;
//    property TaskLibraryIndex[Index: integer]: Cardinal read GetItemIndex write SetItemIndex; default;

  end;

//  TLibraryList = TArray<TLibraryTaskInfo>;   //--- Применён из-за встроенного менеджера памяти

  TLibraryList = class (TObjectList)   //--- Применён из-за встроенного менеджера памяти
   private
    function GetItem(Index: integer): TLibraryTask;
    procedure SetItem(Index: integer; const Value: TLibraryTask);
   public
    property Items[Index: integer]: TLibraryTask read GetItem write SetItem; default;
  end;


  TOutInfo_ForViewing = record
    hWndViewObject: hWnd;
    IndexInViewComponent: integer;
    TextForViewComponent: ansistring;
  end;

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

  IBSTRItems = interface
  ['{7988654F-59FB-401F-9E4C-972FF343C66B}']
    function GetCount: Integer; safecall;
    function GetString(const AIndex: Integer): BSTR; safecall;

    property Count: Integer read GetCount;
    property Strings[const AIndex: Integer]: BSTR read GetString; default;
  end;


  ILibraryAPI = interface
  ['{6D0957A0-EADE-4770-B448-EEE0D92F84CF}']
    // Методы реализуемые DLL API
    function GetName: BSTR; safecall;
    function GetVersion: BSTR; safecall;
    function GetTaskList: IBSTRItems; safecall;
    function GetTaskCount: byte; safecall;
    procedure FinalizeDLL; safecall;
//--- Тестирование (удалить!)
    procedure GetFormParams; safecall;

    property Name: BSTR read GetName;
    property Version: BSTR read GetVersion;
    property TaskCount: byte read GetTaskCount;
  end;

var
  intrfDllAPI: ILibraryAPI;
  hTaskLibrary: THandle;  //--- он же HMODULE





var
//  bFormToolsIsActive: boolean = false;
  ExchangeType: TExchangeType = etSynchronize; //--- Глобальная переменная - будет обращение из потоков
  iTreadCount: byte= 0;
  aResultArraySimple: TArray<Int64>;
  FileList: TFileList; //StreamWriter: TStreamWriter;
//  aTaskNameArray: array of string; // = ['Пустой цикл', 'Расчёт числа Пи', 'Определение простых чисел']; //--- При инициализации задачи нумерация будет с номера =

  CallingDLLProc: TCallingDLLProc;
  hDllTask: THandle;
  sWorkDirectory: string = '';
  sFileNameDefault: string = '';
  sFileExtensionDefault: string = '.txt';
  LibraryTask: TLibraryTask;
  LibraryList: TLibraryList; //TObjectList<TLibraryTaskInfo>;
//  aInfoRecordData: array of WideString = ['Файловый функционал', 'FileFinderByMask', 'FileFinderByPattern'];

procedure InitializeVariables;
procedure DeinitializeVariables;

implementation
uses unConst, unTasks, unUtils;

procedure InitializeVariables;
begin
end;

procedure DeinitializeVariables;
begin
 if TaskList <> nil then TaskList.Free;
 if CriticalSection <> nil then CriticalSection.Free;

end;

//------------------------------------------------------------------------------
//---------- Данные для TLibraryTask -------------------------------------------
//------------------------------------------------------------------------------
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

//StreamWriter:= TFile.CreateText('d:\Task_3_SimpleNumbers.txt');

finalization
if Assigned(LibraryList) then
 LibraryList.Free;
//StreamWriter.Free;

end.
