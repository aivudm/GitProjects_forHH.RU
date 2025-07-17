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
    memInfoTread: TMemo;
    memInfo_2: TMemo;
    lbThreadList: TListBox;
    Label1: TLabel;
    bThreadPause: TButton;
    bStop: TButton;
    sbMain: TStatusBar;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    N1: TMenuItem;
    procedure miToolsClick(Sender: TObject);
    procedure miExitClick(Sender: TObject);
    procedure lbThreadListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure bThreadPauseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbThreadListClick(Sender: TObject);
    procedure lbThreadListKeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
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


function AddNewItemToThreadList(NextItem: string): integer;
function AddNewItemToMemo(NextItem: string): integer;

implementation
uses unVariables, unTools, unUtils, unUtilCommon, unTasks, unInfoWindow;

{$R *.dfm}

procedure TformMain.WMCopyData(var MessageData: TWMCopyData);
var
  tmpWord: word;
  tmpString: string;
begin
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

procedure TformMain.bThreadPauseClick(Sender: TObject);
var
  iTaskNum: word;
begin
 iTaskNum:= lbThreadList.ItemIndex;
 if not ((iTaskNum > -1) and (iTaskNum <= lbThreadList.Count)) then
 begin
  exit;
 end;

 if (TaskList[iTaskNum].TaskCore.TaskState = tsActive) then
  begin
   TaskList[iTaskNum].TaskCore.SetTaskState(tsPause);
   TaskList[iTaskNum].TaskCore.Suspended:= true;
  end
 else
  begin
   TaskList[iTaskNum].TaskCore.SetTaskState(tsActive);
//   TaskList[iTaskNum].Suspended:= false;;
   TaskList[iTaskNum].TaskCore.Suspended:= false;;

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


procedure GetItemsFromString(inputSourceBSTR: WideString; var outputStringItems: TArray_WideString; var outputMaskCount: word);
begin
 outputMaskCount:= 0;
 if pos(wsBeginMask, inputSourceBSTR, 1) > 0 then
 begin
  while pos(wsBeginMask, inputSourceBSTR, 1) > 0 do
   begin
//--- Проверка на правильное начало маски, если нет, то отбросим всё что до начала маски расширения
    if pos(wsBeginMask, inputSourceBSTR, 1) > 0 then
      delete(inputSourceBSTR, 1, length(GetSubStr(inputSourceBSTR, 1, pos(wsBeginMask, inputSourceBSTR)))); //--- удалим всё, что до '*.' - ищем только расширения

    if pos(ItemDelemiter, inputSourceBSTR, 1) > 0 then
      outputStringItems[outputMaskCount]:= Copy(inputSourceBSTR, 1, pos(ItemDelemiter, inputSourceBSTR, 1) - 1)
    else // осталась последняя маска и без завершающего разделителя (но мы её не бросим!)
      outputStringItems[outputMaskCount]:= Copy(inputSourceBSTR, 1, length(inputSourceBSTR));

    delete(inputSourceBSTR, 1, Length(outputStringItems[outputMaskCount]) + 1); //--- удалим прочтённую запись и разделитель
    inc(outputMaskCount);
   end;
 end;
end;



procedure TformMain.Button1Click(Sender: TObject);
var
  tmpTargetFile: WideString;
  tmpStreamWriter: TStreamWriter;
  inputParam1, inputParam2, inputParam3: WideString;
  inputParam4: BOOL;
var
  inputParam5: DWORD;
  tmpMaskItems: TArray_WideString;
  tmpMaskCount: word;
  tmpEquealsCount: word;
  tmpInt, tmpInt1: word;
  tmpBool: Boolean;


  tmpPeriodFlush: Cardinal;
  iProcedureWorkTime: DWORD;
  iTargetWorkTime: WORD;

begin
  inputParam1:= 'edf*.txt;*.txt1'; //Маска
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

//--- Извлечение элементов-масок из входящей строки (inputParam1)
   GetItemsFromString(inputParam1, tmpMaskItems, tmpMaskCount);
//--- Цикл перебора и сравнения с масками всех файлов в целевой директории
   tmpEquealsCount:= 0; //--- Счётчик совпадений

       for tmpTargetFile in TDirectory.GetFiles(inputParam2, wsAllMask,
            TSearchOption.soAllDirectories) do
        begin
         tmpBool:= false;
         for tmpInt:= 0 to tmpMaskCount - 1 do
         begin
          if (TPath.GetExtension(tmpTargetFile) = tmpMaskItems[tmpInt]) and (not tmpBool) then
          begin
           inc(tmpEquealsCount);
           tmpBool:= true;
           if tmpBool then
           begin
            tmpStreamWriter.WriteLine(tmpTargetFile + ', ');
            if (GetTickCount() - iProcedureWorkTime) >=  inputParam5 then
             begin
              tmpStreamWriter.Flush;
              iProcedureWorkTime:= GetTickCount(); // запоминаем текущее значение тиков
             end;
           end;
          end;

         end;
        end;

 tmpStreamWriter.WriteLine('Всего найдено совпадений: ' + IntToStr(tmpEquealsCount));
 tmpStreamWriter.Close;

end;











procedure TformMain.Button2Click(Sender: TObject);
var
  tmp_hDllTask: THandle;
  tmpCallingDLL1Proc1: TCallingDLL1Proc1;
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

 @tmpCallingDLL1Proc1:= GetProcAddress(tmp_hDllTask, 'FileFinderByMask');
 if @tmpCallingDLL1Proc1 <> nil then
   tmpCallingDLL1Proc1(inputParam1, inputParam2, inputParam3, inputParam4, 1000, tmpResult, tmpResultSize);

finally
  FreeLibrary(tmp_hDllTask);
end;

end;

procedure TformMain.Button3Click(Sender: TObject);
var
  tmp_hTaskLibrary: THandle;  //--- он же HMODULE
  tmpDLLAPIProc: TDLLAPIProc;
  tmpBSTR, tmpWString: WideString; //--- Для обмена строками с Dll только BSTR (или в Делфи WideString)
  i, tmpInfoRecordSize, tmpInfoRecordCount: Byte;
  tmpIntrfDllAPI: ILibraryAPI;
  tmpIntrfTaskSource: ITaskSource;
//  tmpIInterface: IInterface;
begin
//-------------------------------------------------------------------------------------------------------
//--- Отработка
//-------------------------------------------------------------------------------------------------------
try
 tmp_hTaskLibrary:= LoadLibrary('D:\DelphiProj\TestCode_ForHHRU_4_DLL1\Win32\Debug\PrimerDll_1_MT_4.dll');

 @tmpDLLAPIProc:= GetProcAddress(tmp_hTaskLibrary, DllProcName_LibraryInfo);
 Win32Check(Assigned(tmpDLLAPIProc));

//--- Вызов интерфейса библиотеки API DLL
 tmpDLLAPIProc(ILibraryAPI, tmpIntrfDllAPI);

// tmpIInterface.QueryInterface(TGUID(ITaskSource), tmpTaskSource);

 tmpIntrfDllAPI.InitDLL;
 tmpIntrfTaskSource:= tmpIntrfDllAPI.NewTaskSource(0);
 tmpIntrfTaskSource.TaskProcedure(0);
 tmpIntrfDllAPI.FinalizeDLL;

// tmpIntrfDllAPI.GetFormParams;



 if intrfDllAPI = nil then
  intrfDllAPI:= tmpIntrfDllAPI;

 tmpIntrfDllAPI:= nil;
finally
 if tmpIntrfTaskSource <> nil then
  tmpIntrfTaskSource:= nil;

 if tmpintrfDllAPI <> nil then
 begin
  tmpintrfDllAPI:= nil;
 end;
 if tmp_hTaskLibrary <> 0 then
//  FreeLibrary(tmp_hTaskLibrary);
end;

end;

procedure TformMain.Button4Click(Sender: TObject);
var
  CDS: TCopyDataStruct;
  tmpString: string;
begin
  tmpString:= 'wsdlkjfhnowpqnfowenfowenfowenfowpenfwpoenfowpnfpoqnfponef';
  //Устанавливаем тип команды
  CDS.dwData := CMD_SetMemoLine;
  //Устанавливаем длину передаваемых данных
  CDS.cbData := Length(tmpString) + 1;
  //Выделяем память буфера для передачи данных
  GetMem(CDS.lpData, CDS.cbData);
  try
    //Копируем данные в буфер
    StrPCopy(CDS.lpData, AnsiString(tmpString));
    //Отсылаем сообщение в окно главного модуля
    PostThreadMessage(FindWindow(nil, PWChar(formMain.Caption)),
                  WM_COPYDATA, Handle, Integer(@CDS));
    SendMessage(FindWindow(nil, PWChar(formMain.Caption)),
                  WM_COPYDATA, Handle, Integer(@CDS));
  finally
    //Высвобождаем буфер
    FreeMem(CDS.lpData, CDS.cbData);
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
