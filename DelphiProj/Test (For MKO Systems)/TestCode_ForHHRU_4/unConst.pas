unit unConst;

interface
uses Winapi.Messages;

const

  aTemplateTaskNameArray: TArray<string> = ['������ ����', '������ 1 (+StreamWriter)', '����������� ������� ����� (+StreamWriter)']; //--- ��� ������������� ������ ��������� ����� � ������ =
  aTaskDllProcNameArray: TArray<string> = ['', 'Calc_Algorithm_Rnd', '']; //--- ��� ������������� ������ ��������� ����� � ������ =

  UserOffset = 2048;
  wm_data_update = WM_APP + UserOffset;
  iMaxPixelCount_difference = 5;
  sHeaderThreadInfo = '����� �';
  sWaitForAppClosing = '�������� ���������� ����� (�������)...';
  ServerUDPPort = 8048;
  serverUDPName = '127.0.0.1';
  sDelimiterNumTask = '#';
  DllFileName = 'Primer_MT_3.dll';
  iMaxDigitPi = 10000;
//----- ��� ����� ������������ �� dll ��� ����� --------------
  DllProcName_LibraryInfo = 'GetLibraryAPI';

  MaxStringInfoLength = 64;

implementation

end.
