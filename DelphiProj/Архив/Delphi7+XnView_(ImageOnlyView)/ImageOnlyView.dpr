program ImageOnlyView;

uses
  Forms,
  unImage in 'unImage.pas' {formImage},
  unVariables in 'unVariables.pas',
  unUtils in 'unUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TformImage, formImage);
  Application.Run;
end.
