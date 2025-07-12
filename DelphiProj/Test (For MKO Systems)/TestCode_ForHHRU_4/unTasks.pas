unit unTasks;

interface
uses
  Vcl.Forms, System.Classes, System.SysUtils, System.SyncObjs, System.Diagnostics, Winapi.Windows, Vcl.ExtCtrls, System.Contnrs,
  unConst, unVariables, IdUDPClient, Dialogs, IOUtils;

type

  TTaskState = (tsNotDefined = -1 {���� �� ���������� - ��� �������, �� ������� ������� �������� ���� �������� ������},
                tsActive = 0, tsTerminate = 1, tsPause = 2, tsReportPause = 3);

//  TProcedure = reference to procedure;
{$IFDEF MSWINDOWS}
//    TTaskOSPriority = (tpIdle, tpLowest, tpLower, tpNormal, tpHigher, tpHighest,
//    tpTimeCritical) platform;
  TTaskOSPriority = array of TThreadPriority;
{$ENDIF MSWINDOWS}
  TPeriodReport = 1..5000; // ����������� � ��

  TTaskItem = class;
//  TTaskProcedure = reference to procedure (TaskItem: TTaskItem); // of object;
  TTaskProcedure = procedure (TaskItem: TTaskItem) of object;

  TTaskSource = class (TObject)
   private
    const
     FTaskSourceName: string  = '��� ������������ ���������';
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
     FTaskSourceName: string  = '������ ����� ��';
   protected
   public
    constructor Create(TaskItemNum: word); overload;
    class procedure TaskProcedure(TaskItem: TTaskItem); overload; inline;
  end;


//--- ����� �������� ���������� �������������� ������� �� ��������� ������ ������� - TaskSource
//--- ��� ��� ����� �� �������� �� ������� � TObjectList... --------------------
//  TTaskSourceList = TArray<TTaskSource>;
(*   TTaskSourceList = class (TObjectList)   //--- ������� ��-�� ����������� ��������� ������
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
     FTaskSourceName: string  = '����� ������ ��� �����'; //--- '����������� ������� ����� ������� ��������'
   protected
    FCurrentNumber: Int64;
    procedure SetCurrentNumber(inNumber: Int64);
   public
    constructor Create(TaskItemNum: word); overload;
    class procedure TaskProcedure(TaskItem: TTaskItem); overload; inline;

    property CurrentNumber: Int64 read FCurrentNumber write SetCurrentNumber;
  end;

//  TTaskSourceList = TArray<TTaskSource4>;
  TTaskSource4List = class (TObjectList)   //--- ������� ��-�� ����������� ��������� ������
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
    FCycleTimeValue: word; // ����������������� ������ ���������� ����� � �� (�� ��������� 1000 ��)
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

//    procedure ExecProcedure;   //--- ����������� ����� ������������ ����� �������� � ������������
//    ExecProcedure: TTaskProcedure;   //--- ����������� ����� ������������ ����� �������� � ������������
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
  TTaskList = class (TObjectList)   //--- ������� ��-�� ����������� ��������� ������
   private
    function GetItem(Index: integer): TTaskItem;
    procedure SetItem(Index: integer; const Value: TTaskItem);
   public
    property Items[Index: integer]: TTaskItem read GetItem write SetItem; default;
  end;
//------------------------------------------------------------------------------
//---- �������� � ��������� ������ ����� ���������� �������� ������ YaskItem ---
//---- ����������� �������� � ������ ���������� ������ ��� �������� ������ � �������
//---- ���������� �� ������ ������
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

  TTimerList1 = class (TObjectList)   //--- ������� ��-�� ����������� ��������� ������
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
//---------- ������ ��� TTaskSource... -----------------------------------------
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

 // ��� ������� ������� ��������� ������ ��������� ������� �������� � ���� (���� ������ � ���������)
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

 // ��� ������� ������� ��������� ������ ��������� ������� �������� � ���� (���� ������ � ���������)
 TaskList[TaskItemNum].SetStreamWriter(FileList.Add(TFileItem.Create(TaskItemNum)));

end;


//------------------------------------------------------------------------------
//---------- ������ ��� TTaskSourceList ----------------------------------------------
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
//---------- ������ ��� TTaskItem ----------------------------------------------
//------------------------------------------------------------------------------
constructor TTaskItem.Create(TaskLibraryId, TaskTemplateId: word; BeginState: TTaskState);
var
  tmpWord: word;
  tmpBool: boolean;
begin
 //--- ��������� ��������� ��������� ������ � tsNotDefined
 //--- ��� ����������� � �� �������� ������ ���������
 //--- ���� ��� ������� �� ����� ������� � ��������
 TaskState:= tsNotDefined;

 inherited  Create(false); //--- ������� ������ ������ �� AfterConstraction
 //--- � ���� ������������ �� ����� �� ���������
 FTaskLibraryId:= TaskLibraryId; // ����� ������-������� �� ������� aTaskNameArray
 FTaskTemplateId:= TaskTemplateId; // ����� ������-������� �� ������� aTaskNameArray
 FTaskName:= aTemplateTaskNameArray[FTaskTemplateId];
 FreeOnTerminate:= true;
 Priority:= tpNormal;
// self.FDSiTimer.Interval:= TaskList[TaskItemNum].GetPeriodReport;
 FPeriodReport:= 2000; //--- �����������
 FCycleTimeValue:= 1000;
//----- �������� ������� - �������������� ��� ������� ������� ------------------
//----- ��� ������ ������� ������ ������� ������ ������ ������ -----------------
 FLastOSTickCount:= GetTickCount(); // "������" ��������
 FStopWatch := TStopwatch.StartNew; // ����� �������� (�������� � 10-� ������

//--- ��������� � ���������� ���������� ����� ������ ��� ������ ���������� � ��������
//--- ���������� ������ ������ ������ ����� ������ � ������ �����
 self.FLineIndex_ForView:= TaskTemplateId;

// if ExchangeType = etClientServerTCP then
//  begin
   FClientUDP:= TIdUDPClient.Create(nil);
   FClientUDP.Host:= serverUDPName;
   FClientUDP.Port:= ServerUDPPort;
//  end;

//--- �������� ��������� ������, ������� ������ �� ����� ������ ������������
//--- �������� TEvent ��� �������� ��������� ������ �� ������ �� �������
//--- � ������ ���������� ���������� ��� ����� ����� ������ ��������� ������
//--- ������� ���������� ��� ���������� ������ � ����� ������ �� �������

 case BeginState of
  tsActive:
   tmpBool:= true;
  else
   tmpBool:= false;
 end;
 FPauseEvent:= TEvent.Create(nil, true, tmpBool, 'ThreadPauseEvent_Task_' + IntToStr(FTaskTemplateId));

//--- �������� ��������� ������, ������� ������ �� ����� ������ ������������
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
 FTaskStepCount:= 0;  // ������� ������� �������� ������ ������� ������ (������)
 FStopWatch.StartNew; // �������� ������ ������� ������� ������ (������)
 // �������� ���������� ��� ���������� ����������� "������� ������� ���������"
 // � ������� ��� ����� �������, ������� ��� �� �������� ���������.
 sleep(100);
 repeat

  FTaskProcedure(self); // ����� ��������� ������, ����������� � ������� ������

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
    self.Suspended:= true; //--- ���������� �����
   end;

(*
  if self.TaskState = tsPause then
   self.Suspend; //--- ��� ��������� (��������) ���������� �����
*)
  if self.TaskState = tsReportPause then
  begin
   self.SetTaskState(tsActive); //--- ���� ��� �����, �� ������� �� ��������� ������ (��� �������� ����)
  end; // if

 until (self.TaskState = tsTerminate);

 //--- ���������� ���������� ������
 //--- ��������� ����� ����� ���������� ������
 FElapsedMillseconds:= FStopWatch.ElapsedMilliseconds;
// FTaskSource.StreamWriter.Close;
 FileList[StreamWriterNum].FStreamWriter.Flush;
 FileList[StreamWriterNum].FStreamWriter.Close;
 //--- ������������ ������ �� ������, ��� ��� ��� �������� ��������� FreeOnTerminate
 TaskList[self.FTaskNum].Terminate;
 //--- �������� ������ �� ������ �������� "������" (���������� �� ���������� ����������� ��������� � ���� ���������...)
// TaskList[self.FTaskNum].Destroy;
 //--- �������� ������ �� ������ "�����" (���������� �� ���������� ����������� ��������� � ���� ���������...)
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
  FPauseEvent.SetEvent; //--- ��������� ������� "����� ��� ������� ������"

 FTaskState:= inTaskState;

 if FTaskState = tsPause then
  FPauseEvent.ResetEvent; //--- �������� ������� "����� ��� ������� ������"

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
          + Format(' , TreadId: %6d | CPU usage(����.): %f | ����. - %s', [cTmp, fTmp, sTmp]);
end;


procedure TTaskItem.SendReportToMainProcess;
begin
    OutInfo_ForViewing.TextForViewComponent:= AnsiString(PrepareOutString(self.FTaskNum, OutInfo_ForViewing.TextForViewComponent));

    case ExchangeType of
     etSynchronize:
     begin
      //--- ����� ������� ����� ��������� �������� ���������� � ������� ��������� ��� � ���� ������� �����
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
   TTaskState(-1): Result:= '�� ����������';
   TTaskState(0):  Result:= '�������';
   TTaskState(1):  Result:= '����������';
   TTaskState(2):  Result:= '�����';
   TTaskState(3):  Result:= '�������'; //--- � ��������� ����� ��� ������ - �� ��� ���� �������� ���������!
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
//---------- ������ ��� TTaskList ----------------------------------------------
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
//---------- ������ ��� TTaskSource4List ----------------------------------------------
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
//------ ������ ��� ������� ----------------------------------------------------
//------------------------------------------------------------------------------

 procedure Calc_NOP(TaskItemIndex: byte);
 begin
   //--- �������� (��������), �������� ��� "����������, ���� ���-�� ����� �� ��� � ������������ TaskItem
 end;

class procedure TTaskSource2.TaskProcedure(TaskItem: TTaskItem);
 //--- Calculate (��): ����� �� ���������� (.dll)
var
  tmpInt, tmpInt1: Integer;
  tmpStr: string;
  tmpCallingDLLProc: TCallingDLLProc;
 begin

//  tmpCallingDLLProc:= FCallingDLLProc;
  if @FCallingDLLProc = nil then
  begin
   TaskItem.InfoFromTask:= '������� ' + IntToStr(TaskItem.FTaskStepCount) + ' ���.����, ' + Format('; ������: �� ������� ������������ ( %s )� ���������� ( %s )', [aTaskDllProcNameArray[TaskItem.FTaskTemplateId], DllFileName]);
   TaskItem.SetTaskState(tsTerminate);
   exit;
  end;

 // � ���������� ����������� ������������:
//  Calc_Algorithm_Pi (tmpInt, fsResult, 100); // 1 - ����� �������� (Int), ��������, ��� �������� ����� ��� ���������� ��������
                                  // 2 - ����, � ������� ����� ���������� ����������
                                  // 3 - ������������ ����� �� ������ ������ ��� ����������� ������ �� ������ (� �������������)
// �������� ������ ������� ������ ���������� ����� ������� ������ ������
// ����������� ������� �������� TaskItem.FStopWatch
  tmpInt1:= TaskItem.FStopWatch.ElapsedMilliseconds;

  repeat
   FCallingDLLProc(tmpInt, FileList[TaskItem.StreamWriterNum].FStreamWriter, TaskItem.FPeriodReport);
  until ((TaskItem.FStopWatch.ElapsedMilliseconds - tmpInt1) >= TaskItem.FPeriodReport)
        or (TaskItem.TaskState = TTaskState(tsTerminate)) or (TaskItem.TaskState = TTaskState(tsPause)) or (TaskItem.TaskState = TTaskState(tsReportPause));

  inc(TaskItem.FTaskStepCount); // ����������� ���������� ���������� ��������� �����
  TaskItem.InfoFromTask:= '������� ' + IntToStr(TaskItem.FTaskStepCount) + ' ���.����, ' + Format('"�������": %d ����� ', [tmpInt]);

 end;


class procedure TTaskSource4.TaskProcedure(TaskItem: TTaskItem);
 //--- �������� ��������� ������ ��� ����� hh.ru: ����� �� ���������� (.dll)
var
  tmpInt, tmpInt1: Integer;
  tmpStr: string;
  tmpCallingDLLProc: TCallingDLLProc;
 begin

//  tmpCallingDLLProc:= FCallingDLLProc;
  if @FCallingDLLProc = nil then
  begin
   TaskItem.InfoFromTask:= '������� ' + IntToStr(TaskItem.FTaskStepCount) + ' ���.����, ' + Format('; ������: �� ������� ������������ ( %s )� ���������� ( %s )', [aTaskDllProcNameArray[TaskItem.FTaskTemplateId], DllFileName]);
   TaskItem.SetTaskState(tsTerminate);
   exit;
  end;

 // � ���������� ����������� ������������:
//  Calc_Algorithm_Pi (tmpInt, fsResult, 100); // 1 - ����� �������� (Int), ��������, ��� �������� ����� ��� ���������� ��������
                                  // 2 - ����, � ������� ����� ���������� ����������
                                  // 3 - ������������ ����� �� ������ ������ ��� ����������� ������ �� ������ (� �������������)
// �������� ������ ������� ������ ���������� ����� ������� ������ ������
// ����������� ������� �������� TaskItem.FStopWatch
  tmpInt1:= TaskItem.FStopWatch.ElapsedMilliseconds;

  repeat
   FCallingDLLProc(tmpInt, FileList[TaskItem.StreamWriterNum].FStreamWriter, TaskItem.FPeriodReport);
  until ((TaskItem.FStopWatch.ElapsedMilliseconds - tmpInt1) >= TaskItem.FPeriodReport)
        or (TaskItem.TaskState = TTaskState(tsTerminate)) or (TaskItem.TaskState = TTaskState(tsPause)) or (TaskItem.TaskState = TTaskState(tsReportPause));

  inc(TaskItem.FTaskStepCount); // ����������� ���������� ���������� ��������� �����
  TaskItem.InfoFromTask:= '������� ' + IntToStr(TaskItem.FTaskStepCount) + ' ���.����, ' + Format('"�������": %d ����� ', [tmpInt]);

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
  3:  // ������ ��� ��������� ������� �� hh.ru
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


//--- ������������ ��� �������
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
