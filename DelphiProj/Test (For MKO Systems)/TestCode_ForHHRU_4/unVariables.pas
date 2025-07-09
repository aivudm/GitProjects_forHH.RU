unit unVariables;

interface
uses Vcl.Forms, System.Contnrs, Vcl.StdCtrls, System.Classes, Winapi.Windows, Winapi.Messages, IOUtils, Dialogs,
    System.SysUtils, System.Generics.Collections;

type
  TCallingDLLProc = procedure (var inputParam1: integer; var fsResult: TStreamWriter; iTargetWorkTime: integer); stdcall;
  TCallingDLLProc1 = procedure (var outputParam: string); stdcall;

type
  TExchangeType = (etSynchronize = 0, etClientServerUDP = 1);

  TLibraryTaskInfo = class (TObject)
   private
    FTaskTemplateName: TArray<string>; //--- заполняется после подключения Dll
    FTaskDllProcName: TArray<string>; //--- заполняется после подключения Dll

   protected

   public
    property TaskTemplateName: TArray<string> read FTaskTemplateName write FTaskTemplateName;
    property TaskDllProcName: TArray<string> read FTaskDllProcName write FTaskDllProcName;

  end;

  TLibraryList = TArray<TLibraryTaskInfo>;   //--- Применён из-за встроенного менеджера памяти

{  TLibraryList = class (TObjectList)   //--- Применён из-за встроенного менеджера памяти
   private
    function GetItem(Index: integer): TLibraryTaskInfo;
    procedure SetItem(Index: integer; const Value: TLibraryTaskInfo);
   public
    property Items[Index: integer]: TLibraryTaskInfo read GetItem write SetItem; default;
  end;
}

  TOutInfo_ForViewing = record
    hWndViewObject: hWnd;
    IndexInViewComponent: integer;
    TextForViewComponent: ansistring;
  end;

  TFileItem = class (TObject)
   private
    FFileName: string;
    FTaskNum: word;

   protected
    FFileId: THandle;

   public
    FStreamWriter: TStreamWriter;
    constructor Create(TaskItemNum: word); overload;
    procedure SetFileName(FileItemName: string = '');
    procedure SetTaskNum(TaskNum: word);

  published
    property FileName: string read FFileName;
    property TaskNum: word read FTaskNum;
    property StreamWriter: TStreamWriter read FStreamWriter;

  end;


  //------------------------------------------------------------------------------
  TFileList = class (TObjectList)   //--- Применён из-за встроенного менеджера памяти
   private
    function GetItem(Index: integer): TFileItem;
    procedure SetItem(Index: integer; const Value: TFileItem);
   public
    property Items[Index: integer]: TFileItem read GetItem write SetItem; default;
  end;



var
//  bFormToolsIsActive: boolean = false;
  ExchangeType: TExchangeType = etSynchronize; //--- Глобальная переменная - будет обращение из потоков
  iTreadCount: byte= 0;
  aResultArraySimple: TArray<Int64>;
  FileList: TFileList; //StreamWriter: TStreamWriter;
//  aTaskNameArray: array of string; // = ['Пустой цикл', 'Расчёт числа Пи', 'Определение простых чисел']; //--- При инициализации задачи нумерация будет с номера =

  CallingDLLProc: TCallingDLLProc;
  hDllTask: THandle;
  sWorkDirectory: string = '';
  sFileNameDefault: string = '';
  sFileExtensionDefault: string = '.txt';
  LibraryTaskInfo: TLibraryTaskInfo;
  LibraryTaskInfoList: TObjectList<TLibraryTaskInfo>;

procedure InitializeVariables;
procedure DeinitializeVariables;

implementation
uses unConst, unTasks, unUtils;

procedure InitializeVariables;
begin
end;

procedure DeinitializeVariables;
begin
 if TaskList <> nil then TaskList.Free;
 if CriticalSection <> nil then CriticalSection.Free;

end;

//------------------ TFileItem -------------------------------------------------
constructor TFileItem.Create(TaskItemNum: word);
var
  tmpProc: TTaskProcedure;
begin
 FFileName:= sWorkDirectory + '/' + sFileNameDefault + '_' + IntToStr(TaskItemNum) + sFileExtensionDefault;
 inherited Create(); //, fmCreate or fmOpenWrite);
 FStreamWriter:= TFile.CreateText(FFileName);
 FTaskNum:= TaskItemNum;
// TaskList[TaskItemNum].SetStreamWriter(self);
end;

procedure TFileItem.SetFileName(FileItemName: string = '');
begin
 if FileItemName = '' then
  FFileName:= sFileNameDefault
 else
  FFileName:= FileItemName;
end;

procedure TFileItem.SetTaskNum(TaskNum: word);
begin
  FTaskNum:= TaskNum;
end;

//------------------------------------------------------------------------------
//---------- Данные для TFileList ----------------------------------------------
//------------------------------------------------------------------------------
function TFileList.GetItem(Index: integer): TFileItem;
begin
 Result:= TFileItem(inherited GetItem(Index));
end;

procedure TFileList.SetItem(Index: integer; const Value: TFileItem);
begin
 inherited SetItem(Index, Value);
end;
//------------------------------------------------------------------------------




initialization
//if IsTaskDllAttached() = -1 then
// Showmessage('Не удаётся подключить библиотеку с прототипами задач');

//---- Имя текущей директории приложения получаем из TDirectory.GetCurrentDirectory;
sWorkDirectory:= GetWorkingDirectoryName();


sFileNameDefault:= Copy(ExtractFileName(Application.ExeName), 1, Pos('.', ExtractFileName(Application.ExeName)) - 1);

LibraryTaskInfoList:= TObjectList<TLibraryTaskInfo>.Create;
FileList:= TFileList.Create();

//StreamWriter:= TFile.CreateText('d:\Task_3_SimpleNumbers.txt');

finalization
LibraryTaskInfoList.Free;
//StreamWriter.Free;

end.
