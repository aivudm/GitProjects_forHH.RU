library PrimerDll_1_MT_4;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  Windows,
  SysUtils,
  Classes,
  ActiveX,
  unLibrary1API in 'unLibrary1API.pas',
  unVariables in 'unVariables.pas',
  unEditInputParams in 'unEditInputParams.pas' {formEditParams_Task1},
  unErrorException in 'unErrorException.pas',
  unTaskSource in 'unTaskSource.pas';

function GetLibraryAPI(const inputIID: TGUID; var Intf): HRESULT; stdcall;
var
  tmpIID: TGUID;
begin
  try
    tmpIID := ILibraryAPI;
//--- Проверка на соответствие запрашиваемого и реализованного интерфейса
    if CompareMem(@inputIID, @tmpIID, SizeOf(tmpIID)) then
    begin
//--- Проверка на существование экземпляра интерфейса DllAPI
      if LibraryAPI = nil then
        LibraryAPI := TLibraryAPI.Create;
      Pointer(Intf) := nil;
      ILibraryAPI(Intf) := LibraryAPI;
      Result := S_OK;
    end
    else
      Result := E_NOINTERFACE;
    ActiveX.SetErrorInfo(0, nil);
  except
    on E: Exception do
      Result := HandleSafeCallException(E, ExceptAddr);
  end;
end;


{$R *.res}

exports
  GetLibraryAPI name 'GetLibraryAPI';

begin
end.
