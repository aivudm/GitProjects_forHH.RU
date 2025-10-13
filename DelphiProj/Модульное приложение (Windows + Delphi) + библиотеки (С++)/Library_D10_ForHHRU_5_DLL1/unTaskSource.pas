unit unTaskSource;

interface
uses   Windows, ActiveX, Classes, IOUtils, SysUtils, System.SyncObjs, Dialogs, DateUtils,
      Shobjidl;

//--- Для Задачи №1 ------------------------------------------------------------
const
  ItemDelemiter = ';';
  wsBeginMask: WideString = '*.';
  wsAllMask: WideString = '*';
  wsPartMaskDelemiter: WideString = '*';
  dwMaxStringLength = 2048;
  CMD_SetMemoLogStreamUpd = 4; //--- Наш код для обновления данных от потока в компоненты отображения
  UserOffset = 2048;
  WM_APP = $8000;
  NotifySignBit = $80000000; //--- бит для определения "наших" сообщений об обновлении (для wParam)
  wm_data_update = WM_APP + UserOffset;

  wsCRLF = #13#10;
  wsLibraryTitle = 'Подключена библиотека: %d (%s), кол-во задач - %d';
  wsLibraryStreamTitle = 'Dll API: %d (%s)';
  wsLibrary_OnError: WideString = 'Исключительная ситуация: %s (ошибка ОС: %d)';
  wsTask1_Name: WideString = 'Поиск файлов по маске';
  wsTask2_Name: WideString = 'Поиск в файлах по шаблонам';
  wsTask1_ResultFileNameByDefault: WideString = 'Lib1_Task1_Result.txt';
  wsTask1_Result_CurrentAccorded: WideString = 'Соответствие маскам: %s, ' + wsCRLF + ' файл: %s';
//  wsTask1_Result_TemplateView: WideString = 'Соответствие маскам: %s, ' + wsCRLF + ' файл: %s';
  wsTask1_TotalResultByMask_TemplateView = 'Маска файлов: [%s]: %d' + wsCRLF;
  wsTask1_TotalResult_TemplateView: WideString = 'Всего найдено соответствий: %d';
  wsTask2_ResultFileNameByDefault: WideString = 'Lib1_Task2_Result.txt';
  wsTask2_TotalResultTitle_TemplateView: WideString = 'Всего найдено совпадений: %d';
  wsTask2_Result_TemplateView: WideString = 'Шаблон: %12s, Позиция в файле: %d';
  wsTask2_TotalResult_TemplateView: WideString = 'Шаблон: %12s, Всего совпадений: %d';
  wsResultStreamTitle: WideString = 'Библиотека №%d, Задача №%d';
  wsTask_TargetDirectoryNotFound: WideString = 'Целевая директория не найдена: %s';
  wsTask_TargetFileNotFound: WideString = 'Целевой файл: %s не найден.';
  wsTask_AbortedOnRequest: WideString = 'Выполнение прервано по запросу главного модуля';
  wsTask_AbortedOnError: WideString = 'Выполнение задачи %d (%s) потока %d прервано из-за ошибки: %s';
  wsTask_ErrorByPostThreadMessage: WideString = 'Ошибка выполнения PostThreadMessage(...) в: %s. Ошибка ОС: %d';
  wsFileDlgFilter = 'All Files' + #0 + '*.*' + #0 + 'Text Files' + #0 + '*.txt' + #0#0;
  wsTask1_DefaultDirectory = 'C:\Users\user\AppData\Roaming\Primer_MT_3';
  wsTask2_DefaultDirectory = 'C:\Users\user\AppData\Roaming\Primer_MT_4';
  wsTask_DoneMessage: WideString = 'Выполнение задачи %d (%s) потока %d завершено.';


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
    SearchPatternWS: WideString;
  end;



//------------------------------------------------------------------------------
  TTask_Results = array of TTask_Result;
  TArray_WideString = array [0..High(Byte)] of WideString;
//------------------------------------------------------------------------------


var
  CriticalSection: TCriticalSection;
  Task1_Parameters: TTask1_Parameters;
  Task2_Parameters: TTask2_Parameters;


//--- Основныеные функции (реализация функционала библиотеки)
//--- Задача №1 - Поиск файлов по маске/маскам
//function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; out outTask1_Result: TTask1_Result): HRESULT;

//--- Вспомогательные функции
function GetWorkingDirectoryName(): WideString;

//--- Для Задачи №1 ------------
//--- Извлечение элементов строки, разделённых символом-разделителем
//procedure GetMasksFromString(inputSourceBSTR: WideString; var outputStringItems: TArray_WideString; var outputPatternCount: word);
//function IsNameAccordedByMask(inputFileName, inputMask: WideString): boolean;
function IsNameAccordedByMask(inputFileName, inputMask: WideString; var inputAbortExecution: boolean): boolean;
function IsAccorded(inputMaskBool: TArray<boolean>; inputMaskCount: word): boolean;
//procedure GetItemsFromString(inputSourceBSTR: WideString; var outputStringItems: TArray_WideString; var outputMaskCount: word);
function GetSubStr(inSourceString: WideString; inIndex:Byte; inCount:Integer): WideString;
function IndexInString(inSubStr, inSourceString: WideString; inPosBegin: word): word;
//--- Для Задачи №2 ------------
procedure GetPatternsFromString(inputSourceBSTR: WideString; var outputStringItems: TArray_WideString; var outputPatternCount: word);
function GetPosForPattern(inputBuffer: Pointer; inputFileSize: DWORD; inputSearchPatternSet: TSearchPatternSet; inputPosBeginSearch: DWORD): DWORD;
function WSToByte(inputWideString: WideString): TSearchPattern;
function ByteToWS(inputBytes: TSearchPattern; inputBytesSize: dword): WideString;
function SelectDirectory(Parent: HWND; const Caption: WideString; const Root: WideString; var outputDirectory: WideString): Boolean;
function SelectFile(Parent: HWND; const Caption: WideString; const Root: WideString; var outputFileName: WideString): Boolean;



implementation


//------------------------------------------------------------------------------------------------------------------------------------
//------------------------------ Для Задачи №1 ---------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------


//-------------------------------------------------------------------------------
function IsNameAccordedByMask(inputFileName, inputMask: WideString; var inputAbortExecution: boolean): boolean;
var
  tmpMaskPart: WideString;
  tmpMaskParts: array of WideString;
  tmpMaskPartsCount: word;
  tmpBool, tmpBool1: boolean;
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
  tmpIsDelemiterLast:= (IndexInString(wsPartMaskDelemiter, inputMask, length(inputMask)) = 1);
  repeat
//--- Выделяем и переносим в массив все части маски
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

  until (pos(wsPartMaskDelemiter, inputMask, 1) = 0) and (length(inputMask) = 0) or inputAbortExecution;

  tmpBool:= true; //--- Признак соответствия имени маски (всем частям маски), при первом несоответсвие станет false и выходим из цикла
//--- Проход по всем выделенным частям маски
   for tmpInt:= 0 to (tmpMaskPartsCount - 1) do
   begin
    repeat
     tmpWord:= IndexInString(tmpMaskParts[tmpInt], inputFileName, 1);
//--- Условие только для последней части маски
     tmpBool1:= (((tmpInt = (tmpMaskPartsCount - 1)) and (not tmpIsDelemiterLast) and (tmpWord = (length(inputFileName) - length(tmpMaskParts[tmpInt]) + 1))))
                    {последняя часть маски}            {последняя части не "*"}          {послед. часть совпадает с концом наим.файла}
                or ((tmpInt = (tmpMaskPartsCount - 1)) and (tmpIsDelemiterLast) and (tmpWord > 0));
                    {последняя часть маски}            {есть последний "*"}      {есть совпададение с последней частью маски}

     tmpBool:= (tmpWord > 0)
               and (not ((tmpInt = 0) and (not tmpIsDelemiterFirst) and (length(inputFileName) > length(tmpMaskParts[0]))))  //--- исключаем ситуацию: первая часть маски начинается не с разделителя
               and (not tmpBool1);
//--- Вырезаем часть до, найденной части маски, включая текущую часть маски, из имени файла.
     if tmpWord > 0 then
      delete(inputFileName, 1, tmpWord + Length(tmpMaskPart) - 1); //--- удалим прочтённую запись и разделитель частей масок

//--- Цикл repeat необходим только для последней части маски
//--- Выходим из цикла repeat: когда достигнуто одно из условий:
    until (tmpWord = 0)                                           //--- Нет совпадения на лючой части маски
          or ((tmpInt = (tmpMaskPartsCount - 1)) and (tmpWord = 0))  //--- на последней части маски нет совпадения
          or ((tmpInt < (tmpMaskPartsCount - 1)) and (tmpBool))   //--- не последняя часть маски и есть совпадения
          or tmpBool1                                             //--- Последняя часть маски точно в конце имени файла
          or (length(inputFileName) = 0)                          //--- Достигнут конец строки имени файла
          or inputAbortExecution;                                 //--- Получен сигнал на немедленную остановку работы

    if not tmpBool then
     break;
   end;     {последняя часть маски}            {нет совпадения по тек. части}   {тек. часть не последняя и есть совпадение}

  Result:= tmpBool or tmpBool1;
 finally

 end;

end;

//------------------------------------------------------------------------------
function IsAccorded(inputMaskBool: TArray<boolean>; inputMaskCount: word): boolean;
var
  tmpWord: word;
begin
  Result:= false;
  try
    for tmpWord:= 0 to (inputMaskCount - 1) do
    begin
     Result:= Result or inputMaskBool[tmpWord];
    end;

  finally

  end;

end;



//--- Переименованная GetPatternsFromString(
procedure GetMasksFromString(inputSourceBSTR: WideString; var outputStringItems: TArray_WideString; var outputPatternCount: word);
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
{
//--- Старая версия, которая только для поиска расширений
//--- В качестве заглушки - только для отработки алгоритма Dll API
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
}

//------------------------------------------------------------------------------
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


{
    for tmpInt:= (tmpWord - 1) downto 0 do
    begin
     for tmpInt1:= 0 to (tmpWord - 1) do
     begin
      if outputStringItems[tmpInt1] = outputStringItems[tmpInt] then
      begin
       delete(inputSourceBSTR, 1, Length(outputStringItems[outputPatternCount]) + 1); //--- удалим прочтённую запись и разделитель
       inc(outputPatternCount);
      end;
     end;
    end;
}

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


function SelectDirectory(Parent: HWND; const Caption: WideString; const Root: WideString; var outputDirectory: WideString): Boolean;
var
  FileDialog: IFileDialog;
  ShellItem: IShellItem;
  FileDialogEvents: TFileDialogEvents;
  Cookie: Cardinal;
begin
  Result:=False;
  if CoCreateInstance(CLSID_FileOpenDialog, nil,
    CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER,
    IFileDialog, FileDialog) = S_OK then
  begin
    FileDialog.SetTitle(PWideChar(WideString(Caption)));
    if SHCreateItemFromParsingName(PWideChar(WideString(Root)),
      nil, SID_IShellItem, ShellItem)=S_OK then FileDialog.SetFolder(ShellItem);

    FileDialog.SetOptions(FOS_PICKFOLDERS);

    FileDialogEvents:=TFileDialogEvents.Create;
    FileDialog.Advise(FileDialogEvents, Cookie);

    if FileDialog.Show(Parent) = S_OK then
    begin
      outputDirectory:= FileDialogEvents.ResultFileName;
      Result:= true;
    end;

    FileDialog.Unadvise(Cookie);
  end;
end;

function SelectFile(Parent: HWND; const Caption: WideString; const Root: WideString; var outputFileName: WideString): Boolean;
var
  FileDialog: IFileDialog;
  ShellItem: IShellItem;
  FileDialogEvents: TFileDialogEvents;
  Cookie: Cardinal;
begin
  Result:=False;
  if CoCreateInstance(CLSID_FileOpenDialog, nil,
    CLSCTX_INPROC_SERVER or CLSCTX_LOCAL_SERVER,
    IFileDialog, FileDialog) = S_OK then
  begin
    FileDialog.SetTitle(PWideChar(WideString(Caption)));
    if SHCreateItemFromParsingName(PWideChar(WideString(Root)),
      nil, SID_IShellItem, ShellItem) = S_OK then FileDialog.SetFolder(ShellItem);

    FileDialog.SetOptions(FOS_FILEMUSTEXIST);

    FileDialogEvents:=TFileDialogEvents.Create;
    FileDialog.Advise(FileDialogEvents, Cookie);

    if FileDialog.Show(Parent) = S_OK then
    begin
      outputFileName:= FileDialogEvents.ResultFileName;
      Result:= true;
    end;

    FileDialog.Unadvise(Cookie);
  end;
end;


end.
