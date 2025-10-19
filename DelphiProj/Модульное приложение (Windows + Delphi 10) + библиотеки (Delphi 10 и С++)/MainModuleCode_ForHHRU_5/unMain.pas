unit unMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, ActiveX, Vcl.AxCtrls, Vcl.ExtCtrls,
  Vcl.Menus, IOUtils, Types, IdGlobal, EncdDecd,
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
    lbThreadList: TListBox;
    bThreadPause: TButton;
    bThreadStop: TButton;
    sbMain: TStatusBar;
    N1: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    bThreadDelete: TButton;
    N2: TMenuItem;
    reThreadInfo_Main: TListBox;
    Panel1: TPanel;
    memThreadInfo_1: TMemo;
    memLogInfo_2: TMemo;
    Splitter1: TSplitter;
    bThreadDeleteAll: TButton;
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
    procedure FormCreate(Sender: TObject);
    procedure bThreadDeleteClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure reThreadInfo_MainClick(Sender: TObject);
    procedure bThreadDeleteAllClick(Sender: TObject);
  private
    { Private declarations }
    procedure WMWindowPosChanging(var Msg: TWMWindowPosChanging); message WM_WINDOWPOSCHANGING;
//    procedure WMCopyData(var MessageData: TWMCopyData); message WM_COPYDATA;
    procedure reThreadInfo_Main_WndProc_Current(var inputMsg: TMessage);
    procedure memThreadInfo_1_WndProc_Current(var inputMsg: TMessage);
    procedure memLogInfo_2_WndProc_Current(var inputMsg: TMessage);
  public
    { Public declarations }
    procedure SetButtonState_ThreadList(ThreadNum: word);
  end;

procedure DeleteTask(inputTaskNum: word);

var
  formMain: TformMain;
  formMain_WndProc_Original: TWndMethod;
  reThreadInfo_Main_WndProc_Original: TWndMethod;
  memThreadInfo_1_WndProc_Original: TWndMethod;
  memLogInfo_2_WndProc_Original: TWndMethod;


implementation
uses unVariables, unTools, unUtils, unUtilCommon, unTasks, unInfoWindow, unConfirmDlg;

{$R *.dfm}

{
procedure TformMain.WMCopyData(var MessageData: TWMCopyData);
var
  tmpWord: word;
  tmpString: WideString;
begin
  if MessageData.CopyDataStruct.dwData = CMD_SetMemoLine then
  begin
  tmpString:= PWChar(MessageData.CopyDataStruct.lpData);
   tmpWord:= StrToInt(GetSubStr(tmpString, IndexInString(sDelimiterNumTask, tmpString, 1) + 1, IndexInString(sDelimiterNumTask, tmpString, IndexInString(sDelimiterNumTask, tmpString, 1) + 1) - 1));
   tmpString:= GetSubStr(tmpString, IndexInString(sDelimiterNumTask, tmpString, 2) + 2, - 1);
   formMain.reThreadInfo_Main.Items[tmpWord]:= tmpString;

    MessageData.Result := 1;
  end
  else
    MessageData.Result := 0;

end;
}

//------------------------------------------------------------------------------
procedure TformMain.WMWindowPosChanging(var Msg: TWMWindowPosChanging);
begin
 inherited;
 if Assigned(formTools) and not Application.Terminated  then
 begin
  formTools.Left:= self.Left + self.Width;
  formTools.Top:= self.Top;
 end;

end;


//------------------------------------------------------------------------------
procedure TformMain.reThreadInfo_MainClick(Sender: TObject);
begin
 lbThreadList.ItemIndex:= reThreadInfo_Main.ItemIndex;
 lbThreadListClick(Sender);
end;

//------------------------------------------------------------------------------
procedure TformMain.reThreadInfo_Main_WndProc_Current(var inputMsg: TMessage);
var
  tmpBool: boolean;
  tmpInt: integer;
  tmpTaskItem: TTaskItem;
  tmpCopyDataStruct: PCopyDataStruct;
  tmpWord: word;
  tmpString: WideString;
begin
 tmpBool:= true;

//--- Если сообщение получено от другого потока, то сразу вернём управление потоку-отправителю, не дожидаясь окончания обработки данного сообщени
 if InSendMessage() then
  ReplyMessage(ord(true));

 case inputMsg.Msg of
//---    WM_COPYDATA:
   WM_COPYDATA:
   begin
    tmpCopyDataStruct:= Pointer(inputMsg.LParam);
    if tmpCopyDataStruct.dwData = CMD_SetMemoLine then
    begin
     tmpString:= PWChar(tmpCopyDataStruct.lpData);
     tmpWord:= StrToInt(GetSubStr(tmpString, IndexInString(sDelimiterNumTask, tmpString, 1) + 1, IndexInString(sDelimiterNumTask, tmpString, IndexInString(sDelimiterNumTask, tmpString, 1) + 1) - 1));
     tmpWord:= GetViewComponentLineIndex(tmpWord);
     tmpString:= GetSubStr(tmpString, IndexInString(sDelimiterNumTask, tmpString, 2) + 2, - 1);
     formMain.reThreadInfo_Main.Items[tmpWord]:= tmpString;
    end;
   end;

//---    WM_Data_Update:
   WM_Data_Update:
   begin
   if (inputMsg.LParam = CMD_DeleteTaskItem) then
    begin

     lbThreadList.ItemIndex:= inputMsg.WParam;
     tmpTaskItem:= lbThreadList.Items.Objects[lbThreadList.ItemIndex] as TTaskItem;
//--- Передвинем номера строк в Мемо для всех задач, номера которых после удаляемой строки
//--- Удаление строки Мемо, соответствующей задаче из списка задач
//   reThreadInfo_Main.Lines.Delete(TaskList[Message.WParam].LineIndex_ForView);
//--- После сдвига номеров строк в Мемо для всех задач, удаляем последнюю строку Мемо
//--- Отображение оставшихся задач автоматически сдвинется вверх по строкам мемо в процессе получения отчётов от задач
      reThreadInfo_Main.Items.Delete(reThreadInfo_Main.Items.Count - 1);
      lbThreadList.DeleteSelected;
      tmpBool:= false;
 end;


   end;
 end;

 if Assigned(memThreadInfo_1_WndProc_Original) and tmpBool then
  reThreadInfo_Main_WndProc_Original(inputMsg);

end;

//------------------------------------------------------------------------------
procedure TformMain.memThreadInfo_1_WndProc_Current(var inputMsg: TMessage);
var
  tmpStringList: TStringList;
  tmpBool: boolean;
  tmpMsg: TMsg;
  tmpMessage_Sender: TMessage_Sender;
  tmpPMessage_Sender: ^TMessage_Sender;
begin
 if (inputMsg.Msg = WM_Data_Update) and (inputMsg.LParam = CMD_SetMemoStreamUpd) then
 begin
  if TaskList.Count > inputMsg.WParam then //--- асинхронные сообщения могут приходить ещё после удаления всех элементов списка задач
  begin
   if inputMsg.WParam = Info_ForViewing.CurrentViewingTask then
   begin
    if TaskList[inputMsg.WParam].StringStream.Position < TaskList[inputMsg.WParam].Stream.Position then
    begin
     TaskList[inputMsg.WParam].StringStream.LoadFromStream(TaskList[inputMsg.WParam].Stream);
     TaskList[inputMsg.WParam].StringStream.Seek(0, soEnd);
    end;
    if (TaskList[inputMsg.WParam].StringStream.Position > TaskList[inputMsg.WParam].StringStream_LastPos) then
    begin
     TaskList[inputMsg.WParam].StringStream.Position:= TaskList[inputMsg.WParam].StringStream_LastPos;
     try
       tmpStringList:= TStringList.Create;
       tmpStringList.LoadFromStream(TaskList[inputMsg.WParam].StringStream);
       TaskList[inputMsg.WParam].StringStream_LastPos:= TaskList[inputMsg.WParam].StringStream.Position;
       memThreadInfo_1.Lines.AddStrings(tmpStringList);
     finally
      FreeAndNil(tmpStringList);
     end;
    end;
   end;
  end;
 end;

 if Assigned(memThreadInfo_1_WndProc_Original) then
  memThreadInfo_1_WndProc_Original(inputMsg);
end;

//------------------------------------------------------------------------------
procedure TformMain.memLogInfo_2_WndProc_Current(var inputMsg: TMessage);
var
  tmpInt: integer;
  tmpBool: boolean;
  tmpStringList: TStringList;
  tmpSenderId: word;
begin
 tmpBool:= false;
 if (inputMsg.Msg = WM_Data_Update) and (inputMsg.lParam = CMD_SetMemoLogStreamUpd) then
 begin
  try
//--- Восстановление исходных значений TaskNum и SenderId из упакованного формата
   inputMsg.WParam:= inputMsg.WParam and (not NotifySignBit);
   tmpSenderId:= inputMsg.WParamHi;
   tmpInt:= inputMsg.WParamLo;
   case tmpSenderId of

//--- sidMainModule
    NativeUInt(msMainModule): //--- 0
     begin
//--- Проверка на новые данные от потока главного модуля
//--- если в logStringStream появились новые данные, то занести их в файл журнала
//--- и вывести в компонент отображения журнала на главной форме
      if logStringStream.Position > logFileStream.Position then
      begin
       logFileStream.Write(logStringStream.Bytes[logFileStream_LastPos], logStringStream.Position - logFileStream_LastPos);
       logStringStream.Position:= logFileStream_LastPos;
       try
        tmpStringList:= TStringList.Create;
        tmpStringList.LoadFromStream(logStringStream);
        memLogInfo_2.Lines.AddStrings(tmpStringList);
        logFileStream_LastPos:= logStringStream.Position;
       finally
        FreeAndNil(tmpStringList);
       end;
      end;
     end;

//--- sidLibraryAPI
    NativeUInt(msLibraryAPI):
     begin
//--- Проверка на новые данные от API библиотек
      if Assigned(LibraryList) then
       for tmpInt:= 0 to (LibraryList.Count - 1) do
       begin
      if Assigned(LibraryList[tmpInt].Stream_Log) then
       if (LibraryList[tmpInt].StringStream.Position < LibraryList[tmpInt].Stream_Log.Position) then
       begin
        LibraryList[tmpInt].StringStream.Position:= LibraryList[tmpInt].StringStream_LastPos;
        try
         tmpStringList:= TStringList.Create;
         tmpStringList.LoadFromStream(LibraryList[tmpInt].StringStream);
         LibraryList[tmpInt].StringStream_LastPos:= LibraryList[tmpInt].StringStream.Position;
         memLogInfo_2.Lines.AddStrings(tmpStringList);
        finally
         FreeAndNil(tmpStringList);
        end;
       end;
       end;
     end;

//--- sidTaskItem
    NativeUInt(msTaskItem):
     begin
      if TaskList.Count > tmpInt then //--- асинхронные сообщения могут приходить ещё после удаления всех элементов списка задач
      begin
       if TaskList[tmpInt].StringStream_Log <> nil then
       begin
        if (TaskList[tmpInt].StringStream_Log.Position > TaskList[tmpInt].StringStream_Log_LastPos) then
         begin
          TaskList[tmpInt].StringStream_Log.Position:= TaskList[tmpInt].StringStream_Log_LastPos;
          try
           tmpStringList:= TStringList.Create;
           tmpStringList.LoadFromStream(TaskList[tmpInt].StringStream_Log);
           TaskList[tmpInt].StringStream_Log_LastPos:= TaskList[tmpInt].StringStream_Log.Position;
           memLogInfo_2.Lines.AddStrings(tmpStringList);
          finally
           FreeAndNil(tmpStringList);
          end;
         end;
       end;
      end;
     end;

//--- sidTaskCore
    NativeUInt(msTaskCore):
     begin

showmessage('Сюда не должны попадать никогда! (После Case ... NativeUInt(msTaskCore):)' );

{
      if TaskList.Count > tmpInt then //--- асинхронные сообщения могут приходить ещё после удаления всех элементов списка задач
      begin
showmessage('if TaskList.Count > tmpInt then');
showmessage('.StringStream_Core_Log.Position = ' + inttostr(TaskList[tmpInt].StringStream_Core_Log.Position) + wsCRLF +
            'TaskList[tmpInt].Stream_Core_Log.Position = ' + inttostr(TaskList[tmpInt].Stream_Core_Log.Position));

       if Assigned(TaskList[tmpInt].StringStream_Core_Log) then
       if TaskList[tmpInt].StringStream_Core_Log.Position < TaskList[tmpInt].Stream_Core_Log.Position then
       begin
        TaskList[tmpInt].StringStream_Core_Log.LoadFromStream(TaskList[tmpInt].Stream_Core_Log);
        TaskList[tmpInt].StringStream_Core_Log.Seek(0, soEnd);
       end;
       if (TaskList[tmpInt].StringStream_Core_Log.Position > TaskList[tmpInt].StringStream_Core_Log_LastPos) then
        begin
         TaskList[tmpInt].StringStream_Core_Log.Position:= TaskList[tmpInt].StringStream_Core_Log_LastPos;
         try
          tmpStringList:= TStringList.Create;
          tmpStringList.LoadFromStream(TaskList[tmpInt].StringStream_Core_Log);
          TaskList[tmpInt].StringStream_Core_Log_LastPos:= TaskList[tmpInt].StringStream_Core_Log.Position;
          memLogInfo_2.Lines.AddStrings(tmpStringList);
         finally
          FreeAndNil(tmpStringList);
         end;
        end;
      end;
}
     end;

    else //--- case
    begin
     WriteDataToLog(format(wsError_NotDefinedMessageSender,
                           [tmpSenderId]),
                           'TformMain.memLogInfo_2_WndProc_Current', 'unMain');
    end; //--- else
   end;


  finally
   tmpBool:= true;
  end;

 end;

 if Assigned(memLogInfo_2_WndProc_Original) and (not  tmpBool) then
  memLogInfo_2_WndProc_Original(inputMsg);

end;

{
procedure TformMain.WMDataUpdate(var updMessage: TMessage);
var
  pBuffer: PWideChar;
begin
  pBuffer:= PWideChar(updinputMsg.LParam);
//  memInfoTread.Lines.Add(updinputMsg.WParam.ToString());
  memLogInfo_2.Lines.Add(pBuffer);
end;
}

//------------------------------------------------------------------------------
procedure TformMain.bThreadStopClick(Sender: TObject);
var
  tmpInt: integer;
  tmpTaskState: TTaskState;
  tmpformConfirmDlg: TformConfirmDlg;
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
  PostMessage(Info_ForViewing.hMemoThreadInfo_1, WM_Data_Update, TaskList[tmpInt].TaskNum, CMD_SetMemoStreamUpd)
 end
 else
 begin
  showmessage(wsInfo_TaskUnnableToTerminate);
  exit;
 end;


 tmpformConfirmDlg:= TformConfirmDlg.Create(formMain);
 tmpformConfirmDlg.stConfirmText.Caption:= wsConfirm_TaskTerminate1;
 tmpformConfirmDlg.ShowModal;

 if not (tmpformConfirmDlg.ConfirmResult = YesResult) then
 begin
//--- Отказ от немедленной остановки
  TaskList[tmpInt].TaskState:= tmpTaskState;
  exit;
 end;

//--- Действия по остановке (прерванное выполнение).
//--- Сначала переключаем задачу в состояние Выполнение, чтобы библиотека смогла принять сигнал останова
//--- затем, ядро задачи переведёт солстояние в Остановлено (tsAbortedDone).
  TaskList[tmpInt].TaskState:= tsAbortedDone;

 SetButtonState_ThreadList(TaskList[tmpInt].TaskNum);
finally
 if Assigned(tmpformConfirmDlg) then
  FreeAndNil(tmpformConfirmDlg);
end;

end;

//------------------------------------------------------------------------------
procedure TformMain.bThreadDeleteAllClick(Sender: TObject);
var
  tmpInt: integer;
  tmpformConfirmDlg: TformConfirmDlg;
begin
try
 tmpformConfirmDlg:= TformConfirmDlg.Create(formMain);

 tmpformConfirmDlg.stConfirmText.Caption:= wsConfirm_TaskDeleteAll;

 tmpformConfirmDlg.ShowModal;

 if not (tmpformConfirmDlg.ConfirmResult = YesResult) then
 begin
//--- Отказ от удаления
  exit;
 end;

//--- Удаление задач
 for tmpInt:= (TaskList.Count - 1) downto 0 do
 begin
  DeleteTask(tmpInt);
 end;

finally
 if Assigned(tmpformConfirmDlg) then
  FreeAndNil(tmpformConfirmDlg);

end;
end;

//------------------------------------------------------------------------------
procedure TformMain.bThreadDeleteClick(Sender: TObject);
var
  tmpInt, tmpInt1: integer;
  tmpTaskState: TTaskState;
  tmpformConfirmDlg: TformConfirmDlg;
begin
try
 tmpInt:= lbThreadList.ItemIndex;
 if (tmpInt < 0) then
 begin
  exit;
 end;
 tmpInt:=  TaskList.IndexOf(lbThreadList.Items.Objects[tmpInt] as TTaskItem);

//--- Попытка приостановить выполнение на время диалога подтверждения
 if (TaskList[tmpInt].TaskState in [tsActive, tsPause]) then
 begin
  tmpTaskState:= TaskList[tmpInt].TaskState;
  TaskList[tmpInt].TaskState:= tsPause
 end;

 tmpformConfirmDlg:= TformConfirmDlg.Create(formMain);

 if (TaskList[tmpInt].TaskState in [tsActive, tsPause]) then
  tmpformConfirmDlg.stConfirmText.Caption:= wsConfirm_TaskDelete2
 else
  tmpformConfirmDlg.stConfirmText.Caption:= wsConfirm_TaskDelete1;

 tmpformConfirmDlg.ShowModal;

 if not (tmpformConfirmDlg.ConfirmResult = YesResult) then
 begin
//--- Отказ от удаления
  TaskList[tmpInt].TaskState:= tmpTaskState;
  exit;
 end;

 DeleteTask(tmpInt);

finally
 if Assigned(tmpformConfirmDlg) then
  FreeAndNil(tmpformConfirmDlg);

end;

end;

//------------------------------------------------------------------------------
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
 PostMessage(Info_ForViewing.hMemoThreadInfo_1, WM_Data_Update, TaskList[tmpInt].TaskNum, CMD_SetMemoStreamUpd);

 SetButtonState_ThreadList(TaskList[tmpInt].TaskNum);
end;


//------------------------------------------------------------------------------
procedure TformMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  tmpInt: integer;
begin
try
//--- Удаляем наш перехватчик сообщений очереди главного потока
 UnhookWindowsHookEx(hMainThreadHook);
//--- Удаление задач
 sbMain.Panels[2].Text:= wsConfirm_TaskDeleteMessage;
 if TaskList.Count > 0 then
  for tmpInt:= (TaskList.Count - 1) downto 0 do
  begin
   DeleteTask(tmpInt);
  end;

 if Assigned(formTools) then
 begin
  formTools.Close;
  FreeAndNil(formTools);
 end;

finally
// DeinitializeVariables;
 FinalizeLibraries;
end;
end;

//------------------------------------------------------------------------------
procedure TformMain.FormCreate(Sender: TObject);
var
  tmpMsg: TMsg;
  tmpPointer: Pointer;
  tmpMessage_Sender: TMessage_Sender;
  tmpBool: boolean;
begin
//--- Проверка минимальной версии ОС, необходимой для работы данного ПО
  if not (Assigned(GetProcAddress(GetModuleHandle(kernel32), 'AddDllDirectory'))) then
  begin
    showmessage(wsUncknownVersionOS);
    Application.Terminate;
  end;

 sbMain.Panels[0].Text:= 'ThreadId (процесса): ' + inttostr(GetCurrentThreadId)
                          + ' (' + inttostr(MainModuleThreadId) + ')';
//--- Сделаем "фиктивную" выборку из очереди, чтобы создать очередь
 PeekMessage(tmpMsg, 0, WM_Data_Update, WM_Data_Update, PM_NOREMOVE);
//--- Заполнение глобальных переменных
 Info_ForViewing.hMemoThreadInfo_Main:= reThreadInfo_Main.Handle;
 Info_ForViewing.hMemoThreadInfo_1:= memThreadInfo_1.Handle;
 Info_ForViewing.hMemoLogInfo_2:= memLogInfo_2.Handle;

//--- Настройка обработки сообщения для информации о задачах
 reThreadInfo_Main_WndProc_Original:= formMain.reThreadInfo_Main.WindowProc;
 formMain.reThreadInfo_Main.WindowProc:= reThreadInfo_Main_WndProc_Current;

{
//--- Для отработки
 tmpMessage_Sender.TaskNum:= 0;
 tmpMessage_Sender.SenderId:= sidMainModule;
 tmpBool:= PostThreadMessage(GetCurrentThreadId, WM_Data_Update, CMD_SetMemoLogStreamUpd, DWORD(@tmpMessage_Sender));
 tmpBool:= PeekMessage(tmpMsg, 0, WM_Data_Update, WM_Data_Update, PM_NOREMOVE);
}
 //--- Настройка обработки сообщения от потоков (PostTHreadMessage) в поток главного модуля
 //--- установка перехватчика сообщений, в котором будут извлекаться только сообщения от потоков для журнала
 hMainThreadHook:= SetWindowsHookEx(WH_CALLWNDPROC, @MainThread_WndProc_Hook, 0, GetCurrentThreadId);

//--- Настройка обработки сообщения для информации о задачах
 memThreadInfo_1_WndProc_Original:= formMain.memThreadInfo_1.WindowProc;
 formMain.memThreadInfo_1.WindowProc:= memThreadInfo_1_WndProc_Current;

 //--- Настройка обработки сообщения для журнала
 memLogInfo_2_WndProc_Original:= formMain.memLogInfo_2.WindowProc;
 formMain.memLogInfo_2.WindowProc:= memLogInfo_2_WndProc_Current;


end;

//------------------------------------------------------------------------------
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

//------------------------------------------------------------------------------
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
 if lbThreadList.ItemIndex < 0 then
    exit;

 tmpInt:=  TaskList.IndexOf(lbThreadList.Items.Objects[lbThreadList.ItemIndex] as TTaskItem);
 if lbThreadList.ItemIndex < 0 then
 begin
  memThreadInfo_1.Lines.Clear;
  exit;
 end;

 reThreadInfo_Main.ItemIndex:= lbThreadList.ItemIndex;

 tmpInt:= lbThreadList.ItemIndex;
 if (Info_ForViewing.CurrentViewingTask = TaskList[tmpInt].TaskNum) and (lbThreadList.Count > 1) then
  exit;

//--- установка текущего активного (выбранного) элемента - Задача
//--- по данноой переменной определяется задача, для которой должны отображаться результаты от задачи (потока)
//--- (в визуальном компоненте для результатов
// и колбак функция окна тоже проверяет данное соответствие
 CriticalSection.Enter;
  Info_ForViewing.CurrentViewingTask:= TaskList[tmpInt].TaskNum;
 CriticalSection.Leave;
  memThreadInfo_1.Lines.Clear;

 TaskList[tmpInt].StringStream_LastPos:= 0;

 SetButtonState_ThreadList(lbThreadList.ItemIndex);

//--- Первоначальный вывод информации о результатах от задачи (потока)
//--- будет отображена информация, которая уже есть на момент переключения
//--- последующая информация будет выводиться по сообщениям от задач (по мере выполнения)
//--- Выведем информацию о результате выполнения задачи в TMemo
try
   if Assigned(TaskList[tmpInt]) then
   begin
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
   end
   else
    showmessage(wsError_TaskItemNotAssigned);


except
 on tmpE: Exception {EStreamError} do
 begin
  WriteDataToLog(tmpE.ClassName + ', E.Message = ' + tmpE.Message,
                 'TformMain.lbThreadListClick', 'unMain');
 end;
end;

finally
end;

end;

//------------------------------------------------------------------------------
procedure TformMain.lbThreadListKeyPress(Sender: TObject; var Key: Char);
begin
 SetButtonState_ThreadList(lbThreadList.ItemIndex);
end;

//------------------------------------------------------------------------------
procedure TformMain.lbThreadListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
// (Sender as TListbox).Selected[(Sender as TListbox).ItemIndex];
SetButtonState_ThreadList((Sender as TListbox).ItemIndex);
end;

//------------------------------------------------------------------------------
procedure TformMain.miExitClick(Sender: TObject);
begin
 Close;
end;

//------------------------------------------------------------------------------
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

//------------------------------------------------------------------------------
procedure TformMain.N1Click(Sender: TObject);
var
  tmpStringList: TStrings;
begin
  memLogInfo_2.Lines.Clear;
  ListDLLsForProcess(GetPIDByName(PWChar(formMain.Caption)), memLogInfo_2.Lines);
end;

//------------------------------------------------------------------------------
procedure TformMain.N2Click(Sender: TObject);
var
  tmpInt: integer;
  tmpWideString, tmpWideString1: WideString;
begin
//--- Отобразить зависимые потоки
//  for tmpWord:= 0 to (memLogInfo_2.Lines.Count - 1) do
//    GetThreadsInfoBySubThread(strtoint(memLogInfo_2.Lines[tmpWord]), memLogInfo_2, tmpWord);
  for tmpWideString in ThreadList1 do
   tmpWideString1:= tmpWideString1 + tmpWideString + ', ';
  memLogInfo_2.Lines.Add(format('%11s: %s', ['На старте', tmpWideString1]));

//--- Потоки процесса на текущий момент
  setlength(ThreadList2, 0);
  GetThreadsInfo(GetCurrentProcessId, ThreadList2);
  tmpWideString1:= '';
  for tmpWideString in ThreadList2 do
   tmpWideString1:= tmpWideString1 + tmpWideString + ', ';
  memLogInfo_2.Lines.Add(format('%11s: %s', ['Сейчас', tmpWideString1]));

//--- Потоки созданные по задачам с момента старта главного модуля
  tmpWideString1:= '';

  for tmpInt:= 0 to (length(ThreadStorList) - 1) do
   tmpWideString1:= tmpWideString1 + inttostr(ThreadStorList[tmpInt].cTask_ThreadId) + '/' + inttostr(ThreadStorList[tmpInt].cTaskCore__ThreadId) + ', ';
  memLogInfo_2.Lines.Add(format('%11s: %s', ['По задачам', tmpWideString1]));

end;

//------------------------------------------------------------------------------
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

//------------------------------------------------------------------------------
//--- Подпрограммы вне классов -------------------------------------------------
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
procedure DeleteTask(inputTaskNum: word);
var
  tmpInt, tmpInt1: integer;
begin
// if (TaskList[tmpInt].TaskState in [tsActive, tsPause, tsAbortedDone]) then
// begin
//--- Удаление задачи (потока)
 try
  tmpInt:= inputTaskNum;
  TaskList[tmpInt].TaskState:= tsTerminate;
  TaskList[tmpInt].WaitFor;

// end;

//--- Удаление задачи из списка "задач" (информацию о задаче (в компоненте отображения) пока оставляем в окне просмотра (само обновиться из задачи)...)
//--- Удаление задачи из списка объектов "задачи"

 if TaskList.Remove(formMain.lbThreadList.Items.Objects[tmpInt] as TTaskItem) < 0 then //--- если удаление прошло не удачно, то будет -1
  for tmpInt1:= 0 to (TaskList.Count - 1) do  //--- тогда пытаемся поиском определить индекс нужной задачи и удалить Delete(Index)
   if (TaskList[tmpInt1].TaskNum = TaskList[tmpInt].TaskNum) then
    TaskList.Delete(TaskList[tmpInt1].TaskNum);
 //--- Передвинем номера строк на одну вверх (для отображения в Мемо) для всех задач, номера которых после удаляемой строки
// for tmpInt1:= tmpInt to (TaskList.Count - 1) do
//  if TaskList[tmpInt1].LineIndex_ForView > 0 then
//   TaskList[tmpInt1].LineIndex_ForView:= TaskList[tmpInt1].LineIndex_ForView - 1;
//--- После сдвига номеров строк в компоненте просмотра для всех задач, удаляем последнюю строку компонента просмотра
//--- Удаление строки компонента просмотра, соответствующей задаче из списка задач, не производим
//--- Отображение оставшихся задач автоматически сдвинется вверх по строкам мемо в процессе получения отчётов от задач

//---  Если текущая отображаемая в окне результатов строка стала меньше количества строк в списке задач, то уменьшим её тоже
 if Info_ForViewing.CurrentViewingTask > (TaskList.Count - 1) then
  AtomicDecrement(Info_ForViewing.CurrentViewingTask, 1);

 try
  if formMain.reThreadInfo_Main.Items.Count > 0 then
  begin
   formMain.reThreadInfo_Main.Items.Delete(formMain.reThreadInfo_Main.Items.Count - 1);
  end;
 except
  on tmpE: EListError do
   WriteDataToLog(tmpE.ClassName + tmpE.Message, 'formMain.bThreadStopClick', 'formMain');
 end;
//--- Удаляем задачу из списка задач компонента отображения (ЛистБокс)
 formMain.lbThreadList.Items.Delete(tmpInt);
//--- обновление информации о задаче
 if formMain.lbThreadList.ItemIndex > -1 then
//  PostMessage(Info_ForViewing.hMemoThreadInfo_1, WM_Data_Update, formMain.lbThreadList.ItemIndex, CMD_SetMemoStreamUpd)
 else
  formMain.memThreadInfo_1.Lines.Clear;

//--- Установим выделение строки, если есть хотя бы одна в списке
//--- Переведём выделение строки на одну вверх или, если эта последняя, то установим в -1
// if (TaskList.Count > 0) then
  if (formMain.lbThreadList.ItemIndex > (TaskList.Count - 1)) then
   formMain.lbThreadList.ItemIndex:= TaskList.Count - 1;

 except
  on tmpE: Exception do
   WriteDataToLog(tmpE.ClassName + tmpE.Message, 'formMain.bThreadStopClick', 'formMain');
 end;
end;

initialization

finalization

end.
