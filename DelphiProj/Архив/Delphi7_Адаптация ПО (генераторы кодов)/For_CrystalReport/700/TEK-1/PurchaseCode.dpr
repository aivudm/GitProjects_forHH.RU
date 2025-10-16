program PurchaseCode;

uses
  Forms,
  GetPurchaseKey in 'GetPurchaseKey.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
