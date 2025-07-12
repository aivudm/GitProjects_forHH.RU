unit unLibrary1API;
{$A8}
{$MINENUMSIZE 4}
interface
uses
  Windows, SysUtils, ActiveX, Classes, Diagnostics, IOUtils;
{
//function _GetLibraryInfo (out outputParam1: WideString; out InfoRecordSize, InfoRecordCount: Byte): HRESULT; stdcall;
procedure _GetLibraryInfo (out outputParam1: WideString); stdcall;
function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; iTargetWorkTime: WORD; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT; stdcall;
function Task2_FileFinderByPattern (var inputParam1, inputParam2: WideString; var iResult: DWORD; iTargetWorkTime: WORD): HRESULT; stdcall;
}

{ Задачи реализуемые данной библиотекой
  _GetLibraryInfo name 'GetLibraryInfo',
  Task1_FileFinderByMask name 'FileFinderByMask',
  Task2_FileFinderByPattern name 'FileFinderByPattern';
 }

type
  ILibraryAPI = interface
  ['{A1EDF2C2-6A61-4EA2-A8F4-60241BE3EFAD}']
    // Методы реализуемые DLL API
    function GetVersion: BSTR; safecall;
    function GetTaskList: IStrings; safecall;
    procedure FinalizeDLL; safecall;

    property Version: BSTR read GetVersion;

    //--- Методы - реализованный функционал в этой библиотеки
    //--- Для передачи
//    function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; iTargetWorkTime: WORD): HRESULT;  safecall; //; out outputResult: Pointer = Pointer(nil); out outputResultSize: DWORD = 0): HRESULT;  safecall;
//    function Task2_FileFinderByPattern (var inputParam1, inputParam2: WideString; var iResult: DWORD; iTargetWorkTime: WORD): HRESULT; safecall;
  end;

  TLibraryAPI = class(TInterfacedObject, ILibraryAPI) //, ISupportErrorInfo)
  strict private
    FLibraryFuncName: BSTR;

  strict protected
    function GetName: BSTR; safecall;
    function GetVersion: BSTR; safecall;
    function GetTaskList: IStrings; safecall;
    procedure FinalizeDLL; safecall;

    // Функционал библиотеки:
//    function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; iTargetWorkTime: WORD): HRESULT;  safecall; //; out outputResult: Pointer = Pointer(nil); out outputResultSize: DWORD = 0): HRESULT;  safecall;
//    function Task2_FileFinderByPattern (var inputParam1, inputParam2: WideString; var iResult: DWORD; iTargetWorkTime: WORD): HRESULT; safecall;
  public
    constructor Create;
  end;

var
  Lib1_API: ILibraryAPI;

  dllFuncName: BSTR = 'Файловый функционал';
  dllVersion: BSTR = '1.0';

implementation


constructor TLibraryAPI.Create;
begin
  inherited;
  FLibraryFuncName:= dllFuncName;
end;

function TLibraryAPI.GetName: BSTR;
begin
  Result := FLibraryFuncName;
end;

function TLibraryAPI.GetVersion: BSTR;
begin
  Result := dllVersion;
end;

procedure TLibraryAPI.FinalizeDLL;
begin
//  FNotify := nil;
  Lib1_API := nil;
end;

{ TSampleDLLAPI }

// Метод получения результата через память (строки
function TLibraryAPI.GetTaskList: IStrings;
var
  tmpInfoRecordData: array of WideString;
begin
  SetLength(tmpInfoRecordData, 2);
  tmpInfoRecordData[0] := 'Файловый функционал';
  tmpInfoRecordData[1] := 'FileFinderByMask';
//  SampleData[2] := 'Sample';
//  SampleData[3] := 'DLL';
//  SampleData[4] := '!';

  Result := unVariables.TStrings.Create(tmpInfoRecordData);
end;

initialization
  LoadWinAPIFunctions;
//  {$IFDEF WIN32}FixSafeCallExceptions;{$ENDIF}

end.
