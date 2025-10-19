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
    tmpInt, tmpInt1: integer;
    tmpIntrfDllAPI: ILibraryAPI;
    tmpIntrfTaskSource: ITaskSource;
    tmpWord: word;
    tmpDWord: DWORD;
begin
 try
  if lbTemplateTaskList.ItemIndex < 0 then
    exit;

  if (tmpInt < 0) or (formMain.lbThreadList.Items.Count <> TaskList.Count) then //--- Проверка: кол-во элементов в Листбоксе будет равно кол-ву задач в перечне задач?
  begin
   showmessage(wsError_TaskItemCantViewed);
   exit;
  end;

//--- Настроим передачу информации от потоков в главное окно согласно выбранному типу
  //--- Назначение задачи (из списка доступных задач) новому потоку
  //--- 1. Создаём новый объект "Задача", затем помещаем его в массив объектов типа "Список Задач"
  //--- Порядковый номер библиотеки в Перечне библиотек и порядковый номер шаблона задачи точно соответствуют
  //--- их порядковым номерам в визуальных компонентах lbLibraryList и lbTemplateTaskList
  tmpInt:= GetNextTaskNum; //--- Далее работа идёт с tmpInt

  tmpWord:= TaskList.Add(TTaskItem.Create(lbLibraryList.ItemIndex, lbTemplateTaskList.ItemIndex, tmpInt, tsNotDefined));  //--- создаём новый элемент-пустышку списка задач
  tmpInt:= tmpWord;
//--- Установка параметра "Владелец задачи" - у всех задач владелец главный модуль
  TaskList[tmpInt].MainModuleOwner:= MainModuleThreadId; //GetCurrentThreadId;

  try
//--- Добавляем "Новую Задачу" в перечень задач (потоков - Thread) (листбокс)
  tmpInt:= formMain.lbThreadList.Items.AddObject(format(wsHeaderThreadInfo + ': %s',
                                             [tmpInt,
                                             lbTemplateTaskList.Items[lbTemplateTaskList.ItemIndex] {TaskList[tmpInt].TaskName}]), TaskList[tmpInt]);

//--- Назначим объекты для отображения информации от задач (потоков)
//--- равной номеру строки самой задачи в списке задач (Листбокс)
{  TaskList[tmpInt].LineIndex_ForView:=}
   if formMain.reThreadInfo_Main.Items.Count = (formMain.lbThreadList.Count - 1)  then //--- В перечне пока на 1 больше элементов (так должно быть)
   begin
//--- Добавить новую строку в визуальном компоненте для вновь созданной задачи
    formMain.reThreadInfo_Main.Items.Add(sWaitForThreadAnswer);
    TaskList[tmpInt].SetInfo_ForViewing(Info_ForViewing);
   end
   else
   begin
    formMain.lbThreadList.Items.Delete(formMain.lbThreadList.Items.Count - 1);
    DeleteTask(tmpInt);
    showmessage(wsError_TaskItemCantViewed);
    exit;
   end;


  finally
   tmpIntrfDllAPI:= nil;
   tmpIntrfTaskSource:= nil;
  end;



//--- Так тоже работало всегда, но вернее логически второй вариант
{  TaskList[tmpInt].LineIndex_ForView:=}


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
 if lbLibraryList.ItemIndex < 0 then
  exit;

// LibraryList[lbLibraryList.ItemIndex].Free;

 if not DeleteLibraryFromList(lbLibraryList.Items[lbLibraryList.ItemIndex]) then
 begin
  showmessage(format(wsError_LibraryItemNotDeleted, [lbLibraryList.Items[lbLibraryList.ItemIndex]]));
  exit;
 end;
 lbTemplateTaskList.Clear;
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
    if IsLibraryAlreadyUsed(odGetLibrary.Files[tmpInt]) then
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
   begin
    LibraryList.Remove(LibraryList[tmpLibraryNum]);
   end;
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
