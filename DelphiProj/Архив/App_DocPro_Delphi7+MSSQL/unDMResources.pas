unit unDMResources;

interface

uses
  SysUtils, Classes, ImgList, Controls;

type
  TDataModule1 = class(TDataModule)
    ilActions: TImageList;
    ilDepartments: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmResources: TDataModule1;

implementation

{$R *.dfm}

end.
