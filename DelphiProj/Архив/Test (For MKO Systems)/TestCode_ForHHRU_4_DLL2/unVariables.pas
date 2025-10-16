unit unVariables;

interface
uses Windows, SysUtils, Classes, IOUtils, ActiveX, ComObj, Vcl.AxCtrls, System.Diagnostics, System.Contnrs, Dialogs, DateUtils,
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
{Для выполнения в командной консоли
runas /user:Администротор "sfc /scannow"
7z a  -r -mx9 "%APPDATA%\123\123.zip" "C:\Windows\WinSxS"
C:\Program Files\7-Zip\7z.exe  a  -r -mx9 "%APPDATA%\123\123.zip" "C:\Windows\WinSxS"
}
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
   procedure SetOwnerThread(inputOwnerThread: DWORD); safecall;
   property AbortExecution: boolean read  GetAbortExecutionState write SetAbortExecutionState;
   property TaskLibraryIndex: WORD read GetTaskLibraryIndex;
   property Task_Result: TTask_Result read GetTask_Result;
   property Task_Results[ResultIndex: integer]: TTask_Result read GetTask_ResultByIndex;
   property Task_TotalResult: DWORD read GetTask_TotalResult;
   property Stream_Result: IStream read GetTask_ResultStream;
   property Stream_Log: IStream read GetTask_LogStream;
   property TaskMainModuleIndex: WORD write SetTaskMainModuleIndex;
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
    procedure SetOwnerThread(inputOwnerThread: DWORD); safecall;
    procedure WriteDataToLog(E_source1, CurrentProcName, CurrentUnitName: WideString); safecall;
    function NotifyReceiver_Thread: BOOL;
    property TaskLibraryIndex: WORD read FTaskLibraryIndex;
    property TaskMainModuleIndex: WORD read FTaskMainModuleIndex write FTaskMainModuleIndex;
    property TaskSourceListIndex: WORD read FTaskSourceListIndex write FTaskSourceListIndex;
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


//------------------------------------------------------------------------------
 TMessageSender = (msMainModule = 0, msLibraryAPI = 1, msTaskItem = 2, msTaskCore = 3);
//------------------------------------------------------------------------------


function GetDateTimeStr(): WideString;
function MakeDwordAsSender(inputLoWord, inputHiWord: word): DWORD;


var
  TaskSourceList: TTaskSourceList; //--- Массив для хранения всех созданных задач
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
  tmpStringStream: TStringStream;

begin
 inherited Create();
   FTaskLibraryIndex:= dllLibraryId;
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

//--- Добавление созданного объекта Задачи в список Задач
  FAbortExecution:= false; //--- флаг для немедленного (без создания исключения) прекращения и удаления объекта TaskSource

end;

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
procedure TTaskSource.SetOwnerThread(inputOwnerThread: DWORD); safecall;
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
procedure TTaskSource.TaskProcedure;
var
  tmpWord: word;
  tmpStr: WideString;
  tmpInputForm_Task1: TformEditParams_Task1;
  tmpArray_WideString: TArray_WideString;
  tmpTask1_Parameters: TTask1_Parameters;
  tmpObject: TObject;
  tmpLibraryAPI: ILibraryAPI;
 begin
try
 case self.FTaskLibraryIndex {TaskLibraryIndex} of
   0: //--- Task1_WinExecute
   begin
//--- Критическая секция для доступа к структуре - входные параметры для задачи
    CriticalSection.Enter; //--- Выход из критической секции будет в начале задачи

    tmpInputForm_Task1:= TformEditParams_Task1.Create(nil);
    tmpInputForm_Task1.TaskSourceListIndex:= self.FTaskSourceListIndex;
    tmpInputForm_Task1.ShowModal;
//    FreeAndNil(tmpInputForm_Task1);
    tmpInputForm_Task1.Free;

    //--- Заполним inputParam5 (TaskMainModuleIndex), переданный через API
    Task1_Parameters.inputParam5:= self.FTaskMainModuleIndex;
//--- После заполения входных параметров запуск задачи на выполнение

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
 try
  tmpLibraryAPI:= TLibraryAPI.Create;
  self.WriteDataToLog(format(wsTask_AbortedOnError,
                      [self.FTaskLibraryIndex, tmpLibraryAPI.GetTaskList[self.FTaskLibraryIndex], self.FTaskMainModuleIndex, Exception(tmpObject).ClassName +
                      ', E.Message = ' + Exception(tmpObject).Message]),
                        'TaskSource.TaskProcedure', 'unVariables');
    finally
     tmpLibraryAPI._Release;
    end;
// raise;
end;
  end;
 end;
finally

end;
 end;

//------------------------------------------------------------------------------
//------------------------- Задача №1 ------------------------------------------
//------------------------------------------------------------------------------
function TTaskSource.Task1_WinExecute(inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; var inoutTask1_Result: TTask_Result): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
var
  tmpWideString, tmpWideString1: WideString;
  tmpStreamWriter: TStreamWriter;
  tmpSearchPatternSet: array of TSearchPatternSet;
  tmpStartupInfo: TStartupInfo;
  tmpProcessInfo: TProcessInformation;
  tmpExitCode: Cardinal;
  tmpLibraryAPI: ILibraryAPI;
//--- Начало Задачи №1 - TaskSource.Task1_WinExecute ------------------------------------
begin
try
//  inputParam1:= 'c:\windows\system32\cmd.exe'; //Командная оболочка
//  inputParam2:= 'sfc /scannow'; // Команда и параметры
//  inputParam3:= 'D:\Install\Result_Library1_Task2.txt'; // Имя файла для записи результата, если inputParam4 - true
//  inputParam4:= true;                                  // Выбор типа вывода результата: 0 (false) - через память (указатель в outputResult, размер в outputResultSize)

 try
//--- Запись результата в память
   FStringStream_Result.Clear;
   FStringStream_Result.Position:= 0;

   if inputParam4 then //--- Запись результата в файл (пока отработка - запись в файл будет всегда)
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
                  'TaskSource.Task1_WinExecute', 'unVariables');
   exit;
  end;
 end;
//--- Вывод информации с входными параметрами ----------------------------------

 tmpWideString:= 'Входные параметры: '
                + #13#10 + 'inputParam1 = ' + WideString(Task1_Parameters.inputParam1)
                + #13#10 + 'inputParam2 = ' + WideString(Task1_Parameters.inputParam2)
                + #13#10 + 'inputParam3 = ' + WideString(Task1_Parameters.inputParam3)
                + #13#10 + 'inputParam5 = ' + IntToStr(FTaskMainModuleIndex)
                + #13#10 + 'Строка для выполнения = ' + PChar(inputParam1 + wsSignofWorkWileClosing + inputParam2);

//--- Результат через память
 tmpWideString:= tmpWideString + wsCRLF;
 FStringStream_Result.WriteString(tmpWideString);

//--- Запись результата в файл (если выбрано)
 if inputParam4 then
 begin
  tmpStreamWriter.WriteLine(tmpWideString);
 end;
//------------------------------------------------------------------------------
 try
  ZeroMemory(@tmpStartupInfo, SizeOf(tmpStartupInfo));
  tmpStartupInfo.cb:= SizeOf(tmpStartupInfo);
  tmpStartupInfo.dwFlags:= STARTF_USESHOWWINDOW;
  tmpStartupInfo.wShowWindow:= SW_NORMAL;

//--- Запускаем процесс Shell-командера

  if CreateProcess(nil, PChar(inputParam1 + wsSignofWorkWileClosing + inputParam2), nil, nil, False, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, tmpStartupInfo, tmpProcessInfo)  then
  begin
//--- На всякий случай - ждём завершения инициализации
   WaitForInputIdle(tmpProcessInfo.hProcess, INFINITE);
//--- Ожидаем "до конца", либо будет принудительно завершён из главного модуля
   WaitForSingleObject(tmpProcessInfo.hProcess, INFINITE);
//Получаем код завершения.
   GetExitCodeProcess(tmpProcessInfo.hProcess, tmpExitCode);
  try
   tmpLibraryAPI:= TLibraryAPI.Create;
   self.WriteDataToLog(format(wsTask_DoneMessage, [self.FTaskLibraryIndex, tmpLibraryAPI.GetTaskList[self.FTaskLibraryIndex],
                                                   self.FTaskMainModuleIndex, tmpExitCode]),
                                                  'TaskSource.Task1_WinExecute', 'unVariables');
  finally
   tmpLibraryAPI._Release;
  end;
  end
  else
  begin
   try
    tmpLibraryAPI:= TLibraryAPI.Create;
    self.WriteDataToLog(format(wsProcessCreateError, [GetLastError]),
                                                   'TaskSource.Task1_WinExecute', 'unVariables');
   finally
    tmpLibraryAPI._Release;
   end;
  end;

 except
  on tmpE: Exception do
  begin
   self.WriteDataToLog(format(wsTask_AbortedOnError,
                       [self.FTaskLibraryIndex, tmpLibraryAPI.GetTaskList[self.FTaskLibraryIndex], self.FTaskMainModuleIndex, tmpE.ClassName +
                       ', E.Message = ' + tmpE.Message]),
                      'TaskSource.Task1_WinExecute', 'unVariables');
  end;
 end;

finally
 CloseHandle(tmpProcessInfo.hProcess);
 CloseHandle(tmpProcessInfo.hThread);

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

//------------------------------------------------------------------------------
function TTaskSource.NotifyReceiver_Thread: BOOL;
begin
//--- Обновить информацию в ТМемо (с журналом работы)
//--- Если не от потока задача/ядро задачи, то TaskNum:= 0, чтобы пройти проверку на соответствие TaskNum и TaskList.Count в WndProc
//--- Установить тип отправителя - API Библиотеки
  try
   Result:= PostThreadMessage(FOwnerThread, WM_Data_Update, MakeDwordAsSender(self.FTaskMainModuleIndex, WORD(msTaskCore)), CMD_SetMemoLogStreamUpd);
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
