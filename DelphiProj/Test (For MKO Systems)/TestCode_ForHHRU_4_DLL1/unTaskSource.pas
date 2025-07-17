unit unTaskSource;

interface
uses   Windows, ActiveX, Classes, IOUtils, SysUtils, System.SyncObjs;

const
  ItemDelemiter = ';';
  wsBeginMask: WideString = '*.';
  wsAllMask: WideString = '*';
  wsTask1_ResultFileNameByDefault: WideString = 'Lib1_Task1_Result.txt';

type
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
//--- Выходные параметры Задачи №1 (Индекс задачи в библиотеке - 0)

  TTask1_Result = packed record
    dwEqualsCount: DWORD;
  end;

//------------------------------------------------------------------------------

  TArray_WideString = array [0..High(Byte)] of WideString;
//------------------------------------------------------------------------------

var
  CriticalSection: TCriticalSection;
  Task1_Parameters: TTask1_Parameters;


//--- Основныеные функции (реализация функционала библиотеки)
//--- Задача №1 - Поиск файлов по маске/маскам
//function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; out outTask1_Result: TTask1_Result): HRESULT;

//--- Вспомогательные функции
//--- Извлечение элементов строки, разделённых символом-разделителем
procedure GetItemsFromString(inputSourceBSTR: WideString; var outputStringItems: TArray_WideString; var outputMaskCount: word);
function GetSubStr(inSourceString: WideString; inIndex:Byte; inCount:Integer): WideString;
function IndexInString(inSubStr, inSourceString: WideString; inPosBegin: word): word;




implementation

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
    tmpStreamWriter.Free;

end;
end;

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


end.
