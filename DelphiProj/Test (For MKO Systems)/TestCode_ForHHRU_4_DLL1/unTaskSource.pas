unit unTaskSource;

interface
uses   Windows, ActiveX, Classes, IOUtils, SysUtils, System.SyncObjs, Dialogs, DateUtils;

//--- ��� ������ �1 ------------------------------------------------------------
const
  ItemDelemiter = ';';
  wsBeginMask: WideString = '*.';
  wsAllMask: WideString = '*';
  wsTask1_Name: WideString = '����� ������ �� �����';
  wsTask2_Name: WideString = '����� � ������ �� ��������';
  wsTask1_ResultFileNameByDefault: WideString = 'Lib1_Task1_Result.txt';
  wsTask2_ResultFileNameByDefault: WideString = 'Lib1_Task2_Result.txt';
  wsTask2_Result_TemplateView: WideString = '������: %12s, ������� � �����: %d';
  wsTask2_TotalResult_TemplateView: WideString = '������: %12s, ����� ����������: %d';
  wsResultStreamTitle: WideString = '���������� �%d, ������ �%d';
  wsCRLF = #13#10;

//--- ��� ������ �2 ------------------------------------------------------------
const
  iPatternNotFound = $FFFFFFFF;
  Task2_DefaultBufferSize = 4096;
type
//------------------- ��� ������ �2 --------------------------------------------

  TTargetFile = array of byte;
  TSearchPattern = array of byte;

  TSearchPatternSet = packed record
    LastPosBeginSearch: DWORD;
    Pattern: TSearchPattern;
    PatternSize: DWORD;
  end;

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//--- ������� ��������� ������ �1 (������ ������ � ���������� - 0)

  TTask1_Parameters = packed record
    inputParam1: PWideChar; //--- �����
    inputParam2: PWideChar; //--- ���������� ������ ������
    inputParam3: PWideChar; //--- ��� ����� ��� ������ ����������, ���� inputParam4 - true (�.�. ������ ���������� � ����)
    inputParam4: BOOL;       //--- ����� ���� ������ ����������: 0 (false) - ����� ������ (��������� � outputResult, ������ � outputResultSize)
    inputParam5: WORD;      //--- ����� (������) ������ � ������� � ������� ������ (������ � �������� �����������)
  end;

//------------------------------------------------------------------------------
//--- ������� ��������� ������ �2 (������ ������ � ���������� - 1)

  TTask2_Parameters = packed record
    inputParam1: PWideChar; //array of byte; //--- ������ ������
    inputParam2: PWideChar; //--- ���� ��� ������ ������������ �������� ������
    inputParam3: PWideChar; //--- ��� ����� ��� ������ ����������, ���� inputParam4 - true (�.�. ������ ���������� � ����)
    inputParam4: BOOL;       //--- ����� ���� ������ ����������: 0 (false) - ����� ������ (��������� � outputResult, ������ � outputResultSize)
    inputParam5: WORD;      //--- ����� (������) ������ � ������� � ������� ������ (������ � �������� �����������)
  end;

//------------------------------------------------------------------------------
//--- �������� ��������� �����: �1,�2 (������� ����� � ����������: 0, 1)

  TTask_Result = packed record
    dwEqualsCount: DWORD;
    SearchPattern: TSearchPattern;
  end;


//------------------------------------------------------------------------------
  TTask_Results = array of TTask_Result;
  TArray_WideString = array [0..High(Byte)] of WideString;
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------

  ILibraryLog = interface (IInterface)
  ['{417D26A0-0BA7-4F69-877C-0E80A224E8EA}']
    function GetStream: IStream; safecall;
    property Stream: IStream read GetStream;
  end;

//------------------------------------------------------------------------------
  TLibraryLog = class(TInterfacedObject, ILibraryLog)
  strict private
    FStringStream: TStringStream;
    FStream: IStream;
  strict protected
  public
    constructor Create();
    function GetStream: IStream; safecall;
    property StringStream: TStringStream read FStringStream;
    property Stream: IStream read GetStream;
  end;
//------------------------------------------------------------------------------


var
  CriticalSection: TCriticalSection;
  Task1_Parameters: TTask1_Parameters;
  Task2_Parameters: TTask2_Parameters;
  LibraryLog: TLibraryLog;



//--- ����������� ������� (���������� ����������� ����������)
//--- ������ �1 - ����� ������ �� �����/������
//function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; out outTask1_Result: TTask1_Result): HRESULT;

//--- ��������������� �������
procedure WriteDataToLog(E_source1, CurrentProcName, CurrentUnitName: WideString);
function GetWorkingDirectoryName(): WideString;
//--- ���������� ��������� ������, ���������� ��������-������������
procedure GetItemsFromString(inputSourceBSTR: WideString; var outputStringItems: TArray_WideString; var outputMaskCount: word);
function GetSubStr(inSourceString: WideString; inIndex:Byte; inCount:Integer): WideString;
function IndexInString(inSubStr, inSourceString: WideString; inPosBegin: word): word;
//--- ��� ������ �2 ------------
procedure GetPatternsFromString(inputSourceBSTR: WideString; var outputStringItems: TArray_WideString; var outputPatternCount: word);
function GetPosForPattern(inputBuffer: Pointer; inputFileSize: DWORD; inputSearchPatternSet: TSearchPatternSet; inputPosBeginSearch: DWORD): DWORD;
function WSToByte(inputWideString: WideString): TSearchPattern;
function ByteToWS(inputBytes: TSearchPattern; inputBytesSize: dword): WideString;



implementation


//------------------------------------------------------------------------------
//---------- ������ ��� TLibraryLog --------------------------------------
//------------------------------------------------------------------------------
constructor TLibraryLog.Create;
begin
try
 inherited Create();
 FStringStream:= TStringStream.Create('', TEncoding.ANSI);
 FStream:= TStreamAdapter.Create(FStringStream, soReference);

finally
end;
end;


function TLibraryLog.GetStream: IStream; safecall;
begin
try
  Result:= FStream;
finally
end;
end;


{
function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; inputTaskMainModuleIndex: WORD; out outTask1_Result: TTask1_Result): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
var
  inputParam5, iProcedureWorkTime: DWORD;
  tmpTargetFile: WideString;
  tmpStreamWriter: TStreamWriter;
  tmpMaskItems: TArray_WideString;
  tmpMaskCount: word;
  tmpInt, tmpInt1, tmpWord3: word;
  tmpBool: Boolean;
  tmpPAnsiChar: PAnsiChar;
  tmpPWideChar: PWideChar;
  tmpWideString: WideString;

begin
try
    CriticalSection.Leave; //--- ���� � ����������� ������ ��� �� ������ ���� � �������� �����������

//  inputParam1:= '*.txt;*.txt1'; //�����
//  inputParam2:= 'C:\Users\user\AppData\Roaming\Primer_MT_3'; //���������� ������ ������
//  inputParam3:= 'D:\Install\ResultSearchByMask.txt'; //��� ����� ��� ������ ����������, ���� inputParam4 - true
//  inputParam4:= true; //����� ���� ������ ����������: 0 (false) - ����� ������ (��������� � outputResult, ������ � outputResultSize)
//  inputParam5:= 1000; //������ ������ � ������

// iProcedureWorkTime:= GetTickCount(); // ���������� �������� ����� � ������ ������������
  case inputParam4 of
    true:  //--- �������: ������ ���������� � ����
     begin
//--- ���� ������ ����� ������ � ����, �� �������� ������������ ����� ��������� �����
//--- ������� � ����� ��������� ����� ���������� � ������ ������ �� ������� ������� ������� � ������� ������, ����� ����� ������ � ������� ��������
       if TPath.GetFileName(inputParam3) <> '' then
        tmpWideString:= TPath.GetFileNameWithoutExtension(inputParam3) + format('_%d', [inputParam5]) + TPath.GetExtension(inputParam3)
       else
        tmpWideString:= TPath.GetFileNameWithoutExtension(wsTask1_ResultFileNameByDefault) + format('_%d', [inputParam5]) + TPath.GetExtension(wsTask1_ResultFileNameByDefault);
//--- ...������������ ����� �������� ����������
       if TPath.GetDirectoryName(inputParam3) <> '' then
        tmpWideString:= TPath.GetDirectoryName(inputParam3) + '\' + tmpWideString
       else
        tmpWideString:= TDirectory.GetCurrentDirectory() + '\' + tmpWideString;

        tmpStreamWriter:= TFile.CreateText(tmpWideString);

//--- ���������� ���������-����� �� �������� ������ (inputParam1)
   GetItemsFromString(inputParam1, tmpMaskItems, tmpMaskCount);
//--- ���� �������� � ��������� � ������� ���� ������ � ������� ����������
   outTask1_Result.dwEqualsCount:= 0; //--- ������� ����������

       for tmpTargetFile in TDirectory.GetFiles(inputParam2, wsAllMask,
            TSearchOption.soAllDirectories) do
        begin
          sleep(500); //--- ��� ��������� (��� ���������� ��������)
         tmpBool:= false;
         for tmpInt:= 0 to tmpMaskCount do
         begin
          if (TPath.GetExtension(tmpTargetFile) = tmpMaskItems[tmpInt]) and (not tmpBool) then
          begin
           inc(outTask1_Result.dwEqualsCount);
           tmpBool:= true;
           if tmpBool then
           begin
            tmpStreamWriter.WriteLine(tmpTargetFile + ', ');
            if (GetTickCount() - iProcedureWorkTime) >=  inputParam5 then
             begin
              tmpStreamWriter.Flush;
              iProcedureWorkTime:= GetTickCount(); // ���������� ������� �������� �����
             end;
           end;
          end;
         end;
        end;

       tmpPAnsiChar:= '����� ������� ����������: ';
       tmpStreamWriter.WriteLine(tmpPAnsiChar + IntToStr(outTask1_Result.dwEqualsCount));
       tmpStreamWriter.Close;

     end;

    false:   //--- ��������� ������ ��� �������� ����������
     begin

     end;
   end;

finally
 if Win32Check(Assigned(tmpStreamWriter)) then
    freeandnil(tmpStreamWriter); //    tmpStreamWriter.Free;

end;
end;


procedure CountPatternIncluding(inputTargetFileName: WideString; inputParam4: boolean; var inputSearchPatternSet: array of TSearchPatternSet; inputPattenCount: DWORD; var inoutTask2_Results: TTask_Results; inputStreamWriter: TStreamWriter);
var
  tmpFileStream: TFileStream;
  tmpTargetFileBuffer: TTargetFile;
  tmpWord: word;
  tmpBool: boolean;
  tmpDword: DWORD;
//  tmpInt: integer;
//  tmpBaseStartPosForAllPatterns: DWORD;

begin
try
  //--- �������� ������ ��� �������� �����
  tmpFileStream:= TFileStream.Create(inputTargetFileName, fmOpenRead or fmShareDenyWrite);
  SetLength(tmpTargetFileBuffer, tmpFileStream.Size);
  tmpFileStream.ReadBuffer(Pointer(tmpTargetFileBuffer)^, Length(tmpTargetFileBuffer));
  tmpFileStream.Position:= 0;

//--- ��������� ������� - ����� � ������ �����
//--- ���������� ���� "������" � ���������� ���������� ������
   for tmpWord:= 0 to inputPattenCount - 1 do //sizeof(inputSearchPatternSet) do
   begin
    inputSearchPatternSet[tmpWord].LastPosBeginSearch:= 0;
    inoutTask2_Results[tmpWord].SearchPattern:= inputSearchPatternSet[tmpWord].Pattern;
   end;

//--- ����� � �����
       while (tmpFileStream.Position < tmpFileStream.Size) do
        begin
//------------------------------------------------------------------------------
//          sleep(500); //--- ��� ��������� (��� ���������� ��������)
//------------------------------------------------------------------------------

         tmpBool:= false;
         tmpDword:= 0;

//=== � ����� ���������� ��� ������� � ��������� ����� ������� (��� ������, ���� ����� ���������������)
         for tmpWord:= 0 to inputPattenCount - 1 do //sizeof(inputSearchPatternSet) do
         begin
//--- ��������: ����� �� ������� ������� ��� ������� �� ����� �����...
          if inputSearchPatternSet[tmpWord].LastPosBeginSearch < iPatternNotFound then
          begin
//--- ����, ���� �� ��� ����������� �������� LastPosBeginSearch < iPatternNotFound, ������ ���� ��� ������� ���������� �� �� ����� �����
           tmpBool:= true;
           tmpFileStream.Position:= inputSearchPatternSet[tmpWord].LastPosBeginSearch;
           tmpDWord:= GetPosForPattern(Pointer(tmpTargetFileBuffer), tmpFileStream.Size,
                               inputSearchPatternSet[tmpWord], tmpFileStream.Position); //inputSearchPatternSet[tmpWord].LastPosBeginSearch);

           if (tmpDWord < iPatternNotFound) then
           begin
            inputSearchPatternSet[tmpWord].LastPosBeginSearch:= tmpDword + inputSearchPatternSet[tmpWord].PatternSize + 1; //--- ��������� �������, � ������� ����� ��������� ����� �� ������� �������

//--- � tmpFileStream.Position ������ ���������� ������� ������ ������ ��� ��������
//--- ������ �� ���� ���������� � ��������� ����� ������ � ����� while
           if tmpFileStream.Position > inputSearchPatternSet[tmpWord].LastPosBeginSearch then
            tmpFileStream.Position:= inputSearchPatternSet[tmpWord].LastPosBeginSearch;
            inc(inoutTask2_Results[tmpWord].dwEqualsCount);
            CriticalSection.Enter;
            inputStreamWriter.WriteLine(format(wsTask2_Result_TemplateView, [ByteToWS(inputSearchPatternSet[tmpWord].Pattern, inputSearchPatternSet[tmpWord].PatternSize),
                                                                             inputSearchPatternSet[tmpWord].LastPosBeginSearch]));
            CriticalSection.Leave;

           end
           else
           begin
            inputSearchPatternSet[tmpWord].LastPosBeginSearch:= iPatternNotFound;
           end;
          end;
         end;

//--- ���� ��� ������� ��������� �� ����� �����, �� ������ �� ����� ����� � ����� ������� �� whilr
         if not tmpBool then
          tmpFileStream.Position:= tmpFileStream.Size;

        end;

finally
 FreeAndNil(tmpFileStream);
end;
end;



}
procedure GetItemsFromString(inputSourceBSTR: WideString; var outputStringItems: TArray_WideString; var outputMaskCount: word);
begin
 outputMaskCount:= 0;
 if pos(wsBeginMask, inputSourceBSTR, 1) > 0 then
 begin
  while pos(wsBeginMask, inputSourceBSTR, 1) > 0 do
   begin
//--- �������� �� ���������� ������ �����, ���� ���, �� �������� �� ��� �� ������ ����� ����������
    if pos(wsBeginMask, inputSourceBSTR, 1) > 0 then
      delete(inputSourceBSTR, 1, length(GetSubStr(inputSourceBSTR, 1, pos(wsBeginMask, inputSourceBSTR)))); //--- ������ ��, ��� �� '*.' - ���� ������ ����������

    if pos(ItemDelemiter, inputSourceBSTR, 1) > 0 then
      outputStringItems[outputMaskCount]:= Copy(inputSourceBSTR, 1, pos(ItemDelemiter, inputSourceBSTR, 1) - 1)
    else // �������� ��������� ����� � ��� ������������ ����������� (�� �� � �� ������!)
      outputStringItems[outputMaskCount]:= Copy(inputSourceBSTR, 1, length(inputSourceBSTR));

    delete(inputSourceBSTR, 1, Length(outputStringItems[outputMaskCount]) + 1); //--- ������ ��������� ������ � �����������
    inc(outputMaskCount);
   end;
 end;
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

//------------------------------------------------------------------------------------------------------------------------------------
//------------------------------ ��� ������ �2 ---------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------

function GetPosForPattern(inputBuffer: Pointer; inputFileSize: DWORD; inputSearchPatternSet: TSearchPatternSet; inputPosBeginSearch: DWORD): DWORD;
var
   LastStartComparePos, tmpPatternSize: DWORD;
begin
 Result:= $0FFFFFFFF; //iPatternNotFound;
 tmpPatternSize:= inputSearchPatternSet.PatternSize;
 if tmpPatternSize < 1 then
  exit;

asm
 mov esi, inputBuffer
 mov edx, esi
 add esi, inputPosBeginSearch
 dec esi
 mov LastStartComparePos, esi
 mov eax, inputFileSize
 sub eax, tmpPatternSize
 jb @@Exit_Failed
 add edx, eax //--- edx = MaxLastComparePos

@@BeginCompare:
 inc LastStartComparePos
 cmp edx, LastStartComparePos
 jb @@Exit_Failed

@@PrepareNextStep:
 mov esi, LastStartComparePos
 mov edi, inputSearchPatternSet.Pattern
 mov ecx, tmpPatternSize
@@CompareByte:
 mov al, byte ptr [edi]
 mov ah, byte ptr [esi]
 cmp al, ah
 jnz @@BeginCompare
 inc esi
 cmp edx, esi
 jb @@Exit_Failed
 inc edi
 dec ecx
 test ecx, ecx
 ja @@CompareByte
 mov eax, LastStartComparePos
 sub eax, inputBuffer
 jmp @@Exit
@@Exit_Failed:
 mov eax, 0FFFFFFFFh
@@Exit:
 mov Result, eax
end;

end;

function WSToByte(inputWideString: WideString): TSearchPattern;
var
  tmpPChar: PChar;
  tmpWord: word;
begin
  if length(inputWideString) = 0 then
    exit;

  setlength(Result, length(inputWideString));
  tmpPChar:= PChar(inputWideString);
 for tmpWord:= 0 to length(inputWideString) - 1 do
 begin
   Result[tmpWord]:= ord(tmpPChar[tmpWord]);
 end;
end;

function ByteToWS(inputBytes: TSearchPattern; inputBytesSize: dword): WideString;
var
  tmpWord: word;
  tmpStr: AnsiString;
begin
  Result:= '';
  if inputBytesSize < 1 then
  begin
   Result:= '';
   exit;
  end;

//  setlength(Result, inputBytesSize*sizeof(WideChar) + 1);
 setlength(Result, inputBytesSize*sizeof(WideChar) + 1);
 Result:='';

 for tmpWord:= 0 to (inputBytesSize - 1) do
 begin
   tmpStr:= AnsiChar(inputBytes[tmpWord]);
   Result:= Result + WideChar(tmpStr[1]);
 end;
// Result:= Result + #0;
end;

procedure GetPatternsFromString(inputSourceBSTR: WideString; var outputStringItems: TArray_WideString; var outputPatternCount: word);
var
  tmpWideString: WideString;
  tmpWord: word;
  tmpInt, tmpInt1: integer;
  tmpBool: Boolean;
begin
 outputPatternCount:= 0;
 if inputSourceBSTR = '' then
  exit;

  repeat
    if pos(ItemDelemiter, inputSourceBSTR, 1) > 0 then
      tmpWideString:= Copy(inputSourceBSTR, 1, pos(ItemDelemiter, inputSourceBSTR, 1) - 1)
    else // ������� ��������� ������ � ��� ������������ �����������
      tmpWideString:= Copy(inputSourceBSTR, 1, length(inputSourceBSTR));
    outputStringItems[outputPatternCount]:= tmpWideString; //--- ���� ��������� ����������
    tmpWord:= outputPatternCount;                          //--- ����� �������� �� ����������
                                                          //--- ��� �������� ����� ���� �������

//--- �������� �� ������� �������� �, ���� ���� - ������.
    tmpBool:= false;
    for tmpInt:= (outputPatternCount - 1) downto 0 do
    begin
      if outputStringItems[outputPatternCount] = outputStringItems[tmpInt] then
      begin
       tmpBool:= true;
       break;
      end;
    end;
//--- ������� ������� ������ �� �������� ������-���������
    delete(inputSourceBSTR, 1, Length(outputStringItems[outputPatternCount]) + 1); //--- ������ ��������� ������ � �����������
//--- ���� �� ���� ���������� � ����������� ���������, �� �������� ������� - ������� ������� ������ � ������
    if not tmpBool then
    begin
     inc(outputPatternCount);
    end;


  until length(inputSourceBSTR) = 0;

end;

//------------------------------------------------------------------------------
function GetWorkingDirectoryName(): WideString;
var
  tmpStr: string;
begin
 Result:= '';
 try
  tmpStr:= GetEnvironmentVariable('APPDATA') + '\' + Copy(ExtractFileName(GetModuleName(HInstance)), 1, Pos('.', ExtractFileName(GetModuleName(HInstance))) - 1);
  if not TDirectory.Exists(tmpStr) then
   TDirectory.CreateDirectory(tmpStr);
  Result:= tmpStr;
 except
  on E: Exception do
    Writeln(E.ClassName, ': ', E.Message);
 end;
end;

//------------------------------------------------------------------------------
procedure WriteDataToLog(E_source1, CurrentProcName, CurrentUnitName: WideString);
var
  tmpWideString: WideString;
  tmpCardinal: Cardinal;
begin
try
  tmpWideString:= '--------------- ���������� �1 -------------------------------'
                + #13#10
                + DatetimeToStr(today())
                + #13#10
                + '��������� ������������� � - ' + CurrentUnitName + '\' + CurrentProcName
                + #13#10
                + E_source1
                + #13#10
                + '-------------------------------------------------------------';
  LibraryLog.StringStream.WriteString(tmpWideString);

finally

end;
end;

end.
