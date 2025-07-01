unit unTools;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TformTools = class(TForm)
    MainMenu1: TMainMenu;
    mFile: TMenuItem;
    miExit: TMenuItem;
    tmCheckThreadReport: TTimer;
    gbThread: TGroupBox;
    btnNewThread: TButton;
    lbTaskList: TListBox;
    gbRxchangeType: TGroupBox;
    rbSynchronize: TRadioButton;
    rbClientServer_http: TRadioButton;
    procedure miExitClick(Sender: TObject);
    procedure tmCheckThreadReportTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNewThreadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbSynchronizeClick(Sender: TObject);
  private
    { Private declarations }
    procedure WMWINDOWPOSCHANGING(var Msg: TWMWINDOWPOSCHANGING); message WM_WINDOWPOSCHANGING;
  public
    { Public declarations }
  end;

var
  formTools: TformTools;


implementation

{$R *.dfm}
uses unMain, unConst, unVariables, unTasks, unDM;

procedure TformTools.WMWindowPosChanging(var Msg: TWMWindowPosChanging);
begin
 inherited;
 if not Application.Terminated  then
 begin
  Msg.WindowPos.x:= formMain.Left + formMain.Width;
  Msg.WindowPos.y:= formMain.Top;
 end;

end;

procedure TformTools.btnNewThreadClick(Sender: TObject);
 var
    iTaskNum: byte;
    iThreadNum: integer;
    pTaskSource: Pointer;
begin
 try
//--- Настроим передачу информации от потоков в главное окно согласно выбранному типу


  //--- Назначение задачи (из списка доступных задач) новому потоку
  //--- 1. Создаём новый объект "Задача" (сразу назначаем Исходник задачи), затем помещаем его в массив объектов типа "Список Задач"
  iTaskNum:= TaskList.Add(TTaskItem.Create(lbTaskList.ItemIndex, tsActive));
  //--- 2. Создаём новый объект "Исходник Задачи", затем помещаем его в массив объектов типа "Список Исходников Задач" - нужна реализация каждого объекта, так как они будут выполняться в потоках
  TaskList[iTaskNum].SetTaskNum(iTaskNum);
  pTaskSource:= TaskList[iTaskNum].InitTaskSource(lbTaskList.ItemIndex, iTaskNum);
  TaskList[iTaskNum].SetTaskSource(pTaskSource);
  //--- 3. Создаём новый объект "Поток", привязываем его к Задаче и запускаем его на выполнение
//  iThreadNum:= ThreadList.Add(TThreadType1.Create(iSelectedTask));

  TaskList[iTaskNum].HandleWinForView:= formMain.memInfoTread.Handle;
  TaskList[iTaskNum].LineIndex_ForView:= formMain.memInfoTread.Lines.Add('Ожидание ответа от потока...');
//  TaskList[iTaskNum].Resume; - Только для отработки, так как в реале запуск сразу после создания. Потом паузы и продолжение по событию FPauseEvent: TEvent;

  //--- 4. Добавляем "Новый Поток" в перечень потоков (комбобокс)
  AddNewItemToThreadList(sHeaderThreadInfo + IntToStr(iTaskNum));   // Для более привычного восприятия номера (с 1-цы)

  tmCheckThreadReport.Enabled:= true;

 finally

 end;
end;

procedure TformTools.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: word;
begin
 tmCheckThreadReport.Enabled:= false;
 for i:=0 to (TaskList.Count - 1) do
 begin
  if TaskList[i].GetTaskState = tsPause then
   TaskList[i].Suspended:= false;

  if TaskList[i].GetTaskState = tsPause then
   TaskList[i].Suspended:= false;

  TaskList[i].SetTaskState(tsTerminate);
//  while not TaskList[i].IsTerminated do
//   sleep(300); //--- ждём завершения текущей щадачи
 end;

end;

procedure TformTools.FormCreate(Sender: TObject);
begin
// TaskInitialize;
end;

procedure TformTools.FormShow(Sender: TObject);
var
  i: byte;
begin
  for i:= (Low(aTaskNameArray) + 1) to (High(aTaskNameArray) + 1) do
  begin
   lbTaskList.AddItem(aTaskNameArray[i - 1], Sender);
  end;
end;

procedure TformTools.miExitClick(Sender: TObject);
begin
 Close;
end;

procedure TformTools.rbSynchronizeClick(Sender: TObject);
begin
  if self.rbSynchronize.Checked then
   begin
    DM.PrepareServerSetting(false);
    ExchangeType:= etSynchronize;
    formMain.sbMain.Panels[0].Text:= 'Режим: TThread.Synchronize';
   end
  else
   begin
    ExchangeType:= etClientServerUDP;
    DM.PrepareServerSetting(true);
   end;
end;

procedure TformTools.tmCheckThreadReportTimer(Sender: TObject);
var
  i: Integer;
  tmpTaskItem: TTaskItem;
begin
 tmCheckThreadReport.Enabled:= false;
// for i := Low(TaskList) to High(TaskList) do
 for i:=0 to (TaskList.Count - 1) do
 begin
  if TaskList[i].GetTaskState = tsActive  then
   TaskList[i].CheckReportTime(TaskList[i]);
 end;
  tmCheckThreadReport.Enabled:= true;
end;


//--- Подпрограммы вне классов -------------------------------------------------



end.
