unit unMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Menus, unConst, unVariables, unTools, unUtils,
  IOUtils, Types, DateUtils;

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
    Button1: TButton;
    Button2: TButton;
    procedure miToolsClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure lbThreadListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bStopClick(Sender: TObject);
    procedure bThreadPauseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbThreadListClick(Sender: TObject);
    procedure lbThreadListKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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

procedure TformMain.Button1Click(Sender: TObject);
var
  tmpTargetFile: WideString;
  tmpStreamWriter: TStreamWriter;
  inputParam1, inputParam2, inputParam3: WideString;
  inputParam4: BOOL;
  tmpPeriodFlush: Cardinal;
  iProcedureWorkTime: DWORD;
  iTargetWorkTime: WORD;

begin
  inputParam1:= '*.txt'; //Маска
  inputParam2:= 'C:\Users\user\AppData\Roaming\Primer_MT_3'; // Директория старта поиска
  inputParam3:= 'D:\Install\ResultSearchByMask1.txt'; // Имя файла для записи результата, если inputParam4 - true
  inputParam4:= true;                                  // Выбор типа вывода результата: 0 (false) - через память (указатель в outputResult, размер в outputResultSize)

  tmpPeriodFlush:= 1;

  iTargetWorkTime:= 1000;

//--- Если выбран режим вывода в файл, то проверим правильность имени выходного файла
  case inputParam4 of
    true:
     begin
       if TPath.GetFileName(inputParam3) <> '' then
        if TPath.GetDirectoryName(inputParam3) <> '' then
          tmpStreamWriter:= TFile.CreateText(inputParam3)
        else
     end;

    false:   //--- Настройка памяти для выгрузки результата
      begin

      end;
    else
  end;

  tmpPeriodFlush:= 1;

  for tmpTargetFile in TDirectory.GetFiles(inputParam2, inputParam1,
                TSearchOption.soAllDirectories) do
  begin
    tmpStreamWriter.WriteLine(tmpTargetFile + ', ');
    if (GetTickCount() - iProcedureWorkTime) >=  iTargetWorkTime then
     begin
      tmpStreamWriter.Flush;
      iProcedureWorkTime:= GetTickCount(); // запоминаем текущее значение тиков
     end;
  end;
 tmpStreamWriter.Close;

end;

procedure TformMain.Button2Click(Sender: TObject);
var
  tmp_hDllTask: THandle;
  tmpCallingDLL1Proc2: TCallingDLL1Proc2;
  tmpBSTR, tmpWString: WideString; //--- Для обмена строками с Dll только BSTR (или в Делфи WideString)
  i, tmpInfoRecordSize, tmpInfoRecordCount: Byte;
  inputParam1, inputParam2, inputParam3: WideString;
  inputParam4: BOOL;
  tmpResult: Pointer;
  tmpResultSize: DWORD;
  tmpDllFileName: string;

begin
  inputParam1:= '*.txt'; //Маска
  inputParam2:= 'C:\Users\user\AppData\Roaming\Primer_MT_3'; // Директория старта поиска
  inputParam3:= 'D:\Install\ResultSearchByMask1.txt'; // Имя файла для записи результата, если inputParam4 - true
  inputParam4:= true;                                  // Выбор типа вывода результата: 0 (false) - через память (указатель в outputResult, размер в outputResultSize)
  tmpDllFileName:= 'D:\DelphiProj\TestCode_ForHHRU_4_DLL1\Win32\Debug\PrimerDll_1_MT_4.dll';
try

if  Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
   tmp_hDllTask:= LoadLibrary(PChar(tmpDllFileName)); //, 0, LOAD_LIBRARY_AS_DATAFILE{DONT_RESOLVE_DLL_REFERENCES});
  end
  else
   tmp_hDllTask:= LoadLibrary(PChar(tmpDllFileName)); //, 0, 0{DONT_RESOLVE_DLL_REFERENCES});

 @tmpCallingDLL1Proc2:= GetProcAddress(tmp_hDllTask, 'FileFinderByMask');
 if @tmpCallingDLL1Proc2 <> nil then
   tmpCallingDLL1Proc2(inputParam1, inputParam2, inputParam3, inputParam4, 1000, tmpResult, tmpResultSize);

finally
  FreeLibrary(tmp_hDllTask);
end;

end;

procedure TformMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: word;
begin
try
 formInfo:= TformInfo.Create(Application);
 formInfo.lMessageInfo.Caption:= sWaitForAppClosing;
 formInfo.Show;
 Application.ProcessMessages;

 if Assigned(formTools) then
 begin
  formTools.Close;
  formTools.Free;
 end;

 if Assigned(formTools) then
 begin
 formInfo.Close;
 formInfo.Free;
 end;
finally
 FinalizeLibraryes;
end;
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
