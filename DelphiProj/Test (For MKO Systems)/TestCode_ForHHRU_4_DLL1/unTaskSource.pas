unit unTaskSource;

interface
uses   Windows, ActiveX, Classes, IOUtils, SysUtils, System.SyncObjs;

type
  TTask1_Parameters = packed record
    inputParam1: PWideChar; //--- �����
    inputParam2: PWideChar; //--- ���������� ������ ������
    inputParam3: PWideChar; //--- ��� ����� ��� ������ ����������, ���� inputParam4 - true (�.�. ������ ���������� � ����)
    inputParam4: BOOL;       //--- ����� ���� ������ ����������: 0 (false) - ����� ������ (��������� � outputResult, ������ � outputResultSize)
    inputParam5: WORD;      //--- TargetWorkTime - ��������, ���������� ������ �� ������� ��������� - �������!
  end;

var
  CriticalSection: TCriticalSection;
  Task1_Parameters: TTask1_Parameters;


function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; iTargetWorkTime: WORD): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;


implementation

function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; iTargetWorkTime: WORD): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;

var
  inputParam5, iProcedureWorkTime: DWORD;
  tmpTargetFile: WideString;
  tmpStreamWriter: TStreamWriter;
//  inputParam1, inputParam2, inputParam3: WideString;
//  inputParam4: BOOL;

begin
try
    CriticalSection.Leave; //--- ���� � ����������� ������ ��� �� ������ ���� � �������� �����������

//  inputParam1:= '*.txt;*.txt1'; //�����
//  inputParam2:= 'C:\Users\user\AppData\Roaming\Primer_MT_3'; //���������� ������ ������
//  inputParam3:= 'D:\Install\ResultSearchByMask.txt'; //��� ����� ��� ������ ����������, ���� inputParam4 - true
//  inputParam4:= true; //����� ���� ������ ����������: 0 (false) - ����� ������ (��������� � outputResult, ������ � outputResultSize)
//  inputParam5:= 1000; //������ ������ � ������

// iProcedureWorkTime:= GetTickCount(); // ���������� �������� ����� � ������ ������������

//--- ���� ������ ����� ������ � ����, �� �������� ������������ ����� ��������� �����
  case inputParam4 of
    false, true:
     begin
       if TPath.GetFileName(inputParam3) <> '' then
        begin
         if TPath.GetDirectoryName(inputParam3) <> '' then
           tmpStreamWriter:= TFile.CreateText(inputParam3)
         else
           tmpStreamWriter:= TFile.CreateText(TDirectory.GetCurrentDirectory());
        end
       else
         tmpStreamWriter:= TFile.CreateText(TDirectory.GetCurrentDirectory());

        for tmpTargetFile in TDirectory.GetFiles(inputParam2, inputParam1,
                TSearchOption.soAllDirectories) do
        begin
          tmpStreamWriter.WriteLine(tmpTargetFile + ', ');
          if (GetTickCount() - iProcedureWorkTime) >=  inputParam5 then
           begin
            tmpStreamWriter.Flush;
            iProcedureWorkTime:= GetTickCount(); // ���������� ������� �������� �����
           end;
        end;
       tmpStreamWriter.Close;

     end;

//    false:   //--- ��������� ������ ��� �������� ����������
//      begin

//      end;
  end;

finally
 if Win32Check(Assigned(tmpStreamWriter)) then
    tmpStreamWriter.Free;

end;
end;


end.
