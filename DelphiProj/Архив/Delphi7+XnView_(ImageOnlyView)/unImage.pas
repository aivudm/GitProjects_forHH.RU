unit unImage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, ComCtrls, ShellCtrls, ShellAPI,
  GR32, GR32_Image, GR32_Resamplers, GR32_Transforms, ClipBrd, ToolWin,
  FreeImage, ImgList;

type
  TShellListView = class(ShellCtrls.TShellListView)
  protected
    procedure DblClick; override;
  end;

type
  TformImage = class(TForm)
    ImgView32: TImgView32;
    PopupMenu: TPopupMenu;
    ZoomInItem: TMenuItem;
    ZoomOutItem: TMenuItem;
    ActualSizeItem: TMenuItem;
    N1: TMenuItem;
    RotateClockwiseItem: TMenuItem;
    RotateAntiClockwiseItem: TMenuItem;
    N4: TMenuItem;
    FlipHorizontalItem: TMenuItem;
    FilpVerticalItem: TMenuItem;
    N3: TMenuItem;
    ShowAlphaItem: TMenuItem;
    ShowWithAlphaItem: TMenuItem;
    N2: TMenuItem;
    OpenImageItem: TMenuItem;
    Panel1: TPanel;
    Splitter1: TSplitter;
    ShellListView1: TShellListView;
    Splitter2: TSplitter;
    FilterTimer: TTimer;
    AlphaView: TImgView32;
    ToolBar1: TToolBar;
    ToolButton6: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    tbUpLevel: TToolButton;
    tbNextObject: TToolButton;
    tbPrevPage: TToolButton;
    tbNextPage: TToolButton;
    StatusBar: TStatusBar;
    tbRotateAntiClockwise: TToolButton;
    tbRotateClockwise: TToolButton;
    ToolButton5: TToolButton;
    ImageList2: TImageList;
    procedure ShellListView1Click(Sender: TObject);
    procedure ZoomInItemClick(Sender: TObject; inputResamplerIndex: double = 0);
    procedure ZoomOutItemClick(Sender: TObject; inputResamplerIndex: double = 0);
    procedure ActualSizeItemClick(Sender: TObject);
    procedure RotateClockwiseItemClick(Sender: TObject);
    procedure RotateAntiClockwiseItemClick(Sender: TObject);
    procedure ImgView32MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ImgView32MouseEnter(Sender: TObject);
    procedure ImgView32MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ImgView32DblClick(Sender: TObject);
    procedure ShellTreeView1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure tbPrevPageClick(Sender: TObject);
    procedure tbNextPageClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tbNextObjectClick(Sender: TObject);
    procedure tbUpLevelClick(Sender: TObject);
    procedure tbRotateClockwiseClick(Sender: TObject);
    procedure tbRotateAntiClockwiseClick(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure ShellListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    procedure OnAppDeactivate(Sender: TObject);
//    procedure OnAppActivate(Sender: TObject);
    procedure OnAppDoubleClick(Sender: TObject);
  private
    { Private declarations }
    OrigWidth : integer;
    OrigHeight : integer;
    BPP : longword;
    procedure LoadImage(inputFileName: string);
    procedure RecalcWindowSize;
//    procedure IncreaseContrast(Sender: TObject);
 public
    procedure ShowImageVCL(input_dib: PFIBITMAP);
    { Public declarations }
  end;

var
  formImage: TformImage;

implementation
uses unVariables, unUtils;

{$R *.dfm}
procedure TShellListView.DblClick;
begin
 if ItemIndex = -1 then exit;
 AutoNavigate := False;
 with Folders[Selected.Index] do
  if IsFolder then AutoNavigate := True
              else exit;

 inherited DblClick;
end;

procedure TformImage.OnAppDeactivate(Sender: TObject);
begin
// ShowMessage('Фокус потерян!');
// ImgView32.Scale:= 0.08;
 Application.Minimize;
 
end;

procedure TformImage.OnAppDoubleClick(Sender: TObject);
begin
  ZoomOutItemClick(Sender, 5);
end;

procedure TformImage.LoadImage(inputFileName: string);
var
  PBH : PBITMAPINFOHEADER;
  PBI : PBITMAPINFO;
  Ext : string;
  BM : TBitmap;
  x, y : integer;
  BP : PLONGWORD;
  DC : HDC;
begin
  try
    FreeImage_Unload(dib);
    t:= GetImageFileType(inputFileName);
    case t of
     FIF_TIFF:
      begin
       dib_m:= FreeImage_OpenMultiBitmap(t, PAnsiChar(AnsiString(inputFileName)), false, false, false);
       tbPrevPage.Enabled:= false;
       dib_m_ActivePage:= 0;
       if FreeImage_GetPageCount(dib_m) > 1 then
       begin
        tbNextPage.Enabled:= true;
        StatusBar.Panels[1].Text:= 'Страница ' + IntToStr(dib_m_ActivePage + 1) + ' из ' + IntToStr(FreeImage_GetPageCount(dib_m));
       end
       else tbNextPage.Enabled:= false;
      end
     else
      begin
       tbPrevPage.Enabled:= false;
       tbNextPage.Enabled:= false;
       StatusBar.Panels[1].Text:= '';
      end;
    end; {case}

    dib:= FreeImage_Load(t, PAnsiChar(AnsiString(inputFileName)), JPEG_ACCURATE);
    if dib = nil then exit;

{    case FITMO of
     1: FITMO:= FITMO_DRAGO03;
     2: FITMO:= FITMO_REINHARD05;
     3: FITMO:= FITMO_FATTAL02;
    end;
    dib:= FreeImage_ToneMapping(dib, FITMO);
}
    ShowImageVCL(dib);
//    FreeImage_Unload(dib);
    StatusBar.Panels[1].Text:= '';
  except
    on e:exception do
    begin
      Application.BringToFront;
      MessageDlg(e.message, mtInformation, [mbOK], 0);
      Close;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TformImage.ShowImageVCL(input_dib: PFIBITMAP);
var
  PBH : PBITMAPINFOHEADER;
  PBI : PBITMAPINFO;
  t : FREE_IMAGE_FORMAT;
  BM : TBitmap;
  x, y : integer;
  BP : PLONGWORD;
  DC : HDC;
begin
  try
     PBH := FreeImage_GetInfoHeader(input_dib);
     PBI := FreeImage_GetInfo(input_dib);
     BPP := FreeImage_GetBPP(input_dib);

    ShowWithAlphaItem.Enabled := BPP = 32;
    ShowAlphaItem.Enabled := BPP = 32;

    if BPP = 32 then
    begin
      ImgView32.Bitmap.SetSize(FreeImage_GetWidth(input_dib), FreeImage_GetHeight(input_dib));

      BP := PLONGWORD(FreeImage_GetBits(input_dib));
      for y := ImgView32.Bitmap.Height - 1 downto 0 do
        for x := 0 to ImgView32.Bitmap.Width - 1 do
        begin
          ImgView32.Bitmap.Pixel[x, y] := BP^;
          inc(BP);
        end;
    end
    else
    begin
      BM := TBitmap.Create;

      BM.Assign(nil);
      DC := GetDC(Handle);

      BM.handle := CreateDIBitmap(DC,
        PBH^,
        CBM_INIT,
        PChar(FreeImage_GetBits(dib)),
        PBI^,
        DIB_RGB_COLORS);

      ImgView32.Bitmap.Assign(BM);

      BM.Free;
      ReleaseDC(Handle, DC);
    end;

    OrigWidth := ImgView32.Bitmap.Width;
    OrigHeight := ImgView32.Bitmap.Height;

    Caption := ExtractFileName( Name ) + '   (' + IntToStr(OrigWidth) +
                  ' x ' + IntToStr(OrigHeight) + ')';
    if BPP = 32 then
      Caption := Caption + ' + Alpha';

    ImgView32.Hint := 'Name: ' + Name + #13 +
                      'Width: ' + IntToStr(OrigWidth) + #13 +
                      'Height: ' + IntToStr(OrigHeight) + #13 +
                      'BPP: ' + IntToStr(BPP);

//    RecalcWindowSize;
    Show;
  except
    on e:exception do
    begin
      Application.BringToFront;
      MessageDlg(e.message, mtInformation, [mbOK], 0);
      Close;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TformImage.RecalcWindowSize;
var
  Rect : TRect;
  CW, CH : integer;
  WSH, WSW : integer;
  TitleH : integer;
  BorderY : integer;
  BorderX : integer;
begin

  CW := ImgView32.Bitmap.Width + GetSystemMetrics(SM_CXVSCROLL);
  CH := ImgView32.Bitmap.Height + GetSystemMetrics(SM_CYVSCROLL);

  SystemParametersInfo( SPI_GETWORKAREA, 0, @Rect, 0);

  WSH := Rect.Bottom - Rect.Top;
  WSW := Rect.Right - Rect.Left;
  TitleH := GetSystemMetrics(SM_CYCAPTION);
  BorderY := GetSystemMetrics(SM_CYSIZEFRAME) * 2;
  BorderX := GetSystemMetrics(SM_CXSIZEFRAME) * 2;

  if (Top + CH + TitleH + BorderY > WSH) or (CH + TitleH + BorderY > WSH) then
  begin
    Top := Rect.Bottom - CH - BorderY;
    if Top < 0 then
    begin
      Top := 0;
      CH := WSH - TitleH - BorderY;
      CW := CW + GetSystemMetrics(SM_CXVSCROLL);

      if CW + BorderX > WSW then
        CH := CH - GetSystemMetrics(SM_CYVSCROLL);
    end;
  end;

  if (Left + CW + BorderX > WSW) or (CW + BorderX > WSW) then
  begin
    Left := Rect.Right - CW - BorderX;
    if Left < 0 then
    begin
      Left := 0;
      CW := WSW - BorderX;
      CH := CH + GetSystemMetrics(SM_CYVSCROLL);

      if CH + TitleH + BorderY > WSH then
        CW := CW + GetSystemMetrics(SM_CXVSCROLL);
    end
  end;

  ClientWidth := CW;
  ClientHeight := CH;
end;

procedure TformImage.ShellListView1Click(Sender: TObject);
var
  bFileIsNotSupportedType: boolean;
  UnsupportedFileName: string;
begin
try
 bFileIsNotSupportedType:= false;
 if ShellListView1.ItemIndex = -1 then exit;
   ImageFileName:= ShellListView1.Folders[ShellListView1.ItemIndex].PathName;
 if not FileExists(ImageFileName) then
 begin
  ImgView32.Bitmap.LoadFromFile(ExtractFilePath(Application.ExeName) + '\' + DefaultImage);
  exit;
 end;

 t:= GetImageFileType(ImageFileName);
 if (t = FIF_UNKNOWN) or (not FreeImage_FIFSupportsReading(t)) then
 begin
  bFileIsNotSupportedType:= true;
  UnsupportedFileName:= ImageFileName;
  ImageFileName:= ExtractFilePath(Application.ExeName) + '\' + DefaultImage;
 end;

 if not FileExists(ImageFileName) then
 begin
  ImgView32.Bitmap.LoadFromFile(ExtractFilePath(Application.ExeName) + '\' + DefaultImage);
  exit;
 end;

 LoadImage(ImageFileName);
 if bFileIsNotSupportedType then ShellExecute(Application.Handle, 'open', PChar(UnsupportedFileName), nil, nil, SW_SHOWNORMAL);
 StatusBar.Panels[2].Text:= ExtractFileName(ImageFileName);
except
end;
end;

procedure TformImage.ZoomInItemClick(Sender: TObject; inputResamplerIndex: double = 0);
begin
  FilterTimer.Enabled := False;
  if not (ImgView32.Bitmap.Resampler is TNearestResampler) then
    TNearestResampler.Create(ImgView32.Bitmap);
  FilterTimer.Enabled := True;

  if inputResamplerIndex = 0 then ImgView32.Scale := ImgView32.Scale * ResamplerIndex
                              else ImgView32.Scale := ImgView32.Scale * inputResamplerIndex;
  //RecalcWindowSize;
end;

procedure TformImage.ZoomOutItemClick(Sender: TObject; inputResamplerIndex: double = 0);
var
  iHeight, iWidth: integer;
begin

  FilterTimer.Enabled := False;
  if not (ImgView32.Bitmap.Resampler is TNearestResampler) then
    TNearestResampler.Create(ImgView32.Bitmap);
  FilterTimer.Enabled := True;

  if inputResamplerIndex = 0 then ImgView32.Scale := ImgView32.Scale / ResamplerIndex
                              else ImgView32.Scale := ImgView32.Scale / inputResamplerIndex;

  //RecalcWindowSize;

//  FreeImage_RescaleRect(dib, AlphaView.Bitmap.Height, AlphaView.Bitmap.Width, 0, 0, 140, 140);
//  iHeight:= FreeImage_GetHeight(dib);
//  iWidth:= FreeImage_GetWidth(dib);
//  Showmessage(IntToStr(iHeight) + '; ' + IntToStr(iWidth));

//  dib1:= FreeImage_Copy(dib, 0, 0, FreeImage_GetWidth(dib), FreeImage_GetHeight(dib));
//  if inputResamplerIndex = 0 then dib1:= FreeImage_Rescale(dib, Round(FreeImage_GetWidth(dib)/ResamplerIndex), Round(FreeImage_GetHeight(dib)/ResamplerIndex), FILTER_BILINEAR)
//                              else dib1:= FreeImage_Rescale(dib, Round(ImgView32.Bitmap.Width/inputResamplerIndex), Round(ImgView32.Bitmap.Height/inputResamplerIndex), FILTER_BILINEAR);

//  ShowImageVCL(dib1);

end;

procedure TformImage.ActualSizeItemClick(Sender: TObject);
begin
  FilterTimer.Enabled := False;
  if not (ImgView32.Bitmap.Resampler is TNearestResampler) then
    TNearestResampler.Create(ImgView32.Bitmap);
  FilterTimer.Enabled := True;

  ImgView32.Scale := 1.0;

 // RecalcWindowSize;

end;

procedure TformImage.RotateClockwiseItemClick(Sender: TObject);
var
  x : integer;
  y : integer;
  DestX : integer;
  DestY : integer;
  C : TColor32;
begin
  AlphaView.Bitmap.Assign(ImgView32.Bitmap);

  ImgView32.BeginUpdate;
  ImgView32.Bitmap.Width := AlphaView.Bitmap.Height;
  ImgView32.Bitmap.Height := AlphaView.Bitmap.Width;

  for x := 0 to AlphaView.Bitmap.Width - 1 do
    for y := 0 to AlphaView.Bitmap.Height - 1 do
    begin
      C := AlphaView.Bitmap.Pixel[x, y];

      DestX := (ImgView32.Bitmap.Width - 1) - Y;
      DestY := X;

      ImgView32.Bitmap.Pixels[DestX, DestY] := C;
    end;

  ImgView32.EndUpdate;
  ImgView32.Refresh;
end;

procedure TformImage.RotateAntiClockwiseItemClick(Sender: TObject);
var
  x : integer;
  y : integer;
  DestX : integer;
  DestY : integer;
  C : TColor32;
begin
  AlphaView.Bitmap.Assign(ImgView32.Bitmap);

  ImgView32.BeginUpdate;
  ImgView32.Bitmap.Width := AlphaView.Bitmap.Height;
  ImgView32.Bitmap.Height := AlphaView.Bitmap.Width;

  for x := 0 to AlphaView.Bitmap.Width - 1 do
    for y := 0 to AlphaView.Bitmap.Height - 1 do
    begin
      C := AlphaView.Bitmap.Pixel[x, y];

      DestX := Y;
      DestY := (ImgView32.Bitmap.Height - 1) -X;

      ImgView32.Bitmap.Pixels[DestX, DestY] := C;
    end;

  ImgView32.EndUpdate;
  ImgView32.Refresh;
end;

procedure TformImage.ImgView32MouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
ZoomInItemClick(Sender);;
end;

procedure TformImage.ImgView32MouseEnter(Sender: TObject);
begin
 ImgView32.SetFocus;
end;

procedure TformImage.ImgView32MouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
ZoomOutItemClick(Sender);
end;

procedure TformImage.ImgView32DblClick(Sender: TObject);
begin
 ActualSizeItemClick(Sender);
end;

procedure TformImage.ShellTreeView1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case (Key) of
  ord(#13) {VK_RETURN}:
   begin
    if (ImgView32.CanFocus()) then
     ImgView32.SetFocus();
   end;
  ord(#44) {VK_SNAPSHOT}:
   begin
    Key:= 8 {VK_TAB};
    Clipboard.Clear;
    exit;
   end;
  ord('C'), ord('c'), ord(#45) {VK_INSERT}:
    begin
     if (bCtrlWasPressed) then
      begin
       Key:= 8 {VK_TAB};
       Clipboard.Clear;
       exit;
      end;
    end
  else
   bCtrlWasPressed:= false;
  end;
end;

procedure TformImage.FormCreate(Sender: TObject);
begin
// Application.OnActivate := formImage.OnAppActivate;
 Application.OnDeactivate := formImage.OnAppDeactivate;
 ShellListView1.AutoContextMenus:= false;
 InitializeVariables;
 WriteDataToLog('начало', 'TformImage.FormCreate', 'unImage');
 try
  ChDir(iniFile.ReadString('Path', 'Root', ''));
  ShellListView1.Root:= iniFile.ReadString('Path', 'Root', '');
 except
 end;
 ShellListView1.ItemIndex:= 0;
 FITMO:= iniFile.ReadInteger('Settings', 'ToneMapping', 1);
 WriteDataToLog('конец', 'TformImage.FormCreate', 'unImage');
 formImage.WindowState:= wsMaximized;
end;

procedure TformImage.tbPrevPageClick(Sender: TObject);
begin
    case t of
     FIF_TIFF:
      begin
       if dib_m_ActivePage - 1 >= 0 then
        begin
         dib_m_ActivePage:= dib_m_ActivePage - 1;
         if dib_m_ActivePage = 0 then tbPrevPage.Enabled:= false;
         tbNextPage.Enabled:= true;
         bFirstPageSelect:= true;
        end
       else
       begin
        tbPrevPage.Enabled:= false;
        exit;
       end;
      end
     else
      begin
       tbPrevPage.Enabled:= false;
       tbNextPage.Enabled:= false;
      end;
    end; {case}

    dib := FreeImage_LockPage(dib_m, dib_m_ActivePage);
    if dib = nil then exit;
    ShowImageVCL(dib);
    FreeImage_UnlockPage(dib_m, dib, false);
    StatusBar.Panels[1].Text:= 'Страница ' + IntToStr(dib_m_ActivePage + 1) + ' из ' + IntToStr(FreeImage_GetPageCount(dib_m));
end;

procedure TformImage.tbNextPageClick(Sender: TObject);
begin
    case t of
     FIF_TIFF:
      begin
       if FreeImage_GetPageCount(dib_m) >= dib_m_ActivePage + 1 + 1 then
        begin
         dib_m_ActivePage:= dib_m_ActivePage + 1;
         if FreeImage_GetPageCount(dib_m) = dib_m_ActivePage + 1 then tbNextPage.Enabled:= false;
         tbPrevPage.Enabled:= true;
         bFirstPageSelect:= true;
        end
       else
       begin
        tbNextPage.Enabled:= false;
        exit;
       end;
      end
     else
      begin
       tbPrevPage.Enabled:= false;
       tbNextPage.Enabled:= false;
      end;
    end; {case}

    dib := FreeImage_LockPage(dib_m, dib_m_ActivePage);
    if dib = nil then exit;

    ShowImageVCL(dib);
    FreeImage_UnlockPage(dib_m, dib, false);
    StatusBar.Panels[1].Text:= 'Страница ' + IntToStr(dib_m_ActivePage + 1) + ' из ' + IntToStr(FreeImage_GetPageCount(dib_m));
end;


procedure TformImage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 iniFile.WriteString('Path', 'Root', ShellListView1.Root);
 iniFile.WriteString('Path', 'LastDirectoty', ExtractFileDir(ImageFileName));
 iniFile.WriteInteger('Settings', 'ToneMapping', FITMO);
 DeinitializeVariables;
end;

procedure TformImage.tbNextObjectClick(Sender: TObject);
begin
// keybd_event(VK_UP, 0, 0, 0);
 ShellListView1.ItemIndex:= ShellListView1.ItemIndex + 1;
end;

procedure TformImage.tbUpLevelClick(Sender: TObject);
begin
 if ShellListView1.ItemIndex = -1 then ShellListView1.ItemIndex:= 1;
 if AnsiCompareText(SetCorrectDOSPath(ShellListView1.Root), SetCorrectDOSPath(ExtractFileDir(ShellListView1.Folders[ShellListView1.ItemIndex].PathName))) <> 0 then
   ShellListView1.Back
 else exit;

 ImageFileName:= DefaultImage;
 if not FileExists(ImageFileName) then
 begin
  ImgView32.Bitmap.Clear;
  StatusBar.Panels[1].Text:= '';
  StatusBar.Panels[2].Text:= '';
 end
 else
 begin
  LoadImage(ImageFileName);
  StatusBar.Panels[2].Text:= ExtractFileName(ImageFileName);
 end;
end;

procedure TformImage.tbRotateClockwiseClick(Sender: TObject);
begin
//RotateClockwiseItemClick(Sender);
    case t of
     FIF_TIFF:
      begin
       if bFirstPageSelect then
        begin
         dib := FreeImage_LockPage(dib_m, dib_m_ActivePage);
         bFirstPageSelect:= false;
        end;

        if dib = nil then exit;
        dib:= FreeImage_Rotate(dib, -90.0);
        ShowImageVCL(dib);
        FreeImage_UnlockPage(dib_m, dib, false);
      end
     else
      begin
        dib:= FreeImage_Rotate(dib, -90.0);
        ShowImageVCL(dib);
      end;
    end; {case}

 StatusBar.Panels[1].Text:= 'Страница ' + IntToStr(dib_m_ActivePage + 1) + ' из ' + IntToStr(FreeImage_GetPageCount(dib_m));
end;

procedure TformImage.tbRotateAntiClockwiseClick(Sender: TObject);
begin
//RotateAntiClockwiseItemClick(Sender);
    case t of
     FIF_TIFF:
      begin
       if bFirstPageSelect then
        begin
         dib := FreeImage_LockPage(dib_m, dib_m_ActivePage);
         bFirstPageSelect:= false;
        end;

        if dib = nil then exit;
        dib:= FreeImage_Rotate(dib, 90.0);
        ShowImageVCL(dib);
        FreeImage_UnlockPage(dib_m, dib, false);
      end
     else
      begin
        dib:= FreeImage_Rotate(dib, 90.0);
        ShowImageVCL(dib);
      end;
    end; {case}

 StatusBar.Panels[1].Text:= 'Страница ' + IntToStr(dib_m_ActivePage + 1) + ' из ' + IntToStr(FreeImage_GetPageCount(dib_m));
end;

procedure TformImage.ToolButton2Click(Sender: TObject);
begin
 ShellListView1.Root:= iniFile.ReadString('Path', 'Root', '');
 ShellListView1.Update;
end;


procedure TformImage.PopupMenuPopup(Sender: TObject);
begin
 if ShellListView1.ItemIndex = -1 then exit;
 ImageFileName:= ShellListView1.Folders[ShellListView1.ItemIndex].PathName;
 if not FileExists(ImageFileName) then exit;

 t:= GetImageFileType(ImageFileName);
 if (t = FIF_UNKNOWN) or (not FreeImage_FIFSupportsReading(t)) then
 begin
  exit;
 end;
end;

procedure TformImage.ShellListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 case (Key) of
   VK_RETURN: {13}
    begin
     if (Sender as TShellListView).ItemIndex = -1 then exit;
     (Sender as TShellListView).AutoNavigate := False;
     with (Sender as TShellListView).Folders[(Sender as TShellListView).Selected.Index] do
      if IsFolder then (Sender as TShellListView).AutoNavigate := True
                  else exit;
    end;
   VK_CONTROL: {17}
    begin
     bCtrlWasPressed:= true;
     exit;
    end;
   VK_SHIFT:
    begin
     Key:= VK_CONTROL;
     exit;
    end;
 end;
end;

{
//--- Заготовка для процедуры увеличения контраста всех точек (перед уменьшением картинки)
procedure TformImage.IncreaseContrast(Sender: TObject);
var
  x : integer;
  y : integer;
  DestX : integer;
  DestY : integer;
  C : TColor32;
begin
  AlphaView.Bitmap.Assign(ImgView32.Bitmap);

  ImgView32.BeginUpdate;
  ImgView32.Bitmap.Width := AlphaView.Bitmap.Height;
  ImgView32.Bitmap.Height := AlphaView.Bitmap.Width;

  for x := 0 to AlphaView.Bitmap.Width - 1 do
    for y := 0 to AlphaView.Bitmap.Height - 1 do
    begin
      C := AlphaView.Bitmap.Pixel[x, y];

      DestX := Y;
      DestY := (ImgView32.Bitmap.Height - 1) -X;

      ImgView32.Bitmap.Pixels[DestX, DestY] := C;
    end;

  ImgView32.EndUpdate;
  ImgView32.Refresh;
end;
}
end.
