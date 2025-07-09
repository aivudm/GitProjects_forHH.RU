unit unTools;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls, IOUtils;

type
  TformTools = class(TForm)
    MainMenu1: TMainMenu;
    mFile: TMenuItem;
    miExit: TMenuItem;
    tmCheckThreadReport: TTimer;
    gbThread: TGroupBox;
    btnNewThread: TButton;
    lbTemplateTaskList: TListBox;
    gbRxchangeType: TGroupBox;
    rbSynchronize: TRadioButton;
    rbClientServer_http: TRadioButton;
    gbLibraryList: TGroupBox;
    Button1: TButton;
    lbLibraryList: TListBox;
    odGetLibrary: TOpenDialog;
    procedure miExitClick(Sender: TObject);
    procedure tmCheckThreadReportTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNewThreadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbSynchronizeClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure lbLibraryListClick(Sender: TObject);
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
uses unMain, unConst, unVariables, unTasks, unDM, unUtils;

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
    iTaskListNum: word;
    iThreadNum: integer;
    pTaskSource: Pointer;
begin
 try
//--- Настроим передачу информации от потоков в главное окно согласно выбранному типу


  //--- Назначение задачи (из списка доступных задач) новому потоку
  //--- 1. Создаём новый объект "Задача" (сразу назначаем Исходник задачи), затем помещаем его в массив объектов типа "Список Задач"
  //--- Порядковый номер шаблона задачи точно соответствует порядковому номеру в визуальном компоненте lbTemplateTaskList
  iTaskListNum:= TaskList.Add(TTaskItem.Create(lbTemplateTaskList.ItemIndex, tsNotDefined));
  //--- 2. Создаём новый объект "Исходник Задачи", затем помещаем его в массив объектов типа "Список Исходников Задач" - нужна реализация каждого объекта, так как они будут выполняться в потоках
  TaskList[iTaskListNum].SetTaskNum(iTaskListNum);
  pTaskSource:= TaskList[iTaskListNum].InitTaskSource(lbTemplateTaskList.ItemIndex, iTaskListNum);
//  TaskList[iTaskListNum].SetTaskSource(pTaskSource); // перенесён внутрь TaskList[iTaskListNum].InitTaskSource
  //--- 3. Создаём новый объект "Поток", привязываем его к Задаче и запускаем его на выполнение
//  iThreadNum:= ThreadList.Add(TThreadType1.Create(iSelectedTask));

  TaskList[iTaskListNum].HandleWinForView:= formMain.memInfoTread.Handle;
  TaskList[iTaskListNum].LineIndex_ForView:= formMain.memInfoTread.Lines.Add('Ожидание ответа от потока...');
//  TaskList[iTaskNum].Resume; - Только для отработки, так как в реале запуск сразу после создания. Потом паузы и продолжение по событию FPauseEvent: TEvent;

  //--- 4. Добавляем "Новый Поток" в перечень потоков (комбобокс)
  AddNewItemToThreadList(sHeaderThreadInfo + IntToStr(iTaskListNum));   // Для более привычного восприятия номера (с 1-цы)

  tmCheckThreadReport.Enabled:= true;
  //--- После подготовки всех объектов присваиваем задаче состояние - tsActive
  TaskList[iTaskListNum].TaskState:= tsActive;

 finally

 end;
end;

procedure TformTools.Button1Click(Sender: TObject);
var
 tmpItem, tmpItem1, tmpDllProcNum: word;
 tmpString: string;
 tmpTaskDllProcName: TArray<string>;

begin
 if TFile.Exists(sWorkDirectory) then
  odGetLibrary.InitialDir:= sWorkDirectory;
 if Not odGetLibrary.Execute(formTools.Handle) then Exit;

 lbLibraryList.Clear;
 for tmpItem:= 0 to odGetLibrary.Files.Count-1 do
 begin

  tmpString:= GetDllLibraryNickName(odGetLibrary.Files.Strings[tmpItem]);
 //--- Если наименование не получено от Dll, значит Dll "не наша", просто пропускаем её
  if tmpString <> '' then
   begin
 //--- Добавим библиотеку в список доступных библиотек
    tmpDllProcNum:= LibraryTaskInfoList.Add(TLibraryTaskInfo.Create);




 //    lbLibraryList.Items.Add(tmpString);



 //--- Получим из библиотеки имена экспортируемых процедур
//    GetDLLExportList(odGetLibrary.Files.Strings[tmpItem], tmpTaskDllProcName);
//    LibraryTaskInfoList[tmpDllProcNum].TaskDllProcName:= tmpTaskDllProcName;
//--- Для отработки заполним вручную пока

    LibraryTaskInfoList[tmpDllProcNum].TaskDllProcName:= ['GetLibraryNickName', 'FileFinderByMask', 'FileFinderByPattern'];

 //--- Получим из библиотеки адреса процедур согласно наименованию
{
  for i:= (Low(LibraryTaskInfo.aTaskDllProcName)) to (High(LibraryTaskInfo.aTaskDllProcName)) do
  begin
   LibraryTaskInfo.:= ;
  end;
 }
   end;
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

  TaskList[i].SetTaskState(tsTerminate);
//  while not TaskList[i].IsTerminated do
//   sleep(300); //--- ждём завершения текущей щадачи
 end;

 formMain.miTools.Enabled:= true;
end;

procedure TformTools.FormCreate(Sender: TObject);
begin
// TaskInitialize;
end;

procedure TformTools.FormShow(Sender: TObject);
var
  i: byte;
begin
  for i:= (Low(aTemplateTaskNameArray) + 1) to (High(aTemplateTaskNameArray) + 1) do
  begin
   lbTemplateTaskList.AddItem(aTemplateTaskNameArray[i - 1], Sender);
  end;
end;

procedure TformTools.lbLibraryListClick(Sender: TObject);
var
  tmpItem: byte;
  tmpDllProcNum: word;
begin
//--- Выведем список доступных в библиотеке задач в визуальный компонент (ListBox)
  lbTemplateTaskList.Clear;
  tmpDllProcNum:= lbLibraryList.ItemIndex;
  for tmpItem:= 0 to (High(LibraryTaskInfoList[tmpDllProcNum].TaskDllProcName[tmpItem])) do
  begin
   lbTemplateTaskList.AddItem(LibraryTaskInfoList[tmpDllProcNum].TaskDllProcName[tmpItem], Sender);
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
