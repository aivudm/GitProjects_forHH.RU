unit unTaskSource;

interface
uses   Windows, ActiveX, Classes, IOUtils, SysUtils, System.SyncObjs, Dialogs, DateUtils;

//--- Для Задачи №1 ------------------------------------------------------------
const
  CMD_SetMemoLogStreamUpd = 4; //--- Наш код для обновления данных от потока в компоненты отображения
  UserOffset = 2048;
  WM_APP = $8000;
  NotifySignBit = $80000000; //--- бит для определения "наших" сообщений об обновлении (для wParam)
  wm_data_update = WM_APP + UserOffset;

  wsLibraryTitle = 'Подключена библиотека: %d (%s), кол-во задач - %d';
  wsLibraryStreamTitle = 'Dll API: %d (%s)';
  wsLibrary_OnError: WideString = 'Исключительная ситуация: %s (ошибка ОС: %d)';
  wsTask1_Name: WideString = 'Выполнение внешних командных модулей';
  wsTask1_ResultFileNameByDefault: WideString = 'Lib1_Task1_Result.txt';
  wsTask2_ResultFileNameByDefault: WideString = 'Lib1_Task2_Result.txt';
  wsTask2_Result_TemplateView: WideString = 'Шаблон: %12s, Позиция в файле: %d';
  wsTask2_TotalResult_TemplateView: WideString = 'Шаблон: %12s, Всего совпадений: %d';
  wsResultStreamTitle: WideString = 'Библиотека №%3d, Задача №%3d';
  wsIniFileTitle1: WideString = 'EditInputParams_DLL1_Task1 Settings';
  wsIniFileParam1: WideString = 'edShellCommander';
  wsIniFileParam2: WideString = 'edTargetCommand';
  wsIniFileParam3: WideString = 'edResultFile';
  wsSignofWorkWileClosing: WideString = ' /c ';
  wsCRLF = #13#10;
  wsIniFileName = 'Primer_MT_4_Lib2.ini';
  wsTask1_TargetFileNotFound: WideString = 'Целевой файл: %s не найден.';
  wsProcessCreateError: WideString = 'Ошибка создания процесса: %d';
  wsTask_ErrorByPostThreadMessage: WideString = 'Ошибка выполнения PostThreadMessage(...)  %d (%s) потока %d прервано из-за ошибки ОС: %d';
  wsTask_AbortedOnError: WideString = 'Выполнение задачи %d (%s) потока %d прервано из-за ошибки: %s';
  wsTask_DoneMessage: WideString = 'Выполнение задачи %d (%s) потока %d завершено. Код завершения: %d';


//--- Для Задачи №2 ------------------------------------------------------------
const
  iPatternNotFound = $FFFFFFFF;
  Task2_DefaultBufferSize = 4096;
  CMD_SetLogInfo = 2;
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

//--- Вспомогательные попрограммы

var
  CriticalSection: TCriticalSection;
  Task1_Parameters: TTask1_Parameters;
  LibraryLog: TLibraryLog;


//--- Вспомогательные функции
//--- Извлечение элементов строки, разделённых символом-разделителем

//--- Для Задачи №1 ------------



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



end.
