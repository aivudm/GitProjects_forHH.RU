unit unVariables;

interface
uses Windows, SysUtils, Classes, IOUtils, ActiveX, ComObj, System.Diagnostics, System.Contnrs, Dialogs,
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
   procedure SetTaskMainModuleIndex(inputTaskMainModuleIndex: WORD);
   property Task1_Result: TTask1_Result read GetTask1_Result;
   property TaskMainModuleIndex: WORD write SetTaskMainModuleIndex;
  end;

//------------------------------------------------------------------------------
  TTaskSource = class (TInterfacedObject, ITaskSource)
   private
    FTaskLibraryIndex: word;
    FTaskMainModuleIndex: word;
    FTaskSourceList: word;
    FTaskState: TTaskState;
    FStopWatch: TStopWatch;
   protected
    FTask1_Result: TTask1_Result;
    procedure TaskProcedure(TaskLibraryIndex: word);
    function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; out outTask1_Result: TTask1_Result): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
   public
    constructor Create(TaskLibraryIndex: word);
    function GetTask1_Result: TTask1_Result; safecall;
    procedure SetTaskMainModuleIndex(inputTaskMainModuleIndex: WORD);
    property TaskState: TTaskState read FTaskState write FTaskState;
    property StopWatch: TStopWatch read FStopWatch write FStopWatch;
    property Task1_Result: TTask1_Result read FTask1_Result write FTask1_Result;
    property TaskMainModuleIndex: WORD write FTaskMainModuleIndex;
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
procedure TTaskSource.SetTaskMainModuleIndex(inputTaskMainModuleIndex: WORD);
begin
  FTaskMainModuleIndex:= inputTaskMainModuleIndex;
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

    //--- Заполним inputParam5 (TaskMainModuleIndex), переданный через API
    Task1_Parameters.inputParam5:= self.FTaskMainModuleIndex;
//--- После заполения входных параметров запуск задачи на выполнение
 {   ShowMessage('Перед входом в Task1_FileFinderByMask'
                + #13#10 + 'inputParam1 = ' + WideString(Task1_Parameters.inputParam1)
                + #13#10 + 'inputParam2 = ' + WideString(Task1_Parameters.inputParam2)
                + #13#10 + 'inputParam3 = ' + WideString(Task1_Parameters.inputParam3)
                + #13#10 + 'inputParam5 = ' + IntToStr(FTaskMainModuleIndex)); // Task1_Parameters.inputParam5
}
// Начинаем отсчёт времени работы текущей задачи задачи
// зафиксируем текущее значение TaskItem.FStopWatch
    tmpInt1:= self.StopWatch.ElapsedMilliseconds;

    self.Task1_FileFinderByMask(WideString(Task1_Parameters.inputParam1), WideString(Task1_Parameters.inputParam2), WideString(Task1_Parameters.inputParam3), Task1_Parameters.inputParam4, FTaskMainModuleIndex {Task1_Parameters.inputParam4}, self.FTask1_Result); //, nil, 0);
    CriticalSection.Leave;
   end;
 end;

 end;


function TTaskSource.Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; out outTask1_Result: TTask1_Result): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
var
  inputParam5, iProcedureWorkTime: DWORD;
  tmpTargetFile: WideString;
  tmpStreamWriter: TStreamWriter;
  tmpMaskItems: TArray_WideString;
  tmpMaskCount: word;
  tmpWord: word;
  tmpBool: Boolean;
  tmpPAnsiChar: PAnsiChar;
  tmpWideString: WideString;

begin
try
    CriticalSection.Leave; //--- Вход в критическую секцию был до вызова окна с входными параметрами

 iProcedureWorkTime:= GetTickCount(); // запоминаем значение тиков в начале подпрограммы
  case inputParam4 of
    true:  //--- Вариант: запись результата в файл
     begin
//--- Если выбран режим вывода в файл, то проверим правильность имени выходного файла
//--- Добавим к имени выходного файла информацию о номере задачи по порядку запуска потоков в главном модуле, иначе имена файлов в потоках совпадут
       if TPath.GetFileName(inputParam3) <> '' then
        tmpWideString:= TPath.GetFileNameWithoutExtension(inputParam3) + format('_%d', [self.FTaskMainModuleIndex]) + TPath.GetExtension(inputParam3)
       else
        tmpWideString:= TPath.GetFileNameWithoutExtension(wsTask1_ResultFileNameByDefault) + format('_%d', [inputParam5]) + TPath.GetExtension(wsTask1_ResultFileNameByDefault);
//--- ...правильность имени выходной директории
       if TPath.GetDirectoryName(inputParam3) <> '' then
        tmpWideString:= TPath.GetDirectoryName(inputParam3) + '\' + tmpWideString
       else
        tmpWideString:= TDirectory.GetCurrentDirectory() + '\' + tmpWideString;

        tmpStreamWriter:= TFile.CreateText(tmpWideString);

//--- Извлечение элементов-масок из входящей строки (inputParam1)
   GetItemsFromString(inputParam1, tmpMaskItems, tmpMaskCount);
//--- Цикл перебора и сравнения с масками всех файлов в целевой директории
   outTask1_Result.dwEqualsCount:= 0; //--- Счётчик совпадений

       for tmpTargetFile in TDirectory.GetFiles(inputParam2, wsAllMask,
            TSearchOption.soAllDirectories) do
        begin
//          sleep(500); //--- Для отработки (для замедления процесса)
         tmpBool:= false;
         for tmpWord:= 0 to tmpMaskCount do
         begin
          if (TPath.GetExtension(tmpTargetFile) = tmpMaskItems[tmpWord]) and (not tmpBool) then
          begin
           inc(outTask1_Result.dwEqualsCount);
           tmpBool:= true;
           if tmpBool then
           begin
            tmpStreamWriter.WriteLine(tmpTargetFile + ', ');
            if (GetTickCount() - iProcedureWorkTime) >=  inputParam5 then
             begin
              tmpStreamWriter.Flush;
              iProcedureWorkTime:= GetTickCount(); // запоминаем текущее значение тиков
             end;
           end;
          end;
         end;
        end;

       tmpPAnsiChar:= 'Всего найдено совпадений: ';
       tmpStreamWriter.WriteLine(tmpPAnsiChar + IntToStr(outTask1_Result.dwEqualsCount));
       tmpStreamWriter.Close;

     end;

    false:   //--- Настройка памяти для выгрузки результата
     begin

     end;
   end;

finally
 if Win32Check(Assigned(tmpStreamWriter)) then
    tmpStreamWriter.Free;

end;
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
