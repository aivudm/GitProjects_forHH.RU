unit unVariables;

interface
uses Vcl.StdCtrls, System.Classes, Winapi.Windows, Winapi.Messages, IOUtils, unConst;

type
  TExchangeType = (etSynchronize = 0, etClientServerUDP = 1);

  TOutInfo_ForViewing = record
    hWndViewObject: hWnd;
    IndexInViewComponent: integer;
    TextForViewComponent: ansistring;
  end;

var
//  bFormToolsIsActive: boolean = false;
  ExchangeType: TExchangeType = etSynchronize; //--- Глобальная переменная - будет обращение из потоков
  iTreadCount: byte= 0;
  aResultArraySimple: TArray<Int64>;
  StreamWriter: TStreamWriter;
//  aTaskNameArray: array of string; // = ['Пустой цикл', 'Расчёт числа Пи', 'Определение простых чисел']; //--- При инициализации задачи нумерация будет с номера =


procedure InitializeVariables;
procedure DeinitializeVariables;

implementation
uses unTasks;
procedure InitializeVariables;
begin
end;

procedure DeinitializeVariables;
begin
 if TaskList <> nil then TaskList.Free;
 if CriticalSection <> nil then CriticalSection.Free;

end;


initialization
StreamWriter:= TFile.CreateText('d:\Task_3_SimpleNumbers.txt');

finalization
StreamWriter.Free;

end.
