program Primer_MT_3;

uses
  Vcl.Forms,
  unTools in 'unTools.pas' {formTools},
  unTasks in 'unTasks.pas',
  unConst in 'unConst.pas',
  unVariables in 'unVariables.pas',
  unMain in 'unMain.pas' {formMain},
  unInfoWindow in 'unInfoWindow.pas' {formInfo},
  unDM in 'unDM.pas' {DataModule1: TDataModule},
  unUtilCommon in 'unUtilCommon.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TformMain, formMain);
  Application.CreateForm(TDataModule1, DM);
  Application.Run;
end.
