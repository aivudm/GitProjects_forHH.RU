unit unTaskItem;

interface

implementation
//------------------------------------------------------------------------------
type
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
    procedure OnTerminate(Sender: TObject); overload;
    procedure SendReportToMainProcess;
    procedure CheckReportTime(TaskItem: TTaskItem);
    function GetPeriodReport: TPeriodReport;
    function GetTaskState(): TTaskState;
    function PrepareOutString(TaskNum: integer; sPersonThreadInfo: string): string;
//    function InitTaskSource(SelectedLibraryNum, SelectedTaskNum: byte; TaskItemNum: word): Pointer;
    function IsTerminated: boolean;

    property TaskNum: word read FTaskNum;
{$IFDEF MSWINDOWS}
    property TaskSource: TTaskSource read FTaskSource write SetTaskSource;
//    property TaskExecProcedure: TTaskProcedure read ExecProcedure;
    property TaskState: TTaskState read FTaskState write SetTaskState;
    property CoreUtilization: byte read FCoreUtilization;

{$ENDIF MSWINDOWS}

//    property PeriodReport: TPeriodReport read FPeriodReport;
//    property LineIndex_ForView: integer read FLineIndex_ForView write FLineIndex_ForView;
//    property HandleWinForView: hWnd read FHandleWinForView write SetHandleWinForView;
//    property InfoFromTask: string read FInfoFromTask write FInfoFromTask;
//    property StreamWriterNum: word read FSreamWriterNum;

//    property TimerCycleCount: Int64 read FTimerCycleCount;
  published
    property Terminated;
  end;

end.
