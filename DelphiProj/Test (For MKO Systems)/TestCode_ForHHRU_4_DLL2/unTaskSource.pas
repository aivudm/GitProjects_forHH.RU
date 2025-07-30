unit unTaskSource;

interface
uses   Windows, ActiveX, Classes, IOUtils, SysUtils, System.SyncObjs, Dialogs, DateUtils;

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

//------------------------------------------------------------------------------

  ILibraryLog = interface (IInterface)
  ['{417D26A0-0BA7-4F69-877C-0E80A224E8EA}']
    function GetStream: IStream; safecall;
    property Stream: IStream read GetStream;
  end;

//------------------------------------------------------------------------------
  TLibraryLog = class(TInterfacedObject, ILibraryLog)
  strict private
    FStringStream: TStringStream;
    FStream: IStream;
  strict protected
  public
    constructor Create();
    function GetStream: IStream; safecall;
    property StringStream: TStringStream read FStringStream;
    property Stream: IStream read GetStream;
  end;
//------------------------------------------------------------------------------

//--- ��������������� �����������
procedure WriteDataToLog(E_source1, CurrentProcName, CurrentUnitName: WideString);

var
  CriticalSection: TCriticalSection;
  Task1_Parameters: TTask1_Parameters;
  LibraryLog: TLibraryLog;


//--- ��������������� �������
//--- ���������� ��������� ������, ���������� ��������-������������

//--- ��� ������ �1 ------------



implementation

//------------------------------------------------------------------------------
//---------- ������ ��� TLibraryLog --------------------------------------
//------------------------------------------------------------------------------
constructor TLibraryLog.Create;
begin
try
 inherited Create();
 FStringStream:= TStringStream.Create('', TEncoding.ANSI);
 FStream:= TStreamAdapter.Create(FStringStream, soReference);

finally
end;
end;


function TLibraryLog.GetStream: IStream; safecall;
begin
try
  Result:= FStream;
finally
end;
end;

//------------------------------------------------------------------------------
procedure WriteDataToLog(E_source1, CurrentProcName, CurrentUnitName: WideString);
var
  tmpWideString: WideString;
  tmpCardinal: Cardinal;
begin
try
  tmpWideString:= '--------------- ���������� �2 -------------------------------'
                + #13#10
                + DatetimeToStr(today())
                + #13#10
                + '��������� ������������� � - ' + CurrentUnitName + '\' + CurrentProcName
                + #13#10
                + E_source1
                + #13#10
                + '-------------------------------------------------------------';
  LibraryLog.StringStream.WriteString(tmpWideString);

finally

end;
end;


//------------------------------------------------------------------------------------------------------------------------------------
//------------------------------ ��� ������ �1 ---------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------





end.
