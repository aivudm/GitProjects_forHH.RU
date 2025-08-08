unit unConst;

interface
uses Winapi.Messages;

const
//------------------------------------------------------------------------------
  iCycleTimeValue = 20; //--- длительность цикла общей загрузки потока (мс)
  iTaskBoreHole = 0.05; //--- скважность цикла полезной загрузки потока (мс)
  iTaskPeriodReport = 300; //--- период отчёта потоков о результатах (мс)
  UserOffset = 2048;
  wm_data_update = WM_APP + UserOffset;
  CMD_SetMemoLine = 1; //--- Наш код для записи информации из сообщения в Мемо
  CMD_SetMemoStreamUpd = 2; //--- Наш код для обновления данных от потока в Мемо
  CMD_DeleteTaskItem = 3; //--- Наш код для удаления строки
//------------------------------------------------------------------------------
  iMaxPixelCount_difference = 5;
//------------------------------------------------------------------------------
  wsUncknownVersionOS = 'Не допустимая версия ОС. #13#10 Завершение работы приложения.';
  wsHeaderThreadInfo = 'Задача (поток) №%3d';
  wsEvent_ThreadCreated = wsHeaderThreadInfo + ' создан успешно. ThreadId (задача/ядро задачи)= %d/%d';
  sWaitForThreadAnswer = 'Ожидание ответа от потока...';
  sWaitForAppClosing = 'Ожидание завершения задач (потоков)...';
  wsTaskItem_Terminated = wsHeaderThreadInfo + 'завершена. Задача (ThreadID: %d';
  wsTaskCore_Terminated = wsHeaderThreadInfo + 'завершена. Ядро задачи (ThreadID: %d';
  sThreadInfoForView = wsHeaderThreadInfo + ' : %s, %s TreadId: %4d | Время работы: %d | %s ||| [сост. - %s]';
//  sThreadInfoForView = sHeaderThreadInfo + ' %4d : %s, %s TreadId: %4d | CPU usage(проц.): %f | Кол-во совпадений: %6d ||| [сост. - %s]';
  wsIniToolsTitle1 = 'Library Path';
  wsIniLibraryPath_Item = 'lbLibraryList_Item%d';
  wsIniToolsTitle2 = 'formTools Settings';
  wsIniExchangeType_WMCopyData = 'rbMessage_WMCopyData';
  wsNameExchangeType_WMCopyData = 'Режим: Message WM_CopyData';
  wsNameExchangeType_ServerUDP = 'Режим: Сервер UDP [Порт: %5d]';
  wsError_LoadLibrary = 'Ошибка загрузки библиотеки';
  wsError_LoadLibraryWithTargetAPI = 'Ошибка. Библиотека не поддерживает целевой API';
  wsError_TaskItemNotAssigned = 'Задача не существует. Вожможно, удалена в связи с исключительной ситуацией.';
  wsResultPartDll1Task0_InfoFromTask = 'Кол-во файлов по маскам: %3d';
  wsResultPartDll1Task1_InfoFromTask = 'Общ. кол-во соотв. шаблонам: %3d';
  wsResultPartDll2Task0_InfoFromTask = '';
  wsInfo_TaskUnnableToTerminate = 'Задача уже не может быть прервана.';
  wsConfirm_TaskTerminate1 = 'Вы действительно хотите прервать выполнение задачи?';
  wsConfirm_TaskDelete1 = 'Вы действительно хотите полностью удалить задачу?';
  wsConfirm_TaskDelete2 = 'Вы действительно хотите прервать и полностью удалить задачу?';

  ServerUDPPort = 8048;
  serverUDPName = '127.0.0.1';
  sDelimiterNumTask = '#';
//------------------------------------------------------------------------------
  aTaskStateName: TArray<WideString> = ['Не определено', 'Активен', 'Остановлен', 'Пауза', 'Завершён (Выполнен)'];
  aButtonStateCaption: TArray<WideString> = ['Пауза', 'Продолжить', 'Завершён', 'Запуск (повтор)'];

//------------------------------------------------------------------------------
  LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR = $04;
  LOAD_LIBRARY_SEARCH_DEFAULT_DIR = $08;


//----- Для задач подключаемых из dll для теста --------------
  DllProcName_LibraryInfo = 'GetLibraryAPI';


implementation

end.
