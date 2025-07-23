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
    procedure miExitClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNewThreadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbMessage_WMCoptDataClick(Sender: TObject);
    procedure btnLoadLibraryClick(Sender: TObject);
    procedure lbLibraryListClick(Sender: TObject);
    procedure SaveSettingsformTools(Sender: TObject);
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
  iTaskListNum:= TaskList.Add(TTaskItem.Create(lbLibraryList.ItemIndex, lbTemplateTaskList.ItemIndex, tsNotDefined));
  //--- Запись номера задачи в текущем списке активных задач в объект TaskItem
  TaskList[iTaskListNum].SetTaskNum(iTaskListNum);

  //--- 2. Создаём новый объект "Исходник Задачи", затем помещаем его в массив объектов типа "Список Исходников Задач" - нужна реализация каждого объекта, так как они будут выполняться в потоках
  tmpIntrfDllAPI:= LibraryList[lbLibraryList.ItemIndex].LibraryAPI;
  tmpIntrfTaskSource:= LibraryList[lbLibraryList.ItemIndex].LibraryAPI.NewTaskSource(lbTemplateTaskList.ItemIndex);
  TaskList[iTaskListNum].SetTaskSource(LibraryList[lbLibraryList.ItemIndex].LibraryAPI.NewTaskSource(lbTemplateTaskList.ItemIndex));
//  TaskList[iTaskListNum].SetTaskSource(tmpIntrfTaskSource);

  TaskList[iTaskListNum].TaskSource.TaskMainModuleIndex:= iTaskListNum;
//  tmpIntrfTaskSource.TaskMainModuleIndex:= iTaskListNum;
  tmpIntrfDllAPI:= nil;
  tmpIntrfTaskSource:= nil;

//--- 3. Добавляем "Новый Поток" в перечень потоков (комбобокс)
  formMain.lbThreadList.Items.Add(format(sHeaderThreadInfo + '%3d: %s',
                                                              [iTaskListNum,
                                                              TaskList[iTaskListNum].TaskName]));

//--- 4. Назначим объекты для отображения информации от задач (потоков)
//  formMain.memInfoTread.Lines.Add(sWaitForThreadAnswer);
//  formMain.memInfoTread.Lines[iTaskListNum]:= (sWaitForThreadAnswer);
  TaskList[iTaskListNum].LineIndex_ForView:= formMain.memInfoTread.Lines.Add(sWaitForThreadAnswer);

  TaskList[iTaskListNum].HandleWinForView:= formMain.memInfoTread.Handle;
  GetWindowThreadProcessId(formMain.memInfoTread.Handle, @tmpDWord);
  TaskList[iTaskListNum].ThreadIDWinForView:= tmpDWord;

  //--- После подготовки всех объектов присваиваем задаче состояние - tsActive
  TaskList[iTaskListNum].TaskState:= tsActive;

 finally

 end;
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
  end;

//--- Создание объекта библиотек
//--- состоит из: имени шаблона задачи и индекса задачи в библиотеке
//--- Индекс соответсвует индексу строки при получении списка реализуемых задач
//--- полученных через интерфейс DllAPI
  tmpLibraryNum:= LibraryList.Add(TLibraryTask.Create);
  tmpLibraryTask:= LibraryList[tmpLibraryNum];

 for tmpItem:= 0 to odGetLibrary.Files.Count-1 do
 begin
 //--- По номеру библиотеки с списке библиотек получим её наименование и список реализованных в ней функций
  GetLibraryInfo(odGetLibrary.Files.Strings[tmpItem], tmpLibraryTask);
 //--- Если наименование не получено от Dll, значит Dll "не наша", просто пропускаем её
  if tmpLibraryTask.LibraryName <> '' then
   begin
 //--- Добавим библиотеку в список доступных библиотек в визуальном компоненте (ListBox)
    lbLibraryList.Items.Add(tmpLibraryTask.LibraryName);
//--- Сохраним полный путь библиотеки в .ini файле
    if Assigned(iniFile) then
      iniFile.WriteString('formTools Settings', format('lbLibraryList_Item%d  ', [tmpItem]), odGetLibrary.Files.Strings[tmpItem]);
   end
   else
    LibraryList[tmpLibraryNum].Free;
 end;
 lbLibraryList.ItemIndex:= 0;
 lbLibraryList.OnClick(Sender);
end;

procedure TformTools.FormClose(Sender: TObject; var Action: TCloseAction);
var
  tmpWord: word;
begin
 if TaskList.Count <1 then exit;

 for tmpWord:=0 to (TaskList.Count - 1) do
 begin
  if TaskList[tmpWord].GetTaskState = tsPause then
   TaskList[tmpWord].Suspended:= false;

  TaskList[tmpWord].SetTaskState(tsTerminate);
//  while not TaskList[i].IsTerminated do
//   sleep(300); //--- ждём завершения текущей щадачи
 end;

 formMain.miTools.Enabled:= true;
 SaveSettingsformTools(Sender);

end;

procedure TformTools.FormCreate(Sender: TObject);
var
  tmpWord: word;
  tmpString: WideString;
begin
// TaskInitialize;
  odGetLibrary.Files.Clear;
  for tmpWord:= 0 to 100 {заведомо большое количество библиотек} do
  begin
   tmpString:= iniFile.ReadString('formTools Settings', format('lbLibraryList_Item%d  ', [tmpWord]), '');
   if tmpString <> '' then
    odGetLibrary.Files.Add(tmpString)
   else
   break;
  end;

  if odGetLibrary.Files.Count > 0 then
    formTools.btnLoadLibraryClick(Sender);
end;

procedure TformTools.FormShow(Sender: TObject);
begin
 lbLibraryListClick(Sender);
end;

procedure TformTools.lbLibraryListClick(Sender: TObject);
var
  tmpItem: integer;
  tmpTaskTemplateIndex: integer;
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
    formMain.sbMain.Panels[0].Text:= 'Режим: Message WM_CopyData';
   end;

  if self.rbClientServer_udp.Checked then
   begin
    ModulsExchangeType:= etClientServerUDP;
    DM.PrepareServerSetting(true);
    //--- информация на статус бар выводится в DM.PrepareServerSetting
   end;


end;

procedure TformTools.SaveSettingsformTools(Sender: TObject);
begin
try

 iniFile.WriteBool('formTools Settings', 'rbMessage_WMCoptData', true);

finally
end;
end;

//--- Подпрограммы вне классов -------------------------------------------------



end.
