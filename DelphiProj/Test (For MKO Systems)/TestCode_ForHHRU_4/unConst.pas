unit unConst;

interface
uses Winapi.Messages;

const
//------------------------------------------------------------------------------
  iCycleTimeValue = 20; //--- ������������ ����� ����� �������� ������ (��)
  iTaskBoreHole = 0.05; //--- ���������� ����� �������� �������� ������ (��)
  iTaskPeriodReport = 1000; //--- ������ ������ ������� � ����������� (��)
  UserOffset = 2048;
  wm_data_update = WM_APP + UserOffset;
  CMD_SetMemoLine = 1; //--- ��� ��� ��� ������ ���������� �� ��������� � ����
  CMD_SetMemoStreamUpd = 2; //--- ��� ��� ��� ���������� ������ �� ������ � ����
//------------------------------------------------------------------------------
  iMaxPixelCount_difference = 5;
//------------------------------------------------------------------------------
  wsUncknownVersionOS = '�� ���������� ������ ��. #13#10 ���������� ������ ����������.';
  wsHeaderThreadInfo = '������ (�����) �';
  wsEvent_ThreadCreated = wsHeaderThreadInfo + '%3d ������ �������.';
  sWaitForThreadAnswer = '�������� ������ �� ������...';
  sWaitForAppClosing = '�������� ���������� ����� (�������)...';
  sThreadInfoForView = wsHeaderThreadInfo + ' %4d : %s, %s TreadId: %4d | ����� ������: %d | %s ||| [����. - %s]';
//  sThreadInfoForView = sHeaderThreadInfo + ' %4d : %s, %s TreadId: %4d | CPU usage(����.): %f | ���-�� ����������: %6d ||| [����. - %s]';
  wsIniToolsTitle1 = 'Library Path';
  wsIniLibraryPath_Item = 'lbLibraryList_Item%d';
  wsIniToolsTitle2 = 'formTools Settings';
  wsIniExchangeType_WMCopyData = 'rbMessage_WMCopyData';
  wsNameExchangeType_WMCopyData = '�����: Message WM_CopyData';
  wsNameExchangeType_ServerUDP = '�����: ������ UDP [����: %5d]';
  wsError_LoadLibrary = '������ �������� ����������';
  wsError_LoadLibraryWithTargetAPI = '������. ���������� �� ������������ ������� API';
  wsResultPartDll1Task0_InfoFromTask = '���-�� ������ �� ������: %3d';
  wsResultPartDll1Task1_InfoFromTask = '���. ���-�� �����. ��������: %3d';
  wsResultPartDll2Task0_InfoFromTask = '';

  ServerUDPPort = 8048;
  serverUDPName = '127.0.0.1';
  sDelimiterNumTask = '#';
//------------------------------------------------------------------------------
  aTaskStateName: TArray<WideString> = ['�� ����������', '�������', '����������', '�����', '�������� (��������)'];
  aButtonStateCaption: TArray<WideString> = ['�����', '����������', '��������', '������ (������)'];

//------------------------------------------------------------------------------
  LOAD_LIBRARY_SEARCH_DLL_LOAD_DIR = $04;
  LOAD_LIBRARY_SEARCH_DEFAULT_DIR = $08;


//----- ��� ����� ������������ �� dll ��� ����� --------------
  DllProcName_LibraryInfo = 'GetLibraryAPI';


implementation

end.
