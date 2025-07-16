unit unTasks;

interface
uses
  Winapi.Windows, Winapi.Messages, Vcl.Forms, System.Classes, System.SysUtils, System.SyncObjs, System.Diagnostics, Vcl.ExtCtrls, System.Contnrs,
  unConst, unVariables, IdUDPClient, Dialogs, IOUtils;

type

//------------------------------------------------------------------------------
  TTaskState = (tsNotDefined = -1 {одно из применений - при запуске, до момента полного создания всех объектов задачи},
                tsActive = 0, tsTerminate = 1, tsPause = 2, tsReportPause = 3);

//------------------------------------------------------------------------------
//  TProcedure = reference to procedure;
{$IFDEF MSWINDOWS}
//    TTaskOSPriority = (tpIdle, tpLowest, tpLower, tpNormal, tpHigher, tpHighest,
//    tpTimeCritical) platform;
//------------------------------------------------------------------------------
  TTaskOSPriority = array of TThreadPriority;
{$ENDIF MSWINDOWS}
//------------------------------------------------------------------------------
  TPeriodReport = 1..5000; // указывается в мс

//------------------------------------------------------------------------------
  TTaskItem = class;
//  TTaskProcedure = reference to procedure (TaskItem: TTaskItem); // of object;
//------------------------------------------------------------------------------
  TTaskProcedure = procedure (TaskLibraryIndex: word) of object;
  TTaskCore = class;

//------------------------------------------------------------------------------
  TTaskItem = class (TThread)
   private
    FTaskName: string;
    FTaskNumInList: word;
    FTaskSource: ITaskSource;
    FTaskCore: TTaskCore;
    FTaskState: TTaskState;
    FPauseEvent: TEvent;
    FPeriodReport: TPeriodReport;
//    FIsReportNeed: boolean;
    FLastOSTickCount: cardinal;
    FStopWatch: TStopwatch;
    FElapsedMillseconds: Int64;
//    FTimerCycleCount: Int64;
    FCycleTimeValue: word; // продолжительность одного расчётного цикла в мс (по умолчанию 1000 мс)
    FCoreUtilization: byte;
{$IFDEF MSWINDOWS}
    FTaskOSPriority: TTaskOSPriority;
{$ENDIF MSWINDOWS}
    FInfoUpdatePeriod: TPeriodReport;

    FHandleWinForView: hWnd;
    FInfoFromTask: String;
    FIsDeleted: boolean;
    FClientUDP: TIdUDPClient;
    procedure thrSendInfoToView(inputString: string);
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
    constructor Create(TaskLibraryId, TaskTemplateId: word; inputBeginState: TTaskState); overload;
    destructor Destroy(); overload;
    procedure OnTerminate(Sender: TObject); overload;
    procedure SetTaskNum(TaskNum: word);
    procedure SetTaskState(inTaskState: TTaskState);
    procedure SetPeriodReport(PeriodReport: TPeriodReport);
    procedure SetHandleWinForView(WinForView: hWnd);
    procedure SetTaskSource(intrfTaskSource: ITaskSource);
    procedure SetTaskName(TaskItemName: string = '');
    procedure SetStreamWriter(TaskStreamWriter: word);
    procedure SendReportToMainProcess;
    procedure DeleteTaskFromViewingList;
    procedure CheckReportTime(TaskItem: TTaskItem);
    procedure MarkAsDeleted;
    function GetTaskSource(): ITaskSource;
    function GetPeriodReport: TPeriodReport;
    function GetTaskState(): TTaskState;
    function PrepareOutString(inTaskNumInList: word; inThreadInfo: string): string;
    function GetTaskStateName(inTaskState: TTaskState): string;
//    function InitTaskSource(SelectedLibraryNum, SelectedTaskNum: byte; TaskItemNum: word): Pointer;
    function IsTerminated: boolean;

    property TaskName: string read FTaskName;
    property TaskNum: word read FTaskNumInList;
{$IFDEF MSWINDOWS}
    property TaskSource: ITaskSource read FTaskSource write SetTaskSource;
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

//------------------------------------------------------------------------------
//--- Вспомогательный объект для TaskItem - обёртка для TaskSource из библиотеки
//--- его роль - это предоставление функционала управления потоком, который ----
//--- будет содержать только вызов кода задачи из библиотеки -------------------
//------------------------------------------------------------------------------
  TTaskCore = class (TTaskItem)
   private
    FTaskNumInList: word;
    FTaskSource: ITaskSource;
    FTaskItemOwner: TTaskItem;
    FLastOSTickCount: cardinal;
    FStopWatch: TStopwatch;
    FElapsedMillseconds: Int64;
   protected
//    FTaskProcedure: TTaskProcedure;
    procedure Execute; override;
   public
    constructor Create(TaskItemOwner: TTaskItem); overload;
    destructor Destroy(); overload;
    procedure OnTerminate(Sender: TObject);
    property TaskSource: ITaskSource read FTaskSource write SetTaskSource;
  published
  end;
//------------------------------------------------------------------------------





//------------------------------------------------------------------------------
 var
    TaskList: TTaskList;

    CriticalSection: TCriticalSection;
    OutInfo_ForViewing: TOutInfo_ForViewing;
    ReportingTaskItemNum: integer;
    stSystemTimes: TThread.TSystemTimes;
    curTaskItem: TTaskItem;

//------------------------------------------------------------------------------


// {$L unThread.pas}

//function InitTaskSource(SelectedTaskNum: byte; TaskItemNum: word): Pointer;
//procedure SendReportToMainProcess(TaskItem: TTaskItem);
//function PrepareOutString(TaskNum: integer): string;


implementation
uses unMain, unUtilCommon, IdGlobal, unUtils;

//------------------------------------------------------------------------------
//---------- Данные для TTaskCore ----------------------------------------------
//------------------------------------------------------------------------------
constructor TTaskCore.Create(TaskItemOwner: TTaskItem);
begin
 inherited  Create(true); //false); //--- отложим запуск потока до AfterConstraction
 self.FTaskItemOwner:= TaskItemOwner;
 FreeOnTerminate:= false; //--- После "добывания из потока" результирующих данных удалим его вручную
 Priority:= tpNormal;

end;

destructor TTaskCore.Destroy();
begin

end;

procedure TTaskCore.Execute;
begin
  self.FTaskItemOwner.FTaskSource.TaskProcedure(self.FTaskItemOwner.FTaskLibraryId); // FTaskProcedure(self.TaskNum); // вызов алгоритма задачи, заложенного в шаблоне задачи
end;

procedure TTaskCore.OnTerminate(Sender: TObject);
begin
if Assigned(self) then
// self.FTaskItemOwner.OnTerminate(Sender);
end;


//------------------------------------------------------------------------------
//---------- Данные для TTaskItem ----------------------------------------------
//------------------------------------------------------------------------------
constructor TTaskItem.Create(TaskLibraryId, TaskTemplateId: word; inputBeginState: TTaskState);
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
 FTaskName:= LibraryList[TaskLibraryId].TaskTemplateName[TaskTemplateId];
 FreeOnTerminate:= false; //true;
 Priority:= tpLower; //tpNormal; этот поток только запускает и крутится в цикле
// self.FDSiTimer.Interval:= TaskList[TaskItemNum].GetPeriodReport;
 FPeriodReport:= 2000; //--- миллисекунд
 FCycleTimeValue:= 1000; //--- миллисекунд Время делится на 1/4 выполнение Задачи + 3/4 на отчёт + простой
//----- Для начала периода отчёта времени работы данной задачи -----------------
 FLastOSTickCount:= GetTickCount(); // "стаhым" способом
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

 case inputBeginState of
  tsActive:
   tmpBool:= true;
  else
   tmpBool:= false;
 end;
 FPauseEvent:= TEvent.Create(nil, true, tmpBool, 'ThreadPauseEvent_Task_' + IntToStr(FTaskTemplateId));

//--- Создаём новый объект "Ядро исходника Задачи" - для получения функционала управления потоком
//--- Делаем это в главном модуле, так как этот объект "продолжение" TaskItem, который становится аналогом
//--- "callback pump" для TaskSource, который создаётся в библиотеке
 self.FTaskCore:= TTaskCore.Create(self);

//--- присвоим состояние задачи, которое пришло на входе данной подпрограммы
TaskState:= inputBeginState;

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
// FreeAndNil(self);
end;


function TTaskItem.IsTerminated: boolean;
begin
  Result:= self.Terminated;
end;


procedure TTaskItem.Execute;
var
  tmpProc: TTaskProcedure;
  tmpWord: word;
begin

 SetTaskState(tsActive);
 FStopWatch.StartNew; // Начинаем отсчёт времени текущей задачи (потока)

 // задержка необходима для исключения возможности "слишком раннего обращения"
 // к методам или полям обхекта, который ещй не создался полностью.
// sleep(100);

//--- Сначала задача из библиотеки запускалась здесь
//  self.FTaskSource.TaskProcedure(self.TaskNum); // FTaskProcedure(self.TaskNum); // вызов алгоритма задачи, заложенного в шаблоне задачи
self.FTaskCore.Start;

repeat
  if self.FTaskCore.Suspended then
//    self.FTaskCore.Resume;
    self.FTaskCore.SetTaskState(tsPause);

  //--- выдаём квант времени на выполнение Задачи
  sleep(round(FCycleTimeValue*0.5)); // 250мс - на выполнение Задачи в библиотеке
                             // 750 - время выполнениея кода (ниже) и sleep
                             // это эмуляция квантованного предоставления времени выполнения потока

                             //--- Задача из библиотеки уже выполняется или уже завершилась...
  //--- Проверяем не завершилась ли Задача во время последнего кванта времени, если не завершилась, то приоставнавливаем.
  if self.FTaskCore.Terminated then
    self.SetTaskState(tsTerminate)    //--- Если Задача завершилась, то переводим ItemState в завершённое состояние
  else
    if Assigned(self.FTaskCore) then
//      self.FTaskCore.Suspended:= true
    else
     showmessage('self.FTaskCore.Suspend - не существует');

//  self.SetTaskState(tsReportPause);   //--- Согласно первого алгоритма (синхроггаый запрос на отчёт)
                                      //--- в этой точке должно быть состояние Пауза для отчёта.
                                      //--- оэтому пока оставлено для совместимости. Будет удалено в последствие.
//---
//--- Теперь читаем промежуточные результаты от задачи и показываем в визуальных компонентах главного потока
  try
    CriticalSection.Enter;
// curTaskItem:= self;

    OutInfo_ForViewing.hWndViewObject:= self.FHandleWinForView;
    OutInfo_ForViewing.IndexInViewComponent:= self.FLineIndex_ForView;
    OutInfo_ForViewing.TextForViewComponent:= self.InfoFromTask;

      case ModulsExchangeType of
     etMessage_WMCopyData:
      SendReportToMainProcess;  //Synchronize(SendReportToMainProcess);
     etClientServerUDP:
      SendReportToMainProcess;
    end;
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

  sleep(round(FCycleTimeValue*0.75)); // 750 - время выполнениея кода (ниже) и sleep
                                     // это эмуляция квантованного предоставления времени выполнения потока
 until (self.TaskState = tsTerminate);

 //--- Прекращаеи выполнение задачи
 //--- Фиксируем общее время выполнения задачи
 FElapsedMillseconds:= FStopWatch.ElapsedMilliseconds;
 //--- Освобождение памяти не делаем, так как при создании поставили FreeOnTerminate
 TaskList[self.FTaskNumInList].Terminate;
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
end; //--- TTaskItem.Execute;

procedure TTaskItem.SetTaskName(TaskItemName: string = '');
begin
 if TaskItemName = '' then
//  FTaskName:= self.FTaskSource.GetName
 else
  FTaskName:= TaskItemName;
end;

function TTaskItem.GetTaskState(): TTaskState;
begin
   Result:= FTaskState;
end;

procedure TTaskItem.SetTaskSource(intrfTaskSource: ITaskSource);
begin
 self.FTaskSource:= intrfTaskSource;
end;

function TTaskItem.GetTaskSource(): ITaskSource;
begin
 Result:= FTaskSource;
end;

procedure TTaskItem.SetTaskNum(TaskNum: word);
begin
 FTaskNumInList:= TaskNum;
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
  SetPeriodReport(PeriodReport);
end;

function TTaskItem.GetPeriodReport: TPeriodReport;
begin
 Result:= self.FPeriodReport;
end;

procedure TTaskItem.thrSendInfoToView(inputString: string);
var
  cdsData: TCopyDataStruct;
//  tmpString: string;
begin
  //Устанавливаем наш тип команды
  cdsData.dwData := CMD_SetMemoLine;
  cdsData.cbData := Length(PChar(inputString)) * sizeof(Char) + 1;
  //Выделяем память буфера для структуры данных
  GetMem(cdsData.lpData, cdsData.cbData);
  try
    StrPCopy(cdsData.lpData, PWChar(inputString));

//    tmpString:= PChar(cdsData.lpData);
    //Отсылаем сообщение в окно главного модуля
    SendMessage(FindWindow(nil, PWChar(formMain.Caption)),
                  WM_COPYDATA, Handle, Integer(@cdsData));
  finally
    //Высвобождаем буфер
    FreeMem(cdsData.lpData, cdsData.cbData);
  end;
end;

function TTaskItem.PrepareOutString(inTaskNumInList: word; inThreadInfo: string): string;
var
  tmpSingle: single;
  tmpInt: integer;
  tmpCardinal: cardinal;
  tmpString: string;
begin
{
 TaskList[TaskNum].GetCPUUsage(stSystemTimes);
 tmpSingle:= (stSystemTimes.UserTime/stSystemTimes.KernelTime)*100;
 tmpInt:= round(tmpSingle);
 tmpString:= GetTaskStateName(TaskList[TaskNum].TaskState);
 tmpCardinal:= TaskList[TaskNum].ThreadID;
 Result:= sHeaderThreadInfo + IntToStr(TaskNum) +  ': ' + TaskList[TaskNum].TaskName
          + ', ' + inThreadInfo
          + Format(' , TreadId: %6d | CPU usage(проц.): %f | сост. - %s', [tmpCardinal, tmpSingle, tmpString]);

  sThreadInfoForView = sHeaderThreadInfo + ' %4d : %s, %s TreadId: %4d | CPU usage(проц.): %f | сост. - %s';
}
 tmpInt:= TaskList[TaskNum].FTaskSource.Task1_Result.dwEqualsCount;

 tmpString:= GetTaskStateName(TaskList[TaskNum].TaskState);
 Result:= format(sThreadInfoForView,
                                    [inTaskNumInList,
                                     TaskList[TaskNum].TaskName,
                                     inThreadInfo,
                                     TaskList[TaskNum].ThreadID,
                                     (stSystemTimes.UserTime/(stSystemTimes.KernelTime + 1))*100, //деление на 0...
                                     tmpInt, //TaskList[TaskNum].FTaskSource.Task1_Result.dwEqualsCount,
                                     tmpString]); //GetTaskStateName(TaskList[TaskNum].TaskState)]);

end;


procedure TTaskItem.SendReportToMainProcess;
begin
    OutInfo_ForViewing.TextForViewComponent:= AnsiString(PrepareOutString(self.FTaskNumInList, OutInfo_ForViewing.TextForViewComponent));
    OutInfo_ForViewing.TextForViewComponent:= format(sDelimiterNumTask + '%d' + sDelimiterNumTask,
                                                      [OutInfo_ForViewing.IndexInViewComponent]) + OutInfo_ForViewing.TextForViewComponent;

    case ModulsExchangeType of
     etMessage_WMCopyData:
     begin
      //--- После каждого цикла запускаем передачу информации в окно главной формы
      // OutInfo_ForViewing.TextForViewObject:= OutInfo_ForViewing.TextForViewObject +
      if formMain.memInfoTread <> nil then
       self.thrSendInfoToView(OutInfo_ForViewing.TextForViewComponent);
     end;

     etClientServerUDP:
     begin
       try
        FClientUDP.Connect;
//        OutInfo_ForViewing.TextForViewComponent:= format('#%d#', [OutInfo_ForViewing.IndexInViewComponent]) + OutInfo_ForViewing.TextForViewComponent;
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
   TTaskState(3):  Result:= 'Активен/Отчёт'; //--- В состоянии Паузы для отчёта - но это есть активное состояние!
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

//--- Подпрограммы вне классов
//procedure SendReportToMainProcess(TaskItem: TTaskItem);

initialization
 TaskList:= TTaskList.Create();
 FileList:= TFileList.Create();
 CriticalSection:= TCriticalSection.Create();

finalization

// if Assigned(TaskList) then TaskList.Free;
// if Assigned(FileList) then FileList.Free;
// if Assigned(CriticalSection) then CriticalSection.Free;

end.
