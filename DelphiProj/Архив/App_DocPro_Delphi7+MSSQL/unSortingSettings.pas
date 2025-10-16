unit unSortingSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls,
  unConstant, unVariable, Buttons;

type
  TformFilterSettings = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox15: TGroupBox;
    rbFilterON: TRadioButton;
    rbFilterOFF: TRadioButton;
    cbOrderCreatorOwner: TComboBox;
    ckbOrdersCreatorOwner: TCheckBox;
    ckbObjectsGroups: TCheckBox;
    cbObjectGroup: TComboBox;
    gbPeriodSelect: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    dtpPeriodBegin: TDateTimePicker;
    dtpPeriodEnd: TDateTimePicker;
    ckbPeriod: TCheckBox;
    bbSaveSettings: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure rbFilterONClick(Sender: TObject);
    procedure ckbOrdersCreatorOwnerClick(Sender: TObject);
    procedure ckbObjectsGroupsClick(Sender: TObject);
    procedure ckbPeriodClick(Sender: TObject);
    procedure bbSaveSettingsClick(Sender: TObject);
    procedure cbOrderCreatorOwnerChange(Sender: TObject);
    procedure cbObjectGroupChange(Sender: TObject);
    procedure dtpPeriodBeginChange(Sender: TObject);
    procedure dtpPeriodEndChange(Sender: TObject);
    procedure rbFilterOFFClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formFilterSettings: TformFilterSettings;

implementation
uses unUtilCommon, unDM, unDBUtil, unMain;

{$R *.dfm}

procedure TformFilterSettings.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
// bbSaveSettingsClick(Sender);
 formMain.tbFilterSettings.Down:= false;
end;

procedure TformFilterSettings.FormShow(Sender: TObject);
begin
 if IsAuthenticationDone() then
 begin
//------- Заполнение ComboBox's из справочников ---------------------------------

  Execute_SP('sp_GetSpravUser', dmDB.QComboBox1);
  FillComboBoxFromQuery(cbOrderCreatorOwner, dmDB.QComboBox1, queryFieldName_SpravShortName);
//  cbOrderCreatorOwner.Text:= cbOrderCreatorOwner.Items[0];

  Execute_SP('sp_GetSpravObjectGroup_MTR', dmDB.QComboBox2);
  FillComboBoxFromQuery(cbObjectGroup, dmDB.QComboBox2, queryFieldName_SpravShortName);
//  cbObjectGroup.Text:= cbObjectGroup.Items[0];
//------- Конец заполнения ComboBox's из справочников ---------------------------------
 end;

 FilterForOrders.ReadValuesFromIniFile(FilterForOrders);
 ckbOrdersCreatorOwner.Checked:= (FilterForOrders.GetStateInitiatorOwner = fsOn);
 if FilterForOrders.GetStateInitiatorOwner = fsOn then
  cbOrderCreatorOwner.Text:= FilterForOrders.GetValueInitiatorOwner;

 ckbObjectsGroups.Checked:= (FilterForOrders.GetStateObjectsGroup = fsOn);
 if FilterForOrders.GetStateObjectsGroup = fsOn then
  cbObjectGroup.Text:= FilterForOrders.GetValueObjectsGroup;
 ckbPeriod.Checked:= (FilterForOrders.GetStatePeriodCreating = fsOn);
 if FilterForOrders.GetStatePeriodCreating = fsOn then
 begin
  dtpPeriodBegin.Date:= FilterForOrders.GetValuePeriodBeginCreating;
  dtpPeriodEnd.Date:= FilterForOrders.GetValuePeriodEndCreating;
 end;

 rbFilterON.Checked:= (iniFile.ReadInteger('MainForm Settings', 'FilterState', 1) = 1);
end;

procedure TformFilterSettings.rbFilterONClick(Sender: TObject);
begin
 FilterForOrders.SetState:= fsON;
 formMain.tbRefreshClick(Sender);
end;

procedure TformFilterSettings.ckbOrdersCreatorOwnerClick(Sender: TObject);
begin
 if ckbOrdersCreatorOwner.Checked then
 begin
  FilterForOrders.SetStateInitiatorOwner:= fsOn;
 end
 else FilterForOrders.SetStateInitiatorOwner:= fsOff;
 formMain.tbRefreshClick(Sender);
end;

procedure TformFilterSettings.ckbObjectsGroupsClick(Sender: TObject);
begin
 if ckbObjectsGroups.Checked then
 begin
  FilterForOrders.SetStateObjectsGroup:= fsOn;
 end
 else FilterForOrders.SetStateObjectsGroup:= fsOff;

// formMain.tbRefreshClick(Sender);
end;

procedure TformFilterSettings.ckbPeriodClick(Sender: TObject);
begin
 if ckbPeriod.Checked then
 begin
  FilterForOrders.SetStatePeriodCreating:= fsOn;
 end
 else FilterForOrders.SetStatePeriodCreating:= fsOff;

// formMain.tbRefreshClick(Sender);
end;

procedure TformFilterSettings.bbSaveSettingsClick(Sender: TObject);
begin
 FilterForOrders.WriteValuesToIniFile(FilterForOrders);
 formMain.tbRefreshClick(Sender);
 Close;
end;

procedure TformFilterSettings.cbOrderCreatorOwnerChange(Sender: TObject);
begin
 FilterForOrders.SetValueInitiatorOwner:= cbOrderCreatorOwner.Text;
// if FilterForOrders.GetState = fsOn then formMain.tbRefreshClick(Sender);
end;

procedure TformFilterSettings.cbObjectGroupChange(Sender: TObject);
begin
 FilterForOrders.SetValueObjectsGroup:= cbObjectGroup.Text;
// if FilterForOrders.GetState = fsOn then formMain.tbRefreshClick(Sender);
end;

procedure TformFilterSettings.dtpPeriodBeginChange(Sender: TObject);
begin
 FilterForOrders.SetValuePeriodBeginCreating:= dtpPeriodBegin.Date;
// if FilterForOrders.GetState = fsOn then formMain.tbRefreshClick(Sender);
end;

procedure TformFilterSettings.dtpPeriodEndChange(Sender: TObject);
begin
 FilterForOrders.SetValuePeriodEndCreating:= dtpPeriodEnd.Date;
// if FilterForOrders.GetState = fsOn then formMain.tbRefreshClick(Sender);
end;

procedure TformFilterSettings.rbFilterOFFClick(Sender: TObject);
begin
 FilterForOrders.SetState:= fsOff;
 formMain.tbRefreshClick(Sender);
end;

end.
