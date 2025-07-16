unit unTools;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.StdCtrls, IOUtils;

type
  TformTools = class(TForm)
    MainMenu1: TMainMenu;
    mFile: TMenuItem;
    miExit: TMenuItem;
    gbThread: TGroupBox;
    btnNewThread: TButton;
    lbTemplateTaskList: TListBox;
    gbRxchangeType: TGroupBox;
    rbMessage_WMCoptData: TRadioButton;
    rbClientServer_udp: TRadioButton;
    gbLibraryList: TGroupBox;
    Button1: TButton;
    lbLibraryList: TListBox;
    odGetLibrary: TOpenDialog;
    procedure miExitClick(Sender: TObject);
    procedure tmCheckThreadReportTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnNewThreadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbMessage_WMCoptDataClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure lbLibraryListClick(Sender: TObject);
  private
    { Private declarations }
    procedure WMWINDOWPOSCHANGING(var Msg: TWMWINDOWPOSCHANGING); message WM_WINDOWPOSCHANGING;
  public
    { Public declarations }
  end;

var
  formTools: TformTools;


implementation

{$R *.dfm}
uses unMain, unConst, unVariables, unTasks, unDM, unUtils;

procedure TformTools.WMWindowPosChanging(var Msg: TWMWindowPosChanging);
begin
 inherited;
 if not Application.Terminated  then
 begin
  Msg.WindowPos.x:= formMain.Left + formMain.Width;
  Msg.WindowPos.y:= formMain.Top;
 end;

end;

procedure TformTools.btnNewThreadClick(Sender: TObject);
 var
    iTaskListNum: word;
    iThreadNum: integer;
    pTaskSource: Pointer;
    tmpIntrfDllAPI: ILibraryAPI;
    tmpIntrfTaskSource: ITaskSource;
begin
 try
//--- �������� �������� ���������� �� ������� � ������� ���� �������� ���������� ����


  //--- ���������� ������ (�� ������ ��������� �����) ������ ������
  //--- 1. ������ ����� ������ "������", ����� �������� ��� � ������ �������� ���� "������ �����"
  //--- ���������� ����� ���������� � ������� ��������� � ���������� ����� ������� ������ ����� �������������
  //--- �� ���������� ������� � ���������� ����������� lbLibraryList � lbTemplateTaskList
  iTaskListNum:= TaskList.Add(TTaskItem.Create(lbLibraryList.ItemIndex, lbTemplateTaskList.ItemIndex, tsNotDefined));
  //--- ������ ������ ������ � ������� ������ �������� ����� � ������ TaskItem
  TaskList[iTaskListNum].SetTaskNum(iTaskListNum);

  //--- 2. ������ ����� ������ "�������� ������", ����� �������� ��� � ������ �������� ���� "������ ���������� �����" - ����� ���������� ������� �������, ��� ��� ��� ����� ����������� � �������
  tmpIntrfDllAPI:= LibraryList[lbLibraryList.ItemIndex].LibraryAPI;
  tmpIntrfTaskSource:= LibraryList[lbLibraryList.ItemIndex].LibraryAPI.NewTaskSource(lbTemplateTaskList.ItemIndex);
  TaskList[iTaskListNum].SetTaskSource(LibraryList[lbLibraryList.ItemIndex].LibraryAPI.NewTaskSource(lbTemplateTaskList.ItemIndex));
  tmpIntrfDllAPI:= nil;
  tmpIntrfTaskSource:= nil;
  //--- 3. �������� ������� ��� ����������� ���������� �� ����� (�������)
  TaskList[iTaskListNum].HandleWinForView:= formMain.memInfoTread.Handle;
  TaskList[iTaskListNum].LineIndex_ForView:= formMain.memInfoTread.Lines.Add('�������� ������ �� ������...');
//------------------------------------------------------------------------------
//  TaskList[iTaskListNum].Run; - ������ ��� ���������, ��� ��� � ����� ������ ����� ����� ��������. ����� ����� � ����������� �� ������� FPauseEvent: TEvent;
//------------------------------------------------------------------------------

  //--- 4. ��������� "����� �����" � �������� ������� (���������)
  AddNewItemToThreadList(format(sHeaderThreadInfo + '%3d: %s',
                                                                    [iTaskListNum,
                                                                    TaskList[iTaskListNum].TaskName]));   // ��� ����� ���������� ���������� ������ (� 1-��)

  //--- ����� ���������� ���� �������� ����������� ������ ��������� - tsActive
  TaskList[iTaskListNum].TaskState:= tsActive;

 finally

 end;
end;

procedure TformTools.Button1Click(Sender: TObject);
var
 tmpItem, tmpItem1, tmpLibraryNum: word;
 tmpLibraryTask: TLibraryTask;

begin
 if TFile.Exists(sWorkDirectory) then
  odGetLibrary.InitialDir:= sWorkDirectory;
 if Not odGetLibrary.Execute(formTools.Handle) then Exit;

 lbLibraryList.Clear;

 for tmpItem:= 0 to odGetLibrary.Files.Count-1 do
 begin

//--- �������� ������� ���������
//--- ������� ��: ����� ������� ������ � ������� ������ � ����������
//--- ������ ������������ ������� ������ ��� ��������� ������ ����������� �����
//--- ���������� ����� ��������� DllAPI
  tmpLibraryNum:= LibraryList.Add(TLibraryTask.Create);
  tmpLibraryTask:= LibraryList[tmpLibraryNum];
 //--- �� ������ ���������� � ������ ��������� ������� � ������������ � ������ ������������� � ��� �������
  GetLibraryInfo(odGetLibrary.Files.Strings[tmpItem], tmpLibraryTask);
 //--- ���� ������������ �� �������� �� Dll, ������ Dll "�� ����", ������ ���������� �
  if tmpLibraryTask.LibraryName <> '' then
   begin
 //--- ������� ���������� � ������ ��������� ��������� � ���������� ���������� (ListBox)
    lbLibraryList.Items.Add(tmpLibraryTask.LibraryName);

   end;
 end;

 lbLibraryList.ItemIndex:= 0;
 lbLibraryList.OnClick(Sender);
end;

procedure TformTools.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: word;
begin
 if TaskList.Count <1 then exit;
 
 for i:=0 to (TaskList.Count - 1) do
 begin
  if TaskList[i].GetTaskState = tsPause then
   TaskList[i].Suspended:= false;

  TaskList[i].SetTaskState(tsTerminate);
//  while not TaskList[i].IsTerminated do
//   sleep(300); //--- ��� ���������� ������� ������
 end;

 formMain.miTools.Enabled:= true;

end;

procedure TformTools.FormCreate(Sender: TObject);
begin
// TaskInitialize;
end;

procedure TformTools.FormShow(Sender: TObject);
begin
 lbLibraryListClick(Sender);
end;

procedure TformTools.lbLibraryListClick(Sender: TObject);
var
  tmpItem: integer;
  tmpTaskTemplateIndex: integer;
begin
//--- ������� ������ ��������� � ���������� ����� � ���������� ��������� (ListBox)
  lbTemplateTaskList.Clear;

  tmpTaskTemplateIndex:= lbLibraryList.ItemIndex;
  if tmpTaskTemplateIndex < 0 then exit;

  for tmpItem:= 0 to LibraryList[tmpTaskTemplateIndex].TaskCount do
  begin
   lbTemplateTaskList.AddItem(LibraryList[tmpTaskTemplateIndex].TaskTemplateName[tmpItem], Sender);
  end;
end;

procedure TformTools.miExitClick(Sender: TObject);
begin
 Close;
end;

procedure TformTools.rbMessage_WMCoptDataClick(Sender: TObject);
begin
  if self.rbMessage_WMCoptData.Checked then
   begin
    DM.PrepareServerSetting(false);
    ModulsExchangeType:= etMessage_WMCopyData;
    formMain.sbMain.Panels[0].Text:= '�����: Message WM_CopyData';
   end;

  if self.rbClientServer_udp.Checked then
   begin
    ModulsExchangeType:= etClientServerUDP;
    DM.PrepareServerSetting(true);
    //--- ���������� �� ������ ��� ��������� � DM.PrepareServerSetting
   end;


end;

procedure TformTools.tmCheckThreadReportTimer(Sender: TObject);
var
  i: Integer;
  tmpTaskItem: TTaskItem;
begin
 exit;
 for i:=0 to (TaskList.Count - 1) do
 begin
  if TaskList[i].GetTaskState = tsActive  then
   TaskList[i].CheckReportTime(TaskList[i]);
 end;
end;


//--- ������������ ��� ������� -------------------------------------------------



end.
