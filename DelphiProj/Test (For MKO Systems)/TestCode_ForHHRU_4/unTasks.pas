unit unTasks;

interface
uses
  Winapi.Windows, Winapi.Messages, Vcl.Forms, System.Classes, System.SysUtils, System.SyncObjs, System.Diagnostics, Vcl.ExtCtrls, System.Contnrs,
  IdUDPClient, Dialogs, IOUtils, ActiveX, Vcl.AxCtrls,
  unConst, unVariables;

type

//------------------------------------------------------------------------------
  TTaskState = (tsNotDefined = -1 {���� �� ���������� - ��� �������, �� ������� ������� �������� ���� �������� ������},
                tsActive = 0, tsTerminate = 1, tsPause = 2, tsDone = 3);
//------------------------------------------------------------------------------
//  TProcedure = reference to procedure;
{$IFDEF MSWINDOWS}
//    TTaskOSPriority = (tpIdle, tpLowest, tpLower, tpNormal, tpHigher, tpHighest,
//    tpTimeCritical) platform;
//------------------------------------------------------------------------------
  TTaskOSPriority = array of TThreadPriority;
{$ENDIF MSWINDOWS}
//------------------------------------------------------------------------------
  TPeriodReport = 1..5000; // ����������� � ��

//------------------------------------------------------------------------------
  TTaskItem = class;
//  TTaskProcedure = reference to procedure (TaskItem: TTaskItem); // of object;
//------------------------------------------------------------------------------
  TTaskProcedure = procedure (TaskLibraryIndex: word) of object;
  TTaskCore = class;

//------------------------------------------------------------------------------
  TTaskItem = class (TThread)
   private
    FTaskName: WideString;
    FTaskNumInList: word;
    FTaskSource: ITaskSource;
    FTaskCore: TTaskCore;
    FTaskState: TTaskState;
    FPauseEvent: TEvent;
    FPeriodReport: TPeriodReport;
    FBeginTickCount: cardinal;
    FEndTickCount: cardinal;
    FMemoryStream: TMemoryStream;
    FStream: TStream;
    FOLEStream: IStream;  //--- ����� � "COM-�������" ��������� ����������� TStreamAdapter
//    FStopWatch: TStopwatch;
//    FElapsedMillseconds: Int64;
//    FTimerCycleCount: Int64;
    FCycleTimeValue: word; // ����������������� ������ ���������� ����� � �� (�� ��������� 1000 ��)
    FCoreUtilization: byte;
{$IFDEF MSWINDOWS}
    FTaskOSPriority: TTaskOSPriority;
{$ENDIF MSWINDOWS}

    FHandleWinForView: hWnd;
    FThreadIDWinForView: THandle;
    FInfoFromTask: WideString;
    FIsDeleted: boolean;
    FClientUDP: TIdUDPClient;
    procedure thrSendInfoToView(inputString: WideString);
   protected
    FLibraryId: DWORD;
    FTaskTemplateId: word;
    FTaskProcedure: TTaskProcedure;

    FLineIndex_ForView: integer;
    FSreamWriterNum: word;

//    procedure ExecProcedure;   //--- ����������� ����� ������������ ����� �������� � ������������
//    ExecProcedure: TTaskProcedure;   //--- ����������� ����� ������������ ����� �������� � ������������
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
    procedure SetTaskName(TaskItemName: WideString = '');
    procedure SetStreamWriter(TaskStreamWriter: word);
    procedure SendReportToMainProcess;
    procedure DeleteTaskFromViewingList;
    procedure MarkAsDeleted;
    function GetTaskSource(): ITaskSource;
    function GetPeriodReport: TPeriodReport;
    function GetTaskState(): TTaskState;
    function PrepareOutString(inTaskNumInList: word; inThreadInfo: WideString): WideString;
    function GetTaskStateName(inTaskState: TTaskState): WideString;
//    function CheckReportTime(TaskItem: TTaskItem): boolean;
//    function InitTaskSource(SelectedLibraryNum, SelectedTaskNum: byte; TaskItemNum: word): Pointer;
    function IsTerminated: boolean;

    property LibraryId: DWORD read FLibraryId;
    property TaskName: WideString read FTaskName;
    property TaskNum: word read FTaskNumInList;
{$IFDEF MSWINDOWS}
    property TaskSource: ITaskSource read FTaskSource write SetTaskSource;
    property TaskCore: TTaskCore read FTaskCore write FTaskCore;
    property TaskOSPriority: TTaskOSPriority read FTaskOSPriority write FTaskOSPriority;
//    property TaskExecProcedure: TTaskProcedure read ExecProcedure;
    property TaskState: TTaskState read FTaskState write SetTaskState;
    property CoreUtilization: byte read FCoreUtilization;

{$ENDIF MSWINDOWS}

    property PeriodReport: TPeriodReport read FPeriodReport;
    property LineIndex_ForView: integer read FLineIndex_ForView write FLineIndex_ForView;
    property HandleWinForView: hWnd read FHandleWinForView write SetHandleWinForView;
    property InfoFromTask: WideString read FInfoFromTask write FInfoFromTask;
    property StreamWriterNum: word read FSreamWriterNum;
    property Stream: TStream read FStream write FStream;
    property MemoryStream: TMemoryStream read FMemoryStream write FMemoryStream;
    property ThreadIDWinForView: THandle read FThreadIDWinForView write FThreadIDWinForView;
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

//------------------------------------------------------------------------------
//--- ��������������� ������ ��� TaskItem - ������ ��� TaskSource �� ����������
//--- ��� ���� - ��� �������������� ����������� ���������� �������, ������� ----
//--- ����� ��������� ������ ����� ���� ������ �� ���������� -------------------
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
    property TaskItemOwner: TTaskItem read FTaskItemOwner write FTaskItemOwner;
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

    OutInfo_ForViewing: TOutInfo_ForViewing;
    ReportingTaskItemNum: integer;
    stSystemTimes: TThread.TSystemTimes;
    curTaskItem: TTaskItem;

//------------------------------------------------------------------------------


// {$L unThread.pas}

//function InitTaskSource(SelectedTaskNum: byte; TaskItemNum: word): Pointer;
//procedure SendReportToMainProcess(TaskItem: TTaskItem);
//function PrepareOutString(TaskNum: integer): WideString;


implementation
uses unMain, unUtilCommon, IdGlobal, unUtils;

//------------------------------------------------------------------------------
//---------- ������ ��� TTaskCore ----------------------------------------------
//------------------------------------------------------------------------------
constructor TTaskCore.Create(TaskItemOwner: TTaskItem);
begin
 inherited  Create(true); //--- true = ������� ������ ������ (��������� TaskItem)
 Priority:= tpIdle; //tpLower; //tpNormal;

 self.FTaskItemOwner:= TaskItemOwner;
 FreeOnTerminate:= false; //--- ���� ��������� �������� - TaskItem (��������, ��� ������� ������ �� ���� �� ������)

end;

destructor TTaskCore.Destroy();
begin
end;



//------------------------------------------------------------------------------
procedure TTaskCore.Execute;
var
  tmpTaskState: TTaskState;
  tmpObject: TObject;
  tmpPAnsiChar: PAnsiChar;
  tmpWideString: WideString;
begin
  tmpTaskState:= self.FTaskItemOwner.TaskState; //--- ��� ������ (������������ �������� TaskUtem) ����� ������ - tsActive
 repeat                                         //--- ����� ������� ������� ����� ������ tsDone � �������� �� ����������
                                                //--- ����� If �� �����, ���� �������� TaskItem �� ������ tsActive ��� tsTerminate

  if (not (self.FTaskItemOwner.TaskState = tsDone)) and (not (self.TaskItemOwner.TaskState = tsPause)) and (not (self.TaskItemOwner.TaskState = tsTerminate)) then
   begin
    try
     FTaskItemOwner.FTaskSource.TaskProcedure(self.FTaskItemOwner.FLibraryId);
    except
//    if Assigned(e) then     1
//     tmpPAnsiChar:= PAnsiChar(e.Message + #13 + e.ClassName())
//    else
//    begin
     tmpObject:= ExceptObject;
     tmpWideString:= Exception(tmpObject).Message;
     WriteDataToLog(Exception(tmpObject).ClassName + ', E.Message = ' + tmpWideString, 'TTaskCore.Execute', 'unTasks');

//    raise Exception.Create(tmpPAnsiChar);
//   end;
    end;
    self.FTaskItemOwner.TaskState:= tsDone;
//--- ��������� ����� ����� ���������� ������
    self.FTaskItemOwner.FEndTickCount:= GetTickCount();
   end
   else
    sleep(100);
 until (self.FTaskItemOwner.TaskState = tsTerminate);

end;
//------------------------------------------------------------------------------




procedure TTaskCore.OnTerminate(Sender: TObject);
var
  tmpString: WideString;
  E: Exception;
begin
try
 if Assigned(self) then
 begin
  self.TaskItemOwner.TaskCore:= nil;
  FreeAndNil(self);
 end;
except
 if Assigned(E) then
  begin
   WriteDataToLog(E.ClassName + ', E.Message = ' + E.Message, 'TformMain.lbThreadListClick', 'unMain');
  end;
  raise Exception.Create(PAnsiChar(tmpString));
end;

end;


//------------------------------------------------------------------------------
//---------- ������ ��� TTaskItem ----------------------------------------------
//------------------------------------------------------------------------------
constructor TTaskItem.Create(TaskLibraryId, TaskTemplateId: word; inputBeginState: TTaskState);
var
  tmpWord: word;
  tmpBool: boolean;
  Stream: TStream;
begin
try
 //--- ��������� ��������� ��������� ������ � tsNotDefined
 //--- ��� ����������� � �� �������� ������ ���������
 //--- ���� ��� ������� �� ����� ������� � ��������
 TaskState:= tsNotDefined;
   inherited  Create(true);  //--- false = TaskItem ��������� ������ �����! (��� ����������� �������� ���� ������)

//----- ��� ������ ������� ������ ������� ������ ������ ������ -----------------
 FBeginTickCount:= GetTickCount(); // "������" ��������
// FStopWatch := TStopwatch.StartNew; // ����� �������� (�������� � 10-� ������

 //--- � ���� ������������ �� ����� �� ���������
 FLibraryId:= TaskLibraryId; // ���������� ����� ���������� (�� ������ �� ���������)
 FTaskTemplateId:= TaskTemplateId; // ����� ������-������� �� ������� aTaskNameArray
 FTaskName:= LibraryList[TaskLibraryId].TaskTemplateName[TaskTemplateId];
 FreeOnTerminate:= true;

 Priority:= tpLower; //tpNormal; ���� ����� ������ ��������� � �������� � �����
// self.FDSiTimer.Interval:= TaskList[TaskItemNum].GetPeriodReport;
 FPeriodReport:= 1000; //--- �����������
 FCycleTimeValue:= 20; //--- ����������� ����� ������� �� 1/4 ���������� ������ + 3/4 �� ����� + �������

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

 case inputBeginState of
  tsActive:
   tmpBool:= true;
  else
   tmpBool:= false;
 end;
 FPauseEvent:= TEvent.Create(nil, true, tmpBool, 'ThreadPauseEvent_Task_' + IntToStr(FTaskTemplateId));

//--- �������� ��������� ������, ������� ������ �� ����� ������ ������������
TaskState:= inputBeginState;

finally

end;

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
  tmpInt64: Int64;
begin

 // �������� ���������� ��� ���������� ����������� "������� ������� ���������"
 // � ������� ��� ����� �������, ������� ��� �� �������� ���������.
// sleep(100);

//--- ������� ������ �� ���������� ����������� �����
//  self.FTaskSource.TaskProcedure(self.TaskNum); // FTaskProcedure(self.TaskNum); // ����� ��������� ������, ����������� � ������� ������
//--- ������ ����� ������ "���� ��������� ������" - ��� ��������� ����������� ���������� �������
//--- ������ ��� � ������� ������, ��� ��� ���� ������ "�����������" TaskItem, ������� ���������� ��������
//--- "callback pump" ��� TaskSource, ������� �������� � ����������
 self.FTaskCore:= TTaskCore.Create(self); //--- �������� � ���������� ��������
 self.FTaskCore.Start;
 tmpInt64:= 0;
// FStopWatch.StartNew; // �������� ������ ������� ������ ���� ������� ������ (������)
 self.FBeginTickCount:= GetTickCount();
repeat
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
      //--- ����� ����� ������� �� ���������� ������
       sleep(round(FCycleTimeValue*0.05)); // 5�� - �� ���������� ������ � ����������
                             // 95 - ����� ����������� ���� (����) � sleep
                             // ��� �������� ������������� �������������� ������� ���������� ������
//--- ��������� ������� ����� (��� ������ �� �����)
       self.FEndTickCount:= GetTickCount();
      end;
    tsTerminate:
      begin
       self.FTaskCore.TaskState:= tsTerminate; //--- ����� �������� ���� � TaskCore.Execute;
      end;
{    tsDone:
      begin
       self.FTaskCore.Priority:= tpIdle;
      end;
}
  end;

//--- ����� � �������� � ����������� � ������� ������ ����� self.PeriodReport (��)
   if (GetTickCount - tmpInt64) > self.PeriodReport then
   begin
//--- ��� ������ ������, ����� ������ ������������� ���������� �� ������ � ���������� � ���������� ����������� �������� ������
//--- ��� ������ ������� ���������� ����� ���� ���������� (������) OutInfo_ForViewing
    try
      CriticalSection.Enter;
// curTaskItem:= self;

      OutInfo_ForViewing.hWndViewObject:= self.FHandleWinForView;
      OutInfo_ForViewing.IndexInViewComponent:= self.FLineIndex_ForView;
      OutInfo_ForViewing.TextForViewComponent:= self.InfoFromTask;
//--- ������������ �������� ���������� ���������� ������

      case self.FLibraryId of
      0:
        begin
          case self.FTaskSource.TaskLibraryIndex of
          0:
           self.FInfoFromTask:= format(wsResultPartDll1Task0_InfoFromTask, [self.FTaskSource.Task_Result.dwEqualsCount]);
          1:
           begin
            if Win32Check(Assigned(self.FTaskSource)) then
              self.FInfoFromTask:= format(wsResultPartDll1Task1_InfoFromTask, [self.FTaskSource.Task_TotalResult]);
           end;
         end;

        end;
      1:
      begin

      end;
      end;


     case ModulsExchangeType of
     etMessage_WMCopyData:
      SendReportToMainProcess;  //Synchronize(SendReportToMainProcess);
     etClientServerUDP:
      SendReportToMainProcess;
     end;
    finally
      CriticalSection.Leave;
    end;

    tmpInt64:= GetTickCount;
   end;


  while (TaskState = tsPause) and (TaskState <> tsTerminate) do
   begin
//    self.FTaskCore.Suspended:= true; //--- ���������� �����
//    self.Priority:= tpIdle;
   end;

(*
  if self.TaskState = tsPause then
   self.Suspend; //--- ��� ��������� (��������) ���������� �����
*)
  sleep(round(FCycleTimeValue*0.75)); // 15�� - ����� ����������� ���� (����) � sleep
                                     // ��� �������� ������������� �������������� ������� ���������� ������
 until (self.TaskState = tsTerminate);

 //--- ���������� ���������� ������
 self.FTaskCore.Terminate;

 //--- ������������ ������ �� ������, ��� ��� ��� �������� ��������� FreeOnTerminate
 TaskList[self.FTaskNumInList].Terminate;
 //--- �������� ������ �� ������ �������� "������" (���������� �� ���������� ����������� ��������� � ���� ���������...)
// TaskList[self.FTaskNum].Destroy;
 //--- �������� ������ �� ������ "�����" (���������� �� ���������� ����������� ��������� � ���� ���������...)

(*
//--- ���������� ����������� ���������� ������� ������ � ��������� (����������)
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
 FTaskNumInList:= TaskNum;
//--- ��������� � ���������� ���������� ����� ������ ��� ������ ���������� � ��������
//--- ���������� ������ ������ ������ ����� ������ � ������ �����
 FLineIndex_ForView:= TaskNum;

end;

procedure TTaskItem.SetTaskState(inTaskState: TTaskState);
begin
 FTaskState:= inTaskState;
{
 if ((FTaskState = tsPause) or (FTaskState = tsTerminate)) then exit;

 if FTaskState = inTaskState then exit;

 if inTaskState = tsActive then
  FPauseEvent.SetEvent; //--- ��������� ������� "����� ��� ������� ������"

 FTaskState:= inTaskState;

 if FTaskState = tsPause then
  FPauseEvent.ResetEvent; //--- �������� ������� "����� ��� ������� ������"
}
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

procedure TTaskItem.thrSendInfoToView(inputString: WideString);
var
  cdsData: TCopyDataStruct;
  tmpHandle: THandle;
//  tmpString: WideString;
begin
  //������������� ��� ��� �������
  cdsData.dwData := CMD_SetMemoLine;
  cdsData.cbData := Length(PChar(inputString)) * sizeof(Char) + 1;
  GetMem(cdsData.lpData, cdsData.cbData);
  try
    StrPCopy(cdsData.lpData, PWChar(inputString));
    tmpHandle:= FindWindow(nil, PWChar(formMain.ClassName));
    //�������� ��������� � ���� �������� ������
//    PostThreadMessage(FindWindow(nil, PWChar(formMain.Caption)),
//    PostMessage(FindWindow(nil, PWChar(formMain.ClassName)),
    SendMessage(FindWindow(nil, PWChar(formMain.Caption)),
                  WM_COPYDATA, Handle, Integer(@cdsData));
  finally
    //������������ �����
    FreeMem(cdsData.lpData, cdsData.cbData);
  end;
end;

function TTaskItem.PrepareOutString(inTaskNumInList: word; inThreadInfo: WideString): WideString;
var
  tmpSingle: single;
  tmpInt: integer;
  tmpCardinal: cardinal;
  tmpString: WideString;
begin
{
 TaskList[TaskNum].GetCPUUsage(stSystemTimes);
 tmpSingle:= (stSystemTimes.UserTime/stSystemTimes.KernelTime)*100;
 tmpInt:= round(tmpSingle);
 tmpString:= GetTaskStateName(TaskList[TaskNum].TaskState);
 tmpCardinal:= TaskList[TaskNum].ThreadID;
 Result:= sHeaderThreadInfo + IntToStr(TaskNum) +  ': ' + TaskList[TaskNum].TaskName
          + ', ' + inThreadInfo
          + Format(' , TreadId: %6d | CPU usage(����.): %f | ����. - %s', [tmpCardinal, tmpSingle, tmpString]);

  sThreadInfoForView = sHeaderThreadInfo + ' %4d : %s, %s TreadId: %4d | CPU usage(����.): %f | ����. - %s';
}
// if self.FTaskCore. then

 tmpInt:= TaskList[TaskNum].FTaskSource.Task_Result.dwEqualsCount;

 tmpString:= GetTaskStateName(TaskList[TaskNum].TaskState);
 Result:= format(sThreadInfoForView,
                                    [inTaskNumInList,
                                     TaskList[TaskNum].TaskName,
                                     inThreadInfo,
                                     TaskList[TaskNum].ThreadID,
                                     round((self.FEndTickCount - self.FBeginTickCount)/1000), //������� �� 0...
                                     self.FInfoFromTask,  //--- ������ � ���������� ���������� (����������� ������ Execute ������
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
      //--- ����� ������� ����� ��������� �������� ���������� � ���� ������� �����
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

function TTaskItem.GetTaskStateName(inTaskState: TTaskState): WideString;
begin
 Result:= '';
 case TTaskState(ord(inTaskState)) of
   TTaskState(-1): Result:= aTaskStateName[0]; //'�� ����������';
   TTaskState(0):  Result:= aTaskStateName[1];
   TTaskState(1):  Result:= aTaskStateName[2];
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

//--- ������������ ��� �������
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
