unit unConst;

interface
uses Winapi.Messages;

const
  aTaskNameArray: TArray<string> = ['������ ����', '������ ����� ��', '����������� ������� �����']; //--- ��� ������������� ������ ��������� ����� � ������ =

  UserOffset = 2048;
  wm_data_update = WM_APP + UserOffset;
  iMaxPixelCount_difference = 5;
  sHeaderThreadInfo = '����� �';
  sWaitForAppClosing = '�������� ���������� ����� (�������)...';
  ServerUDPPort = 8048;
  serverUDPName = '127.0.0.1';
  sDelimiterNumTask = '#';
implementation

end.
