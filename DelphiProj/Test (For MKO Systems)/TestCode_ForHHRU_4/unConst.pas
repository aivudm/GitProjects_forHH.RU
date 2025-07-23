unit unConst;

interface
uses Winapi.Messages;

const
//------------------------------------------------------------------------------
  UserOffset = 2048;
  wm_data_update = WM_APP + UserOffset;
  CMD_SetMemoLine = 1; //--- Наш код для записи информации из сообщения в Мемо
//------------------------------------------------------------------------------
  iMaxPixelCount_difference = 5;
//------------------------------------------------------------------------------
  sHeaderThreadInfo = 'Поток №';
  sWaitForThreadAnswer = 'Ожидание ответа от потока...';
  sWaitForAppClosing = 'Ожидание завершения задач (потоков)...';
  sThreadInfoForView = sHeaderThreadInfo + ' %4d : %s, %s TreadId: %4d | Время работы: %d | %s ||| [сост. - %s]';
//  sThreadInfoForView = sHeaderThreadInfo + ' %4d : %s, %s TreadId: %4d | CPU usage(проц.): %f | Кол-во совпадений: %6d ||| [сост. - %s]';
  ServerUDPPort = 8048;
  serverUDPName = '127.0.0.1';
  sDelimiterNumTask = '#';
//------------------------------------------------------------------------------
  aTaskStateName: TArray<String> = ['Не определено', 'Активен', 'Остановлен', 'Пауза', 'Завершён (Выполнен)'];

//------------------------------------------------------------------------------


//----- Для задач подключаемых из dll для теста --------------
  DllProcName_LibraryInfo = 'GetLibraryAPI';


implementation

end.
