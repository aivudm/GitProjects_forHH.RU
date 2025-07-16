unit unVariables;

interface
uses Windows, SysUtils, Classes, ActiveX, ComObj, System.Diagnostics, System.Contnrs, Dialogs,
    unEditInputParams, unTaskSource;

type
  BSTR = WideString;
  LPWSTR = PWideChar;
  UnicodeString = WideString;
  NativeInt = Integer;
  NativeUInt = Cardinal;
  DWORD = Cardinal;
  UInt = Cardinal;

type

//------------------------------------------------------------------------------
  TTaskState = (tsNotDefined = -1 {одно из применений - при запуске, до момента полного создания всех объектов задачи},
                tsActive = 0, tsTerminate = 1, tsPause = 2, tsReportPause = 3);
//------------------------------------------------------------------------------
//--- FileFinderByMask
  TCallingDLL1Proc1 = function (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; iTargetWorkTime: WORD; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT; stdcall;

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
//    constructor Create(const AStrings: array of BSTR); reintroduce;
  end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
  ITaskSource = interface (IInterface)
  ['{6D0957A0-EADE-4770-B448-EEE0D92F84CF}']
   procedure TaskProcedure(TaskLibraryIndex: word);
   function GetTask1_Result: TTask1_Result; safecall;
   property Task1_Result: TTask1_Result read GetTask1_Result;
  end;

//------------------------------------------------------------------------------
  TTaskSource = class (TInterfacedObject, ITaskSource)
   private
    FTaskLibraryIndex: word;
    FTaskSourceList: word;
    FTaskState: TTaskState;
    FStopWatch: TStopWatch;
   protected
    FTask1_Result: TTask1_Result;
    procedure TaskProcedure(TaskLibraryIndex: word);
   public
    constructor Create(TaskLibraryIndex: word);
    function GetTask1_Result: TTask1_Result; safecall;
    property TaskState: TTaskState read FTaskState write FTaskState;
    property StopWatch: TStopWatch read FStopWatch write FStopWatch;
    property Task1_Result: TTask1_Result read FTask1_Result write FTask1_Result;

  end;


//  TTaskSourceList = TArray<TTaskSource>;
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
  LoadLibraryEx: function(lpFileName: PChar; Reserved: THandle; dwFlags: DWORD): HMODULE; stdcall;
  TaskSourceList: TTaskSourceList; //--- Массив для хранения всех созданных задач

//  SetDllDirectory: function(lpPathName: PChar): BOOL; stdcall;
//  SetSearchPathMode: function(Flags: DWORD): BOOL; stdcall;
//  AddDllDirectory: function(Path: PWideChar): Pointer; stdcall;
//  RemoveDllDirectory: function(Cookie: Pointer): BOOL; stdcall;
//  SetDefaultDllDirectories: function(DirectoryFlags: DWORD): BOOL; stdcall;





implementation
uses unLibrary1API;


//resourcestring
//  rsInvalidDelete  = 'Попытка удалить объект %s при активной интерфейсной ссылке; счётчик ссылок: %d';
//  rsDoubleFree     = 'Попытка повторно удалить уже удалённый объект %s';
//  rsUseDeleted     = 'Попытка использовать уже удалённый объект %s';


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
//---------- Данные для TTaskSource... -----------------------------------------
//------------------------------------------------------------------------------

constructor TTaskSource.Create(TaskLibraryIndex: word);
begin
 inherited Create();
   FTaskLibraryIndex:= TaskLibraryIndex;
   FTaskSourceList:= TaskSourceList.Add(self);
end;

//------------------------------------------------------------------------------
function TTaskSource.GetTask1_Result: TTask1_Result; safecall;
begin
  Result:= FTask1_Result;
end;

//------------------------------------------------------------------------------
procedure TTaskSource.TaskProcedure(TaskLibraryIndex: word);
var
  tmpInt, tmpInt1: Integer;
  tmpStr: string;
  tmpInputForm_Task1: TformEditParams_Task1;
 begin

//  repeat

 case TaskLibraryIndex of
   0: //--- Task1_FileFinderByMask
   begin
//--- Критическая секция для доступа к структуре - входные параметры для задачи
    CriticalSection.Enter; //--- Выход из критической секции будет в начале задачи
    tmpInputForm_Task1:= TformEditParams_Task1.Create(nil);
    tmpInputForm_Task1.ShowModal;
    tmpInputForm_Task1.Free;

//--- После заполения входных параметров запуск задачи на выполнение
{    ShowMessage('Пепед входом в Task1_FileFinderByMask'
                + #13#10 + 'inputParam1 = ' + WideString(Task1_Parameters.inputParam1)
                + #13#10 + 'inputParam2 = ' + WideString(Task1_Parameters.inputParam2)
                + #13#10 + 'inputParam3 = ' + WideString(Task1_Parameters.inputParam3));
}
// Начинаем отсчёт времени работы текущей задачи задачи
// зафиксируем текущее значение TaskItem.FStopWatch
    tmpInt1:= self.StopWatch.ElapsedMilliseconds;

    Task1_FileFinderByMask(WideString(Task1_Parameters.inputParam1), WideString(Task1_Parameters.inputParam2), WideString(Task1_Parameters.inputParam3), Task1_Parameters.inputParam4, Task1_Parameters.inputParam5, self.FTask1_Result); //, nil, 0);
    CriticalSection.Leave;
   end;
 end;

//  until ((TaskItem.FStopWatch.ElapsedMilliseconds - tmpInt1) >= TaskItem.FPeriodReport)
//        or (TaskItem.TaskState = TTaskState(tsTerminate)) or (TaskItem.TaskState = TTaskState(tsPause)) or (TaskItem.TaskState = TTaskState(tsReportPause));

//  inc(TaskItem.FTaskStepCount); // зафиксируем завершение очередного условного цикла
//  TaskItem.InfoFromTask:= 'Пройден ' + IntToStr(TaskItem.FTaskStepCount) + ' усл.цикл, ' + Format('"найдено": %d чисел ', [tmpInt]);

 end;

//------------------------------------------------------------------------------
//---------- Данные для TTaskSourceList ----------------------------------------
//------------------------------------------------------------------------------

function TTaskSourceList.GetItem(Index: integer): TTaskSource;
begin
 Result:= TTaskSource(inherited GetItem(Index));
end;

procedure TTaskSourceList.SetItem(Index: integer; const Value: TTaskSource);
begin
 inherited SetItem(Index, Value);
end;


end.
