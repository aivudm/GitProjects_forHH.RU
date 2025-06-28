unit unFrameEditStoreObject;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Buttons, ComCtrls, StdCtrls, ExtCtrls;

type
  TFrame1 = class(TFrame)
    Splitter1: TSplitter;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lb: TLabel;
    Label2: TLabel;
    Label10: TLabel;
    cbObjectGroup: TComboBox;
    edObjectName: TEdit;
    edObjectVolume: TEdit;
    cbMeasurementUnit: TComboBox;
    memNotes: TMemo;
    edFIO: TEdit;
    pnlBottomForm: TPanel;
    bbSave: TBitBtn;
    bbCancel: TBitBtn;
    GroupBox2: TGroupBox;
    lbOrderOpen: TLabel;
    cbStoreObjectParentLink: TComboBox;
    dtpStoreObjectCreationDate: TDateTimePicker;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    cbStoreObjectGroup: TComboBox;
    edStoreObjectShortName: TEdit;
    edStoreObjectVolume: TEdit;
    cbStoreMeasurementUnit: TComboBox;
    memStoreNotes: TMemo;
    edStoreObjectFullName: TEdit;
    Panel1: TPanel;
    sbCopyOrderDataToStoreData: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
