unit unTools;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls, Contnrs,
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
    tmpInt: word;
    tmpIntrfDllAPI: ILibraryAPI;
    tmpIntrfTaskSource: ITaskSource;
    tmpWord: word;
begin
 try
  if lbTemplateTaskList.ItemIndex < 0 then
    exit;
//--- Настроим передачу информации от потоков в главное окно согласно выбранному типу

  //--- Назначение задачи (из списка доступных задач) новому потоку
  //--- 1. Создаём новый объект "Задача", затем помещаем его в массив объектов типа "Список Задач"
  //--- Порядковый номер библиотеки в Перечне библиотек и порядковый номер шаблона задачи точно соответствуют
  //--- их порядковым номерам в визуальных компонентах lbLibraryList и lbTemplateTaskList
  tmpInt:= TaskList.Add(TTaskItem.Create(lbLibraryList.ItemIndex, lbTemplateTaskList.ItemIndex, tsNotDefined));
  //--- Запись Id библиотеки (так как индексы задач в библиотеках нумеруются с 0 (не уникальны))
  //--- и текущего номера задачи (в текущем списке активных задач) в объект TaskItem
  TaskList[tmpInt].SetTaskNum(tmpInt);

  TaskList[tmpInt].MainModuleOwner:= GetCurrentThreadId;

  //--- 2. Создаём новый объект "Исходник Задачи", затем помещаем его в массив объектов типа "Список Исходников Задач" - нужна реализация каждого объекта, так как они будут выполняться в потоках
  //--- в TaskSource прописывается индекс задачи в библиотеке и он больше не может изменяться
  try
   TaskList[tmpInt].TaskCore:= TTaskCore.Create();
   TaskList[tmpInt].TaskCore.TaskItemOwner:= TaskList[tmpInt].GetTaskItem;   //--- передачей владельца в TaskCore
//--- Настроим ядро задачи на соответствующую задачу из библиотек
   tmpWord:= lbTemplateTaskList.ItemIndex;

//--- В TaskItem и TaskCore свои ссылки на объект TaskSource в библиотеке

   TaskList[tmpInt].SetTaskSource(LibraryList[lbLibraryList.ItemIndex].LibraryAPI.NewTaskSource(tmpWord, tmpInt));
   TaskList[tmpInt].TaskCore.SetTaskSource(LibraryList[lbLibraryList.ItemIndex].LibraryAPI.GetTaskSource(tmpInt));

//-------------------------------------------------------------------------------------------------------------------------------------
//   tmpIntrfDllAPI:= LibraryList[lbLibraryList.ItemIndex].LibraryAPI;
//   tmpIntrfTaskSource:= LibraryList[lbLibraryList.ItemIndex].LibraryAPI.NewTaskSource(lbTemplateTaskList.ItemIndex);
//   tmpIntrfTaskSource:= tmpIntrfDllAPI.NewTaskSource(lbTemplateTaskList.ItemIndex);
//   TaskList[iTaskListNum].SetTaskSource(LibraryList[lbLibraryList.ItemIndex].LibraryAPI.NewTaskSource(lbTemplateTaskList.ItemIndex));
 //  TaskList[iTaskListNum].SetTaskSource(tmpIntrfTaskSource);

 //????????????????????????????????????????
 //   TaskList[iTaskListNum].TaskCore.TaskSource.TaskMainModuleIndex:= iTaskListNum;
//   tmpIntrfTaskSource.TaskMainModuleIndex:= iTaskListNum;

//--- 2.1 Настройка потока передачи информации для журнала
//--- от задач (в библиотеках) в главный модуль
   TaskList[tmpInt].Stream_Log:= TOleStream.Create(TaskList[tmpInt].TaskSource.Stream_Log);
   TaskList[tmpInt].Stream_Log.Position:= 0;

//--- от ядра задачи в главный модуль
   TaskList[tmpInt].Stream_Core_Log:= TOleStream.Create(TaskList[tmpInt].TaskCore.TaskCoreStream_Log);
   TaskList[tmpInt].Stream_Core_Log.Position:= 0;

//--- Запускаем получение потока информации для журнала
//--- от задачи (в библиотеке)
   TaskList[tmpInt].StringStream_Log:= TStringStream.Create;
   TaskList[tmpInt].StringStream_Log.LoadFromStream(TaskList[tmpInt].Stream_Log);
   DecodeStream(TaskList[tmpInt].StringStream_Log, TaskList[tmpInt].StringStream_Log);

//--- от ядра задачи
   TaskList[tmpInt].StringStream_Core_Log:= TStringStream.Create('', TEncoding.ANSI); //--- При создании ядра не пишем в лог отдельное сообщение
   TaskList[tmpInt].StringStream_Core_Log.LoadFromStream(TaskList[tmpInt].Stream_Core_Log);
   DecodeStream(TaskList[tmpInt].StringStream_Core_Log, TaskList[tmpInt].StringStream_Core_Log);

//--- 2.2 Настройка потока передачи результатов от задач в главный модуль
   TaskList[tmpInt].Stream:= TOleStream.Create(TaskList[tmpInt].TaskSource.Stream_Result);
   TaskList[tmpInt].Stream.Position:= 0;

//--- Запускаем получение потока из задачи в библиотеке
   TaskList[tmpInt].StringStream:= TStringStream.Create;
   TaskList[tmpInt].StringStream.LoadFromStream(TaskList[tmpInt].Stream);
   DecodeStream(TaskList[tmpInt].StringStream, TaskList[tmpInt].StringStream);


  finally
   tmpIntrfDllAPI:= nil;
   tmpIntrfTaskSource:= nil;
  end;



//--- 3. Добавляем "Новый Поток" в перечень потоков (листбокс)
//--- 4. Назначим объекты для отображения информации от задач (потоков)
//--- Назначаем в визуальном компоненте номер строки для вывода расширенной информации о процессе выполнения задачи
//--- равной номеру строки самой задачи в списке задач
{  TaskList[tmpInt].LineIndex_ForView:=} formMain.lbThreadList.Items.AddObject(format(wsHeaderThreadInfo + ': %s',
                                                              [tmpInt,
                                                             TaskList[tmpInt].TaskName]), TaskList[tmpInt]);
//--- Так тоже работало всегда, но вернее логически второй вариант
{  TaskList[tmpInt].LineIndex_ForView:=} formMain.reThreadInfo_Main.Items.Add(sWaitForThreadAnswer);

  TaskList[tmpInt].SetInfo_ForViewing(Info_ForViewing);

//--- Помещаем информацию о потоке Задачи и потоке ядра задачи в хранилице ThreadID
//--- Для контроля ресурсов потоков
  setlength(ThreadStorList, length(ThreadStorList) + 1);
  ThreadStorList[length(ThreadStorList) - 1].cTask_ThreadId:= TaskList[tmpInt].ThreadID;
//--- Запускаем Задачу на выполнение
   TaskList[tmpInt].TaskState:= tsActive;
   TaskList[tmpInt].Suspended:= false;


 finally
   FreeAndNil(tmpIntrfDllAPI);
   FreeAndNil(tmpIntrfTaskSource);
 end;
end;

procedure TformTools.Button1Click(Sender: TObject);
begin
 if lbLibraryList.ItemIndex < 1 then
  exit;

// LibraryList[lbLibraryList.ItemIndex].Free;

 lbLibraryList.DeleteSelected;
end;

procedure TformTools.btnLoadLibraryClick(Sender: TObject);
var
 tmpInt: integer;
 tmpLibraryNum: word;
begin
  if (Sender as TObject).ClassType.ClassName = 'TButton' then
  begin
   odGetLibrary.Files.Clear;
   if TFile.Exists(sWorkDirectory) then
    odGetLibrary.InitialDir:= sWorkDirectory;
   if Not odGetLibrary.Execute(formTools.Handle) then
    Exit;

   for tmpInt:= 0 to odGetLibrary.Files.Count-1 do
   begin
    if IsLibraryAlreadeUsed(odGetLibrary.Files[tmpInt]) then
     odGetLibrary.Files.Delete(tmpInt);
   end;
  end
  else
   LibraryList.Clear;

 try
//--- Временный объект "Описатель библиотеки"
//--- для получения информации о библиотеке
  for tmpInt:= 0 to odGetLibrary.Files.Count-1 do
  begin
//--- Создание объекта библиотек
//--- Индекс соответсвует индексу строки при получении списка реализуемых задач
//--- полученных через интерфейс DllAPI
   tmpLibraryNum:= LibraryList.Add(TLibraryTask.Create);
 //--- По номеру библиотеки с списке библиотек получим её наименование и список реализованных в ней функций
   if GetLibraryInfo(odGetLibrary.Files.Strings[tmpInt], tmpLibraryNum) then
 //--- Если наименование не получено от Dll, значит Dll "не наша", просто пропускаем её
//    if LibraryList[tmpLibraryNum].LibraryName <> '' then
   begin
//     LibraryList[tmpLibraryNum]:= tmpLibraryTask;
 //--- Добавим библиотеку в список доступных библиотек в визуальном компоненте (ListBox)
    lbLibraryList.AddItem(LibraryList[tmpLibraryNum].LibraryName, LibraryList[tmpLibraryNum]);
   end
   else
    LibraryList.Remove(LibraryList[tmpLibraryNum]);
 end;
 finally
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
  tmpInt, tmpItem: integer;
  tmpTaskTemplateIndex: integer;
begin
//--- Выведем список доступных в библиотеке задач в визуальный компонент (ListBox)
 if lbLibraryList.ItemIndex < 0 then
  exit;

  lbTemplateTaskList.Clear;
  tmpTaskTemplateIndex:= lbLibraryList.ItemIndex;
  tmpInt:= LibraryList.IndexOf(lbLibraryList.Items.Objects[lbLibraryList.ItemIndex] as TLibraryTask);

  for tmpItem:= 0 to (LibraryList[tmpInt].TaskCount - 1) do
  begin
   lbTemplateTaskList.AddItem(LibraryList[tmpInt].TaskTemplateName[tmpItem], Sender);
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
