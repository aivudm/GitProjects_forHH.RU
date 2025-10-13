unit unInfoWindow;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TformInfo = class(TForm)
    lMessageInfo: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formInfo: TformInfo;

implementation

{$R *.dfm}

end.
