unit unLogViewer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ImgList, Grids, DBGridEh, ToolWin, StdCtrls,
  Mask, DBCtrlsEh, DBGrids;

type
  TformLogViewer = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    nFile: TMenuItem;
    nFile_Exit: TMenuItem;
    CoolBar1: TCoolBar;
    ToolBar1: TToolBar;
    ilLogViewer: TImageList;
    tbRefresh: TToolButton;
    pcontEvents: TPageControl;
    tsheetErrorView: TTabSheet;
    tsheetEventView: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    dbgrehErrorViewer: TDBGrid;
    dbgrehEventViewer: TDBGrid;
    dbdtpBeginDate: TDateTimePicker;
    dbdtpEndDate: TDateTimePicker;
    procedure nFile_ExitClick(Sender: TObject);
    procedure dbgrehErrorViewerDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tbRefreshClick(Sender: TObject);
    procedure dbgrehEventViewerDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure pcontEventsResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formLogViewer: TformLogViewer;

implementation
uses unVariable, unConstant, unUtilCommon, unDM, unDBUtil;


{$R *.dfm}

procedure TformLogViewer.nFile_ExitClick(Sender: TObject);
begin
 formLogViewer.Close;
end;

procedure TformLogViewer.dbgrehErrorViewerDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
With dbgrehErrorViewer do
begin
 if DataSource.DataSet.RecNo mod 2 = 1
	then Canvas.Brush.Color:= ColorZebraGrid;

	// ¬осстанавливаем выделение текущей позиции курсора
	if  gdSelected in State
	then Begin
		Canvas.Brush.Color:= clHighLight;
		Canvas.Font.Color := clHighLightText;
	end;
	// ѕросим GRID перерисоватьс€ самому
	DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;
end;

procedure TformLogViewer.FormResize(Sender: TObject);
begin
//-------- –аздвинем колонку с наименованием описани€ ошибки по максимуму,
//-------- в зависимости от ширины Grid
with dbgrehErrorViewer do
 Columns[2].Width:= formLogViewer.Width - Columns[0].Width- Columns[2].Width -
                    Columns[3].Width - Columns[4].Width - Columns[5].Width - 48;

with dbgrehEventViewer do
 Columns[2].Width:= formLogViewer.Width - Columns[0].Width - Columns[2].Width -
                    Columns[3].Width - Columns[4].Width - Columns[5].Width - 48;


end;

procedure TformLogViewer.FormShow(Sender: TObject);
begin
 GetLogError(byDateAll, dbdtpBeginDate.DateTime, dbdtpEndDate.Datetime +1);
 GetLogEvent(byDateAll, dbdtpBeginDate.DateTime, dbdtpEndDate.DateTime+1);
end;

procedure TformLogViewer.tbRefreshClick(Sender: TObject);
begin
 formLogViewer.FormShow(Sender);
end;

procedure TformLogViewer.dbgrehEventViewerDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
With dbgrehEventViewer do
begin
 if DataSource.DataSet.RecNo mod 2 = 1
	then Canvas.Brush.Color:= ColorZebraGrid;

	// ¬осстанавливаем выделение текущей позиции курсора
	if  gdSelected in State
	then Begin
		Canvas.Brush.Color:= clHighLight;
		Canvas.Font.Color := clHighLightText;
	end;
	// ѕросим GRID перерисоватьс€ самому
	DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;
end;

procedure TformLogViewer.FormCreate(Sender: TObject);
begin
 dbdtpBeginDate.DateTime:= Date();
 dbdtpEndDate.DateTime:= Date();
end;

procedure TformLogViewer.pcontEventsResize(Sender: TObject);
begin
//-------- –аздвинем колонку с наименованием за€вки по максимуму,
//-------- в зависимости от общей ширины Grid
//---------------- »зменение размера дл€ заказов -------------------------------
 case pcontEvents.ActivePageIndex of
 0: begin
     with dbgrehErrorViewer do
     begin
      Columns[1].Width:= Width - Columns[0].Width - Columns[2].Width - Columns[3].Width
                         - Columns[4].Width - Columns[5].Width - col_ShiftForSysCol;
     end;
    end;
 1: begin
     with dbgrehErrorViewer do
     begin
      Columns[1].Width:= Width - Columns[0].Width - Columns[2].Width - Columns[3].Width
                         - Columns[4].Width - col_ShiftForSysCol;
     end;
    end;
 end;
end;

end.
