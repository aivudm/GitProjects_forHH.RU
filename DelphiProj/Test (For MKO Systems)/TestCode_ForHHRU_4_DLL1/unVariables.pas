unit unVariables;

interface
uses Windows, SysUtils, Classes, IOUtils, ActiveX, ComObj, Vcl.AxCtrls, System.Diagnostics, System.Contnrs, Dialogs,
     unTaskSource, unEditInputParams_Task1, unEditInputParams_Task2;

type
  BSTR = WideString;
  LPWSTR = PWideChar;
  UnicodeString = WideString;
  NativeInt = Integer;
  NativeUInt = Cardinal;
  DWORD = Cardinal;
  UInt = Cardinal;

type

//------------------------------------------------------------------------------
  TTaskState = (tsNotDefined = -1 {���� �� ���������� - ��� �������, �� ������� ������� �������� ���� �������� ������},
                tsActive = 0, tsTerminate = 1, tsPause = 2, tsReportPause = 3);
//------------------------------------------------------------------------------
//--- FileFinderByMask
//  TCallingDLL1Proc1 = function (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; iTargetWorkTime: WORD; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT; stdcall;

//------------------------------------------------------------------------------
  IBSTRItems = interface (IInterface)
  ['{7988654F-59FB-401F-9E4C-972FF343C66B}']
    function GetCount: Integer; safecall;
    function GetString(const Index: Integer): BSTR; safecall;

    property Count: Integer read GetCount;
    property Strings[const Index: Integer]: BSTR read GetString; default;
  end;

//------------------------------------------------------------------------------
  TBSTRItems = class(TInterfacedObject, IBSTRItems)
  strict private
    FBSTRItems: array of WideString;
  strict protected
    function GetCount: Integer; safecall;
    function GetString(const Index: Integer): BSTR; safecall;
  public
    constructor Create(const inputBSTRItems: array of WideString); reintroduce;
//    constructor Create(const AStrings: array of BSTR); reintroduce;
  end;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
  ITaskSource = interface (IInterface)
  ['{6D0957A0-EADE-4770-B448-EEE0D92F84CF}']
   procedure TaskProcedure(TaskLibraryIndex: word); safecall;
   function GetTaskLibraryIndex: word;
   function GetTask1_Result: TTask1_Result; safecall;
   function GetTask2_Result(ResultIndex: integer): TTask2_Result; safecall;
   function GetTask2_TotalResult: DWORD; safecall;
   function GetTask2_ResultBuffer: Pointer; safecall;
   procedure SetTaskMainModuleIndex(inputTaskMainModuleIndex: WORD);
   property TaskLibraryIndex: WORD read GetTaskLibraryIndex;
   property Task1_Result: TTask1_Result read GetTask1_Result;
   property Task2_Results[ResultIndex: integer]: TTask2_Result read GetTask2_Result; // write SetTask2_Result;
   property Task2_TotalResult: DWORD read GetTask2_TotalResult;
   property TaskMainModuleIndex: WORD write SetTaskMainModuleIndex;
  end;

//------------------------------------------------------------------------------
  TTaskSource = class (TInterfacedObject, ITaskSource)
   private
    FTaskLibraryIndex: word;
    FTaskMainModuleIndex: word;
    FTaskSourceList: word;
    FTaskState: TTaskState;
    FResultBuffer: Pointer;
    FStopWatch: TStopWatch;
   protected
    FTask1_Result: TTask1_Result;
    procedure TaskProcedure(TaskLibraryIndex: word); safecall;
    function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; out outTask1_Result: TTask1_Result): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
//    function Task2_FindInFilesByPattern (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; out outTask2_Result: TTask2_Results): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
    function Task2_FindInFilesByPattern (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; var inoutTask2_Results: TTask2_Results): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;

   public
    FTask2_TotalResult: DWORD;
    FTask2_Results: TTask2_Results;
    constructor Create(TaskLibraryIndex: word);
    function GetTaskLibraryIndex: word;
    function GetTask1_Result: TTask1_Result; safecall;
    function GetTask2_Result(ResultIndex: integer): TTask2_Result; safecall;
    function GetTask2_TotalResult: DWORD; safecall;
    function GetTask2_ResultBuffer: Pointer; safecall;
    procedure SetTaskMainModuleIndex(inputTaskMainModuleIndex: WORD);
    property TaskLibraryIndex: WORD read FTaskLibraryIndex;
    property TaskMainModuleIndex: WORD write FTaskMainModuleIndex;
    property TaskState: TTaskState read FTaskState write FTaskState;
    property StopWatch: TStopWatch read FStopWatch write FStopWatch;
    property Task1_Result: TTask1_Result read FTask1_Result write FTask1_Result;
    property Task2_Results[ResultIndex: integer]: TTask2_Result read GetTask2_Result; // write SetTask2_Result;
    property Task2_TotalResult: DWORD read GetTask2_TotalResult;
  end;


//  TTaskSourceList = TArray<TTaskSource>;
//------------------------------------------------------------------------------
   TTaskSourceList = class (TObjectList)
   private
    function GetItem(Index: integer): TTaskSource;
    procedure SetItem(Index: integer; const Value: TTaskSource);
   public
    property Items[Index: integer]: TTaskSource read GetItem write SetItem; default;
  end;

//------------------------------------------------------------------------------



var
  LoadLibraryEx: function(lpFileName: PChar; Reserved: THandle; dwFlags: DWORD): HMODULE; stdcall;
  TaskSourceList: TTaskSourceList; //--- ������ ��� �������� ���� ��������� �����

//  SetDllDirectory: function(lpPathName: PChar): BOOL; stdcall;
//  SetSearchPathMode: function(Flags: DWORD): BOOL; stdcall;
//  AddDllDirectory: function(Path: PWideChar): Pointer; stdcall;
//  RemoveDllDirectory: function(Cookie: Pointer): BOOL; stdcall;
//  SetDefaultDllDirectories: function(DirectoryFlags: DWORD): BOOL; stdcall;





implementation
uses unLibrary1API;


{ TStrings }
constructor TBSTRItems.Create(const inputBSTRItems: array of WideString);
var
  i: integer;
begin
  inherited Create;

  SetLength(FBSTRItems, length(inputBSTRItems));
  for i := 0 to high(FBSTRItems) do
    FBSTRItems[i] := inputBSTRItems[i];
end;

function TBSTRItems.GetCount: Integer;
begin
  Result := length(FBSTRItems);
end;

function TBSTRItems.GetString(const Index: Integer): BSTR;
begin
  Result := FBSTRItems[Index];
end;
//------------------------------------------------------------------------------
//---------- ������ ��� TTaskSourceList ----------------------------------------
//------------------------------------------------------------------------------

function TTaskSourceList.GetItem(Index: integer): TTaskSource;
begin
 Result:= TTaskSource(inherited GetItem(Index));
end;

procedure TTaskSourceList.SetItem(Index: integer; const Value: TTaskSource);
begin
 inherited SetItem(Index, Value);
end;


//------------------------------------------------------------------------------
//---------- ������ ��� TTaskSource... -----------------------------------------
//------------------------------------------------------------------------------

constructor TTaskSource.Create(TaskLibraryIndex: word);
begin
 inherited Create();
   FTaskLibraryIndex:= TaskLibraryIndex;
   FTaskSourceList:= TaskSourceList.Add(self);
end;

//------------------------------------------------------------------------------
function TTaskSource.GetTaskLibraryIndex: WORD;
begin
  Result:= self.FTaskLibraryIndex;
end;

//------------------------------------------------------------------------------
procedure TTaskSource.SetTaskMainModuleIndex(inputTaskMainModuleIndex: WORD);
begin
  FTaskMainModuleIndex:= inputTaskMainModuleIndex;
end;

//------------------------------------------------------------------------------
function TTaskSource.GetTask1_Result: TTask1_Result; safecall;
begin
  Result:= FTask1_Result;
end;

//------------------------------------------------------------------------------

function TTaskSource.GetTask2_Result(ResultIndex: integer): TTask2_Result; safecall;
begin
//  if sizeof(FTask2_Results) > ResultIndex then
  Result:= FTask2_Results[ResultIndex];
end;

//------------------------------------------------------------------------------

function TTaskSource.GetTask2_TotalResult: DWORD; safecall;
var
  tmpWord: word;
begin
  Result:= 0;
//--- ��������� ���������� �� ���� �������� � ����� ���������
  if length(FTask2_Results) > 0 then
  begin
   FTask2_TotalResult:= 0;
   for tmpWord:= 0 to (length(FTask2_Results) - 1) do
     FTask2_TotalResult:= FTask2_TotalResult + FTask2_Results[tmpWord].dwEqualsCount;
   Result:= FTask2_TotalResult;
  end;
end;

//------------------------------------------------------------------------------

function TTaskSource.GetTask2_ResultBuffer: Pointer; safecall;
begin
try
finally
  Result:= FResultBuffer;
end;
end;

//------------------------------------------------------------------------------
procedure TTaskSource.TaskProcedure(TaskLibraryIndex: word);
var
  tmpWord: word;
  tmpStr: WideString;
  tmpInputForm_Task1: TformEditParams_Task1;
  tmpInputForm_Task2: TformEditParams_Task2;
  tmpArray_WideString: TArray_WideString;
  tmpTask1_Parameters: TTask1_Parameters;
  tmpTask2_Parameters: TTask2_Parameters;
 begin
try
 case self.FTaskLibraryIndex {TaskLibraryIndex} of
   0: //--- Task1_FileFinderByMask
   begin
//--- ����������� ������ ��� ������� � ��������� - ������� ��������� ��� ������
    CriticalSection.Enter; //--- ����� �� ����������� ������ ����� � ������ ������

    tmpInputForm_Task1:= TformEditParams_Task1.Create(nil);
    tmpInputForm_Task1.ShowModal;
//    FreeAndNil(tmpInputForm_Task1);
    tmpInputForm_Task1.Free;

    //--- �������� inputParam5 (TaskMainModuleIndex), ���������� ����� API
    Task1_Parameters.inputParam5:= self.FTaskMainModuleIndex;
//--- ����� ��������� ������� ���������� ������ ������ �� ����������
 {   ShowMessage('����� ������ � Task1_FileFinderByMask'
                + #13#10 + 'inputParam1 = ' + WideString(Task1_Parameters.inputParam1)
                + #13#10 + 'inputParam2 = ' + WideString(Task1_Parameters.inputParam2)
                + #13#10 + 'inputParam3 = ' + WideString(Task1_Parameters.inputParam3)
                + #13#10 + 'inputParam5 = ' + IntToStr(FTaskMainModuleIndex)); // Task1_Parameters.inputParam5
}
    tmpTask1_Parameters.inputParam1:= Task1_Parameters.inputParam1;
    tmpTask1_Parameters.inputParam2:= Task1_Parameters.inputParam2;
    tmpTask1_Parameters.inputParam3:= Task1_Parameters.inputParam3;
    tmpTask1_Parameters.inputParam4:= Task1_Parameters.inputParam4;
    tmpTask1_Parameters.inputParam5:= Task1_Parameters.inputParam5;
    CriticalSection.Leave;

    self.Task1_FileFinderByMask(WideString(tmpTask1_Parameters.inputParam1), WideString(tmpTask1_Parameters.inputParam2),
                                WideString(tmpTask1_Parameters.inputParam3), tmpTask1_Parameters.inputParam4,
                                FTaskMainModuleIndex {Task1_Parameters.inputParam4}, self.FTask1_Result); //, nil, 0);
   end;



//-------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------ ������ �2 --------------------------------------------------------------------------------------
//-------------------------------------------------------------------------------------------------------------------------------------


   1: //--- Task2_FindInFilesByPattern
   begin
//--- ����������� ������ ��� ������� � ��������� - ������� ��������� ��� ������
    CriticalSection.Enter; //--- ����� �� ����������� ������ ����� � ������ ������

    tmpInputForm_Task2:= TformEditParams_Task2.Create(nil);
    tmpInputForm_Task2.ShowModal;
    FreeAndNil(tmpInputForm_Task2);
//    tmpInputForm_Task2.Free;

    //--- �������� inputParam5 (TaskMainModuleIndex), ���������� ����� API
//    Task2_Parameters.inputParam5:= self.FTaskMainModuleIndex;
//--- ����� ��������� ������� ���������� ������ ������ �� ����������
{    ShowMessage('����� ������ � Task2_FindInFilesByPattern'
                + #13#10 + 'inputParam1 = ' + WideString(Task2_Parameters.inputParam1)
                + #13#10 + 'inputParam2 = ' + WideString(Task2_Parameters.inputParam2)
                + #13#10 + 'inputParam3 = ' + WideString(Task2_Parameters.inputParam3)
                + #13#10 + 'inputParam5 = ' + IntToStr(FTaskMainModuleIndex)); // Task1_Parameters.inputParam5
}
 //--- ��������� ������� ��������� ��������� �������� ���������� ��������
//    GetPatternsFromString(WideString(Task2_Parameters.inputParam1), tmpArray_WideString, tmpWord);
//    setlength(self.FTask2_Results, tmpWord);

    self.FTask2_TotalResult:= 0;
    tmpTask2_Parameters.inputParam1:= Task2_Parameters.inputParam1;
    tmpTask2_Parameters.inputParam2:= Task2_Parameters.inputParam2;
    tmpTask2_Parameters.inputParam3:= Task2_Parameters.inputParam3;
    tmpTask2_Parameters.inputParam4:= Task2_Parameters.inputParam4;
    tmpTask2_Parameters.inputParam5:= Task2_Parameters.inputParam5;
    CriticalSection.Leave;

//--- ���� ������ ����� �������� ���������� ����� ������, �� ������� ������ (������� ���. ����� = 4096 (�)
//--- �� ���� ���������� ������ ����������� ������, �� ���� ����������, ����� ��������� ���������� ������� ������
    SysAllocStringLen(self.FResultBuffer, Task2_DefaultBufferSize);

    self.Task2_FindInFilesByPattern(WideString(tmpTask2_Parameters.inputParam1), WideString(tmpTask2_Parameters.inputParam2),
                                    WideString(tmpTask2_Parameters.inputParam3), tmpTask2_Parameters.inputParam4,
                                    FTaskMainModuleIndex {Task1_Parameters.inputParam4}, self.FTask2_Results); //, nil, 0);

   end;

 end;
finally

end;
 end;

//------------------------------------------------------------------------------
function TTaskSource.Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; out outTask1_Result: TTask1_Result): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
var
  inputParam5, iProcedureWorkTime: DWORD;
  tmpTargetFile: WideString;
  tmpStreamWriter: TStreamWriter;
  tmpMemoryStream: TOLEStream;
  tmpMaskItems: TArray_WideString;
  tmpMaskCount: word;
  tmpWord: word;
  tmpBool: Boolean;
  tmpPAnsiChar: PAnsiChar;
  tmpWideString: WideString;

begin
try
 CriticalSection.Leave; //--- ���� � ����������� ������ ��� �� ������ ���� � �������� �����������

// iProcedureWorkTime:= GetTickCount(); // ���������� �������� ����� � ������ ������������

//--- ���� ������ ����� ������ � ����, �� �������� ������������ ����� ��������� �����
//--- ������� � ����� ��������� ����� ���������� � ������ ������ �� ������� ������� ������� � ������� ������, ����� ����� ������ � ������� ��������
       if TPath.GetFileName(inputParam3) <> '' then
        tmpWideString:= TPath.GetFileNameWithoutExtension(inputParam3) + format('_%d', [self.FTaskMainModuleIndex]) + TPath.GetExtension(inputParam3)
       else
        tmpWideString:= TPath.GetFileNameWithoutExtension(wsTask1_ResultFileNameByDefault) + format('_%d', [self.FTaskMainModuleIndex]) + TPath.GetExtension(wsTask1_ResultFileNameByDefault);
//--- ...������������ ����� �������� ����������
       if TPath.GetDirectoryName(inputParam3) <> '' then
        tmpWideString:= TPath.GetDirectoryName(inputParam3) + '\' + tmpWideString
       else
        tmpWideString:= TDirectory.GetCurrentDirectory() + '\' + tmpWideString;

        if inputParam4 then //--- ������ ���������� � ����
         tmpStreamWriter:= TFile.CreateText(tmpWideString)
        else //--- ������ ���������� � ������
        begin
//         tmpMemoryStream:= TOLEStream.Create();
//         tmpMemoryStream.set:= self.FResultBuffer;
//         tmpMemoryStream.SetSize(sizeof(self.FResultBuffer));
        end;

//--- ���������� ���������-����� �� �������� ������ (inputParam1)
   GetItemsFromString(inputParam1, tmpMaskItems, tmpMaskCount);
//--- ���� �������� � ��������� � ������� ���� ������ � ������� ����������
   outTask1_Result.dwEqualsCount:= 0; //--- ������� ����������

       for tmpTargetFile in TDirectory.GetFiles(inputParam2, wsAllMask,
            TSearchOption.soAllDirectories) do
        begin
//          sleep(500); //--- ��� ��������� (��� ���������� ��������)
         tmpBool:= false;
         for tmpWord:= 0 to tmpMaskCount do
         begin
          if (TPath.GetExtension(tmpTargetFile) = tmpMaskItems[tmpWord]) and (not tmpBool) then
          begin
           inc(outTask1_Result.dwEqualsCount);
           tmpBool:= true;
           if tmpBool then
           begin
            if inputParam4 then
              tmpStreamWriter.WriteLine(tmpTargetFile + ', ')
            else //--- ��������� ����� ������
            //--- ��������� ������ ��� �������� ����������
//             tmpMemoryStream.Memory;
            begin

            end;
           { if (GetTickCount() - iProcedureWorkTime) >=  inputParam5 then
             begin
              tmpStreamWriter.Flush;
              iProcedureWorkTime:= GetTickCount(); // ���������� ������� �������� �����
             end;}
           end;
          end;
         end;
        end;

       tmpPAnsiChar:= '����� ������� ����������: ';
       tmpStreamWriter.WriteLine(tmpPAnsiChar + IntToStr(outTask1_Result.dwEqualsCount));
       tmpStreamWriter.Close;








finally
 if Win32Check(Assigned(tmpStreamWriter)) then
    freeandnil(tmpStreamWriter); //    tmpStreamWriter.Free;

end;
end;

//------------------------------------------------------------------------------
//------------------------- ������ �2 ------------------------------------------
//------------------------------------------------------------------------------
function TTaskSource.Task2_FindInFilesByPattern (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; var inoutTask2_Results: TTask2_Results): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
var
  tmpWideString: WideString;
  tmpStreamWriter: TStreamWriter;
  tmpPatternList: array of TSearchPattern;
  tmpPatternItemsStr: TArray_WideString;
  tmpPatternItems: RawByteString;
  tmpPatternCount, tmpWord, tmpWord1, tmpWord2: word;
  tmpSearchPatternSet: array of TSearchPatternSet;

//--- ������ ������ �2 - TaskSource.Task2_FindInFilesByPattern ------------------------------------
begin
try
//  inputParam1:= 'resource;ozX'; //'resource'; //������
//  inputParam2:= 'D:\Install\FFscriptCache.bin'; // ������� ���� (� ������� �����)
//  inputParam3:= 'D:\Install\Result_Library1_Task2.txt'; //'D:\Install\ResultSearchByMask1.txt'; // ��� ����� ��� ������ ����������, ���� inputParam4 - true
//  inputParam4:= true;                                  // ����� ���� ������ ����������: 0 (false) - ����� ������ (��������� � outputResult, ������ � outputResultSize)


  case inputParam4 of
    true:  //--- �������: ������ ���������� � ����
     begin
//--- ���� ������ ����� ������ � ����, �� �������� ������������ ����� ��������� �����
//--- ������� � ����� ��������� ����� ���������� � ������ ������ �� ������� ������� ������� � ������� ������, ����� ����� ������ � ������� ��������
       if TPath.GetFileName(inputParam3) <> '' then
        tmpWideString:= TPath.GetFileNameWithoutExtension(inputParam3) + format('_%d', [self.FTaskMainModuleIndex]) + TPath.GetExtension(inputParam3)
       else
        tmpWideString:= TPath.GetFileNameWithoutExtension(wsTask2_ResultFileNameByDefault)
                                                         + format('_%d', [self.FTaskMainModuleIndex])
                                                         + TPath.GetExtension(wsTask2_ResultFileNameByDefault);
//--- ...������������ ����� �������� ����������
       if TPath.GetDirectoryName(inputParam3) <> '' then
        tmpWideString:= TPath.GetDirectoryName(inputParam3) + '\' + tmpWideString
       else
        tmpWideString:= TDirectory.GetCurrentDirectory() + '\' + tmpWideString;
//--- �������� ����� ���������� ������
        tmpStreamWriter:= TFile.CreateText(tmpWideString);

//--- ���������� ���������-�������� �� �������� ������ (inputParam1)
       GetPatternsFromString(inputParam1, tmpPatternItemsStr, tmpPatternCount);
//--- ���������� �������� �������� ������ �������� ������� ����������

//--- �������������� �������� �� WideString (������ �����������) � array of byte
       setlength(tmpSearchPatternSet, tmpPatternCount);
       setlength(inoutTask2_Results, tmpPatternCount);
//       setlength(inoutTaskSource.FTask2_Results, tmpPatternCount);

       for tmpWord:= 0 to tmpPatternCount - 1 do
       begin
        setlength(tmpSearchPatternSet[tmpWord].Pattern, length(tmpPatternItemsStr[tmpWord]));
        tmpSearchPatternSet[tmpWord].Pattern:= WSToByte(tmpPatternItemsStr[tmpWord]);
        tmpSearchPatternSet[tmpWord].PatternSize:= length(tmpSearchPatternSet[tmpWord].Pattern);
       end;

//--- ������������ ������ �������� � ������� �����
       CountPatternIncluding(inputParam2, tmpSearchPatternSet, tmpPatternCount, inoutTask2_Results, tmpStreamWriter);

       tmpStreamWriter.WriteLine('����� ������� ����������: ');
       for tmpWord:= 0 to tmpPatternCount - 1 do
       begin
        tmpSearchPatternSet[tmpWord].Pattern:= WSToByte(tmpPatternItemsStr[tmpWord]);
        tmpStreamWriter.WriteLine(format(wsTask2_TotalResult_TemplateView, [ByteToWS(inoutTask2_Results[tmpWord].SearchPattern, tmpSearchPatternSet[tmpWord].PatternSize),
                                                                              inoutTask2_Results[tmpWord].dwEqualsCount]));
       end;

       tmpStreamWriter.Close;

     end;

    false:   //--- ��������� ������ ��� �������� ����������
     begin

     end;
   end;

finally
 FreeAndNil(tmpStreamWriter);
end;

end;

//---------------- ������������ ��� ������� ------------------------------------





end.
