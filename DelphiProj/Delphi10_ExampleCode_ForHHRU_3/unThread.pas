unit unThread;

interface
uses
  System.Classes, Vcl.ExtCtrls,
  unVariables, unTasks;

type

  TTypeInfoUpdatePeriod = word;

  ThreadType1 = class(TThread)
  private
//    FTreadPriority: TTreadPriority;
    FInfoUpdatePeriod: TTypeInfoUpdatePeriod;
    FTimer: TTimer;
    procedure thrSendInfoTpView;
  protected
    FCurrentTaskItem: TTaskItem;
    procedure Execute; override;
  public
    constructor Create(); overload;
    constructor Create(TaskItemId: byte; InfoUpdatePeriod: TTypeInfoUpdatePeriod); overload;
    property InfoUpdatePeriod: TTypeInfoUpdatePeriod read FInfoUpdatePeriod;
    procedure SetInfoUpdatePeriod(InfoUpdatePeriod: TTypeInfoUpdatePeriod);
  end;

 TListOfThread = array [1..10] of ThreadType1;

 procedure Calc_NOP(TaskItemIndex: byte);
// procedure Calculate_Dummy();
 procedure Calculate_Dummy(TaskItemIndex: byte);
 procedure Calculate_Pi_Gauss(TaskItemIndex: byte);

 var
    ListOfThread: TListOfThread;

implementation

constructor ThreadType1.Create();
begin
 inherited;
 //--- В этом конструкторе всё выдаём по умолчанию
 FCurrentTaskItem:= TaskList[1];
 FInfoUpdatePeriod:= 1000; //--- По умолчанию 1000 мс
 self.FreeOnTerminate:= true;
 self.Priority:= TThreadPriority(FCurrentTaskItem.TaskOSPriority);
end;

constructor ThreadType1.Create(TaskItemId: byte; InfoUpdatePeriod: TTypeInfoUpdatePeriod);
begin
 inherited Create();
 FInfoUpdatePeriod:= InfoUpdatePeriod;
 self.FreeOnTerminate:= true;
 self.Priority:= TThreadPriority(FCurrentTaskItem.TaskOSPriority);
end;

procedure ThreadType1.SetInfoUpdatePeriod(InfoUpdatePeriod: TTypeInfoUpdatePeriod);
begin

end;

procedure ThreadType1.Execute;
var
  CurProc: TTaskProcedure;
begin
  NameThreadForDebugging('Name_ThreadTest1');
  { Place thread code here }
  if Assigned(self.FCurrentTaskItem.TaskExecProcedure) then
   begin
    CurProc:= self.FCurrentTaskItem.TaskExecProcedure;
    asm
      call CurProc
    end;
    Synchronize(thrSendInfoTpView);
   end;
end;

procedure ThreadType1.thrSendInfoTpView;
begin
 formMain.memInfoTread.Text:= 'Поток ?: 11111111111111111111111';
end;




//------------------------------------------------------------------------------
//------ Задачи для потоков ----------------------------------------------------
//------------------------------------------------------------------------------

 procedure Calc_NOP(TaskItemIndex: byte);
 begin
   //--- Заглушка (пустышка), например для "затыкания№, если что-то погло не так в консипукторе TaskItem
 end;

 procedure Calculate_Dummy(TaskItemIndex: byte);
 var
  i, CycleCount: Int64;
  maxValue: Int64;
  ts: TTaskStatus;
 begin
  maxValue:= 100000; //exp(6*ln(10));
  repeat
   for i:=1 to maxValue do
   begin

   end;

   TaskList.Items[TaskItemIndex].FTaskOutParan:= i;
   ts:= TaskList.Items[TaskItemIndex].TaskStatus;

  until Integer(ts) = 0;

 end;

 procedure Calculate_Pi_Gauss(TaskItemIndex: byte);
var
  Sign: integer;
  PiValue, PiValue_Pred: Extended;
  i: Int64;
 begin
  PiValue:= 4;
  Sign:= -1;
 end;




end.
