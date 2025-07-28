unit unTools;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls,
  IOUtils, ActiveX, Vcl.AxCtrls, EncdDecd;

type
  TformTools = class(TForm)
    MainMenu1: TMainMenu;
    mFile: TMenuItem;
    miExit: TMenuItem;
    gbThread: TGroupBox;
    btnNewThread: TButton;
    lbTemplateTaskList: TListBox;
    gbExchangeType: TGroupBox;
    rbMessage_WMCoptData: TRadioButton;
    rbClientServer_udp: TRadioButton;
    gbLibraryList: TGroupBox;
    btnLoadLibrary: TButton;
    lbLibraryList: TListBox;
    odGetLibrary: TOpenDialog;
    Button1: TButton;
    procedure miExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNewThreadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbMessage_WMCoptDataClick(Sender: TObject);
    procedure btnLoadLibraryClick(Sender: TObject);
    procedure lbLibraryListClick(Sender: TObject);
    procedure SaveSettingsformTools(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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
uses unMain, unConst, unVariables, unTasks, unDM, unUtils, unUtilCommon;

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
    tmpIntrfDllAPI: ILibraryAPI;
    tmpIntrfTaskSource: ITaskSource;
    tmpDWord: DWORD;
begin
 try
//--- Настроим передачу информации от потоков в главное окно согласно выбранному типу

  //--- Назначение задачи (из списка доступных задач) новому потоку
  //--- 1. Создаём новый объект "Задача", затем помещаем его в массив объектов типа "Список Задач"
  //--- Порядковый номер библиотеки в Перечне библиотек и порядковый номер шаблона задачи точно соответствуют
  //--- их порядковым номерам в визуальных компонентах lbLibraryList и lbTemplateTaskList
  iTaskListNum:= TaskList.Add(TTaskItem.Create(LibraryList[lbLibraryList.ItemIndex].LibraryId, lbTemplateTaskList.ItemIndex, tsNotDefined));
  //--- Запись Id библиотеки (так как индексы задач в библиотеках нумеруются с 0 (не уникальны))
  //--- и текущего номера задачи (в текущем списке активных задач) в объект TaskItem
  TaskList[iTaskListNum].SetTaskNum(iTaskListNum);


  //--- 2. Создаём новый объект "Исходник Задачи", затем помещаем его в массив объектов типа "Список Исходников Задач" - нужна реализация каждого объекта, так как они будут выполняться в потоках
  try
   TaskList[iTaskListNum].SetTaskSource(LibraryList[lbLibraryList.ItemIndex].LibraryAPI.NewTaskSource(lbTemplateTaskList.ItemIndex));

//   tmpIntrfDllAPI:= LibraryList[lbLibraryList.ItemIndex].LibraryAPI;
//   tmpIntrfTaskSource:= LibraryList[lbLibraryList.ItemIndex].LibraryAPI.NewTaskSource(lbTemplateTaskList.ItemIndex);
//   tmpIntrfTaskSource:= tmpIntrfDllAPI.NewTaskSource(lbTemplateTaskList.ItemIndex);
//   TaskList[iTaskListNum].SetTaskSource(LibraryList[lbLibraryList.ItemIndex].LibraryAPI.NewTaskSource(lbTemplateTaskList.ItemIndex));
 //  TaskList[iTaskListNum].SetTaskSource(tmpIntrfTaskSource);

   TaskList[iTaskListNum].TaskSource.TaskMainModuleIndex:= iTaskListNum;
//   tmpIntrfTaskSource.TaskMainModuleIndex:= iTaskListNum;

//--- 2.1 Настройка потока передачи результатов из библиотек в главный модуль
   TaskList[iTaskListNum].Stream:= TOleStream.Create(TaskList[iTaskListNum].TaskSource.Task_ResultStream);
   TaskList[iTaskListNum].Stream.Position:= 0;

//--- Запускаем получение потока из задачи в библиотеке
   TaskList[iTaskListNum].StringStream:= TStringStream.Create;
   TaskList[iTaskListNum].StringStream.LoadFromStream(TaskList[iTaskListNum].Stream);
   DecodeStream(TaskList[iTaskListNum].StringStream, TaskList[iTaskListNum].StringStream); // двоичное дешиврование



  finally
   tmpIntrfDllAPI:= nil;
   tmpIntrfTaskSource:= nil;
  end;

//--- Запишем в лог событие - создание нового потока - Задачи
  WriteDataToLog(format(wsEvent_ThreadCreated, [iTaskListNum]), 'formTools.btnNewThreadClick()', 'unTools');


//--- 3. Добавляем "Новый Поток" в перечень потоков (комбобокс)
  formMain.lbThreadList.Items.Add(format(wsHeaderThreadInfo + '%3d: %s',
                                                              [iTaskListNum,
                                                              TaskList[iTaskListNum].TaskName]));

//--- 4. Назначим объекты для отображения информации от задач (потоков)
  TaskList[iTaskListNum].LineIndex_ForView:= formMain.memInfoThread.Lines.Add(sWaitForThreadAnswer);

  TaskList[iTaskListNum].HandleWinForView:= formMain.memInfoThread.Handle;
  GetWindowThreadProcessId(formMain.memInfoThread.Handle, @tmpDWord);
  TaskList[iTaskListNum].ThreadIDWinForView:= tmpDWord;

//--- Запускаем Задачу на выполнение
   TaskList[iTaskListNum].TaskState:= tsActive;
   TaskList[iTaskListNum].Suspended:= false;

 finally
   FreeAndNil(tmpIntrfDllAPI);
   FreeAndNil(tmpIntrfTaskSource);
 end;
end;

procedure TformTools.Button1Click(Sender: TObject);
begin
 if lbLibraryList.ItemIndex < 1 then
  exit;

 LibraryList[lbLibraryList.ItemIndex].Free;

 lbLibraryList.DeleteSelected;
end;

procedure TformTools.btnLoadLibraryClick(Sender: TObject);
var
 tmpItem, tmpItem1, tmpLibraryNum: word;
 tmpLibraryTask: TLibraryTask;

begin
  if (Sender as TObject).ClassType.ClassName = 'TButton' then
  begin
   odGetLibrary.Files.Clear;
   if TFile.Exists(sWorkDirectory) then
    odGetLibrary.InitialDir:= sWorkDirectory;
   if Not odGetLibrary.Execute(formTools.Handle) then Exit;
  end
  else
   LibraryList.Clear;

 try
//--- Временный объект "Описатель библиотеки"
//--- для получения информации о библиотеке
  tmpLibraryTask:= TLibraryTask.Create;
  for tmpItem:= 0 to odGetLibrary.Files.Count-1 do
  begin
//--- Создание объекта библиотек
//--- Индекс соответсвует индексу строки при получении списка реализуемых задач
//--- полученных через интерфейс DllAPI
     tmpLibraryNum:= LibraryList.Add(TLibraryTask.Create);
 //--- По номеру библиотеки с списке библиотек получим её наименование и список реализованных в ней функций
   GetLibraryInfo(odGetLibrary.Files.Strings[tmpItem], tmpLibraryNum);
 //--- Если наименование не получено от Dll, значит Dll "не наша", просто пропускаем её
   if LibraryList[tmpLibraryNum].LibraryName <> '' then
    begin
//     LibraryList[tmpLibraryNum]:= tmpLibraryTask;
 //--- Добавим библиотеку в список доступных библиотек в визуальном компоненте (ListBox)
     lbLibraryList.Items.Add(LibraryList[tmpLibraryNum].LibraryName);
    end
    else
     LibraryList[tmpLibraryNum].Clear;
 end;
 finally
  FreeAndNil(tmpLibraryTask);
 end;

 lbLibraryList.ItemIndex:= 0;
 lbLibraryList.OnClick(Sender);
end;

procedure TformTools.FormClose(Sender: TObject; var Action: TCloseAction);
var
  tmpWord: word;
begin
try

 formMain.miTools.Enabled:= true;
 SaveSettingsformTools(Sender);

 if TaskList.Count <1 then exit;

 for tmpWord:=0 to (TaskList.Count - 1) do
 begin
  if TaskList[tmpWord].GetTaskState = tsPause then
   TaskList[tmpWord].Suspended:= false;

  TaskList[tmpWord].SetTaskState(tsTerminate);
//  while not TaskList[i].IsTerminated do
//   sleep(300); //--- ждём завершения текущей щадачи
 end;

finally

end;

end;

procedure TformTools.FormCreate(Sender: TObject);
var
  tmpInt: integer;
  tmpString: WideString;
  tmpStrings: TStringList;
begin
try
 formTools.Height:= formMain.Height;
// TaskInitialize;
 iniFile.ReadBool(wsIniToolsTitle2, wsIniExchangeType_WMCopyData, true);
//--- Считывание библиотек из *.ini
 odGetLibrary.Files.Clear;
 tmpStrings:= TStringList.Create;
 tmpStrings.Clear;
 iniFile.ReadSection(wsIniToolsTitle1, tmpStrings);
 for tmpInt:= 0 to tmpStrings.Count - 1 do
 begin
  tmpString:= iniFile.ReadString(wsIniToolsTitle1, tmpStrings[tmpInt], '');
  if FileExists(tmpString) then
     odGetLibrary.Files.Add(tmpString)
  else
   if tmpString = '' then
    iniFile.DeleteKey(wsIniToolsTitle1, format(wsIniLibraryPath_Item, [tmpInt]));
 end;
 if odGetLibrary.Files.Count > 0 then
  formTools.btnLoadLibraryClick(Sender);
finally
  FreeAndNil(tmpStrings);
end;
end;

procedure TformTools.FormShow(Sender: TObject);
begin
 lbLibraryListClick(Sender);
end;

procedure TformTools.lbLibraryListClick(Sender: TObject);
var
  tmpItem: integer;
  tmpTaskTemplateIndex: integer;
  tmpLibraryTask: TLibraryTask;
begin
//--- Выведем список доступных в библиотеке задач в визуальный компонент (ListBox)
  lbTemplateTaskList.Clear;

  tmpTaskTemplateIndex:= lbLibraryList.ItemIndex;
  if tmpTaskTemplateIndex < 0 then exit;

  for tmpItem:= 0 to (LibraryList[tmpTaskTemplateIndex].TaskCount - 1) do
  begin
   lbTemplateTaskList.AddItem(LibraryList[tmpTaskTemplateIndex].TaskTemplateName[tmpItem], Sender);
  end;
end;

procedure TformTools.miExitClick(Sender: TObject);
begin
 Close;
end;

procedure TformTools.rbMessage_WMCoptDataClick(Sender: TObject);
begin
  if self.rbMessage_WMCoptData.Checked then
   begin
    DM.PrepareServerSetting(false);
    ModulsExchangeType:= etMessage_WMCopyData;
    formMain.sbMain.Panels[0].Text:= wsNameExchangeType_WMCopyData;
   end;

  if self.rbClientServer_udp.Checked then
   begin
    ModulsExchangeType:= etClientServerUDP;
    DM.PrepareServerSetting(true);
    //--- информация на статус бар выводится в DM.PrepareServerSetting
   end;


end;

procedure TformTools.SaveSettingsformTools(Sender: TObject);
var
  tmpInt: integer;
  tmpStrings: TStringList;
begin
try
//--- Сохрание настроек в .ini файле
//------------------------------------------------
 if not Assigned(iniFile) then
    exit;

 iniFile.WriteBool(wsIniToolsTitle2, wsIniExchangeType_WMCopyData, true);

//--- Удалим предыдудущие записи о библиотеках из *.ini for tmpWord:= 0 to lbLibraryList.Items.Count - 1 do
 tmpStrings:= TStringList.Create;
 iniFile.ReadSection(wsIniToolsTitle1, tmpStrings);
 for tmpInt:= 0 to tmpStrings.Count - 1 do
 begin
  iniFile.DeleteKey(wsIniToolsTitle1, tmpStrings[tmpInt]);
 end;

 if lbLibraryList.Items.Count < 1 then
  exit;
//--- Запишем в *.ini текущие библиотеки
 for tmpInt:= 0 to lbLibraryList.Items.Count - 1 do
 begin
  iniFile.WriteString(wsIniToolsTitle1, format(wsIniLibraryPath_Item, [tmpInt]), LibraryList[tmpInt].LibraryFileName);
 end;

finally
 FreeAndNil(tmpStrings);
end;
end;

//--- Подпрограммы вне классов -------------------------------------------------



end.
