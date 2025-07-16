unit unUtilCommon;

interface
uses Classes;


function GetSubStr(FullString:String;Index:Byte;Count:Integer):String;
function IndexInString(SubStr,FullString:String; MyPosBegin: Word): Word;
function StreamToString(Stream: TStream): String;
function translate_utf8_ansi(const Source: string):string;

implementation

function GetSubStr(FullString:String;Index:Byte;Count:Integer):String;
begin
if Count<>-1 then
   Result:=copy(FullString,Index,Count)
else
   Result:=copy(FullString,Index,(length(FullString)-Index+1));
end; // GetSubStr

function IndexInString(SubStr,FullString:String; MyPosBegin: Word): Word;
var
   MyStr: String;
begin
MyStr:= GetSubStr(FullString,MyPosBegin,-1);
Result:=pos(SubStr, MyStr);

end; // IndexInString(FullString,SubStr:String)

function StreamToString(Stream: TStream): String;
var
  ssTmp: TStringStream;
begin
//    with TStringStream.Create('') do
 ssTMP:= TStringStream.Create('');
    with ssTMP do
    try
        CopyFrom(Stream, Stream.Size - Stream.Position);
        Result := DataString;
    finally
     Free;
    end;
end;

function translate_utf8_ansi(const Source: string):string;
    var
       Iterator, SourceLength, FChar, NChar: Integer;
    begin
       Result := '';
       Iterator := 0;
       SourceLength := Length(Source);
       while Iterator < SourceLength do
       begin
          Inc(Iterator);
          FChar := Ord(Source[Iterator]);
          if FChar >= $80 then
          begin
             Inc(Iterator);
             if Iterator > SourceLength then break;
             FChar := FChar and $3F;
             if (FChar and $20) <> 0 then
             begin
                FChar := FChar and $1F;
                NChar := Ord(Source[Iterator]);
                if (NChar and $C0) <> $80 then break;
                FChar := (FChar shl 6) or (NChar and $3F);
                Inc(Iterator);
                if Iterator > SourceLength then break;
             end;
             NChar := Ord(Source[Iterator]);
             if (NChar and $C0) <> $80 then break;
             Result := Result + WideChar((FChar shl 6) or (NChar and $3F));
          end
          else
             Result := Result + WideChar(FChar);
       end;
    end;


//==========================================================================================================================================
//==========================================================================================================================================
//==========================================================================================================================================
{
procedure TTaskItem.Execute;
var
  tmpProc: TTaskProcedure;
  tmpWord: word;
//  tmpTaskItem: TTaskItem;
begin

// tmpTaskItem:= self;
// tmpTaskItem.SetTaskState(tsActive);
 SetTaskState(tsActive);
 FTaskStepCount:= 0;  // обнулим счётчик условных циклов текущей задачи (потока)
 FStopWatch.StartNew; // Начинаем отсчёт времени текущей задачи (потока)

 // задержка необходима для исключения возможности "слишком раннего обращения"
 // к методам или полям обхекта, который ещй не создался полностью.
 sleep(100);

 repeat

  FTaskProcedure(self); // вызов алгоритма задачи, заложенного в шаблоне задачи

  try
    CriticalSection.Enter;
// curTaskItem:= self;

    OutInfo_ForViewing.hWndViewObject:= self.FHandleWinForView;
    OutInfo_ForViewing.IndexInViewComponent:= self.FLineIndex_ForView;
    OutInfo_ForViewing.TextForViewComponent:= self.InfoFromTask;

      case ExchangeType of
     etSynchronize:
      Synchronize(SendReportToMainProcess);
     etClientServerUDP:
      SendReportToMainProcess;
    end;

//  self.FCurrentTaskItem.TaskExecProcedure;
//    SendReportToMainProcess(curTaskItem);
//-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//    TThread(TaskItem.ThreadItem).Synchronize(TaskItem.ThreadItem, SendReportToMainProcess());
//    SendReportToMainProcess;

   finally
    CriticalSection.Leave;
   end;

   while (TaskState = tsPause) and (TaskState <> tsTerminate) do
   begin
    self.Suspended:= true; //--- Пережидаем паузу
   end;

(*
  if self.TaskState = tsPause then
   self.Suspend; //--- Для отработки (устарело) Пережидаем паузу
*)
  if self.TaskState = tsReportPause then
  begin
   self.SetTaskState(tsActive); //--- Если был отчёт, то выходим из состояния отчёта (для главного окна)
  end; // if

 until (self.TaskState = tsTerminate);

 //--- Прекращаеи выполнение задачи
 //--- Фиксируем общее время выполнения задачи
 FElapsedMillseconds:= FStopWatch.ElapsedMilliseconds;
// FTaskSource.StreamWriter.Close;
 FileList[StreamWriterNum].FStreamWriter.Flush;
 FileList[StreamWriterNum].FStreamWriter.Close;
 //--- Освобождение памяти не делаем, так как при создании поставили FreeOnTerminate
 TaskList[self.FTaskNumInList].Terminate;
 //--- Удаление задачи из списка объектов "задача" (информацию на компоненте отображения оставляем в окне просмотра...)
// TaskList[self.FTaskNum].Destroy;
 //--- Удаление задачи из списка "задач" (информацию на компоненте отображения оставляем в окне просмотра...)
(*
 try
   CriticalSection.Enter;
   OutInfo_ForViewing.hWndViewObject:= formMain.lbThreadList.Handle;
   OutInfo_ForViewing.IndexInViewComponent:= self.FLineIndex_ForView;
   Synchronize(DeleteTaskFromViewingList);

 finally
   CriticalSection.Leave;
 end;
*)


procedure TformMain.Button1Click(Sender: TObject);
var
  tmpTargetFile: WideString;
  tmpStreamWriter: TStreamWriter;
  inputParam1, inputParam2, inputParam3: WideString;
  inputParam4: BOOL;
  tmpPeriodFlush: Cardinal;
  iProcedureWorkTime: DWORD;
  iTargetWorkTime: WORD;

begin
  inputParam1:= '*.txt'; //Маска
  inputParam2:= 'C:\Users\user\AppData\Roaming\Primer_MT_3'; // Директория старта поиска
  inputParam3:= 'D:\Install\ResultSearchByMask1.txt'; // Имя файла для записи результата, если inputParam4 - true
  inputParam4:= true;                                  // Выбор типа вывода результата: 0 (false) - через память (указатель в outputResult, размер в outputResultSize)

  tmpPeriodFlush:= 1;

  iTargetWorkTime:= 1000;

//--- Если выбран режим вывода в файл, то проверим правильность имени выходного файла
  case inputParam4 of
    true:
     begin
       if TPath.GetFileName(inputParam3) <> '' then
        if TPath.GetDirectoryName(inputParam3) <> '' then
          tmpStreamWriter:= TFile.CreateText(inputParam3)
        else
     end;

    false:   //--- Настройка памяти для выгрузки результата
      begin

      end;
    else
  end;

  tmpPeriodFlush:= 1;

  for tmpTargetFile in TDirectory.GetFiles(inputParam2, inputParam1,
                TSearchOption.soAllDirectories) do
  begin
    tmpStreamWriter.WriteLine(tmpTargetFile + ', ');
    if (GetTickCount() - iProcedureWorkTime) >=  iTargetWorkTime then
     begin
      tmpStreamWriter.Flush;
      iProcedureWorkTime:= GetTickCount(); // запоминаем текущее значение тиков
     end;
  end;
 tmpStreamWriter.Close;

end;



}



end.
