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
  TTaskProcedure = procedure (TaskLibraryIndex: word) of object;

  TTaskItem = class (TThread)
   private
    FTaskName: string;
    FTaskNumInList: word;
    FTaskSource: ITaskSource;
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
    function PrepareOutString(TaskNum: integer; sPersonThreadInfo: string): string;
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
  TTaskList = class (TObjectList)   //--- ������� ��-�� ����������� ��������� ������
   private
    function GetItem(Index: integer): TTaskItem;
    procedure SetItem(Index: integer; const Value: TTaskItem);
   public
    property Items[Index: integer]: TTaskItem read GetItem write SetItem; default;
  end;


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
 FTaskName:= LibraryList[TaskLibraryId].TaskTemplateName[TaskTemplateId];
 FreeOnTerminate:= true;
 Priority:= tpNormal;
// self.FDSiTimer.Interval:= TaskList[TaskItemNum].GetPeriodReport;
 FPeriodReport:= 2000; //--- �����������
 FCycleTimeValue:= 1000;
//----- ��� ������ ������� ������ ������� ������ ������ ������ -----------------
 FLastOSTickCount:= GetTickCount(); // "���h��" ��������
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

  self.FTaskSource.TaskProcedure(self.TaskNum); // FTaskProcedure(self.TaskNum); // ����� ��������� ������, ����������� � ������� ������

 //--- ���������� ���������� ������
 //--- ��������� ����� ����� ���������� ������
 FElapsedMillseconds:= FStopWatch.ElapsedMilliseconds;
 //--- ������������ ������ �� ������, ��� ��� ��� �������� ��������� FreeOnTerminate
 TaskList[self.FTaskNumInList].Terminate;
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
    OutInfo_ForViewing.TextForViewComponent:= AnsiString(PrepareOutString(self.FTaskNumInList, OutInfo_ForViewing.TextForViewComponent));

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

{
function TTaskItem.InitTaskSource(SelectedLibraryNum, SelectedTaskNum: byte; TaskItemNum: word): Pointer;
var
 tmpPointer: Pointer;
begin
 case SelectedTaskNum of
  0:
  begin
    self.SetTaskSource(LibraryList[SelectedLibraryNum].LibraryAPI.NewTaskSource(TaskItemNum));
  end;
  1:
  begin
  end;
  2:
  begin
  end;
  3:  // ������ ��� ��������� ������� �� hh.ru
  begin
  end;
  else Result:= nil;
 end;
// TTaskSource(Result).SetTaskItem(TaskList[TaskItemNum]);
end;
}

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
