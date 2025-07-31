unit unVariables;

interface
uses Windows, SysUtils, Classes, IOUtils, ActiveX, ComObj, Vcl.AxCtrls,
     System.Diagnostics, System.Contnrs, Dialogs, IniFiles, EncdDecd,
     unTaskSource, unEditInputParams_Task1, unEditInputParams_Task2;

type
  BSTR = WideString;
  LPWSTR = PWideChar;
  UnicodeString = WideString;
  NativeInt = Integer;
  NativeUInt = Cardinal;
  DWORD = Cardinal;
  UInt = Cardinal;

type

//------------------------------------------------------------------------------
  TTaskState = (tsNotDefined = -1 {одно из применений - при запуске, до момента полного создания всех объектов задачи},
                tsActive = 0, tsTerminate = 1, tsPause = 2, tsReportPause = 3);
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
//    constructor Create(const AStrings: array of BSTR); reintroduce;
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
    FTaskState: TTaskState;
    FTaskStringList: TStringList;
    FStringStream: TStringStream;
    FTaskResultStream: IStream;
   protected
    FTask_Result: TTask_Result;
    procedure TaskProcedure(TaskLibraryIndex: word); safecall;
    function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; out inoutTask1_Result: TTask_Result; out inoutTask1_Results: TTask_Results): HRESULT;
    function Task2_FindInFilesByPattern (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; var inoutTask2_Results: TTask_Results): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;

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
    property TaskLibraryIndex: WORD read FTaskLibraryIndex;
    property TaskMainModuleIndex: WORD write FTaskMainModuleIndex;
    property TaskState: TTaskState read FTaskState write FTaskState;
    property Task_Result: TTask_Result read FTask_Result write FTask_Result;
    property Task_Results[ResultIndex: integer]: TTask_Result read GetTask_ResultByIndex; // write SetTask2_Result;
    property Task_TotalResult: DWORD read GetTask_TotalResult;
    property Task_ResultStream: IStream read GetTask_ResultStream;
  end;


//  TTaskSourceList = TArray<TTaskSource>;
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
  LoadLibraryEx: function(lpFileName: PChar; Reserved: THandle; dwFlags: DWORD): HMODULE; stdcall;
  TaskSourceList: TTaskSourceList; //--- Массив для хранения всех созданных задач
  bDllInitExecuted: boolean = false;
  sWorkDirectory: WideString;

implementation
uses unLibrary1API;


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

//--- Создание потока для передачи результатов в главный модуль
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
  Result:= FTaskResultStream;
finally
end;
end;

//------------------------------------------------------------------------------
procedure TTaskSource.TaskProcedure(TaskLibraryIndex: word);
var
  tmpWord: word;
  tmpStr: WideString;
  tmpInputForm_Task1: TformEditParams_Task1;
  tmpInputForm_Task2: TformEditParams_Task2;
  tmpArray_WideString: TArray_WideString;
  tmpTask1_Parameters: TTask1_Parameters;
  tmpTask2_Parameters: TTask2_Parameters;
 begin
try
 case self.FTaskLibraryIndex {TaskLibraryIndex} of
   0: //--- Task1_FileFinderByMask
   begin
//--- Критическая секция для доступа к структуре - входные параметры для задачи
    CriticalSection.Enter;

    tmpInputForm_Task1:= TformEditParams_Task1.Create(nil);
    tmpInputForm_Task1.ShowModal;
//    FreeAndNil(tmpInputForm_Task1);
    tmpInputForm_Task1.Free;

    //--- Заполним inputParam5 (TaskMainModuleIndex), переданный через API
    Task1_Parameters.inputParam5:= self.FTaskMainModuleIndex;
//--- После заполения входных параметров запуск задачи на выполнение
    tmpTask1_Parameters.inputParam1:= Task1_Parameters.inputParam1;
    tmpTask1_Parameters.inputParam2:= Task1_Parameters.inputParam2;
    tmpTask1_Parameters.inputParam3:= Task1_Parameters.inputParam3;
    tmpTask1_Parameters.inputParam4:= Task1_Parameters.inputParam4;
    tmpTask1_Parameters.inputParam5:= Task1_Parameters.inputParam5;
    CriticalSection.Leave;

    self.Task1_FileFinderByMask(WideString(tmpTask1_Parameters.inputParam1), WideString(tmpTask1_Parameters.inputParam2),
                                WideString(tmpTask1_Parameters.inputParam3), tmpTask1_Parameters.inputParam4,
                                FTaskMainModuleIndex, self.FTask_Result, self.FTask_Results);
   end;



//-------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------ Задача №2 --------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------


   1: //--- Task2_FindInFilesByPattern
   begin
//--- Критическая секция для доступа к структуре - входные параметры для задачи
    CriticalSection.Enter; //--- Выход из критической секции будет в начале задачи

    tmpInputForm_Task2:= TformEditParams_Task2.Create(nil);
    tmpInputForm_Task2.ShowModal;
    FreeAndNil(tmpInputForm_Task2);
//    tmpInputForm_Task2.Free;

    //--- Заполним inputParam5 (TaskMainModuleIndex), переданный через API
//    Task2_Parameters.inputParam5:= self.FTaskMainModuleIndex;
//--- После заполения входных параметров запуск задачи на выполнение

    self.FTask_TotalResult:= 0;
    tmpTask2_Parameters.inputParam1:= Task2_Parameters.inputParam1;
    tmpTask2_Parameters.inputParam2:= Task2_Parameters.inputParam2;
    tmpTask2_Parameters.inputParam3:= Task2_Parameters.inputParam3;
    tmpTask2_Parameters.inputParam4:= Task2_Parameters.inputParam4;
    tmpTask2_Parameters.inputParam5:= Task2_Parameters.inputParam5;
    CriticalSection.Leave;

    self.Task2_FindInFilesByPattern(WideString(tmpTask2_Parameters.inputParam1), WideString(tmpTask2_Parameters.inputParam2),
                                    WideString(tmpTask2_Parameters.inputParam3), tmpTask2_Parameters.inputParam4,
                                    FTaskMainModuleIndex {Task1_Parameters.inputParam4}, self.FTask_Results); //, nil, 0);

   end;

 end;
finally

end;
 end;

//------------------------------------------------------------------------------
function TTaskSource.Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; out inoutTask1_Result: TTask_Result; out inoutTask1_Results: TTask_Results): HRESULT;
var
  tmpTargetFile: WideString;
  tmpStreamWriter: TStreamWriter;
  tmpMaskItems: TArray_WideString;
  tmpMaskItemsBool: TArray<boolean>;
  tmpMaskCount: word;
  tmpWord: word;
  tmpBool: Boolean;
  tmpWideString: WideString;
//-------------------------------------------------------------------------------
{
function IsNameAccordedByMask(inputFileName, inputMask: WideString): boolean;
var
  tmpMaskPart: WideString;
  tmpMaskParts: array of WideString;
  tmpMaskPartsCount: word;
  tmpBool: boolean;
  tmpInt: integer;
  tmpWord: word;
  tmpIsDelemiterFirst,
  tmpIsDelemiterLast: boolean;
begin
 Result:= false;
 try
 //--- Счётчик частей маски (часть - всё что между "*")
  tmpMaskPartsCount:= 0;
//--- Зафиксируем присутствие разделителей частей в начале и конце маски
  tmpIsDelemiterFirst:= (IndexInString(wsPartMaskDelemiter, inputMask, 1) = 1);
  tmpIsDelemiterLast:= (IndexInString(wsPartMaskDelemiter, inputMask, length(inputMask) - 1) = 1);
  repeat
//--- Копируем до разделителя частей масок
   tmpMaskPart:= GetSubStr(inputMask, 1, (length(inputMask) - (length(inputMask) - pos(wsPartMaskDelemiter, inputMask, 1)) - 1));
   if length(tmpMaskPart) > 0 then
   begin
    inc(tmpMaskPartsCount);
    setlength(tmpMaskParts, tmpMaskPartsCount);
    tmpMaskParts[tmpMaskPartsCount - 1]:= tmpMaskPart;
//--- Вырезаем скопированную масок
    delete(inputMask, 1, Length(tmpMaskPart) + 1); //--- удалим прочтённую запись и разделитель частей масок
   end
   else  //--- значит первый символ в маске это разделитель частей "*", удаляем его
    delete(inputMask, 1, Length(wsPartMaskDelemiter)); //--- удалим прочтённую запись и разделитель частей масок

  until (pos(wsPartMaskDelemiter, inputMask, 1) = 0) and (length(inputMask) = 0);

  tmpBool:= true; //--- Признак соответствия имени маски (всем частям маски), при первом несоответсвие станет false и выходим из цикла
  repeat
//--- Проход по всем выделенным частям маски
   for tmpInt:= 0 to (tmpMaskPartsCount - 1) do
   begin
    tmpWord:= IndexInString(tmpMaskParts[tmpWord], inputFileName, 1);
    tmpBool:= (tmpWord > 0)
              and (not ((tmpWord = 0) and (not tmpIsDelemiterFirst) and (length(inputFileName) > length(tmpMaskParts[tmpWord]))))  //--- исключаем ситуацию: первая часть маски начинается не с разделителя
              and (not ((tmpWord = (tmpMaskPartsCount - 1)) and (not tmpIsDelemiterLast) and (tmpWord <> (length(inputFileName) - length(tmpMaskParts[tmpWord]) + 1))));
    if not tmpBool then
     break;
//--- Вырезаем часть до, найденной части маски, включая текущую часть маски, из имени файла.
    delete(inputFileName, 1, Length(tmpMaskPart)); //--- удалим прочтённую запись и разделитель частей масок
   end;
  until (not tmpBool) or (length(inputMask) = 0);

  Result:= tmpBool;
 finally

 end;

end;
}
//------------------------------------------------------------------------------
begin
try
//--- Если выбран режим вывода в файл, то проверим правильность имени выходного файла
//--- Добавим к имени выходного файла информацию о номере задачи по порядку запуска потоков в главном модуле, иначе имена файлов в потоках совпадут
       if TPath.GetFileName(inputParam3) <> '' then
        tmpWideString:= TPath.GetFileNameWithoutExtension(inputParam3) + format('_%d', [FTaskMainModuleIndex]) + TPath.GetExtension(inputParam3)
       else
        tmpWideString:= TPath.GetFileNameWithoutExtension(wsTask1_ResultFileNameByDefault) + format('_%d', [FTaskMainModuleIndex]) + TPath.GetExtension(wsTask1_ResultFileNameByDefault);
//--- ...правильность имени выходной директории
       if TPath.GetDirectoryName(inputParam3) <> '' then
        tmpWideString:= TPath.GetDirectoryName(inputParam3) + '\' + tmpWideString
       else
        tmpWideString:= TDirectory.GetCurrentDirectory() + '\' + tmpWideString;

        try
         tmpStreamWriter:= TFile.CreateText(tmpWideString);
         if inputParam4 then //--- Запись результата в файл (пока отработка - запись в файл будет всегда)
//         tmpStreamWriter:= TFile.CreateText(tmpWideString)
         else //--- Запись результата в память
         begin
//         self.FTaskStringList.Clear;
          FStringStream.Clear;
          FStringStream.Position:= 0;
         end;
        except
         on E: Exception {EStreamError} do
         begin
          CriticalSection.Enter;
           WriteDataToLog(E.ClassName + ', E.Message = ' + E.Message, 'Task1_FileFinderByMask', 'unVariables');
          CriticalSection.Leave;
          raise;
         end;
        end;

//--- Вывод информации с входными параметрами ----------------------------------
       tmpWideString:= 'Входные параметры: '
                + #13#10 + 'inputParam1 = ' + WideString(Task1_Parameters.inputParam1)
                + #13#10 + 'inputParam2 = ' + WideString(Task1_Parameters.inputParam2)
                + #13#10 + 'inputParam3 = ' + WideString(Task1_Parameters.inputParam3)
                + #13#10 + 'inputParam4 = ' + IntToStr(ord(Task1_Parameters.inputParam4));

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


//--- Извлечение элементов-масок из входящей строки (inputParam1)
   GetPatternsFromString(inputParam1, tmpMaskItems, tmpMaskCount);
//--- заполнение поля исходными значениями в переменной результата задачи
    setlength(tmpMaskItemsBool, tmpMaskCount);
    setlength(inoutTask1_Results, tmpMaskCount);

   for tmpWord:= 0 to tmpMaskCount - 1 do
   begin
    inoutTask1_Results[tmpWord].dwEqualsCount:= 0; //--- Счётчик совпадений
    inoutTask1_Results[tmpWord].SearchPatternWS:= tmpMaskItems[tmpWord];
   end;
//--- Цикл перебора и сравнения с масками всех файлов в целевой директории
       inoutTask1_Result.dwEqualsCount:= 0;
       for tmpTargetFile in TDirectory.GetFiles(inputParam2, wsAllMask,
            TSearchOption.soAllDirectories) do
        begin
//          sleep(500); //--- Для отработки (для замедления процесса)
//--- Обнуляем признак сооьветствия маскам
         for tmpWord:= 0 to (tmpMaskCount - 1) do
         begin
          tmpMaskItemsBool[tmpWord]:= false;
         end;
//--- Проверяем соответствие текущего файла всем маскам
         for tmpWord:= 0 to (tmpMaskCount - 1) do
         begin
          if (IsNameAccordedByMask(tmpTargetFile, tmpMaskItems[tmpWord])) then
          begin
           inc(inoutTask1_Results[tmpWord].dwEqualsCount);
           tmpMaskItemsBool[tmpWord]:= true;
          end;
         end;

//--- Проверяем было ли соответствие маскам и если было, то выводим результат по текущему файлу и маскам, которым он соответствует
         if IsAccorded(tmpMaskItemsBool, tmpMaskCount) then
         begin
          inc(inoutTask1_Result.dwEqualsCount);
 {
           tmpStreamWriter.WriteLine(tmpTargetFile + ', ');  //--- пока отработка - запись в файл будет всегда
            if inputParam4 then
//              tmpStreamWriter.WriteLine(tmpTargetFile + ', ')
            else //--- Результат через память
            begin
             tmpWideString:= tmpTargetFile + ', ' + wsCRLF;
             FStringStream.WriteString(tmpWideString);
            end;
 }
 //--- Вывод на печать результата по текущему (проверяемому) файлу
          tmpWideString:= '';
          for tmpWord:= 0 to (tmpMaskCount - 1) do
          begin
           if tmpMaskItemsBool[tmpWord] then
            tmpWideString:= tmpWideString + tmpMaskItems[tmpWord] + ItemDelemiter;
          end;
          tmpWideString:= format(wsTask1_Result_TemplateView, [tmpWideString, tmpTargetFile]);
//             tmpWideString:= wsTask2_Result_TemplateView_Part1 + ByteToWS(inputSearchPatternSet[tmpWord].Pattern, inputSearchPatternSet[tmpWord].PatternSize)
//                             + wsTask2_Result_TemplateView_Part2 + inttostr(inputSearchPatternSet[tmpWord].LastPosBeginSearch) + wsCRLF;;
          tmpStreamWriter.WriteLine(tmpWideString); //--- пока отработка - запись в файл будет всегда
          if inputParam4 then
          begin
//           inputStreamWriter.WriteLine(format(wsTask1_Result_TemplateView, [tmpWideString]));
//             FStringStream.WriteString(tmpWideString);
          end
          else //--- Результат через память
          begin
           tmpWideString:= format(wsTask1_Result_TemplateView, [tmpWideString, tmpTargetFile]) + wsCRLF;
           FStringStream.WriteString(tmpWideString);
          end;

           end;


        end;

//--- Вывод на печать общего результата по всем файлам
        tmpWideString:= wsCRLF + format(wsTask1_TotalResult_TemplateView, [inoutTask1_Result.dwEqualsCount]) + wsCRLF;
        tmpStreamWriter.WriteLine(tmpWideString); //--- пока отработка - запись в файл будет всегда
        for tmpWord:= 0 to (tmpMaskCount - 1) do
        begin
         if tmpMaskItemsBool[tmpWord] then
          tmpWideString:= format(wsTask1_TotalResultByMask_TemplateView, [tmpMaskItems[tmpWord], inoutTask1_Results[tmpWord].dwEqualsCount]);
          tmpStreamWriter.WriteLine(tmpWideString); //--- пока отработка - запись в файл будет всегда
        end;

        if inputParam4 then
        begin
{
        tmpStreamWriter.WriteLine(tmpWideString); //--- пока отработка - запись в файл будет всегда
        for tmpWord:= 0 to (tmpMaskCount - 1) do
        begin
         if tmpMaskItemsBool[tmpWord] then
          tmpWideString:= format(wsTask1_TotalResultByMask_TemplateView, [tmpMaskItems[tmpWord], inoutTask1_Results[tmpWord].dwEqualsCount]);
          tmpStreamWriter.WriteLine(tmpWideString); //--- пока отработка - запись в файл будет всегда
        end;
}
        end
        else //--- Результат через память
        begin
         tmpWideString:= wsCRLF + format(wsTask1_TotalResult_TemplateView, [inoutTask1_Result.dwEqualsCount]) + wsCRLF;
         FStringStream.WriteString(tmpWideString);
         for tmpWord:= 0 to (tmpMaskCount - 1) do
         begin
          if tmpMaskItemsBool[tmpWord] then
           tmpWideString:= format(wsTask1_TotalResultByMask_TemplateView, [tmpMaskItems[tmpWord], inoutTask1_Results[tmpWord].dwEqualsCount]);
           FStringStream.WriteString(tmpWideString); //--- пока отработка - запись в файл будет всегда
         end;
        end;


finally
 if Win32Check(Assigned(tmpStreamWriter)) then
 begin
  tmpStreamWriter.Close;
  freeandnil(tmpStreamWriter);
 end;
end;
end;

//------------------------------------------------------------------------------
//------------------------- Задача №2 ------------------------------------------
//------------------------------------------------------------------------------
function TTaskSource.Task2_FindInFilesByPattern (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; var inoutTask2_Results: TTask_Results): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
var
  tmpWideString: WideString;
  tmpStreamWriter: TStreamWriter;
  tmpPatternList: array of TSearchPattern;
  tmpPatternItemsStr: TArray_WideString;
  tmpPatternItems: RawByteString;
  tmpPatternCount, tmpWord, tmpWord1, tmpWord2: word;
  tmpSearchPatternSet: array of TSearchPatternSet;

//------------------------------------------------------------------------------
procedure CountPatternIncluding(inputTargetFileName: WideString; inputParam4: boolean; var inputSearchPatternSet: array of TSearchPatternSet; inputPattenCount: DWORD; var inoutTask2_Results: TTask_Results; inputStreamWriter: TStreamWriter);
var
  tmpFileStream: TFileStream;
  tmpTargetFileBuffer: TTargetFile;
  tmpWord: word;
  tmpBool: boolean;
  tmpDword: DWORD;
//  tmpInt: integer;
//  tmpBaseStartPosForAllPatterns: DWORD;

begin
try
  //--- Создание потока для целевого файла
  tmpFileStream:= TFileStream.Create(inputTargetFileName, fmOpenRead or fmShareDenyWrite);
  SetLength(tmpTargetFileBuffer, tmpFileStream.Size);
  tmpFileStream.ReadBuffer(Pointer(tmpTargetFileBuffer)^, Length(tmpTargetFileBuffer));
  tmpFileStream.Position:= 0;

//--- Начальные условия - поиск с начала файла
//--- заполнение поля "шаблон" в переменной результата задачи
   for tmpWord:= 0 to inputPattenCount - 1 do //sizeof(inputSearchPatternSet) do
   begin
    inputSearchPatternSet[tmpWord].LastPosBeginSearch:= 0;
    inoutTask2_Results[tmpWord].SearchPattern:= inputSearchPatternSet[tmpWord].Pattern;
   end;

//--- Поиск в файле
       while (tmpFileStream.Position < tmpFileStream.Size) do
        begin
//------------------------------------------------------------------------------
//         sleep(5); //--- Для отработки (для замедления процесса)
//------------------------------------------------------------------------------

         tmpBool:= false;
         tmpDword:= 0;

//=== В цикле перебираем все шаблоны и выполняем поиск каждого (или одного, если режим многопоточности)
         for tmpWord:= 0 to inputPattenCount - 1 do //sizeof(inputSearchPatternSet) do
         begin
//--- Проверка: поиск по жанному шаблону уже прогнан до конца файла...
          if inputSearchPatternSet[tmpWord].LastPosBeginSearch < iPatternNotFound then
          begin
//--- Если, хотя бы раз выполняется условиек LastPosBeginSearch < iPatternNotFound, значит есть ещё шаблоны прогнанные не до конца файла
           tmpBool:= true;
           tmpFileStream.Position:= inputSearchPatternSet[tmpWord].LastPosBeginSearch;
           tmpDWord:= GetPosForPattern(Pointer(tmpTargetFileBuffer), tmpFileStream.Size,
                               inputSearchPatternSet[tmpWord], tmpFileStream.Position); //inputSearchPatternSet[tmpWord].LastPosBeginSearch);

           if (tmpDWord < iPatternNotFound) then
           begin
            inputSearchPatternSet[tmpWord].LastPosBeginSearch:= tmpDword + inputSearchPatternSet[tmpWord].PatternSize + 1; //--- Сохраняем позицию, с которой будет продолжен поиск по данному шаблону

//--- В tmpFileStream.Position храним наименьшую позицию начала поиска для шаблонов
//--- именно по этой переменной и определим конец поиска в цикле while
           if tmpFileStream.Position > inputSearchPatternSet[tmpWord].LastPosBeginSearch then
            tmpFileStream.Position:= inputSearchPatternSet[tmpWord].LastPosBeginSearch;
            inc(inoutTask2_Results[tmpWord].dwEqualsCount);

            CriticalSection.Enter;
             tmpWideString:= format(wsTask2_Result_TemplateView, [ByteToWS(inputSearchPatternSet[tmpWord].Pattern, inputSearchPatternSet[tmpWord].PatternSize),
                                                                 inputSearchPatternSet[tmpWord].LastPosBeginSearch]);
//             tmpWideString:= wsTask2_Result_TemplateView_Part1 + ByteToWS(inputSearchPatternSet[tmpWord].Pattern, inputSearchPatternSet[tmpWord].PatternSize)
//                             + wsTask2_Result_TemplateView_Part2 + inttostr(inputSearchPatternSet[tmpWord].LastPosBeginSearch) + wsCRLF;;
             inputStreamWriter.WriteLine(tmpWideString); //--- пока отработка - запись в файл будет всегда
             if inputParam4 then
             begin
//             inputStreamWriter.WriteLine(format(wsTask2_Result_TemplateView, [ByteToWS(inputSearchPatternSet[tmpWord].Pattern, inputSearchPatternSet[tmpWord].PatternSize),
//                                                                             inputSearchPatternSet[tmpWord].LastPosBeginSearch]));
//             FStringStream.WriteString(tmpWideString);
             end
             else //--- Результат через память
             begin
              tmpWideString:= format(wsTask2_Result_TemplateView, [ByteToWS(inputSearchPatternSet[tmpWord].Pattern, inputSearchPatternSet[tmpWord].PatternSize),
                                                                             inputSearchPatternSet[tmpWord].LastPosBeginSearch]) + wsCRLF;
              FStringStream.WriteString(tmpWideString);
             end;

            CriticalSection.Leave;

           end
           else
           begin
            inputSearchPatternSet[tmpWord].LastPosBeginSearch:= iPatternNotFound;
           end;
          end;
         end;

//--- Если все щаблоны проверены до конца файла, то ставим на конец файла и далее выходим из whilr
         if not tmpBool then
          tmpFileStream.Position:= tmpFileStream.Size;

        end;

finally
 FreeAndNil(tmpFileStream);
end;
end;



//--- Начало Задачи №2 - TaskSource.Task2_FindInFilesByPattern ------------------------------------
begin
try
//  inputParam1:= 'resource;ozX'; //'resource'; //Шаблон
//  inputParam2:= 'D:\Install\FFscriptCache.bin'; // Целевой файл (в котором поиск)
//  inputParam3:= 'D:\Install\Result_Library1_Task2.txt'; //'D:\Install\ResultSearchByMask1.txt'; // Имя файла для записи результата, если inputParam4 - true
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
                + #13#10 + 'inputParam1 = ' + WideString(Task2_Parameters.inputParam1)
                + #13#10 + 'inputParam2 = ' + WideString(Task2_Parameters.inputParam2)
                + #13#10 + 'inputParam3 = ' + WideString(Task2_Parameters.inputParam3)
                + #13#10 + 'inputParam4 = ' + IntToStr(ord(Task2_Parameters.inputParam4));

//--- Удалить с этого места в боевом режиме и разкомментировать код внутри if...then
       tmpStreamWriter.WriteLine(tmpWideString);
//--- Разкомментировать в боевом режиме
       if inputParam4 then
       begin
//        tmpStreamWriter.WriteLine(tmpWideString)
       end
       else //--- Результат через память
       begin
        tmpWideString:= tmpWideString + wsCRLF;
        FStringStream.WriteString(tmpWideString);
       end;



//--- Извлечение элементов-шаблонов из входящей строки (inputParam1)
       GetPatternsFromString(inputParam1, tmpPatternItemsStr, tmpPatternCount);
//--- Заполнение структур шаблонов поиска согласно входных параметров

//--- Преобразование шаблонов из WideString (формат отображения) в array of byte
       setlength(tmpSearchPatternSet, tmpPatternCount);
       setlength(inoutTask2_Results, tmpPatternCount);

       for tmpWord:= 0 to tmpPatternCount - 1 do
       begin
        setlength(tmpSearchPatternSet[tmpWord].Pattern, length(tmpPatternItemsStr[tmpWord]));
        tmpSearchPatternSet[tmpWord].Pattern:= WSToByte(tmpPatternItemsStr[tmpWord]);
        tmpSearchPatternSet[tmpWord].PatternSize:= length(tmpSearchPatternSet[tmpWord].Pattern);
       end;

//--- подпрограмма поиска шаблонов в целевом файле
       CountPatternIncluding(inputParam2, inputParam4, tmpSearchPatternSet, tmpPatternCount, inoutTask2_Results, tmpStreamWriter);

       tmpWideString:= 'Всего найдено совпадений: ' + IntToStr(self.Task_TotalResult);
//--- Удалить с этого места в боевом режиме и разкомментировать код внутри if...then
       tmpStreamWriter.WriteLine(tmpWideString);
       for tmpWord:= 0 to (tmpPatternCount - 1) do
       begin
        tmpSearchPatternSet[tmpWord].Pattern:= WSToByte(tmpPatternItemsStr[tmpWord]);
        tmpStreamWriter.WriteLine(format(wsTask2_TotalResult_TemplateView, [ByteToWS(inoutTask2_Results[tmpWord].SearchPattern, tmpSearchPatternSet[tmpWord].PatternSize),
                                                                              inoutTask2_Results[tmpWord].dwEqualsCount]));
       end;
//---------------------------------------------------
       if inputParam4 then
       begin  //--- Разкомментировать в боевом режиме
//        tmpStreamWriter.WriteLine(tmpWideString);
//        for tmpWord:= 0 to (tmpPatternCount - 1) do
//        begin
//         tmpSearchPatternSet[tmpWord].Pattern:= WSToByte(tmpPatternItemsStr[tmpWord]);
//         tmpStreamWriter.WriteLine(format(wsTask2_TotalResult_TemplateView, [ByteToWS(inoutTask2_Results[tmpWord].SearchPattern, tmpSearchPatternSet[tmpWord].PatternSize),
//                                                                             inoutTask2_Results[tmpWord].dwEqualsCount]));
       end
       else //--- Результат через память
       begin
        tmpWideString:= tmpWideString + wsCRLF;
        FStringStream.WriteString(tmpWideString);
        for tmpWord:= 0 to (tmpPatternCount - 1) do
        begin
         tmpSearchPatternSet[tmpWord].Pattern:= WSToByte(tmpPatternItemsStr[tmpWord]);
         tmpWideString:= format(wsTask2_TotalResult_TemplateView, [ByteToWS(inoutTask2_Results[tmpWord].SearchPattern, tmpSearchPatternSet[tmpWord].PatternSize),
                                                                              inoutTask2_Results[tmpWord].dwEqualsCount]) + wsCRLF;
         FStringStream.WriteString(tmpWideString);
       end;

       end;


       tmpStreamWriter.Close;


finally
 if Win32Check(Assigned(tmpStreamWriter)) then
 begin
  tmpStreamWriter.Close;
  freeandnil(tmpStreamWriter);
 end;
end;

end;


//---------------- Подпрограммы вне классов ------------------------------------




end.
