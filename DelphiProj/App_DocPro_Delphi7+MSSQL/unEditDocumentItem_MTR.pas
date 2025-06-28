unit unEditDocumentItem_MTR;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, DB,
  unConstant, unVariable, ExtCtrls, ExtDlgs, CheckLst;

type
  TformEditDocumentItem_MTR = class(TForm)
    GroupBox1: TGroupBox;
    lbFIO: TLabel;
    edFIO: TEdit;
    cbObjectGroup: TComboBox;
    Label1: TLabel;
    Label3: TLabel;
    edObjectName: TEdit;
    Label4: TLabel;
    edObjectVolume: TEdit;
    lb: TLabel;
    cbMeasurementUnit: TComboBox;
    gbAttachements: TGroupBox;
    Splitter1: TSplitter;
    sbAddAttachment: TSpeedButton;
    Label2: TLabel;
    memNotes: TMemo;
    pnlBottomForm: TPanel;
    bbSave: TBitBtn;
    bbCancel: TBitBtn;
    pnlAttachmentList: TPanel;
    lbAttachments: TListBox;
    cbAddAttachment: TCheckBox;
    opdAddFile: TOpenPictureDialog;
    sbDeleteAttachment: TSpeedButton;
    sbRenameAttachment: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure DefaultOnChangeActions(Sender: TObject);       //---- Добавлена вручную
    procedure bbSaveClick(Sender: TObject);
    procedure edObjectVolumeKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure sbAddAttachmentClick(Sender: TObject);
    procedure cbAddAttachmentClick(Sender: TObject);
    procedure sbDeleteAttachmentClick(Sender: TObject);
    procedure sbRenameAttachmentClick(Sender: TObject);
    procedure lbAttachmentsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lbAttachmentsDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    formTypeOperation: TOperationType;
  end;

var
  formEditDocumentItem_MTR: TformEditDocumentItem_MTR;

implementation
uses unUtilCommon, unDM, unDBUtil;

{$R *.dfm}

//-------------- Вручную добавленные процедуры и фукции в классах ---------------------------
procedure TformEditDocumentItem_MTR.DefaultOnChangeActions(Sender: TObject);
begin
 bbSave.Enabled:= true;
end;
//-------------------------------------------------------------------------------------------

procedure TformEditDocumentItem_MTR.FormShow(Sender: TObject);
//var
//--------------------- Временно: после отработки - удалить!
//  idObjectsGroup, idMeasurementsUnit: integer;
//----------------------
begin
 if IsAuthenticationDone() then
 begin
//  FillEditFromQuery(edFIO, 'exec sp_GetUserInfo', queryFieldName_SpravFullName);
  edFIO.Text:= CurrentDocument.CreatorOwner;
  dmDB.QComboBox1.Close;
  Execute_SP('sp_GetSpravObjectGroup_MTR', dmDB.QComboBox1);
  FillComboBoxFromQuery(cbObjectGroup, dmDB.QComboBox1, queryFieldName_SpravShortName);

  cbObjectGroup.Text:= cbObjectGroup.Items[0];

  dmDB.QComboBox2.Close;
  Execute_SP('sp_GetSpravMeasurementUnit', dmDB.QComboBox2);
  FillComboBoxFromQuery(cbMeasurementUnit, dmDB.QComboBox2, queryFieldName_SpravShortName); //-- , cbMeasurementsUnits.Text
  cbMeasurementUnit.Text:= cbMeasurementUnit.Items[0];

  case CurrentDocument.DocumentType of
   dtMTR:
    begin
     gbAttachements.Visible:= false;
    end;
   dtManufacturing:
    begin
     gbAttachements.Visible:= true;
    end;
   dtRepairing:
    begin
     gbAttachements.Visible:= true;
    end;
  end;

 case formTypeOperation of
  doAdd:
    begin
     formEditDocumentItem_MTR.Caption:= 'Добавление строки заявки';
     edObjectName.Text:= '';
     edObjectVolume.Text:= '';
     memNotes.Text:= '';
     cbAddAttachment.Visible:= true;
    end;

  doEdit:
    begin
     formEditDocumentItem_MTR.Caption:= 'Редактирование строки заявки № ' + IntToStr(CurrentDocument.IdDocument);
     edFIO.Text:= CurrentDocumentItem.CreatorOwner;
     edFIO.Text:= CurrentDocument.CreatorOwner;
     cbObjectGroup.Text:= CurrentDocumentItem.ObjectsGroup;
     edObjectName.Text:= CurrentDocumentItem.ShortName;
     edObjectVolume.Text:= IntToStr(CurrentDocumentItem.Volume);
     cbMeasurementUnit.Text:= CurrentDocumentItem.MeasurementUnit;
     memNotes.Text:= CurrentDocumentItem.Notes;
     cbAddAttachment.Visible:= true;
     if CurrentDocumentItem.GetAttachmentsCount > 0 then
     begin
      gbAttachements.Visible:= true;
      FillListBoxFromQuery(lbAttachments, 'sp_GetAttachmentFilesNameForDocumentItem', queryFieldName_AttachmentName, CurrentDocumentItem.Id);
     end;
    end;

  doView:
    begin
     formEditDocumentItem_MTR.Caption:= 'Просмотр строки заявки № ' + IntToStr(CurrentDocument.IdDocument);
     edFIO.Text:= CurrentDocumentItem.CreatorOwner;
     edFIO.Text:= CurrentDocument.CreatorOwner;
     cbObjectGroup.Text:= CurrentDocumentItem.ObjectsGroup;
     cbObjectGroup.Enabled:= false;
     edObjectName.Text:= CurrentDocumentItem.ShortName;
     edObjectName.ReadOnly:= true;
     edObjectVolume.Text:= IntToStr(CurrentDocumentItem.Volume);
     edObjectVolume.Enabled:= false;
     cbMeasurementUnit.Text:= CurrentDocumentItem.MeasurementUnit;
     cbMeasurementUnit.Enabled:= false;
     memNotes.Text:= CurrentDocumentItem.Notes;
     memNotes.ReadOnly:= true;
     bbSave.Enabled:= false;
     cbAddAttachment.Visible:= false;
     sbAddAttachment.Enabled:= false;
     sbRenameAttachment.Enabled:= false;
     sbDeleteAttachment.Enabled:= false;
     if CurrentDocumentItem.GetAttachmentsCount > 0 then
     begin
      gbAttachements.Visible:= true;
      FillListBoxFromQuery(lbAttachments, 'sp_GetAttachmentFilesNameForDocumentItem', queryFieldName_AttachmentName, CurrentDocumentItem.Id);
     end;
    end;
 end;

 end;

end;

procedure TformEditDocumentItem_MTR.bbSaveClick(Sender: TObject);
var
  curRecordPos, curRecordPos1: TidDSPositionSaver;
  i: integer;
  idObjectGroup: TIdSpravObject;
  idMeasurementUnit: TIdMeasurementUnit;
begin
 curRecordPos:= DSPositionSaver.SavePosition(dmDB.QDocument);
 curRecordPos1:= DSPositionSaver.SavePosition(dmDB.QDocumentItem);

 Execute_SP('sp_GetSpravObjectGroup_MTR', dmDB.QComboBox1);
 if FindRecordInQuery(dmDB.QComboBox1, queryFieldName_SpravShortName, cbObjectGroup.Text) then
  idObjectGroup:= dmDB.QComboBox1.FieldByName(queryFieldName_SpravId).AsInteger
 else
 begin
  MessageBox('Код группы объекта не определён по названию!' +  #13#10 + 'Сохранение не произведено', ErrorMessage);
  exit;
 end;

 Execute_SP('sp_GetSpravMeasurementUnit', dmDB.QComboBox2);
 if FindRecordInQuery(dmDB.QComboBox2, queryFieldName_SpravShortName, cbMeasurementUnit.Text) then
  idMeasurementUnit:= dmDB.QComboBox2.FieldByName('id').AsInteger
 else
 begin
  MessageBox('Код единицы измерения не определён по названию!' +  #13#10 + 'Сохранение не произведено', ErrorMessage);
  exit;
 end;


 with formEditDocumentItem_MTR do
 begin
  case formTypeOperation of
   doAdd:
       begin
        i:= CreateDocumentItem_MTR(CurrentDocument.IdDocument, idObjectGroup, edObjectName.Text, edObjectVolume.Text,
                                                  idMeasurementUnit, memNotes.Text);
        if (i > 0) then
        begin
         bbSave.Enabled:= true;
         CurrentDocument.IdSelectedItem:= i;
        end;
        if bbSave.Enabled then
        for i:= 1 to lbAttachments.Items.Count do
         case CurrentDocumentItem.Attachments.GetAttachmentState(i) of
          asNew: bbSave.Enabled:= not (bbSave.Enabled and DocumentItem_AddAttachment(CurrentDocument.IdSelectedItem, CurrentUser.GetLoginName, lbAttachments.Items.Strings[i-1]));
          asRenamed: bbSave.Enabled:= not (bbSave.Enabled and RenameAttachmentForOrderItem(CurrentDocument.IdDocument, CurrentDocument.IdSelectedItem, CurrentUser.GetLoginName, lbAttachments.Items.Strings[i-1], CurrentDocumentItem.Attachments.GetAttachmentId(i)));
          asDeleted: bbSave.Enabled:= not (bbSave.Enabled and DeleteAttachmentForOrderItem(CurrentDocument.IdDocument, CurrentDocument.IdSelectedItem, CurrentUser.GetLoginName, lbAttachments.Items.Strings[i-1], CurrentDocumentItem.Attachments.GetAttachmentId(i)));
         end;

       end;
   doEdit:
       begin
        bbSave.Enabled:= not EditDocumentItem_MTR(CurrentDocument.IdSelectedItem, idObjectGroup, edObjectName.Text, edObjectVolume.Text,
                                                  idMeasurementUnit, memNotes.Text);
        for i:= 1 to lbAttachments.Items.Count do
         case CurrentDocumentItem.Attachments.GetAttachmentState(i) of
          asNew: bbSave.Enabled:= not (bbSave.Enabled and DocumentItem_AddAttachment(CurrentDocument.IdSelectedItem, CurrentUser.GetLoginName, lbAttachments.Items.Strings[i-1]));
          asRenamed: bbSave.Enabled:= not (bbSave.Enabled and RenameAttachmentForOrderItem(CurrentDocument.IdDocument, CurrentDocument.IdSelectedItem, CurrentUser.GetLoginName, lbAttachments.Items.Strings[i-1], CurrentDocumentItem.Attachments.GetAttachmentId(i)));
          asDeleted: bbSave.Enabled:= not (bbSave.Enabled and DeleteAttachmentForOrderItem(CurrentDocument.IdDocument, CurrentDocument.IdSelectedItem, CurrentUser.GetLoginName, lbAttachments.Items.Strings[i-1], CurrentDocumentItem.Attachments.GetAttachmentId(i)));
         end;
       end;
  end;
 end;

 ShowDocumentItem_Document(CurrentDocument.IdDocument);
 DSPositionSaver.RestorePosition(dmDB.QDocument, curRecordPos);
 DSPositionSaver.RestorePosition(dmDB.QDocumentItem, curRecordPos1);
end;

procedure TformEditDocumentItem_MTR.edObjectVolumeKeyPress(Sender: TObject;
  var Key: Char);
begin
SetTextAsInteger(Sender, Key);
end;

procedure TformEditDocumentItem_MTR.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  dmDB.QComboBox1.Close;
  dmDB.QComboBox2.Close;
end;

procedure TformEditDocumentItem_MTR.sbAddAttachmentClick(Sender: TObject);
var
  iTmp: integer;
begin
 opdAddFile.InitialDir:= InitialDirForAttachingFile;
 opdAddFile.FileName:='';
 opdAddFile.Execute;
if (FileExists(opdAddFile.FileName)) then
 begin
  iTmp:= lbAttachments.Items.Add(opdAddFile.FileName);
  CurrentDocumentItem.Attachments.SetAttachmentState(iTmp + 1, asNew); //-- ListBox считает с нуля...
 end
else
 MessageBox('Ошибка добавления вложения.', ErrorMessage);
end;

procedure TformEditDocumentItem_MTR.cbAddAttachmentClick(Sender: TObject);
begin
 gbAttachements.Visible:= cbAddAttachment.Checked;
end;

procedure TformEditDocumentItem_MTR.sbDeleteAttachmentClick(Sender: TObject);
begin
case formTypeOperation of
   doAdd:
       begin
        lbAttachments.DeleteSelected;
       end;
   doEdit:
       begin
        CurrentDocumentItem.Attachments.SetAttachmentState(lbAttachments.ItemIndex + 1, asDeleted); //-- ListBox считает с нуля...
       end;
end;
 lbAttachments.Repaint;
end;

procedure TformEditDocumentItem_MTR.sbRenameAttachmentClick(Sender: TObject);
begin
case formTypeOperation of
   doAdd:
       begin
        MessageBox('Текущее название:' + #13#10 + lbAttachments.Items.Strings[lbAttachments.ItemIndex], EditMessage, lbAttachments.Items.Strings[lbAttachments.ItemIndex]);
        lbAttachments.Items.Strings[lbAttachments.ItemIndex]:= MessageBox_ResultText;
       end;
   doEdit:
       begin
        MessageBox('Текущее название:' + #13#10 + lbAttachments.Items.Strings[lbAttachments.ItemIndex], EditMessage, lbAttachments.Items.Strings[lbAttachments.ItemIndex]);
        lbAttachments.Items.Strings[lbAttachments.ItemIndex]:= MessageBox_ResultText;
       end;
end;
 if CurrentDocumentItem.Attachments.GetAttachmentState(lbAttachments.ItemIndex + 1) <> asNew then
   CurrentDocumentItem.Attachments.SetAttachmentState(lbAttachments.ItemIndex + 1, asRenamed); //-- ListBox считает с нуля...

 lbAttachments.Repaint;

end;

procedure TformEditDocumentItem_MTR.lbAttachmentsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  with lbAttachments do
  begin
  case CurrentDocumentItem.Attachments.GetAttachmentState(Index+1) of
   asDeleted:
       begin
        Canvas.Brush.Color:= clRed;
        Canvas.FillRect(Rect);
        canvas.Font.color:=clWhite;
        canvas.Font.Style:= [fsStrikeOut];
        canvas.TextOut(rect.left,rect.top,items[index]);
       end;
  else
       begin
        Canvas.Brush.Color:= clWhite;
        Canvas.FillRect(Rect);
        canvas.Font.color:= clBlack;
        canvas.TextOut(rect.left,rect.top,items[index]);
       end;
  end;


{*
Пример 1
procedure TForm1.ListBox1DrawItem(Control: TWinControl; Index: Integer; 
Rect: TRect; State: TOwnerDrawState); 
begin 
	With ListBox1 do  
	
	begin  
	
	If odSelected in State then  
	  Canvas.Brush.Color:=clTeal ?/ твой цвет
	else  
	  Canvas.Brush.Color:=clWindow;  
	Canvas.FillRect(Rect);  
	Canvas.TextOut(Rect.Left+2,Rect.Top,Items[Index]);  
	
	end;  
	
end; 

Hе забудьте установить свойство Style у своего ListBox в lbOwnerDrawFixed или в
lbOwnerDrawVariable.


Пример 2

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
procedure TformEditDocumentItem_MTR.lbAttachmentsDblClick(Sender: TObject);
begin
 OpenAttachment(lbAttachments.ItemIndex + 1 {ListBox считает с нуля}, CurrentDocumentItem.Attachments);
end;

end.






