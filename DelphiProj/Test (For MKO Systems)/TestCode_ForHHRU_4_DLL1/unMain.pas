unit unMain;

interface
uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  System.Diagnostics;

procedure _GetLibraryNickName (var outputParam1: string); stdcall;
procedure Task1_FileFinderByMask (var inputParam1: integer; var swResult: TStreamWriter; iTargetWorkTime: integer); stdcall;
procedure Task2_FileFinderByPattern (var inputParam1, inputParam2: AnsiString; var iResult: longint; iTargetWorkTime: integer); stdcall;


implementation

procedure _GetLibraryNickName (var outputParam1: string);
begin
  outputParam1:= '�������� ����������';
end;

procedure Task1_FileFinderByMask (var inputParam1: integer; var swResult: TStreamWriter; iTargetWorkTime: integer);
var
  iDigit: Byte;
  iProcedureWorkTime: integer;
begin
 iProcedureWorkTime:= GetTickCount(); // ���������� �������� ����� � ������ ������������
 // ����� ����� ���������� �� ��������� ���������
 // �� ������ ������ "��������" - ��������� ���������� �������� � ������ ��� � �������������� ����
 // ��� �� 20 ��
 // ������ ����������� �������������� ��� �������������� ����� ���� "������ ������� �������" ("��", "e" � �.�.)
 repeat
//  fsResult.Seek(0,soFromEnd);//���������� ��������� � ����� ������ � ����������� ��� ����� �� 0 ����.
//  fsResult.WriteBuffer(iDigit, sizeOf(Byte));
  iDigit:= Random(10);
  swResult.Write(iDigit);
  inc(inputParam1);
//  sleep(1);

 until (GetTickCount() - iProcedureWorkTime) >=  iTargetWorkTime;

end;

procedure Task2_FileFinderByPattern (var inputParam1, inputParam2: AnsiString; var iResult: longint; iTargetWorkTime: integer);
var
  iProcedureWorkTime: integer;
begin
 iProcedureWorkTime:= GetTickCount(); // ���������� �������� ����� � ������ ������������
 // ����� ����� ���������� �� ��������� ���������
 // �� ������ ������ "��������" - ��������� ���������� �������� � ������ ��� � �������������� ����
 // ��� �� 20 ��
 // ������ ����������� �������������� ��� �������������� ����� ���� "������ ������� �������" ("��", "e" � �.�.)
 iResult:= 0; //--- ���������� ������� ��������� ��������
 repeat
//  fsResult.Seek(0,soFromEnd);//���������� ��������� � ����� ������ � ����������� ��� ����� �� 0 ����.
//  fsResult.WriteBuffer(iDigit, sizeOf(Byte));
//--- ��� ���������
  sleep(10);

 until (GetTickCount() - iProcedureWorkTime) >=  iTargetWorkTime;

end;

end.
