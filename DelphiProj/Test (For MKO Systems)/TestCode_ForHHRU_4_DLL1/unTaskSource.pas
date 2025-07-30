unit unTaskSource;

interface
uses   Windows, ActiveX, Classes, IOUtils, SysUtils, System.SyncObjs, Dialogs, DateUtils;

//--- Для Задачи №1 ------------------------------------------------------------
const
  ItemDelemiter = ';';
  wsBeginMask: WideString = '*.';
  wsAllMask: WideString = '*';
  wsTask1_Name: WideString = 'Поиск файлов по маске';
  wsTask2_Name: WideString = 'Поиск в файлах по шаблонам';
  wsTask1_ResultFileNameByDefault: WideString = 'Lib1_Task1_Result.txt';
  wsTask2_ResultFileNameByDefault: WideString = 'Lib1_Task2_Result.txt';
  wsTask2_Result_TemplateView: WideString = 'Шаблон: %12s, Позиция в файле: %d';
  wsTask2_TotalResult_TemplateView: WideString = 'Шаблон: %12s, Всего совпадений: %d';
  wsResultStreamTitle: WideString = 'Библиотека №%d, Задача №%d';
  wsCRLF = #13#10;

//--- Для Задачи №2 ------------------------------------------------------------
const
  iPatternNotFound = $FFFFFFFF;
  Task2_DefaultBufferSize = 4096;
type
//------------------- Для Задачи №2 --------------------------------------------

  TTargetFile = array of byte;
  TSearchPattern = array of byte;

  TSearchPatternSet = packed record
    LastPosBeginSearch: DWORD;
    Pattern: TSearchPattern;
    PatternSize: DWORD;
  end;

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//--- Входные параметры Задачи №1 (Индекс задачи в библиотеке - 0)

  TTask1_Parameters = packed record
    inputParam1: PWideChar; //--- Маска
    inputParam2: PWideChar; //--- Директория старта поиска
    inputParam3: PWideChar; //--- Имя файла для записи результата, если inputParam4 - true (т.е. запись результата в файл)
    inputParam4: BOOL;       //--- Выбор типа вывода результата: 0 (false) - через память (указатель в outputResult, размер в outputResultSize)
    inputParam5: WORD;      //--- Номер (индекс) задачи в перечне в главном модуле (индекс в элементе отображения)
  end;

//------------------------------------------------------------------------------
//--- Входные параметры Задачи №2 (Индекс задачи в библиотеке - 1)

  TTask2_Parameters = packed record
    inputParam1: PWideChar; //array of byte; //--- Шаблон поиска
    inputParam2: PWideChar; //--- Файл для поиска содержащихся шаблонов поиска
    inputParam3: PWideChar; //--- Имя файла для записи результата, если inputParam4 - true (т.е. запись результата в файл)
    inputParam4: BOOL;       //--- Выбор типа вывода результата: 0 (false) - через память (указатель в outputResult, размер в outputResultSize)
    inputParam5: WORD;      //--- Номер (индекс) задачи в перечне в главном модуле (индекс в элементе отображения)
  end;

//------------------------------------------------------------------------------
//--- Выходные параметры Задач: №1,№2 (Индексы задач в библиотеке: 0, 1)

  TTask_Result = packed record
    dwEqualsCount: DWORD;
    SearchPattern: TSearchPattern;
  end;


//------------------------------------------------------------------------------
  TTask_Results = array of TTask_Result;
  TArray_WideString = array [0..High(Byte)] of WideString;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------

  ILibraryLog = interface (IInterface)
  ['{417D26A0-0BA7-4F69-877C-0E80A224E8EA}']
    function GetStream: IStream; safecall;
    property Stream: IStream read GetStream;
  end;

//------------------------------------------------------------------------------
  TLibraryLog = class(TInterfacedObject, ILibraryLog)
  strict private
    FStringStream: TStringStream;
    FStream: IStream;
  strict protected
  public
    constructor Create();
    function GetStream: IStream; safecall;
    property StringStream: TStringStream read FStringStream;
    property Stream: IStream read GetStream;
  end;
//------------------------------------------------------------------------------


var
  CriticalSection: TCriticalSection;
  Task1_Parameters: TTask1_Parameters;
  Task2_Parameters: TTask2_Parameters;
  LibraryLog: TLibraryLog;



//--- Основныеные функции (реализация функционала библиотеки)
//--- Задача №1 - Поиск файлов по маске/маскам
//function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; out outTask1_Result: TTask1_Result): HRESULT;

//--- Вспомогательные функции
procedure WriteDataToLog(E_source1, CurrentProcName, CurrentUnitName: WideString);
function GetWorkingDirectoryName(): WideString;
//--- Извлечение элементов строки, разделённых символом-разделителем
procedure GetItemsFromString(inputSourceBSTR: WideString; var outputStringItems: TArray_WideString; var outputMaskCount: word);
function GetSubStr(inSourceString: WideString; inIndex:Byte; inCount:Integer): WideString;
function IndexInString(inSubStr, inSourceString: WideString; inPosBegin: word): word;
//--- Для Задачи №2 ------------
procedure GetPatternsFromString(inputSourceBSTR: WideString; var outputStringItems: TArray_WideString; var outputPatternCount: word);
function GetPosForPattern(inputBuffer: Pointer; inputFileSize: DWORD; inputSearchPatternSet: TSearchPatternSet; inputPosBeginSearch: DWORD): DWORD;
function WSToByte(inputWideString: WideString): TSearchPattern;
function ByteToWS(inputBytes: TSearchPattern; inputBytesSize: dword): WideString;



implementation


//------------------------------------------------------------------------------
//---------- Данные для TLibraryLog --------------------------------------
//------------------------------------------------------------------------------
constructor TLibraryLog.Create;
begin
try
 inherited Create();
 FStringStream:= TStringStream.Create('', TEncoding.ANSI);
 FStream:= TStreamAdapter.Create(FStringStream, soReference);

finally
end;
end;


function TLibraryLog.GetStream: IStream; safecall;
begin
try
  Result:= FStream;
finally
end;
end;


{
function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; out outTask1_Result: TTask1_Result): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
var
  inputParam5, iProcedureWorkTime: DWORD;
  tmpTargetFile: WideString;
  tmpStreamWriter: TStreamWriter;
  tmpMaskItems: TArray_WideString;
  tmpMaskCount: word;
  tmpInt, tmpInt1, tmpWord3: word;
  tmpBool: Boolean;
  tmpPAnsiChar: PAnsiChar;
  tmpPWideChar: PWideChar;
  tmpWideString: WideString;

begin
try
    CriticalSection.Leave; //--- Вход в критическую секцию был до вызова окна с входными параметрами

//  inputParam1:= '*.txt;*.txt1'; //Маска
//  inputParam2:= 'C:\Users\user\AppData\Roaming\Primer_MT_3'; //Директория старта поиска
//  inputParam3:= 'D:\Install\ResultSearchByMask.txt'; //Имя файла для записи результата, если inputParam4 - true
//  inputParam4:= true; //Выбор типа вывода результата: 0 (false) - через память (указатель в outputResult, размер в outputResultSize)
//  inputParam5:= 1000; //Период отчёта о работе

// iProcedureWorkTime:= GetTickCount(); // запоминаем значение тиков в начале подпрограммы
  case inputParam4 of
    true:  //--- Вариант: запись результата в файл
     begin
//--- Если выбран режим вывода в файл, то проверим правильность имени выходного файла
//--- Добавим к имени выходного файла информацию о номере задачи по порядку запуска потоков в главном модуле, иначе имена файлов в потоках совпадут
       if TPath.GetFileName(inputParam3) <> '' then
        tmpWideString:= TPath.GetFileNameWithoutExtension(inputParam3) + format('_%d', [inputParam5]) + TPath.GetExtension(inputParam3)
       else
        tmpWideString:= TPath.GetFileNameWithoutExtension(wsTask1_ResultFileNameByDefault) + format('_%d', [inputParam5]) + TPath.GetExtension(wsTask1_ResultFileNameByDefault);
//--- ...правильность имени выходной директории
       if TPath.GetDirectoryName(inputParam3) <> '' then
        tmpWideString:= TPath.GetDirectoryName(inputParam3) + '\' + tmpWideString
       else
        tmpWideString:= TDirectory.GetCurrentDirectory() + '\' + tmpWideString;

        tmpStreamWriter:= TFile.CreateText(tmpWideString);

//--- Извлечение элементов-масок из входящей строки (inputParam1)
   GetItemsFromString(inputParam1, tmpMaskItems, tmpMaskCount);
//--- Цикл перебора и сравнения с масками всех файлов в целевой директории
   outTask1_Result.dwEqualsCount:= 0; //--- Счётчик совпадений

       for tmpTargetFile in TDirectory.GetFiles(inputParam2, wsAllMask,
            TSearchOption.soAllDirectories) do
        begin
          sleep(500); //--- Для отработки (для замедления процесса)
         tmpBool:= false;
         for tmpInt:= 0 to tmpMaskCount do
         begin
          if (TPath.GetExtension(tmpTargetFile) = tmpMaskItems[tmpInt]) and (not tmpBool) then
          begin
           inc(outTask1_Result.dwEqualsCount);
           tmpBool:= true;
           if tmpBool then
           begin
            tmpStreamWriter.WriteLine(tmpTargetFile + ', ');
            if (GetTickCount() - iProcedureWorkTime) >=  inputParam5 then
             begin
              tmpStreamWriter.Flush;
              iProcedureWorkTime:= GetTickCount(); // запоминаем текущее значение тиков
             end;
           end;
          end;
         end;
        end;

       tmpPAnsiChar:= 'Всего найдено совпадений: ';
       tmpStreamWriter.WriteLine(tmpPAnsiChar + IntToStr(outTask1_Result.dwEqualsCount));
       tmpStreamWriter.Close;

     end;

    false:   //--- Настройка памяти для выгрузки результата
     begin

     end;
   end;

finally
 if Win32Check(Assigned(tmpStreamWriter)) then
    freeandnil(tmpStreamWriter); //    tmpStreamWriter.Free;

end;
end;


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
//          sleep(500); //--- Для отработки (для замедления процесса)
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
            inputStreamWriter.WriteLine(format(wsTask2_Result_TemplateView, [ByteToWS(inputSearchPatternSet[tmpWord].Pattern, inputSearchPatternSet[tmpWord].PatternSize),
                                                                             inputSearchPatternSet[tmpWord].LastPosBeginSearch]));
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



}
procedure GetItemsFromString(inputSourceBSTR: WideString; var outputStringItems: TArray_WideString; var outputMaskCount: word);
begin
 outputMaskCount:= 0;
 if pos(wsBeginMask, inputSourceBSTR, 1) > 0 then
 begin
  while pos(wsBeginMask, inputSourceBSTR, 1) > 0 do
   begin
//--- Проверка на правильное начало маски, если нет, то отбросим всё что до начала маски расширения
    if pos(wsBeginMask, inputSourceBSTR, 1) > 0 then
      delete(inputSourceBSTR, 1, length(GetSubStr(inputSourceBSTR, 1, pos(wsBeginMask, inputSourceBSTR)))); //--- удалим всё, что до '*.' - ищем только расширения

    if pos(ItemDelemiter, inputSourceBSTR, 1) > 0 then
      outputStringItems[outputMaskCount]:= Copy(inputSourceBSTR, 1, pos(ItemDelemiter, inputSourceBSTR, 1) - 1)
    else // осталась последняя маска и без завершающего разделителя (но мы её не бросим!)
      outputStringItems[outputMaskCount]:= Copy(inputSourceBSTR, 1, length(inputSourceBSTR));

    delete(inputSourceBSTR, 1, Length(outputStringItems[outputMaskCount]) + 1); //--- удалим прочтённую запись и разделитель
    inc(outputMaskCount);
   end;
 end;
end;

function GetSubStr(inSourceString: WideString; inIndex:Byte; inCount:Integer): WideString;
begin
if inCount<>-1 then
   Result:=copy(inSourceString, inIndex, inCount)
else
   Result:=copy(inSourceString, inIndex, (length(inSourceString) - inIndex + 1));
end;

function IndexInString(inSubStr, inSourceString: WideString; inPosBegin: word): word;
var
   MyStr: WideString;
begin
MyStr:= GetSubStr(inSourceString, inPosBegin, -1);
Result:=pos(inSubStr, MyStr);

end;

//------------------------------------------------------------------------------------------------------------------------------------
//------------------------------ Для Задачи №2 ---------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------

function GetPosForPattern(inputBuffer: Pointer; inputFileSize: DWORD; inputSearchPatternSet: TSearchPatternSet; inputPosBeginSearch: DWORD): DWORD;
var
   LastStartComparePos, tmpPatternSize: DWORD;
begin
 Result:= $0FFFFFFFF; //iPatternNotFound;
 tmpPatternSize:= inputSearchPatternSet.PatternSize;
 if tmpPatternSize < 1 then
  exit;

asm
 mov esi, inputBuffer
 mov edx, esi
 add esi, inputPosBeginSearch
 dec esi
 mov LastStartComparePos, esi
 mov eax, inputFileSize
 sub eax, tmpPatternSize
 jb @@Exit_Failed
 add edx, eax //--- edx = MaxLastComparePos

@@BeginCompare:
 inc LastStartComparePos
 cmp edx, LastStartComparePos
 jb @@Exit_Failed

@@PrepareNextStep:
 mov esi, LastStartComparePos
 mov edi, inputSearchPatternSet.Pattern
 mov ecx, tmpPatternSize
@@CompareByte:
 mov al, byte ptr [edi]
 mov ah, byte ptr [esi]
 cmp al, ah
 jnz @@BeginCompare
 inc esi
 cmp edx, esi
 jb @@Exit_Failed
 inc edi
 dec ecx
 test ecx, ecx
 ja @@CompareByte
 mov eax, LastStartComparePos
 sub eax, inputBuffer
 jmp @@Exit
@@Exit_Failed:
 mov eax, 0FFFFFFFFh
@@Exit:
 mov Result, eax
end;

end;

function WSToByte(inputWideString: WideString): TSearchPattern;
var
  tmpPChar: PChar;
  tmpWord: word;
begin
  if length(inputWideString) = 0 then
    exit;

  setlength(Result, length(inputWideString));
  tmpPChar:= PChar(inputWideString);
 for tmpWord:= 0 to length(inputWideString) - 1 do
 begin
   Result[tmpWord]:= ord(tmpPChar[tmpWord]);
 end;
end;

function ByteToWS(inputBytes: TSearchPattern; inputBytesSize: dword): WideString;
var
  tmpWord: word;
  tmpStr: AnsiString;
begin
  Result:= '';
  if inputBytesSize < 1 then
  begin
   Result:= '';
   exit;
  end;

//  setlength(Result, inputBytesSize*sizeof(WideChar) + 1);
 setlength(Result, inputBytesSize*sizeof(WideChar) + 1);
 Result:='';

 for tmpWord:= 0 to (inputBytesSize - 1) do
 begin
   tmpStr:= AnsiChar(inputBytes[tmpWord]);
   Result:= Result + WideChar(tmpStr[1]);
 end;
// Result:= Result + #0;
end;

procedure GetPatternsFromString(inputSourceBSTR: WideString; var outputStringItems: TArray_WideString; var outputPatternCount: word);
var
  tmpWideString: WideString;
  tmpWord: word;
  tmpInt, tmpInt1: integer;
  tmpBool: Boolean;
begin
 outputPatternCount:= 0;
 if inputSourceBSTR = '' then
  exit;

  repeat
    if pos(ItemDelemiter, inputSourceBSTR, 1) > 0 then
      tmpWideString:= Copy(inputSourceBSTR, 1, pos(ItemDelemiter, inputSourceBSTR, 1) - 1)
    else // остался последний шаблон и без завершающего разделителя
      tmpWideString:= Copy(inputSourceBSTR, 1, length(inputSourceBSTR));
    outputStringItems[outputPatternCount]:= tmpWideString; //--- Пока фиксируем совпадение
    tmpWord:= outputPatternCount;                          //--- После проверки на совпадение
                                                          //--- Это хначение может быть удалено

//--- Проверим на повторы шаблонов и, если есть - удалим.
    tmpBool:= false;
    for tmpInt:= (outputPatternCount - 1) downto 0 do
    begin
      if outputStringItems[outputPatternCount] = outputStringItems[tmpInt] then
      begin
       tmpBool:= true;
       break;
      end;
    end;
//--- удаляем текущий шаблон из входящей строки-параметра
    delete(inputSourceBSTR, 1, Length(outputStringItems[outputPatternCount]) + 1); //--- удалим прочтённую запись и разделитель
//--- Если не было совпадений с предыдущими шаблонами, то увеличим счётчик - оставим текущий шаблон в списке
    if not tmpBool then
    begin
     inc(outputPatternCount);
    end;


  until length(inputSourceBSTR) = 0;

end;

//------------------------------------------------------------------------------
function GetWorkingDirectoryName(): WideString;
var
  tmpStr: string;
begin
 Result:= '';
 try
  tmpStr:= GetEnvironmentVariable('APPDATA') + '\' + Copy(ExtractFileName(GetModuleName(HInstance)), 1, Pos('.', ExtractFileName(GetModuleName(HInstance))) - 1);
  if not TDirectory.Exists(tmpStr) then
   TDirectory.CreateDirectory(tmpStr);
  Result:= tmpStr;
 except
  on E: Exception do
    Writeln(E.ClassName, ': ', E.Message);
 end;
end;

//------------------------------------------------------------------------------
procedure WriteDataToLog(E_source1, CurrentProcName, CurrentUnitName: WideString);
var
  tmpWideString: WideString;
  tmpCardinal: Cardinal;
begin
try
  tmpWideString:= '--------------- Библиотека №1 -------------------------------'
                + #13#10
                + DatetimeToStr(today())
                + #13#10
                + 'Сообщение сгенерировано в - ' + CurrentUnitName + '\' + CurrentProcName
                + #13#10
                + E_source1
                + #13#10
                + '-------------------------------------------------------------';
  LibraryLog.StringStream.WriteString(tmpWideString);

finally

end;
end;

end.
