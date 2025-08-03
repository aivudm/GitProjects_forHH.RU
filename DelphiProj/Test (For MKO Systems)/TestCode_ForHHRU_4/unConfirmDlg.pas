unit unConfirmDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, unVariables, ExtCtrls;

type
  TformConfirmDlg = class(TForm)
    Panel1: TPanel;
    imgConfirm: TImage;
    Panel2: TPanel;
    bbYes: TBitBtn;
    bbNo: TBitBtn;
    Panel3: TPanel;
    stConfirmText: TStaticText;
    procedure bbYesClick(Sender: TObject);
    procedure bbCancelClick(Sender: TObject);
    procedure bbNoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
   ConfirmResult: TConfirmResult;
  end;

var
  formConfirmDlg: TformConfirmDlg;

implementation
{$R *.dfm}

procedure TformConfirmDlg.bbYesClick(Sender: TObject);
begin
 ConfirmResult:= YesResult;
 formConfirmDlg.Close;
end;

procedure TformConfirmDlg.bbCancelClick(Sender: TObject);
begin
 ConfirmResult:= CancelResult;
 formConfirmDlg.Close;
end;

procedure TformConfirmDlg.bbNoClick(Sender: TObject);
begin
 ConfirmResult:= NoResult;
 formConfirmDlg.Close;
end;

end.
