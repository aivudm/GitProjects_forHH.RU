unit unMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Menus, unConst, unVariables, unTools;

type

  TformMain = class(TForm)
    MainMenu1: TMainMenu;
    miFile: TMenuItem;
    miExit: TMenuItem;
    miSetting: TMenuItem;
    miAbout: TMenuItem;
    miTools: TMenuItem;
    GroupBox1: TGroupBox;
    memInfoTread: TMemo;
    memInfo_2: TMemo;
    lbThreadList: TListBox;
    Label1: TLabel;
    bThreadPause: TButton;
    bStop: TButton;
    sbMain: TStatusBar;
    procedure miToolsClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure lbThreadListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bStopClick(Sender: TObject);
    procedure bThreadPauseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbThreadListClick(Sender: TObject);
    procedure lbThreadListKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
//    message WM_WINDOWPOSCHANGING;
    procedure WMWINDOWPOSCHANGING(var Msg: TWMWINDOWPOSCHANGING); message WM_WINDOWPOSCHANGING;
    procedure HandleProc(var updMessage: TMessage); message wm_data_update;
  public
    { Public declarations }
    procedure SetButtonState_ThreadList(ThreadNum: word);
  end;

var
  formMain: TformMain;


function AddNewItemToThreadList(NextItem: string): integer;
function AddNewItemToMemo(NextItem: string): integer;

implementation
uses unTasks, unInfoWindow;

{$R *.dfm}

procedure TformMain.WMWindowPosChanging(var Msg: TWMWindowPosChanging);
begin
 inherited;
 if Assigned(formTools) and not Application.Terminated  then
 begin
  formTools.Left:= self.Left + self.Width;
  formTools.Top:= self.Top;
 end;

end;

procedure TformMain.bStopClick(Sender: TObject);
begin
 formTools.tmCheckThreadReport.Enabled:= false;
 TaskList[lbThreadList.ItemIndex].SetTaskState(tsTerminate);
 SetButtonState_ThreadList(lbThreadList.ItemIndex);
 formTools.tmCheckThreadReport.Enabled:= true;
end;

procedure TformMain.bThreadPauseClick(Sender: TObject);
var
  iTaskNum: word;
begin
 formTools.tmCheckThreadReport.Enabled:= false;
 iTaskNum:= lbThreadList.ItemIndex;
 if not ((iTaskNum > -1) and (iTaskNum <= lbThreadList.Count)) then
 begin
  formTools.tmCheckThreadReport.Enabled:= true;
  exit;
 end;

 if (TaskList[iTaskNum].TaskState = tsActive) or (TaskList[iTaskNum].TaskState = tsReportPause) then
  begin
   TaskList[iTaskNum].SetTaskState(tsPause);
  end
 else
  begin
   TaskList[iTaskNum].SetTaskState(tsActive);
   TaskList[iTaskNum].Suspended:= false;;
  end;
 SetButtonState_ThreadList(TaskList[iTaskNum].TaskNum);
 formTools.tmCheckThreadReport.Enabled:= true;
end;

procedure TformMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: word;
begin
 formInfo:= TformInfo.Create(Application);
 formInfo.lMessageInfo.Caption:= sWaitForAppClosing;
 formInfo.Show;
 Application.ProcessMessages;
 formTools.Close;
 formTools.Free;
 formInfo.Close;
 formInfo.Free;
end;

procedure TformMain.HandleProc(var updMessage: TMessage);
var
  pBuffer: PWideChar;
begin
  pBuffer:= PWideChar(updMessage.LParam);
  memInfoTread.Lines.Add(updMessage.WParam.ToString());
  memInfo_2.Lines.Add(pBuffer);
end;

procedure TformMain.lbThreadListClick(Sender: TObject);
begin
 SetButtonState_ThreadList(lbThreadList.ItemIndex);
end;

procedure TformMain.lbThreadListKeyPress(Sender: TObject; var Key: Char);
begin
 SetButtonState_ThreadList(lbThreadList.ItemIndex);
end;

procedure TformMain.lbThreadListMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
// (Sender as TListbox).Selected[(Sender as TListbox).ItemIndex];
SetButtonState_ThreadList((Sender as TListbox).ItemIndex);
end;

procedure TformMain.miExitClick(Sender: TObject);
begin
 Close;
//- Application.Terminate;
end;

procedure TformMain.miToolsClick(Sender: TObject);
begin
// fmTools:= TfmTools.Create(Application);
try
 miTools.Enabled:= false;
 Application.CreateForm(TformTools, formTools);
 formTools.Show;
except
  miTools.Enabled:= true;
end;
// bFormToolsIsActive:= true;
end;

procedure TformMain.SetButtonState_ThreadList(ThreadNum: word);
begin
 case TaskList[ThreadNum].GetTaskState of
  tsActive, tsReportPause:
   begin
    bThreadPause.Enabled:= true;
    bThreadPause.Caption:= 'Пауза';
    bStop.Enabled:= true;
   end;
  tsPause:
   begin
    bThreadPause.Enabled:= true;
    bThreadPause.Caption:= 'Продолжить';
    bStop.Enabled:= true;
   end;
  tsTerminate:
   begin
    bStop.Enabled:= false;
    bThreadPause.Enabled:= false;
    bThreadPause.Caption:= 'Завершён';
   end;

 end;
end;


//--- Подпрограммы вне классов -------------------------------------------------

function AddNewItemToThreadList(NextItem: string): integer;
begin
 Result:= formMain.lbThreadList.Items.Add(NextItem);
end;

function AddNewItemToMemo(NextItem: string): integer;
begin
 Result:= formMain.memInfoTread.Lines.Add(NextItem);
end;

initialization

end.
