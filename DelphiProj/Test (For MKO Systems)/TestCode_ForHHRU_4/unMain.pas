unit unMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Menus, IOUtils, Types, DateUtils,
  unConst;

const
  wsAllMask: WideString = '*';
  ItemDelemiter = ';';
  wsBeginMask: WideString = '*.';

type

  TformMain = class(TForm)
    MainMenu1: TMainMenu;
    miFile: TMenuItem;
    miExit: TMenuItem;
    miSetting: TMenuItem;
    miAbout: TMenuItem;
    miTools: TMenuItem;
    GroupBox1: TGroupBox;
    memInfoTread1: TMemo;
    memInfo_2: TMemo;
    lbThreadList: TListBox;
    Label1: TLabel;
    bThreadPause: TButton;
    bStop: TButton;
    sbMain: TStatusBar;
    N1: TMenuItem;
    memInfoTread: TRichEdit;
    procedure miToolsClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure lbThreadListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bThreadPauseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbThreadListClick(Sender: TObject);
    procedure lbThreadListKeyPress(Sender: TObject; var Key: Char);
    procedure N1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure bStopClick(Sender: TObject);
    procedure memInfoTread1Click(Sender: TObject);
  private
    { Private declarations }
//    message WM_WINDOWPOSCHANGING;
    procedure WMCopyData(var MessageData: TWMCopyData); message WM_COPYDATA;
    procedure WMWINDOWPOSCHANGING(var Msg: TWMWINDOWPOSCHANGING); message WM_WINDOWPOSCHANGING;
    procedure HandleProc(var updMessage: TMessage); message WM_Data_Update;
  public
    { Public declarations }
    procedure SetButtonState_ThreadList(ThreadNum: word);
  end;

var
  formMain: TformMain;



implementation
uses unVariables, unTools, unUtils, unUtilCommon, unTasks, unInfoWindow;

{$R *.dfm}

procedure TformMain.WMCopyData(var MessageData: TWMCopyData);
var
  tmpWord: word;
  tmpString: WideString;
begin
//tmpWord:= 47653;
  if MessageData.CopyDataStruct.dwData = CMD_SetMemoLine then
  begin
  tmpString:= PWChar(MessageData.CopyDataStruct.lpData);
   tmpWord:= StrToInt(GetSubStr(tmpString, IndexInString(sDelimiterNumTask, tmpString, 1) + 1, IndexInString(sDelimiterNumTask, tmpString, IndexInString(sDelimiterNumTask, tmpString, 1) + 1) - 1));
   tmpString:= GetSubStr(tmpString, IndexInString(sDelimiterNumTask, tmpString, 2) + 2, - 1);
   if tmpWord > formMain.memInfoTread.Lines.Count  then
    formMain.memInfoTread.Lines.Add(tmpString)
   else
    formMain.memInfoTread.Lines[tmpWord]:= tmpString;

    MessageData.Result := 1;
  end
  else
    MessageData.Result := 0;

end;

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
var
  iTaskNum: word;
begin
 iTaskNum:= lbThreadList.ItemIndex;
 if not ((iTaskNum > -1) and (iTaskNum <= lbThreadList.Count)) then
 begin
  exit;
 end;

 if (TaskList[iTaskNum].TaskState <> tsDone) then
  begin
   TaskList[iTaskNum].TaskState:= tsTerminate;
  end;

 SetButtonState_ThreadList(TaskList[iTaskNum].TaskNum);

end;

procedure TformMain.bThreadPauseClick(Sender: TObject);
var
  iTaskNum: word;
begin
 iTaskNum:= lbThreadList.ItemIndex;
 if not ((iTaskNum > -1) and (iTaskNum <= lbThreadList.Count)) then
 begin
  exit;
 end;

 if (TaskList[iTaskNum].TaskState = tsActive) then
  begin
   TaskList[iTaskNum].TaskState:= tsPause;
//   TaskList[iTaskNum].TaskCore.Suspended:= true;
  end
 else
  begin
   TaskList[iTaskNum].TaskState:= tsActive;
 //  TaskList[iTaskNum].TaskCore.Suspended:= false;;
 //  TaskList[iTaskNum].TaskCore.Priority:= tpNormal;

  end;
 SetButtonState_ThreadList(TaskList[iTaskNum].TaskNum);
end;





function GetSubStr(inSourceString: WideString; inIndex:Byte; inCount:Integer): WideString;
begin
if inCount<>-1 then
   Result:=copy(inSourceString, inIndex, inCount)
else
   Result:=copy(inSourceString, inIndex, (length(inSourceString) - inIndex + 1));
end;

function IndexInString(inSubStr, inSourceString: WideString; inPosBegin: word): word;
var
   MyStr: WideString;
begin
MyStr:= GetSubStr(inSourceString, inPosBegin, -1);
Result:=pos(inSubStr, MyStr);

end;



procedure TformMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
try
 formInfo:= TformInfo.Create(Application);
 formInfo.lMessageInfo.Caption:= sWaitForAppClosing;
 formInfo.Show;
 Application.ProcessMessages;

 if Assigned(formTools) then
 begin
  formTools.Close;
  FreeAndNil(formTools);
 end;

 if Assigned(formTools) then
 begin
  formInfo.Close;
  FreeAndNil(formInfo);
 end;
finally
// DeinitializeVariables;
 FinalizeLibraryes;
end;
end;

procedure TformMain.FormShow(Sender: TObject);
begin
//--- Что бы сразу открывалось окно с настройками
  formMain.miToolsClick(Sender);
  formMain.memInfoTread.Clear;
end;

procedure TformMain.HandleProc(var updMessage: TMessage);
var
  pBuffer: PWideChar;
begin
  pBuffer:= PWideChar(updMessage.LParam);
//  memInfoTread.Lines.Add(updMessage.WParam.ToString());
  memInfo_2.Lines.Add(pBuffer);
end;

procedure TformMain.lbThreadListClick(Sender: TObject);
var
  tmpInt: integer;
begin
 if not ((lbThreadList.ItemIndex > -1) and ((Sender as TListBox).ItemIndex <= (Sender as TListBox).Items.Count)) then
 begin
  exit;
 end;

 SetButtonState_ThreadList(lbThreadList.ItemIndex);

// memInfoTread.SelStart := Perform(EM_LINEINDEX, lbThreadList.ItemIndex, 0) + 2; // start two chars beyond the linestart
// memInfoTread.SelLength:= Perform(EM_LINELENGTH, memInfoTread.SelStart,0) - 2; // decrease the whole length by these two chars


//--- Выделим соответсвующую строку состояния задачи в memInfoTread
//   tmpInt:=Perform(EM_LINEFROMCHAR, lbThreadList.ItemIndex, 0);
//   memInfoTread.SelStart:=Perform(EM_LINEINDEX, tmpInt, 0);
//   memInfoTread.SelLength:=Length(memInfoTread.Lines[tmpInt]);

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

procedure TformMain.memInfoTread1Click(Sender: TObject);
var
  tmpInt: integer;
begin
with (Sender as TMemo) do
begin
   tmpInt:=Perform(EM_LINEFROMCHAR, SelStart, 0);
   SelStart:=Perform(EM_LINEINDEX, tmpInt, 0);
   SelLength:=Length(Lines[tmpInt]);
end;
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

procedure TformMain.N1Click(Sender: TObject);
var
  tmpStringList: TStrings; //List;
begin
  memInfo_2.Lines.Clear;
  ListDLLsForProcess(GetPIDByName(PWChar(formMain.Caption)), memInfo_2.Lines);
end;

procedure TformMain.SetButtonState_ThreadList(ThreadNum: word);
begin
 case TaskList[ThreadNum].GetTaskState of
  tsActive:
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
  tsDone:
   begin
    bStop.Enabled:= false;
    bThreadPause.Enabled:= true;
    bThreadPause.Caption:= 'Запуск (повтор)';
   end;

 end;
end;


//--- Подпрограммы вне классов -------------------------------------------------


initialization

finalization
 if Assigned(iniFile) then
  FreeAndNil(iniFile);
 try
  CloseFile(logFile);
 finally
 end;

end.
