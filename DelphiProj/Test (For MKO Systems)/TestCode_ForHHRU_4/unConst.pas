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
  wsUncknownVersionOS = 'Не допустимая версия ОС. #13#10 Завершение работы приложения.';
  wsHeaderThreadInfo = 'Поток №';
  wsEvent_ThreadCreated = wsHeaderThreadInfo + '%3d создан успешно.';
  sWaitForThreadAnswer = 'Ожидание ответа от потока...';
  sWaitForAppClosing = 'Ожидание завершения задач (потоков)...';
  sThreadInfoForView = wsHeaderThreadInfo + ' %4d : %s, %s TreadId: %4d | Время работы: %d | %s ||| [сост. - %s]';
//  sThreadInfoForView = sHeaderThreadInfo + ' %4d : %s, %s TreadId: %4d | CPU usage(проц.): %f | Кол-во совпадений: %6d ||| [сост. - %s]';
  wsIniToolsTitle1 = 'Library Path';
  wsIniLibraryPath_Item = 'lbLibraryList_Item%d';
  wsIniToolsTitle2 = 'formTools Settings';
  wsIniExchangeType_WMCopyData = 'rbMessage_WMCopyData';
  wsNameExchangeType_WMCopyData = 'Режим: Message WM_CopyData';
  wsNameExchangeType_ServerUDP = 'Режим: Сервер UDP [Порт: %5d]';
  wsError_LoadLibrary = 'Ошибка загрузки библиотеки';
  wsError_LoadLibraryWithTargetAPI = 'Ошибка. Библиотека не поддерживает целевой API';
  wsResultPartDll1Task0_InfoFromTask = 'Кол-во файлов по маскам: %3d';
  wsResultPartDll1Task1_InfoFromTask = 'Общ. кол-во соотв. шаблонам: %3d';


  ServerUDPPort = 8048;
  serverUDPName = '127.0.0.1';
  sDelimiterNumTask = '#';
//------------------------------------------------------------------------------
  aTaskStateName: TArray<String> = ['Не определено', 'Активен', 'Остановлен', 'Пауза', 'Завершён (Выполнен)'];

//------------------------------------------------------------------------------
  LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR = $04;
  LOAD_LIBRARY_SEARCH_DEFAULT_DIR = $08;


//----- Для задач подключаемых из dll для теста --------------
  DllProcName_LibraryInfo = 'GetLibraryAPI';


implementation

end.
