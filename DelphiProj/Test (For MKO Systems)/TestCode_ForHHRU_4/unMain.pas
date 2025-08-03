unit unMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, ActiveX, Vcl.AxCtrls, Vcl.ExtCtrls,
  Vcl.Menus, IOUtils, Types, DateUtils, IdGlobal, EncdDecd,
  unConst;

const
  wsAllMask: WideString = '*';
  ItemDelemiter = ';';
  wsBeginMask: WideString = '*.';

type

  TformMain = class(TForm)
    MainMenu1: TMainMenu;
    miFile: TMenuItem;
    miExit: TMenuItem;
    miSetting: TMenuItem;
    miAbout: TMenuItem;
    miTools: TMenuItem;
    GroupBox1: TGroupBox;
    memThreadInfo_1: TMemo;
    lbThreadList: TListBox;
    bThreadPause: TButton;
    bThreadStop: TButton;
    sbMain: TStatusBar;
    N1: TMenuItem;
    reThreadInfo_Main1: TRichEdit;
    Label1: TLabel;
    Label2: TLabel;
    memLogInfo_2: TMemo;
    bThreadDelete: TButton;
    N2: TMenuItem;
    reThreadInfo_Main: TMemo;
    procedure miToolsClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure lbThreadListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bThreadPauseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbThreadListClick(Sender: TObject);
    procedure lbThreadListKeyPress(Sender: TObject; var Key: Char);
    procedure N1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bThreadStopClick(Sender: TObject);
    procedure memThreadInfo_1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bThreadDeleteClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
  private
    { Private declarations }
    procedure WMWindowPosChanging(var Msg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
    procedure WMCopyData(var MessageData: TWMCopyData); message WM_COPYDATA;
    procedure reThreadInfo_Main_WndProc_Current(var Message: TMessage);
    procedure memThreadInfo_1_WndProc_Current(var Message: TMessage);
    procedure memLogInfo_2_WndProc_Current(var Message: TMessage);
  public
    { Public declarations }
    procedure SetButtonState_ThreadList(ThreadNum: word);
  end;

var
  formMain: TformMain;
  reThreadInfo_Main_WndProc_Original: TWndMethod;
  memThreadInfo_1_WndProc_Original: TWndMethod;
  memLogInfo_2_WndProc_Original: TWndMethod;


implementation
uses unVariables, unTools, unUtils, unUtilCommon, unTasks, unInfoWindow, unConfirmDlg;

{$R *.dfm}

procedure TformMain.WMCopyData(var MessageData: TWMCopyData);
var
  tmpWord: word;
  tmpString: WideString;
begin
//  if MessageData.CopyDataStruct.dwData = CMD_SetMemoLine then
  if MessageData.CopyDataStruct.dwData = CMD_SetMemoLine then
  begin
  tmpString:= PWChar(MessageData.CopyDataStruct.lpData);
   tmpWord:= StrToInt(GetSubStr(tmpString, IndexInString(sDelimiterNumTask, tmpString, 1) + 1, IndexInString(sDelimiterNumTask, tmpString, IndexInString(sDelimiterNumTask, tmpString, 1) + 1) - 1));
   tmpString:= GetSubStr(tmpString, IndexInString(sDelimiterNumTask, tmpString, 2) + 2, - 1);
   if tmpWord > formMain.reThreadInfo_Main.Lines.Count  then
    formMain.reThreadInfo_Main.Lines.Add(tmpString)
   else
    formMain.reThreadInfo_Main.Lines[tmpWord]:= tmpString;

    MessageData.Result := 1;
  end
  else
    MessageData.Result := 0;

end;

procedure TformMain.WMWindowPosChanging(var Msg: TWMWindowPosChanging);
begin
 inherited;
 if Assigned(formTools) and not Application.Terminated  then
 begin
  formTools.Left:= self.Left + self.Width;
  formTools.Top:= self.Top;
 end;

end;


procedure TformMain.reThreadInfo_Main_WndProc_Current(var Message: TMessage);
var
  tmpBool: boolean;
  tmpInt: integer;
  tmpTaskItem: TTaskItem;
begin
 tmpBool:= true;
 if (Message.Msg = WM_Data_Update) and (Message.LParam = CMD_DeleteTaskItem) then
 begin
{
   lbThreadList.ItemIndex:= Message.WParam;
   tmpTaskItem:= lbThreadList.Items.Objects[lbThreadList.ItemIndex] as TTaskItem;
//--- Передвинем номера строк в Мемо для всех задач, номера которых после удаляемой строки
   for tmpInt:= lbThreadList.ItemIndex to (lbThreadList.Count - 1) do
     if (lbThreadList.Items.Objects[tmpInt] as TTaskItem).LineIndex_ForView > tmpTaskItem.LineIndex_ForView then
        (lbThreadList.Items.Objects[tmpInt] as TTaskItem).LineIndex_ForView:= (lbThreadList.Items.Objects[tmpInt] as TTaskItem).LineIndex_ForView - 1;
//--- Удаление строки Мемо, соответствующей задаче из списка задач
//   reThreadInfo_Main.Lines.Delete(TaskList[Message.WParam].LineIndex_ForView);
//--- После сдвига номеров строк в Мемо для всех задач, удаляем последнюю строку Мемо
//--- Отображение оставшихся задач автоматически сдвинется вверх по строкам мемо в процессе получения отчётов от задач
   reThreadInfo_Main.Lines.Delete(reThreadInfo_Main.Lines.Count - 1);
   lbThreadList.DeleteSelected;

   tmpBool:= false;
}
 end;

 if Assigned(memThreadInfo_1_WndProc_Original) and tmpBool then
  reThreadInfo_Main_WndProc_Original(Message);

end;

procedure TformMain.memThreadInfo_1_WndProc_Current(var Message: TMessage);
var
  tmpStringList: TStringList;
begin
// if (Message.Msg = EM_LINESCROLL) or ((Message.Msg = WM_VSCROLL)) then
 if (Message.Msg = WM_Data_Update) and (Message.LParam = CMD_SetMemoStreamUpd) then
 begin
  if Message.WParam = OutInfo_ForViewing.CurrentViewingTask then
  begin
   if TaskList[Message.WParam].StringStream.Position < TaskList[Message.WParam].Stream.Position then
   begin
    TaskList[Message.WParam].StringStream.LoadFromStream(TaskList[Message.WParam].Stream);
    TaskList[Message.WParam].StringStream.Seek(0, soEnd);
   end;
   if (TaskList[Message.WParam].StringStream.Position > TaskList[Message.WParam].StringStream_LastPos) then
   begin
    TaskList[Message.WParam].StringStream.Position:= TaskList[Message.WParam].StringStream_LastPos;
    try
      tmpStringList:= TStringList.Create;
      tmpStringList.LoadFromStream(TaskList[Message.WParam].StringStream);
      TaskList[Message.WParam].StringStream_LastPos:= TaskList[Message.WParam].StringStream.Position;
      memThreadInfo_1.Lines.AddStrings(tmpStringList);
    finally
     FreeAndNil(tmpStringList);
    end;

   end;
  end;
 end;

 if Assigned(memThreadInfo_1_WndProc_Original) then
  memThreadInfo_1_WndProc_Original(Message);

end;


procedure TformMain.memLogInfo_2_WndProc_Current(var Message: TMessage);
var
  tmpWord: word;
  tmpBool: boolean;
begin
 tmpBool:= false;
 if (Message.Msg = WM_Data_Update) and (Message.WParam = CMD_SetMemoStreamUpd) then
 begin
  try
//--- Проверка на новые данные от потоков библиотек
 {
   if Assigned(LibraryList) then
    for tmpWord:= 0 to (LibraryList.Count - 1) do
    begin
     if Assigned(LibraryList[tmpWord].Stream) then
      if LibraryList[tmpWord].Stream.Position > LibraryList[tmpWord].Stream_LastPos then
      begin
       LibraryList[tmpWord].Stream.Position:= LibraryList[tmpWord].Stream_LastPos;
       logFileStringList.LoadFromStream(LibraryList[tmpWord].Stream);
       LibraryList[tmpWord].Stream_LastPos:= LibraryList[tmpWord].Stream.Position;
       memLogInfo_2.Lines.AddStrings(logFileStringList);
      end;
    end;
}
//--- Проверка на новые данные от потока главного модуля
   if logFileStream_LastPos < logFileStringStream.Position then
   begin
    logFileStringList.LoadFromStream(logFileStringStream);
    memLogInfo_2.Lines.AddStrings(logFileStringList);
    logFileStream_LastPos:= logFileStringStream.Position;
   end;

  finally
   tmpBool:= true;
  end;

 end;

 if Assigned(memLogInfo_2_WndProc_Original) and (not  tmpBool) then
  memLogInfo_2_WndProc_Original(Message);

end;

{
procedure TformMain.WMDataUpdate(var updMessage: TMessage);
var
  pBuffer: PWideChar;
begin
  pBuffer:= PWideChar(updMessage.LParam);
//  memInfoTread.Lines.Add(updMessage.WParam.ToString());
  memLogInfo_2.Lines.Add(pBuffer);
end;
}

procedure TformMain.bThreadStopClick(Sender: TObject);
var
  tmpInt: integer;
  tmpTaskState: TTaskState;

begin
try
 tmpInt:=  TaskList.IndexOf(lbThreadList.Items.Objects[lbThreadList.ItemIndex] as TTaskItem);
 if (tmpInt < 0) then
 begin
  exit;
 end;
//--- Попытка приостановить выполнение на время диалога подтверждения
 if (TaskList[tmpInt].TaskState in [tsActive, tsPause]) then
 begin
  tmpTaskState:= TaskList[tmpInt].TaskState;
  TaskList[tmpInt].TaskState:= tsPause;
//--- Обновим отображаемую информацию по текущей задаче перед показом диалогового окна
  PostMessage(OutInfo_ForViewing.hMemoThreadInfo_1, WM_Data_Update, TaskList[tmpInt].TaskNum, CMD_SetMemoStreamUpd)
 end
 else
 begin
  showmessage(wsInfo_TaskUnnableToTerminate);
  exit;
 end;


 formConfirmDlg:= TformConfirmDlg.Create(formMain);
 formConfirmDlg.stConfirmText.Caption:= wsConfirm_TaskTerminate1;
 formConfirmDlg.ShowModal;

 if not (formConfirmDlg.ConfirmResult = YesResult) then
 begin
//--- Отказ от немедленной остановки
  TaskList[tmpInt].TaskState:= tmpTaskState;
  exit;
 end;

//--- Действия по остановке (прерванное выполнение).
//--- Сначала переключаем задачу в состояние Выполнение, чтобы библиотека смогла принять сигнал останова
//--- затем, ядро задачи переведёт солстояние в Остановлено (tsAbortedDone).
 TaskList[tmpInt].TaskState:= tsActive;
 try
  TaskList[tmpInt].TaskSource.AbortTaskSource;
 finally
 end;

 SetButtonState_ThreadList(TaskList[tmpInt].TaskNum);
finally

end;

end;

procedure TformMain.bThreadDeleteClick(Sender: TObject);
var
  tmpInt, tmpInt1: integer;
  tmpTaskState: TTaskState;

begin
try
//mpTaskItem:= lbThreadList.Items.Objects[lbThreadList.ItemIndex] as TTaskItem;
 tmpInt:=  TaskList.IndexOf(lbThreadList.Items.Objects[lbThreadList.ItemIndex] as TTaskItem);
//TaskNum:= tmpTaskItem.TaskNum;
 if (tmpInt < 0) then
 begin
  exit;
 end;

//--- Попытка приостановить выполнение на время диалога подтверждения
 if (TaskList[tmpInt].TaskState in [tsActive, tsPause]) then
 begin
  tmpTaskState:= TaskList[tmpInt].TaskState;
  TaskList[tmpInt].TaskState:= tsPause
 end;

 formConfirmDlg:= TformConfirmDlg.Create(formMain);

 if (TaskList[tmpInt].TaskState in [tsActive, tsPause]) then
  formConfirmDlg.stConfirmText.Caption:= wsConfirm_TaskDelete2
 else
  formConfirmDlg.stConfirmText.Caption:= wsConfirm_TaskDelete1;

 formConfirmDlg.ShowModal;

 if not (formConfirmDlg.ConfirmResult = YesResult) then
 begin
//--- Отказ от удаления
  TaskList[tmpInt].TaskState:= tmpTaskState;
  exit;
 end;


 if (TaskList[tmpInt].TaskState in [tsActive, tsPause, tsAbortedDone]) then
 begin
//--- Удаление задачи (потока)
  TaskList[tmpInt].TaskState:= tsTerminate;

//--- Освобождение памяти не делаем, так как при создании поставили FreeOnTerminate
//  TaskList[tmpWord].Terminate;
 end;

//--- Удаление задачи из списка "задач" (информацию о задаче (в компоненте отображения) пока оставляем в окне просмотра (само обновиться из задачи)...)
//--- Удаление задачи из списка объектов "задачи"
 TaskList.Extract(TaskList[tmpInt]);
 //--- Передвинем номера строк на одну вниз (для отображения в Мемо) для всех задач, номера которых после удаляемой строки
 for tmpInt1:= tmpInt to (TaskList.Count - 1) do
  if TaskList[tmpInt1].LineIndex_ForView > 0 then
   TaskList[tmpInt1].LineIndex_ForView:= TaskList[tmpInt1].LineIndex_ForView - 1;
//--- После сдвига номеров строк в Мемо для всех задач, удаляем последнюю строку Мемо
//--- Удаление строки Мемо, соответствующей задаче из списка задач не производим
//--- Отображение оставшихся задач автоматически сдвинется вверх по строкам мемо в процессе получения отчётов от задач
 try
  if reThreadInfo_Main.Lines.Count > 0 then
   reThreadInfo_Main.Lines.Delete(reThreadInfo_Main.Lines.Count - 1);
 except
  on E: EListError do
   WriteDataToLog(E.ClassName + E.Message, 'formMain.bThreadStopClick', 'formMain');
 end;
//--- Удаляем задачу из списка задач компонента отображения (ЛистБокс)
 lbThreadList.DeleteSelected;
 if lbThreadList.ItemIndex > -1 then
  PostMessage(OutInfo_ForViewing.hMemoThreadInfo_1, WM_Data_Update, lbThreadList.ItemIndex, CMD_SetMemoStreamUpd)
 else
  memThreadInfo_1.Lines.Clear;


finally
 if Assigned(formConfirmDlg) then
  FreeAndNil(formConfirmDlg);

end;

end;

procedure TformMain.bThreadPauseClick(Sender: TObject);
var
  tmpInt, tmpInt1: integer;
  tmpTaskState: TTaskState;

begin
 tmpInt:=  TaskList.IndexOf(lbThreadList.Items.Objects[lbThreadList.ItemIndex] as TTaskItem);
 if (tmpInt < 0) then
 begin
  exit;
 end;

 case TaskList[tmpInt].TaskState of
  tsActive:
   TaskList[tmpInt].TaskState:= tsPause;
  tsPause, tsDone, tsAbortedDone:
   TaskList[tmpInt].TaskState:= tsActive;
 end;

//--- Обновим отображаемую информацию по текущей задаче перед показом диалогового окна
 PostMessage(OutInfo_ForViewing.hMemoThreadInfo_1, WM_Data_Update, TaskList[tmpInt].TaskNum, CMD_SetMemoStreamUpd);

 SetButtonState_ThreadList(TaskList[tmpInt].TaskNum);
end;


procedure TformMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
try
 formInfo:= TformInfo.Create(Application);
 formInfo.lMessageInfo.Caption:= sWaitForAppClosing;
 formInfo.Show;
 Application.ProcessMessages;

 if Assigned(formTools) then
 begin
  formTools.Close;
  FreeAndNil(formTools);
 end;

 if Assigned(formTools) then
 begin
  formInfo.Close;
  FreeAndNil(formInfo);
 end;

finally
// DeinitializeVariables;
 FinalizeLibraryes;
end;
end;

procedure TformMain.FormCreate(Sender: TObject);
begin
//--- Проверка минимальной версии ОС, необходимой для работы данного ПО
  if not (Assigned(GetProcAddress(GetModuleHandle(kernel32), 'AddDllDirectory'))) then
  begin
    showmessage(wsUncknownVersionOS);
    Application.Terminate;
  end;


 sbMain.Panels[0].Text:= 'ThreadId (процесса): ' + inttostr(GetCurrentThreadId);

//--- Заполнение глобальных переменных
 OutInfo_ForViewing.hMemoThreadInfo_Main:= reThreadInfo_Main.Handle;
 OutInfo_ForViewing.hMemoThreadInfo_1:= memThreadInfo_1.Handle;
 OutInfo_ForViewing.hMemoLogInfo_2:= memLogInfo_2.Handle;

//--- Настройка обработки сообщения для информации о задачах
 reThreadInfo_Main_WndProc_Original:= formMain.reThreadInfo_Main.WindowProc;
 formMain.reThreadInfo_Main.WindowProc:= reThreadInfo_Main_WndProc_Current;

 //--- Настройка обработки сообщения для информации о задачах
 memThreadInfo_1_WndProc_Original:= formMain.memThreadInfo_1.WindowProc;
 formMain.memThreadInfo_1.WindowProc:= memThreadInfo_1_WndProc_Current;

 //--- Настройка обработки сообщения для журнала
 memLogInfo_2_WndProc_Original:= formMain.memLogInfo_2.WindowProc;
 formMain.memLogInfo_2.WindowProc:= memLogInfo_2_WndProc_Current;

//--- Прокрутить ТМемо с журналом работы на последнюю строку
 PostMessage(OutInfo_ForViewing.hMemoLogInfo_2, WM_Data_Update, CMD_SetMemoStreamUpd, 0);

end;

procedure TformMain.FormShow(Sender: TObject);
begin
//--- Что бы сразу открывалось окно с настройками
  formMain.lbThreadList.Clear;
  formMain.reThreadInfo_Main.Clear;
  formMain.miToolsClick(Sender);

//--- Зафиксируем потоки на момент старта процесса приложения
//--- Затем будем сохранять создаваемые по ходу работы приложения
 setlength(ThreadList1, 0);
 GetThreadsInfo(GetCurrentProcessId, ThreadList1);

end;

procedure TformMain.lbThreadListClick(Sender: TObject);
var
  tmpInt: integer;
  tmpResultBuffer: Pointer;
  tmpHandle: THandle;
  tmpIStream: IStream;
  tmpStringList: TStringList;
  tmpWideString: AnsiString;

begin
try
 tmpStringList:= TStringList.Create;
 if not ((lbThreadList.ItemIndex > -1) and ((Sender as TListBox).ItemIndex <= (Sender as TListBox).Items.Count)) then
 begin
  memThreadInfo_1.Lines.Clear;
  exit;
 end;

 tmpInt:= lbThreadList.ItemIndex;
 if (OutInfo_ForViewing.CurrentViewingTask = tmpInt) and (lbThreadList.Count > 1) then
  exit;

 CriticalSection.Enter;
  memThreadInfo_1.Lines.Clear;
  OutInfo_ForViewing.CurrentViewingTask:= tmpInt;
  TaskList[tmpInt].StringStream_LastPos:= 0;
 CriticalSection.Leave;

 SetButtonState_ThreadList(lbThreadList.ItemIndex);

//--- Первоначальный вывод информации о результатах от задачи (потока)
//--- будет отображена информация, которая уже есть на момент переключения
//--- последующая информация будет выводиться по сообщениям от задач (по мере выполнения)
//--- Выведем информацию о результате выполнения задачи в TMemo
try

   TaskList[tmpInt].StringStream.LoadFromStream(TaskList[tmpInt].Stream);
   if (TaskList[tmpInt].StringStream.Position > TaskList[tmpInt].StringStream_LastPos) then
   begin
    TaskList[tmpInt].StringStream.Position:= TaskList[tmpInt].StringStream_LastPos;
    try
      tmpStringList:= TStringList.Create;
      tmpStringList.LoadFromStream(TaskList[tmpInt].StringStream);
      TaskList[tmpInt].StringStream_LastPos:= TaskList[tmpInt].StringStream.Position;
      memThreadInfo_1.Lines.Text:= tmpStringList.Text;
    finally
     FreeAndNil(tmpStringList);
    end;
   end;


except
 on E: Exception {EStreamError} do
 begin
  WriteDataToLog(E.ClassName + ', E.Message = ' + E.Message, 'TformMain.lbThreadListClick', 'unMain');
 end;
end;

finally
 if Assigned(tmpStringList) then
  FreeAndNil(tmpStringList);
end;

//--- Выделим соответсвующую строку состояния задачи в memInfoTread
// memInfoTread.SelStart := Perform(EM_LINEINDEX, lbThreadList.ItemIndex, 0) + 2; // отступ слева - 2 точки
// memInfoTread.SelLength:= Perform(EM_LINELENGTH, memInfoTread.SelStart,0) - 2; // отступ справа - 2 точки
//   tmpInt:=Perform(EM_LINEFROMCHAR, lbThreadList.ItemIndex, 0);
//   memInfoTread.SelStart:=Perform(EM_LINEINDEX, tmpInt, 0);
//   memInfoTread.SelLength:=Length(memInfoTread.Lines[tmpInt]);

end;

procedure TformMain.lbThreadListKeyPress(Sender: TObject; var Key: Char);
begin
 SetButtonState_ThreadList(lbThreadList.ItemIndex);
end;

procedure TformMain.lbThreadListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
// (Sender as TListbox).Selected[(Sender as TListbox).ItemIndex];
SetButtonState_ThreadList((Sender as TListbox).ItemIndex);
end;

procedure TformMain.memThreadInfo_1Click(Sender: TObject);
{
  tmpInt: integer;
}
begin
{
with (Sender as TMemo) do
begin
   tmpInt:=Perform(EM_LINEFROMCHAR, SelStart, 0);
   SelStart:=Perform(EM_LINEINDEX, tmpInt, 0);
   SelLength:=Length(Lines[tmpInt]);
end;
}
end;

procedure TformMain.miExitClick(Sender: TObject);
begin
 Close;
end;

procedure TformMain.miToolsClick(Sender: TObject);
begin
try
 miTools.Enabled:= false;
 Application.CreateForm(TformTools, formTools);
 formTools.Show;
except
  miTools.Enabled:= true;
end;
// bFormToolsIsActive:= true;
end;

procedure TformMain.N1Click(Sender: TObject);
var
  tmpStringList: TStrings;
begin
  memLogInfo_2.Lines.Clear;
  ListDLLsForProcess(GetPIDByName(PWChar(formMain.Caption)), memLogInfo_2.Lines);
end;

procedure TformMain.N2Click(Sender: TObject);
var
  tmpWord: word;
  tmpWideString, tmpWideString1: WideString;
begin
  memLogInfo_2.Lines.Clear;

//--- Отобразить зависимые потоки
//  for tmpWord:= 0 to (memLogInfo_2.Lines.Count - 1) do
//    GetThreadsInfoBySubThread(strtoint(memLogInfo_2.Lines[tmpWord]), memLogInfo_2, tmpWord);
  for tmpWideString in ThreadList1 do
   tmpWideString1:= tmpWideString1 + tmpWideString + ', ';
  memLogInfo_2.Lines.Add(format('%11s', ['На старте: ']) + tmpWideString1);

//--- Потоки процесса на текущий момент
  setlength(ThreadList2, 0);
  GetThreadsInfo(GetCurrentProcessId, ThreadList2);
  tmpWideString1:= '';
  for tmpWideString in ThreadList2 do
   tmpWideString1:= tmpWideString1 + tmpWideString + ', ';
  memLogInfo_2.Lines.Add(format('%11s', ['Сейчас: ']) + tmpWideString1);

end;

procedure TformMain.SetButtonState_ThreadList(ThreadNum: word);
begin
 case TaskList[ThreadNum].GetTaskState of
  tsActive:
   begin
    bThreadPause.Enabled:= true;
    bThreadPause.Caption:= aButtonStateCaption[0]; //--- 'Пауза';
    bThreadStop.Enabled:= true;
   end;
  tsPause:
   begin
    bThreadPause.Enabled:= true;
    bThreadPause.Caption:= aButtonStateCaption[1]; //--- 'Продолжить';
    bThreadStop.Enabled:= true;
   end;
  tsTerminate:
   begin
    bThreadStop.Enabled:= false;
    bThreadPause.Enabled:= false;
    bThreadPause.Caption:= aButtonStateCaption[2]; //--- 'Завершён';
   end;
  tsDone, tsAbortedDone:
   begin
    bThreadStop.Enabled:= false;
    bThreadPause.Enabled:= true;
    bThreadPause.Caption:= aButtonStateCaption[3]; //--- 'Запуск (повтор)';
   end;

 end;
end;


//--- Подпрограммы вне классов -------------------------------------------------


initialization

finalization

end.
