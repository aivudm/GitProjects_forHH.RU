unit unVariables;

interface
uses Windows, SysUtils, Classes, ActiveX, ComObj;

type
  BSTR = WideString;
  LPWSTR = PWideChar;
  UnicodeString = WideString;
  NativeInt = Integer;
  NativeUInt = Cardinal;
  DWORD = Cardinal;
  UInt = Cardinal;

type

  IBSTRItems = interface
  ['{7988654F-59FB-401F-9E4C-972FF343C66B}']
    function GetCount: Integer; safecall;
    function GetString(const AIndex: Integer): BSTR; safecall;

    property Count: Integer read GetCount;
    property Strings[const AIndex: Integer]: BSTR read GetString; default;
  end;

  TBSTRItems = class(TInterfacedObject, IBSTRItems)
  strict private
    FStrings: array of String;
  strict protected
    function GetCount: Integer; safecall;
    function GetString(const AIndex: Integer): BSTR; safecall;
  public
    constructor Create(const AStrings: array of BSTR); reintroduce;
  end;


var
  LoadLibraryEx: function(lpFileName: PChar; Reserved: THandle; dwFlags: DWORD): HMODULE; stdcall;


implementation
uses unLibrary1API;


resourcestring
  rsInvalidDelete  = 'Попытка удалить объект %s при активной интерфейсной ссылке; счётчик ссылок: %d';
  rsDoubleFree     = 'Попытка повторно удалить уже удалённый объект %s';
  rsUseDeleted     = 'Попытка использовать уже удалённый объект %s';


{ TBSTRItems }
constructor TBSTRItems.Create(const AStrings: array of WideString);
var
  X: Integer;
begin
  inherited Create;

  SetLength(FStrings, Length(AStrings));
  for X := 0 to High(FStrings) do
    FStrings[X] := AStrings[X];
end;

function TBSTRItems.GetCount: Integer;
begin
  Result := Length(FStrings);
end;

function TBSTRItems.GetString(const AIndex: Integer): BSTR;
begin
  Result := FStrings[AIndex];
end;




end.
