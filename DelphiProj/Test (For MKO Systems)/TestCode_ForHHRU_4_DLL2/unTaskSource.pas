unit unTaskSource;

interface
uses   Windows, ActiveX, Classes, IOUtils, SysUtils, System.SyncObjs, Dialogs;

//--- ��� ������ �1 ------------------------------------------------------------
const
  wsTask1_Name: WideString = '���������� ������� ��������� �������';
  wsTask1_ResultFileNameByDefault: WideString = 'Lib1_Task1_Result.txt';
  wsTask2_ResultFileNameByDefault: WideString = 'Lib1_Task2_Result.txt';
  wsTask2_Result_TemplateView: WideString = '������: %12s, ������� � �����: %d';
  wsTask2_TotalResult_TemplateView: WideString = '������: %12s, ����� ����������: %d';
  wsResultStreamTitle: WideString = '���������� �%3d, ������ �%3d';
  wsIniFileTitle1: WideString = 'EditInputParams_DLL1_Task1 Settings';
  wsIniFileParam1: WideString = 'edShellCommander';
  wsIniFileParam2: WideString = 'edTargetCommand';
  wsIniFileParam3: WideString = 'edResultFile';
  wsSignofWorkWileClosing: WideString = ' /c ';
  wsCRLF = #13#10;
  wsIniFileName = 'Primer_MT_4_Lib2.ini';


//--- ��� ������ �2 ------------------------------------------------------------
const
  iPatternNotFound = $FFFFFFFF;
  Task2_DefaultBufferSize = 4096;
  CMD_SetLogInfo = 2;
type
//------------------- ��� ������ �2 --------------------------------------------

  TTargetFile = array of byte;
  TSearchPattern = array of byte;

  TSearchPatternSet = packed record
    LastPosBeginSearch: DWORD;
    Pattern: TSearchPattern;
    PatternSize: DWORD;
  end;

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//--- ������� ��������� ������ �1 (������ ������ � ���������� - 0)

  TTask1_Parameters = packed record
    inputParam1: PWideChar; //--- �����
    inputParam2: PWideChar; //--- ���������� ������ ������
    inputParam3: PWideChar; //--- ��� ����� ��� ������ ����������, ���� inputParam4 - true (�.�. ������ ���������� � ����)
    inputParam4: BOOL;       //--- ����� ���� ������ ����������: 0 (false) - ����� ������ (��������� � outputResult, ������ � outputResultSize)
    inputParam5: WORD;      //--- ����� (������) ������ � ������� � ������� ������ (������ � �������� �����������)
  end;

//------------------------------------------------------------------------------
//--- ������� ��������� ������ �2 (������ ������ � ���������� - 1)

  TTask2_Parameters = packed record
    inputParam1: PWideChar; //array of byte; //--- ������ ������
    inputParam2: PWideChar; //--- ���� ��� ������ ������������ �������� ������
    inputParam3: PWideChar; //--- ��� ����� ��� ������ ����������, ���� inputParam4 - true (�.�. ������ ���������� � ����)
    inputParam4: BOOL;       //--- ����� ���� ������ ����������: 0 (false) - ����� ������ (��������� � outputResult, ������ � outputResultSize)
    inputParam5: WORD;      //--- ����� (������) ������ � ������� � ������� ������ (������ � �������� �����������)
  end;

//------------------------------------------------------------------------------
//--- �������� ��������� �����: �1,�2 (������� ����� � ����������: 0, 1)

  TTask_Result = packed record
    dwEqualsCount: DWORD;
    SearchPattern: TSearchPattern;
  end;

//------------------------------------------------------------------------------
  TTask_Results = array of TTask_Result;
  TArray_WideString = array [0..High(Byte)] of WideString;
//------------------------------------------------------------------------------


var
  CriticalSection: TCriticalSection;
  Task1_Parameters: TTask1_Parameters;



//--- ��������������� �������
//--- ���������� ��������� ������, ���������� ��������-������������

//--- ��� ������ �1 ------------



implementation


//------------------------------------------------------------------------------------------------------------------------------------
//------------------------------ ��� ������ �1 ---------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------




end.
