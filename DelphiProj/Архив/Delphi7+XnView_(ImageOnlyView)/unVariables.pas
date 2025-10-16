unit unVariables;

interface
uses FreeImage, ClipBrd, IniFiles,
     SysUtils, Windows, Forms;

type
  TLegalDelemitersDOS = set of char;
const
  ZoomCounter = 3;
  ResamplerIndex = 1.05;
  LegalDelemitersDOSPath: TLegalDelemitersDOS = ['\', '/'];
  DOSPathDelemiter = '\';
  DefaultImage = 'FreeImage.jpg';

var
  iniFile: TIniFile;
  logFile: TextFile;
  ImageFileName: string;
  bWasFirstActivate: boolean = false;
  bCtrlWasPressed: boolean;
  bFirstPageSelect: boolean;

  Clipboard: TClipboard;
  dib, dib1 : PFIBITMAP;
  t : FREE_IMAGE_FORMAT;
  dib_m : PFIMULTIBITMAP;
  dib_m_ActivePage: integer = 0;
  FITMO: FREE_IMAGE_TMO;

procedure InitializeVariables;
procedure DeinitializeVariables;

implementation

procedure InitializeVariables;
var
  strTmp: string;
  i: integer;
begin
try
 try
  strTmp:= Copy(ExtractFileName(Application.ExeName), 1, Pos('.', ExtractFileName(Application.ExeName)) - 1);
  CreateDir(GetEnvironmentVariable('APPDATA') + '\' + strTmp);
  strTmp:= GetEnvironmentVariable('APPDATA') + '\' + strTmp;
  AssignFile(logFile, strTmp + '\' + ExtractFileName(ChangeFileExt(Application.ExeName, '.log' )));
  if FileExists(strTmp) then Append(logFile) else Rewrite(logFile);
 finally
 end;
 iniFile:= TIniFile.Create(strTmp + '\' + ExtractFileName(ChangeFileExt(Application.ExeName, '.ini' )));
 Clipboard:= TClipboard.Create;
 
except
end;
end;

procedure DeinitializeVariables;
begin
 if Assigned(iniFile) then iniFile.Free;
 if Assigned(Clipboard) then Clipboard.Free;

 try
  CloseFile(logFile);
 finally
 end;
end;

end.
