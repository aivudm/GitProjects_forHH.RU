unit unMain;

interface
uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  System.Diagnostics;


procedure Calc_Algorithm_Pi (var inputParam1: integer; var swResult: TStreamWriter; iTargetWorkTime: integer); stdcall;


implementation

procedure Calc_Algorithm_Pi (var inputParam1: integer; var swResult: TStreamWriter; iTargetWorkTime: integer);
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

end.
