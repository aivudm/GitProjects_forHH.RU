unit unConst;

interface
uses Winapi.Messages;

const
//------------------------------------------------------------------------------
  UserOffset = 2048;
  wm_data_update = WM_APP + UserOffset;
  CMD_SetMemoLine = 1; //--- ��� ��� ��� ������ ���������� �� ��������� � ����
//------------------------------------------------------------------------------
  iMaxPixelCount_difference = 5;
//------------------------------------------------------------------------------
  sHeaderThreadInfo = '����� �';
  sWaitForThreadAnswer = '�������� ������ �� ������...';
  sWaitForAppClosing = '�������� ���������� ����� (�������)...';
  sThreadInfoForView = sHeaderThreadInfo + ' %4d : %s, %s TreadId: %4d | ����� ������: %d | %s ||| [����. - %s]';
//  sThreadInfoForView = sHeaderThreadInfo + ' %4d : %s, %s TreadId: %4d | CPU usage(����.): %f | ���-�� ����������: %6d ||| [����. - %s]';
  ServerUDPPort = 8048;
  serverUDPName = '127.0.0.1';
  sDelimiterNumTask = '#';
//------------------------------------------------------------------------------
  aTaskStateName: TArray<String> = ['�� ����������', '�������', '����������', '�����', '�������� (��������)'];

//------------------------------------------------------------------------------


//----- ��� ����� ������������ �� dll ��� ����� --------------
  DllProcName_LibraryInfo = 'GetLibraryAPI';


implementation

end.
