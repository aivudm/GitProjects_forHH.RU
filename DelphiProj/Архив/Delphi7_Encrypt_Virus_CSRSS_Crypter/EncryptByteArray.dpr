program EncryptByteArray;

uses
  Forms,
  unMain in 'unMain.pas' {formMain},
  unConstant in 'unConstant.pas',
  unUtils in 'unUtils.pas',
  unVariables in 'unVariables.pas',
  unUtilFiles in 'unUtilFiles.pas',
  unConstantFiles in 'unConstantFiles.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.
