unit unConst;

interface
uses Winapi.Messages;

const
  aTaskNameArray: TArray<string> = ['Пустой цикл', 'Расчёт числа Пи', 'Определение простых чисел']; //--- При инициализации задачи нумерация будет с номера =

  UserOffset = 2048;
  wm_data_update = WM_APP + UserOffset;
  iMaxPixelCount_difference = 5;
  sHeaderThreadInfo = 'Поток №';
  sWaitForAppClosing = 'Ожидание завершения задач (потоков)...';
  ServerUDPPort = 8048;
  serverUDPName = '127.0.0.1';
  sDelimiterNumTask = '#';
implementation

end.
