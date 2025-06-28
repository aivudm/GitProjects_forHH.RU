unit tmp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

const
    NeedSubKey: PChar = 'software\centura\SQLBase\1';
    RegValueKey: String = 'ServerType';
type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
function MyRegSetValueText(My_PHKEY:integer; MyNeedSubKey, MyNeedSubKeyName, MySetingValue: String): boolean;
var
   MyPHKEY, phkResult: integer;
   DataSize: longint;
   MyRegData: PChar; //array [1..256] of char;
   DataBuffer: Pointer;
   MySizeRegValue: DWord;
begin
  if RegOpenKeyEx(My_PHKEY, PChar(MyNeedSubKey), 0, KEY_ALL_ACCESS, phkResult) = 0 then
  try
    GetMem(DataBuffer, 256);
    DataSize := SizeOf(MySetingValue);
    RegSetValueEx(phkResult, PChar(MyNeedSubKeyName), 0,
                              REG_SZ,
                              DataBuffer,
                              DataSize);
    Result:= TRue;;
  finally
    RegCloseKey(phkResult);
    FreeMem(DataBuffer, 256);
  end;
end;


function MyRegGetValueText(My_PHKEY:integer; MyNeedSubKey, MyNeedSubKeyName: String): string;
var
   MyPHKEY, phkResult: integer;
   DataSize: longint;
   MyRegData: PChar; //array [1..256] of char;
   DataBuffer: Pointer;
   MySizeRegValue: DWord;
begin
  if RegOpenKeyEx(My_PHKEY, PChar(MyNeedSubKey), 0, KEY_ALL_ACCESS, phkResult) = 0 then
  try
    GetMem(DataBuffer, 256);
    DataSize := 257;
    RegQueryValueEx(phkResult, PChar(MyNeedSubKeyName), nil, nil , DataBuffer, @DataSize);
    Result:= StrPas(DataBuffer);
  finally
    RegCloseKey(phkResult);
    FreeMem(DataBuffer, 256);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
   NeedSubKey, NeedSubKeyName: string;
   ReestrDataTxt: string;
begin
NeedSubKey:= 'software\centura\SQLBase\1';
NeedSubKeyName:= 'ServerType';
ReestrDataTxt:=MyRegGetValueText(HKEY_LOCAL_MACHINE, NeedSubKey, NeedSubKeyName);
ReestrDataTxt:= 'SQLBase Server 3-Users';
MyRegSetValueText(HKEY_LOCAL_MACHINE, NeedSubKey, NeedSubKeyName, ReestrDataTxt);
end;

end.
