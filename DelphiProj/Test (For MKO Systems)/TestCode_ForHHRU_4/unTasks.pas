unit unTasks;

interface
uses
  Winapi.Windows, Winapi.Messages, Vcl.Forms, System.Classes, System.SysUtils, System.SyncObjs, System.Diagnostics, Vcl.ExtCtrls, System.Contnrs,
  IdUDPClient, Dialogs, IOUtils, ActiveX, Vcl.AxCtrls,
  unConst, unVariables;

type

//------------------------------------------------------------------------------
  TTaskState = (tsNotDefined = -1,
                tsActive = 0, tsTerminate = 1, tsPause = 2, tsDone = 3, tsAbortedDone = 4);
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
  TTaskProcedure = procedure of object;
  TTaskCore = class;

//------------------------------------------------------------------------------
  TTaskItem = class (TThread)
   private
    FTaskName: WideString;
    FTaskNum: word;
    FTaskSource: ITaskSource;
    FTaskCore: TTaskCore;
    FTaskCoreState: TTaskState;
    FTaskState: TTaskState;
    FPauseEvent: TEvent;
    FPeriodReport: TPeriodReport;
    FBeginTickCount: cardinal;
    FEndTickCount: cardinal;
    FStringStream: TStringStream;
    FStringStream_LastPos: DWORD;
    FStream: TStream;
    FStream_Log: TStream;
    FOLEStream: IStream;  //--- Поток в "COM-формате" принимаем посредством TStreamAdapter
    FStringStream_Log: TStringStream;
    FStringStream_Log_LastPos: DWORD;
    FOLEStream_Log: IStream;  //--- Поток в "COM-формате" принимаем посредством TStreamAdapter
    FStream_Core_Log: TStream;
    FStringStream_Core_Log: TStringStream;
    FStringStream_Core_Log_LastPos: DWORD;
    FCycleTimeValue: word; // продолжительность одного расчётного цикла в мс (по умолчанию 1000 мс)
    FCoreUtilization: byte;
{$IFDEF MSWINDOWS}
    FTaskOSPriority: TTaskOSPriority;
{$ENDIF MSWINDOWS}

    FHandleWinForView: hWnd;
    FInfo_ForViewing: TInfo_ForViewing;
    FInfoFromTask: WideString;
    FIsDeleted: boolean;
    FClientUDP: TIdUDPClient;
//    procedure thrSendInfoToView(inputString: WideString);
   protected
    FLibraryId: DWORD;
    FTaskTemplateId: word;
    FLineIndex_ForView: integer;
    FSreamWriterNum: word;
    procedure Execute; override;
   public
    constructor Create(TaskLibraryId, TaskTemplateId: word; inputBeginState: TTaskState); overload;
    procedure OnTerminate(Sender: TObject); overload;
    procedure SetTaskNum(TaskNum: word);
    procedure SetTaskState(inTaskState: TTaskState);
    procedure SetTaskCoreState(inTaskCoreState: TTaskState);
    procedure SetPeriodReport(PeriodReport: TPeriodReport);
    procedure SetHandleWinForView(WinForView: hWnd);
    procedure SetTaskSource(intrfTaskSource: ITaskSource);
    procedure SetTaskName(TaskItemName: WideString = '');
    procedure SetStreamWriter(TaskStreamWriter: word);
    procedure SendReportToMainProcess;
    procedure MarkAsDeleted;
    procedure SetInfo_ForViewing(var inputInfo_ForViewing: TInfo_ForViewing);
    function GetTaskItem(): TTaskItem;
    function GetTaskSource(): ITaskSource;
    function GetPeriodReport: TPeriodReport;
    function GetTaskState(): TTaskState;
    function GetTaskStateName(inTaskState: TTaskState): WideString;
    function IsTerminated: boolean;
    function GetInfo_ForViewing: TInfo_ForViewing;


    property LibraryId: DWORD read FLibraryId;
    property TaskName: WideString read FTaskName;
    property TaskNum: word read FTaskNum;
{$IFDEF MSWINDOWS}
    property TaskSource: ITaskSource read FTaskSource write SetTaskSource;
    property TaskCore: TTaskCore read FTaskCore write FTaskCore;
    property TaskOSPriority: TTaskOSPriority read FTaskOSPriority write FTaskOSPriority;
    property TaskState: TTaskState read FTaskState write SetTaskState;
    property TaskCoreState: TTaskState read FTaskCoreState write SetTaskCoreState;
    property CoreUtilization: byte read FCoreUtilization;

{$ENDIF MSWINDOWS}

    property PeriodReport: TPeriodReport read FPeriodReport;
    property LineIndex_ForView: integer read FLineIndex_ForView write FLineIndex_ForView;
    property HandleWinForView: hWnd read FHandleWinForView write SetHandleWinForView;
    property InfoFromTask: WideString read FInfoFromTask write FInfoFromTask;
    property StreamWriterNum: word read FSreamWriterNum;

    property Stream: TStream read FStream write FStream;
    property StringStream: TStringStream read FStringStream write FStringStream;
    property StringStream_LastPos: DWORD read FStringStream_LastPos write FStringStream_LastPos;

    property Stream_Log: TStream read FStream_Log write FStream_Log;
    property StringStream_Log: TStringStream read FStringStream_Log write FStringStream_Log;
    property StringStream_Log_LastPos: DWORD read FStringStream_Log_LastPos write FStringStream_Log_LastPos;
    property Stream_Core_Log: TStream read FStream_Core_Log write FStream_Core_Log;
    property StringStream_Core_Log: TStringStream read FStringStream_Core_Log write FStringStream_Core_Log;
    property StringStream_Core_Log_LastPos: DWORD read FStringStream_Core_Log_LastPos write FStringStream_Core_Log_LastPos;
    property Info_ForViewing: TInfo_ForViewing read GetInfo_ForViewing;
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
    FTaskNum: word;
    FTaskSource: ITaskSource;
    FTaskItemOwner: TTaskItem;
   protected
    FLibraryId: DWORD;
    FTaskTemplateId: word;
    FTaskProcedure: TTaskProcedure;
    FStream_Log: TStream;
    FTaskCoreStream: IStream;  //--- Поток в "COM-формате" принимаем посредством TStreamAdapter
    FStringStream_Log: TStringStream;
    FStringStream_Log_LastPos: DWORD;
    FTaskCoreStream_Log: IStream;  //--- Поток в "COM-формате" принимаем посредством TStreamAdapter
    procedure Execute; override;
   public
    constructor Create(); overload;
    procedure DoTerminate; overload;
    procedure SetTaskSource(intrfTaskSource: ITaskSource);
    property TaskSource: ITaskSource read FTaskSource write SetTaskSource;
    property LibraryId: DWORD read FLibraryId write FLibraryId;
    property TaskTemplateId: word read FTaskTemplateId write FTaskTemplateId;
    property TaskItemOwner: TTaskItem read FTaskItemOwner write FTaskItemOwner;

    property Stream_Log: TStream read FStream_Log write FStream_Log;
    property TaskCoreStream_Log: IStream read FTaskCoreStream_Log write FTaskCoreStream_Log;
    property StringStream_Log: TStringStream read FStringStream_Log write FStringStream_Log;
    property StringStream_Log_LastPos: DWORD read FStringStream_Log_LastPos write FStringStream_Log_LastPos;

  published
  end;
//------------------------------------------------------------------------------





//------------------------------------------------------------------------------
 var
    TaskList: TTaskList;

    ReportingTaskItemNum: integer;
    stSystemTimes: TThread.TSystemTimes;

//------------------------------------------------------------------------------


// {$L unThread.pas}

//function InitTaskSource(SelectedTaskNum: byte; TaskItemNum: word): Pointer;
//procedure SendReportToMainProcess(TaskItem: TTaskItem);
//function PrepareOutString(TaskNum: integer): WideString;


implementation
uses unMain, unUtilCommon, IdGlobal, unUtils;

//------------------------------------------------------------------------------
//---------- Данные для TTaskCore ----------------------------------------------
//------------------------------------------------------------------------------
constructor TTaskCore.Create();
begin
 inherited  Create(true); //--- true = отложим запуск потока (управляет TaskItem)
 FreeOnTerminate:= false; //--- false - управляет владелец - TaskItem (например, нелбходимо для повтора задачи на этом же потоке)

//--- Создание потока для передачи информации для журнала в "управляющий поток" - TaskItem
//--- Запись в поток "начальных данных" (наименование, номер)
  FStringStream_Log:= TStringStream.Create('', TEncoding.ANSI);
  self.FTaskCoreStream_Log:= TStreamAdapter.Create(FStringStream_Log, soReference);

// DecodeStream(StringStream_Log, StringStream_Log);

end;

//------------------------------------------------------------------------------
procedure TTaskCore.SetTaskSource(intrfTaskSource: ITaskSource);
begin
 self.FTaskSource:= intrfTaskSource;
end;

//------------------------------------------------------------------------------
procedure TTaskCore.Execute;
var
  tmpObject: TObject;
  tmpPAnsiChar: PAnsiChar;
  tmpWideString: WideString;
  tmpCardinal: cardinal;
begin
try
 //--- При первом (относительно создания TaskItem) входе всегда - tsActive
 repeat                                         //--- после прохода первого цикла станет tsDone и заходить на выполнение
                                                //--- внутрь If не будет, пока владелец TaskItem не станет tsActive или tsTerminate

  if (not ((self.FTaskItemOwner.TaskState in [tsDone, tsAbortedDone])))
      and (not (self.TaskItemOwner.TaskState = tsPause))
      and (not (self.TaskItemOwner.TaskState = tsTerminate)) then
   begin

    try
     tmpCardinal:= self.ThreadID;
     FTaskSource.TaskProcedure; //--- Индекс задачи уже передан в процессе создания TaskSource при создании задачи
     if (self.FTaskItemOwner.TaskState = tsActive) and (not self.FTaskSource.AbortExecution) then //--- Если вышли сюда из исходника задачи, то это либо полное выполнение,
       self.FTaskItemOwner.TaskState:= tsDone         //--- либо мягкое прерывание (через установку флага FAbortExecution)
     else                                             //--- при установке флага состояние Task было бы tsTerminate
     begin
//--- Так как задача прервана (остановлена), то необходимо вернуть в исходное состояние
//--- флаг немедленного прерывания задачи
      self.FTaskSource.AbortExecution:= false;
     end;

    except
     tmpObject:= ExceptObject;
     tmpWideString:= Exception(tmpObject).Message;
//--- Если исключение вызвано естественными причинами (не экстренное прерывание работы), то статус был Активен
//--- поэтому устанавливаем Прервано
     self.FTaskItemOwner.TaskState:= tsTerminate;
     self.FStringStream_Log.WriteString(Exception(tmpObject).ClassName + ', E.Message = ' + tmpWideString + '(TTaskCore.Execute, unTasks)');
     PostMessage(FInfo_ForViewing.hMemoLogInfo_2, WM_Data_Update, CMD_SetMemoStreamUpd, 0);
    end;
//--- Фиксируем общее время выполнения задачи
    self.FTaskItemOwner.FEndTickCount:= GetTickCount();
   end
   else
   begin
//    if self.TaskState = tsTerminate then
//     self.FTaskItemOwner.TaskCoreState:= self.TaskState;
    sleep(iTaskPeriodReport);
   end;
   tmpCardinal:= self.ThreadID;
 until (self.TaskState = tsTerminate) and (self.FTaskItemOwner.TaskState = tsTerminate);

finally
//--- Сообщим родительскому TaskItem о завершении
 self.DoTerminate; 
end;

end;
//------------------------------------------------------------------------------

procedure TTaskCore.DoTerminate;
var
  tmpString: WideString;
  tmpE: Exception;
  tmpExcept: TObject;
begin
 inherited;
try
 try
  self.FTaskItemOwner.TaskCoreState:= tsTerminate;
 except
  if Assigned(tmpE) then
   begin
    FStringStream_Log.WriteString(tmpE.ClassName +
                                    ', E.Message = ' +
                                    tmpE.Message +
                                    '(TTaskCore.DoTerminate, unTasks)');
    PostMessage(FInfo_ForViewing.hMemoLogInfo_2, WM_Data_Update, CMD_SetMemoStreamUpd, 0);

   end;
   raise Exception.Create(PAnsiChar(tmpString));
 end;
finally
  tmpExcept:= TThread(self).FatalException;
  if Assigned(tmpExcept) then
  begin
    // Thread terminated due to an exception
    if tmpExcept is Exception then
     FStringStream_Log.WriteString(Exception(tmpExcept).ClassName +
                                     ', E.Message = ' +
                                     Exception(tmpExcept).Message +
                                     '(TTaskCore.DoTerminate, unTasks)');
     PostMessage(FInfo_ForViewing.hMemoLogInfo_2, WM_Data_Update, CMD_SetMemoStreamUpd, 0);
  end;

 self.FTaskItemOwner:= nil;
 self.FTaskSource:= nil;
//--- Записать в журнал отчёт о завершении данной задачи (потока)
 FStringStream_Log.WriteString(format(wsTaskCore_Terminated, [self.FTaskNum, self.ThreadID]));
 PostMessage(FInfo_ForViewing.hMemoLogInfo_2, WM_Data_Update, CMD_SetMemoStreamUpd, 0);
end;

end;


//------------------------------------------------------------------------------
//---------- Данные для TTaskItem ----------------------------------------------
//------------------------------------------------------------------------------
constructor TTaskItem.Create(TaskLibraryId, TaskTemplateId: word; inputBeginState: TTaskState);
var
  tmpWord: word;
  tmpBool: boolean;
  Stream: TStream;
begin
try
 //--- Установим начальное состояние задачи в tsNotDefined
 //--- для исклбчениея её из процесса опроса состояния
 //--- пока все объекты не будут созданы и настоены
 TaskState:= tsNotDefined;
 inherited  Create(true);  //--- false = TaskItem запускаем всегда сразу! (это управляющая оболочка ядра Задачи)
 FreeOnTerminate:= false;  //--- TaskItem уничтожается при удалении задачи или при закрытии приложения

//----- Для начала периода отчёта времени работы данной задачи -----------------
 FBeginTickCount:= GetTickCount(); // "старым" способом
// FStopWatch := TStopwatch.StartNew; // новым способом (появился в 10-й версии

 //--- В этом конструкторе всё выдаём по умолчанию
 FLibraryId:= TaskLibraryId; // Порядковый номер библиотеки (по списку из листбокса)
 FTaskTemplateId:= TaskTemplateId; // Номер задачи-шаблона из массива aTaskNameArray
 FTaskName:= LibraryList[TaskLibraryId].TaskTemplateName[TaskTemplateId];

 Priority:= tpLower; //tpNormal; этот поток только запускает и крутится в цикле
// self.FDSiTimer.Interval:= TaskList[TaskItemNum].GetPeriodReport;
 FPeriodReport:= iTaskPeriodReport; //--- миллисекунд
 FCycleTimeValue:= iCycleTimeValue; //--- длительность цикла работы потока миллисекунд Время делится на 1/4 выполнение Задачи + 3/4 на отчёт + простой

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

//--- Создание потока для передачи информации для журнала в главный модуль
//--- Запись в поток "начальных данных" (наименование, номер)
//  tmpString:= format(wsResultStreamTitle, [FTaskLibraryIndex, FTaskLibraryIndex]) + wsCRLF;


//--- Начальное значение для потока (информация для журнала от задач)
 FStringStream_Log_LastPos:= 0;
//--- Начальное значение для потока (информация о результате выполнения от задач)
 FStringStream_LastPos:= 0;
//--- присвоим состояние задачи, которое пришло на входе данной подпрограммы
TaskState:= inputBeginState;

finally

end;

end;


//------------------------------------------------------------------------------
function TTaskItem.GetTaskItem(): TTaskItem;
begin
  Result:= self;
end;

//------------------------------------------------------------------------------
function TTaskItem.GetInfo_ForViewing(): TInfo_ForViewing;
begin
  Result:= self.FInfo_ForViewing;
end;

//------------------------------------------------------------------------------
procedure TTaskItem.SetInfo_ForViewing(var inputInfo_ForViewing: TInfo_ForViewing);
begin
  self.FInfo_ForViewing:= inputInfo_ForViewing;
end;


//------------------------------------------------------------------------------
procedure TTaskItem.OnTerminate(Sender: TObject);
var
  E: Exception;
  tmpExcept: TObject;
begin
try
 try
  if Assigned(self.FTaskCore) then
   FreeAndNil(self.FTaskCore);
//  FreeAndNil(self.FTaskSource);
  if Assigned(self.FPauseEvent) then
   FreeAndNil(self.FPauseEvent);
  if Assigned(self.FStream) then
   FreeAndNil(self.FStream);
  if Assigned(self.FStringStream) then
   FreeAndNil(self.FStringStream);
  if Assigned(self.FOLEStream) then
   FreeAndNil(self.FOLEStream);
  if Assigned(self.FOLEStream_Log) then
   FreeAndNil(self.FOLEStream_Log);
  if Assigned(self.FClientUDP) then
   FreeAndNil(self.FClientUDP);

 except
  if Assigned(E) then
  begin
   self.FStringStream_Log.WriteString(E.ClassName + ', E.Message = ' + E.Message + ' (TTaskItem.OnTerminate, unTasks)');
   PostMessage(FInfo_ForViewing.hMemoLogInfo_2, WM_Data_Update, CMD_SetMemoStreamUpd, 0);
  end;
  raise Exception.Create(PAnsiChar(E.ClassName + ', E.Message = ' + E.Message));
 end;

except
 tmpExcept:= TThread(self).FatalException;
 if Assigned(tmpExcept) then
 begin
   // Thread terminated due to an exception
   if tmpExcept is Exception then
    self.FStringStream_Log.WriteString(Exception(tmpExcept).ClassName +
                                    ', E.Message = ' +
                                    Exception(tmpExcept).Message +
                                    '(TTaskCore.DoTerminate, unTasks)');
    PostMessage(FInfo_ForViewing.hMemoLogInfo_2, WM_Data_Update, CMD_SetMemoStreamUpd, 0);
 end;
end;
//--- Записать в журнал отчёт о завершении данной задачи (потока)
try
 FStringStream_Log.WriteString(format(wsTaskItem_Terminated, [self.FTaskNum, self.ThreadID]));
 PostMessage(FInfo_ForViewing.hMemoLogInfo_2, WM_Data_Update, CMD_SetMemoStreamUpd, 0);
 self.Sleep(iCycleTimeValue*3); //--- пауза для получения данных главным потоком
finally
 if Assigned(self.FStringStream_Log) then
  FreeAndNil(self.FStringStream_Log);
 if Assigned(self.FStream_Log) then
  FreeAndNil(self.FStream_Log);
end;

end;


function TTaskItem.IsTerminated: boolean;
begin
  Result:= self.Terminated;
end;

//------------------------------------------------------------------------------
procedure TTaskItem.Execute;
var
  tmpProc: TTaskProcedure;
  tmpWord: word;
  tmpStreamWriter: TStreamWriter;
  tmpInt: integer;
  tmpInt64: Int64;
  tmpE: Exception;
  tmpObject: TObject;
begin
//--- Создаём новый объект "Ядро исходника Задачи" - для получения функционала управления потоком
//--- Делаем это в главном модуле, так как этот объект "продолжение" TaskItem, который становится аналогом
//--- "callback pump" для TaskSource, который создаётся в библиотеке
//--- Настройка потока для журнала главного модуля (через TaskItem)
{
//--- от ядра задачи в главный модуль
 Stream_Core_Log:= TOleStream.Create(TaskCore.TaskCoreStream_Log);
 Stream_Core_Log.Position:= 0;
//--- от ядра задачи
 StringStream_Core_Log:= TStringStream.Create('', TEncoding.ANSI); //--- При создании ядра не пишем в лог отдельное сообщение
 StringStream_Core_Log.LoadFromStream(Stream_Core_Log);

}
 self.TaskCoreState:= tsActive;
 self.FTaskCore.Start;
 tmpInt64:= 0;
//--- Допишем в массив запущенных потоков ID потока TaskCore (дочернего  для TaskItem)
 try
  ThreadStorList[length(ThreadStorList) - 1].cTaskCore__ThreadId:= TaskList[self.FTaskNum].TaskCore.ThreadID;
 finally

 end;

//--- Запишем в лог событие - создание нового потока - Задачи
 FStringStream_Log.WriteString(format(wsEvent_ThreadCreated, [self.FTaskNum,
                                                TaskList[self.FTaskNum].ThreadID,
                                                TaskList[self.FTaskNum].TaskCore.ThreadID]) +
                                                ' (formTools.btnNewThreadClick(), unTools)');
 PostMessage(FInfo_ForViewing.hMemoLogInfo_2, WM_Data_Update, CMD_SetMemoStreamUpd, 0);

//--- Для отработки (удалить после...)
 try
  tmpStreamWriter:= TFile.AppendText('D:\Install\ThreadList.txt');
  tmpStreamWriter.WriteLine(format(wsEvent_ThreadCreated, [self.FTaskNum,
                                                TaskList[self.FTaskNum].ThreadID,
                                                TaskList[self.FTaskNum].TaskCore.ThreadID]));
 finally
  FreeAndNil(tmpStreamWriter);
 end;
//---

// Начинаем отсчёт времени работы ядра текущей задачи (потока)
 self.FBeginTickCount:= GetTickCount();
 repeat
  try
   case self.TaskState of
    tsPause, tsDone:
      begin
       if self.FTaskCore.Priority <> tpIdle then self.FTaskCore.Priority:= tpIdle;
       if not self.FTaskCore.Suspended then self.FTaskCore.Suspended:= true;
      end;
    tsActive:
      begin
       if self.FTaskCore.Priority <> tpNormal then self.FTaskCore.Priority:= tpNormal;
       if self.FTaskCore.Suspended then self.FTaskCore.Suspended:= false;
      //--- выдаём квант времени на выполнение Задачи
       sleep(round(FCycleTimeValue*iTaskBoreHole)); // 5мс - на выполнение Задачи в библиотеке
                             // 95 - время выполнениея кода (ниже) и sleep
                             // это эмуляция квантованного предоставления времени выполнения потока

//--- Фиксируем текущее время (для вывода на экран)
       self.FEndTickCount:= GetTickCount();
      end;
    tsAbortedDone:
    begin
     if not self.FTaskSource.AbortExecution then
      self.FTaskSource.AbortExecution:= true;
     if self.FTaskCore.Priority <> tpNormal then self.FTaskCore.Priority:= tpNormal;
     if self.FTaskCore.Suspended then
     begin
      self.FTaskCore.Suspended:= false;
     end;
    end;
    tsTerminate:
      begin
       self.FTaskCore.TaskState:= tsTerminate; //--- чтобы покинуть цикл в TaskCore.Execute;
      if not self.FTaskSource.AbortExecution then
       self.FTaskSource.AbortExecution:= true;
       if self.FTaskCore.Priority <> tpNormal then self.FTaskCore.Priority:= tpNormal;
       if self.FTaskCore.Suspended then self.FTaskCore.Suspended:= false;
      end;
{    tsDone:
      begin
       self.FTaskCore.Priority:= tpIdle;
      end;
}
   end;

//--- Отчёт о сотоянии и результатах в главный модуль через self.PeriodReport (мс)
   if ((GetTickCount - tmpInt64) > self.PeriodReport) and (self.TaskState <> tsTerminate) then
   begin
//--- При выводе отчёта, также читаем промежуточные результаты от задачи и показываем в визуальных компонентах главного потока
//--- все потоки выводят информацию через одну переменную (запись) OutInfo_ForViewing
    try

      FInfo_ForViewing.IndexInViewComponent:= self.FLineIndex_ForView;
      FInfo_ForViewing.TextForViewComponent:= self.InfoFromTask;

//--- Формирование краткого результата выполнения задачи
      case self.FLibraryId of
      0:
        begin
          case self.FTaskSource.TaskLibraryIndex of
          0:
           begin
            if Win32Check(Assigned(self.FTaskSource)) then
             self.FInfoFromTask:= format(wsResultPartDll1Task0_InfoFromTask, [self.FTaskSource.Task_Result.dwEqualsCount]);
           end;
          1:
           begin
            if Win32Check(Assigned(self.FTaskSource)) then
              self.FInfoFromTask:= format(wsResultPartDll1Task1_InfoFromTask, [self.FTaskSource.Task_TotalResult]);
           end;
         end;

        end;
      1:
      begin
          case self.FTaskSource.TaskLibraryIndex of
          0:
           begin
            if Win32Check(Assigned(self.FTaskSource)) then
             self.FInfoFromTask:= wsResultPartDll2Task0_InfoFromTask;
           end;
         end;
      end;
      end;

//--- Вывод информации о зтекущем состоянии задачи и результирующей информации от задачи
     if TaskState <> tsTerminate then
     begin
//--- Отправим ТМемо (c подробной информацией о задаче) данные для обновлению
       case ModulsExchangeType of
        etMessage_WMCopyData:
         SendReportToMainProcess;
        etClientServerUDP:
         SendReportToMainProcess;
       end;

//--- Обновление результирующей информации, получаемой от задачи
      CriticalSection.Enter;
       tmpWord:= Info_ForViewing.CurrentViewingTask;
      CriticalSection.Leave;
      if tmpWord = self.FTaskNum then
      begin
       if self.StringStream_LastPos < self.Stream.Position then
       begin
          PostMessage(FInfo_ForViewing.hMemoThreadInfo_1, WM_Data_Update, self.FInfo_ForViewing.IndexInViewComponent, CMD_SetMemoStreamUpd);
       end;
      end;

   end;

//--- При ошибках во время формирования и направления информации для отображения в главной форме
//--- попадаем в этот finally и ничего не предпринимаем)
    finally
     tmpInt64:= GetTickCount;
    end;

   end;

//--- При других ошибках в TaskItem попадаем в этот except
 except
  if Assigned(tmpE) then
   begin
    FStringStream_Log.WriteString(tmpE.ClassName +
                                    ', Err.Message = ' +
                                    tmpE.Message +
                                    '(TTaskCore.DoTerminate, unTasks)');
    PostMessage(FInfo_ForViewing.hMemoLogInfo_2, WM_Data_Update, CMD_SetMemoStreamUpd, 0);
   end;
 end;

 sleep(round(FCycleTimeValue*(iCycleTimeValue*(1 - iTaskBoreHole)))); // 15мс - время выполнениея кода (выше) и sleep
                                     // Для уменьшения загрузки процессора вспомогательной нагрузкой (контроль, распределение) - - TaskItem
                                     // Полезная нагрузка выполняется в TaskCore -

until (self.TaskState = tsTerminate) and (self.TaskCoreState = tsTerminate);


//--- Завершающие действия перед уничтожением потока (TThread) -----------------
 try
//--- Сначала необходимо проверить на освобождение дочернего процесса - TaskCore
//--- В случае, если была исключительнвя ситуация, то в данной точке TaskCore может ещё существовать
  if self.TaskCoreState <> tsTerminate then
  begin
 //--- Дочерний поток TaskCore не завершён
   self.FTaskCore.TaskState:= tsTerminate; //--- чтобы покинуть цикл в TaskCore.Execute;
   if not self.FTaskSource.AbortExecution  then
    self.FTaskSource.AbortExecution:= true;
   if self.FTaskCore.Priority <> tpNormal then self.FTaskCore.Priority:= tpNormal;
   if self.FTaskCore.Suspended then self.FTaskCore.Suspended:= false;
   sleep(iCycleTimeValue);
   if self.TaskCoreState <> tsTerminate then
   begin
//--- Поток не отвечает - вызываем исключение в TaskSource

   end;
  end;
//--- Высвобождаем ресурсы TaskCore (уже завершённого к этому моменту)
  FTaskCore.WaitFor;
  FreeAndNil(FTaskCore);

//--- Высвобождаем ресурсы источника задачи (TaskSource) (на стороне библиотеки)
   try
    self.TaskSource._Release;
//    LibraryList[self.FLibraryId].LibraryAPI.FreeTaskSource(self.FTaskNum);
   except
     tmpObject:= ExceptObject;
//--- Если исключение вызвано естественными причинами (не экстренное прерывание работы), то статус был Активен
//--- поэтому устанавливаем Прервано
     self.FStringStream_Log.WriteString(Exception(tmpObject).ClassName +
                                        ', E.Message = ' +
                                        Exception(tmpObject).Message +
                                        '(TTaskCore.Execute (LibraryList[self.FLibraryId].LibraryAPI.FreeTaskSource(self.FTaskNum);), unTasks)');
     PostMessage(FInfo_ForViewing.hMemoLogInfo_2, WM_Data_Update, CMD_SetMemoStreamUpd, 0);
     self.Sleep(iCycleTimeValue*3);
   end;

 finally
  self.OnTerminate(self);
 end;

end; //--- TTaskItem.Execute;

//------------------------------------------------------------------------------
procedure TTaskItem.SetTaskName(TaskItemName: WideString = '');
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
 FTaskNum:= TaskNum;
//--- Назначаем в визуальном компоненте номер строки для вывода информации о процессе
//--- выполнения задачи равной номеру самой задачи в списке задач
 FLineIndex_ForView:= TaskNum;

end;

//------------------------------------------------------------------------------

procedure TTaskItem.SetTaskState(inTaskState: TTaskState);
begin
 FTaskState:= inTaskState;
end;

//------------------------------------------------------------------------------
procedure TTaskItem.SetTaskCoreState(inTaskCoreState: TTaskState);
begin
 FTaskCoreState:= inTaskCoreState;
end;

//------------------------------------------------------------------------------
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


procedure TTaskItem.SendReportToMainProcess;
var
  tmpAnsiString: AnsiString;
  tmpSingle: single;
  tmpInt: integer;
  tmpCardinal: cardinal;
  tmpWideString: WideString;

//------------ Подпрограммы TTaskItem.SendReportToMainProcess ------------------
procedure SendToViewByWmCopyData(inputString: WideString);
var
  cdsData: TCopyDataStruct;
  tmpHandle: THandle;
begin
  cdsData.dwData := CMD_SetMemoLine;
  cdsData.cbData := Length(PChar(inputString)) * sizeof(Char) + 1;
  GetMem(cdsData.lpData, cdsData.cbData);
  try
    StrPCopy(cdsData.lpData, PWChar(inputString));
    tmpHandle:= formMain.Handle; //FindWindow(nil, PWChar(formMain.ClassName));
    //Отсылаем сообщение в окно главного модуля
//    PostThreadMessage(FindWindow(nil, PWChar(formMain.Caption)),
//    PostMessage(FindWindow(nil, PWChar(formMain.ClassName)),
    SendMessage(tmpHandle,
                  WM_COPYDATA, Handle, Integer(@cdsData));
  finally
    FreeMem(cdsData.lpData, cdsData.cbData);
  end;
end;
//------------------------------------------------------------------------------


//--------------- Начало TTaskItem.SendReportToMainProcess ---------------------
begin
//--- Формирование заготовки строки отчёта
 if (TaskList.Count < 1) then
 begin
  exit;
 end;

 try
  tmpInt:= TaskList[self.FInfo_ForViewing.IndexInViewComponent].FTaskSource.Task_Result.dwEqualsCount;

// tmpWideString:= GetTaskStateName(TaskList[TaskNum].TaskState);
  tmpWideString:= format(sThreadInfoForView,
                                    [self.TaskNum,
                                     self.TaskName,
                                     '???',
                                     self.ThreadID,
                                     round((self.FEndTickCount - self.FBeginTickCount)/1000), //деление на 0...
                                     self.FInfoFromTask,  //--- Кратко о результате выполнения (формируется внутри Execute задачи
                                     GetTaskStateName(self.TaskState)]); //GetTaskStateName(TaskList[TaskNum].TaskState)]);

//------------------------------------------------------------------------------
    FInfo_ForViewing.TextForViewComponent:= AnsiString(tmpWideString);
    FInfo_ForViewing.TextForViewComponent:= format(sDelimiterNumTask + '%d' + sDelimiterNumTask,
                                                      [FInfo_ForViewing.IndexInViewComponent]) + FInfo_ForViewing.TextForViewComponent;

    case ModulsExchangeType of
     etMessage_WMCopyData:
     begin
      //--- После каждого цикла запускаем передачу информации в окно главной формы
      if formMain.reThreadInfo_Main <> nil then
        SendToViewByWmCopyData(FInfo_ForViewing.TextForViewComponent);
     end;

     etClientServerUDP:
     begin
       try
        FClientUDP.Connect;
        FClientUDP.Send(FInfo_ForViewing.TextForViewComponent, IndyTextEncoding_UTF8);
       finally
        FClientUDP.Disconnect;
       end;
     end;

    end;
 except
  on tmpE: Exception do
    begin
     FStringStream_Log.WriteString(tmpE.ClassName +
                                    ', Err.Message = ' +
                                    tmpE.Message +
                                    '(TTaskItem.SendReportToMainProcess, unTasks)');
     PostMessage(FInfo_ForViewing.hMemoLogInfo_2, WM_Data_Update, CMD_SetMemoStreamUpd, 0);
    end;
 end;

end;


function TTaskItem.GetTaskStateName(inTaskState: TTaskState): WideString;
begin
 Result:= '';
 case TTaskState(ord(inTaskState)) of
   TTaskState(-1): Result:= aTaskStateName[0]; //'Не определено';
   TTaskState(0):  Result:= aTaskStateName[1];
   TTaskState(1), TTaskState(4):  Result:= aTaskStateName[2];
   TTaskState(2):  Result:= aTaskStateName[3];
   TTaskState(3):  Result:= aTaskStateName[4];
 end;
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
 TaskList:= TTaskList.Create(true); //--- false = TaskList не будет владеть помещаемыми обхектами и сам их разрушать не сможет при удалении из списка.
//--- TaskList.OwnsObjects:= false;  //--- текущий вариант алгоритма использует самоуничтожение TThread после завершения, поэтому и не надо, что бы тасклист пытался это проделать
 FileList:= TFileList.Create(true);
 CriticalSection:= TCriticalSection.Create();

finalization

// if Assigned(TaskList) then TaskList.Free;
// if Assigned(FileList) then FileList.Free;
// if Assigned(CriticalSection) then CriticalSection.Free;

end.
