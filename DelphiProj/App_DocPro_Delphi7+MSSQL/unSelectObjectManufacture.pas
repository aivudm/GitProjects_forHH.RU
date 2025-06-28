unit unSelectObjectManufacture;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, Buttons, ExtCtrls;

type
  TformSelectObjectManufacture = class(TForm)
    Panel1: TPanel;
    bbSave: TBitBtn;
    bbCancel: TBitBtn;
    dbgrObjectManufactureList: TDBGrid;
    procedure FormShow(Sender: TObject);
    procedure bbSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formSelectObjectManufacture: TformSelectObjectManufacture;

implementation
uses unConstant, unVariable, unUtilCommon, unDBUtil, unDM;

{$R *.dfm}

procedure TformSelectObjectManufacture.FormShow(Sender: TObject);
begin
 if IsAuthenticationDone() then
 begin
  formSelectObjectManufacture.Caption:= '¬ыбор изготавливаемого издели€ из справочника';
  Execute_SP('sp_GetSpravObjectManufacturing', dmDB.QCommon);
 end;

end;

procedure TformSelectObjectManufacture.bbSaveClick(Sender: TObject);
begin
 if dmDB.QCommon.FieldByName(queryFieldName_IdObjectManufacture).Value <> Null then
  CurrentSpravObject.SetCurrent(spravProductManufacturing, dmDB.QCommon.FieldByName(queryFieldName_IdObjectManufacture).AsInteger);
end;

end.
