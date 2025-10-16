program DocPro;

uses
  Forms,
  Controls,
  unMain in 'unMain.pas' {formMain},
  unUtilCommon in 'unUtilCommon.pas',
  unLoginDialog in 'unLoginDialog.pas',
  unDM in 'unDM.pas' {MainDM: TDataModule},
  unVariable in 'unVariable.pas',
  unConfirmDlg in 'unConfirmDlg.pas' {formConfirmDlg},
  unLogViewer in 'unLogViewer.pas' {formLogViewer},
  unDBUtil in 'unDBUtil.pas',
  unConstant in 'unConstant.pas',
  unEditDocument in 'unEditDocument.pas' {formEditDocument},
  unMessageBox in 'unMessageBox.pas' {formMessageBox},
  unEditDocumentItem_MTR in 'unEditDocumentItem_MTR.pas' {formEditDocumentItem_MTR},
  unEditSettings in 'unEditSettings.pas' {formEditSettings},
  unXLSUtils in 'unXLSUtils.pas',
  unReport1 in 'unReport1.pas' {Form1},
  unResolutionWriter in 'unResolutionWriter.pas' {formResolutionWriter},
  unSortingSettings in 'unSortingSettings.pas' {formFilterSettings},
  unResolutionForItemWriter in 'unResolutionForItemWriter.pas' {formResolutionForItemWriter},
  unEditUser in 'unEditUser.pas' {formEditUser},
  unEditJobPosition in 'unEditJobPosition.pas' {formEditJobPosition},
  unEditProcess in 'unEditProcess.pas' {formEditProcess},
  unEditProcessItem in 'unEditProcessItem.pas' {formEditProcessItem},
  unEditStoreObject in 'unEditStoreObject.pas' {formEditStoreObject},
  unSortingSettingsStore in 'unSortingSettingsStore.pas' {formFilterSettingsStore},
  unEditOrderItem_ProductManufacturing in 'unEditOrderItem_ProductManufacturing.pas' {formEditOrderItem_ProductManufacturing},
  unSelectObjectManufacture in 'unSelectObjectManufacture.pas' {formSelectObjectManufacture},
  unUtilFiles in 'unUtilFiles.pas',
  unConstantFiles in 'unConstantFiles.pas',
  unUtilStrings in 'unUtilStrings.pas',
  unJob in 'unJob.pas' {formJobProcess},
  unUtilAction in 'unUtilAction.pas',
  unAdminUtil in 'unAdminUtil.pas',
  unEditJob in 'unEditJob.pas' {formEditJob},
  unFrameEditStoreObject in 'unFrameEditStoreObject.pas' {Frame1: TFrame},
  unEditJobItem in 'unEditJobItem.pas' {formEditJobItem};

{$R *.res}
begin
  Application.Initialize;
  Application.CreateForm(TdmDB, dmDB);
  Application.CreateForm(TformMain, formMain);
  Application.CreateForm(TformEditJobItem, formEditJobItem);
  Application.Run;
end.
