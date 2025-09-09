unit unUtils;

interface
uses Vcl.Forms, System.Classes, System.SysUtils, Winapi.Windows, Winapi.Messages, Vcl.StdCtrls, IOUtils,
     Vcl.AxCtrls, TlHelp32, ImageHlp, {PsAPI,}
     unVariables;

function GetWorkingDirectoryName(): WideString;
//function IsTaskDllAttached(DllFileName: String): Integer;
function GetLibraryInfo(inputDllFileName: WideString; inputLibraryNum: word): boolean;
//procedure GetDLLExportList(const DllFileName: string; var outputList: TArray<string>);
//--- Получение элементов из строки, разделённых ';'
procedure GetItemsFromString(SourceBSTR: WideString; var outputStringItems: TArray_WideString);
procedure FinalizeLibraries;
function LoadAnyLibrary(const LibraryFileName: WideString): HMODULE;
function GetPIDByName(const name: PWideChar): Cardinal;
function GetThreadsInfo(PID: Cardinal; var ThreadList: TArray<WideString>): Boolean;
function GetThreadsInfoBySubThread(PID: Cardinal; var memViewer: TMemo; memViewerLine: word): Boolean;
function MainThread_WndProc_Hook(nCode: integer; wParam, lParam: DWORD):LRESULT; stdcall;


implementation
uses unConst, unUtilCommon;

function GetWorkingDirectoryName(): WideString;
var
  tmpStr: string;
begin
 Result:= '';
try
 tmpStr:= GetEnvironmentVariable('APPDATA') + '\' + Copy(ExtractFileName(Application.ExeName), 1, Pos('.', ExtractFileName(Application.ExeName)) - 1);
 if not TDirectory.Exists(tmpStr) then
  TDirectory.CreateDirectory(tmpStr);
 Result:= tmpStr;
except
 on E: Exception do
    Writeln(E.ClassName, ': ', E.Message);
end;
{
----- Вариант работы с директориями и именами файлов до появления классов TDirectory, TFile
  tmpStr:= Copy(ExtractFileName(Application.ExeName), 1, Pos('.', ExtractFileName(Application.ExeName)) - 1);
  CreateDir(GetEnvironmentVariable('APPDATA') + '\' + tmpStr);
  tmpStr:= GetEnvironmentVariable('APPDATA') + '\' + tmpStr;
  tmpStr:= tmpStr + '\' + ExtractFileName(ChangeFileExt(Application.ExeName, '.txt' ));
  if FileExists(tmpStr) then DeleteFile(PWideChar(tmpStr));
  fsResult:= TFileStream.Create(ChangeFileExt(Application.ExeName, '.txt' ), fmCreate or fmOpenWrite);
  tmpStr:= Copy(ExtractFileName(Application.ExeName), 1, Pos('.', ExtractFileName(Application.ExeName)) - 1);
  CreateDir(GetEnvironmentVariable('APPDATA') + '\' + tmpStr);
  Result:= GetEnvironmentVariable('APPDATA') + '\' + tmpStr;
  tmpStr:= tmpStr + '\' + ExtractFileName(ChangeFileExt(Application.ExeName, '.txt' ));

}

end;


//------------------------------------------------------------------------------
function LoadAnyLibrary(const LibraryFileName: WideString): HMODULE;
begin
 try
  if FileExists(LibraryFileName) then
  begin
   Result := LoadLibrary(PWideChar(LibraryFileName)); //LoadLibraryEx(PWideChar(LibraryFileName), 0, LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR or LOAD_LIBRARY_SEARCH_DEFAULT_DIR);
   Win32Check(Result <> 0);
  end
  else
  begin
   Result:= 0;
   exit;
  end;
 finally
 end;
  SetLastError(0);
end;

//------------------------------------------------------------------------------
procedure GetItemsFromString(SourceBSTR: WideString; var outputStringItems: TArray_WideString);
var
  i: word;
begin
 if pos(';', SourceBSTR, 1) > 0 then
 begin
  i:= 0;
  while pos(';', SourceBSTR, 1) > 0 do
   begin
    outputStringItems[i]:= Copy(SourceBSTR, 1, pos(';', SourceBSTR, 1) - 1);
    delete(SourceBSTR, 1, Length(outputStringItems[i]) + 1); //--- удалим прочтённую запись и разделитель
    inc(i);
   end;
 end;
end;


//------------------------------------------------------------------------------
function GetLibraryInfo(inputDllFileName: WideString; inputLibraryNum: word): boolean;
var
  tmp_hTaskLibrary: THandle;  //--- он же HMODULE
  tmpDLLAPIProc: TDLLAPIProc;
  tmpWString: WideString; //--- Для обмена строками с Dll только BSTR (или в Делфи WideString)
  tmpInt: integer;
  tmpIntrfDllAPI: ILibraryAPI;
  tmpResult: HRESULT;
begin
// LibraryList[inputLibraryNum].LibraryName:= '';
 Result:= false;
try

 tmp_hTaskLibrary:= LoadAnyLibrary(inputDllFileName);
 if tmp_hTaskLibrary = INVALID_HANDLE_VALUE then
 begin
  WriteDataToLog(wsError_LoadLibrary + ': ' + inputDllFileName, 'GetLibraryInfo()', 'unUtils');
  exit;
 end;


//--- Получение интерфейса данной библиотеки с задачами
 try
  @tmpDLLAPIProc:= GetProcAddress(tmp_hTaskLibrary, DllProcName_LibraryInfo);
  if not Win32Check(Assigned(tmpDLLAPIProc)) then
  begin
   FreeLibrary(tmp_hTaskLibrary);
   WriteDataToLog(wsError_LoadLibraryWithTargetAPI + ': ' + inputDllFileName, 'GetLibraryInfo()', 'unUtils');
  end;
 except
  FreeLibrary(tmp_hTaskLibrary);
  WriteDataToLog(wsError_LoadLibraryWithTargetAPI + ': ' + inputDllFileName, 'GetLibraryInfo()', 'unUtils');
  exit;
 end;


//--- Настройка потока передачи результатов из библиотеки в главный модуль
//--- Дальнейшая настройка передачи будет сделана после подключения интерфейса библиотеки
//--- Создание потока желательно сделать до подключения интерфейса API библиотеки
//--- Так как в будущем может потребоваться вывод сообщений в журнал в подпрограмме создания интерфейса
//--- и тогда может получиться неинициализированная переменная LibraryList[inputLibraryNum].StringStream в оконных процедурах
//--- на данный момент первое сообщение-оповещение посылается в подпрограмме LibraryAPI.SetOwnerThread(MainModuleThreadId);
 tmpWString:= wsLibrary_Loaded;
 LibraryList[inputLibraryNum].StringStream:= TStringStream.Create(tmpWString, TEncoding.ANSI);

//--- Вызов интерфейса библиотеки
 tmpResult:= tmpDLLAPIProc(ILibraryAPI, tmpIntrfDllAPI);
 if (not Assigned(tmpIntrfDllAPI)) or (tmpResult <> S_OK) then
 begin
  FreeLibrary(tmp_hTaskLibrary);
  WriteDataToLog(wsError_LoadLibraryWithTargetAPI + ': ' + inputDllFileName, 'GetLibraryInfo()', 'unUtils');
  exit;
 end;

//--- Проверка на уже имеющуюся такую же библиотеку (путь другой, а функционал и версионность та же)
//--- Если уже есть в списке библиотек такая же, то отключаем данную библиотеку и выходим
 for tmpInt:= 0 to (inputLibraryNum - 1) do
 begin
  if (LibraryList.Items[tmpInt].LibraryId = tmpIntrfDllAPI.GetId) and
     (LibraryList.Items[tmpInt].LibraryName = tmpIntrfDllAPI.Name) and
     (LibraryList.Items[tmpInt].TaskCount = tmpIntrfDllAPI.TaskCount) then
  begin
   Result:= false;
   try
    tmpIntrfDllAPI._Release;
   finally
    tmpIntrfDllAPI:= nil;
    LibraryList[inputLibraryNum].StringStream.Free;
   end;
   WriteDataToLog(wsError_LoadLibraryAlreadyUse + ': ' + inputDllFileName, 'GetLibraryInfo()', 'unUtils');
  end;
  break;
 end;

if tmpIntrfDllAPI <> nil then  //--- Библиотека прошла проверку на отсутствие дубликатов, если нет - то сразу на выход с Result:= false;
begin

//--- Сохраним интерфейс в объекте LibraryTask
 if LibraryList[inputLibraryNum].LibraryAPI = nil then
    LibraryList[inputLibraryNum].LibraryAPI:= tmpIntrfDllAPI;

//--- Настройка потока (подключение к IStream) передачи результатов из библиотек в главный модуль
 LibraryList[inputLibraryNum].Stream:= TOleStream.Create(LibraryList[inputLibraryNum].LibraryAPI.Stream_Log);
 LibraryList[inputLibraryNum].StringStream.LoadFromStream(LibraryList[inputLibraryNum].Stream);
 LibraryList[inputLibraryNum].Stream_LastPos:= 0;

//--- Запись в библиотеку номера потока шлавного модуля
//--- Вывод сообщения (от библиотеки) о факте подключения в компонент отображения
 LibraryList[inputLibraryNum].LibraryAPI.SetOwnerThread(MainModuleThreadId);


//--- Получим Id библиотеки
 LibraryList[inputLibraryNum].LibraryId:= tmpIntrfDllAPI.GetId;

//--- Получим имя библиотеки
 LibraryList[inputLibraryNum].LibraryName:= tmpIntrfDllAPI.Name;

 //--- Получим количество реализованных в библиотеке задач
 LibraryList[inputLibraryNum].SetTaskTemplateCount(tmpIntrfDllAPI.GetTaskList.Count);
 //--- Получим имена реализованных задач
 for tmpInt:= 0 to (tmpIntrfDllAPI.GetTaskList.Count - 1) do
 begin
  LibraryList[inputLibraryNum].TaskTemplateName[tmpInt]:= tmpIntrfDllAPI.GetTaskList.Strings[tmpInt];
 end;

// tmpIntrfDllAPI.GetFormParams;

{
//--- Выделим из полученной строки первую запись - функциональное наименование библиотеки
  LibraryName:= AnsiString(Copy(tmpBSTR, 1, pos(';', tmpBSTR, 1) - 1));
  delete(tmpBSTR, 1, Length(LibraryName) + 1); //--- удалим прочтённую запись и разделитель

//--- Выделим наименования всех реализуемых задач
GetItemsFromString(tmpBSTR, TaskDllProcName);
}


 if intrfDllAPI = nil then
    LibraryList[inputLibraryNum].LibraryAPI:= tmpIntrfDllAPI;
  tmpIntrfDllAPI:= nil;

 //--- Один раз запустим LibraryAPI.InitDLL
//--- проверка на
  LibraryList[inputLibraryNum].LibraryAPI.InitDLL;

 LibraryList[inputLibraryNum].SetLibraryFileName(inputDllFileName);
 LibraryList[inputLibraryNum].LibraryHandle:= tmp_hTaskLibrary;

 Result:= true;
end;

finally
 if tmpintrfDllAPI <> nil then
 begin
//--- Уменьшим _RefCount для интерфейса бмблиотек
//--- Доступ к интерфейсу библиотек теперь только через LibraryList[inputLibraryNum.LibraryAPI
  tmpintrfDllAPI:= nil;
 end;
end;
end;


//------------------------------------------------------------------------------
function GetThreadsInfo(PID: Cardinal; var ThreadList: TArray<WideString>): Boolean;
  var
    SnapProcHandle: THandle;
    NextProc      : Boolean;
    ThreadEntry  : TThreadEntry32;
  begin
    SnapProcHandle := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0); //Создаем снэпшот всех существующих потоков
    Result := (SnapProcHandle <> INVALID_HANDLE_VALUE);
    if Result then
      try
        ThreadEntry.dwSize := SizeOf(ThreadEntry);
        NextProc := Thread32First(SnapProcHandle, ThreadEntry);//получаем первый поток
        while NextProc do begin
          if ThreadEntry.th32OwnerProcessID = PID then
          begin //проверка на принадлежность к процессу
           setlength(ThreadList, length(ThreadList) + 1);
           ThreadList[length(ThreadList) - 1]:= inttostr(ThreadEntry.th32ThreadID);
//              Writeln('base priority  ' + inttostr(ThreadEntry.tpBasePri));
//              Writeln('delta priority ' + inttostr(ThreadEntry.tpBasePri));
//              Writeln('');
          end;
          NextProc := Thread32Next(SnapProcHandle, ThreadEntry);//получаем следующий поток
        end;
      finally
        CloseHandle(SnapProcHandle);//освобождаем снэпшот
      end;
  end;

//------------------------------------------------------------------------------
function GetThreadsInfoBySubThread(PID: Cardinal; var memViewer: TMemo; memViewerLine: word): Boolean;
  var
    SnapProcHandle: THandle;
    NextProc      : Boolean;
    ThreadEntry  : TThreadEntry32;
  begin
    SnapProcHandle := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0); //Создаем снэпшот всех существующих потоков
    Result := (SnapProcHandle <> INVALID_HANDLE_VALUE);
    if Result then
      try
        ThreadEntry.dwSize := SizeOf(ThreadEntry);
        NextProc := Thread32First(SnapProcHandle, ThreadEntry);//получаем первый поток
        while NextProc do begin
          if ThreadEntry.th32OwnerProcessID = PID then begin //проверка на принадлежность к процессу
              memViewer.Lines[memViewerLine]:= memViewer.Lines[memViewerLine] + 'Thread ID ' + inttostr(ThreadEntry.th32ThreadID) + '; ';
//              Writeln('base priority  ' + inttostr(ThreadEntry.tpBasePri));
//              Writeln('delta priority ' + inttostr(ThreadEntry.tpBasePri));
//              Writeln('');
          end;
          NextProc := Thread32Next(SnapProcHandle, ThreadEntry);//получаем следующий поток
        end;
      finally
        CloseHandle(SnapProcHandle);//освобождаем снэпшот
      end;
  end;

//------------------------------------------------------------------------------
function GetPIDByName(const name: PWideChar): Cardinal;
var
  SnapProcHandle: THandle;
  ProcEntry : TProcessEntry32;
  NextProc : Boolean;
begin
  Result := 0;
  SnapProcHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  try
    ProcEntry.dwSize := SizeOf(ProcEntry);
    NextProc := Process32First(SnapProcHandle, ProcEntry);
    while NextProc do begin
      if StrComp(name, ProcEntry.szExeFile) = 0 then
        Result := ProcEntry.th32ProcessID;
      NextProc := Process32Next(SnapProcHandle, ProcEntry);
    end;
  finally
    CloseHandle(SnapProcHandle);
  end;
end;

//------------------------------------------------------------------------------
function MainThread_WndProc_Hook(nCode: integer; wParam, lParam: DWORD):LRESULT; stdcall;
var
  tmpNUI: NativeUInt;
  tmpBool: boolean;
  tmpMsg: TMsg;
  tmpMsgCount: byte;
//--- Для отработки - потом удалить!
tmpWord1, tmpWord2: word;
begin
try
//Result := CallNextHookEx(hMainThreadHook, nCode, wParam, lParam);
//exit;

 if nCode < 0 then
 begin
   exit;
 end;

 if (nCode = HC_ACTION) then
 begin
//--- Проверка очереди сообщений главного потока на наличие сообщений от API библиотек, задач (TaskItem)
//--- Если есть такие сообщения, то перенаправить их в компонент отображения главного модуля
  tmpBool:= PeekMessage(tmpMsg, 0, WM_Data_Update, WM_Data_Update, PM_REMOVE);
  if tmpBool and (tmpMsg.lParam = CMD_SetMemoLogStreamUpd) and IsNotifyMessage(tmpMsg.wParam) then //and (tmpMsg.hwnd = 0)then
    begin
     tmpMsgCount:= 0; //--- Счётчик количества пересылаемых сообщений за один перехват
     repeat
//--- скопируем исходные значения для отправляемого сооющения
//--- tmpMsg.lParam нет смысла копировать, так как в этот цикл мы попадаем по условию равенства tmpMsg.lParam = CMD_SetMemoLogStreamUpd
       tmpNUI:= tmpMsg.wParam;

//--- Проверим на наличие ещё сообщений нашего типа (пока без удаления) - это для проверки условия выхода из цикла (until)
      tmpBool:= PeekMessage(tmpMsg, 0, WM_Data_Update, WM_Data_Update, PM_REMOVE);
//--- Для отработки - потом удалить!
//--- Восстановление исходных значений TaskNum и SenderId из упакованного формата
//   tmpMsg.WParam:= tmpMsg.WParam and (not NotifySignBit);
//   tmpWord1:= tmpMsg.WParam; //--- WParamLo
//   tmpWord2:= tmpMsg.WParam shr 16; //--- WParamHi

//--- публикация нового сообщения уже для компонента отображения (TMemo)
      PostMessage(Info_ForViewing.hMemoLogInfo_2, WM_Data_Update, tmpNUI, CMD_SetMemoLogStreamUpd);
      inc(tmpMsgCount);
     until (not tmpBool)
           or ((tmpMsg.hwnd <> 0) and (tmpMsg.hwnd = Info_ForViewing.hMemoLogInfo_2))
           or (tmpMsgCount < iMsgCountForHook); //--- Это настраиваемый параметр. По умолчанию он равен

   end;
 end;

finally
Result := CallNextHookEx(hMainThreadHook, nCode, wParam, lParam);
end;
end;

//------------------------------------------------------------------------------
procedure FinalizeLibraries;
var
  tmpInt: integer;
begin
 for tmpInt:= 0 to (LibraryList.Count - 1) do
 begin
  if LibraryList[tmpInt].LibraryAPI <> nil then
  begin
   try
    LibraryList[tmpInt].LibraryAPI.FinalizeDLL;
   finally
    LibraryList[tmpInt].Stream.Free;
    LibraryList[tmpInt].StringStream.Free;
   end;
  end;
  if LibraryList[tmpInt].LibraryHandle <> 0 then
  begin
   try
    LibraryList[tmpInt].LibraryAPI._Release;
    LibraryList[tmpInt].LibraryAPI:= nil;
    FreeLibrary(LibraryList[tmpInt].LibraryHandle);
   finally
    LibraryList[tmpInt].LibraryHandle := 0;
   end;
  end;
 end;
end;



//------------------------------------------------------------------------------
//-------------- Варианты (требуется доработка через вирт. память --------------
//---- На данный момент не актуально -------------------------------------------
//------------------------------------------------------------------------------

{
function MainThread_WndProc_Hook(nCode: integer; wParam, lParam: DWORD):LRESULT; stdcall;
var
  tmpInt: integer;
  tmpBool: boolean;
  tmpStringList: TStringList;
  tmpPMsg: ^TCWPStruct;
  tmpMessage_Sender: TMessage_Sender;
  tmpPMessage_Sender: ^TMessage_Sender;
  tmpMsg: TMsg;
begin
try
 if nCode < 0 then
 begin
   exit;
 end;

 if (nCode = HC_ACTION) then
  tmpBool:= true;
  tmpPMsg:= Pointer(lParam);
  case tmpMsg.message of
   WM_Data_Update:
   begin
    if (tmpPMsg^.lParam = CMD_SetMemoLogStreamUpd) then
    begin
     try
//--- Проверка очереди сообщений главного потока на наличие сообщений от API библиотек, задач (TaskItem)
//--- Если есть такие сообщения, то перенаправить их в компонент отображения главного модуля
      tmpBool:= false;
//      repeat
//       if tmpBool then
//        tmpBool:= PeekMessage(tmpMsg, 0, WM_Data_Update, WM_Data_Update, PM_REMOVE);

//--- Перенесём данные из структуры TMessage_Sender, полученного сообщения в переменную (адресное пространство) главного модуля
       tmpPMessage_Sender:= Pointer(tmpPMsg^.wParam);
       tmpMessage_Sender.TaskNum:= tmpPMessage_Sender^.TaskNum;
       tmpMessage_Sender.SenderId:= tmpPMessage_Sender^.SenderId;
       PostMessage(Info_ForViewing.hMemoLogInfo_2, WM_Data_Update, Integer(@tmpMessage_Sender), CMD_SetMemoLogStreamUpd);

//       tmpBool:= PeekMessage(tmpMsg, 0, WM_Data_Update, WM_Data_Update, PM_NOREMOVE);
//      until (not tmpBool) and (tmpMsg.message = WM_Data_Update) and (tmpMsg.LParam = CMD_SetMemoLogStreamUpd);

    finally
    end;
   end;

   end;

  end;

finally
 Result := CallNextHookEx(hMainThreadHook, nCode, wParam, lParam);
end;

end;
}

initialization

finalization

end.
