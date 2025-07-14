unit unTaskSource;

interface
uses   Windows, ActiveX, Classes, IOUtils, SysUtils, System.SyncObjs;

type
  TTask1_Parameters = packed record
    inputParam1: PWideChar; //--- Маска
    inputParam2: PWideChar; //--- Директория старта поиска
    inputParam3: PWideChar; //--- Имя файла для записи результата, если inputParam4 - true (т.е. запись результата в файл)
    inputParam4: BOOL;       //--- Выбор типа вывода результата: 0 (false) - через память (указатель в outputResult, размер в outputResultSize)
    inputParam5: WORD;      //--- TargetWorkTime - устарело, управление теперь по другому алгоритму - удалить!
  end;

var
  CriticalSection: TCriticalSection;
  Task1_Parameters: TTask1_Parameters;


function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; iTargetWorkTime: WORD): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;


implementation

function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; iTargetWorkTime: WORD): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;

var
  inputParam5, iProcedureWorkTime: DWORD;
  tmpTargetFile: WideString;
  tmpStreamWriter: TStreamWriter;
//  inputParam1, inputParam2, inputParam3: WideString;
//  inputParam4: BOOL;

begin
try
    CriticalSection.Leave; //--- Вход в критическую секцию был до вызова окна с входными параметрами

//  inputParam1:= '*.txt;*.txt1'; //Маска
//  inputParam2:= 'C:\Users\user\AppData\Roaming\Primer_MT_3'; //Директория старта поиска
//  inputParam3:= 'D:\Install\ResultSearchByMask.txt'; //Имя файла для записи результата, если inputParam4 - true
//  inputParam4:= true; //Выбор типа вывода результата: 0 (false) - через память (указатель в outputResult, размер в outputResultSize)
//  inputParam5:= 1000; //Период отчёта о работе

// iProcedureWorkTime:= GetTickCount(); // запоминаем значение тиков в начале подпрограммы

//--- Если выбран режим вывода в файл, то проверим правильность имени выходного файла
  case inputParam4 of
    false, true:
     begin
       if TPath.GetFileName(inputParam3) <> '' then
        begin
         if TPath.GetDirectoryName(inputParam3) <> '' then
           tmpStreamWriter:= TFile.CreateText(inputParam3)
         else
           tmpStreamWriter:= TFile.CreateText(TDirectory.GetCurrentDirectory());
        end
       else
         tmpStreamWriter:= TFile.CreateText(TDirectory.GetCurrentDirectory());

        for tmpTargetFile in TDirectory.GetFiles(inputParam2, inputParam1,
                TSearchOption.soAllDirectories) do
        begin
          tmpStreamWriter.WriteLine(tmpTargetFile + ', ');
          if (GetTickCount() - iProcedureWorkTime) >=  inputParam5 then
           begin
            tmpStreamWriter.Flush;
            iProcedureWorkTime:= GetTickCount(); // запоминаем текущее значение тиков
           end;
        end;
       tmpStreamWriter.Close;

     end;

//    false:   //--- Настройка памяти для выгрузки результата
//      begin

//      end;
  end;

finally
 if Win32Check(Assigned(tmpStreamWriter)) then
    tmpStreamWriter.Free;

end;
end;


end.
