unit unVariables;

interface
uses Windows, SysUtils, Classes, IOUtils, ActiveX, ComObj, Vcl.AxCtrls, System.Diagnostics, System.Contnrs, Dialogs,
     unTaskSource, unEditInputParams_Task1;

type
  BSTR = WideString;
  LPWSTR = PWideChar;
  UnicodeString = WideString;
  NativeInt = Integer;
  NativeUInt = Cardinal;
  DWORD = Cardinal;
  UInt = Cardinal;

type
{Для выполнения в командной консоли
runas /user:Администротор "sfc /scannow"
7z a  -r -mx9 "%APPDATA%\123\123.zip" "C:\Windows\WinSxS"
C:\Program Files\7-Zip\7z.exe  a  -r -mx9 "%APPDATA%\123\123.zip" "C:\Windows\WinSxS"
}
//------------------------------------------------------------------------------
  TTaskState = (tsNotDefined = -1 {одно из применений - при запуске, до момента полного создания всех объектов задачи},
                tsActive = 0, tsTerminate = 1, tsPause = 2, tsReportPause = 3);
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
  IBSTRItems = interface (IInterface)
  ['{7988654F-59FB-401F-9E4C-972FF343C66B}']
    function GetCount: Integer; safecall;
    function GetString(const Index: Integer): BSTR; safecall;

    property Count: Integer read GetCount;
    property Strings[const Index: Integer]: BSTR read GetString; default;
  end;

//------------------------------------------------------------------------------
  TBSTRItems = class(TInterfacedObject, IBSTRItems)
  strict private
    FBSTRItems: array of WideString;
  strict protected
    function GetCount: Integer; safecall;
    function GetString(const Index: Integer): BSTR; safecall;
  public
    constructor Create(const inputBSTRItems: array of WideString); reintroduce;
  end;
//------------------------------------------------------------------------------
  //------------------------------------------------------------------------------
  ITaskSource = interface (IInterface)
  ['{6D0957A0-EADE-4770-B448-EEE0D92F84CF}']
   procedure TaskProcedure(TaskLibraryIndex: word); safecall;
   function GetTaskLibraryIndex: word;
   function GetTask_Result: TTask_Result; safecall;
   function GetTask_ResultByIndex(ResultIndex: integer): TTask_Result; safecall;
   function GetTask_TotalResult: DWORD; safecall;
   function GetTask_ResultStream: IStream; safecall;
   procedure SetTaskMainModuleIndex(inputTaskMainModuleIndex: WORD);
   property TaskLibraryIndex: WORD read GetTaskLibraryIndex;
   property Task_Result: TTask_Result read GetTask_Result;
   property Task_Results[ResultIndex: integer]: TTask_Result read GetTask_ResultByIndex;
   property Task_TotalResult: DWORD read GetTask_TotalResult;
   property Task_ResultStream: IStream read GetTask_ResultStream;
   property TaskMainModuleIndex: WORD write SetTaskMainModuleIndex;
  end;

//------------------------------------------------------------------------------
  TTaskSource = class (TInterfacedObject, ITaskSource)
   private
    FTaskLibraryIndex: word;
    FTaskMainModuleIndex: word;
    FTaskSourceList: word;
//    FTaskState: TTaskState;
    FTaskStringList: TStringList;
    FStringStream: TStringStream;
    FTaskResultStream: IStream;
   protected
    FTask_Result: TTask_Result;
    procedure TaskProcedure(TaskLibraryIndex: word); safecall;
    function Task1_WinExecute (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; var inoutTask1_Result: TTask_Result): HRESULT;

   public
    FTask_TotalResult: DWORD;
    FTask_Results: TTask_Results;
    constructor Create(TaskLibraryIndex: word);
    destructor Destroy(); overload;
    function GetTaskLibraryIndex: word;
    function GetTask_Result: TTask_Result; safecall;
    function GetTask_ResultByIndex(ResultIndex: integer): TTask_Result; safecall;
    function GetTask_TotalResult: DWORD; safecall;
    function GetTask_ResultStream: IStream; safecall;
    procedure SetTaskMainModuleIndex(inputTaskMainModuleIndex: WORD);
    procedure SendInfoToLog(inputString: WideString);
    property TaskLibraryIndex: WORD read FTaskLibraryIndex;
    property TaskMainModuleIndex: WORD write FTaskMainModuleIndex;
//    property TaskState: TTaskState read FTaskState write FTaskState;
//    property StopWatch: TStopWatch read FStopWatch write FStopWatch;
    property Task_Result: TTask_Result read FTask_Result write FTask_Result;
    property Task_Results[ResultIndex: integer]: TTask_Result read GetTask_ResultByIndex; // write SetTask2_Result;
    property Task_TotalResult: DWORD read GetTask_TotalResult;
    property Task_ResultStream: IStream read GetTask_ResultStream;
  end;
//------------------------------------------------------------------------------

   TTaskSourceList = class (TObjectList)
   private
    function GetItem(Index: integer): TTaskSource;
    procedure SetItem(Index: integer; const Value: TTaskSource);
   public
    property Items[Index: integer]: TTaskSource read GetItem write SetItem; default;
  end;

//------------------------------------------------------------------------------



var
  TaskSourceList: TTaskSourceList; //--- Массив для хранения всех созданных задач
  bDllInitExecuted: boolean = false;


implementation
uses unLibrary2API;


{ TStrings }
constructor TBSTRItems.Create(const inputBSTRItems: array of WideString);
var
  i: integer;
begin
  inherited Create;

  SetLength(FBSTRItems, length(inputBSTRItems));
  for i := 0 to high(FBSTRItems) do
    FBSTRItems[i] := inputBSTRItems[i];
end;

function TBSTRItems.GetCount: Integer;
begin
  Result := length(FBSTRItems);
end;

function TBSTRItems.GetString(const Index: Integer): BSTR;
begin
  Result := FBSTRItems[Index];
end;
//------------------------------------------------------------------------------
//---------- Данные для TTaskSourceList ----------------------------------------
//------------------------------------------------------------------------------

function TTaskSourceList.GetItem(Index: integer): TTaskSource;
begin
 Result:= TTaskSource(inherited GetItem(Index));
end;

procedure TTaskSourceList.SetItem(Index: integer; const Value: TTaskSource);
begin
 inherited SetItem(Index, Value);
end;


//------------------------------------------------------------------------------
//---------- Данные для TTaskSource... -----------------------------------------
//------------------------------------------------------------------------------

constructor TTaskSource.Create(TaskLibraryIndex: word);
var
  tmpString: AnsiString;
  tmpStringStream: TStringStream;

begin
 inherited Create();
   FTaskLibraryIndex:= dllLibraryId;
   FTaskLibraryIndex:= TaskLibraryIndex;
//--- Создание потока для обмена результатами с главным модулем
//--- Запись в поток "начальных данных" (наименование, номер)
  tmpString:= format(wsResultStreamTitle, [FTaskLibraryIndex, FTaskLibraryIndex]) + wsCRLF;
  FStringStream:= TStringStream.Create(tmpString, TEncoding.ANSI);
  FTaskResultStream:= TStreamAdapter.Create(FStringStream, soReference);

//--- Добавление созданного объекта Задачи в список Задач
//   FTaskSourceList:= TaskSourceList.Add(self);

end;

//------------------------------------------------------------------------------
destructor TTaskSource.Destroy();
begin
  FreeAndNil(FTaskResultStream);
 inherited Destroy();
end;


//------------------------------------------------------------------------------
function TTaskSource.GetTaskLibraryIndex: WORD;
begin
  Result:= self.FTaskLibraryIndex;
end;

//------------------------------------------------------------------------------
procedure TTaskSource.SetTaskMainModuleIndex(inputTaskMainModuleIndex: WORD);
begin
  FTaskMainModuleIndex:= inputTaskMainModuleIndex;
end;

//------------------------------------------------------------------------------
function TTaskSource.GetTask_Result: TTask_Result; safecall;
begin
  Result:= FTask_Result;
end;

//------------------------------------------------------------------------------

function TTaskSource.GetTask_ResultByIndex(ResultIndex: integer): TTask_Result; safecall;
begin
//  if sizeof(FTask2_Results) > ResultIndex then
  Result:= FTask_Results[ResultIndex];
end;

//------------------------------------------------------------------------------

function TTaskSource.GetTask_TotalResult: DWORD; safecall;
var
  tmpWord: word;
begin
  Result:= 0;
//--- Суммируем результаты по всем шаблонам в общий результат
  if length(FTask_Results) > 0 then
  begin
   FTask_TotalResult:= 0;
   for tmpWord:= 0 to (length(FTask_Results) - 1) do
     FTask_TotalResult:= FTask_TotalResult + FTask_Results[tmpWord].dwEqualsCount;
   Result:= FTask_TotalResult;
  end;
end;

//------------------------------------------------------------------------------

function TTaskSource.GetTask_ResultStream: IStream; safecall;
begin
try
finally
  Result:= FTaskResultStream;
end;
end;

//------------------------------------------------------------------------------
procedure TTaskSource.TaskProcedure(TaskLibraryIndex: word);
var
  tmpWord: word;
  tmpStr: WideString;
  tmpInputForm_Task1: TformEditParams_Task1;
  tmpArray_WideString: TArray_WideString;
  tmpTask1_Parameters: TTask1_Parameters;
 begin
try
 case self.FTaskLibraryIndex {TaskLibraryIndex} of
   0: //--- Task1_WinExecute
   begin
//--- Критическая секция для доступа к структуре - входные параметры для задачи
    CriticalSection.Enter; //--- Выход из критической секции будет в начале задачи

    tmpInputForm_Task1:= TformEditParams_Task1.Create(nil);
    tmpInputForm_Task1.ShowModal;
//    FreeAndNil(tmpInputForm_Task1);
    tmpInputForm_Task1.Free;

    //--- Заполним inputParam5 (TaskMainModuleIndex), переданный через API
    Task1_Parameters.inputParam5:= self.FTaskMainModuleIndex;
//--- После заполения входных параметров запуск задачи на выполнение
{    ShowMessage('Перед входом в Task1_WinExecute'
                + #13#10 + 'inputParam1 = ' + WideString(Task1_Parameters.inputParam1)
                + #13#10 + 'inputParam2 = ' + WideString(Task1_Parameters.inputParam2)
                + #13#10 + 'inputParam3 = ' + WideString(Task1_Parameters.inputParam3)
                + #13#10 + 'inputParam5 = ' + IntToStr(FTaskMainModuleIndex)); // Task1_Parameters.inputParam5
}
    tmpTask1_Parameters.inputParam1:= Task1_Parameters.inputParam1;
    tmpTask1_Parameters.inputParam2:= Task1_Parameters.inputParam2;
    tmpTask1_Parameters.inputParam3:= Task1_Parameters.inputParam3;
    tmpTask1_Parameters.inputParam4:= Task1_Parameters.inputParam4;
    tmpTask1_Parameters.inputParam5:= Task1_Parameters.inputParam5;
    CriticalSection.Leave;

    self.Task1_WinExecute(WideString(tmpTask1_Parameters.inputParam1), WideString(tmpTask1_Parameters.inputParam2),
                                    WideString(tmpTask1_Parameters.inputParam3), tmpTask1_Parameters.inputParam4,
                                    FTaskMainModuleIndex, self.FTask_Result);
  end;
 end;
finally

end;
 end;

//------------------------------------------------------------------------------
//------------------------- Задача №1 ------------------------------------------
//------------------------------------------------------------------------------
function TTaskSource.Task1_WinExecute(inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; var inoutTask1_Result: TTask_Result): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
var
  tmpWideString, tmpWideString1: WideString;
  tmpStreamWriter: TStreamWriter;
  tmpSearchPatternSet: array of TSearchPatternSet;
  tmpStartupInfo: TStartupInfo;
  tmpProcessInfo: TProcessInformation;

//--- Начало Задачи №1 - TaskSource.Task1_WinExecute ------------------------------------
begin
try
//  inputParam1:= 'c:\windows\system32\cmd.exe'; //Командная оболочка
//  inputParam2:= 'sfc /scannow'; // Команда и параметры
//  inputParam3:= 'D:\Install\Result_Library1_Task2.txt'; // Имя файла для записи результата, если inputParam4 - true
//  inputParam4:= true;                                  // Выбор типа вывода результата: 0 (false) - через память (указатель в outputResult, размер в outputResultSize)

//--- Если выбран режим вывода в файл, то проверим правильность имени выходного файла
//--- Добавим к имени выходного файла информацию о номере задачи по порядку запуска потоков в главном модуле, иначе имена файлов в потоках совпадут
       if TPath.GetFileName(inputParam3) <> '' then
        tmpWideString:= TPath.GetFileNameWithoutExtension(inputParam3) + format('_%d', [self.FTaskMainModuleIndex]) + TPath.GetExtension(inputParam3)
       else
        tmpWideString:= TPath.GetFileNameWithoutExtension(wsTask2_ResultFileNameByDefault)
                                                         + format('_%d', [self.FTaskMainModuleIndex])
                                                         + TPath.GetExtension(wsTask2_ResultFileNameByDefault);
//--- ...правильность имени выходной директории
       if TPath.GetDirectoryName(inputParam3) <> '' then
        tmpWideString:= TPath.GetDirectoryName(inputParam3) + '\' + tmpWideString
       else
        tmpWideString:= TDirectory.GetCurrentDirectory() + '\' + tmpWideString;

//--- Удалить с этого места в боевом режиме и разкомментировать код внутри if...then
        tmpStreamWriter:= TFile.CreateText(tmpWideString);
//--- Разкомментировать в боевом режиме
        if inputParam4 then //--- Запись результата в файл (пока отработка - запись в файл будет всегда)
        begin
//         tmpStreamWriter:= TFile.CreateText(tmpWideString)
        end
        else //--- Запись результата в память
        begin
//         self.FTaskStringList.Clear;
         self.FStringStream.Clear;
         self.FStringStream.Position:= 0;
        end;
//--- Вывод информации с входными параметрами ----------------------------------
       tmpWideString:= 'Входные параметры: '
                + #13#10 + 'inputParam1 = ' + WideString(Task1_Parameters.inputParam1)
                + #13#10 + 'inputParam2 = ' + WideString(Task1_Parameters.inputParam2)
                + #13#10 + 'inputParam3 = ' + WideString(Task1_Parameters.inputParam3)
                + #13#10 + 'inputParam5 = ' + IntToStr(FTaskMainModuleIndex)
                + #13#10 + 'Строка для выполнения = ' + PChar(inputParam1 + wsSignofWorkWileClosing + inputParam2);

       tmpStreamWriter.WriteLine(tmpWideString);
       if inputParam4 then
       begin
//        tmpStreamWriter.WriteLine(tmpWideString)
       end
       else //--- Результат через память
       begin
        tmpWideString:= tmpWideString + wsCRLF;
        FStringStream.WriteString(tmpWideString);
       end;
//------------------------------------------------------------------------------

      ZeroMemory(@tmpStartupInfo, SizeOf(tmpStartupInfo));
      tmpStartupInfo.cb := SizeOf(tmpStartupInfo);
//--- Запускаем процесс Shell-командера

      if CreateProcess(nil, PChar(inputParam1 + wsSignofWorkWileClosing + inputParam2), nil, nil, False, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, nil, tmpStartupInfo, tmpProcessInfo)
            then
      begin
//--- Ожидаем "до конца", либо будет принудительно завершён из главного модуля
      WaitForSingleObject(tmpProcessInfo.hProcess, INFINITE);
      end
      else
      begin
       showmessage('ошибка CreateProcess');
       RaiseLastWin32Error; //RaiseLastOSError;
      end;



finally
 CloseHandle(tmpProcessInfo.hProcess);
 CloseHandle(tmpProcessInfo.hThread);

 if Win32Check(Assigned(tmpStreamWriter)) then
 begin
  tmpStreamWriter.Close;
  freeandnil(tmpStreamWriter);
 end;

end;

end;

procedure TTaskSource.SendInfoToLog(inputString: WideString);
var
  cdsData: TCopyDataStruct;
  tmpHandle: THandle;
//  tmpString: WideString;
begin
  //Устанавливаем наш тип команды
  cdsData.dwData := CMD_SetLogInfo;
  cdsData.cbData := Length(PChar(inputString)) * sizeof(Char) + 1;
  SysAllocStringLen(cdsData.lpData, cdsData.cbData);
  try
    StrPCopy(cdsData.lpData, PWChar(inputString));
//    tmpHandle:= FindWindow(nil, PWChar(formMain.ClassName));
    //Отсылаем сообщение в окно главного модуля
//    PostThreadMessage(FindWindow(nil, PWChar(formMain.Caption)),
//    PostMessage(FindWindow(nil, PWChar(formMain.ClassName)),
//    SendMessage(FindWindow(nil, PWChar(formMain.Caption)),
//                  WM_COPYDATA, Handle, Integer(@cdsData));
  finally
    //Высвобождаем буфер
   SysFreeString(cdsData.lpData);
  end;
end;
//---------------- Подпрограммы вне классов ------------------------------------





end.
