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
  outputParam1:= 'Файловый функционал';
end;

procedure Task1_FileFinderByMask (var inputParam1: integer; var swResult: TStreamWriter; iTargetWorkTime: integer);
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

procedure Task2_FileFinderByPattern (var inputParam1, inputParam2: AnsiString; var iResult: longint; iTargetWorkTime: integer);
var
  iProcedureWorkTime: integer;
begin
 iProcedureWorkTime:= GetTickCount(); // запоминаем значение тиков в начале подпрограммы
 // Здесь будут вычисления по заданному алгоритму
 // на данный момент "пустышка" - получение случайного значения и запись его в результирующий файл
 // сон на 20 мс
 // данная конструкция предполагается для вычислительных задач типа "Расчёт методом краника" ("Пи", "e" и т.д.)
 iResult:= 0; //--- сбрасывает счётчик вхождений паттерна
 repeat
//  fsResult.Seek(0,soFromEnd);//установить указатель в конец потока и передвинуть его влево на 0 байт.
//  fsResult.WriteBuffer(iDigit, sizeOf(Byte));
//--- Для отработки
  sleep(10);

 until (GetTickCount() - iProcedureWorkTime) >=  iTargetWorkTime;

end;

end.
