unit unTasks;

interface
uses
  Vcl.Forms, System.Classes, System.SysUtils, System.SyncObjs, System.Diagnostics, Winapi.Windows, Vcl.ExtCtrls, System.Contnrs,
  unConst, unVariables, IdUDPClient, Dialogs, IOUtils;

type

  TTaskState = (tsNotDefined = -1 {одно из применений - при запуске, до момента полного создания всех объектов задачи},
                tsActive = 0, tsTerminate = 1, tsPause = 2, tsReportPause = 3);

//  TProcedure = reference to procedure;
{$IFDEF MSWINDOWS}
//    TTaskOSPriority = (tpIdle, tpLowest, tpLower, tpNormal, tpHigher, tpHighest,
//    tpTimeCritical) platform;
  TTaskOSPriority = array of TThreadPriority;
{$ENDIF MSWINDOWS}
  TPeriodReport = 1..5000; // указывается в мс

  TTaskItem = class;
//  TTaskProcedure = reference to procedure (TaskItem: TTaskItem); // of object;
  TTaskProcedure = procedure (TaskItem: TTaskItem) of object;

  TTaskSource = class (TObject)
   private
    const
     FTaskSourceName: string  = 'Нет назначенного алгоритма';
   private
      FTaskItem: TTaskItem;
//    FTimerOut: TTimer;
//    FPtrPred: Pointer;
//    FPtrNext: Pointer;
   protected
//    procedure TaskProcedure(TaskItem: TTaskItem); virtual; abstract;
    procedure TaskProcedure(TaskItem: TTaskItem); virtual; abstract;
   public
    FTaskState: TTaskState;
    FDllProcName: PWideChar;
    class var FCallingDLLProc: TCallingDLLProc;
    constructor Create(TaskItemNum: word);
    function GetName: string;
    property TaskState: TTaskState read FTaskState write FTaskState;
    procedure SetTaskItem(TaskItem: TTaskItem);
    function GetTaskItem: TTaskItem;

    property DllProcName: PWideChar read FDllProcName;
//    property PtrPred: Pointer read FPtrPred write FTaskState;
  end;

  TTaskSource2 = class (TTaskSource)
   private
    const
     FTaskSourceName: string  = 'Расчёт числа Пи';
   protected
   public
    constructor Create(TaskItemNum: word); overload;
    class procedure TaskProcedure(TaskItem: TTaskItem); overload; inline;
  end;


//--- После создания необходимо самостоятельно следить за жизненным циклом классов - TaskSource
//--- так как здесь не возможно их хранить в TObjectList... --------------------
//  TTaskSourceList = TArray<TTaskSource>;
(*   TTaskSourceList = class (TObjectList)   //--- Применён из-за встроенного менеджера памяти
   private
    function GetItem(Index: integer): TTaskSource;
    procedure SetItem(Index: integer; const Value: TTaskSource);
   public
    property Items[Index: integer]: TTaskSource read GetItem write SetItem; default;
  end;
*)

  TTaskSource4 = class (TTaskSource)
   private
    const
     FTaskSourceName: string  = 'Новые задачи для теста'; //--- 'Определение простых чисел методом перебора'
   protected
    FCurrentNumber: Int64;
    procedure SetCurrentNumber(inNumber: Int64);
   public
    constructor Create(TaskItemNum: word); overload;
    class procedure TaskProcedure(TaskItem: TTaskItem); overload; inline;

    property CurrentNumber: Int64 read FCurrentNumber write SetCurrentNumber;
  end;

//  TTaskSourceList = TArray<TTaskSource4>;
  TTaskSource4List = class (TObjectList)   //--- Применён из-за встроенного менеджера памяти
   private
    function GetItem(Index: integer): TTaskSource4;
    procedure SetItem(Index: integer; const Value: TTaskSource4);
   public
    property Items[Index: integer]: TTaskSource4 read GetItem write SetItem; default;
  end;


//------------------------------------------------------------------------------

  TTaskItem = class (TThread)
   private
    FTaskName: string;
    FTaskNum: word;
    FTaskSource: TTaskSource;
    FTaskState: TTaskState;
    FPauseEvent: TEvent;
    FPeriodReport: TPeriodReport;
//    FIsReportNeed: boolean;
    FLastOSTickCount: cardinal;
    FStopWatch: TStopwatch;
    FElapsedMillseconds: Int64;
//    FTimerCycleCount: Int64;
    FCycleTimeValue: word; // продолжительность одного расчётного цикла в мс (по умолчанию 1000 мс)
    FTaskStepCount: Int64;
    FCoreUtilization: byte;
{$IFDEF MSWINDOWS}
    FTaskOSPriority: TTaskOSPriority;
{$ENDIF MSWINDOWS}
    FInfoUpdatePeriod: TPeriodReport;

    FHandleWinForView: hWnd;
    FInfoFromTask: String;
    FIsDeleted: boolean;
    FClientUDP: TIdUDPClient;
    procedure thrSendInfoToView;
   protected
    FTaskLibraryId: word;
    FTaskTemplateId: word;
    FTaskProcedure: TTaskProcedure;

    FLineIndex_ForView: integer;
    FSreamWriterNum: word;

//    procedure ExecProcedure;   //--- Фактический адрес подпрограммы будет назначен в конструкторе
//    ExecProcedure: TTaskProcedure;   //--- Фактический адрес подпрограммы будет назначен в конструкторе
    procedure Execute; override;
   public
    constructor Create(TaskLibraryId, TaskTemplateId: word; BeginState: TTaskState); overload;
    destructor Destroy(); overload;
    procedure OnTerminate(Sender: TObject); overload;
    procedure SetTaskNum(TaskNum: word);
    procedure SetTaskState(inTaskState: TTaskState);
    procedure SetPeriodReport(PeriodReport: TPeriodReport);
    procedure SetHandleWinForView(WinForView: hWnd);
    procedure SetTaskSource(TaskSource: TTaskSource);
    procedure SetTaskName(TaskItemName: string = '');
    procedure SetStreamWriter(TaskStreamWriter: word);
    procedure SendReportToMainProcess;
    procedure DeleteTaskFromViewingList;
    procedure CheckReportTime(TaskItem: TTaskItem);
    procedure MarkAsDeleted;
    function GetTaskSource(): TTaskSource;
    function GetPeriodReport: TPeriodReport;
    function GetTaskState(): TTaskState;
    function PrepareOutString(TaskNum: integer; sPersonThreadInfo: string): string;
    function GetTaskStateName(inTaskState: TTaskState): string;
    function InitTaskSource(SelectedLibraryNum, SelectedTaskNum: byte; TaskItemNum: word): Pointer;
    function IsTerminated: boolean;

    property TaskName: string read FTaskName;
    property TaskNum: word read FTaskNum;
{$IFDEF MSWINDOWS}
    property TaskSource: TTaskSource read FTaskSource write SetTaskSource;
    property TaskOSPriority: TTaskOSPriority read FTaskOSPriority write FTaskOSPriority;
//    property TaskExecProcedure: TTaskProcedure read ExecProcedure;
    property TaskState: TTaskState read FTaskState write SetTaskState;
    property CoreUtilization: byte read FCoreUtilization;

{$ENDIF MSWINDOWS}

    property PeriodReport: TPeriodReport read FPeriodReport;
    property LineIndex_ForView: integer read FLineIndex_ForView write FLineIndex_ForView;
    property HandleWinForView: hWnd read FHandleWinForView write SetHandleWinForView;
    property InfoFromTask: string read FInfoFromTask write FInfoFromTask;
    property StreamWriterNum: word read FSreamWriterNum;

//    property TimerCycleCount: Int64 read FTimerCycleCount;
  published
    property Terminated;
  end;

//------------------------------------------------------------------------------
  TTaskList = class (TObjectList)   //--- Применён из-за встроенного менеджера памяти
   private
    function GetItem(Index: integer): TTaskItem;
    procedure SetItem(Index: integer; const Value: TTaskItem);
   public
    property Items[Index: integer]: TTaskItem read GetItem write SetItem; default;
  end;
//------------------------------------------------------------------------------
//---- Работаем с таймерами только через переменные объектов класса YaskItem ---
//---- Организация таймеров в список необходимо только для простоты работы с памятью
//---- избавление от утечек памяти
(*
  TTimerItem = class (TTimer)
   private
    FTaskItem: TTaskItem;
//    FTaskNum: word;
    FTimerCycleCount: Int64;
   protected
    function FOnTimer(Sender: TObject): TNotifyEvent; overload;

   public
    constructor Create(TaskItem: TTaskItem); overload;
    procedure SetTaskNum(TaskNum: word);
//    property TaskNum: word read FTaskNum write SetTaskNum;
  end;

  TTimerItem = class (TTimer)
   private
    FTaskItem: TTaskItem;
//    FTaskNum: word;
    FTimerCycleCount: Int64;
   protected
    function FOnTimer(Sender: TObject): TNotifyEvent; overload;

   public
    constructor Create(TaskItem: TTaskItem); overload;
    procedure SetTaskNum(TaskNum: word);
//    property TaskNum: word read FTaskNum write SetTaskNum;
  end;

  TTimerList1 = class (TObjectList)   //--- Применён из-за встроенного менеджера памяти
   private
    function GetItem(Index: integer): TTimerItem;
    procedure SetItem(Index: integer; const Value: TTimerItem);
   public
    property Items[Index: integer]: TTimerItem read GetItem write SetItem; default;
  end;
*)


 var
    TaskList: TTaskList;

    CriticalSection: TCriticalSection;
    OutInfo_ForViewing: TOutInfo_ForViewing;
    ReportingTaskItemNum: integer;
    stSystemTimes: TThread.TSystemTimes;
    curTaskItem: TTaskItem;

//------------------------------------------------------------------------------


// {$L unThread.pas}
// procedure Calc_NOP(TaskItemIndex: byte); external;
// procedure Calculate_Dummy();
// procedure Calculate_Dummy(TaskItemIndex: byte); external;
// procedure Calculate_Pi_Gauss(TaskItemIndex: byte); external;


procedure Calc_NOP(TaskItemIndex: byte);
//function InitTaskSource(SelectedTaskNum: byte; TaskItemNum: word): Pointer;
//procedure SendReportToMainProcess(TaskItem: TTaskItem);
//function PrepareOutString(TaskNum: integer): string;


implementation
uses unMain, unUtilCommon, IdGlobal, unUtils;

//------------------------------------------------------------------------------
//---------- Данные для TTaskSource... -----------------------------------------
//------------------------------------------------------------------------------

function TTaskSource.GetName(): string;
begin
  Result:= self.FTaskSourceName;
end;

procedure TTaskSource.SetTaskItem(TaskItem: TTaskItem);
begin
 self.FTaskItem:= TaskItem;
end;

function TTaskSource.GetTaskItem: TTaskItem;
begin
 Result:= self.FTaskItem;
end;

constructor TTaskSource.Create(TaskItemNum: word);
var
  tmpProc: TTaskProcedure;
begin
 inherited Create();
 TaskList[TaskItemNum].SetTaskSource(self);
 tmpProc:= TaskProcedure;
// TaskList[TaskItemNum].FTaskProcedure:= TMethod(pooTmp).Code;
 TaskList[TaskItemNum].FTaskProcedure:= tmpProc;
end;


//------------- procedure TTaskSource2 -----------------------------------------
constructor TTaskSource2.Create(TaskItemNum: word);
begin
 inherited Create(TaskItemNum);
 if not aTaskDllProcNameArray[TaskList[TaskItemNum].FTaskTemplateId].IsEmpty then
  FDllProcName:= PWideChar(aTaskDllProcNameArray[TaskList[TaskItemNum].FTaskTemplateId])
 else
  FDllProcName:= '';

 @CallingDLLProc:= GetProcAddress(hDllTask, FDllProcName);
 FCallingDLLProc:= CallingDLLProc;

 // Для данного шаблона источника задачи требуется наличие писателя в файл (пока только в текстовый)
 TaskList[TaskItemNum].SetStreamWriter(FileList.Add(TFileItem.Create(TaskItemNum)));

end;

//------------- procedure TTaskSource4 -----------------------------------------
procedure TTaskSource4.SetCurrentNumber(inNumber: Int64);
begin
 FCurrentNumber:= inNumber;
end;

constructor TTaskSource4.Create(TaskItemNum: word);
begin
 inherited Create(TaskItemNum);
 if not aTaskDllProcNameArray[TaskList[TaskItemNum].FTaskTemplateId].IsEmpty then
  FDllProcName:= PWideChar(aTaskDllProcNameArray[TaskList[TaskItemNum].FTaskTemplateId])
 else
  FDllProcName:= nil;

 @CallingDLLProc:= GetProcAddress(hDllTask, FDllProcName);
 FCallingDLLProc:= CallingDLLProc;

 // Для данного шаблона источника задачи требуется наличие писателя в файл (пока только в текстовый)
 TaskList[TaskItemNum].SetStreamWriter(FileList.Add(TFileItem.Create(TaskItemNum)));

end;


//------------------------------------------------------------------------------
//---------- Данные для TTaskSourceList ----------------------------------------------
//------------------------------------------------------------------------------
(*
function TTaskSourceList.GetItem(Index: integer): TTaskSource;
begin
 Result:= TTaskSource(inherited GetItem(Index));
end;

procedure TTaskSourceList.SetItem(Index: integer; const Value: TTaskSource);
begin
 inherited SetItem(Index, Value);
end;
*)

//------------------------------------------------------------------------------
//---------- Данные для TTaskItem ----------------------------------------------
//------------------------------------------------------------------------------
constructor TTaskItem.Create(TaskLibraryId, TaskTemplateId: word; BeginState: TTaskState);
var
  tmpWord: word;
  tmpBool: boolean;
begin
 //--- Установим начальное состояние задачи в tsNotDefined
 //--- для исклбчениея её из процесса опроса состояния
 //--- пока все объекты не будут созданы и настоены
 TaskState:= tsNotDefined;

 inherited  Create(false); //--- отложим запуск потока до AfterConstraction
 //--- В этом конструкторе всё выдаём по умолчанию
 FTaskLibraryId:= TaskLibraryId; // Номер задачи-шаблона из массива aTaskNameArray
 FTaskTemplateId:= TaskTemplateId; // Номер задачи-шаблона из массива aTaskNameArray
 FTaskName:= aTemplateTaskNameArray[FTaskTemplateId];
 FreeOnTerminate:= true;
 Priority:= tpNormal;
// self.FDSiTimer.Interval:= TaskList[TaskItemNum].GetPeriodReport;
 FPeriodReport:= 2000; //--- миллисекунд
 FCycleTimeValue:= 1000;
//----- Создание таймера - индивидуальный для каждого объекта ------------------
//----- Для начала периода отчёта времени работы данной задачи -----------------
 FLastOSTickCount:= GetTickCount(); // "стаоым" способом
 FStopWatch := TStopwatch.StartNew; // новым способом (появился в 10-й версии

//--- Назначаем в визуальном компоненте номер строки для вывода информации о процессе
//--- выполнения задачи равной номеру самой задачи в списке задач
 self.FLineIndex_ForView:= TaskTemplateId;

// if ExchangeType = etClientServerTCP then
//  begin
   FClientUDP:= TIdUDPClient.Create(nil);
   FClientUDP.Host:= serverUDPName;
   FClientUDP.Port:= ServerUDPPort;
//  end;

//--- присвоим состояние задачи, которое пришло на входе данной подпрограммы
//--- созданим TEvent для варианта получения отчёта от задачи по событию
//--- в данном приложении реализован ещё метод через таймер основного потока
//--- который опрашивает все работающие потоки в цикое опроса по таймеру

 case BeginState of
  tsActive:
   tmpBool:= true;
  else
   tmpBool:= false;
 end;
 FPauseEvent:= TEvent.Create(nil, true, tmpBool, 'ThreadPauseEvent_Task_' + IntToStr(FTaskTemplateId));

//--- присвоим состояние задачи, которое пришло на входе данной подпрограммы
TaskState:= BeginState;

end;

destructor TTaskItem.Destroy();
begin
//if Assigned(self.FTaskSource) then
// self.FTaskSource.Free;
 inherited;
end;


procedure TTaskItem.OnTerminate(Sender: TObject);
begin
if Assigned(self) then
 FreeAndNil(self);
end;


function TTaskItem.IsTerminated: boolean;
begin
  Result:= self.Terminated;
end;


procedure TTaskItem.Execute;
var
  tmpProc: TTaskProcedure;
  tmpWord: word;
//  tmpTaskItem: TTaskItem;
begin

// tmpTaskItem:= self;
// tmpTaskItem.SetTaskState(tsActive);
 SetTaskState(tsActive);
 FTaskStepCount:= 0;  // обнулим счётчик условных циклов текущей задачи (потока)
 FStopWatch.StartNew; // Начинаем отсчёт времени текущей задачи (потока)
 // задержка необходима для исключения возможности "слишком раннего обращения"
 // к методам или полям обхекта, который ещй не создался полностью.
 sleep(100);
 repeat

  FTaskProcedure(self); // вызов алгоритма задачи, заложенного в шаблоне задачи

  try
    CriticalSection.Enter;
// curTaskItem:= self;

    OutInfo_ForViewing.hWndViewObject:= self.FHandleWinForView;
    OutInfo_ForViewing.IndexInViewComponent:= self.FLineIndex_ForView;
    OutInfo_ForViewing.TextForViewComponent:= self.InfoFromTask;

      case ExchangeType of
     etSynchronize:
      Synchronize(SendReportToMainProcess);
     etClientServerUDP:
      SendReportToMainProcess;
    end;

//  self.FCurrentTaskItem.TaskExecProcedure;
//    SendReportToMainProcess(curTaskItem);
//-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//    TThread(TaskItem.ThreadItem).Synchronize(TaskItem.ThreadItem, SendReportToMainProcess());
//    SendReportToMainProcess;

   finally
    CriticalSection.Leave;
   end;

   while (TaskState = tsPause) and (TaskState <> tsTerminate) do
   begin
    self.Suspended:= true; //--- Пережидаем паузу
   end;

(*
  if self.TaskState = tsPause then
   self.Suspend; //--- Для отработки (устарело) Пережидаем паузу
*)
  if self.TaskState = tsReportPause then
  begin
   self.SetTaskState(tsActive); //--- Если был отчёт, то выходим из состояния отчёта (для главного окна)
  end; // if

 until (self.TaskState = tsTerminate);

 //--- Прекращаеи выполнение задачи
 //--- Фиксируем общее время выполнения задачи
 FElapsedMillseconds:= FStopWatch.ElapsedMilliseconds;
// FTaskSource.StreamWriter.Close;
 FileList[StreamWriterNum].FStreamWriter.Flush;
 FileList[StreamWriterNum].FStreamWriter.Close;
 //--- Освобождение памяти не делаем, так как при создании поставили FreeOnTerminate
 TaskList[self.FTaskNum].Terminate;
 //--- Удаление задачи из списка объектов "задача" (информацию на компоненте отображения оставляем в окне просмотра...)
// TaskList[self.FTaskNum].Destroy;
 //--- Удаление задачи из списка "задач" (информацию на компоненте отображения оставляем в окне просмотра...)
(*
 try
   CriticalSection.Enter;
   OutInfo_ForViewing.hWndViewObject:= formMain.lbThreadList.Handle;
   OutInfo_ForViewing.IndexInViewComponent:= self.FLineIndex_ForView;
   Synchronize(DeleteTaskFromViewingList);

 finally
   CriticalSection.Leave;
 end;
*)
end;

procedure TTaskItem.SetTaskName(TaskItemName: string = '');
begin
 if TaskItemName = '' then
  FTaskName:= self.FTaskSource.GetName
 else
  FTaskName:= TaskItemName;
end;

function TTaskItem.GetTaskState(): TTaskState;
begin
   Result:= FTaskState;
end;

procedure TTaskItem.SetTaskSource(TaskSource: TTaskSource);
begin
 self.FTaskSource:= TaskSource;
end;

function TTaskItem.GetTaskSource(): TTaskSource;
begin
 Result:= FTaskSource;
end;

procedure TTaskItem.SetTaskNum(TaskNum: word);
begin
 FTaskNum:= TaskNum;
end;

procedure TTaskItem.SetTaskState(inTaskState: TTaskState);
begin
 if ((FTaskState = tsPause) or (FTaskState = tsTerminate)) and (inTaskState = tsReportPause) then exit;

 if FTaskState = inTaskState then exit;

 if inTaskState = tsActive then
  FPauseEvent.SetEvent; //--- Отключаем событие "Пауза для данного потока"

 FTaskState:= inTaskState;

 if FTaskState = tsPause then
  FPauseEvent.ResetEvent; //--- Включаем событие "Пауза для данного потока"

end;

procedure TTaskItem.SetHandleWinForView(WinForView: hWnd);
begin
 FHandleWinForView:= WinForView;
end;

procedure TTaskItem.SetPeriodReport(PeriodReport: TPeriodReport);
begin
// self.SetPeriodReport(PeriodReport);
SetPeriodReport(PeriodReport);
end;

function TTaskItem.GetPeriodReport: TPeriodReport;
begin
 Result:= self.FPeriodReport;
end;

procedure TTaskItem.thrSendInfoToView;
begin
// SendMessage(OutInfo_ForViewing.hWndViewObject, wm_data_update, 20, dword(PChar(OutInfo_ForViewing.TextForViewObject)));
end;

function TTaskItem.PrepareOutString(TaskNum: integer; sPersonThreadInfo: string): string;
var
  fTmp: single;
  iTmp: integer;
  cTmp: cardinal;
  sTmp: string;
begin
 TaskList[TaskNum].GetCPUUsage(stSystemTimes);
 fTmp:= (stSystemTimes.UserTime/stSystemTimes.KernelTime)*100;
 iTmp:= round(fTmp);
 sTmp:= GetTaskStateName(TaskList[TaskNum].TaskState);
 cTmp:= TaskList[TaskNum].ThreadID;
 Result:= sHeaderThreadInfo + IntToStr(TaskNum) +  ': ' + TaskList[TaskNum].TaskName
          + ', ' + sPersonThreadInfo
          + Format(' , TreadId: %6d | CPU usage(проц.): %f | сост. - %s', [cTmp, fTmp, sTmp]);
end;


procedure TTaskItem.SendReportToMainProcess;
begin
    OutInfo_ForViewing.TextForViewComponent:= AnsiString(PrepareOutString(self.FTaskNum, OutInfo_ForViewing.TextForViewComponent));

    case ExchangeType of
     etSynchronize:
     begin
      //--- После каждого цикла запускаем передачу информации о текущем положении дел в окно главной формы
      // OutInfo_ForViewing.TextForViewObject:= OutInfo_ForViewing.TextForViewObject +
      if formMain.memInfoTread <> nil then
       formMain.memInfoTread.Lines[OutInfo_ForViewing.IndexInViewComponent]:= OutInfo_ForViewing.TextForViewComponent;
     end;
     etClientServerUDP:
     begin
       try
        FClientUDP.Connect;
        OutInfo_ForViewing.TextForViewComponent:= format('#%d#', [OutInfo_ForViewing.IndexInViewComponent]) + OutInfo_ForViewing.TextForViewComponent;
        FClientUDP.Send(OutInfo_ForViewing.TextForViewComponent, IndyTextEncoding_UTF8);
       finally
        FClientUDP.Disconnect;
       end;
     end;

    end;

end;

procedure TTaskItem.DeleteTaskFromViewingList;
begin
//    formMain.lbThreadList.Items.Delete(self.FTaskNum);
end;

function TTaskItem.GetTaskStateName(inTaskState: TTaskState): string;
begin
 Result:= '';
 case TTaskState(ord(inTaskState)) of
   TTaskState(-1): Result:= 'Не определено';
   TTaskState(0):  Result:= 'Активен';
   TTaskState(1):  Result:= 'Остановлен';
   TTaskState(2):  Result:= 'Пауза';
   TTaskState(3):  Result:= 'Активен'; //--- В состоянии Паузы для отчёта - но это есть активное состояние!
 end;
end;

procedure TTaskItem.CheckReportTime(TaskItem: TTaskItem);
var
  tmpTickCount: cardinal;
begin
  if self.FTaskState = tsTerminate then exit;
  tmpTickCount:= GetTickCount();
  if (tmpTickCount - TaskItem.FLastOSTickCount) > TaskItem.FPeriodReport then
   if self.FTaskState <> tsPause then
    self.SetTaskState(tsReportPause);
end;

procedure TTaskItem.MarkAsDeleted;
begin
 self.FIsDeleted:= true;
end;

procedure TTaskItem.SetStreamWriter(TaskStreamWriter: word);
begin
  FSreamWriterNum:= TaskStreamWriter;
end;

//------------------------------------------------------------------------------
//---------- Данные для TTaskList ----------------------------------------------
//------------------------------------------------------------------------------
function TTaskList.GetItem(Index: integer): TTaskItem;
begin
 Result:= TTaskItem(inherited GetItem(Index));
end;

procedure TTaskList.SetItem(Index: integer; const Value: TTaskItem);
begin
 inherited SetItem(Index, Value);
end;

//------------------------------------------------------------------------------
//---------- Данные для TTaskSource4List ----------------------------------------------
//------------------------------------------------------------------------------
function TTaskSource4List.GetItem(Index: integer): TTaskSource4;
begin
 Result:= TTaskSource4(inherited GetItem(Index));
end;

procedure TTaskSource4List.SetItem(Index: integer; const Value: TTaskSource4);
begin
 inherited SetItem(Index, Value);
end;


//------------------------------------------------------------------------------
//------ Задачи для потоков ----------------------------------------------------
//------------------------------------------------------------------------------

 procedure Calc_NOP(TaskItemIndex: byte);
 begin
   //--- Заглушка (пустышка), например для "затыкания№, если что-то погло не так в консипукторе TaskItem
 end;

class procedure TTaskSource2.TaskProcedure(TaskItem: TTaskItem);
 //--- Calculate (Пи): вызов из библиотеки (.dll)
var
  tmpInt, tmpInt1: Integer;
  tmpStr: string;
  tmpCallingDLLProc: TCallingDLLProc;
 begin

//  tmpCallingDLLProc:= FCallingDLLProc;
  if @FCallingDLLProc = nil then
  begin
   TaskItem.InfoFromTask:= 'Пройден ' + IntToStr(TaskItem.FTaskStepCount) + ' усл.цикл, ' + Format('; Ошибка: Не найдена подпрограмма ( %s )в библиотеке ( %s )', [aTaskDllProcNameArray[TaskItem.FTaskTemplateId], DllFileName]);
   TaskItem.SetTaskState(tsTerminate);
   exit;
  end;

 // В библиотеке расположена подпрограмма:
//  Calc_Algorithm_Pi (tmpInt, fsResult, 100); // 1 - некий параметр (Int), например, для обратной связи при длительных расчётах
                                  // 2 - Файл, в который пишем результаты вычислений
                                  // 3 - максимальное время на данную задачу при циклическом вызове из потока (в миллисекундах)
// Начинаем отсчёт времени работы очередного цикла текущей задачи задачи
// зафиксируем текущее значение TaskItem.FStopWatch
  tmpInt1:= TaskItem.FStopWatch.ElapsedMilliseconds;

  repeat
   FCallingDLLProc(tmpInt, FileList[TaskItem.StreamWriterNum].FStreamWriter, TaskItem.FPeriodReport);
  until ((TaskItem.FStopWatch.ElapsedMilliseconds - tmpInt1) >= TaskItem.FPeriodReport)
        or (TaskItem.TaskState = TTaskState(tsTerminate)) or (TaskItem.TaskState = TTaskState(tsPause)) or (TaskItem.TaskState = TTaskState(tsReportPause));

  inc(TaskItem.FTaskStepCount); // зафиксируем завершение очередного условного цикла
  TaskItem.InfoFromTask:= 'Пройден ' + IntToStr(TaskItem.FTaskStepCount) + ' усл.цикл, ' + Format('"найдено": %d чисел ', [tmpInt]);

 end;


class procedure TTaskSource4.TaskProcedure(TaskItem: TTaskItem);
 //--- Прототип источника задачи для теста hh.ru: вызов из библиотеки (.dll)
var
  tmpInt, tmpInt1: Integer;
  tmpStr: string;
  tmpCallingDLLProc: TCallingDLLProc;
 begin

//  tmpCallingDLLProc:= FCallingDLLProc;
  if @FCallingDLLProc = nil then
  begin
   TaskItem.InfoFromTask:= 'Пройден ' + IntToStr(TaskItem.FTaskStepCount) + ' усл.цикл, ' + Format('; Ошибка: Не найдена подпрограмма ( %s )в библиотеке ( %s )', [aTaskDllProcNameArray[TaskItem.FTaskTemplateId], DllFileName]);
   TaskItem.SetTaskState(tsTerminate);
   exit;
  end;

 // В библиотеке расположена подпрограмма:
//  Calc_Algorithm_Pi (tmpInt, fsResult, 100); // 1 - некий параметр (Int), например, для обратной связи при длительных расчётах
                                  // 2 - Файл, в который пишем результаты вычислений
                                  // 3 - максимальное время на данную задачу при циклическом вызове из потока (в миллисекундах)
// Начинаем отсчёт времени работы очередного цикла текущей задачи задачи
// зафиксируем текущее значение TaskItem.FStopWatch
  tmpInt1:= TaskItem.FStopWatch.ElapsedMilliseconds;

  repeat
   FCallingDLLProc(tmpInt, FileList[TaskItem.StreamWriterNum].FStreamWriter, TaskItem.FPeriodReport);
  until ((TaskItem.FStopWatch.ElapsedMilliseconds - tmpInt1) >= TaskItem.FPeriodReport)
        or (TaskItem.TaskState = TTaskState(tsTerminate)) or (TaskItem.TaskState = TTaskState(tsPause)) or (TaskItem.TaskState = TTaskState(tsReportPause));

  inc(TaskItem.FTaskStepCount); // зафиксируем завершение очередного условного цикла
  TaskItem.InfoFromTask:= 'Пройден ' + IntToStr(TaskItem.FTaskStepCount) + ' усл.цикл, ' + Format('"найдено": %d чисел ', [tmpInt]);

 end;



function TTaskItem.InitTaskSource(SelectedLibraryNum, SelectedTaskNum: byte; TaskItemNum: word): Pointer;
var
 tmpPointer: Pointer;
 tmpProc: TTaskProcedure;
begin
 case SelectedTaskNum of
  0:
  begin
  end;
  1:
  begin
   Result:= TTaskSource2.Create(TaskItemNum);
   TaskList[TaskItemNum].FTaskProcedure:= TTaskSource2(Result).TaskProcedure;
  end;
  2:
  begin
  end;
  3:  // Задачи для тестового примера от hh.ru
  begin
   Result:= TTaskSource4.Create(TaskItemNum);
   TaskList[TaskItemNum].FTaskProcedure:= TTaskSource4(Result).TaskProcedure;
   // LibraryTaskInfoList[tmpLibraryNum].TaskDllProcName
  end;
  else Result:= nil;
 end;
// TTaskSource(Result).SetTaskItem(TaskList[TaskItemNum]);
 TaskList[TaskItemNum].SetTaskSource(Result);
end;


//--- Подпрограммы вне классов
//procedure SendReportToMainProcess(TaskItem: TTaskItem);

initialization
 TaskList:= TTaskList.Create();
 FileList:= TFileList.Create();
 CriticalSection:= TCriticalSection.Create();

finalization

// if TaskList <> nil then TaskList.Destroy;
// if FileList <> nil then FileList.Destroy;
// if CriticalSection <> nil then CriticalSection.Free;

end.
