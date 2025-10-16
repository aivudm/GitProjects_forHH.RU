unit unMessageBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TformMessageBox = class(TForm)
    Panel1: TPanel;
    imgMessageType: TImage;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Splitter2: TSplitter;
    stMessageText: TStaticText;
    Panel3: TPanel;
    imgError: TImage;
    imgInfo: TImage;
    bbYes: TBitBtn;
    edNewText: TEdit;
    imgEdit: TImage;
    procedure bbYesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formMessageBox: TformMessageBox;

implementation
uses unVariable;
{$R *.dfm}

procedure TformMessageBox.bbYesClick(Sender: TObject);
begin
 if edNewText.Visible then MessageBox_ResultText:= edNewText.Text;
end;

end.
