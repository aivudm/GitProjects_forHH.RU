program CrNtSrv7;

uses
  Forms,
  CrkTl32 in 'CrkTl32.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
