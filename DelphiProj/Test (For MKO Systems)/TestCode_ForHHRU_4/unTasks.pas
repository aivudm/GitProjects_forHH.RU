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
  TPeriodReport = 1..5000; // ����������� � ��

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
    FTaskNumInList: word;
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
    FOLEStream: IStream;  //--- ����� � "COM-�������" ��������� ����������� TStreamAdapter
    FLogStream: TStream;
    FLogStringStream: TStringStream;
    FLogStringStream_LastPos: DWORD;
    FOLELogStream: IStream;  //--- ����� � "COM-�������" ��������� ����������� TStreamAdapter
    FCycleTimeValue: word; // ����������������� ������ ���������� ����� � �� (�� ��������� 1000 ��)
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
    property TaskNum: word read FTaskNumInList;
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
    property LogStream: TStream read FLogStream write FLogStream;
    property LogStringStream: TStringStream read FLogStringStream write FLogStringStream;
    property LogStringStream_LastPos: DWORD read FLogStringStream_LastPos write FLogStringStream_LastPos;
    property Info_ForViewing: TInfo_ForViewing read GetInfo_ForViewing;
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
   protected
    FLibraryId: DWORD;
    FTaskTemplateId: word;
    FTaskProcedure: TTaskProcedure;
    procedure Execute; override;
   public
    constructor Create(); overload;
    procedure DoTerminate; overload;
    procedure SetTaskSource(intrfTaskSource: ITaskSource);
    property TaskSource: ITaskSource read FTaskSource write SetTaskSource;
    property LibraryId: DWORD read FLibraryId write FLibraryId;
    property TaskTemplateId: word read FTaskTemplateId write FTaskTemplateId;
    property TaskItemOwner: TTaskItem read FTaskItemOwner write FTaskItemOwner;

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
//---------- ������ ��� TTaskCore ----------------------------------------------
//------------------------------------------------------------------------------
constructor TTaskCore.Create();
begin
 inherited  Create(true); //--- true = ������� ������ ������ (��������� TaskItem)
 FreeOnTerminate:= false; //--- false - ��������� �������� - TaskItem (��������, ���������� ��� ������� ������ �� ���� �� ������)
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
 //--- ��� ������ (������������ �������� TaskItem) ����� ������ - tsActive
 repeat                                         //--- ����� ������� ������� ����� ������ tsDone � �������� �� ����������
                                                //--- ������ If �� �����, ���� �������� TaskItem �� ������ tsActive ��� tsTerminate

  if (not ((self.FTaskItemOwner.TaskState in [tsDone, tsAbortedDone])))
      and (not (self.TaskItemOwner.TaskState = tsPause))
      and (not (self.TaskItemOwner.TaskState = tsTerminate)) then
   begin

    try
     tmpCardinal:= self.ThreadID;
     FTaskSource.TaskProcedure; //--- ������ ������ ��� ������� � �������� �������� TaskSource ��� �������� ������
     if (self.FTaskItemOwner.TaskState = tsActive) and (not self.FTaskSource.AbortExecution) then //--- ���� ����� ���� �� ��������� ������, �� ��� ���� ������ ����������,
       self.FTaskItemOwner.TaskState:= tsDone         //--- ���� ������ ���������� (����� ��������� ����� FAbortExecution)
     else                                             //--- ��� ��������� ����� ��������� Task ���� �� tsTerminate
     begin
//--- ��� ��� ������ �������� (�����������), �� ���������� ������� � �������� ���������
//--- ���� ������������ ���������� ������
      self.FTaskSource.AbortExecution:= false;
     end;

    except
     tmpObject:= ExceptObject;
     tmpWideString:= Exception(tmpObject).Message;
//--- ���� ���������� ������� ������������� ��������� (�� ���������� ���������� ������), �� ������ ��� �������
//--- ������� ������������� ��������
     self.FTaskItemOwner.TaskState:= tsTerminate;
     self.FStringStream.WriteString(Exception(tmpObject).ClassName + ', E.Message = ' + tmpWideString + '(TTaskCore.Execute, unTasks)');
    end;
//--- ��������� ����� ����� ���������� ������
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
//--- ������� ������������� TaskItem � ����������
 self.DoTerminate; 
end;

end;
//------------------------------------------------------------------------------

procedure TTaskCore.DoTerminate;
var
  tmpString: WideString;
  E: Exception;
begin
 inherited;
try
 try
  self.FTaskItemOwner.TaskCoreState:= tsTerminate;
 except
  if Assigned(E) then
   begin
    WriteDataToLog(E.ClassName + ', E.Message = ' + E.Message, 'TTaskCore.OnTerminate', 'unTasks');
   end;
   raise Exception.Create(PAnsiChar(tmpString));
 end;
finally
 self.FTaskItemOwner:= nil;
 self.FTaskSource:= nil;

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
 FreeOnTerminate:= false;  //--- TaskItem ������������ ��� �������� ������ ��� ��� �������� ����������

//----- ��� ������ ������� ������ ������� ������ ������ ������ -----------------
 FBeginTickCount:= GetTickCount(); // "������" ��������
// FStopWatch := TStopwatch.StartNew; // ����� �������� (�������� � 10-� ������

 //--- � ���� ������������ �� ����� �� ���������
 FLibraryId:= TaskLibraryId; // ���������� ����� ���������� (�� ������ �� ���������)
 FTaskTemplateId:= TaskTemplateId; // ����� ������-������� �� ������� aTaskNameArray
 FTaskName:= LibraryList[TaskLibraryId].TaskTemplateName[TaskTemplateId];

 Priority:= tpLower; //tpNormal; ���� ����� ������ ��������� � �������� � �����
// self.FDSiTimer.Interval:= TaskList[TaskItemNum].GetPeriodReport;
 FPeriodReport:= iTaskPeriodReport; //--- �����������
 FCycleTimeValue:= iCycleTimeValue; //--- ������������ ����� ������ ������ ����������� ����� ������� �� 1/4 ���������� ������ + 3/4 �� ����� + �������

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

//--- ��������� �������� ��� ������ (���������� �� �����)
 FStringStream_LastPos:= 0;
//--- �������� ��������� ������, ������� ������ �� ����� ������ ������������
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
begin
try
 if Assigned(self) then
 begin
  FreeAndNil(self.FTaskCore);
 end;
except
 if Assigned(E) then
  begin
   self.FLogStringStream.WriteString(E.ClassName + ', E.Message = ' + E.Message + ' (TTaskItem.OnTerminate, unTasks)');
  end;
  raise Exception.Create(PAnsiChar(E.ClassName + ', E.Message = ' + E.Message));
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
begin
try  //--- finally
//--- ������ ����� ������ "���� ��������� ������" - ��� ��������� ����������� ���������� �������
//--- ������ ��� � ������� ������, ��� ��� ���� ������ "�����������" TaskItem, ������� ���������� ��������
//--- "callback pump" ��� TaskSource, ������� �������� � ����������
try  //--- except
 self.TaskCoreState:= tsActive;
 self.FTaskCore.Start;
 tmpInt64:= 0;
//--- ������� � ������ ���������� ������� ID ������ TaskCore (���������  ��� TaskItem)
try
 ThreadStorList[length(ThreadStorList) - 1].cTaskCore__ThreadId:= TaskList[self.FTaskNumInList].TaskCore.ThreadID;
finally

end;

//--- ������� � ��� ������� - �������� ������ ������ - ������
 WriteDataToLog(format(wsEvent_ThreadCreated, [self.FTaskNumInList,
                                                TaskList[self.FTaskNumInList].ThreadID,
                                                TaskList[self.FTaskNumInList].TaskCore.ThreadID]),
                        'formTools.btnNewThreadClick()', 'unTools');
//--- ��� ��������� (������� �����...)
 try
  tmpStreamWriter:= TFile.AppendText('D:\Install\ThreadList.txt');
  tmpStreamWriter.WriteLine(format(wsEvent_ThreadCreated, [self.FTaskNumInList,
                                                TaskList[self.FTaskNumInList].ThreadID,
                                                TaskList[self.FTaskNumInList].TaskCore.ThreadID]));
 finally
  FreeAndNil(tmpStreamWriter);
 end;
//---

// �������� ������ ������� ������ ���� ������� ������ (������)
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
       sleep(round(FCycleTimeValue*iTaskBoreHole)); // 5�� - �� ���������� ������ � ����������
                             // 95 - ����� ����������� ���� (����) � sleep
                             // ��� �������� ������������� �������������� ������� ���������� ������

//--- ��������� ������� ����� (��� ������ �� �����)
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
       self.FTaskCore.TaskState:= tsTerminate; //--- ����� �������� ���� � TaskCore.Execute;
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

//--- ����� � �������� � ����������� � ������� ������ ����� self.PeriodReport (��)
   if ((GetTickCount - tmpInt64) > self.PeriodReport) and (self.TaskState <> tsTerminate) then
   begin
//--- ��� ������ ������, ����� ������ ������������� ���������� �� ������ � ���������� � ���������� ����������� �������� ������
//--- ��� ������ ������� ���������� ����� ���� ���������� (������) OutInfo_ForViewing
    try
      CriticalSection.Enter;

      FInfo_ForViewing.IndexInViewComponent:= self.FLineIndex_ForView;
      FInfo_ForViewing.TextForViewComponent:= self.InfoFromTask;

//--- ������������ �������� ���������� ���������� ������
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

//--- ����� ���������� � �������� ��������� ������ � �������������� ���������� �� ������
     if TaskState in [tsActive, tsDone, tsAbortedDone] then
     begin
//--- �������� ����� (c ��������� ����������� � ������) ������ ��� ����������
       case ModulsExchangeType of
        etMessage_WMCopyData:
         SendReportToMainProcess;
        etClientServerUDP:
         SendReportToMainProcess;
       end;

//--- ���������� �������������� ����������, ���������� �� ������
      if FInfo_ForViewing.CurrentViewingTask = self.FTaskNumInList then
      begin
       if self.StringStream_LastPos < self.Stream.Position then
       begin
          PostMessage(FInfo_ForViewing.hMemoThreadInfo_1, WM_Data_Update, self.FTaskNumInList, CMD_SetMemoStreamUpd);
       end;
      end;
     end;

    finally
      CriticalSection.Leave;
    end;

    tmpInt64:= GetTickCount;
   end;

 sleep(round(FCycleTimeValue*(iCycleTimeValue*(1 - iTaskBoreHole)))); // 15�� - ����� ����������� ���� (����) � sleep
                                     // ��� ���������� �������� ���������� ��������������� ��������� (��������, �������������) - - TaskItem
                                     // �������� �������� ����������� � TaskCore -
 until (self.TaskState = tsTerminate) and (self.TaskCoreState = tsTerminate);

except
end;

finally
//--- ������� ���������� ��������� �� ������������ ��������� �������� - TaskCore
//--- � ������, ���� ���� �������������� ��������, �� � ������ ����� TaskCore ����� ��� ������������
 if self.TaskCoreState <> tsTerminate then
 begin
 //--- �������� ����� TaskCore �� ��������
  self.FTaskCore.TaskState:= tsTerminate; //--- ����� �������� ���� � TaskCore.Execute;
  if not self.FTaskSource.AbortExecution  then
   self.FTaskSource.AbortExecution:= true;
  if self.FTaskCore.Priority <> tpNormal then self.FTaskCore.Priority:= tpNormal;
  if self.FTaskCore.Suspended then self.FTaskCore.Suspended:= false;
  sleep(iCycleTimeValue);
  if self.TaskCoreState <> tsTerminate then
  begin
//--- ����� �� �������� - �������� ���������� � TaskSource

  end;
 end;
//--- ������������ ������� TaskCore (��� ������������ � ����� �������)
 FTaskCore.WaitFor;
 FreeAndNil(FTaskCore);


//--- ������������ ������� ��������� ������ (TaskSource) (�� ������� ����������)
 try
  LibraryList[self.FLibraryId].LibraryAPI.FreeTaskSource(self.FTaskNumInList);
 finally
//--- �� ������ ������ ������� ������������� ������������� ����� ���������� ������
//--- ������������ ������� ���� ������ (�� ������� �������� ������)
// if Assigned(self.FTaskCore) then
//  FreeAndNil(self.FTaskCore);
 end;

end;
self.OnTerminate(self);
//  FreeAndNil(self.FTaskSource);
FreeAndNil(self.FPauseEvent);
FreeAndNil(self.FStream);
FreeAndNil(self.FStringStream);
FreeAndNil(self.FOLEStream);
FreeAndNil(self.FClientUDP);
FreeAndNil(self.FLogStream);
FreeAndNil(self.FLogStringStream);
FreeAndNil(self.FOLELogStream);

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

//------------ ������������ TTaskItem.SendReportToMainProcess ------------------
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
    //�������� ��������� � ���� �������� ������
//    PostThreadMessage(FindWindow(nil, PWChar(formMain.Caption)),
//    PostMessage(FindWindow(nil, PWChar(formMain.ClassName)),
    SendMessage(tmpHandle,
                  WM_COPYDATA, Handle, Integer(@cdsData));
  finally
    FreeMem(cdsData.lpData, cdsData.cbData);
  end;
end;
//------------------------------------------------------------------------------


//--------------- ������ TTaskItem.SendReportToMainProcess ---------------------
begin
//--- ������������ ��������� ������ ������
 if (TaskList.Count < 1) then
 begin
  exit;
 end;

 tmpInt:= TaskList[TaskNum].FTaskSource.Task_Result.dwEqualsCount;

// tmpWideString:= GetTaskStateName(TaskList[TaskNum].TaskState);
 tmpWideString:= format(sThreadInfoForView,
                                    [self.TaskNum,
                                     self.TaskName,
                                     '???',
                                     self.ThreadID,
                                     round((self.FEndTickCount - self.FBeginTickCount)/1000), //������� �� 0...
                                     self.FInfoFromTask,  //--- ������ � ���������� ���������� (����������� ������ Execute ������
                                     GetTaskStateName(self.TaskState)]); //GetTaskStateName(TaskList[TaskNum].TaskState)]);

//------------------------------------------------------------------------------
    FInfo_ForViewing.TextForViewComponent:= AnsiString(tmpWideString);
    FInfo_ForViewing.TextForViewComponent:= format(sDelimiterNumTask + '%d' + sDelimiterNumTask,
                                                      [FInfo_ForViewing.IndexInViewComponent]) + FInfo_ForViewing.TextForViewComponent;

    case ModulsExchangeType of
     etMessage_WMCopyData:
     begin
      //--- ����� ������� ����� ��������� �������� ���������� � ���� ������� �����
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

end;


function TTaskItem.GetTaskStateName(inTaskState: TTaskState): WideString;
begin
 Result:= '';
 case TTaskState(ord(inTaskState)) of
   TTaskState(-1): Result:= aTaskStateName[0]; //'�� ����������';
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
 TaskList:= TTaskList.Create(true); //--- false = TaskList �� ����� ������� ����������� ��������� � ��� �� ��������� �� ������ ��� �������� �� ������.
//--- TaskList.OwnsObjects:= false;  //--- ������� ������� ��������� ���������� ��������������� TThread ����� ����������, ������� � �� ����, ��� �� �������� ������� ��� ���������
 FileList:= TFileList.Create(true);
 CriticalSection:= TCriticalSection.Create();

finalization

// if Assigned(TaskList) then TaskList.Free;
// if Assigned(FileList) then FileList.Free;
// if Assigned(CriticalSection) then CriticalSection.Free;

end.
