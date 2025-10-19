unit unVariables;

interface
uses Windows, SysUtils, Classes, IOUtils, ActiveX, ComObj, Vcl.AxCtrls,
     System.Diagnostics, System.Contnrs, Dialogs, IniFiles, EncdDecd, DateUtils,
     unTaskSource, unEditInputParams_Task1, unEditInputParams_Task2;

type
  BSTR = WideString;
  LPWSTR = PWideChar;
  UnicodeString = WideString;
  NativeInt = Integer;
  NativeUInt = Cardinal;
  DWORD = Cardinal;
  UInt = Cardinal;

type

  IBSTRItems = interface
  ['{7988654F-59FB-401F-9E4C-972FF343C66B}']
    function GetCount: DWORD; safecall;
    function GetString(var ItemIndex: DWORD): BSTR; safecall;

    property Count: DWORD read GetCount;
    property Strings[var ItemIndex: DWORD]: BSTR read GetString; default;
  end;


//------------------------------------------------------------------------------
  TBSTRItems = class(TInterfacedObject, IBSTRItems)
  strict private
    FBSTRItems: array of WideString;
  strict protected
    function GetCount: DWORD; safecall;
    function GetString(var ItemIndex: DWORD): BSTR; safecall;
  public
    constructor Create(const inputBSTRItems: array of WideString); reintroduce;
//    constructor Create(const AStrings: array of BSTR); reintroduce;
  end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
  ITaskSource = interface (IInterface)
  ['{697522A7-7EEC-47D5-91E1-928242F770FE}']
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
   procedure SetTaskMainModuleIndex(var inputTaskMainModuleIndex: WORD); safecall;
   procedure SetOwnerThread(var inputOwnerThread: DWORD); safecall;
   property AbortExecution: boolean read  GetAbortExecutionState write SetAbortExecutionState;
   property TaskLibraryIndex: WORD read GetTaskLibraryIndex;
   property Task_Result: TTask_Result read GetTask_Result;
   property Task_Results[ResultIndex: integer]: TTask_Result read GetTask_ResultByIndex;
   property Task_TotalResult: DWORD read GetTask_TotalResult;
   property Stream_Result: IStream read GetTask_ResultStream;
   property Stream_Log: IStream read GetTask_LogStream;
  end;

//------------------------------------------------------------------------------
  TTaskSource = class (TInterfacedObject, ITaskSource)
   private
    FTaskLibraryIndex: word;
    FTaskMainModuleIndex: word;
    FTaskSourceListIndex: word;
    FOwnerThread: DWORD;
    FStream_Result: IStream;
    FStringStream_Result: TStringStream;
    FStream_Log: IStream;
    FStringStream_Log: TStringStream;

   protected
    FTask_TotalResult: DWORD;
    FTask_Results: TTask_Results;
    FTask_Result: TTask_Result;
    procedure TaskProcedure; safecall;
    function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; out inoutTask1_Result: TTask_Result; out inoutTask1_Results: TTask_Results): HRESULT; safecall;
    function Task2_FindInFilesByPattern (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; var inoutTask2_Results: TTask_Results): HRESULT; safecall; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
   public
    FAbortExecution: boolean;
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
    procedure SetTaskMainModuleIndex(var inputTaskMainModuleIndex: WORD); safecall;
    procedure SetOwnerThread(var inputOwnerThread: DWORD); safecall;
    procedure WriteDataToLog(E_source1, CurrentProcName, CurrentUnitName: WideString); safecall;
    function NotifyReceiver_Thread: BOOL;
    property TaskLibraryIndex: WORD read FTaskLibraryIndex;
    property TaskMainModuleIndex: WORD read FTaskMainModuleIndex write FTaskMainModuleIndex;
    property TaskSourceListIndex: WORD read FTaskSourceListIndex write FTaskSourceListIndex;
    property AbortExecution: boolean read  GetAbortExecutionState write SetAbortExecutionState;
    property Task_Result: TTask_Result read FTask_Result write FTask_Result;
    property Task_Results[ResultIndex: integer]: TTask_Result read GetTask_ResultByIndex; // write SetTask2_Result;
    property Task_TotalResult: DWORD read GetTask_TotalResult;
    property StringStream_Result: TStringStream read FStringStream_Result write FStringStream_Result;
    property Task_ResultStream: IStream read GetTask_ResultStream;
    property StringStream_Log: TStringStream read FStringStream_Log write FStringStream_Log;
    property TaskStream_Log: IStream read GetTask_LogStream;
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


//------------------------------------------------------------------------------
 TMessageSender = (msMainModule = 0, msLibraryAPI = 1, msTaskItem = 2, msTaskCore = 3, msTaskSource = 4);
//------------------------------------------------------------------------------


function GetDateTimeStr(): WideString;
function MakeDwordAsSender(inputLoWord, inputHiWord: word): DWORD;


var
  LoadLibraryEx: function(lpFileName: PChar; Reserved: THandle; dwFlags: DWORD): HMODULE; stdcall;
  TaskSourceList: TTaskSourceList; //--- Массив для хранения всех созданных задач
  bDllInitExecuted: boolean = false;
  sWorkDirectory: WideString;

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

function TBSTRItems.GetCount: DWORD;
begin
  Result := length(FBSTRItems);
end;

function TBSTRItems.GetString(var ItemIndex: Cardinal): BSTR;
begin
  Result := FBSTRItems[ItemIndex];
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


//------------------------------------------------------------------------------
//---------- Данные для TTaskSource... -----------------------------------------
//------------------------------------------------------------------------------

constructor TTaskSource.Create(TaskLibraryIndex: word);
var
  tmpString: AnsiString;

begin
 inherited Create();
   FTaskLibraryIndex:= TaskLibraryIndex;

//--- Создание потока для передачи результатов в "управляющий поток" - TaskItem
//--- Запись в поток "начальных данных" (наименование, номер)
  tmpString:= format(wsResultStreamTitle, [FTaskLibraryIndex, FTaskLibraryIndex]) + wsCRLF;
  FStringStream_Result:= TStringStream.Create(tmpString, TEncoding.ANSI);
  FStream_Result:= TStreamAdapter.Create(FStringStream_Result, soReference);

//--- Создание потока для передачи информации для журнала в "управляющий поток" - TaskItem
//--- Запись в поток "начальных данных" (наименование, номер)
  FStringStream_Log:= TStringStream.Create(tmpString, TEncoding.ANSI);
  FStream_Log:= TStreamAdapter.Create(FStringStream_Log, soReference);

  FAbortExecution:= false; //--- флаг для немедленного (без создания исключения) прекращения и удаления объекта TaskSource

end;

//------------------------------------------------------------------------------
procedure TTaskSource.AbortTaskSource;
var
  tmpPointer: pointer;
begin
//--- Вызывается из родительского потока главного модуля
//--- Для немедленного завершения задачи формируется предпосылка для получения исключения типа AV
//--- после этого будет передача исключения поэтапно в главный модуль
{
    tmpPointer:= @FTask_TotalResult;
    asm
     mov eax, tmpPointer
     mov dword ptr [eax], 0
    end;
}
//  self.FStringStream_copy:= self.FStringStream; //--- Сохраняем правильный адрес переменной перед созданием исключения
//  self.FStringStream:= nil;
//--- Или более мягкий вариант - встроен в алгоритм задачи (проверка "флага останова")
  FAbortExecution:= true;
end;

procedure TTaskSource.FreeTaskSource; safecall;
begin
//--- Освобождение ресурсов объекта TaskSource (по запросу главного модуля)
try
 if Assigned(FStream_Result) then
 begin
  FStream_Result._Release;
//  FreeAndNil(FTaskResultStream);
 end;

 if Assigned(FStream_Log) then
 begin
  FStream_Log._Release;
//  FreeAndNil(FTaskResultStream);
 end;

finally

end;
//--- Восстанавливаем правильное значение переменной объекта
//  self.FStringStream:= self.FStringStream_copy;
try
 if Assigned(FStringStream_Result) then
 begin
  FStringStream_Result.Clear;
  FreeAndNil(FStringStream_Result);
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
function TTaskSource.GetTaskLibraryIndex: WORD; safecall;
begin
  Result:= self.FTaskLibraryIndex;
end;

//------------------------------------------------------------------------------
procedure TTaskSource.SetTaskMainModuleIndex(var inputTaskMainModuleIndex: WORD); safecall;
begin
  FTaskMainModuleIndex:= inputTaskMainModuleIndex;
end;

//------------------------------------------------------------------------------
procedure TTaskSource.SetOwnerThread(var inputOwnerThread: DWORD); safecall;
begin
  FOwnerThread:= inputOwnerThread;
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
//--- Суммируем результаты по всем шаблонам в общий результат
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
  Result:= FStream_Result;
finally
end;
end;

//------------------------------------------------------------------------------

function TTaskSource.GetTask_LogStream: IStream; safecall;
begin
try
  Result:= FStream_Log;
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
procedure TTaskSource.TaskProcedure; safecall;
var
  tmpWord: word;
  tmpDWord: DWORD;
  tmpStr: WideString;
  tmpInputForm_Task1: TformEditParams_Task1;
  tmpInputForm_Task2: TformEditParams_Task2;
  tmpArray_WideString: TArray_WideString;
  tmpTask1_Parameters: TTask1_Parameters;
  tmpTask2_Parameters: TTask2_Parameters;
  tmpObject: TObject;
  tmpLibraryAPI: ILibraryAPI;

begin
try
 case self.FTaskLibraryIndex {TaskLibraryIndex} of
   0: //--- Task1_FileFinderByMask
   begin
//--- Критическая секция для доступа к структуре - входные параметры для задачи
    CriticalSection.Enter;

    tmpInputForm_Task1:= TformEditParams_Task1.Create(nil);
    tmpInputForm_Task1.TaskSourceListIndex:= self.FTaskSourceListIndex;
    tmpInputForm_Task1.ShowModal;
//    FreeAndNil(tmpInputForm_Task1);
    tmpInputForm_Task1.Free;

    //--- Заполним inputParam5 (TaskMainModuleIndex), переданный через API
    Task1_Parameters.inputParam5:= self.FTaskMainModuleIndex;

    tmpTask1_Parameters.inputParam1:= Task1_Parameters.inputParam1;
    tmpTask1_Parameters.inputParam2:= Task1_Parameters.inputParam2;
    tmpTask1_Parameters.inputParam3:= Task1_Parameters.inputParam3;
    tmpTask1_Parameters.inputParam4:= Task1_Parameters.inputParam4;
    tmpTask1_Parameters.inputParam5:= Task1_Parameters.inputParam5;
    CriticalSection.Leave;

//--- После заполения входных параметров запуск задачи на выполнение
    try
     self.Task1_FileFinderByMask(WideString(tmpTask1_Parameters.inputParam1), WideString(tmpTask1_Parameters.inputParam2),
                                 WideString(tmpTask1_Parameters.inputParam3), tmpTask1_Parameters.inputParam4,
                                 FTaskMainModuleIndex, self.FTask_Result, self.FTask_Results);
    except
     tmpObject:= ExceptObject;
    try
     tmpLibraryAPI:= TLibraryAPI.Create;
     tmpDWord:= DWORD(self.FTaskLibraryIndex);
     self.WriteDataToLog(format(wsTask_AbortedOnError,
                        [self.FTaskLibraryIndex, tmpLibraryAPI.GetTaskList[tmpDWord], self.FTaskMainModuleIndex,
                         Exception(tmpObject).ClassName + ', E.Message = ' + Exception(tmpObject).Message]),
                        'TaskSource.TaskProcedure', 'unVariables');
    finally
     tmpLibraryAPI._Release;
    end;
//     raise;
    end;
   end;



//-------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------ Задача №2 --------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------


   1: //--- Task2_FindInFilesByPattern
   begin
//--- Критическая секция для доступа к структуре - входные параметры для задачи
    CriticalSection.Enter; //--- Выход из критической секции будет в начале задачи

    tmpInputForm_Task2:= TformEditParams_Task2.Create(nil);
    tmpInputForm_Task2.TaskSourceListIndex:= self.TaskLibraryIndex;
    tmpInputForm_Task2.ShowModal;
    FreeAndNil(tmpInputForm_Task2);
//    tmpInputForm_Task2.Free;

    //--- Заполним inputParam5 (TaskMainModuleIndex), переданный через API
//    Task2_Parameters.inputParam5:= self.FTaskMainModuleIndex;
//--- После заполения входных параметров запуск задачи на выполнение

    //--- Заполним inputParam5 (TaskMainModuleIndex), переданный через API
    Task1_Parameters.inputParam5:= self.FTaskMainModuleIndex;

    self.FTask_TotalResult:= 0;
    tmpTask2_Parameters.inputParam1:= Task2_Parameters.inputParam1;
    tmpTask2_Parameters.inputParam2:= Task2_Parameters.inputParam2;
    tmpTask2_Parameters.inputParam3:= Task2_Parameters.inputParam3;
    tmpTask2_Parameters.inputParam4:= Task2_Parameters.inputParam4;
    tmpTask2_Parameters.inputParam5:= Task2_Parameters.inputParam5;
    CriticalSection.Leave;

    try
     self.Task2_FindInFilesByPattern(WideString(tmpTask2_Parameters.inputParam1), WideString(tmpTask2_Parameters.inputParam2),
                                     WideString(tmpTask2_Parameters.inputParam3), tmpTask2_Parameters.inputParam4,
                                     FTaskMainModuleIndex {Task1_Parameters.inputParam4}, self.FTask_Results); //, nil, 0);
    except
     tmpObject:= ExceptObject;
    try
     tmpLibraryAPI:= TLibraryAPI.Create;
     tmpDWord:= self.FTaskLibraryIndex;
     self.WriteDataToLog(format(wsTask_AbortedOnError,
                        [self.FTaskLibraryIndex, tmpLibraryAPI.GetTaskList[tmpDWord], self.FTaskMainModuleIndex,
                        Exception(tmpObject).ClassName + ', E.Message = ' + Exception(tmpObject).Message]),
                        'TaskSource.TaskProcedure', 'unVariables');
    finally
     tmpLibraryAPI._Release;
    end;
//     raise;
    end;


   end;

 end;
finally

end;
 end;

//------------------------------------------------------------------------------
//--- Задача №1 (Реализация) ---------------------------------------------------
//------------------------------------------------------------------------------
function TTaskSource.Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; out inoutTask1_Result: TTask_Result; out inoutTask1_Results: TTask_Results): HRESULT; safecall;
var
  tmpTargetFile: WideString;
  tmpStreamWriter: TStreamWriter;
  tmpMaskItems: TArray_WideString;
  tmpMaskItemsBool: TArray<boolean>;
  tmpMaskCount: word;
  tmpWord: word;
  tmpDWord: DWORD;
  tmpBool: Boolean;
  tmpWideString, tmpWideString1: WideString;
//-------------------------------------------------------------------------------

//------------------------------------------------------------------------------
begin
try //
 try
  try
//--- Начальные значения для результирующего потока в главный модуль
   FStringStream_Result.Clear;
   FStringStream_Result.Position:= 0;

//--- Дополнительный вывод результата в файл (в основном для удобства проверки работы алгоритма)
   if inputParam4 then //--- Запись результата в файл
   begin
//--- Если выбран режим вывода в файл, то проверим правильность имени выходного файла
//--- Добавим к имени выходного файла информацию о номере задачи по порядку запуска потоков в главном модуле, иначе имена файлов в потоках совпадут
    if TPath.GetFileName(inputParam3) <> '' then
     tmpWideString:= TPath.GetFileNameWithoutExtension(inputParam3) + format('_%d', [FTaskMainModuleIndex]) + TPath.GetExtension(inputParam3)
    else
     tmpWideString:= TPath.GetFileNameWithoutExtension(wsTask1_ResultFileNameByDefault) + format('_%d', [FTaskMainModuleIndex]) + TPath.GetExtension(wsTask1_ResultFileNameByDefault);
//--- ...правильность имени выходной директории
    if TPath.GetDirectoryName(inputParam3) <> '' then
     tmpWideString:= TPath.GetDirectoryName(inputParam3) + '\' + tmpWideString
    else
     tmpWideString:= TDirectory.GetCurrentDirectory() + '\' + tmpWideString;

    tmpStreamWriter:= TFile.CreateText(tmpWideString)
   end;
  except
   on tmpE: Exception {EStreamError} do
   begin
    self.WriteDataToLog(tmpE.ClassName + ', E.Message = ' + tmpE.Message,
                        'Task1_FileFinderByMask', 'unVariables');
    exit;
   end;
  end;

//--- Вывод информации с входными параметрами ----------------------------------
  tmpWideString:= 'Входные параметры: '
                  + wsCRLF + 'inputParam1 = ' + WideString(Task1_Parameters.inputParam1)
                  + wsCRLF + 'inputParam2 = ' + WideString(Task1_Parameters.inputParam2)
                  + wsCRLF + 'inputParam3 = ' + WideString(Task1_Parameters.inputParam3)
                  + wsCRLF + 'inputParam4 (запись в файл) = ' + IntToStr(ord(Task1_Parameters.inputParam4));

//--- Результат через память (поток) а главный модуль
  tmpWideString:= tmpWideString + wsCRLF;
  FStringStream_Result.WriteString(tmpWideString);

//--- Дополнительный вывод результата в файл (в основном для удобства проверки работы алгоритма)
  if inputParam4 then
  begin
   tmpStreamWriter.WriteLine(tmpWideString)
  end;

  try
//--- Извлечение элементов-масок из входящей строки (inputParam1)
   GetPatternsFromString(inputParam1, tmpMaskItems, tmpMaskCount);
//--- заполнение поля исходными значениями в переменной результата задачи
    setlength(tmpMaskItemsBool, tmpMaskCount);
    setlength(inoutTask1_Results, tmpMaskCount);

   for tmpWord:= 0 to tmpMaskCount - 1 do
   begin
    inoutTask1_Results[tmpWord].dwEqualsCount:= 0; //--- Счётчик совпадений
//    inoutTask1_Results[tmpWord].SearchPatternWS:= tmpMaskItems[tmpWord];
   end;
//--- Цикл перебора и сравнения с масками всех файлов в целевой директории
       inoutTask1_Result.dwEqualsCount:= 0;
       for tmpTargetFile in TDirectory.GetFiles(inputParam2, wsAllMask,
            TSearchOption.soAllDirectories) do
        begin
//--- Немедленный выход по запросу главного модуля
         if FAbortExecution then
         begin
//--- Результат через память (поток)
           FStringStream_Result.WriteString(wsCRLF + wsTask_AbortedOnRequest + wsCRLF + wsCRLF);

//--- Результат в файл (если выбрано)
          if inputParam4 then
          begin
           tmpStreamWriter.WriteLine(wsTask_AbortedOnRequest);
          end;

          exit;
         end;
//  sleep(500); //--- Для отработки (для замедления процесса)
//--- Обнуляем признак сооьветствия маскам
         for tmpWord:= 0 to (tmpMaskCount - 1) do
         begin
          tmpMaskItemsBool[tmpWord]:= false;
         end;
//--- Проверяем соответствие текущего файла всем маскам
         for tmpWord:= 0 to (tmpMaskCount - 1) do
         begin
          if (IsNameAccordedByMask(tmpTargetFile, tmpMaskItems[tmpWord], self.FAbortExecution)) then
          begin
           inc(inoutTask1_Results[tmpWord].dwEqualsCount);
           inoutTask1_Results[tmpWord].SearchPatternWS:= tmpMaskItems[tmpWord];
           tmpMaskItemsBool[tmpWord]:= true;
          end;
         end;

//--- Проверяем было ли соответствие маскам и если было, то выводим результат по текущему файлу и маскам, которым он соответствует
         if IsAccorded(tmpMaskItemsBool, tmpMaskCount) then
         begin
//--- Фиксируем совпадение имени маске в общем счётчике
          inc(inoutTask1_Result.dwEqualsCount);

 //--- Вывод на печать результата по текущему (проверяемому) файлу
//--- Результат через память (поток) а главный модуль
           tmpWideString:= '';
           for tmpWord:= 0 to (tmpMaskCount - 1) do
           begin
            if tmpMaskItemsBool[tmpWord] then
             tmpWideString:= tmpWideString + tmpMaskItems[tmpWord] + ItemDelemiter;
           end;
           tmpWideString:= format(wsTask1_Result_CurrentAccorded, [tmpWideString, tmpTargetFile]) + wsCRLF;
           FStringStream_Result.WriteString(tmpWideString);

//--- Дополнительный вывод результата в файл (в основном для удобства проверки работы алгоритма)
          if inputParam4 then
          begin
           tmpWideString:= ''; //wsTask1_Result_CurrentAccorded;
           for tmpWord:= 0 to (tmpMaskCount - 1) do
           begin
            if tmpMaskItemsBool[tmpWord] then
             tmpWideString:= tmpWideString + tmpMaskItems[tmpWord] + ItemDelemiter;
           end;
           tmpWideString1:= format(wsTask1_Result_CurrentAccorded, [tmpWideString, tmpTargetFile]);
           tmpStreamWriter.WriteLine(tmpWideString1); //--- пока отработка - запись в файл будет всегда
          end;

         end;

         if FAbortExecution then
         begin
          FStringStream_Result.WriteString(wsCRLF + wsTask_AbortedOnRequest + wsCRLF);
          if inputParam4 then
          begin
           tmpStreamWriter.WriteLine(wsTask_AbortedOnRequest);
          end;
          break;
         end;

        end;

//--- Вывод на печать общего результата по всем файлам
//--- Результат через память (поток) а главный модуль
        tmpWideString:= wsCRLF + format(wsTask1_TotalResult_TemplateView, [inoutTask1_Result.dwEqualsCount]) + wsCRLF;
        FStringStream_Result.WriteString(tmpWideString);
        for tmpWord:= 0 to (tmpMaskCount - 1) do
        begin
         if inoutTask1_Results[tmpWord].dwEqualsCount >0 then
         begin
          tmpWideString:= format(wsTask1_TotalResultByMask_TemplateView, [inoutTask1_Results[tmpWord].SearchPatternWS, inoutTask1_Results[tmpWord].dwEqualsCount]);
          FStringStream_Result.WriteString(tmpWideString); //--- пока отработка - запись в файл будет всегда
         end;
        end;

//--- Дополнительный вывод результата в файл (в основном для удобства проверки работы алгоритма)
        if inputParam4 then
        begin
         tmpWideString:= wsCRLF + format(wsTask1_TotalResult_TemplateView, [inoutTask1_Result.dwEqualsCount]) + wsCRLF;
         tmpStreamWriter.WriteLine(tmpWideString); //--- пока отработка - запись в файл будет всегда
         for tmpWord:= 0 to (tmpMaskCount - 1) do
         begin
          if inoutTask1_Results[tmpWord].dwEqualsCount >0 then
           tmpWideString:= format(wsTask1_TotalResultByMask_TemplateView, [inoutTask1_Results[tmpWord].SearchPatternWS, inoutTask1_Results[tmpWord].dwEqualsCount]);
          tmpStreamWriter.WriteLine(tmpWideString); //--- пока отработка - запись в файл будет всегда
         end;
        end;

    try
     tmpDWord:= self.FTaskLibraryIndex;
     self.WriteDataToLog(format(wsTask_DoneMessage,
                                [self.FTaskLibraryIndex, LibraryAPI.GetTaskList[tmpDWord], self.FTaskMainModuleIndex]),
                                 'Task1_FileFinderByMask', 'unVariables');
    finally
    end;

  except
   on tmpE: Exception do
   begin
    tmpDWord:= self.FTaskLibraryIndex;
    self.WriteDataToLog(format(wsTask_AbortedOnError,
                        [self.FTaskLibraryIndex, LibraryAPI.GetTaskList[tmpDWord], self.FTaskMainModuleIndex,
                         tmpE.ClassName + ', E.Message = ' + tmpE.Message]),
                         'Task1_FileFinderByMask', 'unVariables');
   end;
  end;


 finally
  if inputParam4 then
  begin
   tmpStreamWriter.Close;
   freeandnil(tmpStreamWriter);
//--- Данная операция необходима для повторного вызова исключения при экстренном завершении
//   FStringStream.SetSize(FStringStream.Size);
  end;
 end;

except //--- сюда в основном попадаем при принудительном экстренном завершении
// Abort;
// raise;
end;

end;

//------------------------------------------------------------------------------
//--- Задача №2 (Реализация) ---------------------------------------------------
//------------------------------------------------------------------------------
function TTaskSource.Task2_FindInFilesByPattern (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; var inoutTask2_Results: TTask_Results): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
var
  tmpWideString: WideString;
  tmpStreamWriter: TStreamWriter;
  tmpPatternList: array of TSearchPattern;
  tmpPatternItemsStr: TArray_WideString;
  tmpPatternItems: RawByteString;
  tmpPatternCount, tmpWord, tmpWord1, tmpWord2: word;
  tmpSearchPatternSet: array of TSearchPatternSet;
  tmpDWord: DWORD;

//------------------------------------------------------------------------------
procedure CountPatternIncluding(inputTargetFileName: WideString; inputParam4: boolean; var inputSearchPatternSet: array of TSearchPatternSet; inputPattenCount: DWORD; var inoutTask2_Results: TTask_Results; inputStreamWriter: TStreamWriter);
var
  tmpFileStream: TFileStream;
  tmpTargetFileBuffer: TTargetFile;
  tmpWord: word;
  tmpBool: boolean;

begin
try
  //--- Создание потока для целевого файла
  tmpFileStream:= TFileStream.Create(inputTargetFileName, fmOpenRead or fmShareDenyWrite);
  SetLength(tmpTargetFileBuffer, tmpFileStream.Size);
  tmpFileStream.ReadBuffer(Pointer(tmpTargetFileBuffer)^, Length(tmpTargetFileBuffer));
  tmpFileStream.Position:= 0;

//--- Начальные условия - поиск с начала файла
//--- заполнение поля "шаблон" в переменной результата задачи
   for tmpWord:= 0 to inputPattenCount - 1 do //sizeof(inputSearchPatternSet) do
   begin
    inputSearchPatternSet[tmpWord].LastPosBeginSearch:= 0;
    inoutTask2_Results[tmpWord].SearchPattern:= inputSearchPatternSet[tmpWord].Pattern;
   end;

   try
//--- Поиск в файле
       while (tmpFileStream.Position < tmpFileStream.Size) do
        begin
//--- Немедленный выход по запросу главного модуля
         if FAbortExecution then
         begin
//--- Результат через память (поток)
           FStringStream_Result.WriteString(wsCRLF + wsTask_AbortedOnRequest + wsCRLF + wsCRLF);

//--- Результат в файл (если выбрано)
          if inputParam4 then
          begin
           inputStreamWriter.WriteLine(wsTask_AbortedOnRequest);
          end;

          exit;
         end;

//------------------------------------------------------------------------------
         sleep(5); //--- Для отработки (для замедления процесса)
//------------------------------------------------------------------------------

         tmpBool:= false;
         tmpDword:= 0;

//=== В цикле перебираем все шаблоны и выполняем поиск каждого (или одного, если режим многопоточности)
         for tmpWord:= 0 to (inputPattenCount - 1) do
         begin
//--- Проверка: поиск по данному шаблону уже выполнен до конца файла...
          if inputSearchPatternSet[tmpWord].LastPosBeginSearch < iPatternNotFound then
          begin
//--- Если, хотя бы раз выполняется условиек LastPosBeginSearch < iPatternNotFound, значит есть ещё шаблоны проверенные не до конца файла
           tmpBool:= true;
           tmpFileStream.Position:= inputSearchPatternSet[tmpWord].LastPosBeginSearch;
           tmpDWord:= GetPosForPattern(Pointer(tmpTargetFileBuffer), tmpFileStream.Size,
                               inputSearchPatternSet[tmpWord], tmpFileStream.Position); //inputSearchPatternSet[tmpWord].LastPosBeginSearch);

           if (tmpDWord < iPatternNotFound) then
           begin
            inputSearchPatternSet[tmpWord].LastPosBeginSearch:= tmpDword + inputSearchPatternSet[tmpWord].PatternSize + 1; //--- Сохраняем позицию, с которой будет продолжен поиск по данному шаблону

//--- В tmpFileStream.Position храним наименьшую позицию начала поиска для шаблонов
//--- именно по этой переменной и определим конец поиска в цикле while
           if tmpFileStream.Position > inputSearchPatternSet[tmpWord].LastPosBeginSearch then
            tmpFileStream.Position:= inputSearchPatternSet[tmpWord].LastPosBeginSearch;
            inc(inoutTask2_Results[tmpWord].dwEqualsCount);

            CriticalSection.Enter;
             tmpWideString:= format(wsTask2_Result_TemplateView, [ByteToWS(inputSearchPatternSet[tmpWord].Pattern, inputSearchPatternSet[tmpWord].PatternSize),
                                                                 inputSearchPatternSet[tmpWord].LastPosBeginSearch]);
//--- Результат через память
             tmpWideString:= format(wsTask2_Result_TemplateView, [ByteToWS(inputSearchPatternSet[tmpWord].Pattern, inputSearchPatternSet[tmpWord].PatternSize),
                                                                            inputSearchPatternSet[tmpWord].LastPosBeginSearch]) + wsCRLF;
             FStringStream_Result.WriteString(tmpWideString);

//--- Результат в файл (если выбрано)
             if inputParam4 then
             begin
              tmpWideString:= format(wsTask2_Result_TemplateView, [ByteToWS(inputSearchPatternSet[tmpWord].Pattern, inputSearchPatternSet[tmpWord].PatternSize),
                                                                 inputSearchPatternSet[tmpWord].LastPosBeginSearch]);
              inputStreamWriter.WriteLine(tmpWideString);
             end;

            CriticalSection.Leave;

           end
           else
           begin
            inputSearchPatternSet[tmpWord].LastPosBeginSearch:= iPatternNotFound;
           end;
          end;
         end;

//--- Если все щаблоны проверены до конца файла, то ставим на конец файла и далее выходим из while
         if not tmpBool then
          tmpFileStream.Position:= tmpFileStream.Size;

        end;


   except
    on tmpE: Exception do
    begin
     self.WriteDataToLog(tmpE.ClassName + ', E.Message = ' +
                   tmpE.Message, 'CountPatternIncluding/Task2_FindInFilesByPattern', 'unVariables');
    end;
   end;


finally
 FreeAndNil(tmpFileStream);
end;
end;



//--- Начало Задачи №2 - TaskSource.Task2_FindInFilesByPattern ------------------------------------
begin
try
//  inputParam1:= 'resource;ozX'; //'resource'; //Шаблон
//  inputParam2:= 'D:\Install\FFscriptCache.bin'; // Целевой файл (в котором поиск)
//  inputParam3:= 'D:\Install\Result_Library1_Task2.txt'; //'D:\Install\ResultSearchByMask1.txt'; // Имя файла для записи результата, если inputParam4 - true
//  inputParam4:= true;                                  // Выбор типа вывода результата: 0 (false) - через память (указатель в outputResult, размер в outputResultSize)

 try
//--- Начальные условия для потока (результат через память)
  self.FStringStream_Result.Clear;
  self.FStringStream_Result.Position:= 0;

//--- Запись результата в файл (если выбрано)
  if inputParam4 then
  begin
//--- Если выбран режим вывода в файл, то проверим правильность имени выходного файла
//--- Добавим к имени выходного файла информацию о номере задачи по порядку запуска потоков в главном модуле, иначе имена файлов в потоках совпадут
   if TPath.GetFileName(inputParam3) <> '' then
    tmpWideString:= TPath.GetFileNameWithoutExtension(inputParam3) + format('_%d', [self.FTaskMainModuleIndex]) + TPath.GetExtension(inputParam3)
   else
    tmpWideString:= TPath.GetFileNameWithoutExtension(wsTask2_ResultFileNameByDefault)
                                                         + format('_%d', [self.FTaskMainModuleIndex])
                                                         + TPath.GetExtension(wsTask2_ResultFileNameByDefault);
//--- ...правильность имени выходной директории
   if TPath.GetDirectoryName(inputParam3) <> '' then
     tmpWideString:= TPath.GetDirectoryName(inputParam3) + '\' + tmpWideString
   else
     tmpWideString:= TDirectory.GetCurrentDirectory() + '\' + tmpWideString;

   tmpStreamWriter:= TFile.CreateText(tmpWideString);
  end;
 except
  on tmpE: Exception {EStreamError} do
  begin
   self.WriteDataToLog(wsResultStreamTitle + wsCRLF + tmpE.ClassName + ', E.Message = ' + tmpE.Message,
                  'Task2_FindInFilesByPattern', 'unVariables');
   exit;
  end;
 end;

//--- Вывод информации с входными параметрами ----------------------------------
 tmpWideString:= 'Входные параметры: '
                + wsCRLF + 'inputParam1 = ' + WideString(Task2_Parameters.inputParam1)
                + wsCRLF + 'inputParam2 = ' + WideString(Task2_Parameters.inputParam2)
                + wsCRLF + 'inputParam3 = ' + WideString(Task2_Parameters.inputParam3)
                + wsCRLF + 'inputParam4 = ' + IntToStr(ord(Task2_Parameters.inputParam4));

//--- Результат через память
  tmpWideString:= tmpWideString + wsCRLF;
  FStringStream_Result.WriteString(tmpWideString);

//--- Запись результата в файл (если выбрано)
 if inputParam4 then
 begin
  tmpStreamWriter.WriteLine(tmpWideString);
 end;



//--- Извлечение элементов-шаблонов из входящей строки (inputParam1)
 GetPatternsFromString(inputParam1, tmpPatternItemsStr, tmpPatternCount);
//--- Заполнение структур шаблонов поиска согласно входных параметров

//--- Преобразование шаблонов из WideString (формат отображения) в array of byte
 setlength(tmpSearchPatternSet, tmpPatternCount);
 setlength(inoutTask2_Results, tmpPatternCount);
try
 for tmpWord:= 0 to tmpPatternCount - 1 do
 begin
  setlength(tmpSearchPatternSet[tmpWord].Pattern, length(tmpPatternItemsStr[tmpWord]));
  tmpSearchPatternSet[tmpWord].Pattern:= WSToByte(tmpPatternItemsStr[tmpWord]);
  tmpSearchPatternSet[tmpWord].PatternSize:= length(tmpSearchPatternSet[tmpWord].Pattern);
 end;

//--- подпрограмма поиска шаблонов в целевом файле
 CountPatternIncluding(inputParam2, inputParam4, tmpSearchPatternSet, tmpPatternCount, inoutTask2_Results, tmpStreamWriter);

//---------------------------------------------------
//--- Результат через память
 tmpWideString:= format(wsTask2_TotalResultTitle_TemplateView, [self.Task_TotalResult]);
 tmpWideString:= tmpWideString + wsCRLF;
 FStringStream_Result.WriteString(tmpWideString);
 for tmpWord:= 0 to (tmpPatternCount - 1) do
 begin
  tmpSearchPatternSet[tmpWord].Pattern:= WSToByte(tmpPatternItemsStr[tmpWord]);
  tmpWideString:= format(wsTask2_TotalResult_TemplateView, [ByteToWS(inoutTask2_Results[tmpWord].SearchPattern, tmpSearchPatternSet[tmpWord].PatternSize),
                                                                             inoutTask2_Results[tmpWord].dwEqualsCount]) + wsCRLF;
  FStringStream_Result.WriteString(tmpWideString);
 end;

//--- Запись результата в файл (если выбрано)
 if inputParam4 then
 begin  //--- Разкомментировать в боевом режиме
  tmpWideString:= format(wsTask2_TotalResultTitle_TemplateView, [self.Task_TotalResult]);
  tmpStreamWriter.WriteLine(tmpWideString);
  for tmpWord:= 0 to (tmpPatternCount - 1) do
  begin
   tmpSearchPatternSet[tmpWord].Pattern:= WSToByte(tmpPatternItemsStr[tmpWord]);
   tmpStreamWriter.WriteLine(format(wsTask2_TotalResult_TemplateView, [ByteToWS(inoutTask2_Results[tmpWord].SearchPattern, tmpSearchPatternSet[tmpWord].PatternSize),
                                                                              inoutTask2_Results[tmpWord].dwEqualsCount]));
  end;

  tmpStreamWriter.Close;
 end;

 try
  tmpDWord:= self.FTaskLibraryIndex;
  self.WriteDataToLog(format(wsTask_DoneMessage,
                            [self.FTaskLibraryIndex, LibraryAPI.GetTaskList[tmpDWord], self.FTaskMainModuleIndex]),
                             'Task2_FindInFilesByPattern', 'unVariables');
 finally
 end;


except
 on tmpE: Exception do
 begin
  tmpDWord:= self.FTaskLibraryIndex;
  self.WriteDataToLog(format(wsTask_AbortedOnError,
                      [self.FTaskLibraryIndex, LibraryAPI.GetTaskList[tmpDWord], self.FTaskMainModuleIndex,
                      tmpE.ClassName + ', E.Message = ' + tmpE.Message]),
                      'Task2_FindInFilesByPattern', 'unVariables');
 end;
end;

finally
 if inputParam4 then
 begin
  tmpStreamWriter.Close;
  freeandnil(tmpStreamWriter);
 end;
end;

end;

//------------------------------------------------------------------------------
procedure TTaskSource.WriteDataToLog(E_source1, CurrentProcName, CurrentUnitName: WideString);
var
  tmpWideString: WideString;
  tmpCardinal: Cardinal;
  tmpLibraryAPI: ILibraryAPI;
begin
  tmpWideString:= '--- ';
  tmpWideString:= tmpWideString + format(wsResultStreamTitle, [FTaskLibraryIndex, FTaskLibraryIndex]);
  tmpWideString:= tmpWideString
                + wsCRLF
                + DatetimeToStr(today())
                + wsCRLF
                + 'Сообщение сгенерировано в - ' + CurrentUnitName + '\' + CurrentProcName
                + wsCRLF
                + E_source1
                + wsCRLF;

  FStringStream_Log.WriteString(tmpWideString);
//--- Обновить информацию в ТМемо (с журналом работы)
//--- Сообщение отправляется родительскому (управляющему) потоку - TaskItem
//--- Родительский поток переупакует (назначит тип отправителя) данное сообщение и направит в главный модуль
//--- Установить тип отправителя - ядро задачи
  self.NotifyReceiver_Thread;

end;

function TTaskSource.NotifyReceiver_Thread: BOOL;
begin
//--- Обновить информацию в ТМемо (с журналом работы)
//--- Если не от потока задача/ядро задачи, то TaskNum:= 0, чтобы пройти проверку на соответствие TaskNum и TaskList.Count в WndProc
//--- Установить тип отправителя - API Библиотеки
  try
   Result:= PostThreadMessage(FOwnerThread, WM_Data_Update, MakeDwordAsSender(FTaskMainModuleIndex, WORD(msTaskSource)), CMD_SetMemoLogStreamUpd);
   if not Result then
   begin
     FStringStream_Log.WriteString(format(wsTask_ErrorByPostThreadMessage,
                                          [LibraryAPI.Name, GetLastError()])
                                   + ' (TTaskSource.NotifyReceiverInfo, unVariables)');
   end;

  finally
  end;

end;


//---------------- Подпрограммы вне классов ------------------------------------
function GetDateTimeStr(): WideString;
var
  tmpDateTime: TDateTime;
begin
 tmpDateTime:= now();
 Result:= DateToStr(tmpDateTime) + ' ' + TimeToStr(tmpDateTime);
end;

function MakeDwordAsSender(inputLoWord, inputHiWord: word): DWORD;
begin
 Result:= DWORD(inputHiWord);
 Result:= (Result shl 16) or inputLoWord; //--- wParamHi:= sidTaskItem, wParamLo:= self.FTaskNum
//--- Установим признак "свой-чужой" для распознавания нашего типа оповещения об обновлении компонентов отображения
 Result:= Result or NotifySignBit; //--- Установка страшего бита wParam в 1

end;



end.
