unit unConst;

interface
uses Winapi.Messages;

const

  aTemplateTaskNameArray: TArray<string> = ['Пустой цикл', 'Расчёт 1 (+StreamWriter)', 'Определение простых чисел (+StreamWriter)']; //--- При инициализации задачи нумерация будет с номера =
  aTaskDllProcNameArray: TArray<string> = ['', 'Calc_Algorithm_Rnd', '']; //--- При инициализации задачи нумерация будет с номера =

  UserOffset = 2048;
  wm_data_update = WM_APP + UserOffset;
  iMaxPixelCount_difference = 5;
  sHeaderThreadInfo = 'Поток №';
  sWaitForAppClosing = 'Ожидание завершения задач (потоков)...';
  ServerUDPPort = 8048;
  serverUDPName = '127.0.0.1';
  sDelimiterNumTask = '#';
  DllFileName = 'Primer_MT_3.dll';
  iMaxDigitPi = 10000;
//----- Для задач подключаемых из dll для теста --------------
  DllProcName_LibraryInfo = 'GetLibraryAPI';

  MaxStringInfoLength = 64;

implementation

end.
