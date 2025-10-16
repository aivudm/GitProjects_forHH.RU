program TSFReader;

uses
  Forms,
  PasTSFReader in 'PasTSFReader.pas' {Form1},
  ConstTSFReader in 'ConstTSFReader.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
