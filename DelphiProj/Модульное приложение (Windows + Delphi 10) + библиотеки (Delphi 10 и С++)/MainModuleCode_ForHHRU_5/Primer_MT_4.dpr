program Primer_MT_4;

uses
  Windows,
  Vcl.Forms,
  SysUtils,
  Dialogs,
  IOUtils,
  unTools in 'unTools.pas' {formTools},
  unTasks in 'unTasks.pas',
  unConst in 'unConst.pas',
  unVariables in 'unVariables.pas',
  unMain in 'unMain.pas' {formMain},
  unDM in 'unDM.pas' {DataModule1: TDataModule},
  unUtilCommon in 'unUtilCommon.pas',
  unUtils in 'unUtils.pas' {/,},
  unConfirmDlg in 'unConfirmDlg.pas' {formConfirmDlg};

{$R *.res}
{
var
  hUniqueMapping : THandle;
  hFirstWindow : THandle;
  sAppName: PWChar;
}
begin
{
 sAppName:= PWChar(TPath.GetFileName(application.ExeName));
 hUniqueMapping := CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READONLY, 0, 4096, sAppName);
 if hUniqueMapping = 0 then
  begin
   ShowMessage(SysErrorMessage(GetLastError));
   exit; //Halt;
  end
  else
   if GetLastError = ERROR_ALREADY_EXISTS then
    begin
     hFirstWindow := FindWindowEx(0, 0, PWChar(formMain.ClassName), nil);
     if Win32Check(hFirstWindow <> 0) then
      SetForegroundWindow(hFirstWindow);
      Halt;
    end;

}
//  ReportMemoryLeaksOnShutdown := True;
  MainModuleThreadId:= GetCurrentThreadId;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TformMain, formMain);
  Application.CreateForm(TDataModule1, DM);
  Application.Run;
end.
