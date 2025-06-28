unit unSortingSettingsStore;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ExtCtrls, IniFiles;

type
  TformFilterSettingsStore = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    GroupBox15: TGroupBox;
    rbFilterStoreON: TRadioButton;
    rbFilterStoreOFF: TRadioButton;
    cbOrderCreatorOwner: TComboBox;
    ckbStoreCreatorOwner: TCheckBox;
    ckbObjectsGroups: TCheckBox;
    cbObjectGroup: TComboBox;
    gbPeriodSelect: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    dtpPeriodBegin: TDateTimePicker;
    dtpPeriodEnd: TDateTimePicker;
    ckbPeriod: TCheckBox;
    bbSaveSettingsStore: TBitBtn;
    CheckBox1: TCheckBox;
    Label3: TLabel;
    DateTimePicker1: TDateTimePicker;
    Label4: TLabel;
    DateTimePicker2: TDateTimePicker;
    procedure bbSaveSettingsStoreClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  formFilterSettingsStore: TformFilterSettingsStore;

implementation
uses unConstant, unVariable;
{$R *.dfm}

procedure TformFilterSettingsStore.bbSaveSettingsStoreClick(
  Sender: TObject);
begin
 if rbFilterStoreON.Checked then
 begin
  iniFile.WriteInteger('MainForm Settings', 'FilterStoreState', 1); //  ON
  if ckbStoreCreatorOwner.Checked then
  begin
   iniFile.WriteInteger('MainForm Settings', 'FilterState_StoreCreatorOwner', 1); //  ON
   iniFile.WriteString('MainForm Settings', 'Filter_StoreCreatorOwnerText', cbOrderCreatorOwner.Text); //  ON
  end
  else
   iniFile.WriteInteger('MainForm Settings', 'FilterState_StoreCreatorOwner', 0); //  OFF

  if ckbObjectsGroups.Checked then
  begin
   iniFile.WriteInteger('MainForm Settings', 'FilterState_StoreObjectGroup', 1); //  ON
   iniFile.WriteString('MainForm Settings', 'Filter_StoreObjectGroup', cbObjectGroup.Text); //  ON
  end
  else
   iniFile.WriteInteger('MainForm Settings', 'FilterState_StoreObjectGroup', 0); //  OFF

 end
 else iniFile.WriteInteger('MainForm Settings', 'FilterStoreState', 0); // OFF

end;

end.
