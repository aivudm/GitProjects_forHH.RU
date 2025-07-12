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
  //--- 1. Создаём новый объект "Задача", затем помещаем его в массив объектов типа "Список Задач"
  //--- Порядковый номер библиотеки в Перечне библиотек и порядковый номер шаблона задачи точно соответствуют
  //--- их порядковым номерам в визуальных компонентах lbLibraryList и lbTemplateTaskList
  iTaskListNum:= TaskList.Add(TTaskItem.Create(lbLibraryList.ItemIndex, lbTemplateTaskList.ItemIndex, tsNotDefined));
  //--- 2. Создаём новый объект "Исходник Задачи", затем помещаем его в массив объектов типа "Список Исходников Задач" - нужна реализация каждого объекта, так как они будут выполняться в потоках
  TaskList[iTaskListNum].SetTaskNum(iTaskListNum);
  pTaskSource:= TaskList[iTaskListNum].InitTaskSource(lbLibraryList.ItemIndex, lbTemplateTaskList.ItemIndex, iTaskListNum);
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
 tmpItem, tmpItem1, tmpLibraryNum: word;
 tmpLibraryTask: TLibraryTask;

begin
 if TFile.Exists(sWorkDirectory) then
  odGetLibrary.InitialDir:= sWorkDirectory;
 if Not odGetLibrary.Execute(formTools.Handle) then Exit;

 lbLibraryList.Clear;

 for tmpItem:= 0 to odGetLibrary.Files.Count-1 do
 begin

//--- Создание объекта информации для библиотеки (каждой)
//--- состоит из: имени шаблона задачи и индекса задачи в библиотеке
//--- Индекс соответсвует индексу строки при получении списка реализуемых задач
//--- полученных через интерфейс DllAPI
  tmpLibraryNum:= LibraryList.Add(TLibraryTask.Create);
  tmpLibraryTask:= LibraryList[tmpLibraryNum];
 //--- Пр имени файла библиотеки (DLL) получим её наименование и список реализованных функций
//    Список реализованных функций возвращается в переменную -  tmpTaskDllProcName);
  GetLibraryInfo(odGetLibrary.Files.Strings[tmpItem], tmpLibraryTask);
 //--- Если наименование не получено от Dll, значит Dll "не наша", просто пропускаем её
  if tmpLibraryTask.LibraryName <> '' then
   begin
 //--- Добавим библиотеку в список доступных библиотек в визуальном компоненте (ListBox)
    lbLibraryList.Items.Add(AnsiString(tmpLibraryTask.LibraryName));

//   LibraryTaskInfoList[tmpLibraryNum].TaskTemplateName:= tmpTaskTemplateName;

//--- Для отработки заполним вручную пока
//     LibraryTaskInfoList[tmpDllProcNum].TaskDllProcName:= ['GetLibraryNickName', 'FileFinderByMask', 'FileFinderByPattern'];

 //--- Получим из библиотеки адреса процедур согласно наименованию
{
  for i:= (Low(LibraryTaskInfo.aTaskDllProcName)) to (High(LibraryTaskInfo.aTaskDllProcName)) do
  begin
   LibraryTaskInfo.:= ;
  end;
 }
   end;
 end;

{
//--- Заполним элементы ListBox (Перечень библиотек) согласно перечня библиотек
//--- Первый элемент пропускаем, так как это функция получения наименование самой библиотеки
  for tmpItem:= 1 to (High(LibraryTaskInfoList[tmpDllProcNum].TaskDllProcName)) do
  begin
   lbLibraryList.Items.Add(LibraryTaskInfoList[tmpDllProcNum].TaskDllProcName[tmpItem]);
  end;
}
//  lbLibraryList.ItemIndex:= 0;
//  lbLibraryList.OnClick(Sender);

end;

procedure TformTools.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: word;
begin
 tmCheckThreadReport.Enabled:= false;
 if TaskList.Count <1 then exit;
 
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
  tmpTaskTemplateIndex: Byte;
begin
//--- Выведем список доступных в библиотеке задач в визуальный компонент (ListBox)
  lbTemplateTaskList.Clear;

  tmpTaskTemplateIndex:= lbLibraryList.ItemIndex;
  if tmpTaskTemplateIndex < 0 then exit;

//--- Считаем с 1, так как первый элемент пропускаем - это всегда имя библиотеки
  for tmpItem:= 0 to LibraryList[tmpTaskTemplateIndex].TaskCount do
  begin
   lbTemplateTaskList.AddItem(LibraryList[tmpTaskTemplateIndex].TaskTemplateName[tmpItem], Sender);
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
