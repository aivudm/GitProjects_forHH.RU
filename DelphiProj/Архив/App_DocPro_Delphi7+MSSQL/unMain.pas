unit unMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ToolWin, ExtCtrls, Menus, ImgList, StdCtrls, Grids,
  DBGrids, DBCtrls, Mask, DBGridEh, DBCtrlsEh, Buttons, CheckLst;
//  frxClass, frxExportXML, frxDBSet;

type
  TformMain = class(TForm)
    mainMenu: TMainMenu;
    miFile: TMenuItem;
    miAbout: TMenuItem;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    Close1: TMenuItem;
    Connect1: TMenuItem;
    ilCollBarMainForm: TImageList;
    miView: TMenuItem;
    miTools: TMenuItem;
    miReferenceBook: TMenuItem;
    N101: TMenuItem;
    popMSearch: TPopupMenu;
    popMSearch_byBeginingAs: TMenuItem;
    popMSearch_byIncludingAs: TMenuItem;
    miView_Sorting: TMenuItem;
    N1: TMenuItem;
    ilObjectExplorer: TImageList;
    N2: TMenuItem;
    N11: TMenuItem;
    N10: TMenuItem;
    N12: TMenuItem;
    N8: TMenuItem;
    pnlBase_LeftSide: TPanel;
    pcontCommonInfo: TPageControl;
    tsheetOrderInfo: TTabSheet;
    Splitter4: TSplitter;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    popMOrderPositionOperations: TPopupMenu;
    popMDocumentOperation: TPopupMenu;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    ilOrderOperations: TImageList;
    Panel4: TPanel;
    pcontStatusList: TPageControl;
    tsheetTreeList: TTabSheet;
    ToolBar4: TToolBar;
    tbRefresh: TToolButton;
    tbFilterSettings: TToolButton;
    Panel5: TPanel;
    Splitter5: TSplitter;
    Panel6: TPanel;
    tvHierarchicalInput: TTreeView;
    tvHierarchicalTotal: TTreeView;
    N9: TMenuItem;
    N16: TMenuItem;
    N7: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    ToolBar5: TToolBar;
    ToolButton2: TToolButton;
    cbFullOrderListStates: TCheckBox;
    gbDocItem: TGroupBox;
    pcontDocumentItem: TPageControl;
    tsheetMTR: TTabSheet;
    ToolBar2: TToolBar;
    tbEditDocumentItem: TToolButton;
    tbAddDocumentItem: TToolButton;
    ToolButton6: TToolButton;
    tbDeleteDocumentItem: TToolButton;
    ToolButton1: TToolButton;
    dbgrDocumentItem: TDBGrid;
    tsheetManufacturing_Tree: TTabSheet;
    tsheetRepairing_Tree: TTabSheet;
    tsheetManufacturing_Linear: TTabSheet;
    GroupBox1: TGroupBox;
    N19: TMenuItem;
    mnPutToStore: TMenuItem;
    ToolButton3: TToolButton;
    tbItemToStore: TToolButton;
    ilOrderItemOperations: TImageList;
    tsheetStoreMTR: TTabSheet;
    GroupBox2: TGroupBox;
    gbSearchCondition: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    ToolBar7: TToolBar;
    tbRefreshStoreObject: TToolButton;
    tbFilterSettingsStore: TToolButton;
    ToolButton18: TToolButton;
    ToolBar8: TToolBar;
    CoolBar1: TCoolBar;
    Edit1: TEdit;
    edSearchStore: TEdit;
    GroupBox15: TGroupBox;
    rbFilterON: TRadioButton;
    rbFilterOFF: TRadioButton;
    cbObjectInitiatorOwner: TComboBox;
    ckbOrdersCreatorOwner: TCheckBox;
    ckbObjectsGroups: TCheckBox;
    cbObjectGroup: TComboBox;
    gbPeriodOrderCreatingSelect: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    dtpPeriodBeginLinkedOrderCreation: TDateTimePicker;
    dtpPeriodEndLinkedOrderCreation: TDateTimePicker;
    ckbPeriodOrderCreating: TCheckBox;
    pnlCurrentOrdersRoute: TPanel;
    gbCurrentOrdersRoute: TGroupBox;
    clbProcessItemList: TCheckListBox;
    Splitter2: TSplitter;
    gbPeriodStoreObjectCreatingSelect: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    dtpPeriodBeginPutOnStock: TDateTimePicker;
    dtpPeriodEndPutOnStock: TDateTimePicker;
    ckbPeriodStoreObjectCreating: TCheckBox;
    ToolButton4: TToolButton;
    N20: TMenuItem;
    N21: TMenuItem;
    tvManufacturingItem: TTreeView;
    ToolBar9: TToolBar;
    tbEditProductManufacturingItem: TToolButton;
    tbAddProductManufacturingItem: TToolButton;
    ToolButton16: TToolButton;
    tbDeleteProductManufacturingItem: TToolButton;
    ToolButton19: TToolButton;
    ToolButton23: TToolButton;
    ToolButton24: TToolButton;
    ToolButton25: TToolButton;
    tsheetStoreInfo_MTR: TTabSheet;
    GroupBox4: TGroupBox;
    ToolBar6: TToolBar;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    dbgrStoreMTR: TDBGrid;
    pcontDocumentType: TPageControl;
    tsheetOrderInfo_MTR: TTabSheet;
    gbDocList: TGroupBox;
    ToolBar3: TToolBar;
    tbEditDocument: TToolButton;
    tbAddDocument: TToolButton;
    ToolButton9: TToolButton;
    tbDeleteDocument: TToolButton;
    ToolButton5: TToolButton;
    ToolButton26: TToolButton;
    dbgrDocument_MTR: TDBGrid;
    tsheetOrderInfo_Manufactoring: TTabSheet;
    GroupBox3: TGroupBox;
    ToolBar10: TToolBar;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton17: TToolButton;
    ToolButton27: TToolButton;
    ToolButton28: TToolButton;
    ToolButton29: TToolButton;
    ToolButton30: TToolButton;
    ToolButton31: TToolButton;
    ToolButton32: TToolButton;
    dbgrDocument_Manufactoring: TDBGrid;
    P1: TMenuItem;
    N22: TMenuItem;
    SPX1: TMenuItem;
    pcontComments: TPageControl;
    tsheetDocumentComment: TTabSheet;
    tvDocumentComment: TTreeView;
    tsheetDocumentItemComment: TTabSheet;
    tvDocumentItemComment: TTreeView;
    tsheetStoreInfo_GotProd: TTabSheet;
    tsheetOrderInfo_Repairing: TTabSheet;
    ToolBar11: TToolBar;
    ToolButton33: TToolButton;
    ToolButton34: TToolButton;
    ToolButton35: TToolButton;
    ToolButton36: TToolButton;
    ToolButton37: TToolButton;
    ToolButton41: TToolButton;
    ToolButton42: TToolButton;
    tsheetRepairing_Linear: TTabSheet;
    dbgrOrdersItems_Manufacturing: TDBGrid;
    tbResizeOrderItem: TToolButton;
    ToolButton45: TToolButton;
    tbResizeOrderList: TToolButton;
    sbOrderItemJob_Manufacturing: TSpeedButton;
    sbJobDocument_MTR: TSpeedButton;
    sbJobDocumentItem_MTR: TSpeedButton;
    SpeedButton1: TSpeedButton;
    procedure Close1Click(Sender: TObject);
    procedure tbRefreshClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miConnectClick(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure edSearchKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pcontCommonInfoChange(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure dbgrDocumentItemDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure pcontCommonInfoResize(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure popMSearch_byBeginingAsClick(Sender: TObject);
    procedure popMSearch_byIncludingAsClick(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbFilterONClick(Sender: TObject);
    procedure tvHierarchicalInputChange(Sender: TObject; Node: TTreeNode);
    procedure tbEditDocumentItemClick(Sender: TObject);
    procedure tbAddDocumentItemClick(Sender: TObject);
    procedure tbDeleteDocumentItemClick(Sender: TObject);
    procedure tbAddDocumentClick(Sender: TObject);
    procedure tbEditDocumentClick(Sender: TObject);
    procedure tbDeleteDocumentClick(Sender: TObject);
    procedure N101Click(Sender: TObject);
    procedure tvHierarchicalTotalChange(Sender: TObject; Node: TTreeNode);
    procedure N16Click(Sender: TObject);
    procedure tbDenyOrderClick(Sender: TObject);
    procedure tbFilterSettingsClick(Sender: TObject);
    procedure tbFilterSettingsMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure clbProcessItemListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure tbToAlterationOrderClick(Sender: TObject);
    procedure dbgrDocumentItemDblClick(Sender: TObject);
    procedure dbgrehDocumentDblClick(Sender: TObject);
    procedure cbFullOrderListStatesClick(Sender: TObject);
    procedure dbgrDocument_MTRDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure tvHierarchicalInputClick(Sender: TObject);
    procedure dbgrDocument_MTRMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure dbgrDocumentItemMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mnPutToStoreClick(Sender: TObject);
    procedure tbItemToStoreClick(Sender: TObject);
    procedure tbRefreshStoreObjectClick(Sender: TObject);
    procedure tbFilterSettingsStoreClick(Sender: TObject);
    procedure edSearchStoreEnter(Sender: TObject);
    procedure edSearchStoreExit(Sender: TObject);
    procedure edSearchStoreKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure rbFilterOFFClick(Sender: TObject);
    procedure ckbOrdersCreatorOwnerClick(Sender: TObject);
    procedure ckbObjectsGroupsClick(Sender: TObject);
    procedure ckbPeriodOrderCreatingClick(Sender: TObject);
    procedure cbObjectInitiatorOwnerChange(Sender: TObject);
    procedure cbObjectGroupChange(Sender: TObject);
    procedure dtpPeriodBeginLinkedOrderCreationChange(Sender: TObject);
    procedure dtpPeriodEndLinkedOrderCreationChange(Sender: TObject);
    procedure ckbPeriodStoreObjectCreatingClick(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure dtpPeriodBeginPutOnStockChange(Sender: TObject);
    procedure dtpPeriodEndPutOnStockChange(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure tbAddProductManufacturingItemClick(Sender: TObject);
    procedure tvManufacturingItemExpanding(Sender: TObject;
      Node: TTreeNode; var AllowExpansion: Boolean);
    procedure tvManufacturingItemChange(Sender: TObject; Node: TTreeNode);
    procedure tvManufacturingItemMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure pcontDocumentTypeChange(Sender: TObject);
    procedure dbgrDocument_ManufactoringDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure P1Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure tbResizeOrderItemClick(Sender: TObject);
    procedure pcontDocumentItemChange(Sender: TObject);
    procedure tbResizeOrderListClick(Sender: TObject);
    procedure dbgrOrdersItems_ManufacturingDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure ToolButton7Click(Sender: TObject);
    procedure ToolButton20Click(Sender: TObject);
    procedure dbgrDocumentItemKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgrDocument_MTRKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sbJobDocumentItem_MTRClick(Sender: TObject);
    procedure tvHierarchicalTotalClick(Sender: TObject);
    procedure dbgrDocumentItemEnter(Sender: TObject);
    procedure sbJobDocument_MTRClick(Sender: TObject);
    procedure dbgrDocument_MTRCellClick(Column: TColumn);
    procedure dbgrDocumentItemCellClick(Column: TColumn);
  private
    { Private declarations }
    procedure SaveSettingsformMain(Sender: TObject);
    procedure RestoreSettingsformMain(Sender: TObject);
  public
    { Public declarations }
  end;

var
  formMain: TformMain;

implementation
uses unConstant, unVariable, unUtilCommon, unAdminUtil, unDBUtil, unLoginDialog, unDM,
     unLogViewer, unEditDocument, unEditDocumentItem_MTR, unEditSettings,
  unResolutionWriter, unSortingSettings, unResolutionForItemWriter,
  unEditStoreObject, unSortingSettingsStore, unEditOrderItem_ProductManufacturing,
  unJob, unUtilAction;

{$R *.dfm}

procedure TformMain.SaveSettingsformMain(Sender: TObject);
begin
try
 iniFile.WriteInteger('MainForm Settings', 'ActiveObjectViewType', formMain.pcontStatusList.ActivePage.TabIndex);
 iniFile.WriteInteger('MainForm Settings', 'ActiveOrderInfoType', formMain.pcontDocumentType.ActivePage.TabIndex);

 case formMain.WindowState of
  wsNormal: iniFile.WriteInteger('MainForm Settings', 'WindowState', 1);
  wsMaximized: iniFile.WriteInteger('MainForm Settings', 'WindowState', 0);
 end;

except
end;
end;

procedure TformMain.RestoreSettingsformMain(Sender: TObject);
begin
try
 formMain.pcontStatusList.ActivePageIndex:= iniFile.ReadInteger('MainForm Settings', 'ActiveObjectViewType', 0);
 formMain.pcontDocumentType.ActivePageIndex:= iniFile.ReadInteger('MainForm Settings', 'ActiveOrderInfoType', 1);

 case iniFile.ReadInteger('MainForm Settings', 'WindowState', 0) of
  0: formMain.WindowState:= wsMaximized;
  1: formMain.WindowState:= wsNormal;
 end;

 if FilterForOrders.GetValueFullOrderListStates = fsOn then formMain.cbFullOrderListStates.Checked:= true;
 CurrentHierarchicalView:= hvInput;
except
end;
end;

procedure TformMain.Close1Click(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TformMain.tbRefreshClick(Sender: TObject);
begin
 Refresh_Action(Sender);
end;

procedure TformMain.FormCreate(Sender: TObject);
var
  i: integer;
begin
 InitializeVariables;
 Application.CreateForm(TformMainLoginDialog, formMainLoginDialog);
 if not (CanEnter(formMainLoginDialog)) then
  begin
   WriteDataToLog('Пользователь отказался от входа', 'ClientData', 'ClientsData');
   DeinitializeVariables;
   Application.Terminate;
   exit;
  end;

 formMain_Handle:= formMain.Handle;
 formMain.Caption:= captionProgramName;
 formMain.miConnectClick(Sender);
 pcontCommonInfo.ActivePageIndex:= 0;

 InitializeVariablesAfterDBConnections;

 RestoreSettingsformMain(Sender);
 pcontCommonInfoChange(pcontCommonInfo);
 
  for i:= 0 to MaxRoutesPointsCount do
      ProcessItemCheckData[i]:= FuturePoint;

//------------------ Установка значений ширины колонок Grids -------------------
  dbgrDocument_MTR.Columns[1].Width:= dbgrDocument_MTR.Width - colOrdersIdWidth - colOrdersCreationDateWidth - colOrdersCreatorOwnerWidth - colOrdersExecutionDateWidth - col_ShiftForSysCol;

  dbgrDocument_MTR.Columns[0].Width:= colOrdersIdWidth;
  dbgrDocument_MTR.Columns[2].Width:= colOrdersCreationDateWidth;
  dbgrDocument_MTR.Columns[3].Width:= colOrdersCreatorOwnerWidth;
  dbgrDocument_MTR.Columns[4].Width:= colOrdersExecutionDateWidth;
  dbgrDocument_MTR.Repaint;
//------------------------------------------------------------------------------

//------------------ Установка наименование вкладок в соответствие с Процессом -

//------------------------------------------------------------------------------


 FilterForOrders.ReadValuesFromIniFile(FilterForOrders);

//----------------- Включение администраторских пунктов меню -------------------
  if lowercase(CurrentUser.GetLoginName) <> 'adminop' then
  begin
   N20.Visible:= false;
   N21.Visible:= false;
   N22.Visible:= false;
   P1.Visible:= false;
   SPX1.Visible:= false;
  end;
//------------------------------------------------------------------------------
end;

procedure TformMain.miAboutClick(Sender: TObject);
begin
 MessageBox('Проект программы...', InfoMessage);
end;


procedure TformMain.miConnectClick(Sender: TObject);
begin
  if (IsAuthenticationDone()) then
   begin
    miView.Enabled:= true;
    miTools.Enabled:= true;
    tbRefresh.Enabled:= true;
    tbRefresh.Enabled:= true;
    formMain.tbRefreshClick(self);
   end
  else
   begin
    miView.Enabled:= false;
    miTools.Enabled:= false;
    tbRefresh.Enabled:= false;
    tbRefresh.Enabled:= false;
   end;
end;

procedure TformMain.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
// ShowObjectDetailedInfo(Node);
end;

procedure TformMain.edSearchKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
// OrdersQuickSearch(edSearch.Text);
end;

procedure TformMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 formMain.SaveSettingsformMain(Sender);
 FilterForOrders.WriteValuesToIniFile(FilterForOrders);
// FilterForStoreObjects.WriteValuesToIniFile(FilterForStoreObjects);
 DeinitializeVariables;
end;

procedure TformMain.pcontCommonInfoChange(Sender: TObject);
begin

 SetInterfaceAfterCommonInfoChange(Sender);

 case (Sender as TPageControl).ActivePageIndex of
 0:
  begin
   tvHierarchicalTotal.TopItem.Selected:= true;
   formMain.tvHierarchicalTotalChange(Sender, tvHierarchicalTotal.TopItem);
   SetCursorWait(StatusBar1);
   RefreshDocument;
   CurrentDocument.SetCurrentByIDDocument(CurrentStoreObject.GetIdParentOrder);
   CurrentDocumentItem.SetCurrentByIDDocumentItem(CurrentStoreObject.GetIdParentOrderItem);
   SetCursorIdle(StatusBar1);
  end;
 1:
  begin
  end;
 end;

 StatusBar1.Panels[1].Text:= (Sender as TPageControl).ActivePage.Name;
end;

procedure TformMain.N8Click(Sender: TObject);
begin
  Application.CreateForm(TformLogViewer, formLogViewer);
  formLogViewer.ShowModal;
  formLogViewer.Free;
end;

procedure TformMain.dbgrDocumentItemDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
   imgAttachmentIcon: Graphics.TBitmap;
   fixRect : TRect;
   bmpWidth : integer;
begin
fixRect := Rect;
//   exit;
With dbgrDocumentItem do
begin
 if DataSource.DataSet.RecNo mod 2 = 1
	then Canvas.Brush.Color:= ColorZebraGrid;

 // Серым выделим позиции не доступные для редактирования
 if DataSource.DataSet.FieldByName(queryFieldName_DocumentItemCanChange).AsInteger = ord(disNotAvailable)
	then Canvas.Font.Color:= clGray; // Font.Style:= [fsStrikeOut]

	// Красным выделим отмененные позиции
 if DataSource.DataSet.FieldByName(queryFieldName_DocumentItemStateCurrent).AsInteger = ord(disDenied)
	then
  begin
   Canvas.Font.Color:= clRed;
//   Font.Style:= [fsStrikeOut];
  end;

	// Зелёным выделим позиции согласованные на текущий момент для текущего пользователя (не факт, что они остануться согласованными до конца Процесса)
 if DataSource.DataSet.FieldByName(queryFieldName_DocumentItemStateCurrent).AsInteger = ord(disAgreed)
	then Canvas.Font.Color:= clGreen; // Font.Style:= [fsStrikeOut]

 // Синим выделим позиции оприходованные на склад
 if DataSource.DataSet.FieldByName(queryFieldName_DocumentItemStateCurrent).AsInteger = ord(disAcceptedOnStock)
	then Canvas.Brush.Color:= clBlue; // Font.Style:= [fsStrikeOut]

// Позиции, не раскрашенные по условиям выше, считаются ещё не отработанными и для них оставляем
// значение по умолчанию, т.е. "черный текст на белом фоне"

	// Восстанавливаем выделение текущей позиции курсора
	if  gdSelected in State
	then
  begin
		Canvas.Brush.Color:= clHighLight;
		Canvas.Font.Color := clHighLightText;
	end;

  if DataSource.DataSet.RecNo > 0 then
  begin
   if  (column.FieldName = queryFieldNameForItemName) and (DataSource.DataSet.FieldByName(queryFieldName_AttachmentId).Value > 0) then
    with  Canvas do
    begin
     fillRect(rect);
     imgAttachmentIcon:= TBitmap.Create;
     ilOrderItemOperations.GetBitmap(12, imgAttachmentIcon);
     try
      bmpWidth := (Rect.Bottom - Rect.Top);
      if DataSource.DataSet.FieldByName(queryFieldName_AttachmentId).Value > 0 then
      begin
      //Fix the bitmap dimensions
      fixRect.Right := Rect.Left + bmpWidth;
      //draw the bitmap
      Canvas.StretchDraw(fixRect, imgAttachmentIcon);
      end;
     finally
      imgAttachmentIcon.Free;
     end;
    // reset the output rectangle,
    // add space for the graphics
    fixRect := Rect;
    fixRect.Left := fixRect.Left + bmpWidth;
      //draw default text (fixed position)
    end;
   end;

	// Просим GRID перерисоваться самому
	DefaultDrawColumnCell(fixRect,DataCol,Column,State);
end;
end;

{
procedure TformMain.dbgrOrdersItemsDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
   imgAttachmentIcon: Graphics.TBitmap;
   intX, intY: integer;
begin

With dbgrOrdersItems do
begin
 if DataSource.DataSet.RecNo mod 2 = 1
	then Canvas.Brush.Color:= ColorZebraGrid;

	// Красным выделим отмененные позиции
 if DataSource.DataSet.FieldByName(queryFieldNameForItemActionCode).AsInteger = ord(oisDenied)
	then Canvas.Brush.Color:= clRed; // Font.Style:= [fsStrikeOut]

	// Зелёным выделим позиции оприходованные на склад
 if DataSource.DataSet.FieldByName(queryFieldNameForItemActionCode).AsInteger = ord(oisAcceptedOnStock)
	then Canvas.Brush.Color:= clGreen; // Font.Style:= [fsStrikeOut]

	// Восстанавливаем выделение текущей позиции курсора
	if  gdSelected in State
	then
  begin
		Canvas.Brush.Color:= clHighLight;
		Canvas.Font.Color := clHighLightText;
	end;

  if DataSource.DataSet.RecNo > 0 then
  begin
   if  (column.FieldName = queryFieldNameForAttachmentName) and (CurrentDocumentItem.GetAttachmentsCount > 0) then
    with  Canvas do
    begin
     fillRect(rect);
     imgAttachmentIcon:= TBitmap.Create;
     ilOrderItemOperations.GetBitmap(12, imgAttachmentIcon);
     try
      if CurrentDocumentItem.GetAttachmentsCount > 0 then //DataSource.DataSet.FieldByName(queryFieldNameForAttachmentName).AsString <> ''
      begin
       intX := ((rect.Right - rect.Left) div 2) -
               (imgAttachmentIcon.Width div 2);
       intY := ((rect.Bottom - rect.Top) div 2) -
               (imgAttachmentIcon.Height div 2);
       draw(rect.Left + intX, rect.Top + intY, imgAttachmentIcon);
      end;
     finally
      imgAttachmentIcon.Free;
     end;
    end;
   end;

	// Просим GRID перерисоваться самому
	DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;
end;
}

procedure TformMain.pcontCommonInfoResize(Sender: TObject);
begin
//-------- Раздвинем колонку с наименованием заявки по максимуму,
//-------- в зависимости от общей ширины Grid
//---------------- Изменение размера для заказов -------------------------------
 with dbgrDocument_MTR do
 begin
  Columns[1].Width:= Width - Columns[0].Width - Columns[2].Width - Columns[3].Width
                     - Columns[4].Width - col_ShiftForSysCol;
 end;

//---------------- Изменение размера для позиций заявки ------------------------
 with dbgrDocumentItem do
 begin
  Columns[1].Width:= Width - Columns[0].Width - Columns[2].Width - Columns[3].Width
                     - Columns[4].Width - Columns[5].Width - Columns[6].Width - col_ShiftForSysCol;
 end;

end;

procedure TformMain.FormResize(Sender: TObject);
begin
//---------------- Изменение размера для TreeView -----------------------------
 if (formMain.Width - 1280) < 280 then pnlBase_LeftSide.Width:= 280
                                  else pnlBase_LeftSide.Width:= formMain.Width - 1280;

end;

procedure TformMain.popMSearch_byBeginingAsClick(Sender: TObject);
begin
 popMSearch_byBeginingAs.Checked:= not popMSearch_byBeginingAs.Checked;
 popMSearch_byIncludingAs.Checked:= not popMSearch_byIncludingAs.Checked;
end;

procedure TformMain.popMSearch_byIncludingAsClick(Sender: TObject);
begin
 popMSearch_byBeginingAs.Checked:= not popMSearch_byBeginingAs.Checked;
 popMSearch_byIncludingAs.Checked:= not popMSearch_byIncludingAs.Checked;
end;

procedure TformMain.N11Click(Sender: TObject);
begin
// dmDB.repClientsByDiagnosis.ShowReport;
end;

procedure TformMain.FormShow(Sender: TObject);
begin
 case CurrentUser.GetAdminRightState of
 true:
  begin
   N101Click(Sender);
   exit;
  end;
 end;
{ tsheetStoreMTRCommonInfo.TabVisible:= false;
 CurrentActiveTreeView:= tvObjectsInput;
 CurrentProcessStatusBrowsing.SetCurrent(CurrentProcessStatusBrowsing, NameOfProcessStatus[0]);
// tbRefreshClick(Sender);
 RefreshOrders;
 RefreshOrdersItems;
}
 FilterForStoreObjects.SetState:= fsOn;


//----------- Актуализируем глобальную переменную TargetDocumentType --------------
 formMain.pcontDocumentTypeChange(pcontDocumentType);
{
 ExecQueryWithoutParam(dmDB.QComboBox1, 'exec sp_GetSpravOrderType');
 FillComboBoxFromQuery(cbOrderTypeSelector, dmDB.QComboBox1, 'ShortName');
 cbOrderTypeSelector.Items.Insert(0, 'Полный перечень');
 cbOrderTypeSelector.Text:= cbOrderTypeSelector.Items[0];
}
//------- Правим интерфейс по ситуации -----------------------------------------
// SetButtonState_DocumentMTR;
//------------------------------------------------------------------------------
 StatusBar1.Panels[1].Text:= 'user: ' + CurrentUser.GetLoginName + ' [' + CurrentUser.GetJobRoleName + ' - ' + CurrentUser.GetFullName + '] ';
end;

procedure TformMain.rbFilterONClick(Sender: TObject);
begin
 FilterForStoreObjects.SetState:= fsON;
 formMain.tbRefreshStoreObjectClick(Sender);
end;

procedure TformMain.tvHierarchicalInputChange(Sender: TObject; Node: TTreeNode);
begin
{
//---------------- Проверка, включение/выключение зависимых объектов -----------
 try
  p:= Node.Data;
  if p = nil then exit;
  asm                         //--- Китайский метод для
   push eax                   //--- i:= PointerToInt(p)
   mov eax, p
   mov i, eax
   pop eax
  end;
  CurrentOrder.SetCurrentByIDOrder(i);
//  FormatDateTime('yyyymmdd', StrToDate(dbedCardClosedDate.Text));
}
 CurrentHierarchicalView:= hvInput;
 CurrentHierarchicalJobStatus:= Node.Text;
 ShowDataForSelectedNode;
 dmDB.QDocument.Last;

//------- Правим интерфейс по ситуации -----------------------------------------
// SetButtonState_DocumentMTR;
//------------------------------------------------------------------------------
end;

procedure TformMain.tvHierarchicalTotalChange(Sender: TObject;
  Node: TTreeNode);
begin
 CurrentHierarchicalView:= hvTotal;
 CurrentHierarchicalJobStatus:= Node.Text;
 ShowDataForSelectedNode;
 dmDB.QDocument.Last;

 //------- Правим интерфейс по ситуации -----------------------------------------
// SetButtonState_DocumentMTR;
//------------------------------------------------------------------------------
end;



procedure TformMain.tbEditDocumentItemClick(Sender: TObject);
begin
  Application.CreateForm(TformEditDocumentItem_MTR, formEditDocumentItem_MTR);
  formEditDocumentItem_MTR.formTypeOperation:= doEdit;
  formEditDocumentItem_MTR.ShowModal;
  formEditDocumentItem_MTR.Free;
  RefreshDocument;

end;

procedure TformMain.tbAddDocumentItemClick(Sender: TObject);
begin
  Application.CreateForm(TformEditDocumentItem_MTR, formEditDocumentItem_MTR);
  formEditDocumentItem_MTR.formTypeOperation:= doAdd;
  formEditDocumentItem_MTR.ShowModal;
  formEditDocumentItem_MTR.Free;
  RefreshDocument;
  SetButtonState_DocumentMTR;
end;

procedure TformMain.tbDeleteDocumentItemClick(Sender: TObject);
var
  tmpConfirmResult: TConfirmResult;
  curRecordPos: TidDSPositionSaver;
begin
 tmpConfirmResult:= ConfirmDlg('Вы действительно хотите удалить выделенную:' + #13#10 +
                                'строку заявки №: ' + IntToStr(CurrentDocument.IdDocument) + #13#10 +
                                CurrentDocument.Notes + #13#10 +
                                'Инициатор: ' + CurrentDocument.CreatorOwner + #13#10 +
                                ' ?');
 if (tmpConfirmResult = NoResult) or (tmpConfirmResult = CancelResult) then exit;

 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocumentItem);
 DeleteOrdersItem_MTR(CurrentDocument.IdSelectedItem, CurrentUser.GetLoginName);

 DSPositionSaver.RestorePosition(dmDB.QDocument, curRecordPos);

 ShowDocumentItem_Document(CurrentDocument.IdDocument);
 SetButtonState_DocumentMTR;
end;

procedure TformMain.tbAddDocumentClick(Sender: TObject);
var
  tmpTreeNode: TTreeNode;
begin
  Application.CreateForm(TformEditDocument, formEditDocument);
  formEditDocument.formTypeOperation:= doAdd;
  formEditDocument.ShowModal;
  formEditDocument.Free;
  RefreshDocument;
  tbRefreshClick(Sender);
  tmpTreeNode:= tvHierarchicalTotal.Items.GetFirstNode;
  tvHierarchicalTotal.Selected:= tmpTreeNode.getFirstChild;
  tvHierarchicalTotal.SetFocus;
  tvHierarchicalTotalChange(Sender, tvHierarchicalTotal.Selected);
end;

procedure TformMain.tbEditDocumentClick(Sender: TObject);
begin
  Application.CreateForm(TformEditDocument, formEditDocument);
  formEditDocument.formTypeOperation:= doEdit;
  formEditDocument.ShowModal;
  formEditDocument.Free;
  RefreshDocument;
end;

procedure TformMain.tbDeleteDocumentClick(Sender: TObject);
var
  tmpConfirmResult: TConfirmResult;
  curRecordPos: TIdDSPositionSaver;
begin
 tmpConfirmResult:= ConfirmDlg('Вы действительно хотите удалить заказ:' + #13#10 +
                                'Номер: ' + IntToStr(CurrentDocument.IdDocument) + #13#10 +
                                CurrentDocument.Notes + #13#10 +
                                'Инициатор: ' + CurrentDocument.CreatorOwner + #13#10 +
                                ' ?');
 if (tmpConfirmResult = NoResult) or (tmpConfirmResult = CancelResult) then exit;

 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocument);
 DeleteDocument(CurrentDocument.IdDocument);
 DSPositionSaver.RestorePosition(dmDB.QDocument, curRecordPos);

 RefreshDocument;
end;

procedure TformMain.N101Click(Sender: TObject);
begin
  Application.CreateForm(TformEditSettings, formEditSettings);
  formEditSettings.ShowModal;
  formEditSettings.Free;
end;

procedure TformMain.N16Click(Sender: TObject);
//var
//    t, t1: TfrxMemoView;
begin
// t1:= TfrxMemoView(dmDB.repForPerforming.FindObject('Memo17'));
// t1.Memo.Text:= quDopPar.FieldbyName('NAME_AGR').AsString;

 PrepareReport_MTR_ForBuying();
// dmDB.repForPerforming.PrepareReport;
 dmDB.frxReport_MTR_ForBuying.ShowReport(true);
end;

procedure TformMain.tbDenyOrderClick(Sender: TObject);
begin
// DocumentItem_Deny(Sender, 'Необходимо решить вопрос о вводе текста резолюции в этой процедуре, если она необходима');
end;

procedure TformMain.tbFilterSettingsClick(Sender: TObject);
begin
 if tbFilterSettings.Down then
 begin
  Application.CreateForm(TformFilterSettings, formFilterSettings);
  formFilterSettings.Left:= formMain.Left + pcontStatusList.Left + ToolBar4.Left + tbFilterSettings.Left + tbFilterSettings.Width + 10; //xposMouse + tbFilterSettings.Width + 30; //
  formFilterSettings.Top:= formMain.Top + pnlBase_LeftSide.Top + pcontStatusList.Top + ToolBar4.Top + tbFilterSettings.Top + 64; //yposMouse + tbFilterSettings.Height; //
  formFilterSettings.Show;
 end
 else  if assigned(formFilterSettings) then formFilterSettings.Free;


end;

procedure TformMain.tbFilterSettingsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 xposMouse:= X;
 yposMouse:= Y;
end;

procedure TformMain.clbProcessItemListDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with clbProcessItemList do begin
  case ProcessItemCheckData[Index] of
   PassedPoint:
       begin
        clbProcessItemList.Canvas.Brush.Color:= clGreen;
        Canvas.FillRect(Rect);
        canvas.Font.color:=clWhite;
        canvas.TextOut(rect.left,rect.top,items[index]);
       end;
   CurrentPoint:
       begin
        clbProcessItemList.Canvas.Brush.Color:= clYellow;
        Canvas.FillRect(Rect);
        canvas.Font.color:= clBlack;
        canvas.TextOut(rect.left,rect.top,items[index]);
       end;
   FuturePoint:
       begin
        clbProcessItemList.Canvas.Brush.Color:= clWhite;
        Canvas.FillRect(Rect);
        canvas.Font.color:= clBlack;
        canvas.TextOut(rect.left,rect.top,items[index]);
       end;
   CanceledPoint:
       begin
        clbProcessItemList.Canvas.Brush.Color:= clRed;
        Canvas.FillRect(Rect);
        canvas.Font.color:= clBlack;
        canvas.TextOut(rect.left,rect.top,items[index]);
       end;
  end;


{*
    if Index < Count then begin
      Flags := DrawTextBiDiModeFlags(DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX);
      if not UseRightToLeftAlignment
        then Inc(Rect.Left, 2)
        else Dec(Rect.Right, 2);
      DrawText(Canvas.Handle, PChar(Data), Length(Data), Rect, Flags);
    end;
*}

  end;
end;

procedure TformMain.tbToAlterationOrderClick(Sender: TObject);
begin
 AlterOrder_Action(Sender, 'Если необходимо, то добавить нормальный текст');
end;

procedure TformMain.dbgrDocumentItemDblClick(Sender: TObject);
begin
  Application.CreateForm(TformEditDocumentItem_MTR, formEditDocumentItem_MTR);
  formEditDocumentItem_MTR.formTypeOperation:= doView;
  formEditDocumentItem_MTR.ShowModal;
  formEditDocumentItem_MTR.Free;
  RefreshDocument;
end;

procedure TformMain.dbgrehDocumentDblClick(Sender: TObject);
begin
  Application.CreateForm(TformEditDocument, formEditDocument);
  formEditDocument.formTypeOperation:= doView;
  formEditDocument.ShowModal;
  formEditDocument.Free;
  RefreshDocument;
end;


procedure TformMain.cbFullOrderListStatesClick(Sender: TObject);
begin
 if cbFullOrderListStates.Checked then FilterForOrders.SetValueFullOrderListStates:= fsOn
                                  else FilterForOrders.SetValueFullOrderListStates:= fsOff;
 tvHierarchicalTotal.Visible:= cbFullOrderListStates.Checked;
end;

procedure TformMain.dbgrDocument_MTRDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
   fixRect : TRect;
begin

fixRect := Rect;
With dbgrDocument_MTR do
begin
 if DataSource.DataSet.RecNo mod 2 = 1
	then Canvas.Brush.Color:= ColorZebraGrid;

	// Красным цветом шрифта выделим отмененные позиции
 if DataSource.DataSet.FieldByName(queryFieldName_DocumentType).AsInteger = ord(dtRepairing)
	then Canvas.Font.Color:= clRed; // Font.Style:= [fsStrikeOut]

	// Зелёным выделим позиции оприходованные на склад
 if DataSource.DataSet.FieldByName(queryFieldName_DocumentType).AsInteger = ord(dtManufacturing)
	then Canvas.Font.Color:= clGreen; // Font.Style:= [fsStrikeOut]

	// Восстанавливаем выделение текущей позиции курсора
	if  gdSelected in State
	then
  begin
		Canvas.Brush.Color:= clHighLight;
		Canvas.Font.Color := clHighLightText;
	end;

{
  if DataSource.DataSet.RecNo > 0 then
  begin
   if  (column.FieldName = queryFieldNameForItemName) and (DataSource.DataSet.FieldByName(queryFieldNameForIdAttachment).Value > 0) then
    with  Canvas do
    begin
     fillRect(rect);
     imgAttachmentIcon:= TBitmap.Create;
     ilOrderItemOperations.GetBitmap(12, imgAttachmentIcon);
     try
      if DataSource.DataSet.FieldByName(queryFieldNameForIdAttachment).Value > 0 then
      begin
      //Fix the bitmap dimensions
      bmpWidth := (Rect.Bottom - Rect.Top);
      fixRect.Right := Rect.Left + bmpWidth;
      //draw the bitmap
      Canvas.StretchDraw(fixRect, imgAttachmentIcon);
      end;
     finally
      imgAttachmentIcon.Free;
     end;
    // reset the output rectangle,
    // add space for the graphics
    fixRect := Rect;
    fixRect.Left := fixRect.Left + bmpWidth;
      //draw default text (fixed position)
    end;
   end;
}

	// Просим GRID перерисоваться самому
	DefaultDrawColumnCell(fixRect,DataCol,Column,State);
end;

{        --- Процедура до изменения (типа архив)
With dbgrehDocument do
begin
 if DataSource.DataSet.RecNo mod 2 = 1
	then Canvas.Brush.Color:= ColorZebraGrid;

	// Восстанавливаем выделение текущей позиции курсора
	if  gdSelected in State
	then Begin
		Canvas.Brush.Color:= clHighLight;
		Canvas.Font.Color := clHighLightText;
	end;
	// Просим GRID перерисоваться самому
	DefaultDrawColumnCell(Rect,DataCol,Column,State);
end;

}
end;

procedure TformMain.tvHierarchicalInputClick(Sender: TObject);
begin
 CurrentHierarchicalView:= hvInput;
 tvHierarchicalInputChange(Sender, tvHierarchicalInput.Selected);
end;

procedure TformMain.dbgrDocument_MTRMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 CurrentActiveObject:= aoDocument;
 dmDB.dsDocumentDataChange(Sender, dmDB.QDocument.Fields[0]);
// ShowCommentsForSelectedOrder(formMain.tvOrderComments, CurrentOrder.IdDocument);
// formMain.tvOrderComments.FullExpand;
end;

procedure TformMain.dbgrDocumentItemMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
 CurrentActiveObject:= aoDocumentItem;
// dmDB.dsDocumentItemDataChange(Sender, dmDB.QDocumentItem.Fields[0]);
// ShowCommentsForSelectedOrderItem(formMain.tvOrderItemComments, CurrentOrder.IdDocument, CurrentDocumentItem.Id);
// formMain.tvOrderItemComments.FullExpand;
end;

procedure TformMain.mnPutToStoreClick(Sender: TObject);
begin
  Application.CreateForm(TformEditStoreObject, formEditStoreObject);
  formEditStoreObject.formTypeOperation:= doAdd;
  formEditStoreObject.ShowModal;
  formEditStoreObject.Free;

  {
  if GetNameProcessStatusByCode(CurrentDocument.JobId) <> CurrentActiveTreeView.Selected.Text then
  begin
//-------- Перекинуть заявку и спозиционироваться на ней уже в статусе "Оприходование на склад" ---------------
   formMain.tbRefreshClick(Sender);
   FindPositionInTreeByName(tvHierarchicalTotal, GetNameProcessStatusByCode(psAcceptingOnStock));
   tvHierarchicalTotal.SetFocus;
   SetCursorWait(StatusBar1);
   CurrentDocument.SetCurrentByIdDocument(CurrentDocument.IdDocument);
   CurrentDocumentItem.SetCurrentByIdDocumentItem(CurrentDocumentItem.Id);
  end;
  SetCursorIdle(StatusBar1);
  }
end;

procedure TformMain.tbItemToStoreClick(Sender: TObject);
begin
 formMain.mnPutToStoreClick(Sender);
 formMain.tbRefreshClick(Sender);
 ShowDocumentItem_Document(CurrentDocument.IdDocument);
 RefreshDocument;
end;

procedure TformMain.tbRefreshStoreObjectClick(Sender: TObject);
begin
try
  SetCursorWait(formMain.StatusBar1);
  RefreshStoreObjectList;
  StatusBar1.Panels[1].Text:= 'Всего объектов на складе ' + IntToStr(dmDB.QStoreObjectList.RecordCount);
finally
  SetCursorIdle(formMain.StatusBar1);
end;

end;

procedure TformMain.tbFilterSettingsStoreClick(Sender: TObject);
begin
 FilterForStoreObjects.WriteValuesToIniFile(FilterForStoreObjects);
end;

procedure TformMain.edSearchStoreEnter(Sender: TObject);
begin
 edSearchStore.Text:= '';
end;

procedure TformMain.edSearchStoreExit(Sender: TObject);
begin
 edSearchStore.Text:= 'Введите строку поиска...';
end;

procedure TformMain.edSearchStoreKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 StoreObjectQuickSearch(edSearchStore.Text);
end;

procedure TformMain.rbFilterOFFClick(Sender: TObject);
begin
 FilterForStoreObjects.SetState:= fsOff;
 formMain.tbRefreshStoreObjectClick(Sender);
end;

procedure TformMain.ckbOrdersCreatorOwnerClick(Sender: TObject);
begin
 if (Sender as TCheckbox).Checked then
 begin
  FilterForStoreObjects.SetStateInitiatorOwner:= fsOn;
 end
 else FilterForStoreObjects.SetStateInitiatorOwner:= fsOff;
 formMain.tbRefreshStoreObjectClick(Sender);

end;

procedure TformMain.ckbObjectsGroupsClick(Sender: TObject);
begin
 if (Sender as TCheckbox).Checked then
 begin
  FilterForStoreObjects.SetStateObjectsGroup:= fsOn;
 end
 else FilterForStoreObjects.SetStateObjectsGroup:= fsOff;

 formMain.tbRefreshStoreObjectClick(Sender);
end;

procedure TformMain.ckbPeriodOrderCreatingClick(Sender: TObject);
begin
 if (Sender as TCheckbox).Checked then
 begin
  FilterForStoreObjects.SetStatePeriodParentObjectCreating:= fsOn;
  FilterForStoreObjects.SetValuePeriodBeginParentObjectCreating:= dtpPeriodBeginLinkedOrderCreation.Date;
  FilterForStoreObjects.SetValuePeriodEndParentObjectCreating:= dtpPeriodEndLinkedOrderCreation.Date;
 end
 else FilterForStoreObjects.SetStatePeriodParentObjectCreating:= fsOff;

 formMain.tbRefreshStoreObjectClick(Sender);

end;

procedure TformMain.cbObjectInitiatorOwnerChange(Sender: TObject);
begin
 if FindRecordInQuery(dmDB.QComboBox1, queryFieldName_SpravFullName, cbObjectInitiatorOwner.Text) then
  FilterForStoreObjects.SetValueInitiatorOwner:= dmDB.QComboBox1.FieldByName(queryFieldName_SpravShortName).Value
 else
 begin
  MessageBox('Login инициатора не определён по названию!' +  #13#10 + 'Сохранение не произведено', ErrorMessage);
  exit;
 end;
 if FilterForStoreObjects.GetState = fsOn then formMain.tbRefreshStoreObjectClick(Sender);
 formMain.tbRefreshStoreObjectClick(Sender);
end;

procedure TformMain.cbObjectGroupChange(Sender: TObject);
begin
 FilterForStoreObjects.SetValueObjectsGroup:= cbObjectGroup.Text;
 if FilterForStoreObjects.GetState = fsOn then formMain.tbRefreshStoreObjectClick(Sender);
 formMain.tbRefreshStoreObjectClick(Sender);
end;

procedure TformMain.dtpPeriodBeginLinkedOrderCreationChange(Sender: TObject);
begin
 FilterForStoreObjects.SetValuePeriodBeginParentObjectCreating:= dtpPeriodBeginLinkedOrderCreation.Date;
// if FilterForStoreObjects.GetState = fsOn then formMain.tbRefreshStoreObjectClick(Sender);
 formMain.ckbPeriodOrderCreatingClick(ckbPeriodOrderCreating);
end;

procedure TformMain.dtpPeriodEndLinkedOrderCreationChange(Sender: TObject);
begin
 FilterForStoreObjects.SetValuePeriodEndParentObjectCreating:= dtpPeriodEndLinkedOrderCreation.Date;
// if FilterForStoreObjects.GetState = fsOn then formMain.tbRefreshStoreObjectClick(Sender);
 formMain.ckbPeriodOrderCreatingClick(ckbPeriodOrderCreating);
end;

procedure TformMain.ckbPeriodStoreObjectCreatingClick(Sender: TObject);
begin
 if (Sender as TCheckbox).Checked then
 begin
  FilterForStoreObjects.SetStatePeriodCreating:= fsOn;
  FilterForStoreObjects.SetValuePeriodBeginCreating:= dtpPeriodBeginPutOnStock.DateTime;
  FilterForStoreObjects.SetValuePeriodEndCreating:= dtpPeriodEndPutOnStock.DateTime;
 end
 else FilterForStoreObjects.SetStatePeriodCreating:= fsOff;

 formMain.tbRefreshStoreObjectClick(Sender);

end;

procedure TformMain.RadioButton1Click(Sender: TObject);
begin
if (Sender as TRadioButton).Checked then FilterForStoreObjects.SetStateSearchSubstringForName:= fsBeginingAs;
 formMain.tbRefreshStoreObjectClick(Sender);
end;

procedure TformMain.RadioButton2Click(Sender: TObject);
begin
if (Sender as TRadioButton).Checked then FilterForStoreObjects.SetStateSearchSubstringForName:= fsIncludingAs;
 formMain.tbRefreshStoreObjectClick(Sender);
end;

procedure TformMain.dtpPeriodBeginPutOnStockChange(Sender: TObject);
begin
 FilterForStoreObjects.SetValuePeriodBeginCreating:= dtpPeriodBeginPutOnStock.DateTime;
// if FilterForStoreObjects.GetState = fsOn then formMain.tbRefreshStoreObjectClick(Sender);
 formMain.ckbPeriodStoreObjectCreatingClick(ckbPeriodStoreObjectCreating);
end;

procedure TformMain.dtpPeriodEndPutOnStockChange(Sender: TObject);
begin
 FilterForStoreObjects.SetValuePeriodEndCreating:= dtpPeriodEndPutOnStock.DateTime;
// if FilterForStoreObjects.GetState = fsOn then formMain.tbRefreshStoreObjectClick(Sender);
 formMain.ckbPeriodStoreObjectCreatingClick(ckbPeriodStoreObjectCreating);
end;

procedure TformMain.N21Click(Sender: TObject);
begin
GetServerStorageProcedures();
SaveText_SP_IntoFile(dmDB.QSPText);
GetServerFunctiones();
SaveText_F_IntoFile(dmDB.QSPText);
end;

procedure TformMain.tbAddProductManufacturingItemClick(Sender: TObject);
begin
  Application.CreateForm(TformEditOrderItem_ProductManufacturing, formEditOrderItem_ProductManufacturing);
  formEditOrderItem_ProductManufacturing.formTypeOperation:= doAdd;
  formEditOrderItem_ProductManufacturing.ShowModal;
  formEditOrderItem_ProductManufacturing.Free;
//  ShowOrderItems_ObjectManufacturing_Tree(tvManufacturingItem);
  SetButtonState_DocumentMTR;
end;

procedure TformMain.tvManufacturingItemExpanding(Sender: TObject;
  Node: TTreeNode; var AllowExpansion: Boolean);
begin
//----- Для начала сделаем элемент "Selected", т.е. выделенным -----------------
 Node.Selected:= true;
 CurrentDocumentItem_Tree.SetCurrent(Node);
//------------------------------------------------------------------------------
 if CurrentDocumentItem_Tree.IdParent = 0 then //--- "Раскрываем" только сами изделия, все остальные DCE "раскрыты" после того, как изделие отработали
 ShowObjectItemsTree_Manufacture(tvManufacturingItem, CurrentDocument.IdDocument, CurrentDocumentItem_Tree.Id);
end;

procedure TformMain.tvManufacturingItemChange(Sender: TObject;
  Node: TTreeNode);
begin
// CurrentOrderItem_Tree.SetCurrent(CurrentProcessStatusBrowsing, Node.Text);
end;

procedure TformMain.tvManufacturingItemMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
{ (Sender as TTreeView).GetNodeAt(X, Y)}
end;

procedure TformMain.pcontDocumentTypeChange(Sender: TObject);
begin
 case (Sender as TPageControl).ActivePageIndex of
 0:
  begin
   CurrentActiveQueryDocumentItem:= dmDB.QDocumentItem;
   TargetDocumentType:= dtMTR;
  end;
 1:
  begin
   CurrentActiveQueryDocumentItem:= dmDB.QDocumentItem_Manufacturing;
   TargetDocumentType:= dtManufacturing;
  end;
 2:
  begin
//   CurrentActiveQueryOrderItem:= dmDB.QOrdersItems_Repairing;
   TargetDocumentType:= dtRepairing;
  end;
 end;
 SetInterfaceAfterDocumentTypeChange;
 formMain.tbRefreshClick(Sender);
end;

procedure TformMain.dbgrDocument_ManufactoringDrawColumnCell(
  Sender: TObject; const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
//   imgAttachmentIcon: Graphics.TBitmap;
   fixRect : TRect;
begin

fixRect := Rect;
With dbgrDocument_Manufactoring do
begin
 if DataSource.DataSet.RecNo mod 2 = 1
	then Canvas.Brush.Color:= ColorZebraGrid;

	// Красным цветом шрифта выделим отмененные позиции
 if DataSource.DataSet.FieldByName(queryFieldName_DocumentType).AsInteger = ord(dtRepairing)
	then Canvas.Font.Color:= clRed; // Font.Style:= [fsStrikeOut]

	// Зелёным выделим позиции оприходованные на склад
 if DataSource.DataSet.FieldByName(queryFieldName_DocumentType).AsInteger = ord(dtManufacturing)
	then Canvas.Font.Color:= clGreen; // Font.Style:= [fsStrikeOut]

	// Восстанавливаем выделение текущей позиции курсора
	if  gdSelected in State
	then
  begin
		Canvas.Brush.Color:= clHighLight;
		Canvas.Font.Color := clHighLightText;
	end;
	// Просим GRID перерисоваться самому
	DefaultDrawColumnCell(fixRect,DataCol,Column,State);
end;
end;

procedure TformMain.P1Click(Sender: TObject);
begin
try
 SetCursorWait(formMain.StatusBar1);
 if not UploadSPToServer then WriteDataToLog('UploadSPToServer() отработал с ошибками', 'TformMain.P1Click', 'unMain');
 if not UploadFnToServer then WriteDataToLog('UploadFnToServer() отработал с ошибками', 'TformMain.P1Click', 'unMain');
finally
  SetCursorIdle(formMain.StatusBar1);
end;
end;


procedure TformMain.N22Click(Sender: TObject);
begin
// GetCatalogDBMSSQL(Application.Handle);
end;

procedure TformMain.tbResizeOrderItemClick(Sender: TObject);
begin
 if pnlBase_LeftSide.Width < pnlBase_LeftSide_Width then
   pnlBase_LeftSide.Width:= pnlBase_LeftSide_Width
 else
   pnlBase_LeftSide.Width:= 10;
end;

procedure TformMain.pcontDocumentItemChange(Sender: TObject);
begin
 case (Sender as TPageControl).ActivePageIndex of
 0:
  begin
   CurrentActiveQueryDocumentItem:= dmDB.QDocumentItem;
   ShowDataForSelectedNode;
  end;
 1, 2:
  begin
   CurrentActiveQueryDocumentItem:= dmDB.QDocumentItem_Manufacturing;
   dmDB.dsDocumentDataChange(Sender, dmDB.QDocument.Fields[0]);
  end;
 end;

//------- Правим интерфейс по ситуации -----------------------------------------
 SetButtonState_DocumentMTR;
//------------------------------------------------------------------------------
 StatusBar1.Panels[1].Text:= (Sender as TPageControl).ActivePage.Name;
end;

procedure TformMain.tbResizeOrderListClick(Sender: TObject);
begin
 if pnlBase_LeftSide.Width < pnlBase_LeftSide_Width then
   pnlBase_LeftSide.Width:= pnlBase_LeftSide_Width
 else
   pnlBase_LeftSide.Width:= 10;
end;

procedure TformMain.dbgrOrdersItems_ManufacturingDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
   imgAttachmentIcon: Graphics.TBitmap;
   fixRect : TRect;
   bmpWidth : integer;
begin
fixRect := Rect;

With dbgrOrdersItems_Manufacturing do
begin
 if not DataSource.DataSet.Active then exit;
 if DataSource.DataSet.RecNo mod 2 = 1
	then Canvas.Brush.Color:= ColorZebraGrid;

	// Красным выделим отмененные позиции
// if DataSource.DataSet.FieldByName(queryFieldNameForItemActionCode).AsInteger = ord(oisDenied)
//	then Canvas.Brush.Color:= clRed; // Font.Style:= [fsStrikeOut]

	// Зелёным выделим позиции оприходованные на склад
// if DataSource.DataSet.FieldByName(queryFieldNameForItemActionCode).AsInteger = ord(oisAcceptedOnStock)
//	then Canvas.Brush.Color:= clGreen; // Font.Style:= [fsStrikeOut]

	// Восстанавливаем выделение текущей позиции курсора
	if  gdSelected in State
	then
  begin
		Canvas.Brush.Color:= clHighLight;
		Canvas.Font.Color := clHighLightText;
	end;

  if DataSource.DataSet.RecNo > 0 then
  begin
   if  (column.FieldName = queryFieldNameForItemName) and (DataSource.DataSet.FieldByName(queryFieldName_AttachmentId).Value > 0) then
    with  Canvas do
    begin
     fillRect(rect);
     imgAttachmentIcon:= TBitmap.Create;
     ilOrderItemOperations.GetBitmap(12, imgAttachmentIcon);
     try
      bmpWidth := (Rect.Bottom - Rect.Top);
      if DataSource.DataSet.FieldByName(queryFieldName_AttachmentId).Value > 0 then
      begin
      //Fix the bitmap dimensions
      fixRect.Right := Rect.Left + bmpWidth;
      //draw the bitmap
      Canvas.StretchDraw(fixRect, imgAttachmentIcon);
      end;
     finally
      imgAttachmentIcon.Free;
     end;
    // reset the output rectangle,
    // add space for the graphics
    fixRect := Rect;
    fixRect.Left := fixRect.Left + bmpWidth;
      //draw default text (fixed position)
    end;
   end;

	// Просим GRID перерисоваться самому
	DefaultDrawColumnCell(fixRect,DataCol,Column,State);
end;

end;

procedure TformMain.ToolButton7Click(Sender: TObject);
begin
 if pnlBase_LeftSide.Width < pnlBase_LeftSide_Width then
   pnlBase_LeftSide.Width:= pnlBase_LeftSide_Width
 else
   pnlBase_LeftSide.Width:= 10;
end;

procedure TformMain.ToolButton20Click(Sender: TObject);
begin
  Application.CreateForm(TformJob, formJob);
  formJob.ShowModal;
  formJob.Free;
end;

procedure TformMain.dbgrDocumentItemKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 CurrentActiveObject:= aoDocumentItem;
end;

procedure TformMain.dbgrDocument_MTRKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 CurrentActiveObject:= aoDocument;
end;    

procedure TformMain.sbJobDocumentItem_MTRClick(Sender: TObject);
var
  curRecordPos: TidDSPositionSaver;
begin
 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocumentItem);
 CurrentActiveObject:= aoDocumentItem;
 Application.CreateForm(TformJob, formJob);
 ShowProcessItemJob_DocumentItem_MTR(formJob.pnlJob);
 formJob.ShowModal;
 formJob.Free;
 ShowDocumentItem_Document(CurrentDocument.IdDocument);
 SetButtonState_DocumentMTR;
 DSPositionSaver.RestorePosition(dmDB.QDocumentItem, curRecordPos);
end;

procedure TformMain.tvHierarchicalTotalClick(Sender: TObject);
begin
 CurrentHierarchicalView:= hvTotal;
 tvHierarchicalTotalChange(Sender, tvHierarchicalTotal.Selected);
end;

procedure TformMain.dbgrDocumentItemEnter(Sender: TObject);
begin
 CurrentActiveObject:= aoDocumentItem;
end;

procedure TformMain.sbJobDocument_MTRClick(Sender: TObject);
var
  curRecordPos: TidDSPositionSaver;
begin
 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocument);
 CurrentActiveObject:= aoDocument;
 Application.CreateForm(TformJob, formJob);
 ShowProcessItemJob_DocumentItem_MTR(formJob.pnlJob);    //????????????????????????????????????????????????????
//  if dmDB.dsJob.DataSet.RecordCount <= 0 then formJob.stJob1_Name.Caption:= 'Нет назначенной работы, кроме элементарных действий';
 formJob.ShowModal;
 formJob.Free;
 ShowDocumentItem_Document(CurrentDocument.IdDocument);
 SetButtonState_DocumentMTR;
 DSPositionSaver.RestorePosition(dmDB.QDocument, curRecordPos);
end;

procedure TformMain.dbgrDocument_MTRCellClick(Column: TColumn);
begin
 CurrentActiveObject:= aoDocument;
end;

procedure TformMain.dbgrDocumentItemCellClick(Column: TColumn);
begin
 CurrentActiveObject:= aoDocumentItem;
end;

end.
