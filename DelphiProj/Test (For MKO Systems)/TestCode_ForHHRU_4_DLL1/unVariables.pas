unit unVariables;

interface
uses Windows, SysUtils, Classes, IOUtils, ActiveX, ComObj, Vcl.AxCtrls,
     System.Diagnostics, System.Contnrs, Dialogs, IniFiles, EncdDecd,
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
   function GetTask_Result: TTask_Result; safecall;
   function GetTask_ResultByIndex(ResultIndex: integer): TTask_Result; safecall;
   function GetTask_TotalResult: DWORD; safecall;
   function GetTask_ResultStream: IStream; safecall;
   procedure SetTaskMainModuleIndex(inputTaskMainModuleIndex: WORD);
   property TaskLibraryIndex: WORD read GetTaskLibraryIndex;
   property Task_Result: TTask_Result read GetTask_Result;
   property Task_Results[ResultIndex: integer]: TTask_Result read GetTask_ResultByIndex;
   property Task_TotalResult: DWORD read GetTask_TotalResult;
   property Task_ResultStream: IStream read GetTask_ResultStream;
   property TaskMainModuleIndex: WORD write SetTaskMainModuleIndex;
  end;

//------------------------------------------------------------------------------
  TTaskSource = class (TInterfacedObject, ITaskSource)
   private
    FTaskLibraryIndex: word;
    FTaskMainModuleIndex: word;
    FTaskSourceList: word;
    FTaskState: TTaskState;
    FTaskStringList: TStringList;
    FStringStream: TStringStream;
    FTaskMemoryStream: TMemoryStream;
    FTaskResultStream: IStream;
   protected
    FTask_Result: TTask_Result;
    procedure TaskProcedure(TaskLibraryIndex: word); safecall;
    function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; out outTask1_Result: TTask_Result): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
    function Task2_FindInFilesByPattern (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; var inoutTask2_Results: TTask_Results): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;

   public
    FTask_TotalResult: DWORD;
    FTask_Results: TTask_Results;
    constructor Create(TaskLibraryIndex: word);
    destructor Destroy(); overload;
    function GetTaskLibraryIndex: word;
    function GetTask_Result: TTask_Result; safecall;
    function GetTask_ResultByIndex(ResultIndex: integer): TTask_Result; safecall;
    function GetTask_TotalResult: DWORD; safecall;
    function GetTask_ResultStream: IStream; safecall;
    procedure SetTaskMainModuleIndex(inputTaskMainModuleIndex: WORD);
    property TaskLibraryIndex: WORD read FTaskLibraryIndex;
    property TaskMainModuleIndex: WORD write FTaskMainModuleIndex;
    property TaskState: TTaskState read FTaskState write FTaskState;
    property Task_Result: TTask_Result read FTask_Result write FTask_Result;
    property Task_Results[ResultIndex: integer]: TTask_Result read GetTask_ResultByIndex; // write SetTask2_Result;
    property Task_TotalResult: DWORD read GetTask_TotalResult;
    property Task_ResultStream: IStream read GetTask_ResultStream;
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
  bDllInitExecuted: boolean = false;


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
var
  tmpString: AnsiString;
  tmpStringStream: TStringStream;
  tmpUTF8String: UTF8String;

begin
 inherited Create();
   FTaskLibraryIndex:= TaskLibraryIndex;
//--- �������� ������ ��� ������ ������������ � ������� �������
//--- ������ � ����� "��������� ������" (������������, �����)
  tmpString:= wsResultStreamTitle + inttostr(TaskLibraryIndex) + wsCRLF;
  FStringStream:= TStringStream.Create(tmpString, TEncoding.ANSI);
  FTaskResultStream:= TStreamAdapter.Create(FStringStream, soReference);

//--- ���������� ���������� ������� ������ � ������ �����
//   FTaskSourceList:= TaskSourceList.Add(self);

end;

//------------------------------------------------------------------------------
destructor TTaskSource.Destroy();
begin
  FreeAndNil(FTaskMemoryStream);
  FreeAndNil(FTaskResultStream);
 inherited Destroy();
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
function TTaskSource.GetTask_Result: TTask_Result; safecall;
begin
  Result:= FTask_Result;
end;

//------------------------------------------------------------------------------

function TTaskSource.GetTask_ResultByIndex(ResultIndex: integer): TTask_Result; safecall;
begin
//  if sizeof(FTask2_Results) > ResultIndex then
  Result:= FTask_Results[ResultIndex];
end;

//------------------------------------------------------------------------------

function TTaskSource.GetTask_TotalResult: DWORD; safecall;
var
  tmpWord: word;
begin
  Result:= 0;
//--- ��������� ���������� �� ���� �������� � ����� ���������
  if length(FTask_Results) > 0 then
  begin
   FTask_TotalResult:= 0;
   for tmpWord:= 0 to (length(FTask_Results) - 1) do
     FTask_TotalResult:= FTask_TotalResult + FTask_Results[tmpWord].dwEqualsCount;
   Result:= FTask_TotalResult;
  end;
end;

//------------------------------------------------------------------------------

function TTaskSource.GetTask_ResultStream: IStream; safecall;
begin
try
finally
  Result:= FTaskResultStream;
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
    CriticalSection.Enter;

    tmpInputForm_Task1:= TformEditParams_Task1.Create(nil);
    tmpInputForm_Task1.ShowModal;
//    FreeAndNil(tmpInputForm_Task1);
    tmpInputForm_Task1.Free;

    //--- �������� inputParam5 (TaskMainModuleIndex), ���������� ����� API
    Task1_Parameters.inputParam5:= self.FTaskMainModuleIndex;
//--- ����� ��������� ������� ���������� ������ ������ �� ����������
    tmpTask1_Parameters.inputParam1:= Task1_Parameters.inputParam1;
    tmpTask1_Parameters.inputParam2:= Task1_Parameters.inputParam2;
    tmpTask1_Parameters.inputParam3:= Task1_Parameters.inputParam3;
    tmpTask1_Parameters.inputParam4:= Task1_Parameters.inputParam4;
    tmpTask1_Parameters.inputParam5:= Task1_Parameters.inputParam5;
    CriticalSection.Leave;

    self.Task1_FileFinderByMask(WideString(tmpTask1_Parameters.inputParam1), WideString(tmpTask1_Parameters.inputParam2),
                                WideString(tmpTask1_Parameters.inputParam3), tmpTask1_Parameters.inputParam4,
                                FTaskMainModuleIndex, self.FTask_Result);
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

    self.FTask_TotalResult:= 0;
    tmpTask2_Parameters.inputParam1:= Task2_Parameters.inputParam1;
    tmpTask2_Parameters.inputParam2:= Task2_Parameters.inputParam2;
    tmpTask2_Parameters.inputParam3:= Task2_Parameters.inputParam3;
    tmpTask2_Parameters.inputParam4:= Task2_Parameters.inputParam4;
    tmpTask2_Parameters.inputParam5:= Task2_Parameters.inputParam5;
    CriticalSection.Leave;

    self.Task2_FindInFilesByPattern(WideString(tmpTask2_Parameters.inputParam1), WideString(tmpTask2_Parameters.inputParam2),
                                    WideString(tmpTask2_Parameters.inputParam3), tmpTask2_Parameters.inputParam4,
                                    FTaskMainModuleIndex {Task1_Parameters.inputParam4}, self.FTask_Results); //, nil, 0);

   end;

 end;
finally

end;
 end;

//------------------------------------------------------------------------------
function TTaskSource.Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; out outTask1_Result: TTask_Result): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
var
  inputParam5, iProcedureWorkTime: DWORD;
  tmpTargetFile: WideString;
  tmpStreamWriter: TStreamWriter;
  tmpMemoryStream: TOLEStream;
  tmpStringStream: TStringStream;
  tmpMaskItems: TArray_WideString;
  tmpMaskCount: word;
  tmpWord: word;
  tmpBool: Boolean;
  tmpPAnsiChar: PAnsiChar;
  tmpWideString: WideString;
  tmpUTF8String: UTF8String;

begin
try
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
// �������� �������������� ������ ��� �������������� ��������� ���������� � ����� TStream
         tmpStringStream:= TStringStream.Create('', TEncoding.ANSI);
//         self.FTaskStringList.Clear;
//         self.FTaskMemoryStream.Clear;
//         self.FTaskMemoryStream.Position:= 0;
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
            begin
             tmpWideString:= tmpTargetFile + ', ' + wsCRLF;
             FStringStream.WriteString(tmpWideString);
            end;

           end;
          end;
         end;
        end;

       tmpWideString:= '����� ������� ����������: ' + IntToStr(outTask1_Result.dwEqualsCount);
       if inputParam4 then
        tmpStreamWriter.WriteLine(tmpWideString)
       else //--- ��������� ����� ������
       begin
        tmpWideString:= tmpWideString + ', ' + wsCRLF;
        FStringStream.WriteString(tmpWideString);
       end;



finally
// if Win32Check(Assigned(tmpStreamWriter)) then
// begin
//  tmpStreamWriter.Close;
//  freeandnil(tmpStreamWriter); //    tmpStreamWriter.Free;
// end;
//freeandnil(tmpStringStream);
end;
end;

//------------------------------------------------------------------------------
//------------------------- ������ �2 ------------------------------------------
//------------------------------------------------------------------------------
function TTaskSource.Task2_FindInFilesByPattern (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; var inoutTask2_Results: TTask_Results): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
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
        if inputParam4 then //--- ������ ���������� � ����
          tmpStreamWriter:= TFile.CreateText(tmpWideString)
        else //--- ������ ���������� � ������ � ������� � ������� ������
          tmpStreamWriter:= TStreamWriter.Create(self.FTaskMemoryStream);


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
