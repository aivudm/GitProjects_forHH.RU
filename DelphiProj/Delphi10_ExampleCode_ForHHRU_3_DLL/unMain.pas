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
 iProcedureWorkTime:= GetTickCount(); // запоминаем значение тиков в начале подпрограммы
 // Здесь будут вычисления по заданному алгоритму
 // на данный момент "пустышка" - получение случайного значения и запись его в результирующий файл
 // сон на 20 мс
 // данная конструкция предполагается для вычислительных задач типа "Расчёт методом краника" ("Пи", "e" и т.д.)
 repeat
//  fsResult.Seek(0,soFromEnd);//установить указатель в конец потока и передвинуть его влево на 0 байт.
//  fsResult.WriteBuffer(iDigit, sizeOf(Byte));
  iDigit:= Random(10);
  swResult.Write(iDigit);
  inc(inputParam1);
//  sleep(1);

 until (GetTickCount() - iProcedureWorkTime) >=  iTargetWorkTime;

end;

end.
