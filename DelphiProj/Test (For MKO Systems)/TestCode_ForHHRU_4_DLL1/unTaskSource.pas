unit unTaskSource;

interface
uses   Windows, ActiveX, Classes, IOUtils, SysUtils, System.SyncObjs;

const
  ItemDelemiter = ';';
  wsBeginMask: WideString = '*.';
type
  TTask1_Parameters = packed record
    inputParam1: PWideChar; //--- �����
    inputParam2: PWideChar; //--- ���������� ������ ������
    inputParam3: PWideChar; //--- ��� ����� ��� ������ ����������, ���� inputParam4 - true (�.�. ������ ���������� � ����)
    inputParam4: BOOL;       //--- ����� ���� ������ ����������: 0 (false) - ����� ������ (��������� � outputResult, ������ � outputResultSize)
    inputParam5: WORD;      //--- TargetWorkTime - ��������, ���������� ������ �� ������� ��������� - �������!
  end;

  TArray_WideString = array [0..High(Byte)] of WideString;

var
  CriticalSection: TCriticalSection;
  Task1_Parameters: TTask1_Parameters;


//--- ����������� ������� (���������� ����������� ����������)
//--- ������ �1 - ����� ������ �� �����/������
function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; iTargetWorkTime: WORD): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;

//--- ��������������� �������
//--- ���������� ��������� ������, ���������� ��������-������������
procedure GetItemsFromString(inputSourceBSTR: WideString; var outputStringItems: TArray_WideString; var outputMaskCount: word);
function GetSubStr(inSourceString: WideString; inIndex:Byte; inCount:Integer): WideString;
function IndexInString(inSubStr, inSourceString: WideString; inPosBegin: word): word;




implementation

function Task1_FileFinderByMask (inputParam1, inputParam2, inputParam3: WideString; inputParam4: BOOL; iTargetWorkTime: WORD): HRESULT; //; out outputResult: Pointer; out outputResultSize: DWORD): HRESULT;
const
  wsAllMask: WideString = '*';
var
  inputParam5, iProcedureWorkTime: DWORD;
  tmpTargetFile: WideString;
  tmpStreamWriter: TStreamWriter;
  tmpMaskItems: TArray_WideString;
  tmpMaskCount: word;
  tmpEquealsCount: word;
  tmpInt, tmpInt1: word;
  tmpBool: Boolean;

//  inputParam1, inputParam2, inputParam3: WideString;
//  inputParam4: BOOL;

begin
try
    CriticalSection.Leave; //--- ���� � ����������� ������ ��� �� ������ ���� � �������� �����������

//  inputParam1:= '*.txt;*.txt1'; //�����
//  inputParam2:= 'C:\Users\user\AppData\Roaming\Primer_MT_3'; //���������� ������ ������
//  inputParam3:= 'D:\Install\ResultSearchByMask.txt'; //��� ����� ��� ������ ����������, ���� inputParam4 - true
//  inputParam4:= true; //����� ���� ������ ����������: 0 (false) - ����� ������ (��������� � outputResult, ������ � outputResultSize)
//  inputParam5:= 1000; //������ ������ � ������

// iProcedureWorkTime:= GetTickCount(); // ���������� �������� ����� � ������ ������������
//--- ���� ������ ����� ������ � ����, �� �������� ������������ ����� ��������� �����
  case inputParam4 of
    true:  //--- �������: ������ ���������� � ����
     begin
//--- ���������� ���� � ��������� ����������� ��� ������ ����������
       if TPath.GetFileName(inputParam3) <> '' then
        begin
         if TPath.GetDirectoryName(inputParam3) <> '' then
           tmpStreamWriter:= TFile.CreateText(inputParam3)
         else
           tmpStreamWriter:= TFile.CreateText(TDirectory.GetCurrentDirectory());
        end
       else
         tmpStreamWriter:= TFile.CreateText(TDirectory.GetCurrentDirectory());

//--- ���������� ���������-����� �� �������� ������ (inputParam1)
   GetItemsFromString(inputParam1, tmpMaskItems, tmpMaskCount);
//--- ���� �������� � ��������� � ������� ���� ������ � ������� ����������
   tmpEquealsCount:= 0; //--- ������� ����������

       for tmpTargetFile in TDirectory.GetFiles(inputParam2, wsAllMask,
            TSearchOption.soAllDirectories) do
        begin
         tmpBool:= false;
         for tmpInt:= 0 to tmpMaskCount do
          if TPath.GetExtension(tmpTargetFile) = tmpMaskItems[tmpInt] then
          begin
           inc(tmpEquealsCount);
           tmpBool:= true;
           break;
          end;
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

       tmpStreamWriter.WriteLine('����� ������� ����������: ' + IntToStr(tmpEquealsCount));
       tmpStreamWriter.Close;

     end;

    false:   //--- ��������� ������ ��� �������� ����������
     begin

     end;
  end;

finally
 if Win32Check(Assigned(tmpStreamWriter)) then
    tmpStreamWriter.Free;

end;
end;

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


end.
