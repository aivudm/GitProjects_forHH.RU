unit unUtils;

interface
uses SysUtils, Windows, FreeImage, Forms, DateUtils;

procedure WriteDataToLog(E_source1, CurrentProcName, CurrentUnitName: string);
procedure TrimWorkingSet;
function SetCorrectDOSPath(MyOperand: String): String;
function GetImageFileType(inputFileName: string): FREE_IMAGE_FORMAT;

implementation
uses unVariables;

procedure WriteDataToLog(E_source1, CurrentProcName, CurrentUnitName: string);
var
  tmpString: string;
begin
 WriteLn(logFile, '-------------------------------------------------------------');
 WriteLn(logFile, FormatDateTime('yyyy.mm.dd', Today()) + '  ' + FormatDateTime('hh:mm:ss', Time()));
 WriteLn(logFile, #13#10);
 WriteLn(logFile, 'Сообщение сгенерировано в - ' + CurrentUnitName + '\' + CurrentProcName);
 tmpString:= E_source1;
 WriteLn(logFile, 'Msg: ' + tmpString);
 WriteLn(logFile, '-------------------------------------------------------------');
end;

procedure TrimWorkingSet;
var
MainHandle: THandle;
begin
 if Win32Platform = VER_PLATFORM_WIN32_NT then
 begin
  MainHandle := OpenProcess(PROCESS_ALL_ACCESS, false, GetCurrentProcessID);
  SetProcessWorkingSetSize(MainHandle, DWORD(-1), DWORD(-1));
  CloseHandle(MainHandle);
 end;
end;

function SetCorrectDOSPath(MyOperand: String): String;
var
   TekChar: Char;
begin // SetCorrectDOSPath
if MyOperand = '' then
 exit;
TekChar:= MyOperand[length(MyOperand)];
Result:= MyOperand;
if not (TekChar in LegalDelemitersDOSPath) then
 begin
  Result:= Result + DOSPathDelemiter;
 end;
end; // SetCorrectDOSPath

function GetImageFileType(inputFileName: string): FREE_IMAGE_FORMAT;
var
  t : FREE_IMAGE_FORMAT;
  Ext : string;
begin
 t := FreeImage_GetFileType(PAnsiChar(AnsiString(inputFileName)), 16);
 if t = FIF_UNKNOWN then t := FreeImage_GetFIFFromFileName(PAnsiChar(AnsiString(inputFileName)));

 if t = FIF_UNKNOWN then
  begin
   // Check for types not supported by GetFileType
   Ext := UpperCase(ExtractFileExt(inputFileName));
   if (Ext = '.TGA') or(Ext = '.TARGA') then
    t := FIF_TARGA
   else if Ext = '.MNG' then
    t := FIF_MNG
   else if Ext = '.PCD' then
    t := FIF_PCD
   else if Ext = '.WBMP' then
    t := FIF_WBMP
   else if Ext = '.CUT' then
    t := FIF_CUT
   else if Ext = '.TIFF' then
    t := FIF_TIFF
  end;
  result:= t;
end;

end.
